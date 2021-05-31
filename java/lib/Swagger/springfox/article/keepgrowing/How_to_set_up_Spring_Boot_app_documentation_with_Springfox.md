# [How to set up Spring Boot app documentation with Springfox](https://keepgrowing.in/tools/how-to-set-up-spring-boot-app-documentation-with-springfox-3/)

- [How to set up Spring Boot app documentation with Springfox](#how-to-set-up-spring-boot-app-documentation-with-springfox)
  - [Add Springfox Boot starter](#add-springfox-boot-starter)
  - [Adjust the security config](#adjust-the-security-config)
  - [Useful links](#useful-links)

Learn how to generate documentation for your Spring Boot application using [Springfox Boot Starter](https://mvnrepository.com/artifact/io.springfox/springfox-boot-starter). This article extends the [Spring Boot API documentation with Swagger](https://keepgrowing.in/java/springboot/spring-boot-api-documentation-with-swagger/) post.

In order to see an example Spring Boot project where the starter replaced the older Springfox version, visit the [951ba8dc0fd805c21daf8a483ab730b19f30677f commit](https://github.com/little-pinecone/scrum-ally/commit/951ba8dc0fd805c21daf8a483ab730b19f30677f).

## Add Springfox Boot starter

First, add the maven dependency to your pom.xml file:

    <!-- pom.xml -->
    …
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-boot-starter</artifactId>
        <version>3.0.0</version>
    </dependency>

Second, create a class where we’re going to configure Swagger docs, like in my example SwaggerConfig.java file from the scrum_ally project:

    package in.keepgrowing.scrumally.config;
    
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import springfox.documentation.builders.ApiInfoBuilder;
    import springfox.documentation.service.ApiInfo;
    import springfox.documentation.spi.DocumentationType;
    import springfox.documentation.spring.web.plugins.Docket;
    
    import static springfox.documentation.builders.PathSelectors.regex;
    
    @Configuration
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

Finally, we have to configure handling resources. You’ll find the example config from the Springfox documentation below:

    public class SwaggerUiWebMvcConfigurer implements WebMvcConfigurer {
      private final String baseUrl;
     
      public SwaggerUiWebMvcConfigurer(String baseUrl) {
        this.baseUrl = baseUrl;
      }
     
      @Override
      public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String baseUrl = StringUtils.trimTrailingCharacter(this.baseUrl, '/');
        registry.
            addResourceHandler(baseUrl + "/swagger-ui/**")
            .addResourceLocations("classpath:/META-INF/resources/webjars/springfox-swagger-ui/")
            .resourceChain(false);
      }
     
      @Override
      public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController(baseUrl + "/swagger-ui/")
            .setViewName("forward:" + baseUrl + "/swagger-ui/index.html");
      }
    }

The scrum_ally project uses Angular, so the its configuration is a little bit different, you can find it in the [MvcConfiguration](https://github.com/little-pinecone/scrum-ally/blob/master/backend/src/main/java/in/keepgrowing/scrumally/config/MvcConfiguration.java) file.

In the end, we can finally start our app and see the documentation. We should be able to get the project specification in json by calling the <http://localhost:8080/v3/api-docs> endpoint

Furthermore, we also can see the documentation in Swagger UI on <http://localhost:8080/swagger-ui/>

## Adjust the security config

In order to allow all GET requests to the documentation resources when your project uses Spring Boot security starter, add this matcher to your config:

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

## Useful links

- [Migrating Springfox from existing 2.x version](http://springfox.github.io/springfox/docs/current/#migrating-from-existing-2-x-version)
- What is [Swagger UI](https://swagger.io/tools/swagger-ui/)
- [Online editor for the project specification](https://editor.swagger.io/) where you can paste the json from the <http://localhost:8080/v3/api-docs>
