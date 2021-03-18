# [Build a REST API with Spring and Java Config](https://www.baeldung.com/building-a-restful-web-service-with-spring-and-java-based-configuration)

- [Build a REST API with Spring and Java Config](#build-a-rest-api-with-spring-and-java-config)
  - [1. Overview](#1-overview)
  - [2. Understanding REST in Spring](#2-understanding-rest-in-spring)
  - [3. The Java Configuration](#3-the-java-configuration)
    - [3.1. Using Spring Boot](#31-using-spring-boot)
  - [4. Testing the Spring Context](#4-testing-the-spring-context)
    - [4.1. Using Spring Boot](#41-using-spring-boot)
  - [5. The Controller](#5-the-controller)
  - [6. Mapping the HTTP Response Codes](#6-mapping-the-http-response-codes)
    - [6.1. Unmapped Requests](#61-unmapped-requests)
    - [6.2. Valid Mapped Requests](#62-valid-mapped-requests)
    - [6.3. Client Error](#63-client-error)
    - [6.4. Using `@ExceptionHandler`](#64-using-exceptionhandler)
  - [7. Additional Maven Dependencies](#7-additional-maven-dependencies)
    - [7.1. Using Spring Boot](#71-using-spring-boot)
  - [8. Conclusion](#8-conclusion)

## 1. Overview

This article shows how to set up REST in Spring – the Controller and HTTP response codes, configuration of payload marshalling and content negotiation.

## 2. Understanding REST in Spring

The Spring framework supports **two ways** of creating RESTful services:

- using MVC with **ModelAndView**
- using **HTTP message converters**

The ModelAndView approach is older and much better documented, but also more verbose and configuration heavy. It tries to shoehorn the REST paradigm into the old model, which is not without problems. The Spring team understood this and provided first-class REST support starting with Spring 3.0.

The new approach, based on **`HttpMessageConverter`** and **annotations**, is much more lightweight and easy to implement. Configuration is minimal, and it provides sensible defaults for what you would expect from a RESTful service.

## 3. The Java Configuration

    @Configuration
    @EnableWebMvc
    public class WebConfig{
    //
    }

The new `@EnableWebMvc` annotation does some useful things – specifically, in the case of REST, it detects the existence of Jackson and JAXB 2 on the classpath and automatically creates and registers default JSON and XML converters. The functionality of the annotation is equivalent to the XML version:

    <mvc:annotation-driven />

This is a shortcut, and though it may be useful in many situations, it's not perfect. When more complex configuration is needed, remove the annotation and extend `WebMvcConfigurationSupport` directly.

### 3.1. Using Spring Boot

If we're using the `@SpringBootApplication` annotation and the spring-webmvc library is on the classpath, then the `@EnableWebMvc` annotation is added automatically with [a default autoconfiguration](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-developing-web-applications.html#boot-features-spring-mvc-auto-configuration).

We can still add MVC functionality to this configuration by implementing the `WebMvcConfigurer` interface on a `@Configuration` annotated class. We can also use a `WebMvcRegistrationsAdapter` instance to provide our own `RequestMappingHandlerMapping`, `RequestMappingHandlerAdapter`, or `ExceptionHandlerExceptionResolver` implementations.

Finally, if we want to discard Spring Boot's MVC features and declare a custom configuration, we can do so by using the `@EnableWebMvc` annotation.

## 4. Testing the Spring Context

Starting with Spring 3.1, we get first-class testing support for `@Configuration` classes:

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration( 
      classes = {WebConfig.class, PersistenceConfig.class},
      loader = AnnotationConfigContextLoader.class)
    public class SpringContextIntegrationTest {
    
       @Test
       public void contextLoads(){
          // When
       }
    }

We're specifying the Java configuration classes with the `@ContextConfiguration` annotation. The new `AnnotationConfigContextLoader` loads the bean definitions from the `@Configuration` classes.

Notice that the `WebConfig` configuration class was not included in the test because it needs to run in a Servlet context, which is not provided.

### 4.1. Using Spring Boot

Spring Boot provides several annotations to set up the Spring `ApplicationContext` for our tests in a more intuitive way.

We can load only a particular slice of the application configuration, or we can simulate the whole context startup process.

For instance, we can use the `@SpringBootTest` annotation if we want the entire context to be created without starting the server.

With that in place, we can then add the `@AutoConfigureMockMvc` to inject a `MockMvc` instance and send HTTP requests:

    @RunWith(SpringRunner.class)
    @SpringBootTest
    @AutoConfigureMockMvc
    public class FooControllerAppIntegrationTest {
    
        @Autowired
        private MockMvc mockMvc;
    
        @Test
        public void whenTestApp_thenEmptyResponse() throws Exception {
            this.mockMvc.perform(get("/foos")
                .andExpect(status().isOk())
                .andExpect(...);
        }
    
    }

To avoid creating the whole context and test only our MVC Controllers, we can use `@WebMvcTest`:

    @RunWith(SpringRunner.class)
    @WebMvcTest(FooController.class)
    public class FooControllerWebLayerIntegrationTest {
    
        @Autowired
        private MockMvc mockMvc;
    
        @MockBean
        private IFooService service;
    
        @Test()
        public void whenTestMvcController_thenRetrieveExpectedResult() throws Exception {
            // ...
    
            this.mockMvc.perform(get("/foos")
                .andExpect(...);
        }
    }

We can find detailed information on this subject on [our ‘Testing in Spring Boot' article](https://www.baeldung.com/spring-boot-testing).

## 5. The Controller

The `@RestController` is the central artifact in the entire Web Tier of the RESTful API. For the purpose of this post, the controller is modeling a simple REST resource – Foo:

    @RestController
    @RequestMapping("/foos")
    class FooController {
    
        @Autowired
        private IFooService service;
    
        @GetMapping
        public List<Foo> findAll() {
            return service.findAll();
        }
    
        @GetMapping(value = "/{id}")
        public Foo findById(@PathVariable("id") Long id) {
            return RestPreconditions.checkFound(service.findById(id));
        }
    
        @PostMapping
        @ResponseStatus(HttpStatus.CREATED)
        public Long create(@RequestBody Foo resource) {
            Preconditions.checkNotNull(resource);
            return service.create(resource);
        }
    
        @PutMapping(value = "/{id}")
        @ResponseStatus(HttpStatus.OK)
        public void update(@PathVariable( "id" ) Long id, @RequestBody Foo resource) {
            Preconditions.checkNotNull(resource);
            RestPreconditions.checkNotNull(service.getById(resource.getId()));
            service.update(resource);
        }
    
        @DeleteMapping(value = "/{id}")
        @ResponseStatus(HttpStatus.OK)
        public void delete(@PathVariable("id") Long id) {
            service.deleteById(id);
        }
    
    }

You may have noticed I'm using a straightforward, Guava style `RestPreconditions` utility:

    public class RestPreconditions {
        public static <T> T checkFound(T resource) {
            if (resource == null) {
                throw new MyResourceNotFoundException();
            }
            return resource;
        }
    }

The **Controller implementation is non-public** – this is because it doesn't need to be.

Usually, the controller is the last in the **chain of dependencies**. It receives HTTP requests from the **Spring front controller** (the `DispatcherServlet`) and simply delegates them forward to a service layer. If there's no use case where the controller has to be injected or manipulated through a direct reference, then I prefer not to declare it as public.

The request mappings are straightforward. As with any controller, the actual value of the mapping, as well as the HTTP method, determine the target method for the request. `@RequestBody` will bind the parameters of the method to the body of the HTTP request, whereas `@ResponseBody` does the same for the response and return type.

The `@RestController` is a [shorthand](https://www.baeldung.com/spring-controller-vs-restcontroller) to include both the `@ResponseBody` and the `@Controller` annotations in our class.

They also ensure that the resource will be marshalled and unmarshalled using the correct HTTP converter. Content negotiation will take place to choose which one of the active converters will be used, based mostly on the Accept header, although other HTTP headers may be used to determine the representation as well.

## 6. Mapping the HTTP Response Codes

The status codes of the HTTP response are one of the most important parts of the REST service, and the subject can quickly become very complicated. Getting these right can be what makes or breaks the service.

### 6.1. Unmapped Requests

If Spring MVC receives a request which doesn't have a mapping, it considers the request not to be allowed and returns a 405 METHOD NOT ALLOWED back to the client.

It's also a good practice to include the Allow HTTP header when returning a 405 to the client, to specify which operations are allowed. This is the standard behavior of Spring MVC and doesn't require any additional configuration.

### 6.2. Valid Mapped Requests

For any request that does have a mapping, Spring MVC considers the request valid and responds with 200 OK if no other status code is specified otherwise.

It's because of this that the controller declares different `@ResponseStatus` for the `create`, `update` and `delete` actions but not for get, which should indeed return the default 200 OK.

### 6.3. Client Error

In the case of a client error, **custom exceptions** are defined and mapped to the **appropriate error codes**.

Simply throwing these exceptions from any of the layers of the web tier will ensure Spring maps the corresponding status code on the HTTP response:

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public class BadRequestException extends RuntimeException {
    //
    }
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public class ResourceNotFoundException extends RuntimeException {
    //
    }

These exceptions are part of the REST API and, as such, should only be used in the **appropriate layers** corresponding to REST; if for instance, a DAO/DAL layer exists, it should not use the exceptions directly.

Note also that these are not checked exceptions but runtime exceptions – in line with Spring practices and idioms.

### 6.4. Using `@ExceptionHandler`

Another option to map custom exceptions on specific status codes is to use the `@ExceptionHandler` annotation in the controller. The problem with that approach is that the annotation only applies to the controller in which it's defined. This means that we need to declares in each controller individually.

Of course, there are more [ways to handle errors](https://www.baeldung.com/exception-handling-for-rest-with-spring) in both Spring and Spring Boot that offer more flexibility.

## 7. Additional Maven Dependencies

In addition to the spring-webmvc dependency [required for the standard web application](https://www.baeldung.com/spring-with-maven#mvc), we'll need to set up content marshalling and unmarshalling for the REST API:

    <dependencies>
       <dependency>
          <groupId>com.fasterxml.jackson.core</groupId>
          <artifactId>jackson-databind</artifactId>
          <version>2.9.8</version>
       </dependency>
       <dependency>
          <groupId>javax.xml.bind</groupId>
          <artifactId>jaxb-api</artifactId>
          <version>2.3.1</version>
          <scope>runtime</scope>
       </dependency>
    </dependencies>

These are the libraries used to convert the representation of the REST resource to either JSON or XML.

### 7.1. Using Spring Boot

If we want to retrieve JSON-formatted resources, Spring Boot provides support for different libraries, namely Jackson, Gson and JSON-B.

Auto-configuration is carried out by just including any of the mapping libraries in the classpath.

Usually, if we're developing a web application, we'll just add the **spring-boot-starter-web** dependency and rely on it to include all the necessary artifacts to our project:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>2.4.0</version>
    </dependency>

**Spring Boot uses Jackson by default**.

If we want to serialize our resources in an XML format, we'll have to add the Jackson XML extension (`jackson-dataformat-xml`) to our dependencies, or fallback to the JAXB implementation (provided by default in the JDK) by using the `@XmlRootElement` annotation on our resource.

## 8. Conclusion

This tutorial illustrated how to implement and configure a REST Service using Spring and Java-based configuration.

In the next articles of the series, I will focus on [Discoverability of the API](https://www.baeldung.com/restful-web-service-discoverability), advanced content negotiation and working with additional representations of a `Resource`.

All the code of this article is available [over on Github](https://github.com/eugenp/tutorials/tree/master/spring-boot-rest). This is a Maven-based project, so it should be easy to import and run as it is.
