# [A beginner’s guide to transaction isolation levels in enterprise Java](https://vladmihalcea.com/a-beginners-guide-to-transaction-isolation-levels-in-enterprise-java/)

- [A beginner’s guide to transaction isolation levels in enterprise Java](#a-beginners-guide-to-transaction-isolation-levels-in-enterprise-java)
  - [Introduction](#introduction)
  - [Isolation and consistency](#isolation-and-consistency)
  - [Isolation levels](#isolation-levels)
  - [Database and isolation levels](#database-and-isolation-levels)
  - [DataSource isolation level](#datasource-isolation-level)
  - [Hibernate isolation level](#hibernate-isolation-level)
  - [Driver Manager Connection Provider](#driver-manager-connection-provider)
    - [Driver Manager Connection Provider](#driver-manager-connection-provider-1)
    - [C3P0 Connection Provider](#c3p0-connection-provider)
  - [DataSource Connection Provider](#datasource-connection-provider)
  - [Java Enterprise transaction isolation support](#java-enterprise-transaction-isolation-support)
    - [Java Enterprise Edition](#java-enterprise-edition)
    - [Spring](#spring)
    - [Spring transaction-scoped isolation levels](#spring-transaction-scoped-isolation-levels)
      - [JPA transaction manager](#jpa-transaction-manager)
      - [JTA transaction manager](#jta-transaction-manager)
  - [Conclusion](#conclusion)

## Introduction

A relational database strong consistency model is based on [ACID transaction properties](https://vladmihalcea.com/a-beginners-guide-to-acid-and-database-transactions/). In this post we are going to unravel the reasons behind using different transaction isolation levels and various configuration patterns for both [resource local](http://en.wikibooks.org/wiki/Java_Persistence/Transactions#Resource_Local_Transactions) and [JTA](http://en.wikipedia.org/wiki/Java_Transaction_API) transactions.

## Isolation and consistency

In a relational database system, atomicity and durability are strict properties, while consistency and isolation are more or less configurable. We cannot even separate consistency from isolation as these two properties are always related.

The lower the isolation level, the less consistent the system will get. From the least to the most consistent, there are four isolation levels:

- READ UNCOMMITTED
- READ COMMITTED (protecting against dirty reads)
- REPEATABLE READ (protecting against dirty and non-repeatable reads)
- SERIALIZABLE (protecting against dirty, non-repeatable reads and phantom reads)

Although the most consistent SERIALIZABLE isolation level would be the safest choice, most databases default to READ COMMITTED instead. According to [Amdahl's law](http://en.wikipedia.org/wiki/Amdahl%27s_law), to accommodate more concurrent transactions, we have to reduce the serial fraction of our data processing. The shorter the lock acquisition interval, the more requests a database can process.

## Isolation levels

As we previously demonstrated, [application level repeatable reads](https://vladmihalcea.com/hibernate-application-level-repeatable-reads/) paired with an optimistic locking mechanism are very convenient for [preventing lost updates in long conversations](https://vladmihalcea.com/preventing-lost-updates-in-long-conversations/).

In a highly concurrent environment, optimistic locking might lead to a high transaction failure rate. Pessimistic locking, like any other [queuing mechanism](https://vladmihalcea.com/the-simple-scalability-equation/) might accommodate more transactions when giving a sufficient lock acquisition time interval.

## Database and isolation levels

Apart from MySQL (which uses REPEATABLE_READ), the default isolation level of most relational database systems is READ_COMMITTED. All databases allow you to set the default transaction isolation level.

Typically, the database is shared among multiple applications and each one has its own specific transaction requirements. For most transactions, the READ_COMMITTED isolation level is the best choice and we should only override it for specific business cases.

This strategy proves to be the very efficient, allowing us to have stricter isolation levels for just a subset of all SQL transactions.

## DataSource isolation level

The [JDBC Connection](http://docs.oracle.com/javase/7/docs/api/java/sql/Connection.html) object allows us to set the isolation level for all transactions issued on that specific connection. Establishing a new database connection is a resource consuming process, so most applications use a [connection pooling](https://vladmihalcea.com/the-anatomy-of-connection-pooling/) [DataSource](http://docs.oracle.com/javase/7/docs/api/javax/activation/DataSource.html). The connection pooling DataSource can also set the default transaction isolation level:

- [DBCP](http://commons.apache.org/proper/commons-dbcp/api-1.4/org/apache/commons/dbcp/BasicDataSource.html#setDefaultTransactionIsolation%28int%29)
- [DBCP2](http://commons.apache.org/proper/commons-dbcp/api-2.0.1/org/apache/commons/dbcp2/BasicDataSource.html#setDefaultTransactionIsolation%28int%29)
- [HikariCP](https://github.com/brettwooldridge/HikariCP/blob/master/src/main/java/com/zaxxer/hikari/HikariConfig.java)
- [Bitronix Transaction Manager](https://github.com/bitronix/btm/blob/master/btm/src/main/java/bitronix/tm/resource/jdbc/PoolingDataSource.java)

Compared to the global database isolation level setting, the DataSource level transaction isolation configurations are more convenient. Each application may set its own specific concurrency control level.

We can even define multiple DataSources, each one with a pre-defined isolation level. This way we can dynamically choose a specific isolation level JDBC Connection.

## Hibernate isolation level

Because it has to support both **resource local** and **JTA** transactions, Hibernate offers a very flexible connection provider mechanism.

JTA transactions require an [XAConnection](https://docs.oracle.com/javase/7/docs/api/javax/sql/XAConnection.html) and it's the [JTA transaction manager](https://github.com/bitronix/btm/wiki/Transaction-manager-configuration) responsibility to provide XA compliant connections.

Resource local transactions can use a resource local [DataSource](http://docs.oracle.com/javase/7/docs/api/javax/sql/DataSource.html) and for this scenario, Hibernate offers multiple connection provider options:

- Driver Manager Connection Provider (doesn't pool connections and therefore it's only meant for simple testing scenarios)

- C3P0 Connection Provider (delegating connection acquiring calls to an internal C3P0 connection pooling DataSource)

- DataSource Connection Provider (delegating connection acquiring calls to an external DataSource.

Hibernate offers a transaction isolation level configuration called `hibernate.connection.isolation`, so we are going to check how all the aforementioned connection providers behave when being given this particular setting.

For this we are going to:

Create a SessionFactory

    @Override
    protected SessionFactory newSessionFactory() {
        Properties properties = getProperties();
    
        return new Configuration()
            .addProperties(properties)
            .addAnnotatedClass(SecurityId.class)
            .buildSessionFactory(
                new StandardServiceRegistryBuilder()
                    .applySettings(properties)
                    .build()
        );
    }

Open a new Session and test the associated connection transaction isolation level

    @Test
    public void test() {
        Session session = null;
        Transaction txn = null;
        try {
            session = getSessionFactory().openSession();
            txn = session.beginTransaction();
            session.doWork(new Work() {
                @Override
                public void execute(Connection connection) throws SQLException {
                    LOGGER.debug("Transaction isolation level is {}", Environment.isolationLevelToString(connection.getTransactionIsolation()));
                }
            });
            txn.commit();
        } catch (RuntimeException e) {
            if ( txn != null && txn.isActive() ) txn.rollback();
            throw e;
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

The only thing that differs is the connection provider configuration.

## Driver Manager Connection Provider

### Driver Manager Connection Provider

The Driver Manager Connection Provider offers a rudimentary DataSource wrapper for the configured database driver. You should only use it for test scenarios since it doesn’t offer a professional connection pooling mechanism.

    @Override
    protected Properties getProperties() {
        Properties properties = new Properties();
            properties.put("hibernate.dialect", "org.hibernate.dialect.HSQLDialect");
            //driver settings
            properties.put("hibernate.connection.driver_class", "org.hsqldb.jdbcDriver");
            properties.put("hibernate.connection.url", "jdbc:hsqldb:mem:test");
            properties.put("hibernate.connection.username", "sa");
            properties.put("hibernate.connection.password", "");
            //isolation level
            properties.setProperty("hibernate.connection.isolation", String.valueOf(Connection.TRANSACTION_SERIALIZABLE));
        return properties;
    }

The test generates the following output:

    WARN  [main]: o.h.e.j.c.i.DriverManagerConnectionProviderImpl - HHH000402: Using Hibernate built-in connection pool (not for production use!)
    DEBUG [main]: c.v.h.m.l.t.TransactionIsolationDriverConnectionProviderTest - Transaction isolation level is SERIALIZABLE

The Hibernate Session associated JDBC Connection is using the SERIALIZABLE transaction isolation level, so the hibernate.connection.isolation configuration works for this specific connection provider.

### C3P0 Connection Provider

Hibernate also offers a built-in C3P0 Connection Provider. Like in the previous example, we only need to provide the driver configuration settings and Hibernate instantiate the C3P0 connection pool on our behalf.

    @Override
    protected Properties getProperties() {
        Properties properties = new Properties();
            properties.put("hibernate.dialect", "org.hibernate.dialect.HSQLDialect");
            //log settings
            properties.put("hibernate.hbm2ddl.auto", "update");
            properties.put("hibernate.show_sql", "true");
            //driver settings
            properties.put("hibernate.connection.driver_class", "org.hsqldb.jdbcDriver");
            properties.put("hibernate.connection.url", "jdbc:hsqldb:mem:test");
            properties.put("hibernate.connection.username", "sa");
            properties.put("hibernate.connection.password", "");
            //c3p0 settings
            properties.put("hibernate.c3p0.min_size", 1);
            properties.put("hibernate.c3p0.max_size", 5);
            //isolation level
            properties.setProperty("hibernate.connection.isolation", String.valueOf(Connection.TRANSACTION_SERIALIZABLE));
        return properties;
    }

The test generates the following output:

    Dec 19, 2014 11:02:56 PM com.mchange.v2.log.MLog <clinit>
    INFO: MLog clients using java 1.4+ standard logging.
    Dec 19, 2014 11:02:56 PM com.mchange.v2.c3p0.C3P0Registry banner
    INFO: Initializing c3p0-0.9.2.1 [built 20-March-2013 10:47:27 +0000; debug? true; trace: 10]
    DEBUG [main]: c.v.h.m.l.t.TransactionIsolationInternalC3P0ConnectionProviderTest - Transaction isolation level is SERIALIZABLE

So, the hibernate.connection.isolation configuration works for the internal C3P0 connection provider too.

## DataSource Connection Provider

Hibernate doesn’t force you to use a specific connection provider mechanism. You can simply supply a DataSource and Hibernate will use it whenever a new Connection is being requested. This time we’ll create a full-blown DataSource object and pass it through the hibernate.connection.datasource configuration.

    @Override
    protected Properties getProperties() {
        Properties properties = new Properties();
            properties.put("hibernate.dialect", "org.hibernate.dialect.HSQLDialect");
            //log settings
            properties.put("hibernate.hbm2ddl.auto", "update");
            //data source settings
            properties.put("hibernate.connection.datasource", newDataSource());
            //isolation level
            properties.setProperty("hibernate.connection.isolation", String.valueOf(Connection.TRANSACTION_SERIALIZABLE));
        return properties;
    }
    
    protected ProxyDataSource newDataSource() {
            JDBCDataSource actualDataSource = new JDBCDataSource();
            actualDataSource.setUrl("jdbc:hsqldb:mem:test");
            actualDataSource.setUser("sa");
            actualDataSource.setPassword("");
            ProxyDataSource proxyDataSource = new ProxyDataSource();
            proxyDataSource.setDataSource(actualDataSource);
            proxyDataSource.setListener(new SLF4JQueryLoggingListener());
            return proxyDataSource;
    }   

The test generates the following output:

    DEBUG [main]: c.v.h.m.l.t.TransactionIsolationExternalDataSourceConnectionProviderTest - Transaction isolation level is READ_COMMITTED

This time, the hibernate.connection.isolation doesn't seem to be taken into consideration. Hibernate doesn't override external DataSources, so this setting is useless in this scenario.

If you are using an external DataSource (e.g. maybe through JNDI), then you need to set the transaction isolation at the external DataSource level.

To fix our previous example, we just have to configure the external DataSource to use a specific isolation level:

    protected ProxyDataSource newDataSource() {
        JDBCDataSource actualDataSource = new JDBCDataSource();
        actualDataSource.setUrl("jdbc:hsqldb:mem:test");
        actualDataSource.setUser("sa");
        actualDataSource.setPassword("");
        Properties properties = new Properties();
        properties.setProperty("hsqldb.tx_level", "SERIALIZABLE");
        actualDataSource.setProperties(properties);
        ProxyDataSource proxyDataSource = new ProxyDataSource();
        proxyDataSource.setDataSource(actualDataSource);
        proxyDataSource.setListener(new SLF4JQueryLoggingListener());
        return proxyDataSource;
    }

Generating the following output:

    DEBUG [main]: c.v.h.m.l.t.TransactionIsolationExternalDataSourceExternalconfgiurationConnectionProviderTest - Transaction isolation level is SERIALIZABLE

## Java Enterprise transaction isolation support

Hibernate has a built-in [Transaction API abstraction layer](http://docs.jboss.org/hibernate/orm/4.3/manual/en-US/html/ch13.html#transactions-demarcation-nonmanaged), isolating the data access layer from the transaction management topology (resource local or JTA). While we can develop an application using Hibernate transaction abstraction only, it's much more common to delegate this responsibility to a middle-ware technology (Java EE or Spring).

### Java Enterprise Edition

[JTA (Java Transaction API specification)](https://jcp.org/en/jsr/detail?id=907) defines how transactions should be managed by a Java EE compliant application server. On the client side, we can demarcate the transaction boundaries using the [TransactionAttribute](http://docs.oracle.com/javaee/7/api/javax/ejb/TransactionAttribute.html) annotation. While we have the option of choosing the right transaction propagation setting, we cannot do the same for the isolation level.

JTA doesn't support **transaction-scoped isolation levels** and so we have to resort to vendor-specific configurations for providing an XA DataSource with a specific transaction isolation setting.

### Spring

Spring @Transactional annotation is used for defining a transaction boundary. As opposed to Java EE, this annotation allows us to configure:

- isolation level
- exception types rollback policy
- propagation
- read-only
- timeout

As I will demonstrate later in this article, the isolation level setting is readily available for resource local transactions only. Because JTA doesn't support transaction-scoped isolation levels, Spring offers the [IsolationLevelDataSourceRouter](http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/jdbc/datasource/lookup/IsolationLevelDataSourceRouter.html) to overcome this shortcoming when using application server JTA DataSources.

Because most DataSource implementations can only take a default transaction isolation level, we can have multiple such DataSources, each one serving connections for a specific transaction isolation level.

The logical transaction (e.g. [@Transactional](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/transaction/annotation/Transactional.html#isolation--)) isolation level setting is introspected by the IsolationLevelDataSourceRouter and the connection acquire request is therefore delegated to a specific DataSource implementation that can serve a JDBC Connection with the same transaction isolation level setting.

So, even in JTA environments, the transaction isolation router can offer a vendor-independent solution for overriding the default database isolation level on a per transaction basis.

### Spring transaction-scoped isolation levels

Next, I'm going to test the Spring transaction management support for both resource local and JTA transactions.

For this, I'll introduce a transactional business logic Service Bean:

    @Service
    public class StoreServiceImpl implements StoreService {
    
        protected final Logger LOGGER = LoggerFactory.getLogger(getClass());
    
        @PersistenceContext(unitName = "persistenceUnit")
        private EntityManager entityManager;
    
        @Override
        @Transactional(isolation = Isolation.SERIALIZABLE)
        public void purchase(Long productId) {       
            Session session = (Session) entityManager.getDelegate();
            session.doWork(new Work() {
                @Override
                public void execute(Connection connection) throws SQLException {
                    LOGGER.debug("Transaction isolation level is {}", Environment.isolationLevelToString(connection.getTransactionIsolation()));
                }
            });
        }
    }

The Spring framework offers a transaction management abstraction that decouples the application logic code from the underlying transaction specific configurations. The [Spring transaction manager](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/transaction/support/AbstractPlatformTransactionManager.html) is only a facade to the actual resource local or JTA transaction managers.

Migrating from resource local to XA transactions is just a configuration detail, leaving the actual business logic code untouched. This wouldn't be possible without the extra transaction management abstraction layer and the cross-cutting [AOP support](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/aop.html).

Next, we are going to test how various specific transaction managers support transaction-scope isolation level overriding.

#### JPA transaction manager

First, we are going to test the JPA Transaction Manager:

    <bean id="transactionManager" class="org.springframework.orm.jpa.JpaTransactionManager">
        <property name="entityManagerFactory" ref="entityManagerFactory" />
    </bean>

When calling our business logic service, this is what we get:

    DEBUG [main]: c.v.s.i.StoreServiceImpl - Transaction isolation level is SERIALIZABLE

The JPA transaction manager can take one DataSource only, so it can only issue resource local transactions. In such scenarios, Spring transaction manager is able to override the default DataSource isolation level (which is READ COMMITTED in our case).

#### JTA transaction manager

Now, let’s see what happens when we switch to JTA transactions. As I previously stated, Spring only offers a logical transaction manager, which means we also have to provide a physical JTA transaction manager.

Traditionally, it was the enterprise application server (e.g. [Wildfly](http://www.wildfly.org/), [WebLogic](http://www.oracle.com/technetwork/middleware/weblogic/overview/index-085209.html)) responsibility to provide a JTA compliant transaction manager. Nowadays, there is also a great variety of stand-alone JTA transaction managers:

- [Bitronix](https://github.com/bitronix/btm)
- [Atomikos](http://www.atomikos.com/)
- [RedHat Narayana](http://narayana.io/)

In this test, we are going to use Bitronix:

    <bean id="jtaTransactionManager" factory-method="getTransactionManager"
        class="bitronix.tm.TransactionManagerServices" depends-on="btmConfig, dataSource"
        destroy-method="shutdown"/>
    
    <bean id="transactionManager" class="org.springframework.transaction.jta.JtaTransactionManager">
        <property name="transactionManager" ref="jtaTransactionManager"/>
        <property name="userTransaction" ref="jtaTransactionManager"/>
    </bean>

When running the previous test, we get the following exception:

    org.springframework.transaction.InvalidIsolationLevelException: JtaTransactionManager does not support custom isolation levels by default - switch 'allowCustomIsolationLevels' to 'true'

So, let’s enable the custom isolation level setting and rerun the test:

    <bean id="transactionManager" class="org.springframework.transaction.jta.JtaTransactionManager">
        <property name="transactionManager" ref="jtaTransactionManager"/>
        <property name="userTransaction" ref="jtaTransactionManager"/>
        <property name="allowCustomIsolationLevels" value="true"/>
    </bean>

The test gives us the following output:

    DEBUG [main]: c.v.s.i.StoreServiceImpl - Transaction isolation level is READ_COMMITTED

Even with this extra configuration, the transaction-scoped isolation level wasn't propagated to the underlying database connection, as this is the default JTA transaction manager behavior.

For WebLogic, Spring offers a [WebLogicJtaTransactionManager](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/transaction/jta/WebLogicJtaTransactionManager.html) to address this limitation, as we can see in the following Spring source-code snippet:

    // Specify isolation level, if any, through corresponding WebLogic transaction property.
    if (this.weblogicTransactionManagerAvailable) {
        if (definition.getIsolationLevel() != TransactionDefinition.ISOLATION_DEFAULT) {
            try {
                Transaction tx = getTransactionManager().getTransaction();
                Integer isolationLevel = definition.getIsolationLevel();
                /*
                weblogic.transaction.Transaction wtx = (weblogic.transaction.Transaction) tx;
                wtx.setProperty(ISOLATION_LEVEL_KEY, isolationLevel);
                */
                this.setPropertyMethod.invoke(tx, ISOLATION_LEVEL_KEY, isolationLevel);
            }
            catch (InvocationTargetException ex) {
                throw new TransactionSystemException(
                        "WebLogic's Transaction.setProperty(String, Serializable) method failed", ex.getTargetException());
            }
            catch (Exception ex) {
                throw new TransactionSystemException(
                        "Could not invoke WebLogic's Transaction.setProperty(String, Serializable) method", ex);
            }
        }
    }
    else {
        applyIsolationLevel(txObject, definition.getIsolationLevel());
    }

## Conclusion

Transaction management is definitely not a trivial thing, and with all the available frameworks and abstraction layers, it really becomes more complicated than one might think.

Because data integrity is very important for most business applications, your only option is to master your current project data layer framework stack.

Code available for [Hibernate](https://github.com/vladmihalcea/hibernate-master-class) and [JPA](https://github.com/vladmihalcea/vladmihalcea.wordpress.com/tree/master/hibernate-facts).
