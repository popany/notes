# [Spring Boot REST – Consume and Produce JSON](https://howtodoinjava.com/spring-boot2/rest/consume-produce-json/)

- [Spring Boot REST – Consume and Produce JSON](#spring-boot-rest--consume-and-produce-json)
  - [1. JSON Support in Spring boot](#1-json-support-in-spring-boot)
  - [2. Jackson](#2-jackson)
    - [2.1. Auto Configuration](#21-auto-configuration)
    - [2.2. JSON Response](#22-json-response)
    - [2.3. Customize Jackson ObjectMapper](#23-customize-jackson-objectmapper)
      - [2.3.1. Property Configuration](#231-property-configuration)
      - [2.3.2. Bean Configurations](#232-bean-configurations)
  - [3. Gson](#3-gson)
    - [3.1. Dependency](#31-dependency)
    - [3.2. Auto Configuration](#32-auto-configuration)
    - [3.3. Customization](#33-customization)
  - [4. JSON-B](#4-json-b)
    - [4.1. Dependency](#41-dependency)
    - [4.2. Auto Configuration](#42-auto-configuration)

Learn to create spring boot REST service which accept request payload and produce response body in JSON format i.e. application/json media-type.

## 1. JSON Support in Spring boot

Spring Boot provides integration with three JSON mapping libraries.

- Gson
- Jackson
- JSON-B

Jackson is the preferred and default library in Spring boot.

## 2. Jackson

### 2.1. Auto Configuration

Spring boot, by default, includes Jackson 2 dependency and is part of spring-boot-starter-json. Using [`JacksonAutoConfiguration`](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/jackson/JacksonAutoConfiguration.java) class, spring boot automatically configures Jackson with following behavior:

- an `ObjectMapper` in case none is already configured.
- a `Jackson2ObjectMapperBuilder` in case none is already configured.
- auto-registration for all `Module` beans with all `ObjectMapper` beans (including the defaulted ones).

### 2.2. JSON Response

Any Spring `@RestController` in a Spring Boot application should **render JSON response** by default as long as Jackson2 is on the classpath.

In given example, `EmployeeList` will be **serialized by Jackson2** and serves a JSON representation to client.

    @GetMapping
    public EmployeeList getAllEmployees() 
    {
        EmployeeList list = service.getAllEmployees();
    
        return list;
    }

Similarly, for create or update operation, client can send the JSON payload in request body. In given example, `Employee` object will be populated with JSON request.

    @PostMapping
    public Employee createOrUpdateEmployee(@Valid Employee employee)
                                                    throws RecordNotFoundException {
        Employee updated = service.createOrUpdateEmployee(employee);
        return new ResponseEntity<Employee>(updated, new HttpHeaders(), HttpStatus.OK);
    }

### 2.3. Customize Jackson ObjectMapper

Spring boot auto-configures `MappingJackson2HttpMessageConverter` as one of default converters to **handle request and response body conversion**.

We can customize the default conversion behavior using either **property files** or custom **bean definitions**.

#### 2.3.1. Property Configuration

Property customization

    spring.jackson.date-format= # For instance, `yyyy-MM-dd HH:mm:ss`.
    spring.jackson.default-property-inclusion= # Controls the inclusion of properties during serialization. 
    spring.jackson.deserialization.*= # Jackson on/off features for deserialization.
    spring.jackson.generator.*= # Jackson on/off features for generators.
    spring.jackson.joda-date-time-format= # Joda date time format string.
    spring.jackson.locale= # Locale used for formatting.
    spring.jackson.mapper.*= # Jackson general purpose on/off features.
    spring.jackson.parser.*= # Jackson on/off features for parsers.
    spring.jackson.property-naming-strategy= # PropertyNamingStrategy.
    spring.jackson.serialization.*= # Jackson on/off features for serialization.
    spring.jackson.time-zone= #  Time zone
    spring.jackson.visibility.*= # To limit which methods (and fields) are auto-detected.

#### 2.3.2. Bean Configurations

Use anyone of below bean configuration to override to JSON behavior in spring boot.

1. `Jackson2ObjectMapperBuilderCustomizer`

    @Configuration
    public class WebConfig 
    {
        @Bean
        public Jackson2ObjectMapperBuilderCustomizer customJson()
        {
            return builder -> {
     
                // human readable
                builder.indentOutput(true);
     
                // exclude null values
                builder.serializationInclusion(JsonInclude.Include.NON_NULL);
     
                // all lowercase with under score between words
                builder.propertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
            };
        }
    }

2. `ObjectMapper`

    @Configuration
    public class WebConfig 
    {
        @Bean
        @Primary
        public ObjectMapper customJson(){
            return new Jackson2ObjectMapperBuilder()
            .indentOutput(true)
            .serializationInclusion(JsonInclude.Include.NON_NULL)
            .propertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE)
            .build();
        }
    }

3. `Jackson2ObjectMapperBuilder`

    @Configuration
    public class WebConfig 
    {
        @Bean
        public Jackson2ObjectMapperBuilder customJson() {
            return new Jackson2ObjectMapperBuilder()
                .indentOutput(true)
                .serializationInclusion(JsonInclude.Include.NON_NULL)
                .propertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
        }
    }

4. `MappingJackson2HttpMessageConverter`

    @Configuration
    public class WebConfig 
    {
        @Bean
        public MappingJackson2HttpMessageConverter customJson(){
        return new MappingJackson2HttpMessageConverter(
            new Jackson2ObjectMapperBuilder()
                .indentOutput(true)
                .serializationInclusion(JsonInclude.Include.NON_NULL)
                .propertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE)
                .build()
            );
        } 
    }

## 3. Gson

### 3.1. Dependency

Include gson in the spring boot application by adding the appropriate Gson dependency.

pom.xml

    <dependencies>
        <dependency>
          <groupId>com.google.code.gson</groupId>
          <artifactId>gson</artifactId>
          <version>2.8.5</version>
        </dependency>
    </dependencies>

### 3.2. Auto Configuration

Spring boot detects presence of Gson.class and uses GsonAutoConfiguration for configuring the Gson instance.

To Make Gson preferred json mapper, use this property in application.properties file.

spring.http.converters.preferred-json-mapper=gson

Read More : [Gson with Spring boot](https://howtodoinjava.com/spring-boot2/gson-with-spring-boot/)

### 3.3. Customization

    spring.gson.date-format= # Format to use when serializing Date objects.
    spring.gson.disable-html-escaping= # Whether to disable the escaping of HTML characters such as '<', '>', etc.
    spring.gson.disable-inner-class-serialization= # Whether to exclude inner classes during serialization.
    spring.gson.enable-complex-map-key-serialization= # Whether to enable serialization of complex map keys (i.e. non-primitives).
    spring.gson.exclude-fields-without-expose-annotation= # Whether to exclude all fields from consideration for serialization or deserialization that do not have the "Expose" annotation.
    spring.gson.field-naming-policy= # Naming policy that should be applied to an object's field during serialization and deserialization.
    spring.gson.generate-non-executable-json= # Whether to generate non executable JSON by prefixing the output with some special text.
    spring.gson.lenient= # Whether to be lenient about parsing JSON that doesn't conform to RFC 4627.
    spring.gson.long-serialization-policy= # Serialization policy for Long and long types.
    spring.gson.pretty-printing= # Whether to output serialized JSON that fits in a page for pretty printing.
    spring.gson.serialize-nulls= # Whether to serialize null fields.

## 4. JSON-B

JSON Binding ([JSON-B](http://json-b.net/index.html)) is the new Java EE specification ([JSR 367](https://jcp.org/en/jsr/detail?id=367)) for converting JSON messages to Java Objects and back. Using JSON-B, we have a standard way of handling this conversion in spring boot applications.

### 4.1. Dependency

Add the required Maven dependencies.

pom.xml

    <dependency>
        <groupId>javax.json.bind</groupId>
        <artifactId>javax.json.bind-api</artifactId>
        <version>1.0</version>
    </dependency>
    <dependency>
        <groupId>org.eclipse</groupId>
        <artifactId>yasson</artifactId>
        <version>1.0</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish</groupId>
        <artifactId>javax.json</artifactId>
        <version>1.1</version>
    </dependency>

### 4.2. Auto Configuration

Set the prereffed JSON mapper to JSON-B.

    spring.http.converters.preferred-json-mapper=jsonb

With that in place, now all request and response conversions in spring boot with happen using JSON-B.
