# [Constructor Dependency Injection in Spring](https://www.baeldung.com/constructor-injection-in-spring)

- [Constructor Dependency Injection in Spring](#constructor-dependency-injection-in-spring)
  - [1. Introduction](#1-introduction)
  - [2. Annotation Based Configuration](#2-annotation-based-configuration)
  - [3. Implicit Constructor Injection](#3-implicit-constructor-injection)
  - [4. XML Based Configuration](#4-xml-based-configuration)
  - [5. Pros and Cons](#5-pros-and-cons)
  - [6. Conclusion](#6-conclusion)

## 1. Introduction

Arguably one of the most important development principles of modern software design is Dependency Injection (DI) which quite naturally flows out of another critically important principle: Modularity.

This article will explore a specific type of DI technique called Constructor-Based Dependency Injection within Spring – which simply put, means that required components are passed into a class at the time of instantiation.

To get started we need to import spring-context dependency in our pom.xml:

    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.2.8.RELEASE</version>
    </dependency>

Then we need to set up a **Configuration file**. This file can be either a **POJO** or if you prefer, an **XML** file.

## 2. Annotation Based Configuration

Java **configuration file** looks pretty much like a **plain-old Java object** with some additional annotations:

    @Configuration
    @ComponentScan("com.baeldung.constructordi")
    public class Config {
    
        @Bean
        public Engine engine() {
            return new Engine("v8", 5);
        }
    
        @Bean
        public Transmission transmission() {
            return new Transmission("sliding");
        }
    }

Here we are using annotations to notify Spring runtime that **this class is a provider of bean definitions** (`@Bean` annotation) and that a context scan for additional beans needs to be performed in package `com.baeldung.spring`. Next, we define a `Car` class:

    @Component
    public class Car {
    
        @Autowired
        public Car(Engine engine, Transmission transmission) {
            this.engine = engine;
            this.transmission = transmission;
        }
    }

Spring will encounter our `Car` class while doing a **package scan** and will initialize its instance by calling the `@Autowired` annotated constructor.

Instances of `Engine` and `Transmission` will be obtained by calling `@Bean` annotated methods of the `Config` class. Finally, we need to bootstrap an `ApplicationContext` using our `POJO` configuration:

    ApplicationContext context = new AnnotationConfigApplicationContext(Config.class);
    Car car = context.getBean(Car.class);

## 3. Implicit Constructor Injection

As of Spring 4.3, classes with a single constructor can **omit the `@Autowired` annotation**. A nice little bit of convenience and boilerplate removal!

On top of that, also starting with 4.3, the constructor-based injection can be leveraged in `@Configuration` annotated classes. And yes, if such a class has only one constructor the `@Autowired` annotation can be omitted as well.

## 4. XML Based Configuration

Another way to configure Spring runtime with constructor-based dependency injection is to use an **XML configuration file**:

    <bean id="toyota" class="com.baeldung.constructordi.domain.Car">
        <constructor-arg index="0" ref="engine"/>
        <constructor-arg index="1" ref="transmission"/>
    </bean>
    
    <bean id="engine" class="com.baeldung.constructordi.domain.Engine">
        <constructor-arg index="0" value="v4"/>
        <constructor-arg index="1" value="2"/>
    </bean>
    
    <bean id="transmission" class="com.baeldung.constructordi.domain.Transmission">
        <constructor-arg value="sliding"/>
    </bean>

Note that constructor-arg can accept a literal value or a reference to another bean and that an optional explicit index and type can be provided. Type and index attributes can be used to resolve ambiguity (for example if a constructor takes multiple arguments of the same type).

name attribute could also be used for xml to java variable matching, but then your code must be compiled with debug flag on.

A Spring application context, in this case, needs to be bootstrapped using `ClassPathXmlApplicationContext`:

    ApplicationContext context = new ClassPathXmlApplicationContext("baeldung.xml");
    Car car = context.getBean(Car.class);

## 5. Pros and Cons

Constructor injection has a few advantages compared to field injection.

The first benefit is **testability**. Suppose we're going to unit test a Spring bean that uses field injection:

    public class UserService {
        
        @Autowired 
        private UserRepository userRepository;
    }

During the construction of a `UserService` instance, we can't initialize the `userRepository` state. The only way to achieve this is through the Reflection API, which completely breaks encapsulation. Also, the resulting code will be less safe compared to a simple constructor call.

Additionally, with field injection, we can't enforce class-level invariants. So it's possible to have a `UserService` instance without a properly initialized `userRepository`. Therefore, we may experience random `NullPointerExceptions` here and there. Also, with constructor injection, it's easier to build immutable components.

Moreover, using constructors to create object instances is more natural from the OOP standpoint.

On the other hand, the main disadvantage of constructor injection is its verbosity especially when a bean has a handful of dependencies. Sometimes it can be a blessing in disguise, as we may try harder to keep the number of dependencies minimal.

## 6. Conclusion

This quick tutorial has showcased the basics of two distinct ways to use Constructor-Based Dependency Injection using the Spring framework.
