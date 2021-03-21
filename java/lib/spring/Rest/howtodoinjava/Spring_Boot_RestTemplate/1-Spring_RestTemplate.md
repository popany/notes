# [Spring RestTemplate](https://howtodoinjava.com/spring-boot2/resttemplate/spring-restful-client-resttemplate-example/)

- [Spring RestTemplate](#spring-resttemplate)
  - [1. Spring `RestTemplate` class](#1-spring-resttemplate-class)
  - [2. Building `RestTemplate` Bean](#2-building-resttemplate-bean)
    - [2.1. Using `RestTemplateBuilder`](#21-using-resttemplatebuilder)
    - [2.2. Using `SimpleClientHttpRequestFactory`](#22-using-simpleclienthttprequestfactory)
    - [2.3. Using Apache `HTTPClient`](#23-using-apache-httpclient)
    - [2.4. Injecting RestTemplate bean](#24-injecting-resttemplate-bean)
  - [3. Spring RestTemplate – HTTP GET Example](#3-spring-resttemplate--http-get-example)
    - [3.1. HTTP GET REST APIs](#31-http-get-rest-apis)
    - [3.2. Spring RestTemplate example to consume REST API](#32-spring-resttemplate-example-to-consume-rest-api)
    - [3.3. Spring RestTemplate example to consume API response into POJO](#33-spring-resttemplate-example-to-consume-api-response-into-pojo)
      - [Using `getForObject()` Method](#using-getforobject-method)
      - [Using `getForEntity()` Method](#using-getforentity-method)
    - [3.4. Sending HTTP Headers using `RestTemplate`](#34-sending-http-headers-using-resttemplate)
    - [3.5. Sending URL Parameters using `RestTemplate`](#35-sending-url-parameters-using-resttemplate)
  - [4. Spring RestTemplate – HTTP POST Example](#4-spring-resttemplate--http-post-example)
    - [4.1. HTTP POST REST API](#41-http-post-rest-api)
    - [4.2. Spring RestTemplate example to consume POST API](#42-spring-resttemplate-example-to-consume-post-api)
  - [5. Spring `RestTemplate` – HTTP PUT Method Example](#5-spring-resttemplate--http-put-method-example)
    - [5.1. HTTP PUT REST API](#51-http-put-rest-api)
    - [5.2. Spring `RestTemplate` example to consume PUT API](#52-spring-resttemplate-example-to-consume-put-api)
  - [6. Spring RestTemplate – HTTP DELETE Method Example](#6-spring-resttemplate--http-delete-method-example)
    - [6.1. HTTP DELETE REST API](#61-http-delete-rest-api)
    - [6.2. Spring RestTemplate example to consume DELETE API](#62-spring-resttemplate-example-to-consume-delete-api)
  - [7. RestTemplate Examples](#7-resttemplate-examples)

After learning to build Spring REST API for [XML representation](https://howtodoinjava.com/spring-rest/spring-rest-hello-world-xml-example/) and [JSON representation](https://howtodoinjava.com/spring-rest/spring-rest-hello-world-json-example/), lets learn to build Spring REST client using the Spring RestTemplate to consume the APIs which we have written in linked examples.

|||
|-|-|
Note|Spring docs recommend to use the non-blocking, reactive [WebClient](https://howtodoinjava.com/spring-webflux/webclient-get-post-example/) which offers efficient support for both sync, async and streaming scenarios. `RestTemplate` will be deprecated in the future versions.
|||

## 1. Spring `RestTemplate` class

Accessing the REST apis inside a Spring application revolves around the use of the Spring `RestTemplate` class. The `RestTemplate` class is designed on the same principles as the many other Spring `*Template` classes (e.g., `JdbcTemplate`, `JmsTemplate`), providing a simplified approach with default behaviors for performing complex tasks.

Given that the `RestTemplate` class is a **synchronous client** that is designed to call REST services. It should come as no surprise that its primary methods are closely tied to REST’s underpinnings, which are the HTTP protocol’s methods **HEAD**, **GET**, **POST**, **PUT**, **DELETE**, and **OPTIONS**.

## 2. Building `RestTemplate` Bean

The given below are few examples to create RestTemplate bean in the application. We are only looking at very simple bean definitions. For extensive configuration options, please refer to [RestTemplate Configuration with HttpClient](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-httpclient-java-config/).

### 2.1. Using `RestTemplateBuilder`

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
     
        return builder
                .setConnectTimeout(Duration.ofMillis(3000))
                .setReadTimeout(Duration.ofMillis(3000))
                .build();
    }

### 2.2. Using `SimpleClientHttpRequestFactory`

    @Bean
    public RestTemplate restTemplate() {
     
        var factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(3000);
        factory.setReadTimeout(3000);
        return new RestTemplate(factory);
    }

### 2.3. Using Apache `HTTPClient`

    @Autowired
    CloseableHttpClient httpClient;
     
    @Bean
    public RestTemplate restTemplate() {
     
        RestTemplate restTemplate = new RestTemplate(clientHttpRequestFactory());
        return restTemplate;
    }
     
    @Bean
    public HttpComponentsClientHttpRequestFactory clientHttpRequestFactory() {
     
        HttpComponentsClientHttpRequestFactory clientHttpRequestFactory 
                                = new HttpComponentsClientHttpRequestFactory();
        clientHttpRequestFactory.setHttpClient(httpClient);
        return clientHttpRequestFactory;
    }

### 2.4. Injecting RestTemplate bean

To inject the `RestTemplate` bean, use the well known `@Autowired` annotation. If you have multiple beans of type `RestTemplate` with different configurations, use the `@Qualifier` annotation as well.

    @Autowired
    private RestTemplate restTemplate;

## 3. Spring RestTemplate – HTTP GET Example

Available methods are:

- `getForObject(url, classType)` – retrieve a representation by doing a GET on the URL. The response (if any) is unmarshalled to given class type and returned.

- `getForEntity(url, responseType)` – retrieve a representation as `ResponseEntity` by doing a GET on the URL.

- `exchange(requestEntity, responseType)` – execute the specified `RequestEntity` and return the response as `ResponseEntity`.

- `execute(url, httpMethod, requestCallback, responseExtractor)` – execute the `httpMethod` to the given URI template, preparing the request with the `RequestCallback`, and reading the response with a `ResponseExtractor`.

### 3.1. HTTP GET REST APIs

    @GetMapping(value = "/employees", 
            produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public EmployeeListVO getAllEmployees(
            @RequestHeader(name = "X-COM-PERSIST", required = true) String headerPersist,
            @RequestHeader(name = "X-COM-LOCATION", defaultValue = "ASIA") String headerLocation) 
    {
        LOGGER.info("Header X-COM-PERSIST :: " + headerPersist);
        LOGGER.info("Header X-COM-LOCATION :: " + headerLocation);
         
        EmployeeListVO employees = getEmployeeList();
        return employees;
    }
     
    @GetMapping(value = "/employees/{id}", 
            produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<EmployeeVO> getEmployeeById (@PathVariable("id") Integer id) 
    {
        LOGGER.info("Requested employee id :: " + id);
         
        if (id != null && id > 0) {
            //TODO: Fetch the employee and return from here
            EmployeeVO employee = new EmployeeVO(id, "Lokesh","Gupta", "howtodoinjava@gmail.com");
            return new ResponseEntity<EmployeeVO>(employee, HttpStatus.OK);
        }
        return new ResponseEntity<EmployeeVO>(HttpStatus.NOT_FOUND);
    }

### 3.2. Spring RestTemplate example to consume REST API

In the given example, we are fetching the API response as a JSON string. We need to use `ObjectMapper` to parse it to the POJO before using it in the application.

`getForObject()` method is pretty useful when we are getting an unparsable response from the server, and we have no control to get it fixed on the server-side. Here, we can get the response as `String`, and use a custom parser or use a string replacement function to fix the response before handling it to the parser.

    private static void getEmployees()
    {
        final String uri = "http://localhost:8080/springrestexample/employees";
     
        //TODO: Autowire the RestTemplate in all the examples
        RestTemplate restTemplate = new RestTemplate();
     
        String result = restTemplate.getForObject(uri, String.class);
        System.out.println(result);
    }

Read More: [Converting JSON String to Object using Jackson 2](https://howtodoinjava.com/jackson/jackson-2-convert-json-to-from-java-object/)

### 3.3. Spring RestTemplate example to consume API response into POJO

In the given example, we are fetching the API response directly into the domain object.

#### Using `getForObject()` Method

    private static void getEmployees()
    {
        final String uri = "http://localhost:8080/springrestexample/employees";
        RestTemplate restTemplate = new RestTemplate();
         
        EmployeeListVO result = restTemplate.getForObject(uri, EmployeeListVO.class);
         
        //Use the response
    }

#### Using `getForEntity()` Method

    private static void getEmployees()
    {
        final String uri = "http://localhost:8080/springrestexample/employees";
        RestTemplate restTemplate = new RestTemplate();
     
        ResponseEntity<EmployeeListVO> response = restTemplate.getForEntity(uri, EmployeeListVO.class);
     
        //Use the response.getBody()
    }

### 3.4. Sending HTTP Headers using `RestTemplate`

    private static void getEmployees()
    {
        final String uri = "http://localhost:8080/springrestexample/employees";
        RestTemplate restTemplate = new RestTemplate();
         
        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
        headers.set("X-COM-PERSIST", "NO");
        headers.set("X-COM-LOCATION", "USA");
     
        HttpEntity<String> entity = new HttpEntity<String>(headers);
         
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
         
        //Use the response.getBody()
    }

### 3.5. Sending URL Parameters using `RestTemplate`

    private static void getEmployeeById()
    {
        final String uri = "http://localhost:8080/springrestexample/employees/{id}";
        RestTemplate restTemplate = new RestTemplate();
         
        Map<String, String> params = new HashMap<String, String>();
        params.put("id", "1");
         
        EmployeeVO result = restTemplate.getForObject(uri, EmployeeVO.class, params);
         
        //Use the result
    }

## 4. Spring RestTemplate – HTTP POST Example

Available methods are:

- `postForObject(url, request, classType)` – POSTs the given object to the URL, and returns the representation found in the response as given class type.

- `postForEntity(url, request, responseType)` – POSTs the given object to the URL, and returns the response as `ResponseEntity`.

- `postForLocation(url, request, responseType)` – POSTs the given object to the URL, and returns returns the value of the Location header.

- `exchange(url, requestEntity, responseType)`

- `execute(url, httpMethod, requestCallback, responseExtractor)`

### 4.1. HTTP POST REST API

The POST API, we will consume in this example.

    @PostMapping(value = "/employees")
    public ResponseEntity<String> createEmployee(EmployeeVO employee) 
    {
        //TODO: Save employee details which will generate the employee id
        employee.setId(111);
         
        //Build URI
         URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                             .path("/{id}")
                             .buildAndExpand(employee.getId())
                             .toUri();
        return ResponseEntity.created(location).build();
    }

### 4.2. Spring RestTemplate example to consume POST API

Spring REST client using `RestTemplate` to access HTTP POST api requests.

    private static void createEmployee()
    {
        final String uri = "http://localhost:8080/springrestexample/employees";
        RestTemplate restTemplate = new RestTemplate();
     
        EmployeeVO newEmployee = new EmployeeVO(-1, "Adam", "Gilly", "test@email.com");
         
        EmployeeVO result = restTemplate.postForObject( uri, newEmployee, EmployeeVO.class);
     
        System.out.println(result);
    }

## 5. Spring `RestTemplate` – HTTP PUT Method Example

Available methods are:

- `put(url, request)` – PUTs the given request object to URL.

### 5.1. HTTP PUT REST API

    @PutMapping(value = "/employees/{id}")
    public ResponseEntity<EmployeeVO> updateEmployee(@PathVariable("id") int id
                    ,EmployeeVO employee) 
    {
        //TODO: Save employee details
        return new ResponseEntity<EmployeeVO>(employee, HttpStatus.OK);
    }

### 5.2. Spring `RestTemplate` example to consume PUT API

    private static void updateEmployee()
    {
        final String uri = "http://localhost:8080/springrestexample/employees/{id}";
        RestTemplate restTemplate = new RestTemplate();
         
        Map<String, String> params = new HashMap<String, String>();
        params.put("id", "2");
         
        EmployeeVO updatedEmployee = new EmployeeVO(2, "New Name", "Gilly", "test@email.com");
         
        restTemplate.put ( uri, updatedEmployee, params );
    }

## 6. Spring RestTemplate – HTTP DELETE Method Example

Available methods are:

- `delete(url)` – deletes the resource at the specified URL.

### 6.1. HTTP DELETE REST API

    @DeleteMapping(value = "/employees/{id}")
    public ResponseEntity<String> deleteEmployee(@PathVariable("id") int id) 
    {
        //TODO: Delete the employee record
        return new ResponseEntity<String>(HttpStatus.OK);
    }

### 6.2. Spring RestTemplate example to consume DELETE API

    private static void deleteEmployee()
    {
        final String uri = "http://localhost:8080/springrestexample/employees/{id}";
        RestTemplate restTemplate = new RestTemplate();
         
        Map<String, String> params = new HashMap<String, String>();
        params.put("id", "2");
         
        restTemplate.delete ( uri,  params );
    }

Feel free to copy and modify above Spring RestTemplate examples for building the Spring REST API Consumer in your Spring WebMVC application.

## 7. RestTemplate Examples

[Spring RestTemplate basic authentication example](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-basicauth-example/)

[Spring RestTemplate timeout configuration example](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-timeout-example/)

[Spring RestTemplateBuilder Example](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-builder/)

[Spring RestTemplate – HttpClient configuration example](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-httpclient-java-config/)

[Spring Boot RestTemplate GET Example](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-get-example/)

[Spring Boot RestTemplate POST Example](https://howtodoinjava.com/spring-boot2/resttemplate/resttemplate-post-json-example/)

[Spring boot JUnit example with RestTemplate](https://howtodoinjava.com/spring-boot2/testing/spring-boot-junit-resttemplate/)

[Spring boot TestRestTemplate POST with headers example](https://howtodoinjava.com/spring-boot2/testing/testresttemplate-post-example/)

[Spring ClientHttpRequestInterceptor with RestTemplate](https://howtodoinjava.com/spring-boot2/resttemplate/clienthttprequestinterceptor/)
