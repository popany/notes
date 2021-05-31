# [Setting Up Swagger 2 with a Spring REST API](https://www.baeldung.com/swagger-2-documentation-for-spring-rest-api)

- [Setting Up Swagger 2 with a Spring REST API](#setting-up-swagger-2-with-a-spring-rest-api)
  - [1. Overview](#1-overview)
  - [2. Target Project](#2-target-project)
  - [3. Adding the Maven Dependency](#3-adding-the-maven-dependency)
    - [3.1. Spring Boot Dependency](#31-spring-boot-dependency)
  - [4. Integrating Swagger 2 Into the Project](#4-integrating-swagger-2-into-the-project)
    - [4.1. Java Configuration](#41-java-configuration)
    - [4.2. Configuration Without Spring Boot](#42-configuration-without-spring-boot)
    - [4.3. Verification](#43-verification)
  - [5. Swagger UI](#5-swagger-ui)

## 1. Overview

Nowadays, front-end and back-end components often separate a web application. Usually, we expose APIs as a back-end component for the front-end component or third-party app integrations.

In such a scenario, it is essential to have proper specifications for the back-end APIs. At the same time, the API documentation should be informative, readable, and easy to follow.

Moreover, reference documentation should simultaneously describe every change in the API. Accomplishing this manually is a tedious exercise, so automation of the process was inevitable.

In this tutorial, we'll look at Swagger 2 for a Spring REST web service, using the **Springfox implementation** of the Swagger 2 specification.

If you are not familiar with Swagger, visit [its web page](http://swagger.io/) to learn more before continuing with this tutorial.

## 2. Target Project

The creation of the REST service we will use is not within the scope of this article. If you already have a suitable project, use it. If not, these links are a good place to start:

- [Build a REST API with Spring 4 and Java Config article](https://www.baeldung.com/building-a-restful-web-service-with-spring-and-java-based-configuration)

- [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/)

## 3. Adding the Maven Dependency

As mentioned above, we will use the Springfox implementation of the Swagger specification. The latest version can be found [on Maven Central](https://search.maven.org/classic/#search%7Cga%7C1%7C%22Springfox%20Swagger2%22).

To add it to our Maven project, we need a dependency in the `pom.xml` file:

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>2.9.2</version>
    </dependency>

### 3.1. Spring Boot Dependency

For the Spring Boot based projects, **it's enough to add a single `springfox-boot-starter` dependency**:

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-boot-starter</artifactId>
        <version>3.0.0</version>
    </dependency>

We can add any other starters we need, with a version managed by the Spring Boot parent:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.4.0</version>
    </dependency>

## 4. Integrating Swagger 2 Into the Project

### 4.1. Java Configuration

The configuration of Swagger mainly centers around the **`Docket`** bean:

    @Configuration
    public class SpringFoxConfig {                                    
        @Bean
        public Docket api() { 
            return new Docket(DocumentationType.SWAGGER_2)  
            .select()                                  
            .apis(RequestHandlerSelectors.any())              
            .paths(PathSelectors.any())                          
            .build();                                           
        }
    }

After defining the `Docket` bean, its `select()` method returns an instance of `ApiSelectorBuilder`, which provides a way to control the endpoints exposed by Swagger.

We can configure predicates for selecting `RequestHandlers` with the help of `RequestHandlerSelectors` and `PathSelectors`. Using `any()` for both will make documentation for our entire API available through Swagger.

### 4.2. Configuration Without Spring Boot

In plain Spring projects, we need to enable Swagger 2 explicitly. To do so, we have to use the `@EnableSwagger2WebMvc` on our configuration class:

    @Configuration
    @EnableSwagger2WebMvc
    public class SpringFoxConfig {
    }

Additionally, without Spring Boot, we don't have the luxury of auto-configuration of our resource handlers.

Swagger UI adds a set of resources that we must configure as part of a class that extends `WebMvcConfigurerAdapter` and is annotated with `@EnableWebMvc`:

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("swagger-ui.html")
          .addResourceLocations("classpath:/META-INF/resources/");
    
        registry.addResourceHandler("/webjars/**")
          .addResourceLocations("classpath:/META-INF/resources/webjars/");
    }

### 4.3. Verification

To verify that Springfox is working, we can visit this URL in our browser:

    http://localhost:8080/spring-security-rest/api/v2/api-docs

The result is a JSON response with a large number of key-value pairs, which is not very human readable. Fortunately, Swagger provides Swagger UI for this purpose.

## 5. Swagger UI















TODO swagger rrrrrrrrrrrrrrrrrrrrrrrr