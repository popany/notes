# [Bootstrap a Web Application with Spring 5](https://www.baeldung.com/bootstraping-a-web-application-with-spring-and-java-based-configuration)

- [Bootstrap a Web Application with Spring 5](#bootstrap-a-web-application-with-spring-5)
  - [1. Overview](#1-overview)
  - [2. Bootstrapping Using Spring Boot](#2-bootstrapping-using-spring-boot)
    - [2.1. Maven Dependency](#21-maven-dependency)
    - [2.2. Creating a Spring Boot Application](#22-creating-a-spring-boot-application)
  - [3. Bootstrapping Using spring-webmvc](#3-bootstrapping-using-spring-webmvc)
    - [3.1. Maven Dependencies](#31-maven-dependencies)
    - [3.2. The Java-based Web Configuration](#32-the-java-based-web-configuration)
    - [3.3. The Initializer Class](#33-the-initializer-class)
  - [4. XML Configuration](#4-xml-configuration)
  - [5. Conclusion](#5-conclusion)

## 1. Overview

The tutorial illustrates how to Bootstrap a Web Application with Spring.

We'll look into the Spring Boot solution for bootstrapping the application and also see a non-Spring Boot approach.

We'll primarily use Java configuration, but also have a look at their equivalent XML configuration.

## 2. Bootstrapping Using Spring Boot

### 2.1. Maven Dependency

First, we'll need the [spring-boot-starter-web](https://search.maven.org/search?q=a:spring-boot-starter-web) dependency:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>2.4.0</version>
    </dependency>

This starter includes:

- **spring-web** and the **spring-webmvc** module that we need for our Spring web application
- a **Tomcat starter** so that we can run our web application directly without explicitly installing any server

### 2.2. Creating a Spring Boot Application

The **most straightforward way** to get started using Spring Boot is to create a main class and annotate it with **`@SpringBootApplication`**:

    @SpringBootApplication
    public class SpringBootRestApplication {

        public static void main(String[] args) {
            SpringApplication.run(SpringBootRestApplication.class, args);
        }
    }

This single annotation is equivalent to using `@Configuration`, `@EnableAutoConfiguration`, and `@ComponentScan`.

By default, it will **scan all the components in the same package or below**.

Next, for Java-based configuration of Spring beans, we need to create a config class and annotate it with `@Configuration` annotation:

    @Configuration
    public class WebConfig {

    }

This annotation is the main artifact used by the Java-based Spring configuration; it is itself meta-annotated with `@Component`, which makes the annotated classes standard beans and as such, also candidates for component-scanning.

The **main purpose of `@Configuration`** classes is to be **sources of bean definitions** for the Spring IoC Container. For a more detailed description, see the [official docs](http://static.springsource.org/spring/docs/current/spring-framework-reference/html/beans.html#beans-java).

Let's also have a look at a solution using the core `spring-webmvc` library.

## 3. Bootstrapping Using spring-webmvc

### 3.1. Maven Dependencies

First, we need the [spring-webmvc](https://search.maven.org/search?q=g:org.springframework%20AND%20a:spring-webmvc) dependency:

    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.3.3</version>
    </dependency>

### 3.2. The Java-based Web Configuration

Next, we'll add the configuration class that has the `@Configuration` annotation:

    @Configuration
    @EnableWebMvc
    @ComponentScan(basePackages = "com.baeldung.controller")
    public class WebConfig {
    
    }

Here, unlike the Spring Boot solution, we'll have to explicitly define `@EnableWebMvc` for setting up default Spring MVC Configurations and `@ComponentScan` to specify packages to scan for components.

The `@EnableWebMvc` annotation provides the Spring Web MVC configuration such as setting up the **dispatcher servlet**, enabling the `@Controller` and the `@RequestMapping` annotations and setting up other defaults.

`@ComponentScan` configures the component scanning directive, specifying the packages to scan.

### 3.3. The Initializer Class

Next, we need to add a class that implements the `WebApplicationInitializer` interface:

    public class AppInitializer implements WebApplicationInitializer {

        @Override
        public void onStartup(ServletContext container) throws ServletException {
            AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
            context.scan("com.baeldung");
            container.addListener(new ContextLoaderListener(context));

            ServletRegistration.Dynamic dispatcher = 
            container.addServlet("mvc", new DispatcherServlet(context));
            dispatcher.setLoadOnStartup(1);
            dispatcher.addMapping("/");   
        }
    }

Here, we're creating a Spring context using the `AnnotationConfigWebApplicationContext` class, which means we're using only annotation-based configuration. Then, we're specifying the packages to scan for components and configuration classes.

Finally, we're defining the entry point for the web application – the `DispatcherServlet`.

This class can entirely replace the `web.xml` file from <3.0 Servlet versions.

## 4. XML Configuration

Let's also have a quick look at the equivalent XML web configuration:

    <context:component-scan base-package="com.baeldung.controller" />
    <mvc:annotation-driven />

We can replace this XML file with the `WebConfig` class above.

To start the application, we can use an Initializer class that loads the XML configuration or a web.xml file. For more details on these two approaches, check out [our previous article](https://www.baeldung.com/spring-xml-vs-java-config).

## 5. Conclusion

In this article, we looked into two popular solutions for bootstrapping a Spring web application, one using the **Spring Boot web starter** and other using the **core spring-webmvc library**.

In [the next article on REST with Spring](https://www.baeldung.com/building-a-restful-web-service-with-spring-and-java-based-configuration), I cover setting up MVC in the project, configuration of the HTTP status codes, payload marshalling, and content negotiation.

As always, the code presented in this article is available [over on Github](https://github.com/eugenp/tutorials/tree/master/spring-boot-rest). This is a Maven-based project, so it should be easy to import and run as it is.
