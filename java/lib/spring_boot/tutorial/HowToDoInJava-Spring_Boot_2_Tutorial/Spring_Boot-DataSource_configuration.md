# [Spring Boot – DataSource configuration](https://howtodoinjava.com/spring-boot2/datasource-configuration/)

- [Spring Boot – DataSource configuration](#spring-boot--datasource-configuration)
  - [1. What is DataSource](#1-what-is-datasource)
  - [2. DataSource Configuration](#2-datasource-configuration)
    - [2.1. Maven](#21-maven)
      - [pom.xml](#pomxml)
    - [2.2. application.properties](#22-applicationproperties)
    - [2.3. DataSource Bean](#23-datasource-bean)
      - [JpaConfig.java](#jpaconfigjava)
    - [2.4. JNDI DataSource](#24-jndi-datasource)
  - [3. Connection Pooling](#3-connection-pooling)
    - [3.1. HikariCP, tomcat pooling and commons DBCP2](#31-hikaricp-tomcat-pooling-and-commons-dbcp2)
    - [3.2. Custom settings](#32-custom-settings)
  - [4. Multiple Datasources with Spring boot](#4-multiple-datasources-with-spring-boot)
    - [JpaConfig.java](#jpaconfigjava-1)
    - [Autowire primary datasource](#autowire-primary-datasource)
    - [Autowire NON-primary datasource](#autowire-non-primary-datasource)
  - [5. Conclusion](#5-conclusion)

Learn what is a datasource and how to create and customize DataSource bean in Spring boot applications.

## 1. What is DataSource

A **datasource is a factory for connections** to any physical data source. An alternative to the DriverManager facility. It uses a URL along with some credentials to establish a database connection.

An object that implements the [javax.sql.DataSource](https://docs.oracle.com/javase/10/docs/api/javax/sql/DataSource.html) interface will typically be registered with JNDI service and can be discovered using it’s JNDI name.

A datasource may be used to obtain :

- standard Connection object
- connection which can be used in connection pooling
- connection which can be used in distribured transactions and connection pooling

## 2. DataSource Configuration

Spring boot allows defining datasource configuration in both ways i.e. **Java config** and **properties config**. `DataSourceAutoConfiguration` checks for `DataSource.class` (or `EmbeddedDatabaseType.class`) on the classpath and few other things before configuring a `DataSource` bean for us.

### 2.1. Maven

If not already defined, include `spring-boot-starter-data-jpa` to project. It brings all necessary dependencies including JDBC drivers for various databases e.g. `mysql-connector-java` for connecting to mysql.

If we are planning to use embedded database at some step (e.g. testing), we can import H2 db separately.

#### pom.xml

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <version>2.4.1</version> 
        <scope>runtime</scope> 
    </dependency>

### 2.2. application.properties

DataSource configuration is provided by external configuration properties ( `spring.datasource.*` ) in `application.properties` file.

The properties configuration decouple the configuration from application code. This way, we can import the datasource configurations from even configuration provider systems.

Below given configuration shows sample properties for H2, MySQL, Oracle and SQL server databases.

We often do not need to specify the `driver-class-name`, since Spring Boot can deduce it for most databases from the url.

    # H2
    spring.datasource.url=jdbc:h2:file:C:/temp/test
    spring.datasource.username=sa
    spring.datasource.password=
    spring.datasource.driverClassName=org.h2.Driver
    spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
    
    # MySQL
    #spring.datasource.url=jdbc:mysql://localhost:3306/test
    #spring.datasource.username=dbuser
    #spring.datasource.password=dbpass
    #spring.datasource.driver-class-name=com.mysql.jdbc.Driver
    spring.jpa.database-platform=org.hibernate.dialect.MySQL5InnoDBDialect
    
    # Oracle
    #spring.datasource.url=jdbc:oracle:thin:@localhost:1521:orcl
    #spring.datasource.username=dbuser
    #spring.datasource.password=dbpass
    #spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
    #spring.jpa.database-platform=org.hibernate.dialect.Oracle10gDialect
    
    # SQL Server
    #spring.datasource.url=jdbc:sqlserver://localhost;databaseName=springbootdb
    #spring.datasource.username=dbuser
    #spring.datasource.password=dbpass
    #spring.datasource.driverClassName=com.microsoft.sqlserver.jdbc.SQLServerDriver
    #spring.jpa.hibernate.dialect=org.hibernate.dialect.SQLServer2012Dialect

### 2.3. DataSource Bean

Recommended way to create DataSource bean is using `DataSourceBuilder` class within a class annotated with the `@Configuration` annotation. The datasource uses the underlying connection pool as well.

#### JpaConfig.java

    @Configuration
    public class JpaConfig {
        
        @Bean
        public DataSource getDataSource() 
        {
            DataSourceBuilder dataSourceBuilder = DataSourceBuilder.create();
            dataSourceBuilder.driverClassName("org.h2.Driver");
            dataSourceBuilder.url("jdbc:h2:file:C:/temp/test");
            dataSourceBuilder.username("sa");
            dataSourceBuilder.password("");
            return dataSourceBuilder.build();
        }
    }

### 2.4. JNDI DataSource

If we deploy your Spring Boot application to an Application Server, we might want to configure and manage the DataSource by using the Application Server’s built-in features and access it by using JNDI.

We can do this using the `spring.datasource.jndi-name` property. e.g.

    #JBoss defined datasource using JNDI
 
    spring.datasource.jndi-name = java:jboss/datasources/testDB

## 3. Connection Pooling

### 3.1. HikariCP, tomcat pooling and commons DBCP2

For a **pooling DataSource** to be created, Spring boot verifies that a valid `Driver` class is available. If we set `spring.datasource.driver-class-name` property then that mentioned driver class has to be loadable.

The auto-configuration first tries to find and configure HikariCP. If HikariCP is available, it always choose it. Otherwise, if the Tomcat pooling is found, it is configured.

If neither HikariCP nor the Tomcat pooling datasource are available and if Commons DBCP2 is available, it is used.

`spring-boot-starter-data-jpa` starter automatically get a dependency to `HikariCP`.

### 3.2. Custom settings

It is also possible to fine-tune [implementation-specific settings](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#data-properties) by using their respective prefix (`spring.datasource.hikari.*`, `spring.datasource.tomcat.*`, and `spring.datasource.dbcp2.*`).

For example, we can use below properties to [customize a DBCP2 connection pool](https://commons.apache.org/proper/commons-dbcp/configuration.html).

    spring.datasource.dbcp2.initial-size = 50
    spring.datasource.dbcp2.max-idle = 50
    spring.datasource.dbcp2.default-query-timeout = 10000
    spring.datasource.dbcp2.default-auto-commit = true
    ...

## 4. Multiple Datasources with Spring boot

To configure multiple data sources, create as many bean definitions you want but mark one of the `DataSource` instances as `@Primary`, because various auto-configurations down the road expect to be able to get one by type.

Remember that if we create your own DataSource, the auto-configuration backs off. So we are responsible for providing configurations for all datasource beans.

### JpaConfig.java

    @Configuration
    public class JpaConfig {
        
        @Bean(name = "h2DataSource")
        public DataSource h2DataSource() 
        {
            DataSourceBuilder dataSourceBuilder = DataSourceBuilder.create();
            dataSourceBuilder.driverClassName("org.h2.Driver");
            dataSourceBuilder.url("jdbc:h2:file:C:/temp/test");
            dataSourceBuilder.username("sa");
            dataSourceBuilder.password("");
            return dataSourceBuilder.build();
        }
    
        @Bean(name = "mySqlDataSource")
        @Primary
        public DataSource mySqlDataSource() 
        {
            DataSourceBuilder dataSourceBuilder = DataSourceBuilder.create();
            dataSourceBuilder.url("jdbc:mysql://localhost/testdb");
            dataSourceBuilder.username("dbuser");
            dataSourceBuilder.password("dbpass");
            return dataSourceBuilder.build();
        }
    }

While autowiring the datasource, spring boot will prefer the primary datasource i.e. “`mySqlDataSource`”. To autowire another non-primary datasource, use `@Qualifier` annotation.

### Autowire primary datasource

    @Autowired
    DataSource dataSource;

### Autowire NON-primary datasource

    @Autowired
    @Qualifier("h2DataSource") 
    DataSource dataSource;

## 5. Conclusion

Spring boot provides very easy ways to create datasource beans – either using properties config or using java config `@Bean`. Spring boot provides ready-made auto configuration to use which can be further customized with advanced options in `application.properties` file.

Spring boot tries to find and configure connection pooling first HikariCP, second Tomcat pooling and then finally Commons DBCP2. `HikariCP` comes inbuilt with `spring-boot-starter-jdbc` or `spring-boot-starter-data-jpa` starters.

We can configure multiple datasources and one of them must be marked as `@Primary`. Primary datasource is autowired by default, and other datasources need to be autowired along with `@Qualifier` annotation.







