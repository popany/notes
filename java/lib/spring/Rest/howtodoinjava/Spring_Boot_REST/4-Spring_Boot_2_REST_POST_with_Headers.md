# [Spring Boot 2 REST POST with Headers](https://howtodoinjava.com/spring-boot2/rest/spring-boot2-rest-post-example/)

- [Spring Boot 2 REST POST with Headers](#spring-boot-2-rest-post-with-headers)
  - [1. Maven dependencies](#1-maven-dependencies)
  - [2. REST Controller](#2-rest-controller)
    - [2.1. HTTP POST API](#21-http-post-api)
  - [3. Custom error handler](#3-custom-error-handler)
  - [4. `@SpringBootApplication`](#4-springbootapplication)
  - [5. Model classes and DAO](#5-model-classes-and-dao)
  - [6. Spring Boot 2 REST POST API – Demo](#6-spring-boot-2-rest-post-api--demo)
    - [6.1. HTTP POST – Validate missing header](#61-http-post--validate-missing-header)
    - [6.2. HTTP POST – Valid response](#62-http-post--valid-response)

Learn to create HTTP POST REST APIs using Spring boot 2 framework which accept JSON request and return JSON response to client. In this Spring Boot 2 REST POST API tutorial, we will create a REST API which returns list of employees after adding a new employee to collection.

## 1. Maven dependencies

At first, [create a simple maven web project](https://howtodoinjava.com/maven/maven-web-project-in-eclipse/) and update following spring boot dependencies in pom.xml file.

The important dependencies are `spring-boot-starter-parent` ([read more](https://howtodoinjava.com/spring-boot2/spring-boot-starter-parent-dependency/)) and `spring-boot-starter-web` ([read more](https://howtodoinjava.com/spring-boot2/spring-boot-starter-templates/)).

pom.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
     
        <groupId>com.howtodoinjava.demo</groupId>
        <artifactId>springbootdemo</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <packaging>jar</packaging>
     
        <name>SpringBootDemo</name>
        <description>Spring Boot2 REST API Demo for http://howtodoinjava.com</description>
     
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.0.5.RELEASE</version>
            <relativePath />
        </parent>
     
        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
            <java.version>1.8</java.version>
        </properties>
     
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
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

## 2. REST Controller

In Spring, a controller class, which is capable of serving REST API requests, is called rest controller. It should be annotated with `@RestController` annotation. In given rest controller, we have two API methods. Feel free to add more methods as needed.

### 2.1. HTTP POST API

1. It adds an employee in the employees collection.
2. It accept employee data in `Employee` object.
3. It accepts and creates JSON meda type.
4. It accepts two HTTP headers i.e. `X-COM-PERSIST` and `X-COM-LOCATION`. First header is required and second header is optional.
5. It returns the location of resource created.

EmployeeController.java

    package com.howtodoinjava.rest.controller;
     
    import java.net.URI;
     
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestHeader;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;
    import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
     
    import com.howtodoinjava.rest.dao.EmployeeDAO;
    import com.howtodoinjava.rest.model.Employee;
    import com.howtodoinjava.rest.model.Employees;
     
    @RestController
    @RequestMapping(path = "/employees")
    public class EmployeeController 
    {
        @Autowired
        private EmployeeDAO employeeDao;
         
        @GetMapping(path="/", produces = "application/json")
        public Employees getEmployees() 
        {
            return employeeDao.getAllEmployees();
        }
         
        @PostMapping(path= "/", consumes = "application/json", produces = "application/json")
        public ResponseEntity<Object> addEmployee(
            @RequestHeader(name = "X-COM-PERSIST", required = true) String headerPersist,
            @RequestHeader(name = "X-COM-LOCATION", required = false, defaultValue = "ASIA") String headerLocation,
            @RequestBody Employee employee) 
                     throws Exception 
        {       
            //Generate resource id
            Integer id = employeeDao.getAllEmployees().getEmployeeList().size() + 1;
            employee.setId(id);
             
            //add resource
            employeeDao.addEmployee(employee);
             
            //Create resource location
            URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                                        .path("/{id}")
                                        .buildAndExpand(employee.getId())
                                        .toUri();
             
            //Send location in response
            return ResponseEntity.created(location).build();
        }
    }

## 3. Custom error handler

A [good designed resi api](https://restfulapi.net/rest-api-design-tutorial-with-example/) must have consistent error messages as well. One way to achieve it in spring boot applications is using controller advice. Inside `@ControllerAdvice` class, use `@ExceptionHandler` annotated methods to return consistent responses in invalid scenarios.

CustomExceptionHandler.java

    package com.howtodoinjava.rest.exception;
     
    import java.util.ArrayList;
    import java.util.List;
     
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.ServletRequestBindingException;
    import org.springframework.web.bind.annotation.ControllerAdvice;
    import org.springframework.web.bind.annotation.ExceptionHandler;
    import org.springframework.web.context.request.WebRequest;
     
    @SuppressWarnings({"unchecked","rawtypes"})
    @ControllerAdvice
    public class CustomExceptionHandler
    {   
        @ExceptionHandler(ServletRequestBindingException.class)
        public final ResponseEntity<Object> handleHeaderException(Exception ex, WebRequest request) 
        {
            List<String> details = new ArrayList<>();
            details.add(ex.getLocalizedMessage());
            ErrorResponse error = new ErrorResponse("Bad Request", details);
            return new ResponseEntity(error, HttpStatus.BAD_REQUEST);
        }
         
        @ExceptionHandler(Exception.class)
        public final ResponseEntity<Object> handleAllExceptions(Exception ex, WebRequest request) 
        {
            List<String> details = new ArrayList<>();
            details.add(ex.getLocalizedMessage());
            ErrorResponse error = new ErrorResponse("Server Error", details);
            return new ResponseEntity(error, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

## 4. `@SpringBootApplication`

Run the application in embedded tomcat application by executing `main()` method of `SpringBootDemoApplication` class.

SpringBootDemoApplication.java

    package com.howtodoinjava.rest;
     
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication; 
     
    @SpringBootApplication
    public class SpringBootDemoApplication {
     
        public static void main(String[] args) {
            SpringApplication.run(SpringBootDemoApplication.class, args);
        }
    }

## 5. Model classes and DAO

These classes are not directly related to REST. Still lets take a look how they have been written.

Employee.java

    package com.howtodoinjava.rest.model;
     
    public class Employee {
     
        public Employee() {
     
        }
     
        public Employee(Integer id, String firstName, String lastName, String email) {
            super();
            this.id = id;
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
        }
      
        private Integer id;
        private String firstName;
        private String lastName;
        private String email;
     
        //Getters and setters
     
        @Override
        public String toString() {
            return "Employee [id=" + id + ", firstName=" + firstName + ", 
                    lastName=" + lastName + ", email=" + email + "]";
        }
    }

Employees.java

    package com.howtodoinjava.rest.model;
     
    import java.util.ArrayList;
    import java.util.List;
     
    public class Employees 
    {
        private List<Employee> employeeList;
         
        public List<Employee> getEmployeeList() {
            if(employeeList == null) {
                employeeList = new ArrayList<>();
            }
            return employeeList;
        }
      
        public void setEmployeeList(List<Employee> employeeList) {
            this.employeeList = employeeList;
        }
    }

DAO class uses a static list to store data. Here we need to implement actual database interaction.

EmployeeDAO.java

    package com.howtodoinjava.rest.dao;
     
    import org.springframework.stereotype.Repository;
     
    import com.howtodoinjava.rest.model.Employee;
    import com.howtodoinjava.rest.model.Employees;
     
    @Repository
    public class EmployeeDAO 
    {
        private static Employees list = new Employees();
         
        static
        {
            list.getEmployeeList().add(new Employee(1, "Lokesh", "Gupta", "howtodoinjava@gmail.com"));
            list.getEmployeeList().add(new Employee(2, "Alex", "Kolenchiskey", "abc@gmail.com"));
            list.getEmployeeList().add(new Employee(3, "David", "Kameron", "titanic@gmail.com"));
        }
         
        public Employees getAllEmployees() 
        {
            return list;
        }
         
        public void addEmployee(Employee employee) {
            list.getEmployeeList().add(employee);
        }
    }

## 6. Spring Boot 2 REST POST API – Demo

To start the application, run the `main()` method in `SpringBootDemoApplication` class. It will start the embedded tomcat server. In server logs, you will see that API have been registered in spring context.

Console

    s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped "{[/employees/],methods=[GET],produces=[application/json]}" onto public com.howtodoinjava.rest.model.Employees com.howtodoinjava.rest.controller. EmployeeController.getEmployees()
 
    s.w.s.m.m.a.RequestMappingHandlerMapping : Mapped "{[/employees/],methods=[POST], consumes=[application/json], produces=[application/json]}" onto public org.springframework.http.ResponseEntity <java.lang.Object> com.howtodoinjava.rest. controller. EmployeeController.addEmployee( java.lang.String, java.lang.String, com.howtodoinjava.rest.model.Employee) throws java.lang.Exception

### 6.1. HTTP POST – Validate missing header

Once server is UP, access the API using some rest client. Do not pass the request headers.

API response

    {
    "message": "Bad Request",
        "details": [
            "Missing request header 'X-COM-PERSIST' for method parameter of type String"
        ],
    }

### 6.2. HTTP POST – Valid response

API Response

    location: http://localhost:8080/employees/4
    content-length: 0
    date: Sat, 06 Oct 2018 04:33:37 GMT

Hit the GET request and this time we will get the added employee as well.
