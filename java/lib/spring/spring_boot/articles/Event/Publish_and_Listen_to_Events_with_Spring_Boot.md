# [Publish and Listen to Events with Spring Boot](https://codetober.com/publish-and-listen-to-events-with-spring-boot/)

- [Publish and Listen to Events with Spring Boot](#publish-and-listen-to-events-with-spring-boot)
  - [Summary](#summary)
  - [Creating a Custom ApplicationEvent](#creating-a-custom-applicationevent)
    - [Person Class](#person-class)
    - [PersonChangedEvent](#personchangedevent)
  - [Publish a Custom Event](#publish-a-custom-event)
    - [Service for publishing](#service-for-publishing)
  - [Listen for a Custom Event](#listen-for-a-custom-event)

## Summary

This guide covers how to publish and listen to events with Spring Boot. Custom events are a great way to trigger functionality **without adding bloat to your existing business logic**. The pub-sub pattern is excellent for **horizontally scaling logic** in your Spring Boot application. To do this, we will be creating our own **subclass of the `ApplicationEvent`**.

With micro-service architectures becoming increasingly popular, knowing how to interact with application events is a crucial skill. By the end of this guide you should be able to handle custom events in any Spring Boot application.

## Creating a Custom ApplicationEvent

In this guide our main Object is a `Person` and we want to trigger an event when a new `Person` instance is **created or changed**. Therefore, our custom event will be `PersonChangedEvent`.

### Person Class

    public class Person {
        private String firstname;
        private String lastname;
         
        public String getFirstname() {
            return firstname;
        }
        public void setFirstname(String firstname) {
            this.firstname = firstname;
        }
        public String getLastname() {
            return lastname;
        }
        public void setLastname(String lastname) {
            this.lastname = lastname;
        }
    }

### PersonChangedEvent

    public class PersonChangedEvent extends ApplicationEvent {
        private Person person;
     
        public PersonChangedEvent(Person person, Object source) {
            super(source);
            this.person = person;
        }
         
        public Person getPerson() {
            return this.person;
        }
    }

Notice that our custom event extends `ApplicationEvent`, this is the base type for many of pre-existing events used in Spring Boot such as `ApplicationReadyEvent`.

When our `PersonService` alters a `Person` instance, we will publish one of these events and attach the changed `Person` to the event.

## Publish a Custom Event

Our `ChangeEventPublisher` is a very simple class. It just creates an instance of the `PersonChangedEvent` and then publishes it for any configured listeners. Publishing is facilitated by the `@Autowired` `ApplicationEventPublisher`.

    @Component
    public class ChangeEventPublisher {
        @Autowired
        private ApplicationEventPublisher publisher;
         
        public void publishPersonChange(Person person) {
            PersonChangedEvent pce = new PersonChangedEvent(person, this);
            this.publisher.publishEvent(pce);
        }
    }

### Service for publishing

In an effort to keep our `Person` model clean, we are **manipulating the `Person` from a service**, which also publishes change events. You could choose to publish events directly from the model.

This service has a single method which creates a new `Person` class and then publishes an event before returning the `Person` instance.

    @Service
    public class PersonService {
        @Autowired
        private ChangeEventPublisher publisher;
         
        public Person createPerson(String firstname, String lastname) {
            Person p = new Person();
            p.setFirstname(firstname);
            p.setLastname(lastname);
             
            //Emit Event
            this.publisher.publishPersonChange(p);
             
            return p;
        }
    }

## Listen for a Custom Event

It’s finally time to do something with our new event. To keep the example simple, our `ChangeEventListener` is listening for new `PersonChangeEvents` and printing the details of the `Person` to standard out. This is normally where you could push the event into your [MongoDB instance](https://codetober.com/learn-spring-boot-2-mongodb-atlas/) or event sourcing architecture, like [Apache Kafka](https://kafka.apache.org/).

    @Component
    public class ChangeEventListener implements ApplicationListener<PersonChangedEvent> {
        @Override
        public void onApplicationEvent(PersonChangedEvent event) {
            Person person = event.getPerson();
            System.out.println("PersonChangedEvent: { firstname: "
                    + person.getFirstname() + ", lastname: " + person.getLastname() + "}");
        }
    }

In order to subscribe to new `PersonChangedEvents` our `ChangeEventListener` implements the `ApplicationListener` interface and override its methods. Every time this listener reacts to an event it will print a JSON representation of Person to the console.

    @SpringBootApplication
    public class EventsDemoApplication {
        public static void main(String[] args) {
            ApplicationContext context = SpringApplication.run(EventsDemoApplication.class, args);
            
            PersonService service = context.getBean(PersonService.class);
            service.createPerson("John", "Doe");
            service.createPerson("Kaela", "Jones");
        }
    }
 
// PersonChangedEvent: { firstname: John, lastname: Doe}
// PersonChangedEvent: { firstname: Kaela, lastname: Jones}

Finally, we have covered all of the pieces required to publish and listen to events in Spring Boot. Now, take this knowledge and apply it to a real-world scenario such as a [Spring Boot web service](https://codetober.com/learn-simple-rest-api-with-spring-boot/).
