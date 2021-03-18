# [The Spring @Controller and @RestController Annotations](https://www.baeldung.com/spring-controller-vs-restcontroller)

- [The Spring @Controller and @RestController Annotations](#the-spring-controller-and-restcontroller-annotations)
  - [1. Overview](#1-overview)
  - [2. Spring MVC @Controller](#2-spring-mvc-controller)
  - [3. Spring MVC @RestController](#3-spring-mvc-restcontroller)
  - [4. Conclusion](#4-conclusion)

## 1. Overview

In this brief tutorial, we’ll discuss the difference between `@Controller` and `@RestController` annotations in Spring MVC.

We can use the first annotation for traditional Spring controllers, and it has been part of the framework for a very long time.

Spring 4.0 introduced the `@RestController` annotation in order to simplify the creation of RESTful web services. It's a convenient annotation that combines `@Controller` and `@ResponseBody`, which eliminates the need to annotate every **request handling method** of the controller class with the `@ResponseBody` annotation.

## 2. Spring MVC @Controller

We can annotate classic controllers with the `@Controller` annotation. This is **simply a specialization of the `@Component`** class, which allows us to auto-detect implementation classes through the classpath scanning.

We typically use `@Controller` in combination with a `@RequestMapping` annotation for **request handling methods**.

Let's see a quick example of the Spring MVC controller:

    @Controller
    @RequestMapping("books")
    public class SimpleBookController {
    
        @GetMapping("/{id}", produces = "application/json")
        public @ResponseBody Book getBook(@PathVariable int id) {
            return findBookById(id);
        }
    
        private Book findBookById(int id) {
            // ...
        }
    }

We annotated the **request handling method** with `@ResponseBody`. This annotation enables **automatic serialization** of the **return object** into the `HttpResponse`.

## 3. Spring MVC @RestController

`@RestController` is a specialized version of the controller. It includes the `@Controller` and `@ResponseBody` annotations, and as a result, simplifies the controller implementation:

    @RestController
    @RequestMapping("books-rest")
    public class SimpleBookRestController {
        
        @GetMapping("/{id}", produces = "application/json")
        public Book getBook(@PathVariable int id) {
            return findBookById(id);
        }

        private Book findBookById(int id) {
            // ...
        }
    }

The controller is annotated with the `@RestController` annotation; therefore, the `@ResponseBody` isn't required.

Every request handling method of the controller class automatically serializes return objects into `HttpResponse`.

## 4. Conclusion

In this article, we examined the classic and specialized REST controllers available in the Spring Framework.

The complete source code for the examples is available in [the GitHub project](https://github.com/eugenp/tutorials/tree/master/spring-web-modules/spring-mvc-basics). This is a Maven project, so it can be imported and used as is.
