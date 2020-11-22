# [Servlet入门教程](http://c.biancheng.net/servlet/)

- [Servlet入门教程](#servlet入门教程)
  - [Java Servlet是什么？它有哪些特点？](#java-servlet是什么它有哪些特点)
  - [与Servlet相关的接口和类](#与servlet相关的接口和类)

Servlet 是 Server Applet 的简称，译为“服务器端小程序”。Servlet 是 Java 的一套技术标准，规定了如何使用 Java 来开发动态网站。换句话说，Java 可以用来开发网站后台，但是要提前定义好一套规范，并编写基础类库，这就是 Servlet 所做的事情。

Java Servlet 可以使用所有的 Java API，Java 能做的事情，Servlet 都能做。

这套 Servlet 入门教程对 Servlet 技术的整体框架进行了讲解，并附带了实例演示，阅读本教程需要具备 [Java 基础](http://c.biancheng.net/java/)。

Servlet 只是古老的 CGI 技术的替代品，直接使用 Servlet 开发还是很麻烦，所以 Java 后来又对 Servlet 进行了升级，推出了 [JSP 技术](http://c.biancheng.net/jsp/)。JSP 只是对 Servlet 加了一层壳，JSP 经过编译后还是 Servlet。

## [Java Servlet是什么？它有哪些特点？](http://c.biancheng.net/view/3980.html)

Servlet（Server Applet）是 Java Servlet 的简称，是使用 Java 语言编写的运行在服务器端的程序。具有独立于平台和协议的特性，主要功能在于交互式地浏览和生成数据，生成动态Web内容。

通常来说，Servlet 是指所有实现了 Servlet 接口的类。

Servlet 主要用于处理客户端传来的 HTTP 请求，并返回一个响应，它能够处理的请求有 doGet() 和 doPost() 等。

Servlet 由 Servlet 容器提供，Servlet 容器是指提供了 Servlet 功能的服务器（如 Tomcat）。

Servlet 容器会将 Servlet 动态加载到服务器上，然后通过 HTTP 请求和 HTTP 应与客户端进行交互。

Servlet 应用程序的体系结构如图 1 所示。

![fig1](./fig/5-1Z6061I51XX.gif)

图 1  Servlet 应用程序的体系结构

在图 1 中，Servlet 的请求首先会被 HTTP 服务器（如 Apache）接收，**HTTP 服务器只负责静态 HTML 页面的解析**，而 Servlet 的请求会转交给 **Servlet 容器**，Servlet 容器会根据 web.xml 文件中的映射关系，调用相应的 Servlet，Servlet 再将处理的结果返回给 Servlet 容器，并通过 HTTP 服务器将响应传输给客户端。

Servlet 技术具有如下特点。

1. 方便

   Servlet 提供了大量的实用工具例程，如处理很难完成的 HTML 表单数据、读取和设置 HTTP 头，以及处理 Cookie 和跟踪会话等。

2. 跨平台

   Servlet 使用 Java 类编写，可以在不同的操作系统平台和不同的应用服务器平台运行。

3. 灵活性和可扩展性强

   采用 Servlet 开发的 Web 应用程序，由于 Java 类的继承性及构造函数等特点，使得应用灵活，可随意扩展。

除了上述几点以外，Servlet 还具有功能强大、能够在各个程序之间共享数据、安全性强等特点，此处不再详细说明，读者简单了解即可。

## [与Servlet相关的接口和类](http://c.biancheng.net/view/3982.html)

Sun 公司提供了一系列的接口和类用于 Servlet 技术的开发，其中最重要的接口是 javax.servlet.Servlet。在 Servlet 接口中定义了 5 个抽象方法，如表 1 所示。

|||
|-|-|
方法声明|功能描述
void init(ServletConfig config)|容器在创建好 Servlet 对象后，就会调用此方法。该方法接收一个 ServletConfig 类型的参数，Servlet 容器通过该参数向 Servlet 传递初始化配置信息
ServletConfig getSendetConfig()|用于获取 Servlet 对象的配置信息，返回 Servlet 的 ServletConfig 对象
String getServletInfo()|返回一个字符串，其中包含关于 Servlet 的信息，如作者、版本和版权等信息
void service (ServletRequest request,ServletResponse response)|负责响应用户的请求，当容器接收到客户端访问 Servlet 对象的请求时，就会调用此方法。<br> 容器会构造一个表示客户端请求信息的 ServletRequest 对象和一个用于响应客户端的 ServletResponse 对象作为参数传递给 service() 方法。 <br> 在 service() 方法中，可以通过 ServletRequest 对象得到客户端的相关信息和请求信息，在对请求进行处理后，调用 ServletResponse 对象的方法设置响应信息
void destroy()|负责释放 Servlet 对象占用的资源。当服务器关闭或者 Servlet 对象被移除时，Servlet 对象会被销毁，容器会调用此方法














TODO java servlet