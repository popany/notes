# [Spring @Controller and @RestController Annotations](https://howtodoinjava.com/spring-boot2/rest/controller-restcontroller/)

- [Spring @Controller and @RestController Annotations](#spring-controller-and-restcontroller-annotations)
  - [1. Spring Controller](#1-spring-controller)
    - [1.1. @Controller](#11-controller)
    - [1.2. @RestController](#12-restcontroller)
  - [2. Difference between @Controller and @RestController](#2-difference-between-controller-and-restcontroller)
    - [2.1. Using `@Controller` in spring mvc application](#21-using-controller-in-spring-mvc-application)
    - [2.2. Using `@Controller` with `@ResponseBody` in spring](#22-using-controller-with-responsebody-in-spring)
    - [2.3. Using `@RestController` in spring](#23-using-restcontroller-in-spring)

Learn the differences between `@Controller` and `@RestController` annotations in spring framework and how their response handling is different in each case.

## 1. Spring Controller

In Spring, incoming requests are always handled by some controller. Usually [dispatcher servlet](https://howtodoinjava.com/spring5/webmvc/spring-dispatcherservlet-tutorial/) is responsible for identifying the controller and appropriate request handler method inside controller by URL matching.

### 1.1. @Controller

In typical [spring mvc](https://howtodoinjava.com/spring-mvc-tutorial/) application, controller is indicated by annotation `@Controller`. This annotation serves as a specialization of `@Component`, allowing for implementation classes to be auto-detected through classpath scanning. It is typically used in combination with annotated handler methods based on the [`@RequestMapping`](https://howtodoinjava.com/spring-mvc/spring-mvc-requestmapping-annotation-examples/) annotation.

Controller.java

    @Target(value=TYPE)
    @Retention(value=RUNTIME)
    @Documented
    @Component
    public @interface Controller {
        //...
    }

A spring mvc controller is used typically in UI based applications where response is generally HTML content. The handler method returns the response “view name” which is resolved to a view technology file (e.g. JSP or FTL) by [view resolver](https://howtodoinjava.com/spring-boot/spring-boot-jsp-view-example/). And then parsed view content is sent back to browser client.

Imagine is the request is sent from [AJAX](https://howtodoinjava.com/ajax/complete-ajax-tutorial/) technology and client is actually looking for response in JSON format to that it can parse the result itself in browser and display as needed. Here, we must use `@ResponseBody` annotation along with `@Controller`.

`@ResponseBody` annotation indicates a method return value should be bound to the web **response body** i.e. no **view resolver** is needed.

### 1.2. @RestController

As name suggest, it shall be used in case of REST style controllers i.e. handler methods shall return the **JSON/XML response** directly to client rather using **view resolvers**. It is a convenience annotation that is itself annotated with `@Controller` and `@ResponseBody`.

    RestController.java
    @Target(value=TYPE)
    @Retention(value=RUNTIME)
    @Documented
    @Controller
    @ResponseBody
    public @interface RestController {
        //...
    }

## 2. Difference between @Controller and @RestController

Clearly from above section, `@RestController` is a convenience annotation that does nothing more than adds the `@Controller` and [`@ResponseBody`](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/ResponseBody.html) annotations in single statement.

A key difference between a traditional **MVC** `@Controller` and the **RESTful web service** `@RestController` is the way that the HTTP response body is created. Rather than relying on a view technology to perform server-side rendering of the data to HTML, rest controller simply populates and returns the **domain object** itself.

The object data is be written directly to the HTTP response as JSON or XML and parsed by client to further process it either for modifying the existing view or for any other purpose.

### 2.1. Using `@Controller` in spring mvc application

`@Controller` example without `@ResponseBody`

    @Controller
    @RequestMapping("employees")
    public class EmployeeController 
    {
        @RequestMapping(value = "/{name}", method = RequestMethod.GET)
        public Employee getEmployeeByName(@PathVariable String name, Model model) {
     
            //pull data and set in model
     
            return employeeTemplate;
        }
    }

### 2.2. Using `@Controller` with `@ResponseBody` in spring

`@Controller` example with `@ResponseBody`

    @Controller
    @ResponseBody
    @RequestMapping("employees")
    public class EmployeeController 
    {
        @RequestMapping(value = "/{name}", method = RequestMethod.GET, produces = "application/json")
        public Employee getEmployeeByName(@PathVariable String name) {
    
            //pull date
    
            return employee;
        }
    }

### 2.3. Using `@RestController` in spring

`@RestController` example

    @RestController
    @RequestMapping("employees")
    public class EmployeeController 
    {
        @RequestMapping(value = "/{name}", method = RequestMethod.GET, produces = "application/json")
        public Employee getEmployeeByName(@PathVariable String name) {
    
            //pull date
    
            return employee;
        }
    }

In above example, 2.2. and 2.3. have the same effect.
