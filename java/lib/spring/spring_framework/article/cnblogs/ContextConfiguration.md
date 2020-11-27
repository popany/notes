# [@ContextConfiguration的意思](https://www.cnblogs.com/bihanghang/p/10023759.html)

- [@ContextConfiguration的意思](#contextconfiguration的意思)
  - [XML](#xml)
  - [Java](#java)
  - [在Spring Boot测试](#在spring-boot测试)

`@ContextConfiguration`这个注解通常与`@RunWith(SpringJUnit4ClassRunner.class)`联合使用用来测试

当一个类添加了注解`@Component`,那么他就自动变成了一个`bean`，就不需要再Spring配置文件中显示的配置了。把这些bean收集起来通常有两种方式，Java的方式和XML的方式。当这些`bean`收集起来之后，当我们想要在某个测试类使用`@Autowired`注解来引入这些收集起来的`bean`时，只需要给这个测试类添加`@ContextConfiguration`注解来标注我们想要导入这个测试类的某些`bean`。

## XML

我们先看看老年人使用的XML方式:

    <?xml version="1.0" encoding="UTF-8"?>

    <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
        xmlns:context="http://www.springframework.org/schema/context"
        xsi:schemaLocation="http://www.springframework.org/schema/beans  
        http://www.springframework.org/schema/beans/spring-beans-3.1.xsd  
        http://www.springframework.org/schema/context  
        http://www.springframework.org/schema/context/spring-context-3.1.xsd  >

        <!-- 自动扫描该包 -->
        <context:component-scan base-package="com" />
    </beans>

这个XML文件通过`<context:component-scan base-package="com" />`标签将`com`包下的`bean`全都自动扫描进来。

下面我们就可以测试了。

一般这么写:

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(locations = {"classpath*:/*.xml"})
    public class CDPlayerTest {

    }

`@ContextConfiguration`括号里的`locations = {"classpath*:/*.xml"}`就表示将`class`路径里的所有`.xml`文件都包括进来，那么刚刚创建的那么XML文件就会包括进来，那么里面自动扫描的`bean`就都可以拿到了，此时就可以在测试类中使用`@Autowired`注解来获取之前自动扫描包下的所有`bean`。

`classpath`和`classpath*`区别:

- `classpath`：只会到你的`class`路径中查找文件。

- `classpath*`：不仅包含`class`路径，还包括`jar`文件中（`class`路径）进行查找。

## Java

如果使用Java的方式就会很简单了，我们就不用写XML那么繁琐的文件了，我们可以创建一个Java类来代替XML文件，只需要在这个类上面加上`@Configuration`注解,然后再加上`@ComponentScan`注解就开启了自动扫描，如果注解没有写括号里面的东西，`@ComponentScan`默认会扫描与配置类相同的包。

    @Configuration
    @ComponentScan
    public class CDPlayConfig {

    }

此时如果想要测试的话，就可以这么写：

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(classes=CDPlayConfig.class)
    public class CDPlayerTest {

    }

相较于XML,是不是很酷炫，这也是官方提倡的方式。

## 在Spring Boot测试

    @RunWith(SpringJUnit4ClassRunner.class)
    @SpringBootTest
    public class Test {
    }

这个`@SpringBootTest`注解意思就是将SpringBoot主类中导入的`bean`全都包含进来。

此时SpringBoot主类也被当作了`bean`的收集器。类似上文的`CDPlayConfig`。

    @SpringBootApplication
    @SpringBootConfiguration
    @ComponentScan(basePackages = {"com.bihang.*"})
    public class CarOrderWebApplication extends SpringBootServletInitializer {
        @Override
        protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
            return builder.sources(CarOrderWebApplication.class);
        }

        public static void main(String[] args) {
            SpringApplication.run(CarOrderWebApplication.class, args);
        }

    }
