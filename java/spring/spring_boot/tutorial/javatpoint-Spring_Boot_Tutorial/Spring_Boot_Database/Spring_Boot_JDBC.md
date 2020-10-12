# [Spring Boot JDBC](https://www.javatpoint.com/spring-boot-jdbc)

- [Spring Boot JDBC](#spring-boot-jdbc)
  - [JDBC Connection Pooling](#jdbc-connection-pooling)
  - [HikariCP](#hikaricp)
  - [Why should we use Spring Boot JDBC?](#why-should-we-use-spring-boot-jdbc)
  - [JDBC vs. Hibernate](#jdbc-vs-hibernate)

Spring Boot JDBC provides starter and libraries for connecting an application with JDBC.

In Spring Boot JDBC, the database related beans such as `DataSource`, `JdbcTemplate`, and `NamedParameterJdbcTemplate` **auto-configures** and created during the startup. We can **autowire** these classes if we want to use it. For example:

    @Autowired  
    JdbcTemplate jdbcTemplate;  
    @Autowired  
    private NamedParameterJdbcTemplate jdbcTemplate;

In application.properties file, we configure DataSource and connection pooling. Spring Boot chooses tomcat pooling by default.

## JDBC Connection Pooling

JDBC connection pooling is a mechanism that manages multiple database connection requests. In other words, it facilitates connection reuse, a memory cache of database connections, called a connection pool. A connection pooling module maintains it as a layer on top of any standard JDBC driver product.

It increases the speed of data access and reduces the number of database connections for an application. It also improves the performance of an application. Connection pool performs the following tasks:

- Manage available connection
- Allocate new connection
- Close connection

In the above figure, there are clients, a connection pool (that has four available connections), and a DataSource.

In the first figure, there are three clients connected with different connections, and a connection is available. In the second figure, Client 3 has disconnected, and that connection is available.

When a client completes his work, it releases the connection, and that connection is available for other clients.

## HikariCP

The default connection pool in Spring Boot 2 is HikariCP. It provides enterprise-ready features and better performance. HikariCP is a JDBC DataSource implementation that provides a connection pooling mechanism.

- If the HikariCP is present on the classpath, the Spring Boot automatically configures it.
- If the HikariCP is not found on the classpath, Spring Boot looks for the Tomcat JDBC Connection Pool. If it is on the classpath Spring Boot, pick it up.
- If both the above options are not available, Spring Boot chooses Apache Commons DBCP2 as the JDBC connection pool.

We can also configure a connection pool manually, if we do not want to use the default connection pool. Suppose, we want to use Tomcat JDBC connection pool instead of HikariCP. We will exclude HikariCP dependency and add the tomcat-jdbc dependency in the pom.xml file, as shown below.

    <dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-data-jpa</ artifactId >  
    <exclusions>  
    <exclusion>  
    <groupId>com.zaxxer</groupId>  
    <artifactId>HikariCP</ artifactId >  
    </exclusion>  
    </exclusions>  
    </dependency>  
    <dependency>  
    <groupId>org.apache.tomcat</groupId>  
    <artifactId>tomcat-jdbc</artifactId>  
    <version>9.0.10</version>  
    </dependency>  
    <dependency>  
    <groupId>com.h2database</groupId>  
    <artifactId>h2</artifactId>  
    <version>1.4.9</version>  
    <socpe>runtime</scoope>  
    </dependency>  

On the other hand, we can also skip the connection pool scanning algorithm that Spring Boot uses. We can explicitly specify a connection pooling datasource by adding the property spring.datasource.type in the application.properties file.

    Spring.datasource.type=org.apache.tomcat.jdbc.pool.DataSource

We have set up the Tomcat connection pool. Now, we will add some properties in application.properties that optimize its performance and suiting some specific requirements.

    spring.datasource.tomcat.initial-size=20  
    spring.datasource.tomcat.max-wait=25000  
    spring.datasource.tomcat.max-active=70  
    spring.datasource.tomcat.max-idle=20  
    spring.datasource.tomcat.min-idle=9  
    spring.datasource.tomcat.default-auto-commit=true  

If we want to connect to MySQL database, we need to include the JDBC driver in the application's classpath:

    <!-- MySQL JDBC driver -->  
    <dependency>  
    <groupId>mysql</groupId>  
    <artifactId>mysql-connector-java</artifactId>  
    </dependency>

After that, define the datasoure properties in application.properties file.

Use the following properties if you are using MySQL database:

    spring.datasource.url=jdbc:mysql://192.168.1.4:3306/test  
    spring.datasource.username=javatpoint  
    spring.datasource.password=password  

Use the following properties if you are using Oracle database:

    spring.datasource.url=jdbc:oracle:thin:@localhost:1521:orcl  
    spring.datasource.username=system  
    spring.datasource.password=Password123  

|||
|-|-|
Note|Spring Boot 2 uses HikariCP as the database connection pool, by default. If the HikariCP is not present in the classpath, Spring Boot choose tomcat pooling by default.
|||

## Why should we use Spring Boot JDBC?

The functionality of Spring JDBC and Spring Boot JDBC is the same except the implementations. There are following advantages of Spring Boot JBDC over Spring JDBC:

||| 
|-|-| 
Spring Boot JDBC|Spring JDBC
There is only a spring-boot-starter-jdbc dependency is required.|In Spring JDBC, multiple dependencies need to be configured like spring-jdbc and spring-context.
It automatically configures Datasource bean, if not maintain explicitly. If we do not want to use the bean, we can set a property spring.datasource.initialize to false.|In Spring JDBC, it is necessary to create a database bean either using XML or javaconfig.
We do not need to register Template beans because Spring Boot automatically registers beans.|The Template beans such as PlatformTransactionManager, JDBCTemplate, NamedParameterJdbcTemplate must be registered.
Any db initialization scripts stored in .sql file gets executed automatically.|If any db initialization scripts like dropping or creation of tables are created in SQL file, this info needs to be given explicitly in the configuration.
|||

## JDBC vs. Hibernate

|||
|-|-|
JDBC|Hibernate
JDBC is a technology.|Hibernate is an ORM framework.
In JDBC, the user is responsible for creating and closing the connections.|In Hibernate, the run time system takes care of creating and closing the connections.
It does not support lazy loading.|It supports lazy loading that offers better performance.
It does not support associations (the connection between two separate classes).|It supports associations.
|||
