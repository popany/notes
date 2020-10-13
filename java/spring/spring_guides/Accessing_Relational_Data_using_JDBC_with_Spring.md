# [Accessing Relational Data using JDBC with Spring](https://spring.io/guides/gs/relational-data-access/)

- [Accessing Relational Data using JDBC with Spring](#accessing-relational-data-using-jdbc-with-spring)
  - [What You Will build](#what-you-will-build)
  - [How to complete this guide](#how-to-complete-this-guide)
  - [Starting with Spring Initializr](#starting-with-spring-initializr)
  - [Create a `Customer` Object](#create-a-customer-object)
  - [Store and Retrieve Data](#store-and-retrieve-data)
  - [Build an executable JAR](#build-an-executable-jar)

This guide walks you through the process of accessing relational data with Spring.

## What You Will build

You will build an application that uses Spring’s `JdbcTemplate` to access data stored in a relational database.

## How to complete this guide

Like most Spring [Getting Started guides](https://spring.io/guides), you can start from scratch and complete each step or you can bypass basic setup steps that are already familiar to you. Either way, you end up with working code.

To start from scratch, move on to [Starting with Spring Initializr](https://spring.io/guides/gs/relational-data-access/#scratch).

To skip the basics, do the following:

- [Download](https://github.com/spring-guides/gs-relational-data-access/archive/master.zip) and unzip the source repository for this guide, or clone it using Git: git clone <https://github.com/spring-guides/gs-relational-data-access.git>

- cd into gs-relational-data-access/initial

- Jump ahead to [Create a `Customer` Object](https://spring.io/guides/gs/relational-data-access/#initial).

When you finish, you can check your results against the code in gs-relational-data-access/complete.

## Starting with Spring Initializr

For all Spring applications, you should start with the [Spring Initializr](https://start.spring.io/). The Initializr offers a fast way to pull in all the dependencies you need for an application and does a lot of the setup for you. This example needs the JDBC API and H2 Database dependencies.

The following listing shows the pom.xml file that is created when you choose Maven:

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.3.2.RELEASE</version>
            <relativePath/> <!-- lookup parent from repository -->
        </parent>
        <groupId>com.example</groupId>
        <artifactId>relational-data-access</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <name>relational-data-access</name>
        <description>Demo project for Spring Boot</description>

        <properties>
            <java.version>1.8</java.version>
        </properties>

        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-data-jdbc</artifactId>
            </dependency>

            <dependency>
                <groupId>com.h2database</groupId>
                <artifactId>h2</artifactId>
                <scope>runtime</scope>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
                <exclusions>
                    <exclusion>
                        <groupId>org.junit.vintage</groupId>
                        <artifactId>junit-vintage-engine</artifactId>
                    </exclusion>
                </exclusions>
            </dependency>
        </dependencies>

        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </build>

    </project>

The following listing shows the build.gradle file that is created when you choose Gradle:

    plugins {
        id 'org.springframework.boot' version '2.3.2.RELEASE'
        id 'io.spring.dependency-management' version '1.0.8.RELEASE'
        id 'java'
    }

    group = 'com.example'
    version = '0.0.1-SNAPSHOT'
    sourceCompatibility = '1.8'

    repositories {
        mavenCentral()
    }

    dependencies {
        implementation 'org.springframework.boot:spring-boot-starter-data-jdbc'
        runtimeOnly 'com.h2database:h2'
        testImplementation('org.springframework.boot:spring-boot-starter-test') {
            exclude group: 'org.junit.vintage', module: 'junit-vintage-engine'
        }
    }

    test {
        useJUnitPlatform()
    }

## Create a `Customer` Object

The simple data access logic you will work with manages the first and last names of customers. To represent this data at the application level, create a `Customer` class, as the following listing (from `src/main/java/com/example/relationaldataaccess/Customer.java`) shows:

    package com.example.relationaldataaccess;

    public class Customer {
        private long id;
        private String firstName, lastName;

        public Customer(long id, String firstName, String lastName) {
            this.id = id;
            this.firstName = firstName;
            this.lastName = lastName;
        }

        @Override
        public String toString() {
            return String.format(
                "Customer[id=%d, firstName='%s', lastName='%s']",
                id, firstName, lastName);
        }

        // getters & setters omitted for brevity
    }

## Store and Retrieve Data

Spring provides a template class called `JdbcTemplate` that makes it easy to work with SQL relational databases and JDBC. Most JDBC code is mired in resource acquisition, connection management, exception handling, and general error checking that is wholly unrelated to what the code is meant to achieve. The `JdbcTemplate` takes care of all of that for you. All you have to do is focus on the task at hand. The following listing (from `src/main/java/com/example/relationaldataaccess/RelationalDataAccessApplication.java`) shows a class that can store and retrieve data over JDBC:

package com.example.relationaldataaccess;

    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.CommandLineRunner;
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.jdbc.core.JdbcTemplate;

    import java.util.Arrays;
    import java.util.List;
    import java.util.stream.Collectors;

    @SpringBootApplication
    public class RelationalDataAccessApplication implements CommandLineRunner {

        private static final Logger log = LoggerFactory.getLogger(RelationalDataAccessApplication.class);

        public static void main(String args[]) {
            SpringApplication.run(RelationalDataAccessApplication.class, args);
        }

        @Autowired
        JdbcTemplate jdbcTemplate;

        @Override
        public void run(String... strings) throws Exception {

            log.info("Creating tables");

            jdbcTemplate.execute("DROP TABLE customers IF EXISTS");
            jdbcTemplate.execute("CREATE TABLE customers(" +
                "id SERIAL, first_name VARCHAR(255), last_name VARCHAR(255))");

            // Split up the array of whole names into an array of first/last names
            List<Object[]> splitUpNames = Arrays.asList("John Woo", "Jeff Dean", "Josh Bloch", "Josh Long").stream()
                .map(name -> name.split(" "))
                .collect(Collectors.toList());

            // Use a Java 8 stream to print out each tuple of the list
            splitUpNames.forEach(name -> log.info(String.format("Inserting customer record for %s %s", name[0], name[1])));

            // Uses JdbcTemplate's batchUpdate operation to bulk load data
            jdbcTemplate.batchUpdate("INSERT INTO customers(first_name, last_name) VALUES (?,?)", splitUpNames);

            log.info("Querying for customer records where first_name = 'Josh':");
            jdbcTemplate.query(
                "SELECT id, first_name, last_name FROM customers WHERE first_name = ?", new Object[] { "Josh" },
                (rs, rowNum) -> new Customer(rs.getLong("id"), rs.getString("first_name"), rs.getString("last_name"))
            ).forEach(customer -> log.info(customer.toString()));
        }
    }

`@SpringBootApplication` is a convenience annotation that adds all of the following:

- `@Configuration`: Tags the class as a source of bean definitions for the application context.

- `@EnableAutoConfiguration`: Tells Spring Boot to start adding beans, based on classpath settings, other beans, and various property settings.

- `@ComponentScan`: Tells Spring to look for other components, configurations, and services in the `com.example.relationaldataaccess` package. In this case, there are none.

The `main()` method uses Spring Boot’s `SpringApplication.run()` method to launch an application.

Spring Boot supports H2 (an in-memory relational database engine) and automatically creates a connection. Because we use `spring-jdbc`, Spring Boot automatically creates a `JdbcTemplate`. The `@Autowired JdbcTemplate` field automatically loads it and makes it available.

This `Application` class implements Spring Boot’s `CommandLineRunner`, which means it will execute the `run()` method after the application context is loaded.

First, install some DDL by using the `execute` method of `JdbcTemplate`.

Second, take a list of strings and, by using Java 8 streams, split them into firstname/lastname pairs in a Java array.

Then install some records in your newly created table by using the `batchUpdate` method of `JdbcTemplate`. The first argument to the method call is the query string. The last argument (the array of `Object` instances) holds the variables to be substituted into the query where the `?` characters are.

For single insert statements, the `insert` method of `JdbcTemplate` is good. However, for multiple inserts, it is better to use `batchUpdate`.

Use `?` for arguments to avoid [SQL injection attacks](https://en.wikipedia.org/wiki/SQL_injection) by instructing JDBC to bind variables.

Finally, use the `query` method to search your table for records that match the criteria. You again use the `?` arguments to create parameters for the query, passing in the actual values when you make the call. The last argument is a Java 8 lambda that is used to convert each result row into a new `Customer` object.

## Build an executable JAR

You can run the application from the command line with Gradle or Maven. You can also build a single executable JAR file that contains all the necessary dependencies, classes, and resources and run that. Building an executable jar makes it easy to ship, version, and deploy the service as an application throughout the development lifecycle, across different environments, and so forth.

If you use Gradle, you can run the application by using `./gradlew bootRun`. Alternatively, you can build the JAR file by using `./gradlew build` and then run the JAR file, as follows:

    java -jar build/libs/gs-relational-data-access-0.1.0.jar

If you use Maven, you can run the application by using `./mvnw spring-boot:run`. Alternatively, you can build the JAR file with `./mvnw clean package` and then run the JAR file, as follows:

    java -jar target/gs-relational-data-access-0.1.0.jar

The steps described here create a runnable JAR. You can also [build a classic WAR file](https://spring.io/guides/gs/convert-jar-to-war/).
