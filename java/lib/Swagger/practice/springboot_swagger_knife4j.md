# Spring Boot + Swagger + Knife4j

- [Spring Boot + Swagger + Knife4j](#spring-boot--swagger--knife4j)
  - [Spring Boot + Swagger2 2.x](#spring-boot--swagger2-2x)
    - [Spring Boot + Swagger2 2.x + Knife4j](#spring-boot--swagger2-2x--knife4j)
  - [Spring Boot + Swagger2 3.x](#spring-boot--swagger2-3x)
    - [Spring Boot + Swagger2 3.x + Knife4j](#spring-boot--swagger2-3x--knife4j)

## Spring Boot + Swagger2 2.x

reference: [Spring Boot + Swagger2](https://www.javainuse.com/spring/boot_swagger)

Dependencies

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
        <version>2.9.2</version>
    </dependency>

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>2.9.2</version>
    </dependency>

SpringFoxConfig.java

    @Configuration
    @EnableSwagger2
    public class SpringFoxConfig {

        @Bean
        public Docket api() { 
            return new Docket(DocumentationType.SWAGGER_2)  
            .select()                                  
            .apis(RequestHandlerSelectors.basePackage("org.example.todo_mvc"))
            .paths(PathSelectors.any())                          
            .build()
            .apiInfo(apiInfo());                                           
        }

        private ApiInfo apiInfo() {
            return new ApiInfoBuilder()
                    .title("Todo API")
                    .description("Todo Api")
                    .build();
        }
    }

url

    http://<ip>:<port>/swagger-ui.html

### Spring Boot + Swagger2 2.x + Knife4j

On the base of "Spring Boot + Swagger2 2.x", add Knife4j dependency

    <dependency>
        <groupId>com.github.xiaoymin</groupId>
        <artifactId>knife4j-spring-ui</artifactId>
        <version>2.0.1</version>
    </dependency>

url

    http://<ip>:<port>/doc.html

## Spring Boot + Swagger2 3.x

Dependencies

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-boot-starter</artifactId>
        <version>3.0.0</version>
    </dependency>

SpringFoxConfig.java

    @Configuration
    public class SpringFoxConfig {

        @Bean
        public Docket api() { 
            return new Docket(DocumentationType.SWAGGER_2)  
            .select()                                  
            .apis(RequestHandlerSelectors.basePackage("org.example.todo_mvc"))
            .paths(PathSelectors.any())                          
            .build()
            .apiInfo(apiInfo());                                           
        }

        private ApiInfo apiInfo() {
            return new ApiInfoBuilder()
                    .title("Todo API")
                    .description("Todo Api")
                    .build();
        }
    }

url

    http://<ip>:<port>/swagger-ui/index.html

### Spring Boot + Swagger2 3.x + Knife4j

On the base of "Spring Boot + Swagger2 3.x", add Knife4j dependency

    <dependency>
        <groupId>com.github.xiaoymin</groupId>
        <artifactId>knife4j-spring-ui</artifactId>
        <version>2.0.1</version>
    </dependency>

url

    http://<ip>:<port>/doc.html
