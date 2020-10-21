# [Configuring Spring Boot for Oracle](https://springframework.guru/configuring-spring-boot-for-oracle/)

- [Configuring Spring Boot for Oracle](#configuring-spring-boot-for-oracle)
  - [Oracle Database Driver](#oracle-database-driver)
  - [Spring Boot Configuration for Oracle](#spring-boot-configuration-for-oracle)
    - [Maven Dependency](#maven-dependency)
    - [Oracle Datasource](#oracle-datasource)
    - [Spring Boot Basic Configuration for Oracle](#spring-boot-basic-configuration-for-oracle)
      - [Spring Boot Properties](#spring-boot-properties)
    - [Spring Boot Advanced Configuration for Oracle](#spring-boot-advanced-configuration-for-oracle)
      - [Oracle Properties](#oracle-properties)
        - [OracleConfiguration.class](#oracleconfigurationclass)
      - [Hibernate Configuration](#hibernate-configuration)
        - [Required](#required)
        - [Optional](#optional)

When you start with Spring Boot, it will automatically support H2 if no other data sources have been defined and H2 is found on the classpath. I’ve been using H2 for development for sometime now. It works very well.  All modern relational databases are going to support ANSI SQL. But each is going to have its own nuances and extensions. One thing of the things I like about H2 is its Oracle compatibility mode. It allows H2 to act like an Oracle database. It’s not perfect, but it does do a pretty good job.

The Spring Framework is the most popular Java framework used for building enterprise class applications. Oracle is the most popular database used in the enterprise. So chances are, if you are developing Spring Applications, sooner or later, you’re going to be persisting to an Oracle database.

## Oracle Database Driver

The Oracle JDBC drivers are not in public Maven repositories due to legal restrictions. This is really rather annoying. Oracle, if you’re reading this – really? Come on, fix this. Please.

So, if you are in a company, chances are you will have a Nexus installation with the Oracle JDBC jar installed. But if you are not, you will need to download the JDBC driver from Oracle (after accepting the terms and conditions you probably won’t read). And then you can install it into your local Maven repository manually.

You can install a JAR into your Maven repository using this Maven command. You may need to adjust the version and name depending on the JDBC driver version you download.

    mvn install:install-file -Dfile=ojdbc7.jar  -DgroupId=com.oracle -DartifactId=ojdbc7 -Dversion=12.1.0.1 -Dpackaging=jar

## Spring Boot Configuration for Oracle

### Maven Dependency

You will need to add the Oracle Driver to your Maven (or Gradle) dependencies.

    <dependency>
        <groupId>com.oracle</groupId>
        <artifactId>ojdbc7</artifactId>
        <version>12.1.0.1</version>
    </dependency>

### Oracle Datasource

The easiest approach is to create a configuration bean in the package structure of your Spring Boot application. This will create a new Oracle datasource for your Spring Boot application. **Once you specify a data source, Spring Boot will no longer create the H2 data source for you automatically**.

    @Bean
    DataSource dataSource() throws SQLException {
        OracleDataSource dataSource = new OracleDataSource();
        dataSource.setUser(username);
        dataSource.setPassword(password);
        dataSource.setURL(url);
        dataSource.setImplicitCachingEnabled(true);
        dataSource.setFastConnectionFailoverEnabled(true);
        return dataSource;
    }

### Spring Boot Basic Configuration for Oracle

#### Spring Boot Properties

Configuring a different datasource in Spring Boot is very simple. When you supply datasource properties in Spring Boot’s application.properties file, Spring Boot will use them to configure the datasource. To configure Spring Boot for Oracle, add the following lines to your properties file.

    #Basic Spring Boot Config for Oracle
    spring.datasource.url= jdbc:oracle:thin:@//spring.guru.csi0i9rgj9ws.us-east-1.rds.amazonaws.com:1521/ORCL
    spring.datasource.username=system
    spring.datasource.password=manager
    spring.datasource.driver-class-name=oracle.jdbc.OracleDriver
    #hibernate config
    spring.jpa.database-platform=org.hibernate.dialect.Oracle10gDialect

### Spring Boot Advanced Configuration for Oracle

Oracle is a highly advanced and highly configurable RDBMS. There is a reason Oracle is the #1 database in the enterprise. The basic example above will work for just about any JDBC data source you need to configure for use with Spring Boot. They will all have a url, user name, password, and driver class. But with Oracle, there are a number of advanced properties you may need to set. Especially if you’re using Oracle RAC.

Spring Boot will set vendor specific properties using `spring.datasource.<property name>`. And you absolutely can go this route. However, based on my experience, it might be time to switch to a Java based configuration. **Spring Boot will create the data source from just the properties file, or will forgo the automatic data source creation if you’re doing a more traditional method in Spring to define the data source bean**.

In this section, I’m going to show you how to use a Spring configuration bean to create the Oracle JDBC datasource.

#### Oracle Properties

In this example, I’m going to show you how to externalise the Oracle connection properties to a properties file.

In our Spring Boot application.properties file we want to set the following properties.

    #Oracle connection
    oracle.username=system
    oracle.password=manager
    oracle.url=jdbc:oracle:thin:@//spring.guru.csi0i9rgj9ws.us-east-1.rds.amazonaws.com:1521/ORCL

Next, on our Configuration class for Oracle, we want to add the following annotation:

    @ConfigurationProperties("oracle")

This tells Spring to look for the property prefix of Oracle when binding properties. Now if our configuration class has a property called ‘whatever’, Spring would try to **bind the property value** of ‘oracle.whatever’ to the property in the configuration class.

Now if we add the following properties to our configuration class, Spring will use them in the creation of our Oracle data source.

    @NotNull
    private String username;
    @NotNull
    private String password;
    @NotNull
    private String url;
    public void setUsername(String username) {
        this.username = username;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public void setUrl(String url) {
        this.url = url;
    }

The final Oracle configuration class looks like this:

##### OracleConfiguration.class

    package guru.springframework.configuration;
    import oracle.jdbc.pool.OracleDataSource;
    import org.springframework.boot.context.properties.ConfigurationProperties;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.context.annotation.Profile;
    import javax.sql.DataSource;
    import javax.validation.constraints.NotNull;
    import java.sql.SQLException;
    @Configuration
    @ConfigurationProperties("oracle")
    public class OracleConfiguration {
        @NotNull
        private String username;
        @NotNull
        private String password;
        @NotNull
        private String url;
        public void setUsername(String username) {
            this.username = username;
        }
        public void setPassword(String password) {
            this.password = password;
        }
        public void setUrl(String url) {
            this.url = url;
        }
        @Bean
        DataSource dataSource() throws SQLException {
            OracleDataSource dataSource = new OracleDataSource();
            dataSource.setUser(username);
            dataSource.setPassword(password);
            dataSource.setURL(url);
            dataSource.setImplicitCachingEnabled(true);
            dataSource.setFastConnectionFailoverEnabled(true);
            return dataSource;
        }
    }

#### Hibernate Configuration

We will want to tell Hibernate to use the Oracle dialect. We do this by adding the following property to the Spring Boot application.properties file.

##### Required

    spring.jpa.database-platform=org.hibernate.dialect.Oracle10gDialect

##### Optional

If you’re used to using the H2 database, database tables will automatically be generated by Hibernate. If you want the same behavior in Oracle, you’ll need to set the ddl-auto property of Hibernate to ‘create-drop’. The [Spring Boot documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-database-initialization.html) has additional information about database initialization. To have tables automatically created in Oracle, set the following property in your application.properties file.

    spring.jpa.hibernate.ddl-auto=create-drop
