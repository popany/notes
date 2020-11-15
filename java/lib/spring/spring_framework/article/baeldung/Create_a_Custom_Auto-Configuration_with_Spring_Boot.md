# [Create a Custom Auto-Configuration with Spring Boot](https://www.baeldung.com/spring-boot-custom-auto-configuration)

- [Create a Custom Auto-Configuration with Spring Boot](#create-a-custom-auto-configuration-with-spring-boot)
  - [1. Overview](#1-overview)
  - [2. Maven Dependencies](#2-maven-dependencies)
  - [3. Creating a Custom Auto-Configuration](#3-creating-a-custom-auto-configuration)
    - [3.1. Class Conditions](#31-class-conditions)
    - [3.2. Bean Conditions](#32-bean-conditions)
    - [3.3. Property Conditions](#33-property-conditions)
    - [3.4. Resource Conditions](#34-resource-conditions)

## 1. Overview

Simply put, the Spring Boot autoconfiguration represents a way to automatically configure a Spring application based on the dependencies that are present on the classpath.

This can make development faster and easier by eliminating the need for defining certain beans that are included in the auto-configuration classes.

In the following section, we're going to take a look at creating our custom Spring Boot auto-configuration.

## 2. Maven Dependencies

Let's start with the dependencies that we need:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
        <version>2.2.2.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.19</version>
    </dependency>

The latest versions of [spring-boot-starter-data-jpa](https://search.maven.org/classic/#search%7Cga%7C1%7Ca%3A%22spring-boot-starter-data-jpa%22) and [mysql-connector-java](https://search.maven.org/classic/#search%7Cga%7C1%7Ca%3A%22mysql-connector-java%22%20AND%20g%3A%22mysql%22) can be downloaded from Maven Central.

## 3. Creating a Custom Auto-Configuration

To create a custom auto-configuration, we need to create a class annotated as `@Configuration` and register it.

Let's create a custom configuration for a MySQL data source:

    @Configuration
    public class MySQLAutoconfiguration {
        //...
    }

The next mandatory step is **registering the class as an auto-configuration candidate**, by adding the name of the class under the key `org.springframework.boot.autoconfigure.EnableAutoConfiguration` in the standard file `resources/META-INF/spring.factories`:

    org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
    com.baeldung.autoconfiguration.MySQLAutoconfiguration

If we want our auto-configuration class to have priority over other auto-configuration candidates, we can add the `@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE)` annotation.

Auto-configuration is designed using **classes and beans** marked with `@Conditional` annotations so that the auto-configuration or specific parts of it can be replaced.

Note that the **auto-configuration is only in effect if the auto-configured beans are not defined in the application**. If you define your bean, then the default one will be overridden.

### 3.1. Class Conditions

Class conditions allow us to specify that a configuration bean will be included if a specified class is present using the `@ConditionalOnClass` annotation, or if a class is absent using the `@ConditionalOnMissingClass` annotation.

Let's specify that our `MySQLConfiguration` will only be loaded if the class `DataSource` is present, in which case we can assume the application will use a database:

    @Configuration
    @ConditionalOnClass(DataSource.class)
    public class MySQLAutoconfiguration {
        //...
    }

### 3.2. Bean Conditions

If we want to include a bean only if a specified bean is present or not, we can use the `@ConditionalOnBean` and `@ConditionalOnMissingBean` annotations.

To exemplify this, let's add an `entityManagerFactory` bean to our configuration class, and specify we only want this bean to be created if a bean called `dataSource` is present and if a bean called `entityManagerFactory` is not already defined:

    @Bean
    @ConditionalOnBean(name = "dataSource")
    @ConditionalOnMissingBean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        LocalContainerEntityManagerFactoryBean em
        = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource());
        em.setPackagesToScan("com.baeldung.autoconfiguration.example");
        em.setJpaVendorAdapter(new HibernateJpaVendorAdapter());
        if (additionalProperties() != null) {
            em.setJpaProperties(additionalProperties());
        }
        return em;
    }

Let's also configure a `transactionManager` bean that will only be loaded if a bean of type `JpaTransactionManager` is not already defined:

    @Bean
    @ConditionalOnMissingBean(type = "JpaTransactionManager")
    JpaTransactionManager transactionManager(EntityManagerFactory entityManagerFactory) {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(entityManagerFactory);
        return transactionManager;
    }

### 3.3. Property Conditions

The `@ConditionalOnProperty` annotation is used to specify if a configuration will be loaded based on the presence and value of a Spring Environment property.

First, let's add a property source file for our configuration that will determine where the properties will be read from:

    @PropertySource("classpath:mysql.properties")
    public class MySQLAutoconfiguration {
        //...
    }

We can configure the main `DataSource` bean that will be used to create connections to the database in such a way that it will only be loaded if a property called usemysql is present.

We can use the attribute havingValue to specify certain values of the usemysql property that have to be matched.

Let's define the dataSource bean with default values that connect to a local database called `myDb` if the `usemysql` property is set to local:

    @Bean
    @ConditionalOnProperty(
    name = "usemysql", 
    havingValue = "local")
    @ConditionalOnMissingBean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
    
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/myDb?createDatabaseIfNotExist=true");
        dataSource.setUsername("mysqluser");
        dataSource.setPassword("mysqlpass");
    
        return dataSource;
    }

If the `usemysql` property is set to `custom`, the `dataSource` bean will be configured using custom properties values for the database URL, user, and password:

    @Bean(name = "dataSource")
    @ConditionalOnProperty(
    name = "usemysql", 
    havingValue = "custom")
    @ConditionalOnMissingBean
    public DataSource dataSource2() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
            
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUrl(env.getProperty("mysql.url"));
        dataSource.setUsername(env.getProperty("mysql.user") != null 
        ? env.getProperty("mysql.user") : "");
        dataSource.setPassword(env.getProperty("mysql.pass") != null 
        ? env.getProperty("mysql.pass") : "");
            
        return dataSource;
    }

The `mysql.properties` file will contain the `usemysql` property:

    usemysql=local

If an application that uses the `MySQLAutoconfiguration` wishes to override the default properties, all it needs to do is add different values for the `mysql.url`, `mysql.user` and `mysql.pass` properties and the `usemysql=custom` line in the `mysql.properties` file.

### 3.4. Resource Conditions






TODO AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA