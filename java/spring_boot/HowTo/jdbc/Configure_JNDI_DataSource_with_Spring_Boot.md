# [Configure JNDI DataSource with Spring Boot](https://www.roytuts.com/spring-boot-jndi-datasource/)

- [Configure JNDI DataSource with Spring Boot](#configure-jndi-datasource-with-spring-boot)
  - [Introduction](#introduction)
  - [Why do we use JNDI DataSource?](#why-do-we-use-jndi-datasource)
  - [Prerequisites](#prerequisites)
  - [Creating Project](#creating-project)
  - [Build Script](#build-script)
    - [Spring Boot 1.5.9](#spring-boot-159)
    - [Spring Boot 2.2.1](#spring-boot-221)
  - [Building Project](#building-project)
  - [Application Configuration](#application-configuration)
    - [Oracle Database](#oracle-database)
    - [MySQL Database](#mysql-database)
  - [Property Config](#property-config)
  - [Application Config](#application-config)
    - [Spring Boot 1.5.9](#spring-boot-159-1)
    - [Spring Boot 2.2.1](#spring-boot-221-1)
  - [Entity Class](#entity-class)
  - [MySQL Table](#mysql-table)
  - [Dump Some Data](#dump-some-data)
  - [Spring Repository](#spring-repository)
  - [Spring Service](#spring-service)
  - [Spring REST Controller](#spring-rest-controller)
  - [Spring Main Class](#spring-main-class)
  - [Testing the Application](#testing-the-application)
  - [Source Code](#source-code)

## Introduction

In this post we will see how to configure JNDI datasource with Spring Boot. JNDI data source is very similar to JDBC data source. I will show examples on Oracle as well as MySQL database servers. The MySQL version example is downloadable at the end of this tutorial. I will also show you how to work with Spring Boot 1.5.9 and Spring Boot 2.2.1 versions. The `TomcatEmbeddedServletContainerFactory` has been removed from Spring Boot 2 and I will show you how to use `TomcatServletWebServerFactory` in Spring Boot 2.

The JNDI data source accesses a database connection that is pre-defined and configured in the application server and published as a JNDI resource or service. Instead of specifying a driver and database as we do with JDBC data sources, we only need to specify the JNDI resource name in our application server.

## Why do we use JNDI DataSource?

JNDI comes in rescue when you have to move an application between environments: development -> integration -> test -> production.

If you configure each application server to use the same JNDI name, you can have different databases in each environment but you need not to change your code. You just need to drop the deployable WAR file in the new environment.

You may also like to read [Spring Data JPA CRUD Example](https://www.roytuts.com/spring-data-jpa-crud-example/) and [Spring Data JPA Entity Graphs](https://www.roytuts.com/spring-data-jpa-entity-graphs/)

## Prerequisites

Java 1.8 or 12, Spring Boot 1.5.9 or Spring Boot 2.2.1, Gradle 4.10.2 or Gradle 5.6, Eclipse 4.12

## Creating Project

Create Gradle based Spring Boot project called spring-boot-jndi-datasource in Eclipse.

## Build Script

The default generated build.gradle script does not include the required dependencies. Therefore we need to update the build script to include the required dependencies.

We will see how to include the required dependencies in build scripts for Spring Boot 1.5.9 and Spring Boot 2.2.1.

As it is a REST based application, so we have added starter-web. We include starter-data-jpa to perform to perform database operations.

### Spring Boot 1.5.9

    buildscript {
        ext {
            springBootVersion = '1.5.9.RELEASE'
        }
        repositories {
            mavenLocal()
            mavenCentral()
        }
        dependencies {
            classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
        }
    }

    apply plugin: 'java'
    apply plugin: 'org.springframework.boot'

    sourceCompatibility = 1.8
    targetCompatibility = 1.8

    repositories {
        mavenLocal()
        mavenCentral()
    }

    dependencies {
        compile("org.springframework.boot:spring-boot-starter-web:${springBootVersion}")
        compile('org.springframework.boot:spring-boot-starter-data-jpa')
        runtime('com.oracle.jdbc:ojdbc7:12.1.0.2')
    }

### Spring Boot 2.2.1

    buildscript {
        ext {
            springBootVersion = '2.2.1.RELEASE'
        }
        
        repositories {
            mavenLocal()
            mavenCentral()
        }
        
        dependencies {
            classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
        }
    }

    apply plugin: 'java'
    apply plugin: 'org.springframework.boot'

    sourceCompatibility = 12
    targetCompatibility = 12

    repositories {
        mavenLocal()
        mavenCentral()
    }

    dependencies {
        implementation("org.springframework.boot:spring-boot-starter-web:${springBootVersion}")
        implementation("org.springframework.boot:spring-boot-starter-data-jpa:${springBootVersion}")
        implementation('mysql:mysql-connector-java:8.0.17')
        implementation('org.apache.tomcat:tomcat-jdbc:9.0.27')
        runtimeOnly('javax.xml.bind:jaxb-api:2.4.0-b180830.0359')
    }

Notice in the above build script I have added jaxb-api. This API is required by the Java application. Up to Java 8 you don’t need to add this API explicitly in your build script because this API is available by default up to Java 8. After Java 9 you have to add it in the build script or build file manually to avoid JAXB related exceptions.

## Building Project

Build the blank project, if you get any Exception related to main class then create a class called `JndiDatasourceApp` under package com.roytuts.spring.boot.jndi.datasource with main method and try to build.

## Application Configuration

Create below `application.properties` file under `src/main/resources` directory.

### Oracle Database

We specify Oracle Database connection details and hibernate dialect.

    #datasource
    spring.datasource.driverClassName=oracle.jdbc.driver.OracleDriver
    spring.datasource.url=jdbc:Oracle:thin:@//:/
    spring.datasource.username=scott
    spring.datasource.password=tiger
    spring.datasource.jndiName=jdbc/myDataSource

    #disable schema generation from Hibernate
    spring.jpa.hibernate.ddl-auto=none

    #DB dialect - override default one
    spring.jpa.database-platform=org.hibernate.dialect.Oracle12cDialect

### MySQL Database

We specify MySQL Database connection details.

    #datasource
    spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver
    spring.datasource.url=jdbc:mysql://localhost/roytuts
    spring.datasource.username=root
    spring.datasource.password=root
    spring.datasource.jndiName=jdbc/myDataSource

    #disable schema generation from Hibernate
    spring.jpa.hibernate.ddl-auto=none

Remember to update the configuration values according to your own.

## Property Config

Create below properties class `DatabaseProperties` to load key/value pairs for database connection parameters from `application.properties` file.

You can also load the properties in different way, such as load the property file using class level annotation `@PropertySource("classpath:application.properties")` or as it is the default properties file so it will be loaded by default when application starts up. The you need to `@Autowire Environment` class to get the value for a corresponding key from properties file. For example,

    @PropertySource("classpath:application.properties") //optional
    public class AppConfig {

        @Autowired
        private Environment env;
        
        @Bean
        public DataSource datasource() {
            String jndiName = env.getProperty("jndiName")
            
            //... more code
        }
    }

In the property file we have all properties declared with a prefix – `spring.datasource`. Therefore using Spring Boot it is very easy to load properties in Java class attributes. Simply specify the prefix using `@ConfigurationProperties annotation` and add the same property names as class attributes.

    package com.roytuts.spring.boot.jndi.datasource.config;

    import org.springframework.boot.context.properties.ConfigurationProperties;

    @ConfigurationProperties(prefix = "spring.datasource")
    public class DatabaseProperties {

        String url;
        String username;
        String password;
        String driverClassName;
        String jndiName;

        // getters and setters
    }

We have loaded properties in the above configuration class but we won’t be able to inject as a Bean until we declare as a Bean.

So we will declare as a Bean to access the property config class throughout the application wherever required.

## Application Config

Now create the `AppConfig` class in order to configure DataSource and JPA Repository with Spring’s Transaction support. We will also expose the property config as a bean in this class.

### Spring Boot 1.5.9

For Spring Boot version 1.5.9 use below configuration:

    package com.roytuts.spring.boot.jndi.datasource.config;

    import java.sql.SQLException;
    import javax.naming.NamingException;
    import javax.persistence.EntityManagerFactory;
    import javax.sql.DataSource;
    import org.apache.catalina.Context;
    import org.apache.catalina.startup.Tomcat;
    import org.apache.tomcat.util.descriptor.web.ContextResource;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainer;
    import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
    import org.springframework.jndi.JndiObjectFactoryBean;
    import org.springframework.orm.jpa.JpaTransactionManager;
    import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
    import org.springframework.orm.jpa.vendor.Database;
    import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
    import org.springframework.transaction.PlatformTransactionManager;
    import org.springframework.transaction.annotation.EnableTransactionManagement;

    @Configuration
    @EnableTransactionManagement
    @EnableJpaRepositories(basePackages = "com.roytuts.spring.boot.jndi.datasource.repository")
    public class AppConfig {

        @Bean
        public DatabaseProperties databaseProperties() {
            return new DatabaseProperties();
        }
	
        @Bean
        public TomcatEmbeddedServletContainerFactory tomcatFactory() {
            return new TomcatEmbeddedServletContainerFactory() {
                @Override
                protected TomcatEmbeddedServletContainer getTomcatEmbeddedServletContainer(Tomcat tomcat) {
                    tomcat.enableNaming();
                    return super.getTomcatEmbeddedServletContainer(tomcat);
                }
                
                @Override
                protected void postProcessContext(Context context) {
                    ContextResource resource = new ContextResource();
                    resource.setName(databaseProperties().getJndiName());
                    resource.setType(DataSource.class.getName());
                    resource.setProperty("factory", "org.apache.tomcat.jdbc.pool.DataSourceFactory");
                    resource.setProperty("driverClassName", databaseProperties().getDriverClassName());
                    resource.setProperty("url", databaseProperties().getUrl());
                    resource.setProperty("password", databaseProperties().getPassword());
                    resource.setProperty("username", databaseProperties().getUsername());
                    context.getNamingResources().addResource(resource);
                }
            };
        }
        
        @Bean(destroyMethod = "")
        public DataSource jndiDataSource() throws IllegalArgumentException, NamingException {
            JndiObjectFactoryBean bean = new JndiObjectFactoryBean();
            bean.setJndiName("java:comp/env/" + databaseProperties().getJndiName());
            bean.setProxyInterface(DataSource.class);
            bean.setLookupOnStartup(false);
            bean.afterPropertiesSet();
            return (DataSource) bean.getObject();
        }
        
        @Bean
        public EntityManagerFactory entityManagerFactory() throws SQLException, IllegalArgumentException, NamingException {
            HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
            vendorAdapter.setDatabase(Database.ORACLE);
            vendorAdapter.setShowSql(true);
            LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
            factory.setJpaVendorAdapter(vendorAdapter);
            factory.setPackagesToScan("com.roytuts.spring.boot.jndi.datasource.entity");
            factory.setDataSource(jndiDataSource());
            factory.afterPropertiesSet();
            return factory.getObject();
        }
        
        @Bean
        public PlatformTransactionManager transactionManager()
                                        throws SQLException, IllegalArgumentException, NamingException {
            JpaTransactionManager txManager = new JpaTransactionManager();
            txManager.setEntityManagerFactory(entityManagerFactory());
            return txManager;
        }
    }

### Spring Boot 2.2.1

For Spring Boot 2.2.1 use below configuration file:

    package com.roytuts.spring.boot.jndi.datasource.config;

    import java.sql.SQLException;

    import javax.naming.NamingException;
    import javax.persistence.EntityManagerFactory;
    import javax.sql.DataSource;

    import org.apache.catalina.Context;
    import org.apache.catalina.startup.Tomcat;
    import org.apache.tomcat.util.descriptor.web.ContextResource;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
    import org.springframework.boot.web.embedded.tomcat.TomcatWebServer;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
    import org.springframework.jndi.JndiObjectFactoryBean;
    import org.springframework.orm.jpa.JpaTransactionManager;
    import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
    import org.springframework.orm.jpa.vendor.Database;
    import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
    import org.springframework.transaction.PlatformTransactionManager;
    import org.springframework.transaction.annotation.EnableTransactionManagement;

    @Configuration
    @EnableTransactionManagement
    @EnableJpaRepositories(basePackages = "com.roytuts.spring.boot.jndi.datasource.repository")
    public class AppConfig {

        @Bean
        public DatabaseProperties databaseProperties() {
            return new DatabaseProperties();
        }

        @Bean
        public TomcatServletWebServerFactory tomcatFactory() {
            return new TomcatServletWebServerFactory() {
                @Override
                protected TomcatWebServer getTomcatWebServer(Tomcat tomcat) {
                    tomcat.enableNaming();
                    return super.getTomcatWebServer(tomcat);
                }

                @Override
                protected void postProcessContext(Context context) {
                    ContextResource resource = new ContextResource();

                    resource.setType("org.apache.tomcat.jdbc.pool.DataSource");
                    resource.setName(databaseProperties().getJndiName());
                    resource.setProperty("factory", "org.apache.tomcat.jdbc.pool.DataSourceFactory");
                    resource.setProperty("driverClassName", databaseProperties().getDriverClassName());
                    resource.setProperty("url", databaseProperties().getUrl());
                    resource.setProperty("password", databaseProperties().getUsername());
                    resource.setProperty("username", databaseProperties().getPassword());

                    context.getNamingResources().addResource(resource);
                }
            };
        }

        @Bean(destroyMethod = "")
        public DataSource jndiDataSource() throws IllegalArgumentException, NamingException {
            JndiObjectFactoryBean bean = new JndiObjectFactoryBean();
            bean.setJndiName("java:comp/env/" + databaseProperties().getJndiName());
            bean.setProxyInterface(DataSource.class);
            bean.setLookupOnStartup(false);
            bean.afterPropertiesSet();
            return (DataSource) bean.getObject();
        }

        @Bean
        public EntityManagerFactory entityManagerFactory() throws SQLException, IllegalArgumentException, NamingException {
            HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
            vendorAdapter.setDatabase(Database.MYSQL);
            vendorAdapter.setShowSql(true);
            LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
            factory.setJpaVendorAdapter(vendorAdapter);
            factory.setPackagesToScan("com.roytuts.spring.boot.jndi.datasource.entity");
            factory.setDataSource(jndiDataSource());
            factory.afterPropertiesSet();
            return factory.getObject();
        }

        @Bean
        public PlatformTransactionManager transactionManager()
                throws SQLException, IllegalArgumentException, NamingException {
            JpaTransactionManager txManager = new JpaTransactionManager();
            txManager.setEntityManagerFactory(entityManagerFactory());
            return txManager;
        }

    }

Of course according to your database type and version you may need to work on the above configuration class.

## Entity Class

Create below entity class `Company` to define mapping to database table. Please create the table with below columns as found in the below class.

    package com.roytuts.spring.boot.jndi.datasource.entity;

    import java.io.Serializable;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Table;

    @Entity
    @Table(name = "company")
    public class Company implements Serializable {

        private static final long serialVersionUID = 1L;

        @Id
        @Column(name = "id")
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private long id;

        @Column(name = "name")
        private String name;

        // getters and setters
    }

## MySQL Table

The corresponding MySQL table structure is given below:

    CREATE TABLE `company` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

## Dump Some Data

As we need to test our application, so dump some data:

    insert  into `company`(`id`,`name`) values 
    (1,'Tom & Jerry'),
    (2,'Order All'),
    (3,'Akash Food'),
    (4,'Chinese Food'),
    (5,'Roy Food');

## Spring Repository

Create below JPA Repository interface to perform database activities. Spring provides built-in API through JpaRepository to perform basic CRUD operations.

    package com.roytuts.spring.boot.jndi.datasource.repository;

    import org.springframework.data.jpa.repository.JpaRepository;

    import com.roytuts.spring.boot.jndi.datasource.entity.Company;

    public interface CompanyRepository extends JpaRepository<Company, Long> {
    }

## Spring Service

We need below Service class to fetch data from JPA Repository DAO layer.

    package com.roytuts.spring.boot.jndi.datasource.service;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.roytuts.spring.boot.jndi.datasource.entity.Company;
    import com.roytuts.spring.boot.jndi.datasource.repository.CompanyRepository;

    @Service
    public class CompanyService {

        @Autowired
        private CompanyRepository companyRepository;

        public List<Company> getCompanyList() {
            return companyRepository.findAll();
        }
    }

## Spring REST Controller

Need to send data to client through below Rest Controller class.

    package com.roytuts.spring.boot.jndi.datasource.rest.controller;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;

    import com.roytuts.spring.boot.jndi.datasource.entity.Company;
    import com.roytuts.spring.boot.jndi.datasource.service.CompanyService;

    @RestController
    public class CompanyRestController {

        @Autowired
        private CompanyService companyService;

        @GetMapping("/company")
        public ResponseEntity<List<Company>> getCompanyList() {
            return new ResponseEntity<List<Company>>(companyService.getCompanyList(), HttpStatus.OK);
        }
    }

## Spring Main Class

Create main class to start up the application. main class with `@SpringBootApplication` annotation is enough to deploy the application into Tomcat server.

    package com.roytuts.spring.boot.jndi.datasource;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;

    @SpringBootApplication(scanBasePackages = "com.roytuts.spring.boot.jndi.datasource")
    public class JndiDatasourceApp {

        public static void main(String[] args) {
            SpringApplication.run(JndiDatasourceApp.class, args);
        }
    }

## Testing the Application

Running the above main class will deploy the application into embedded Tomcat server.

Now hit the URL <http://localhost:8080/company> from browser or REST client you will get the below output:

    [{"id":1,"name":"Tom & Jerry"},{"id":2,"name":"Order All"},{"id":3,"name":"Akash Food"},{"id":4,"name":"Chinese Food"},{"id":5,"name":"Roy Food"}]

That’s all. Hope you got an idea how to work with JNDI datasource in Spring Boot 1.5.9 and Spring Boot 2.2.1.

## Source Code

[Download](https://github.com/roytuts/spring-jpa/tree/master/spring-boot-jndi-datasource)
