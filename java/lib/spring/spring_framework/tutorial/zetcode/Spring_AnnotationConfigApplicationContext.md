# [Spring AnnotationConfigApplicationContext](http://zetcode.com/spring/annotationconfigapplicationcontext/)

- [Spring AnnotationConfigApplicationContext](#spring-annotationconfigapplicationcontext)
  - [AnnotationConfigApplicationContext](#annotationconfigapplicationcontext)
  - [Spring AnnotationConfigApplicationContext example](#spring-annotationconfigapplicationcontext-example)

Spring AnnotationConfigApplicationContext tutorial shows how to use AnnotationConfigApplicationContext in a Spring application.

## AnnotationConfigApplicationContext

`AnnotationConfigApplicationContext` is a standalone application context which **accepts annotated classes as input**. For instance, `@Configuration` or `@Component`. Beans can be looked up with `scan()` or registered with `register()`.

## Spring AnnotationConfigApplicationContext example

The following example uses `AnnotationConfigApplicationContext` to build a standalone Spring application. It has one Spring bean--`DateTimeService`--, which is located with `scan()`.

    pom.mxl
    src
    ├───main
    │   ├───java
    │   │   └───com
    │   │       └───zetcode
    │   │           │   Application.java
    │   │           └───bean
    │   │                   DateTimeService.java
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
        <artifactId>annotappctx</artifactId>
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

This is the Maven build file for our Spring application.

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

This is the Logback configuration file.

com/zetcode/bean/DateTimeService.java

    package com.zetcode.bean;

    import org.springframework.stereotype.Service;

    import java.time.LocalDate;
    import java.time.LocalDateTime;
    import java.time.LocalTime;

    @Service
    public class DateTimeService {

        public LocalDate getDate() {

            return LocalDate.now();
        }

        public LocalTime getTime() {

            return LocalTime.now();
        }

        public LocalDateTime getDateTime() {

            return LocalDateTime.now();
        }
    }

The DateTimeService is a service class that provides data and time services. It is decorated with `@Service` stereotype, which causes it to **be detected by the scanning process**.

com/zetcode/Application.java

    package com.zetcode;

    import com.zetcode.bean.DateTimeService;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.context.annotation.AnnotationConfigApplicationContext;
    import org.springframework.stereotype.Component;

    @Component
    public class Application {

        private static final Logger logger = LoggerFactory.getLogger(Application.class);

        @Autowired
        private DateTimeService dateTimeService;

        public static void main(String[] args) {

            var ctx = new AnnotationConfigApplicationContext();
            ctx.scan("com.zetcode");
            ctx.refresh();

            var bean = ctx.getBean(Application.class);
            bean.run();

            ctx.close();
        }

        public void run() {

            logger.info("Current time: {}", dateTimeService.getTime());
            logger.info("Current date: {}", dateTimeService.getDate());
            logger.info("Current datetime: {}", dateTimeService.getDateTime());
        }
    }

We set up the application and inject the `DateTimeService`. We call all three service methods.

    @Component
    public class Application {

The Application is also decorated with a stereotype, this time `@Component`. It will also be detected by Spring. We need to call its `run()` method to go outside the static context.

    @Autowired
    private DateTimeService dateTimeService;

The service class is injected with `@Autowired`.

    var ctx = new AnnotationConfigApplicationContext();
    ctx.scan("com.zetcode");
    ctx.refresh();

A new `AnnotationConfigApplicationContext` is created. The `scan()` method scans the `com.zetcode` package and its subpackages for annotated classes to generate beans. We need to call the `refresh()` method to finish the process.

    public void run() {

        logger.info("Current time: {}", dateTimeService.getTime());
        logger.info("Current date: {}", dateTimeService.getDate());
        logger.info("Current datetime: {}", dateTimeService.getDateTime());
    }

We get the current date, time, and datetime.

    $ mvn package
    $ mvn -q exec:java
    19:25:12.842 INFO  com.zetcode.Application - Current time: 19:25:12.842639200
    19:25:12.842 INFO  com.zetcode.Application - Current date: 2019-01-05
    19:25:12.842 INFO  com.zetcode.Application - Current datetime: 2019-01-05T19:25:12.842639200

We run the application.

In this tutorial, we have used `AnnotationConfigApplicationContext` to create a new standalone Spring application.



