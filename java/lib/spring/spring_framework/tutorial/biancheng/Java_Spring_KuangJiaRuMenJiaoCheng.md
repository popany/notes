# [Java Spring框架入门教程](http://c.biancheng.net/spring/)

- [Java Spring框架入门教程](#java-spring框架入门教程)
  - [Java Spring框架是什么？它有哪些好处？](#java-spring框架是什么它有哪些好处)
  - [Spring体系结构详解](#spring体系结构详解)
  - [Spring目录结构和基础JAR包介绍](#spring目录结构和基础jar包介绍)
  - [Spring IoC容器：BeanFactory和ApplicationContext](#spring-ioc容器beanfactory和applicationcontext)
    - [BeanFactory](#beanfactory)
    - [ApplicationContext](#applicationcontext)
      - [1) ClassPathXmlApplicationContext](#1-classpathxmlapplicationcontext)
      - [2) FileSystemXmlApplicationContext](#2-filesystemxmlapplicationcontext)

## [Java Spring框架是什么？它有哪些好处？](http://c.biancheng.net/view/4241.html)

TOOD spring 框架入门教程

## [Spring体系结构详解](http://c.biancheng.net/view/4242.html)

TOOD spring 框架入门教程

## [Spring目录结构和基础JAR包介绍](http://c.biancheng.net/view/4244.html)

TOOD spring 框架入门教程

## [Spring IoC容器：BeanFactory和ApplicationContext](http://c.biancheng.net/view/4248.html)

IoC 是指在程序开发中，**实例**的创建不再由调用者管理，而是**由 Spring 容器创建**。Spring 容器会负责控制程序之间的关系，而不是由程序代码直接控制，因此，控制权由程序代码转移到了 Spring 容器中，控制权发生了反转，这就是 Spring 的 IoC 思想。

Spring 提供了**两种 IoC 容器**，分别为 `BeanFactory` 和 `ApplicationContext`，接下来将针对这两种 IoC 容器进行详细讲解。

### BeanFactory

BeanFactory 是**基础类型的 IoC 容器**，它由 org.springframework.beans.facytory.BeanFactory 接口定义，并提供了完整的 IoC 服务支持。简单来说，BeanFactory 就是一个**管理 Bean 的工厂**，它主要负责初始化各种 Bean，并调用它们的生命周期方法。

BeanFactory 接口有多个实现类，最常见的是 org.springframework.beans.factory.xml.XmlBeanFactory，它是根据 XML 配置文件中的定义装配 Bean 的。

创建 BeanFactory 实例时，需要提供 Spring 所管理容器的详细配置信息，这些信息通常采用 XML 文件形式管理。其加载配置信息的代码具体如下所示：

    BeanFactory beanFactory = new XmlBeanFactory(new FileSystemResource("D://applicationContext.xml"));

### ApplicationContext

ApplicationContext 是 BeanFactory 的**子接口**，也被称为应用上下文。该接口的全路径为 org.springframework.context.ApplicationContext，它不仅**提供了 BeanFactory 的所有功能**，还添加了对 i18n（国际化）、资源访问、事件传播等方面的良好支持。

ApplicationContext 接口有两个常用的实现类，具体如下。

#### 1) ClassPathXmlApplicationContext

该类**从类路径 ClassPath 中寻找指定的 XML 配置文件**，找到并装载完成 ApplicationContext 的实例化工作，具体如下所示。

    ApplicationContext applicationContext = new ClassPathXmlApplicationContext(String configLocation);

在上述代码中，configLocation 参数用于指定 Spring 配置文件的名称和位置，如 applicationContext.xml。

#### 2) FileSystemXmlApplicationContext

该类**从指定的文件系统路径中寻找指定的 XML 配置文件**，找到并装载完成 ApplicationContext 的实例化工作，具体如下所示。

    ApplicationContext applicationContext = new FileSystemXmlApplicationContext(String configLocation);

它与 ClassPathXmlApplicationContext 的区别是：在读取 Spring 的配置文件时，FileSystemXmlApplicationContext 不再从类路径中读取配置文件，而是通过参数指定配置文件的位置，它可以获取类路径之外的资源，如“F:/workspaces/applicationContext.xml”。

在使用 Spring 框架时，可以通过实例化其中任何一个类创建 Spring 的 ApplicationContext 容器。

通常在 Java 项目中，会采用通过 ClassPathXmlApplicationContext 类实例化 ApplicationContext 容器的方式，而在 **Web 项目**中，ApplicationContext 容器的实例化工作会交由 Web 服务器完成。Web 服务器实例化 ApplicationContext 容器通常使用基于 ContextLoaderListener 实现的方式，它只需要在 web.xml 中添加如下代码：

    <!--指定Spring配置文件的位置，有多个配置文件时，以逗号分隔-->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <!--spring将加载spring目录下的applicationContext.xml文件-->
        <param-value>
            classpath:spring/applicationContext.xml
        </param-value>
    </context-param>
    <!--指定以ContextLoaderListener方式启动Spring容器-->
    <listener>
        <listener-class>
            org.springframework.web.context.ContextLoaderListener
        </listener-class>
    </listener>

需要注意的是，BeanFactory 和 ApplicationContext 都是通过 XML 配置文件加载 Bean 的。

二者的主要区别在于，如果 Bean 的某一个属性没有注入，则使用 BeanFacotry 加载后，在第一次调用 getBean() 方法时会抛出异常，而 ApplicationContext 则在初始化时自检，这样有利于检查所依赖的属性是否注入。

因此，在实际开发中，**通常都选择使用 ApplicationContext**，而只有在系统资源较少时，才考虑使用 BeanFactory。本教程中使用的就是 ApplicationContext。











TODO Spring 框架入门教程 xxxxxxxxxxxxxxxxxxx
