# [Custom Events and Generic Events in Spring](https://jstobigdata.com/spring/custom-events-and-generic-events-in-spring/)

- [Custom Events and Generic Events in Spring](#custom-events-and-generic-events-in-spring)
  - [Introduction:](#introduction)
  - [A. Synchronous custom Spring Event](#a-synchronous-custom-spring-event)
    - [1. Create the Custom event class](#1-create-the-custom-event-class)
    - [2. Create an event Listener class](#2-create-an-event-listener-class)
    - [3. Create an event Publisher class](#3-create-an-event-publisher-class)
    - [4. Publish an event and test the example](#4-publish-an-event-and-test-the-example)
    - [5. Use @EventListener to subscribe events](#5-use-eventlistener-to-subscribe-events)
  - [B. Asynchronous event listener using @async](#b-asynchronous-event-listener-using-async)
  - [C. Runtime event Filtering using SpEL](#c-runtime-event-filtering-using-spel)
  - [D. Ordering EventListeners using @Order](#d-ordering-eventlisteners-using-order)
  - [E. Generic events](#e-generic-events)
  - [Remember](#remember)

## Introduction:

In this article, you will learn about **Custom Events in Spring**. Like many capabilities provided by the Spring framework, events are one of the most useful features provided by `ApplicationContext` in Spring. Spring allows you to **publish/subscribe** events **synchronously** as well as **asynchronously**.

There are several standard Events in Spring as `ContextRefreshedEvent`, `ContextStartedEvent`, `ContextStoppedEvent`, `ContextClosedEvent`, `RequestHandledEvent` and `ServletRequestHandledEvent`. Spring also allows you to create your custom event classes based on your application need. We will first learn to create a custom event and then explore the list of standard ones in another article.

Custom events can be created synchronously as well as asynchronously. The asynchronously way of creation may look complicated but provides better performance due to the non-blocking nature of execution.

## A. Synchronous custom Spring Event

There are just few simple rules that needs to be followed to pub/sub events synchronously.

- The **event** class should extend `ApplicationEvent`.
- The **publisher** has to make use of `ApplicationEventPublisher`.
- The event **listener** should implement the `ApplicationListener`.

### 1. Create the Custom event class

The custom event class has to extend the `ApplicationEvent` abstract class. We will create a custom `UserEvent` class as below.

    package com.jsbd.events;
    import org.springframework.context.ApplicationEvent;
    import java.util.StringJoiner;
    public class UserEvent extends ApplicationEvent {
      //Custom property
      private String message;
      //Custom property
      private Integer eventId;
      public UserEvent(Object source) {
        super(source);
      }
      public UserEvent(Object source, String message,
                       Integer eventId) {
        super(source);
        this.message = message;
        this.eventId = eventId;
      }
      public String getMessage() {
        return this.message;
      }
      public Integer getEventId() {
        return this.eventId;
      }
      @Override
      public String toString() {
        return new StringJoiner(", ", UserEvent.class.getSimpleName() + "[", "]")
            .add("message='" + message + "'")
            .add("source=" + source)
            .add("eventId=" + eventId)
            .toString();
      }
    }

### 2. Create an event Listener class

We will create an `EventListener` by implementing the `ApplicationListener` interface and its method `onApplicationEvent`. As you can see this method accepts `UserEvent` as a parameter. Whenever there is an `UserEvent` published, this method will get executed.

    package com.jsbd.events;
    import org.springframework.context.ApplicationListener;
    import org.springframework.stereotype.Component;
    @Component
    public class EventListener implements ApplicationListener<UserEvent> {
      @Override
      public void onApplicationEvent(UserEvent event) {
        System.out.println("======= UserEvent Listener =======");
        System.out.println(event);
      }
    }

### 3. Create an event Publisher class

The Spring framework already provides us `ApplicationEventPublisher`, we will autowire this using `@Autowired` inside our custom event publisher class.

    @Component
    public class EventPublisher {
      @Autowired //Use setter based injection
      private ApplicationEventPublisher applicationEventPublisher;
      public void publishEvent(String message, Integer eventId) {
        applicationEventPublisher.publishEvent(
            new UserEvent(this, message, eventId)
        );
      }
    }

### 4. Publish an event and test the example

Now, we will write a simple JUnit test case to publish an event and check if the listener receives it. I have also added the configuration needed to run this example.

    @Configuration
    @ComponentScan("com.jsbd.events")
    public class AppConfig {
    }
    
    @SpringJUnitConfig(AppConfig.class)
    class EventPublisherTest {
      @Autowired
      EventPublisher eventPublisher;
      @Test
      public void sendSynchronousEvent() {
        eventPublisher.publishEvent("User registered", 101);
      }
    }

Output:

    ======= UserEvent Listener =======
    UserEvent[message='User registered', source=com.jsbd.events.EventPublisher@abf688e, eventId=101]

### 5. Use @EventListener to subscribe events

Spring 4.2 onwards, it is possible to just annotate a method with `@EventListener` annotation and have the custom event as the method parameter. Spring will mark the method as a listener for the specified event `UserEvent`.

    @Component
    public class AnnEventListener {
      @EventListener
       public void genericListener(UserEvent userEvent) {
          System.out.println("\n===== General UserEvent Listener =====");
          System.out.println(userEvent);
      }
    }

To test this method, we can just send an event using our `EventPublisher` instance as shown before. The listener will work without any extra config.

## B. Asynchronous event listener using @async

Synchronous publish-subscribe is blocking in nature, can have bad impact on application performance. To get rid of this, Spring provides asynchronous event listener using `@async` annotation.

The first step is to enable the async processing by annotating the configuration with `@EnableAsync` as below.

    @Configuration
    @ComponentScan("com.jsbd.events")
    @EnableAsync
    public class AppConfig {
      //other configs if needed
    }

Then, the second step is to use `@async` with the listener as shown below

    @Component
    public class AnnEventListener {
      //Async Event listener
      @EventListener
      @Async
      public void asyncListener(UserEvent userEvent) {
        System.out.println("===== Async UserEvent Listener =====");
        System.out.println(userEvent);
      }
    }

Optionally, if you want asynchronous message processing to be enabled **globally** for `ApplicationContext`, use the following configurations. You will not need to use `@async` annotation.

      @Bean
      @Scope("singleton")
      ApplicationEventMulticaster eventMulticaster() {
        SimpleApplicationEventMulticaster eventMulticaster 
                                                = new SimpleApplicationEventMulticaster();
        eventMulticaster.setTaskExecutor(new SimpleAsyncTaskExecutor());
        //optionally set the ErrorHandler
        eventMulticaster.setErrorHandler(TaskUtils.LOG_AND_PROPAGATE_ERROR_HANDLER);
        return eventMulticaster;
      }

## C. Runtime event Filtering using SpEL

Occasionally, you may want to filter out the events delivered to the listener. Spring allows you to define a SpEL based expression based on which the matched values are delivered to the event listener. Only the UserEvents with the eventId ==120 are delivered to this listener.

    @Component
    public class AnnEventListener {
      //Event Listener with a Spring SpEL expression
      @EventListener(condition = "#userEvent.eventId == 102")
      public void processEvent(UserEvent userEvent) {
        System.out.println("====== Conditional UserEvent Listener =====");
        System.out.println(userEvent);
      }
    }

## D. Ordering EventListeners using @Order

You can use the `@Order` annotation when you want a specific eventListener to get invoked before another one. Remember, the annotation with the least value has the highest execution priority. So in the below example, `listenerA` gets executed before `listenerB`.

    @Component
    public class AnnEventListener {
      @EventListener
      @Order(1)
      public void listenerA(UserEvent userEvent) {
        System.out.println("\n===== UserEvent ListenerA =====");
        System.out.println(userEvent);
      }
      @EventListener
      @Order(5)
      public void listenerB(UserEvent userEvent) {
        System.out.println("\n===== UserEvent ListenerB =====");
        System.out.println(userEvent);
      }
    }

## E. Generic events

Spring also allows you to use a generic event class to publish any type of event. As shown in the below code, instead of creating too many classes for each event types, you can just create a `GenericEvent` class with more properties to send any type of event.

GenericEvent.java

    public class GenericEvent<T> implements ResolvableTypeProvider {
      private T message;
      private Object source;
      public GenericEvent(Object source, T message) {
        this.source = source;
        this.message = message;
      }
      @Override
      public ResolvableType getResolvableType() {
        return ResolvableType.forClassWithGenerics(
            getClass(), ResolvableType.forInstance(getSource())
        );
      }
      public T getMessage() {
        return message;
      }
      public Object getSource() {
        return source;
      }
      @Override
      public String toString() {
        return new StringJoiner(", ", GenericEvent.class.getSimpleName() + "[", "]")
            .add("message=" + message)
            .add("source=" + source)
            .toString();
      }
    }

Once you have the GenericEvent class created, you can next create a listener by annotating the method with `@EventListener`.

    @Component
    public class GenericEventListener {
      @EventListener
      public void listenEvent(GenericEvent event) {
        System.out.println(event);
      }
    }

Now, let us publish few events and test.

GenericEventTest.java

    @SpringJUnitConfig(AppConfig.class)
    public class GenericEventTest {
      @Autowired
      private ApplicationEventPublisher eventPublisher;
      @Test
      public void publishEvent() {
        GenericEvent event1 = new GenericEvent<>(this, new Person("John"));
        GenericEvent event2 = new GenericEvent<>(this, "Hello");
        eventPublisher.publishEvent(event1);
        eventPublisher.publishEvent(event2);
      }
    }

## Remember

- Spring’s eventing mechanism is designed for simple communication between Spring beans within the **same application context**.
- However, for more sophisticated needs you can explore the [Spring Integration](https://projects.spring.io/spring-integration/) project.
