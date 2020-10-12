# [Spring Boot Annotations](https://www.javatpoint.com/spring-boot-annotations)

- [Spring Boot Annotations](#spring-boot-annotations)
  - [Core Spring Framework Annotations](#core-spring-framework-annotations)
  - [Spring Framework Stereotype Annotations](#spring-framework-stereotype-annotations)
  - [Spring Boot Annotations](#spring-boot-annotations-1)
  - [Spring MVC and REST Annotations](#spring-mvc-and-rest-annotations)

Spring Boot Annotations is a form of metadata that provides data about a program. In other words, annotations are used to provide supplemental information about a program. It is not a part of the application that we develop. It does not have a direct effect on the operation of the code they annotate. It does not change the action of the compiled program.

In this section, we are going to discuss some important Spring Boot Annotation that we will use later in this tutorial.

## Core Spring Framework Annotations

`@Required`: It applies to the bean setter method. It indicates that the annotated bean must be populated at configuration time with the required property, else it throws an exception BeanInitilizationException.

    public class Machine   
    {  
        private Integer cost;  
        @Required  
        public void setCost(Integer cost)   
        {  
            this.cost = cost;  
        }  
        public Integer getCost()   
        {  
            return cost;  
        }     
    }  

`@Autowired`: Spring provides annotation-based auto-wiring by providing @Autowired annotation. It is used to autowire spring bean on setter methods, instance variable, and constructor. When we use `@Autowired` annotation, the spring container auto-wires the bean by matching data-type.

    @Component  
    public class Customer  
    {  
        private Person person;  
        @Autowired  
        public Customer(Person person)   
        {   
            this.person=person;  
        }  
    }  

`@Configuration`: It is a class-level annotation. The class annotated with @Configuration used by Spring Containers as a source of bean definitions.

    @Configuration  
    public class Vehicle  
    {  
        @Bean
        Vehicle engine()  
        {  
            return new Vehicle();  
        }  
    }  

`@ComponentScan`: It is used when we want to scan a package for beans. It is used with the annotation `@Configuration`. We can also specify the base packages to scan for Spring Components.

    @ComponentScan(basePackages = "com.javatpoint")  
    @Configuration  
    public class ScanComponent  
    {  
        // ...  
    }  

`@Bean`: It is a method-level annotation. It is an alternative of XML `<bean>` tag. It tells the method to produce a bean to be managed by Spring Container.

    @Bean  
    public BeanExample beanExample()   
    {  
        return new BeanExample ();  
    }  

## Spring Framework Stereotype Annotations

`@Component`: It is a class-level annotation. It is used to mark a Java class as a bean. A Java class annotated with `@Component` is found during the classpath. The Spring Framework pick it up and configure it in the application context as a Spring Bean.

    @Component  
    public class Student  
    {  
        .......  
    }  

`@Controller`: The `@Controller` is a class-level annotation. It is a specialization of `@Component`. It marks a class as a web request handler. It is often used to serve web pages. By default, it returns a string that indicates which route to redirect. It is mostly used with `@RequestMapping` annotation.

    @Controller  
    @RequestMapping("books")  
    public class BooksController   
    {  
        @RequestMapping(value = "/{name}", method = RequestMethod.GET)  
        public Employee getBooksByName()   
        {  
            return booksTemplate;  
        }  
    }  

`@Service`: It is also used at class level. It tells the Spring that class contains the business logic.

    package com.javatpoint;  
    @Service  
    public class TestService  
    {  
        public void service1()  
        {  
            //business code  
        }  
    }  

`@Repository`: It is a class-level annotation. The repository is a DAOs (Data Access Object) that access the database directly. The repository does all the operations related to the database.

    package com.javatpoint;  
    @Repository   
    public class TestRepository  
    {  
        public void delete()  
        {     
            //persistence code  
        }  
    }  

## Spring Boot Annotations

`@EnableAutoConfiguration`: It auto-configures the bean that is present in the classpath and configures it to run the methods. The use of this annotation is reduced in Spring Boot 1.2.0 release because developers provided an alternative of the annotation, i.e. `@SpringBootApplication`.

`@SpringBootApplication`: It is a combination of three annotations `@EnableAutoConfiguration`, `@ComponentScan`, and `@Configuration`.

## Spring MVC and REST Annotations

`@RequestMapping`: It is used to map the web requests. It has many optional elements like consumes, header, method, name, params, path, produces, and value. We use it with the class as well as the method.

`@GetMapping`: It maps the HTTP GET requests on the specific handler method. It is used to create a web service endpoint that fetches. It is used instead of using: @RequestMapping(method = RequestMethod.GET)

...
