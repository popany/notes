# [Spring Boot API documentation with Swagger](https://keepgrowing.in/java/springboot/spring-boot-api-documentation-with-swagger/)

- [Spring Boot API documentation with Swagger](#spring-boot-api-documentation-with-swagger)
  - [What we are going to build](#what-we-are-going-to-build)
  - [Requirements](#requirements)
  - [Generate Swagger schema definition](#generate-swagger-schema-definition)
    - [Add Maven dependency](#add-maven-dependency)
    - [Configure Swagger](#configure-swagger)
    - [Verify the schema definition](#verify-the-schema-definition)
    - [Declare Response Content Type](#declare-response-content-type)
  - [Generate user friendly documentation](#generate-user-friendly-documentation)
    - [Update Maven dependencies](#update-maven-dependencies)
  - [Troubleshooting](#troubleshooting)
    - [The project doesn’t use the default Spring Boot resource handling](#the-project-doesnt-use-the-default-spring-boot-resource-handling)
    - [All views are rendered by the frontend application (e.g. Angular)](#all-views-are-rendered-by-the-frontend-application-eg-angular)
    - [Generated JSON is invalid](#generated-json-is-invalid)
    - [Security config makes reaching the docs impossible](#security-config-makes-reaching-the-docs-impossible)
    - [Resources helpful in case of other problems](#resources-helpful-in-case-of-other-problems)

Each API requires comprehensive documentaiton. You can generate it using Swagger for a REST API. Its clients will get standardized and thorough insight while you won't need to worry about keeping it up to date. Learn how to configure Swagger, generate **documentation in JSON** and **render it with Swagger UI** when frontend is supported by Angular.

## What we are going to build

We are going to use [Springfox](https://springfox.github.io/springfox/) to produce **two versions of the docs**:

- Swagger schema in JSON;
- more human-approachable documentation rendered by Swagger UI.

Our application can be built into a single jar along with the frontend, which is based on Angular 7. Since [Spring Boot had to surrender routing control to Angular](https://keepgrowing.in/java/springboot/make-spring-boot-surrender-routing-control-to-angular/), we have to allow it to regain command over resources needed to display the web documentation generated with Swagger UI.

The project that was used as the example for this post is available in the GitHub repository – [little-pinecone/scrum-ally](https://github.com/little-pinecone/scrum-ally).

## Requirements

We are working on a Spring Boot 2.1.2 project with the Web, JPA and H2 dependencies. You  can read about setting up a similar project with Spring Initializr in [How to create a new Spring Boot Project](https://keepgrowing.in/java/how-to-create-a-new-springboot-project/) post.

## Generate Swagger schema definition

### Add Maven dependency

Include the Maven dependency for [Springfox Swagger2](https://mvnrepository.com/artifact/io.springfox/springfox-swagger2) in the pom.xml file:

    <!--scrum-ally/backend/pom.xml-->
    …
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>2.9.2</version>
    </dependency>
    …

### Configure Swagger

In the application we are going to create a new configuration bean:

    // scrum-ally/backend/src/main/java/in/keepgrowing/scrumally/config/SwaggerConfig.java
    …
    @Configuration
    @EnableSwagger2
    public class SwaggerConfig {
     
        @Bean
        public Docket scrumAllyApi() {
            return new Docket(DocumentationType.SWAGGER_2)
                    .select()
                    .paths(regex("/api.*"))
                    .build()
                    .apiInfo(apiInfo());
        }
     
        private ApiInfo apiInfo() {
            return new ApiInfoBuilder()
                    .title("Scrum_ally API")
                    .description("Scrum_ally is a web application designed for project management")
                    .license("MIT License")
                    .licenseUrl("https://opensource.org/licenses/MIT")
                    .build();
        }
    }

- `@EnableSwagger2`

  The annotation that indicates that Swagger support should be enabled. This should be applied to a Spring java config and should have an accompanying @Configuration annotation ([source](http://springfox.github.io/springfox/javadoc/current/springfox/documentation/swagger2/annotations/EnableSwagger2.html)).

- `public Docket scrumAllyApi()`

  [Docket](http://springfox.github.io/springfox/javadoc/2.7.0/springfox/documentation/spring/web/plugins/Docket.html) is a class that offers convenient methods and many useful defaults to help you configure a subset of services to be documented.

- `.paths(regex("/api.*"))`

  A filter for selecting paths that will be documented. I want to generate docs for all endpoints that start with `/api`. You can restrict Swagger from exposing the whole application by passing here a predicament for selecting routes that will be documented.

- `.apis()`

  A filter for `RequestHandlerSelector`. You can specify a package that is going to be documented: `.apis(RequestHandlerSelectors.basePackage("in.keepgrowing…")` or you can filter endpoints using `withClassAnnotation` or `withMethodAnnotation` predicate. In the example application the regex for `paths()` is sufficient, therefore I didn’t have to override the default predicate – `any`. You can specify here to which extent the API should be documented.

- `.apiInfo(apiInfo())`

  Allows us to provide additional data about the documented API.

You can learn more about configuration options in the [Springfox Reference Documentation](https://springfox.github.io/springfox/docs/snapshot/#configuring-springfox).

### Verify the schema definition

Now, you should be able to test the configuration. Run the application locally and call the <http://localhost:8080/v2/api-docs> link in Postman.

### Declare Response Content Type

If you haven’t declared the response type in `RequestMapping` in your controllers yet, the schema generated with Swagger will reveal that your API can produce a response of any type. Mind the "*/*" in the produces field.

The solution to the problem was described in [this issue on GitHub](https://github.com/springfox/springfox/issues/808). We have to impose the "application/json" response content type on the controllers. Below, you can see the example for my `ProjectController`:

    // scrum-ally/backend/src/main/java/in/keepgrowing/scrumally/projects/ProjectController.java
    …
    @RestController
    @RequestMapping(value = "api/projects", produces = "application/json")
    public class ProjectController {
    …

After rerunning the application, we can see the proper response content type in generated documentation:

You can see the work done in this section in the [d93912fc2c170b781f3fd53b399f8efea7ac9b5d commit](https://github.com/little-pinecone/scrum-ally/commit/d93912fc2c170b781f3fd53b399f8efea7ac9b5d).

## Generate user friendly documentation

### Update Maven dependencies

Add the Maven dependency for [Springfox Swagger UI](https://mvnrepository.com/artifact/io.springfox/springfox-swagger-ui):

    <!--scrum-ally/backend/pom.xml-->
    …
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
        <version>2.9.2</version>
    </dependency>
    …

Spring Boot auto-configuration takes care of handling the resources by default. If you haven’t overwrite it, you should be able to see the documentation by visiting <http://localhost:8080/swagger-ui.html>.

You can see the work done in this section in the [885c41d3b4e15ddf4a85ef4abc58752af72825cc commit](https://github.com/little-pinecone/scrum-ally/commit/885c41d3b4e15ddf4a85ef4abc58752af72825cc).

## Troubleshooting

### The project doesn’t use the default Spring Boot resource handling

You have to manually specify the resources required by Swagger UI. See the example below:

    // scrum-ally/backend/src/main/java/in/keepgrowing/scrumally/config/MvcConfiguration.java
    …
    @Configuration
    public class MvcConfiguration implements WebMvcConfigurer {
    
        @Override
        public void addResourceHandlers(ResourceHandlerRegistry registry) {
            registry.addResourceHandler("swagger-ui.html")
                    .addResourceLocations("classpath:/META-INF/resources/");
    
            registry.addResourceHandler("/webjars/**")
                    .addResourceLocations("classpath:/META-INF/resources/webjars/");
        }
    }

### All views are rendered by the frontend application (e.g. Angular)

In our example, we have a Spring Boot API integrated with Angular and all views are rendered by the fronted. So trying to run the rendered documentation results in 'Cannot match any routes. URL Segment: 'swagger-ui.html' error. To fix this, we are going to add the "swagger-ui.html" resource handler to the registry in our MvcConfiguration:

    // scrum-ally/backend/src/main/java/in/keepgrowing/scrumally/config/MvcConfiguration.java
    …
    @Configuration
    public class MvcConfiguration implements WebMvcConfigurer {
    
        @Override
        public void addResourceHandlers(ResourceHandlerRegistry registry) {
                    …
            registry.addResourceHandler("swagger-ui.html")
                    .addResourceLocations("classpath:/META-INF/resources/");
        }
    }

### Generated JSON is invalid

You can verify the generated JSON by pasting it to the [Swagger editor](http://editor.swagger.io/). The debugging process will be more straightforward with the aid of the validation

### Security config makes reaching the docs impossible

Allow all GET requests to the documentation resources:

    // scrum-ally/backend/src/main/java/in/keepgrowing/scrumally/config/SecurityConfig.java
    …
    @Configuration
      public class WebSecurityConfiguration extends WebSecurityConfigurerAdapter {
        @Override
        protected void configure(HttpSecurity httpSecurity) throws Exception {
          http
            …
            .authorizeRequests()
            …
            .antMatchers(
              HttpMethod.GET,
              "/v2/api-docs",
              "/swagger-resources/**",
              "/swagger-ui.html**",
              "/webjars/**",
              "favicon.ico"
            ).permitAll()
            …
            .anyRequest().authenticated();
            …
        }
      }
    …

### Resources helpful in case of other problems

In the [Springfox Reference Documentation](http://springfox.github.io/springfox/docs/current/) you can find [answers to common question and problems](http://springfox.github.io/springfox/docs/current/#answers-to-common-questions-and-problems) gathered in a separate chapter.
