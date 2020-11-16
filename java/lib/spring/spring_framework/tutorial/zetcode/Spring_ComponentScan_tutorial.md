# [Spring @ComponentScan tutorial](http://zetcode.com/spring/componentscan/)

- [Spring @ComponentScan tutorial](#spring-componentscan-tutorial)
  - [Spring @ComponentScan](#spring-componentscan)
  - [Spring @ComponentScan example](#spring-componentscan-example)

Spring @ComponentScan tutorial shows how to enable component scanning in a Spring application. Component scanning enables auto-detection of beans by Spring container.

Spring is a popular Java application framework for creating enterprise applications.

## Spring @ComponentScan

`@ComponentScan` annotation enables component scanning in Spring. Java classes that are decorated with stereotypes such as `@Component`, `@Configuration`, `@Service` are auto-detected by Spring. The `@ComponentScan`'s `basePackages` attribute specifies which packages should be scanned for decorated beans.

The `@ComponentScan` annotation is an alternative to `<context:component-scan>` XML tag.

## Spring @ComponentScan example

The application enables component scanning with `@ComponentScan`. We have one service bean that returns the current time.

    pom.xml
    src
    ├───main
    │   ├───java
    │   │   └───com
    │   │       └───zetcode
    │   │           │   Application.java
    │   │           └───service
    │   │                   TimeService.java
    │   └───resources
    │           logback.xml
    └───test
        └───java

This is the project structure.

pom.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>

        <groupId>com.zetcode</groupId>
        <artifactId>componentscan</artifactId>
        <version>1.0-SNAPSHOT</version>

        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <maven.compiler.source>11</maven.compiler.source>
            <maven.compiler.target>11</maven.compiler.target>
            <spring-version>5.1.3.RELEASE</spring-version>

        </properties>

        <dependencies>

            <dependency>
                <groupId>ch.qos.logback</groupId>
                <artifactId>logback-classic</artifactId>
                <version>1.2.3</version>
            </dependency>

            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-context</artifactId>
                <version>${spring-version}</version>
            </dependency>

            <dependency>
                <groupId>org.springframework</groupId>
                <artifactId>spring-core</artifactId>
                <version>${spring-version}</version>
            </dependency>      
            
        </dependencies>

        <build>
            <plugins>
                <plugin>
                    <groupId>org.codehaus.mojo</groupId>
                    <artifactId>exec-maven-plugin</artifactId>
                    <version>1.6.0</version>
                    <configuration>
                        <mainClass>com.zetcode.Application</mainClass>
                    </configuration>
                </plugin>
            </plugins>
        </build>

    </project>

In the `pom.xml` file, we have basic Spring dependencies `spring-core`, `spring-context`, and logging `logback-classic` dependency.

The `exec-maven-plugin` is used for executing Spring application from the Maven on the command line.

resources/logback.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <configuration>
        <logger name="org.springframework" level="ERROR"/>
        <logger name="com.zetcode" level="INFO"/>

        <appender name="consoleAppender" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <Pattern>%d{HH:mm:ss.SSS} %blue(%-5level) %magenta(%logger{36}) - %msg %n
                </Pattern>
            </encoder>
        </appender>

        <root>
            <level value="INFO" />
            <appender-ref ref="consoleAppender" />
        </root>
    </configuration>

The `logback.xml` is a configuration file for the Logback logging library.

com/zetcode/service/TimeService.java

    package com.zetcode.service;

    import org.springframework.stereotype.Service;

    import java.time.LocalTime;

    @Service
    public class TimeService {

        public LocalTime getTime() {

            var now = LocalTime.now();

            return now;
        }
    }

The `TimeService` class is annotated with the `@Service` annotation. It is registered by Spring as a managed bean with the help of component scanning.

com/zetcode/Application.java

    package com.zetcode;

    import com.zetcode.service.TimeService;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.context.annotation.AnnotationConfigApplicationContext;
    import org.springframework.context.annotation.ComponentScan;
    import org.springframework.context.annotation.Configuration;

    @ComponentScan(basePackages = "com.zetcode")
    @Configuration
    public class Application {

        private static final Logger logger = LoggerFactory.getLogger(Application.class);

        public static void main(String[] args) {

            var ctx = new AnnotationConfigApplicationContext(Application.class);

            var timeService = (TimeService) ctx.getBean("timeService");
            logger.info("The time is {}", timeService.getTime());

            ctx.close();
        }
    }

The application is annotated with `@ComponentScan`. The `basePackages` option tells Spring to look for components in the `com/zetcode` package and its subpackages.

    var ctx = new AnnotationConfigApplicationContext(Application.class);

`AnnotationConfigApplicationContext` is a Spring standalone application context. It accepts the annotated Application as an input; thus the scanning is enabled.

    var timeService = (TimeService) ctx.getBean("timeService");
    logger.info("The time is {}", timeService.getTime());

We get the registered service bean and call its method.

    $ mvn -q exec:java
    10:57:01.912 INFO  com.zetcode.Application - The time is 10:57:01.912235800

We run the application.

In this tutorial, we have enabled component scanning with `@ComponentScan`.
