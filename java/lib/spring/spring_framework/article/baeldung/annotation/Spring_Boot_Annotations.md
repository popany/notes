# [Spring Boot Annotations](https://www.baeldung.com/spring-boot-annotations)

- [Spring Boot Annotations](#spring-boot-annotations)
  - [1. Overview](#1-overview)
  - [2. @SpringBootApplication](#2-springbootapplication)
  - [3. @EnableAutoConfiguration](#3-enableautoconfiguration)
  - [4. Auto-Configuration Conditions](#4-auto-configuration-conditions)
    - [4.1. `@ConditionalOnClass` and `@ConditionalOnMissingClass`](#41-conditionalonclass-and-conditionalonmissingclass)
    - [4.2. @ConditionalOnBean and @ConditionalOnMissingBean](#42-conditionalonbean-and-conditionalonmissingbean)
    - [4.3. @ConditionalOnProperty](#43-conditionalonproperty)

## 1. Overview

Spring Boot made configuring Spring easier with its auto-configuration feature.

In this quick tutorial, we'll explore the annotations from the `org.springframework.boot.autoconfigure` and `org.springframework.boot.autoconfigure.condition` packages.

## 2. @SpringBootApplication

We use this annotation to mark the main class of a Spring Boot application:

    @SpringBootApplication
    class VehicleFactoryApplication {
    
        public static void main(String[] args) {
            SpringApplication.run(VehicleFactoryApplication.class, args);
        }
    }

`@SpringBootApplication` encapsulates `@Configuration`, `@EnableAutoConfiguration`, and `@ComponentScan` annotations with their default attributes.

## 3. @EnableAutoConfiguration

`@EnableAutoConfiguration`, as its name says, enables auto-configuration. It means that **Spring Boot looks for auto-configuration beans** on its classpath and automatically applies them.

Note, that we have to use this annotation with `@Configuration`:

    @Configuration
    @EnableAutoConfiguration
    class VehicleFactoryConfig {}

## 4. Auto-Configuration Conditions

Usually, when we write our **custom auto-configurations**, we want Spring to **use them conditionally**. We can achieve this with the annotations in this section.

We can place the annotations in this section on `@Configuration` classes or `@Bean` methods.

In the next sections, we'll only introduce the basic concept behind each condition. For further information, please visit [this article](https://www.baeldung.com/spring-boot-custom-auto-configuration).

### 4.1. `@ConditionalOnClass` and `@ConditionalOnMissingClass`

Using these conditions, Spring will only use the marked auto-configuration bean if the class in the annotation's **argument is present/absent**:

    @Configuration
    @ConditionalOnClass(DataSource.class)
    class MySQLAutoconfiguration {
        //...
    }

### 4.2. @ConditionalOnBean and @ConditionalOnMissingBean

We can use these annotations when we want to define conditions based on the presence or absence of a specific bean:

    @Bean
    @ConditionalOnBean(name = "dataSource")
    LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        // ...
    }

### 4.3. @ConditionalOnProperty

TODO spring