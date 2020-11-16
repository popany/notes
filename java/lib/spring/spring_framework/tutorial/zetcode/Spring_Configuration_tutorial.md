# [Spring @Configuration tutorial](http://zetcode.com/spring/configuration/)

- [Spring @Configuration tutorial](#spring-configuration-tutorial)
  - [Spring @Configuration](#spring-configuration)
  - [Spring @Configuration example](#spring-configuration-example)

Spring `@Configuration` annotation tutorial shows how to configure Spring application using `@Configuration` annotation.

## Spring @Configuration

`@Configuration` annotation is used for Spring annotation based configuration. The `@Configuration` is a marker annotation which indicates that a class declares one or more `@Bean` methods and may be processed by the Spring container to generate bean definitions and service requests for those beans at runtime

## Spring @Configuration example

The following application uses `@Configuration` to configure a Spring application.

    pom.xml
    src
    └───src
        ├───main
        │   ├───java
        │   │   └───com
        │   │       └───zetcode
        │   │           │   Application.java
        │   │           └───config
        │   │                   AppConfig.java
        │   │                   H2Configurer.java
        │   └───resources
        │           application.properties
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
        <artifactId>configurationex</artifactId>
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

resources/application.properties

    app.name=My application
    app.db=H2

Here we have some application properties.

com/zetcode/config/AppConfig.java

    package com.zetcode.config;

    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.ComponentScan;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.context.annotation.PropertySource;

    @Configuration
    @ComponentScan(basePackages = "com.zetcode")
    @PropertySource(value = "application.properties")
    public class AppConfig {

        @Bean
        public H2Configurer databaseConfig() {
            return new H2Configurer();
        }
    }

`AppConfig` is the application configuration class. It is decorated with the `@Configuration` annotation, which is a specialization of the `@Component`.

    @Configuration
    @ComponentScan(basePackages = "com.zetcode")
    @PropertySource(value = "application.properties")
    public class AppConfig {

Component scanning is enabled with `@ComponentScan` and the resources are loaded with `@PropertySource`.

    @Bean
    public H2Configurer databaseConfig() {
        return new H2Configurer();
    }

With `@Bean` annotation, we create a `H2Configurer` bean.

com/zetcode/config/H2Configurer.java

    package com.zetcode.config;

    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;

    public class H2Configurer {

        private static final Logger logger = LoggerFactory.getLogger(H2Configurer.class);

        public H2Configurer() {

            logger.info("Configuring H2 database");
        }
    }

The H2Configurer simply logs a message.

com/zetcode/Application.java

    package com.zetcode;

    import com.zetcode.config.AppConfig;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.context.annotation.AnnotationConfigApplicationContext;
    import org.springframework.stereotype.Component;

    @Component
    public class Application {

        private static final Logger logger = LoggerFactory.getLogger(Application.class);

        public static void main(String[] args) {

            var ctx = new AnnotationConfigApplicationContext(AppConfig.class);
            var app = ctx.getBean(Application.class);

            app.run();

            ctx.close();
        }

        @Value("${app.name}")
        private String applicationName;

        @Value("${app.db}")
        private String database;

        private void run() {

            logger.info("Application name: {}", applicationName);
            logger.info("Database: {}", database);

        }
    }

The application class prints the application properties. The properties are injected into the attributes with `@Value`.

    var ctx = new AnnotationConfigApplicationContext(AppConfig.class);

The `AppConfig` is loaded into the **application context**.

    $ mvn -q exec:java
    20:07:39.769 INFO  com.zetcode.config.H2Configurer - Configuring H2 database 
    20:07:39.801 INFO  com.zetcode.Application - Application name: My application 
    20:07:39.816 INFO  com.zetcode.Application - Database: H2 

We run the application.

In this tutorial, we have configured a Spring application with `@Configuration`.
