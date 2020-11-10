# [Bootstrapping](https://www.tutorialspoint.com/spring_boot/spring_boot_bootstrapping.htm)

- [Bootstrapping](#bootstrapping)
  - [Class Path Dependencies](#class-path-dependencies)
    - [Maven dependency](#maven-dependency)
    - [Gradle dependency](#gradle-dependency)
  - [Main Method](#main-method)
  - [Write a Rest Endpoint](#write-a-rest-endpoint)
  - [Run Hello World with Java](#run-hello-world-with-java)

This chapter will explain you how to perform bootstrapping on a Spring Boot application.

One of the ways to Bootstrapping a Spring Boot application is by using Spring Initializer. To do this, you will have to visit the Spring Initializer web page www.start.spring.io and choose your Build, Spring Boot Version and platform. Also, you need to provide a Group, Artifact and required dependencies to run the application.

Observe the following screenshot that shows an example where we added the spring-boot-starter-web dependency to write REST Endpoints.

Once you provided the Group, Artifact, Dependencies, Build Project, Platform and Version, click Generate Project button. The zip file will download and the files will be extracted.

This section explains you the examples by using both Maven and Gradle.

## Class Path Dependencies

Spring Boot provides a number of Starters to add the jars in our class path. For example, for writing a Rest Endpoint, we need to add the spring-boot-starter-web dependency in our class path. Observe the codes shown below for a better understanding −

### Maven dependency

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>   

### Gradle dependency

    dependencies {
        compile('org.springframework.boot:spring-boot-starter-web')
    }

## Main Method

The main method should be writing the Spring Boot Application class. This class should be annotated with `@SpringBootApplication`. This is the entry point of the spring boot application to start. You can find the main class file under `src/java/main` directories with the default package.

In this example, the main class file is located at the `src/java/main` directories with the default package `com.tutorialspoint.demo`. Observe the code shown here for a better understanding −

    package com.tutorialspoint.demo;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;

    @SpringBootApplication
    public class DemoApplication {
        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }
    }

## Write a Rest Endpoint

To write a simple Hello World Rest Endpoint in the Spring Boot Application main class file itself, follow the steps shown below −

Firstly, add the `@RestController` annotation at the top of the class.

Now, write a Request URI method with `@RequestMapping` annotation.

Then, the Request URI method should return the Hello World string.

Now, your main Spring Boot Application class file will look like as shown in the code given below −

    package com.tutorialspoint.demo;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @SpringBootApplication
    @RestController

    public class DemoApplication {
        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }
        @RequestMapping(value = "/")
        public String hello() {
            return "Hello World";
        }
    }

Create an Executable JAR

Let us create an executable JAR file to run the Spring Boot application by using Maven and Gradle commands in the command prompt as shown below −

Use the Maven command mvn clean install as shown below −

    mvn clean install

After executing the command, you can see the BUILD SUCCESS message at the command prompt.

Use the Gradle command gradle clean build as shown below −

    gradle clean build

After executing the command, you can see the BUILD SUCCESSFUL message in the command prompt.

## Run Hello World with Java

Now, run the JAR file by using the command `java –jar <JARFILE>`. Observe that in the above example, the JAR file is named `demo-0.0.1-SNAPSHOT.jar`.
