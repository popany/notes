# [Guide to Spring @Autowired](https://www.baeldung.com/spring-autowire)

- [Guide to Spring @Autowired](#guide-to-spring-autowired)
  - [1. Overview](#1-overview)
  - [2. Enabling @Autowired Annotations](#2-enabling-autowired-annotations)
  - [3. Using @Autowired](#3-using-autowired)
    - [3.1. @Autowired on Properties](#31-autowired-on-properties)
    - [3.2. @Autowired on Setters](#32-autowired-on-setters)
    - [3.3. @Autowired on Constructors](#33-autowired-on-constructors)
    - [4. @Autowired and Optional Dependencies](#4-autowired-and-optional-dependencies)
  - [5. Autowire Disambiguation](#5-autowire-disambiguation)
    - [5.1. Autowiring by @Qualifier](#51-autowiring-by-qualifier)
    - [5.2. Autowiring by Custom Qualifier](#52-autowiring-by-custom-qualifier)
    - [5.3. Autowiring by Name](#53-autowiring-by-name)
  - [6. Conclusion](#6-conclusion)

## 1. Overview

Starting with Spring 2.5, the framework introduced annotations-driven Dependency Injection. The main annotation of this feature is @Autowired. It allows Spring to resolve and inject collaborating beans into our bean.

## 2. Enabling @Autowired Annotations

The Spring framework enables automatic dependency injection. In other words, **by declaring all the bean dependencies in a Spring configuration file**, Spring container can **autowire relationships between collaborating beans**. This is called Spring bean autowiring.

To use Java-based configuration in our application, let's enable annotation-driven injection to load our Spring configuration:

    @Configuration
    @ComponentScan("com.baeldung.autowire.sample")
    public class AppConfig {}

Alternatively, the `<context:annotation-config>` annotation is mainly used to activate the dependency injection annotations in Spring XML files.

Moreover, Spring Boot introduces the `@SpringBootApplication` annotation. This single annotation is equivalent to using `@Configuration`, `@EnableAutoConfiguration`, and `@ComponentScan`.

Let's use this annotation in the main class of the application:

    @SpringBootApplication
    class VehicleFactoryApplication {
        public static void main(String[] args) {
            SpringApplication.run(VehicleFactoryApplication.class, args);
        }
    }

As a result, when we run this Spring Boot application, it will automatically **scan the components in the current package and its sub-packages**. Thus it will **register them in Spring's Application Context**, and **allow us to inject beans using @Autowired**.

## 3. Using @Autowired

After enabling annotation injection, we can use autowiring on **properties**, **setters**, and **constructors**.

### 3.1. @Autowired on Properties

Let’s see how we can annotate a property using `@Autowired`. This eliminates the need for getters and setters.

First, let's **define a `fooFormatter` bean**:

    @Component("fooFormatter")
    public class FooFormatter {
        public String format() {
            return "foo";
        }
    }

Then, we'll inject this bean into the `FooService` bean using `@Autowired` on the field definition:

    @Component
    public class FooService {  
        @Autowired
        private FooFormatter fooFormatter;
    }

As a result, Spring injects `fooFormatter` when `FooService` is created.

### 3.2. @Autowired on Setters

Now let's try adding `@Autowired` annotation on a `setter` method.

In the following example, the `setter` method is called with the instance of `FooFormatter` when `FooService` is created:

    public class FooService {
        private FooFormatter fooFormatter;
        @Autowired
        public void setFooFormatter(FooFormatter fooFormatter) {
            this.fooFormatter = fooFormatter;
        }
    }

### 3.3. @Autowired on Constructors

Finally, let's use `@Autowired` on a constructor.

We'll see that an instance of `FooFormatter` is injected by Spring as an argument to the `FooService` constructor:

    public class FooService {
        private FooFormatter fooFormatter;
        @Autowired
        public FooService(FooFormatter fooFormatter) {
            this.fooFormatter = fooFormatter;
        }
    }

### 4. @Autowired and Optional Dependencies

When a bean is being constructed, the `@Autowired` dependencies should be available. Otherwise, if Spring cannot resolve a bean for wiring, it will throw an exception.

Consequently, it prevents the Spring container from launching successfully with an exception of the form:

    Caused by: org.springframework.beans.factory.NoSuchBeanDefinitionException: 
    No qualifying bean of type [com.autowire.sample.FooDAO] found for dependency: 
    expected at least 1 bean which qualifies as autowire candidate for this dependency. 
    Dependency annotations: 
    {@org.springframework.beans.factory.annotation.Autowired(required=true)}

To fix this, we need to declare a bean of the required type:

    public class FooService {
        @Autowired(required = false)
        private FooDAO dataAccessor; 
    }

## 5. Autowire Disambiguation

By default, Spring resolves `@Autowired` entries **by type**. If more than one bean of the same type is available in the container, the framework will throw a fatal exception.

To resolve this conflict, we need to tell Spring explicitly which bean we want to inject.

### 5.1. Autowiring by @Qualifier

For instance, let's see how we can use the `@Qualifier` annotation to indicate the required bean.

First, we'll define 2 beans of type Formatter:

    @Component("fooFormatter")
    public class FooFormatter implements Formatter {
        public String format() {
            return "foo";
        }
    }
    @Component("barFormatter")
    public class BarFormatter implements Formatter {
        public String format() {
            return "bar";
        }
    }

Now let's try to inject a Formatter bean into the FooService class:

    public class FooService {
        @Autowired
        private Formatter formatter;
    }

In our example, there are two concrete implementations of Formatter available for the Spring container. As a result, Spring will throw a `NoUniqueBeanDefinitionException` exception when constructing the `FooService`:

    Caused by: org.springframework.beans.factory.NoUniqueBeanDefinitionException: 
    No qualifying bean of type [com.autowire.sample.Formatter] is defined: 
    expected single matching bean but found 2: barFormatter,fooFormatter

We can avoid this by narrowing the implementation using a `@Qualifier` annotation:

    public class FooService {
        @Autowired
        @Qualifier("fooFormatter")
        private Formatter formatter;
    }

When there are multiple beans of the same type, it's a good idea to **use `@Qualifier` to avoid ambiguity**.

Please note that the value of the `@Qualifier` annotation matches with the name declared in the `@Component` annotation of our `FooFormatter` implementation.

### 5.2. Autowiring by Custom Qualifier

Spring also allows us to create our own custom `@Qualifier` annotation. To do so, we should provide the `@Qualifier` annotation with the definition:

    @Qualifier
    @Target({
    ElementType.FIELD, ElementType.METHOD, ElementType.TYPE, ElementType.PARAMETER})
    @Retention(RetentionPolicy.RUNTIME)
    public @interface FormatterType {  
        String value();
    }

Then we can use the `FormatterType` within various implementations to specify a custom value:

    @FormatterType("Foo")
    @Component
    public class FooFormatter implements Formatter {
        public String format() {
            return "foo";
        }
    }
    @FormatterType("Bar")
    @Component
    public class BarFormatter implements Formatter {
        public String format() {
            return "bar";
        }
    }

Finally, our custom Qualifier annotation is ready to use for autowiring:

    @Component
    public class FooService {  
        @Autowired
        @FormatterType("Foo")
        private Formatter formatter;
    }

The value specified in the `@Target` meta-annotation restricts where to apply the qualifier, which in our example is **fields**, **methods**, **types**, and **parameters**.

### 5.3. Autowiring by Name

Spring uses the bean's name as a default qualifier value. It will inspect the container and look for a bean with the exact name as the property to autowire it.

Hence, in our example, Spring matches the `fooFormatter` property name to the `FooFormatter` implementation. Therefore, it injects that specific implementation when constructing `FooService`:

    public class FooService {
    @Autowired 
    private Formatter fooFormatter; 
    }

## 6. Conclusion

In this article, we discussed autowiring and the different ways to use it. We also examined ways to solve two common autowiring exceptions caused by either a missing bean or an ambiguous bean injection.
