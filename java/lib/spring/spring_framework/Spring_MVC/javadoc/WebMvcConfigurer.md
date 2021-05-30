# [Interface WebMvcConfigurer](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/config/annotation/WebMvcConfigurer.html)

- [Interface WebMvcConfigurer](#interface-webmvcconfigurer)
  - [Method](#method)
    - [`addInterceptors`](#addinterceptors)
    - [`addResourceHandlers`](#addresourcehandlers)
    - [`addCorsMappings`](#addcorsmappings)
    - [`addViewControllers`](#addviewcontrollers)

Interface WebMvcConfigurer

    public interface WebMvcConfigurer

Defines callback methods to customize the Java-based configuration for Spring MVC enabled via `@EnableWebMvc`.

`@EnableWebMvc`-annotated configuration classes may implement this interface to be called back and given a chance to customize the default configuration.

## Method

### `addInterceptors`

    default void addInterceptors(InterceptorRegistry registry)

Add Spring MVC lifecycle interceptors for pre- and post-processing of controller method invocations and resource handler requests. Interceptors can be registered to apply to all requests or be limited to a subset of URL patterns.

### `addResourceHandlers`

    default void addResourceHandlers(ResourceHandlerRegistry registry)

Add handlers to serve static resources such as images, js, and, css files from specific locations under web application root, the classpath, and others.

### `addCorsMappings`

    default void addCorsMappings(CorsRegistry registry)

Configure "global" cross origin request processing. The configured CORS mappings apply to annotated controllers, functional endpoints, and static resources.

Annotated controllers can further declare more fine-grained config via [`@CrossOrigin`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/CrossOrigin.html). In such cases "global" CORS configuration declared here is [combined](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/cors/CorsConfiguration.html#combine-org.springframework.web.cors.CorsConfiguration-) with local CORS configuration defined on a controller method.

### `addViewControllers`

    default void addViewControllers(ViewControllerRegistry registry)

Configure simple automated controllers pre-configured with the response status code and/or a view to render the response body. This is useful in cases where there is no need for custom controller logic -- e.g. render a home page, perform simple site URL redirects, return a 404 status with HTML content, a 204 with no content, and more.





