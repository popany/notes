# [Spring Boot JDBC Example](https://www.javatpoint.com/spring-boot-jdbc-example)

- [Spring Boot JDBC Example](#spring-boot-jdbc-example)

Spring Boot provides starter and libraries for connecting to our application with JDBC. Here, we are creating an application which connects with Mysql database. It includes the following steps to create and setup [JDBC with Spring Boot](https://www.javatpoint.com/spring-boot-jdbc).

## Create a database

    create database springbootdb  

## Create a table in to mysql

    create table user(id int UNSIGNED primary key not null auto_increment, name varchar(100), email varchar(100));  

## Creating a Spring Boot Pproject

## Providing project name and other project related information.

## Providing dependencies

## After finishing, create following files in your project.

### Configure database into application.properties file.

// application.properties

    spring.datasource.url=jdbc:mysql://localhost:3306/springbootdb  
    spring.datasource.username=root  
    spring.datasource.password=mysql  
    spring.jpa.hibernate.ddl-auto=create-drop  

// SpringBootJdbcApplication.java

    package com.javatpoint;  
    import org.springframework.boot.SpringApplication;  
    import org.springframework.boot.autoconfigure.SpringBootApplication;  
    @SpringBootApplication  
    public class SpringBootJdbcApplication {  
        public static void main(String[] args) {  
            SpringApplication.run(SpringBootJdbcApplication.class, args);  
        }  
    }  

### Creating a controller to handle HTTP requests.

// SpringBootJdbcController.java

    package com.javatpoint;  
    import org.springframework.web.bind.annotation.RequestMapping;  
    import org.springframework.beans.factory.annotation.Autowired;  
    import org.springframework.jdbc.core.JdbcTemplate;  
    import org.springframework.web.bind.annotation.RestController;  
    @RestController  
    public class SpringBootJdbcController {  
        @Autowired  
        JdbcTemplate jdbc;    
        @RequestMapping("/insert")  
        public String index(){  
            jdbc.execute("insert into user(name,email)values('javatpoint','java@javatpoint.com')");  
            return"data inserted Successfully";  
        }  
    }  

## Run the application

Run SpringBootJdbcApplication.java file as Java application.
