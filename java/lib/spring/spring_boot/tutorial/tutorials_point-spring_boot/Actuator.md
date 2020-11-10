# [Spring Boot - Actuator](https://www.tutorialspoint.com/spring_boot/spring_boot_actuator.htm)

- [Spring Boot - Actuator](#spring-boot---actuator)
  - [Enabling Spring Boot Actuator](#enabling-spring-boot-actuator)

Spring Boot Actuator provides secured endpoints for **monitoring and managing** your Spring Boot application. By default, all actuator endpoints are secured. In this chapter, you will learn in detail about how to enable Spring Boot actuator to your application.

## Enabling Spring Boot Actuator

To enable Spring Boot actuator endpoints to your Spring Boot application, we need to add the Spring Boot Starter actuator dependency in our build configuration file.

Maven users can add the below dependency in your `pom.xml` file.

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>

Gradle users can add the below dependency in your `build.gradle` file.

    compile group: 'org.springframework.boot', name: 'spring-boot-starter-actuator'

In the application.properties file, we need to disable the security for actuator endpoints.

    management.security.enabled = false

YAML file users can add the following property in your application.yml file.

    management:
        security:
            enabled: false

If you want to use the separate port number for accessing the Spring boot actutator endpoints add the management port number in `application.properties` file.

    management.port = 9000

YAML file users can add the following property in your `application.yml` file.

    management:
        port: 9000

Now, you can create an executable JAR file, and run the Spring Boot application by using the following Maven or Gradle commands.

For Maven, you can use the following command −

    mvn clean install

After “BUILD SUCCESS”, you can find the JAR file under the target directory.

For Gradle, you can use the following command −

    gradle clean build

After “BUILD SUCCESSFUL”, you can find the JAR file under the build/libs directory.

Now, you can run the JAR file by using the following command −

    java –jar <JARFILE> 

Now, the application has started on the Tomcat port 8080. Note that if you specified the management port number, then same application is running on two different port numbers.

Some important Spring Boot Actuator endpoints are given below. You can enter them in your web browser and monitor your application behavior.

|||
|-|-|
|ENDPOINTS|USAGE|
|/metrics|To view the application metrics such as memory used, memory free, threads, classes, system uptime etc|
|/env|To view the list of Environment variables used in the application|
|/beans|To view the Spring beans and its types, scopes and dependency|
|/health|To view the application health|
|/info|To view the information about the Spring Boot application|
|/trace|To view the list of Traces of your Rest endpoints|
