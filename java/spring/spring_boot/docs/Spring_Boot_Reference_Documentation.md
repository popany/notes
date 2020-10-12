# [Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)

- [Spring Boot Reference Documentation](#spring-boot-reference-documentation)
  - [1. Spring Boot Documentation](#1-spring-boot-documentation)
  - [2. Getting Started](#2-getting-started)
  - [3. Using Spring Boot](#3-using-spring-boot)
  - [4. Spring Boot Features](#4-spring-boot-features)
    - [4.1. SpringApplication](#41-springapplication)
      - [4.1.4. Customizing SpringApplication](#414-customizing-springapplication)
    - [4.11. Working with SQL Databases](#411-working-with-sql-databases)
      - [4.11.1. Configure a DataSource](#4111-configure-a-datasource)
        - [Embedded Database Support](#embedded-database-support)
        - [Connection to a Production Database](#connection-to-a-production-database)
        - [Connection to a JNDI DataSource](#connection-to-a-jndi-datasource)
      - [4.11.2. Using JdbcTemplate](#4112-using-jdbctemplate)
  - [9. “How-to” Guides](#9-how-to-guides)
    - [9.1. Spring Boot Application](#91-spring-boot-application)
      - [9.1.5. Create a Non-web Application](#915-create-a-non-web-application)
    - [9.8. Logging](#98-logging)
    - [9.9. Data Access](#99-data-access)
      - [9.9.1. Configure a Custom DataSource](#991-configure-a-custom-datasource)

## [1. Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-documentation)

## [2. Getting Started](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#getting-started)

## [3. Using Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot)

## [4. Spring Boot Features](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features)

This section dives into the details of Spring Boot. Here you can learn about the key features that you may want to use and customize. If you have not already done so, you might want to read the "[Getting Started](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#getting-started)" and "[Using Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot)" sections, so that you have a good grounding of the basics.

### [4.1. SpringApplication](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-spring-application)

The `SpringApplication` class provides a convenient way to bootstrap a Spring application that is started from a `main()` method. In many situations, you can delegate to the static `SpringApplication.run` method, as shown in the following example:

    public static void main(String[] args) {
        SpringApplication.run(MySpringConfiguration.class, args);
    }

#### [4.1.4. Customizing SpringApplication](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-customizing-spring-application)

If the `SpringApplication` defaults are not to your taste, you can instead create a local instance and customize it. For example, to turn off the banner, you could write:

    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(MySpringConfiguration.class);
        app.setBannerMode(Banner.Mode.OFF);
        app.run(args);
    }

The constructor arguments passed to `SpringApplication` are configuration sources for Spring beans. In most cases, these are references to `@Configuration` classes, but they could also be references to XML configuration or to packages that should be scanned.

It is also possible to configure the `SpringApplication` by using an `application.properties` file. See [Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config) for details.

For a complete list of the configuration options, see the [SpringApplication Javadoc](https://docs.spring.io/spring-boot/docs/2.3.4.RELEASE/api/org/springframework/boot/SpringApplication.html).

### [4.11. Working with SQL Databases](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-sql)

The [Spring Framework](https://spring.io/projects/spring-framework) provides extensive support for working with SQL databases, from direct JDBC access using `JdbcTemplate` to complete “object relational mapping” technologies such as Hibernate. [Spring Data](https://spring.io/projects/spring-data) provides an additional level of functionality: creating `Repository` implementations directly from interfaces and using conventions to generate queries from your method names.

> `JdbcTemplate` is used for direct JDBC access. 

#### [4.11.1. Configure a DataSource](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-configure-datasource)

Java’s `javax.sql.DataSource` interface provides a standard method of working with database connections. Traditionally, a 'DataSource' uses a `URL` along with some credentials to establish a database connection.

> `DataSource` is working with database connections.

See [the “How-to” section](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-configure-a-datasource) for more advanced examples, typically to take full control over the configuration of the DataSource.

##### Embedded Database Support

It is often convenient to develop applications by using an in-memory embedded database. Obviously, in-memory databases do not provide persistent storage. You need to populate your database when your application starts and be prepared to throw away data when your application ends.

The “How-to” section includes a [section on how to initialize a database](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-database-initialization).

Spring Boot can auto-configure embedded [H2](https://www.h2database.com/), [HSQL](http://hsqldb.org/), and [Derby](https://db.apache.org/derby/) databases. You need not provide any connection URLs. You need only include a build dependency to the embedded database that you want to use.

If you are using this feature in your tests, you may notice that the same database is reused by your whole test suite regardless of the number of application contexts that you use. If you want to make sure that each context has a separate embedded database, you should set `spring.datasource.generate-unique-name` to `true`.

For example, the typical POM dependencies would be as follows:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.hsqldb</groupId>
        <artifactId>hsqldb</artifactId>
        <scope>runtime</scope>
    </dependency>

You need a dependency on `spring-jdbc` for an embedded database to be auto-configured. In this example, it is pulled in transitively through `spring-boot-starter-data-jpa`.

If, for whatever reason, you do configure the connection URL for an embedded database, take care to ensure that the database’s automatic shutdown is disabled. If you use H2, you should use `DB_CLOSE_ON_EXIT=FALSE` to do so. If you use HSQLDB, you should ensure that `shutdown=true` is not used. Disabling the database’s automatic shutdown lets Spring Boot control when the database is closed, thereby ensuring that it happens once access to the database is no longer needed.

##### Connection to a Production Database

Production database connections can also be auto-configured by using a pooling `DataSource`. Spring Boot uses the following algorithm for choosing a specific implementation:

1. We prefer [HikariCP](https://github.com/brettwooldridge/HikariCP) for its performance and concurrency. If HikariCP is available, we always choose it.

2. Otherwise, if the Tomcat pooling `DataSource` is available, we use it.

3. If neither HikariCP nor the Tomcat pooling datasource are available and if [Commons DBCP2](https://commons.apache.org/proper/commons-dbcp/) is available, we use it.

If you use the `spring-boot-starter-jdbc` or `spring-boot-starter-data-jpa` “starters”, you automatically get a dependency to `HikariCP`.

You can bypass that algorithm completely and specify the connection pool to use by setting the `spring.datasource.type` property. This is especially important if you run your application in a Tomcat container, as `tomcat-jdbc` is provided by default.

> `spring.datasource.type` property used for specify the connection pool.

Additional connection pools can always be configured manually. If you define your own `DataSource` bean, auto-configuration does not occur.

> Define 'DataSource' bean can forbid auto-configuration of connection pools.

DataSource configuration is controlled by external configuration properties in `spring.datasource.*`. For example, you might declare the following section in `application.properties`:

    spring.datasource.url=jdbc:mysql://localhost/test
    spring.datasource.username=dbuser
    spring.datasource.password=dbpass
    spring.datasource.driver-class-name=com.mysql.jdbc.Driver

You should at least specify the URL by setting the `spring.datasource.url` property. Otherwise, Spring Boot tries to auto-configure an embedded database.

> If `spring.datasource.url` property is not defined, Spring Boot would try to auto-configure an embedded database.

You often do not need to specify the `driver-class-name`, since Spring Boot can deduce it for most databases from the `url`.

For a pooling `DataSource` to be created, we need to be able to verify that a valid `Driver` class is available, so we check for that before doing anything. In other words, if you set `spring.datasource.driver-class-name=com.mysql.jdbc.Driver`, then that class has to be loadable.

See [DataSourceProperties](https://github.com/spring-projects/spring-boot/tree/v2.3.4.RELEASE/spring-boot-project/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/jdbc/DataSourceProperties.java) for more of the supported options. These are the standard options that work regardless of the actual implementation. It is also possible to fine-tune implementation-specific settings by using their respective prefix (`spring.datasource.hikari.*`, `spring.datasource.tomcat.*`, and `spring.datasource.dbcp2.*`). Refer to the documentation of the connection pool implementation you are using for more details.

For instance, if you use the [Tomcat connection pool](https://tomcat.apache.org/tomcat-9.0-doc/jdbc-pool.html#Common_Attributes), you could customize many additional settings, as shown in the following example:

    # Number of ms to wait before throwing an exception if no connection is available.
    spring.datasource.tomcat.max-wait=10000

    # Maximum number of active connections that can be allocated from this pool at the same time.
    spring.datasource.tomcat.max-active=50

    # Validate the connection before borrowing it from the pool.
    spring.datasource.tomcat.test-on-borrow=true

##### Connection to a JNDI DataSource

If you deploy your Spring Boot application to an Application Server, you might want to configure and manage your DataSource by using your Application Server’s built-in features and access it by using JNDI.

The `spring.datasource.jndi-name` property can be used as an alternative to the `spring.datasource.url`, `spring.datasource.username`, and `spring.datasource.password` properties to access the `DataSource` from a specific JNDI location. For example, the following section in `application.properties` shows how you can access a JBoss AS defined `DataSource`:

    spring.datasource.jndi-name=java:jboss/datasources/customers

#### 4.11.2. Using JdbcTemplate

Spring’s `JdbcTemplate` and `NamedParameterJdbcTemplate` classes are auto-configured, and you can `@Autowire` them directly into your own beans, as shown in the following example:

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.jdbc.core.JdbcTemplate;
    import org.springframework.stereotype.Component;

    @Component
    public class MyBean {

        private final JdbcTemplate jdbcTemplate;

        @Autowired
        public MyBean(JdbcTemplate jdbcTemplate) {
            this.jdbcTemplate = jdbcTemplate;
        }

        // ...

    }

You can customize some properties of the template by using the `spring.jdbc.template.*` properties, as shown in the following example:

    spring.jdbc.template.max-rows=500

The `NamedParameterJdbcTemplate` reuses the same `JdbcTemplate` instance behind the scenes. If more than one `JdbcTemplate` is defined and no primary candidate exists, the `NamedParameterJdbcTemplate` is not auto-configured.

## [9. “How-to” Guides](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto)

### [9.1. Spring Boot Application](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-create-a-non-web-application)

#### [9.1.5. Create a Non-web Application](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-create-a-non-web-application)

Not all Spring applications have to be web applications (or web services). If you want to execute some code in a `main` method but also bootstrap a Spring application to set up the infrastructure to use, you can use the `SpringApplication` features of Spring Boot. A `SpringApplication` changes its `ApplicationContext` class, depending on whether it thinks it needs a web application or not. The first thing you can do to help it is to leave server-related dependencies (e.g. servlet API) off the classpath. If you cannot do that (for example, you run two applications from the same code base) then you can explicitly call `setWebApplicationType(WebApplicationType.NONE)` on your `SpringApplication` instance or set the `applicationContextClass` property (through the Java API or with external properties). Application code that you want to run as your business logic can be implemented as a `CommandLineRunner` and dropped into the context as a `@Bean` definition.

### [9.8. Logging](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-logging)

### [9.9. Data Access](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-data-access)

#### [9.9.1. Configure a Custom DataSource](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-configure-a-datasource)

To configure your own `DataSource`, define a `@Bean` of that type in your configuration. Spring Boot reuses your `DataSource` anywhere one is required, including database initialization. If you need to externalize some settings, you can bind your `DataSource` to the environment (see “[Third-party Configuration](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config-3rd-party-configuration)”).

The following example shows how to define a data source in a bean:

    @Bean
    @ConfigurationProperties(prefix="app.datasource")
    public DataSource dataSource() {
        return new FancyDataSource();
    }

The following example shows how to define a data source by setting properties:

    app.datasource.url=jdbc:h2:mem:mydb
    app.datasource.username=sa
    app.datasource.pool-size=30

Assuming that your `FancyDataSource` has regular JavaBean properties for the URL, the username, and the pool size, these settings are bound automatically before the `DataSource` is made available to other components. The regular [database initialization](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-initialize-a-database-using-spring-jdbc) also happens (so the relevant sub-set of `spring.datasource.*` can still be used with your custom configuration).

Spring Boot also provides a utility builder class, called `DataSourceBuilder`, that can be used to create one of the standard data sources (if it is on the classpath). The builder can detect the one to use based on what’s available on the classpath. It also auto-detects the driver based on the JDBC URL.

The following example shows how to create a data source by using a `DataSourceBuilder`:

    @Bean
    @ConfigurationProperties("app.datasource")
    public DataSource dataSource() {
        return DataSourceBuilder.create().build();
    }

To run an app with that `DataSource`, all you need is the connection information. Pool-specific settings can also be provided. Check the implementation that is going to be used at runtime for more details.

The following example shows how to define a JDBC data source by setting properties:

    app.datasource.url=jdbc:mysql://localhost/test
    app.datasource.username=dbuser
    app.datasource.password=dbpass
    app.datasource.pool-size=30

However, there is a catch. Because the actual type of the connection pool is not exposed, no keys are generated in the metadata for your custom `DataSource` and no completion is available in your IDE (because the `DataSource` interface exposes no properties). Also, if you happen to have Hikari on the classpath, this basic setup does not work, because Hikari has no `url` property (but does have a `jdbcUrl` property). In that case, you must rewrite your configuration as follows:

    app.datasource.jdbc-url=jdbc:mysql://localhost/test
    app.datasource.username=dbuser
    app.datasource.password=dbpass
    app.datasource.maximum-pool-size=30

You can fix that by forcing the connection pool to use and return a dedicated implementation rather than `DataSource`. You cannot change the implementation at runtime, but the list of options will be explicit.

The following example shows how create a `HikariDataSource` with `DataSourceBuilder`:

    @Bean
    @ConfigurationProperties("app.datasource")
    public HikariDataSource dataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
    }

You can even go further by leveraging what `DataSourceProperties` does for you — that is, by providing a default embedded database with a sensible username and password if no URL is provided. You can easily initialize a `DataSourceBuilder` from the state of any `DataSourceProperties` object, so you could also inject the DataSource that Spring Boot creates automatically. However, that would split your configuration into two namespaces: `url`, `username`, `password`, `type`, and `driver` on `spring.datasource` and the rest on your custom namespace (`app.datasource`). To avoid that, you can redefine a custom `DataSourceProperties` on your custom namespace, as shown in the following example:

    @Bean
    @Primary
    @ConfigurationProperties("app.datasource")
    public DataSourceProperties dataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean
    @ConfigurationProperties("app.datasource.configuration")
    public HikariDataSource dataSource(DataSourceProperties properties) {
        return properties.initializeDataSourceBuilder().type(HikariDataSource.class).build();
    }

This setup puts you in sync with what Spring Boot does for you by default, except that a dedicated connection pool is chosen (in code) and its settings are exposed in the `app.datasource.configuration` sub namespace. Because `DataSourceProperties` is taking care of the `url/jdbcUrl` translation for you, you can configure it as follows:

    app.datasource.url=jdbc:mysql://localhost/test
    app.datasource.username=dbuser
    app.datasource.password=dbpass
    app.datasource.configuration.maximum-pool-size=30

Spring Boot will expose Hikari-specific settings to `spring.datasource.hikari`. This example uses a more generic `configuration` sub namespace as the example does not support multiple datasource implementations.

Because your custom configuration chooses to go with Hikari, `app.datasource.type` has no effect. In practice, the builder is initialized with whatever value you might set there and then overridden by the call to `.type()`.

See “[Configure a DataSource](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-configure-datasource)” in the “Spring Boot features” section and the [DataSourceAutoConfiguration](https://github.com/spring-projects/spring-boot/tree/v2.3.4.RELEASE/spring-boot-project/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/jdbc/DataSourceAutoConfiguration.java) class for more details.
