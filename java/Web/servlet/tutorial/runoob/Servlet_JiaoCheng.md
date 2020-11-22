# [Servlet 教程](https://www.runoob.com/servlet/servlet-tutorial.html)

- [Servlet 教程](#servlet-教程)
  - [Servlet 简介](#servlet-简介)
    - [Servlet 是什么？](#servlet-是什么)
    - [Servlet 架构](#servlet-架构)
    - [Servlet 任务](#servlet-任务)
    - [Servlet 包](#servlet-包)
  - [Servlet 环境设置](#servlet-环境设置)
    - [设置 Java 开发工具包（Java Development Kit）](#设置-java-开发工具包java-development-kit)
    - [设置 Web 服务器：Tomcat](#设置-web-服务器tomcat)
    - [设置 CLASSPATH](#设置-classpath)
  - [Servlet 生命周期](#servlet-生命周期)
    - [init() 方法](#init-方法)
    - [service() 方法](#service-方法)
    - [doGet() 方法](#doget-方法)
    - [doPost() 方法](#dopost-方法)
    - [destroy() 方法](#destroy-方法)
    - [架构图](#架构图)
  - [Servlet 实例](#servlet-实例)
    - [Hello World 示例代码](#hello-world-示例代码)
    - [编译 Servlet](#编译-servlet)
    - [Servlet 部署](#servlet-部署)
  - [Servlet 表单数据](#servlet-表单数据)
    - [GET 方法](#get-方法)
    - [POST 方法](#post-方法)
    - [使用 Servlet 读取表单数据](#使用-servlet-读取表单数据)
    - [使用 URL 的 GET 方法实例](#使用-url-的-get-方法实例)
    - [使用表单的 GET 方法实例](#使用表单的-get-方法实例)
    - [使用表单的 POST 方法实例](#使用表单的-post-方法实例)
    - [将复选框数据传递到 Servlet 程序](#将复选框数据传递到-servlet-程序)
    - [读取所有的表单参数](#读取所有的表单参数)
  - [Servlet 客户端 HTTP 请求](#servlet-客户端-http-请求)
  - [Servlet 服务器 HTTP 响应](#servlet-服务器-http-响应)
  - [Servlet HTTP 状态码](#servlet-http-状态码)
  - [Servlet 编写过滤器](#servlet-编写过滤器)
    - [Servlet 过滤器方法](#servlet-过滤器方法)
      - [FilterConfig 使用](#filterconfig-使用)
    - [Servlet 过滤器实例](#servlet-过滤器实例)
      - [Web.xml 中的 Servlet 过滤器映射（Servlet Filter Mapping）](#webxml-中的-servlet-过滤器映射servlet-filter-mapping)
    - [使用多个过滤器](#使用多个过滤器)
    - [过滤器的应用顺序](#过滤器的应用顺序)
    - [web.xml配置各节点说明](#webxml配置各节点说明)
  - [Servlet 异常处理](#servlet-异常处理)
    - [Servlet Cookie 处理](#servlet-cookie-处理)

Servlet 为创建基于 web 的应用程序提供了基于组件、独立于平台的方法，可以不受 CGI 程序的性能限制。Servlet 有权限访问所有的 Java API，包括访问企业级数据库的 JDBC API。

## [Servlet 简介](https://www.runoob.com/servlet/servlet-intro.html)

### Servlet 是什么？

Java Servlet 是运行在 Web 服务器或应用服务器上的程序，它是作为来自 Web 浏览器或其他 HTTP 客户端的请求和 HTTP 服务器上的数据库或应用程序之间的中间层。

使用 Servlet，您可以收集来自网页表单的用户输入，呈现来自数据库或者其他源的记录，还可以动态创建网页。

Java Servlet 通常情况下与使用 CGI（Common Gateway Interface，公共网关接口）实现的程序可以达到异曲同工的效果。但是相比于 CGI，Servlet 有以下几点优势：

- 性能明显更好。
- Servlet 在 Web 服务器的地址空间内执行。这样它就没有必要再创建一个单独的进程来处理每个客户端请求。
- Servlet 是独立于平台的，因为它们是用 Java 编写的。
- 服务器上的 Java 安全管理器执行了一系列限制，以保护服务器计算机上的资源。因此，Servlet 是可信的。
- Java 类库的全部功能对 Servlet 来说都是可用的。它可以通过 sockets 和 RMI 机制与 applets、数据库或其他软件进行交互。

### Servlet 架构

下图显示了 Servlet 在 Web 应用程序中的位置。

![fig1](./fig/servlet-arch.jpg)

### Servlet 任务

Servlet 执行以下主要任务：

- 读取客户端（浏览器）发送的显式的数据。这包括网页上的 HTML 表单，或者也可以是来自 applet 或自定义的 HTTP 客户端程序的表单。
- 读取客户端（浏览器）发送的隐式的 HTTP 请求数据。这包括 cookies、媒体类型和浏览器能理解的压缩格式等等。
- 处理数据并生成结果。这个过程可能需要访问数据库，执行 RMI 或 CORBA 调用，调用 Web 服务，或者直接计算得出对应的响应。
- 发送显式的数据（即文档）到客户端（浏览器）。该文档的格式可以是多种多样的，包括文本文件（HTML 或 XML）、二进制文件（GIF 图像）、Excel 等。
- 发送隐式的 HTTP 响应到客户端（浏览器）。这包括告诉浏览器或其他客户端被返回的文档类型（例如 HTML），设置 cookies 和缓存参数，以及其他类似的任务。

### Servlet 包

Java Servlet 是运行在带有支持 Java Servlet 规范的解释器的 web 服务器上的 Java 类。

Servlet 可以使用 `javax.servlet` 和 `javax.servlet.http` 包创建，它是 Java 企业版的标准组成部分，Java 企业版是支持大型开发项目的 Java 类库的扩展版本。

这些类实现 Java Servlet 和 JSP 规范。在写本教程的时候，二者相应的版本分别是 Java Servlet 2.5 和 JSP 2.1。

Java Servlet 就像任何其他的 Java 类一样已经被创建和编译。在您安装 Servlet 包并把它们添加到您的计算机上的 Classpath 类路径中之后，您就可以通过 JDK 的 Java 编译器或任何其他编译器来编译 Servlet。

## [Servlet 环境设置](https://www.runoob.com/servlet/servlet-environment-setup.html)

开发环境是您可以开发、测试、运行 Servlet 的地方。

就像任何其他的 Java 程序，您需要通过使用 Java 编译器 javac 编译 Servlet，在编译 Servlet 应用程序后，将它部署在配置的环境中以便测试和运行。

如果你使用的是 Eclipse 环境，可以直接参阅：[Eclipse JSP/Servlet 环境搭建](https://www.runoob.com/jsp/eclipse-jsp.html)。

这个开发环境设置包括以下步骤：

### 设置 Java 开发工具包（Java Development Kit）

### 设置 Web 服务器：Tomcat

在市场上有许多 Web 服务器支持 Servlet。有些 Web 服务器是免费下载的，Tomcat 就是其中的一个。

Apache Tomcat 是一款 Java Servlet 和 JavaServer Pages 技术的开源软件实现，可以作为测试 Servlet 的独立服务器，而且可以集成到 Apache Web 服务器。下面是在电脑上安装 Tomcat 的步骤：

从 <http://tomcat.apache.org/> 上下载最新版本的 Tomcat。
一旦您下载了 Tomcat，解压缩到一个方便的位置。例如，如果您使用的是 Windows，则解压缩到 C:\apache-tomcat-5.5.29 中，如果您使用的是 Linux/Unix，则解压缩到 /usr/local/apache-tomcat-5.5.29 中，并创建 `CATALINA_HOME` 环境变量指向这些位置。
在 Windows 上，可以通过执行下面的命令来启动 Tomcat：

    %CATALINA_HOME%\bin\startup.bat

 或者

    C:\apache-tomcat-5.5.29\bin\startup.bat

在 Unix（Solaris、Linux 等） 上，可以通过执行下面的命令来启动 Tomcat：

    $CATALINA_HOME/bin/startup.sh

 或者

    /usr/local/apache-tomcat-5.5.29/bin/startup.sh

有关配置和运行 Tomcat 的进一步信息可以查阅应用程序安装的文档，或者可以访问 Tomcat 网站：http://tomcat.apache.org。

在 Windows 上，可以通过执行下面的命令来停止 Tomcat：

    C:\apache-tomcat-5.5.29\bin\shutdown

在 Unix（Solaris、Linux 等） 上，可以通过执行下面的命令来停止 Tomcat：

    /usr/local/apache-tomcat-5.5.29/bin/shutdown.sh

### 设置 CLASSPATH

由于 Servlet 不是 Java 平台标准版的组成部分，所以您必须为编译器指定 Servlet 类的路径。

## [Servlet 生命周期](https://www.runoob.com/servlet/servlet-life-cycle.html)

Servlet 生命周期可被定义为从创建直到毁灭的整个过程。以下是 Servlet 遵循的过程：

- Servlet 初始化后调用 `init ()` 方法。
- Servlet 调用 `service()` 方法来处理客户端的请求。
- Servlet 销毁前调用 `destroy()` 方法。
- 最后，Servlet 是由 JVM 的垃圾回收器进行垃圾回收的。

现在让我们详细讨论生命周期的方法。

### init() 方法

init 方法被设计成只调用一次。它在第一次创建 Servlet 时被调用，在后续每次用户请求时不再调用。因此，它是用于一次性初始化，就像 Applet 的 init 方法一样。

Servlet 创建于用户第一次调用对应于该 Servlet 的 URL 时，但是您也可以指定 Servlet 在服务器第一次启动时被加载。

当用户调用一个 Servlet 时，就会创建一个 Servlet 实例，每一个用户请求都会产生一个新的线程，适当的时候移交给 doGet 或 doPost 方法。init() 方法简单地创建或加载一些数据，这些数据将被用于 Servlet 的整个生命周期。

init 方法的定义如下：

    public void init() throws ServletException {
    // 初始化代码...
    }

### service() 方法

service() 方法是执行实际任务的主要方法。Servlet 容器（即 Web 服务器）调用 service() 方法来处理来自客户端（浏览器）的请求，并把格式化的响应写回给客户端。

每次服务器接收到一个 Servlet 请求时，服务器会产生一个新的线程并调用服务。service() 方法检查 HTTP 请求类型（GET、POST、PUT、DELETE 等），并在适当的时候调用 doGet、doPost、doPut，doDelete 等方法。

下面是该方法的特征：

    public void service(ServletRequest request, 
                        ServletResponse response) 
        throws ServletException, IOException{
    }

service() 方法由容器调用，service 方法在适当的时候调用 doGet、doPost、doPut、doDelete 等方法。所以，您不用对 service() 方法做任何动作，您只需要根据来自客户端的请求类型来重写 doGet() 或 doPost() 即可。

doGet() 和 doPost() 方法是每次服务请求中最常用的方法。下面是这两种方法的特征。

### doGet() 方法

GET 请求来自于一个 URL 的正常请求，或者来自于一个未指定 METHOD 的 HTML 表单，它由 doGet() 方法处理。

    public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
        throws ServletException, IOException {
        // Servlet 代码
    }

### doPost() 方法

POST 请求来自于一个特别指定了 METHOD 为 POST 的 HTML 表单，它由 doPost() 方法处理。

    public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
        throws ServletException, IOException {
        // Servlet 代码
    }

### destroy() 方法

destroy() 方法只会被调用一次，在 Servlet 生命周期结束时被调用。destroy() 方法可以让您的 Servlet 关闭数据库连接、停止后台线程、把 Cookie 列表或点击计数器写入到磁盘，并执行其他类似的清理活动。

在调用 destroy() 方法之后，servlet 对象被标记为垃圾回收。destroy 方法定义如下所示：

    public void destroy() {
        // 终止化代码...
    }

### 架构图

下图显示了一个典型的 Servlet 生命周期方案。

- 第一个到达服务器的 HTTP 请求被委派到 Servlet 容器。
- Servlet 容器在调用 service() 方法之前加载 Servlet。
- 然后 Servlet 容器处理由多个线程产生的多个请求，每个线程执行一个单一的 Servlet 实例的 service() 方法。

![fig2](./fig/Servlet-LifeCycle.jpg)

## [Servlet 实例](https://www.runoob.com/servlet/servlet-first-example.html)

Servlet 是服务 HTTP 请求并实现 javax.servlet.Servlet 接口的 Java 类。Web 应用程序开发人员通常**编写 Servlet 来扩展 javax.servlet.http.HttpServlet**，并实现 Servlet 接口的抽象类专门用来处理 HTTP 请求。

### Hello World 示例代码

下面是 Servlet 输出 Hello World 的示例源代码：

    // 导入必需的 java 库
    import java.io.*;
    import javax.servlet.*;
    import javax.servlet.http.*;

    // 扩展 HttpServlet 类
    public class HelloWorld extends HttpServlet {
    
        private String message;

        public void init() throws ServletException
        {
            // 执行必需的初始化
            message = "Hello World";
        }

        public void doGet(HttpServletRequest request,
                        HttpServletResponse response)
                throws ServletException, IOException
        {
            // 设置响应内容类型
            response.setContentType("text/html");

            // 实际的逻辑是在这里
            PrintWriter out = response.getWriter();
            out.println("<h1>" + message + "</h1>");
        }
    
        public void destroy()
        {
            // 什么也不做
        }
    }

### 编译 Servlet

让我们把上面的代码写在 HelloWorld.java 文件中，把这个文件放在 C:\ServletDevel（在 Windows 上）或 /usr/ServletDevel（在 UNIX 上）中，您还需要把这些目录添加到 CLASSPATH 中。

假设您的环境已经正确地设置，进入 ServletDevel 目录，并编译 HelloWorld.java，如下所示：

    $ javac HelloWorld.java

如果 Servlet 依赖于任何其他库，您必须在 CLASSPATH 中包含那些 JAR 文件。在这里，我只包含了 servlet-api.jar JAR 文件，因为我没有在 Hello World 程序中使用任何其他库。

该命令行使用 Sun Microsystems Java 软件开发工具包（JDK）内置的 javac 编译器。为使该命令正常工作， PATH 环境变量需要设置 Java SDK 的路径。

如果一切顺利，上面编译会在同一目录下生成 HelloWorld.class 文件。下一节将讲解已编译的 Servlet 如何部署在生产中。

### Servlet 部署

默认情况下，Servlet 应用程序位于路径 <Tomcat-installation-directory>/webapps/ROOT 下，且类文件放在 <Tomcat-installation-directory>/webapps/ROOT/WEB-INF/classes 中。

如果您有一个完全合格的类名称 com.myorg.MyServlet，那么这个 Servlet 类必须位于 WEB-INF/classes/com/myorg/MyServlet.class 中。

现在，让我们把 HelloWorld.class 复制到 <Tomcat-installation-directory>/webapps/ROOT/WEB-INF/classes 中，并在位于 <Tomcat-installation-directory>/webapps/ROOT/WEB-INF/ 的 web.xml 文件中创建以下条目：

    <web-app>      
        <servlet>
            <servlet-name>HelloWorld</servlet-name>
            <servlet-class>HelloWorld</servlet-class>
        </servlet>

        <servlet-mapping>
            <servlet-name>HelloWorld</servlet-name>
            <url-pattern>/HelloWorld</url-pattern>
        </servlet-mapping>
    </web-app>  

上面的条目要被创建在 web.xml 文件中的 <web-app>...</web-app> 标签内。在该文件中可能已经有各种可用的条目，但不要在意。

到这里，您基本上已经完成了，现在让我们使用 <Tomcat-installation-directory>\bin\startup.bat（在 Windows 上）或 <Tomcat-installation-directory>/bin/startup.sh（在 Linux/Solaris 等上）启动 tomcat 服务器，最后在浏览器的地址栏中输入 http://localhost:8080/HelloWorld。

## [Servlet 表单数据](https://www.runoob.com/servlet/servlet-form-data.html)

很多情况下，需要传递一些信息，从浏览器到 Web 服务器，最终到后台程序。浏览器使用两种方法可将这些信息传递到 Web 服务器，分别为 GET 方法和 POST 方法。

### GET 方法

GET 方法向页面请求发送已编码的用户信息。页面和已编码的信息中间用 ? 字符分隔，如下所示：

http://www.test.com/hello?key1=value1&key2=value2

GET 方法是默认的从浏览器向 Web 服务器传递信息的方法，它会产生一个很长的字符串，出现在浏览器的地址栏中。如果您要向服务器传递的是密码或其他的敏感信息，请不要使用 GET 方法。GET 方法有大小限制：请求字符串中最多只能有 1024 个字符。

这些信息使用 QUERY_STRING 头传递，并可以通过 QUERY_STRING 环境变量访问，Servlet 使用 doGet() 方法处理这种类型的请求。

### POST 方法

另一个向后台程序传递信息的比较可靠的方法是 POST 方法。POST 方法打包信息的方式与 GET 方法基本相同，但是 POST 方法不是把信息作为 URL 中 ? 字符后的文本字符串进行发送，而是把这些信息作为一个单独的消息。消息以标准输出的形式传到后台程序，您可以解析和使用这些标准输出。Servlet 使用 doPost() 方法处理这种类型的请求。

### 使用 Servlet 读取表单数据

Servlet 处理表单数据，这些数据会根据不同的情况使用不同的方法自动解析：

- getParameter()：您可以调用 request.getParameter() 方法来获取表单参数的值。
- getParameterValues()：如果参数出现一次以上，则调用该方法，并返回多个值，例如复选框。
- getParameterNames()：如果您想要得到当前请求中的所有参数的完整列表，则调用该方法。

### 使用 URL 的 GET 方法实例

下面是一个简单的 URL，将使用 GET 方法向 HelloForm 程序传递两个值。

http://localhost:8080/TomcatTest/HelloForm?name=菜鸟教程&url=www.runoob.com

下面是处理 Web 浏览器输入的 HelloForm.java Servlet 程序。我们将使用 getParameter() 方法，可以很容易地访问传递的信息：

    package com.runoob.test;

    import java.io.IOException;
    import java.io.PrintWriter;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /**
    * Servlet implementation class HelloForm
    */
    @WebServlet("/HelloForm")
    public class HelloForm extends HttpServlet {
        private static final long serialVersionUID = 1L;
        
        /**
        * @see HttpServlet#HttpServlet()
        */
        public HelloForm() {
            super();
            // TODO Auto-generated constructor stub
        }

        /**
        * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
        */
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // 设置响应内容类型
            response.setContentType("text/html;charset=UTF-8");

            PrintWriter out = response.getWriter();
            String title = "使用 GET 方法读取表单数据";
            // 处理中文
            String name =new String(request.getParameter("name").getBytes("ISO-8859-1"),"UTF-8");
            String docType = "<!DOCTYPE html> \n";
            out.println(docType +
                "<html>\n" +
                "<head><title>" + title + "</title></head>\n" +
                "<body bgcolor=\"#f0f0f0\">\n" +
                "<h1 align=\"center\">" + title + "</h1>\n" +
                "<ul>\n" +
                "  <li><b>站点名</b>："
                + name + "\n" +
                "  <li><b>网址</b>："
                + request.getParameter("url") + "\n" +
                "</ul>\n" +
                "</body></html>");
        }
        
        // 处理 POST 方法请求的方法
        public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            doGet(request, response);
        }
    }

然后我们在 web.xml 文件中创建以下条目：

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app>
        <servlet>
            <servlet-name>HelloForm</servlet-name>
            <servlet-class>com.runoob.test.HelloForm</servlet-class>
        </servlet>
        <servlet-mapping>
            <servlet-name>HelloForm</servlet-name>
            <url-pattern>/TomcatTest/HelloForm</url-pattern>
        </servlet-mapping>
    </web-app>

现在在浏览器的地址栏中输入 http://localhost:8080/TomcatTest/HelloForm?name=菜鸟教程&url=www.runoob.com ，并在触发上述命令之前确保已经启动 Tomcat 服务器。

### 使用表单的 GET 方法实例

下面是一个简单的实例，使用 HTML 表单和提交按钮传递两个值。我们将使用相同的 Servlet HelloForm 来处理输入。

    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <title>菜鸟教程(runoob.com)</title>
    </head>
    <body>
    <form action="HelloForm" method="GET">
    网址名：<input type="text" name="name">
    <br />
    网址：<input type="text" name="url" />
    <input type="submit" value="提交" />
    </form>
    </body>
    </html>

保存这个 HTML 到 hello.html 文件中，目录结构如下所示:

![fig](./fig/hell-form.jpg)

尝试输入网址名和网址 localhost:8080/TomcatTest/hello.html，然后点击"提交"按钮。

### 使用表单的 POST 方法实例

让我们对上面的 Servlet 做小小的修改，以便它可以处理 GET 和 POST 方法。下面的 HelloForm.java Servlet 程序使用 GET 和 POST 方法处理由 Web 浏览器给出的输入。

---
注意：如果表单提交的数据中有中文数据则需要转码：

    String name =new String(request.getParameter("name").getBytes("ISO8859-1"),"UTF-8");
---

    package com.runoob.test;

    import java.io.IOException;
    import java.io.PrintWriter;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /**
    * Servlet implementation class HelloForm
    */
    @WebServlet("/HelloForm")
    public class HelloForm extends HttpServlet {
        private static final long serialVersionUID = 1L;
        
        /**
        * @see HttpServlet#HttpServlet()
        */
        public HelloForm() {
            super();
            // TODO Auto-generated constructor stub
        }

        /**
        * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
        */
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // 设置响应内容类型
            response.setContentType("text/html;charset=UTF-8");

            PrintWriter out = response.getWriter();
            String title = "使用 POST 方法读取表单数据";
            // 处理中文
            String name =new String(request.getParameter("name").getBytes("ISO8859-1"),"UTF-8");
            String docType = "<!DOCTYPE html> \n";
            out.println(docType +
                "<html>\n" +
                "<head><title>" + title + "</title></head>\n" +
                "<body bgcolor=\"#f0f0f0\">\n" +
                "<h1 align=\"center\">" + title + "</h1>\n" +
                "<ul>\n" +
                "  <li><b>站点名</b>："
                + name + "\n" +
                "  <li><b>网址</b>："
                + request.getParameter("url") + "\n" +
                "</ul>\n" +
                "</body></html>");
        }
        
        // 处理 POST 方法请求的方法
        public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            doGet(request, response);
        }
    }

现在，编译部署上述的 Servlet，并使用带有 POST 方法的 hello.html 进行测试，如下所示：

    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <title>菜鸟教程(runoob.com)</title>
    </head>
    <body>
    <form action="HelloForm" method="POST">
    网址名：<input type="text" name="name">
    <br />
    网址：<input type="text" name="url" />
    <input type="submit" value="提交" />
    </form>
    </body>
    </html>


尝试输入网址名和网址 localhost:8080/TomcatTest/hello.html，然后点击"提交"按钮。

### 将复选框数据传递到 Servlet 程序

当需要选择一个以上的选项时，则使用复选框。

下面是一个 HTML 代码实例 checkbox.html，一个带有两个复选框的表单。

    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <title>菜鸟教程(runoob.com)</title>
    </head>
    <body>
    <form action="CheckBox" method="POST" target="_blank">
    <input type="checkbox" name="runoob" checked="checked" /> 菜鸟教程
    <input type="checkbox" name="google"  /> Google
    <input type="checkbox" name="taobao" checked="checked" /> 淘宝
    <input type="submit" value="选择站点" />
    </form>
    </body>
    </html>

下面是 CheckBox.java Servlet 程序，处理 Web 浏览器给出的复选框输入。

    package com.runoob.test;

    import java.io.IOException;
    import java.io.PrintWriter;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /**
    * Servlet implementation class CheckBox
    */
    @WebServlet("/CheckBox")
    public class CheckBox extends HttpServlet {
        private static final long serialVersionUID = 1L;
        
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            
            // 设置响应内容类型
            response.setContentType("text/html;charset=UTF-8");

            PrintWriter out = response.getWriter();
            String title = "读取复选框数据";
            String docType = "<!DOCTYPE html> \n";
                out.println(docType +
                    "<html>\n" +
                    "<head><title>" + title + "</title></head>\n" +
                    "<body bgcolor=\"#f0f0f0\">\n" +
                    "<h1 align=\"center\">" + title + "</h1>\n" +
                    "<ul>\n" +
                    "  <li><b>菜鸟按教程标识：</b>: "
                    + request.getParameter("runoob") + "\n" +
                    "  <li><b>Google 标识：</b>: "
                    + request.getParameter("google") + "\n" +
                    "  <li><b>淘宝标识：</b>: "
                    + request.getParameter("taobao") + "\n" +
                    "</ul>\n" +
                    "</body></html>");
        }
        
        // 处理 POST 方法请求的方法
        public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            doGet(request, response);
        }
    }

设置对应的 web.xml：

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app>
        <servlet>
            <servlet-name>CheckBox</servlet-name>
            <servlet-class>com.runoob.test.CheckBox</servlet-class>
        </servlet>
        <servlet-mapping>
            <servlet-name>CheckBox</servlet-name>
            <url-pattern>/TomcatTest/CheckBox</url-pattern>
        </servlet-mapping>
    </web-app>

尝试输入网址名和网址 localhost:8080/TomcatTest/checkbox.html。

### 读取所有的表单参数

以下是通用的实例，使用 HttpServletRequest 的 getParameterNames() 方法读取所有可用的表单参数。该方法返回一个枚举，其中包含未指定顺序的参数名。

一旦我们有一个枚举，我们可以以标准方式循环枚举，使用 hasMoreElements() 方法来确定何时停止，使用 nextElement() 方法来获取每个参数的名称。

    import java.io.IOException;
    import java.io.PrintWriter;
    import java.util.Enumeration;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /**
    * Servlet implementation class ReadParams
    */
    @WebServlet("/ReadParams")
    public class ReadParams extends HttpServlet {
        private static final long serialVersionUID = 1L;
        
        /**
        * @see HttpServlet#HttpServlet()
        */
        public ReadParams() {
            super();
            // TODO Auto-generated constructor stub
        }

        /**
        * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
        */
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // 设置响应内容类型
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            String title = "读取所有的表单数据";
            String docType =
                "<!doctype html public \"-//w3c//dtd html 4.0 " +
                "transitional//en\">\n";
                out.println(docType +
                "<html>\n" +
                "<head><meta charset=\"utf-8\"><title>" + title + "</title></head>\n" +
                "<body bgcolor=\"#f0f0f0\">\n" +
                "<h1 align=\"center\">" + title + "</h1>\n" +
                "<table width=\"100%\" border=\"1\" align=\"center\">\n" +
                "<tr bgcolor=\"#949494\">\n" +
                "<th>参数名称</th><th>参数值</th>\n"+
                "</tr>\n");

            Enumeration paramNames = request.getParameterNames();

            while(paramNames.hasMoreElements()) {
                String paramName = (String)paramNames.nextElement();
                out.print("<tr><td>" + paramName + "</td>\n");
                String[] paramValues =
                request.getParameterValues(paramName);
                // 读取单个值的数据
                if (paramValues.length == 1) {
                    String paramValue = paramValues[0];
                    if (paramValue.length() == 0)
                        out.println("<td><i>没有值</i></td>");
                    else
                        out.println("<td>" + paramValue + "</td>");
                } else {
                    // 读取多个值的数据
                    out.println("<td><ul>");
                    for(int i=0; i < paramValues.length; i++) {
                    out.println("<li>" + paramValues[i]);
                }
                    out.println("</ul></td>");
                }
                out.print("</tr>");
            }
            out.println("\n</table>\n</body></html>");
        }

        /**
        * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
        */
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // TODO Auto-generated method stub
            doGet(request, response);
        }
    }

现在，通过下面的表单尝试上面的 Servlet：

    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <title>菜鸟教程(runoob.com)</title>
    </head>
    <body>

    <form action="ReadParams" method="POST" target="_blank">
    <input type="checkbox" name="maths" checked="checked" /> 数学
    <input type="checkbox" name="physics"  /> 物理
    <input type="checkbox" name="chemistry" checked="checked" /> 化学
    <input type="submit" value="选择学科" />
    </form>

    </body>
    </html>

设置相应的 web.xml:

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app>
        <servlet>
            <servlet-name>ReadParams</servlet-name>
            <servlet-class>com.runoob.test.ReadParams</servlet-class>
        </servlet>
        <servlet-mapping>
            <servlet-name>ReadParams</servlet-name>
            <url-pattern>/TomcatTest/ReadParams</url-pattern>
        </servlet-mapping>
    </web-app>

现在使用上面的表单调用 Servlet, localhost:8080/TomcatTest/test.html

## [Servlet 客户端 HTTP 请求](https://www.runoob.com/servlet/servlet-client-request.html)

...

## [Servlet 服务器 HTTP 响应](https://www.runoob.com/servlet/servlet-server-response.html)

## [Servlet HTTP 状态码](https://www.runoob.com/servlet/servlet-http-status-codes.html)

## [Servlet 编写过滤器](https://www.runoob.com/servlet/servlet-writing-filters.html)

Servlet 过滤器可以动态地拦截请求和响应，以变换或使用包含在请求或响应中的信息。

可以将一个或多个 Servlet 过滤器附加到一个 Servlet 或一组 Servlet。Servlet 过滤器也可以附加到 JavaServer Pages (JSP) 文件和 HTML 页面。调用 Servlet 前调用所有附加的 Servlet 过滤器。

Servlet 过滤器是可用于 Servlet 编程的 Java 类，可以实现以下目的：

-j在客户端的请求访问后端资源之前，拦截这些请求。
- 在服务器的响应发送回客户端之前，处理这些响应。

根据规范建议的各种类型的过滤器：

- 身份验证过滤器（Authentication Filters）。
- 数据压缩过滤器（Data compression Filters）。
- 加密过滤器（Encryption Filters）。
- 触发资源访问事件过滤器。
- 图像转换过滤器（Image Conversion Filters）。
- 日志记录和审核过滤器（Logging and Auditing Filters）。
- MIME-TYPE 链过滤器（MIME-TYPE Chain Filters）。
- 标记化过滤器（Tokenizing Filters）。
- XSL/T 过滤器（XSL/T Filters），转换 XML 内容。

过滤器通过 Web 部署描述符（web.xml）中的 XML 标签来声明，然后映射到您的应用程序的部署描述符中的 Servlet 名称或 URL 模式。

当 Web 容器启动 Web 应用程序时，它会为您在部署描述符中声明的每一个过滤器创建一个实例。

Filter的执行顺序与在web.xml配置文件中的配置顺序一致，一般把Filter配置在所有的Servlet之前。

### Servlet 过滤器方法

过滤器是一个实现了 javax.servlet.Filter 接口的 Java 类。javax.servlet.Filter 接口定义了三个方法：

|||
|-|-|
序号|方法 & 描述
1|public void doFilter (ServletRequest, ServletResponse, FilterChain) <br> 该方法完成实际的过滤操作，当客户端请求方法与过滤器设置匹配的URL时，Servlet容器将先调用过滤器的doFilter方法。FilterChain用户访问后续过滤器。
2|public void init(FilterConfig filterConfig) <br> web 应用程序启动时，web 服务器将创建Filter 的实例对象，并调用其init方法，读取web.xml配置，完成对象的初始化功能，从而为后续的用户请求作好拦截的准备工作（filter对象只会创建一次，init方法也只会执行一次）。开发人员通过init方法的参数，可获得代表当前filter配置信息的FilterConfig对象。
3|public void destroy() <br> Servlet容器在销毁过滤器实例前调用该方法，在该方法中释放Servlet过滤器占用的资源。
|||

#### FilterConfig 使用

Filter 的 init 方法中提供了一个 FilterConfig 对象。

如 web.xml 文件配置如下：

    <filter>
        <filter-name>LogFilter</filter-name>
        <filter-class>com.runoob.test.LogFilter</filter-class>
        <init-param>
            <param-name>Site</param-name>
            <param-value>菜鸟教程</param-value>
        </init-param>
    </filter>

在 init 方法使用 FilterConfig 对象获取参数：

    public void  init(FilterConfig config) throws ServletException {
        // 获取初始化参数
        String site = config.getInitParameter("Site"); 
        // 输出初始化参数
        System.out.println("网站名称: " + site); 
    }

### Servlet 过滤器实例

以下是 Servlet 过滤器的实例，将输出网站名称和地址。本实例让您对 Servlet 过滤器有基本的了解，您可以使用相同的概念编写更复杂的过滤器应用程序：

    package com.runoob.test;

    //导入必需的 java 库
    import javax.servlet.*;
    import java.util.*;

    //实现 Filter 类
    public class LogFilter implements Filter  {
        public void  init(FilterConfig config) throws ServletException {
            // 获取初始化参数
            String site = config.getInitParameter("Site"); 

            // 输出初始化参数
            System.out.println("网站名称: " + site); 
        }
        public void  doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws java.io.IOException, ServletException {

            // 输出站点名称
            System.out.println("站点网址：http://www.runoob.com");

            // 把请求传回过滤链
            chain.doFilter(request,response);
        }
        public void destroy( ){
            /* 在 Filter 实例被 Web 容器从服务移除之前调用 */
        }
    }

这边使用前文提到的 DisplayHeader.java 为例子：

    //导入必需的 java 库
    import java.io.IOException;
    import java.io.PrintWriter;
    import java.util.Enumeration;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    @WebServlet("/DisplayHeader")

    //扩展 HttpServlet 类
    public class DisplayHeader extends HttpServlet {

        // 处理 GET 方法请求的方法
        public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
        {
            // 设置响应内容类型
            response.setContentType("text/html;charset=UTF-8");

            PrintWriter out = response.getWriter();
            String title = "HTTP Header 请求实例 - 菜鸟教程实例";
            String docType =
                "<!DOCTYPE html> \n";
                out.println(docType +
                "<html>\n" +
                "<head><meta charset=\"utf-8\"><title>" + title + "</title></head>\n"+
                "<body bgcolor=\"#f0f0f0\">\n" +
                "<h1 align=\"center\">" + title + "</h1>\n" +
                "<table width=\"100%\" border=\"1\" align=\"center\">\n" +
                "<tr bgcolor=\"#949494\">\n" +
                "<th>Header 名称</th><th>Header 值</th>\n"+
                "</tr>\n");

            Enumeration headerNames = request.getHeaderNames();

            while(headerNames.hasMoreElements()) {
                String paramName = (String)headerNames.nextElement();
                out.print("<tr><td>" + paramName + "</td>\n");
                String paramValue = request.getHeader(paramName);
                out.println("<td> " + paramValue + "</td></tr>\n");
            }
            out.println("</table>\n</body></html>");
        }
        // 处理 POST 方法请求的方法
        public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            doGet(request, response);
        }
    }

#### Web.xml 中的 Servlet 过滤器映射（Servlet Filter Mapping）

定义过滤器，然后映射到一个 URL 或 Servlet，这与定义 Servlet，然后映射到一个 URL 模式方式大致相同。在部署描述符文件 web.xml 中为 filter 标签创建下面的条目：

    <?xml version="1.0" encoding="UTF-8"?>  
    <web-app>  
    <filter>
      <filter-name>LogFilter</filter-name>
      <filter-class>com.runoob.test.LogFilter</filter-class>
      <init-param>
        <param-name>Site</param-name>
        <param-value>菜鸟教程</param-value>
      </init-param>
    </filter>
    <filter-mapping>
      <filter-name>LogFilter</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>
    <servlet>  
      <!-- 类名 -->  
      <servlet-name>DisplayHeader</servlet-name>  
      <!-- 所在的包 -->  
      <servlet-class>com.runoob.test.DisplayHeader</servlet-class>  
    </servlet>  
    <servlet-mapping>  
      <servlet-name>DisplayHeader</servlet-name>  
      <!-- 访问的网址 -->  
      <url-pattern>/TomcatTest/DisplayHeader</url-pattern>  
    </servlet-mapping>  
    </web-app>  

上述过滤器适用于所有的 Servlet，因为我们在配置中指定 /* 。如果您只想在少数的 Servlet 上应用过滤器，您可以指定一个特定的 Servlet 路径。

现在试着以常用的方式调用任何 Servlet，您将会看到在 Web 服务器中生成的日志。您也可以使用 Log4J 记录器来把上面的日志记录到一个单独的文件中。

接下来我们访问这个实例地址 http://localhost:8080/TomcatTest/DisplayHeader, 然后在控制台看下输出内容，如下所示：

### 使用多个过滤器

Web 应用程序可以根据特定的目的定义若干个不同的过滤器。假设您定义了两个过滤器 AuthenFilter 和 LogFilter。您需要创建一个如下所述的不同的映射，其余的处理与上述所讲解的大致相同：

    <filter>
       <filter-name>LogFilter</filter-name>
       <filter-class>com.runoob.test.LogFilter</filter-class>
       <init-param>
          <param-name>test-param</param-name>
          <param-value>Initialization Paramter</param-value>
       </init-param>
    </filter>

    <filter>
       <filter-name>AuthenFilter</filter-name>
       <filter-class>com.runoob.test.AuthenFilter</filter-class>
       <init-param>
          <param-name>test-param</param-name>
          <param-value>Initialization Paramter</param-value>
       </init-param>
    </filter>

    <filter-mapping>
       <filter-name>LogFilter</filter-name>
       <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
       <filter-name>AuthenFilter</filter-name>
       <url-pattern>/*</url-pattern>
    </filter-mapping>

### 过滤器的应用顺序

web.xml 中的 filter-mapping 元素的顺序决定了 Web 容器应用过滤器到 Servlet 的顺序。若要反转过滤器的顺序，您只需要在 web.xml 文件中反转 filter-mapping 元素即可。

例如，上面的实例将先应用 LogFilter，然后再应用 AuthenFilter，但是下面的实例将颠倒这个顺序：

    <filter-mapping>
       <filter-name>AuthenFilter</filter-name>
       <url-pattern>/*</url-pattern>
    </filter-mapping>

    <filter-mapping>
       <filter-name>LogFilter</filter-name>
       <url-pattern>/*</url-pattern>
    </filter-mapping>

### web.xml配置各节点说明

- `<filter>`指定一个过滤器。

  - `<filter-name>`用于为过滤器指定一个名字，该元素的内容不能为空。
  - `<filter-class>`元素用于指定过滤器的完整的限定类名。
  - `<init-param>`元素用于为过滤器指定初始化参数，它的子元素`<param-name>`指定参数的名字，`<param-value>`指定参数的值。
  - 在过滤器中，可以使用FilterConfig接口对象来访问初始化参数。

- `<filter-mapping>`元素用于设置一个 Filter 所负责拦截的资源。一个Filter拦截的资源可通过两种方式来指定：Servlet 名称和资源访问的请求路径

  - `<filter-name>`子元素用于设置filter的注册名称。该值必须是在`<filter>`元素中声明过的过滤器的名字
  - `<url-pattern>`设置 filter 所拦截的请求路径(过滤器关联的URL样式)

- `<servlet-name>`指定过滤器所拦截的Servlet名称。

- `<dispatcher>`指定过滤器所拦截的资源被 Servlet 容器调用的方式，可以是REQUEST,INCLUDE,FORWARD和ERROR之一，默认REQUEST。用户可以设置多个`<dispatcher>`子元素用来指定 Filter 对资源的多种调用方式进行拦截。

- `<dispatcher>`子元素可以设置的值及其意义

  - REQUEST：当用户直接访问页面时，Web容器将会调用过滤器。如果目标资源是通过RequestDispatcher的include()或forward()方法访问时，那么该过滤器就不会被调用。
  - INCLUDE：如果目标资源是通过RequestDispatcher的include()方法访问时，那么该过滤器将被调用。除此之外，该过滤器不会被调用。
  - FORWARD：如果目标资源是通过RequestDispatcher的forward()方法访问时，那么该过滤器将被调用，除此之外，该过滤器不会被调用。
  - ERROR：如果目标资源是通过声明式异常处理机制调用时，那么该过滤器将被调用。除此之外，过滤器不会被调用。

## [Servlet 异常处理](https://www.runoob.com/servlet/servlet-exception-handling.html)

当一个 Servlet 抛出一个异常时，Web 容器在使用了 exception-type 元素的 web.xml 中搜索与抛出异常类型相匹配的配置。

您必须在 web.xml 中使用 error-page 元素来指定对特定异常 或 HTTP 状态码 作出相应的 Servlet 调用。

...

### [Servlet Cookie 处理](https://www.runoob.com/servlet/servlet-cookies-handling.html)

Cookie 是存储在客户端计算机上的文本文件，并保留了各种跟踪信息。Java Servlet 显然支持 HTTP Cookie。

识别返回用户包括三个步骤：

- 服务器脚本向浏览器发送一组 Cookie。例如：姓名、年龄或识别号码等。
- 浏览器将这些信息存储在本地计算机上，以备将来使用。
- 当下一次浏览器向 Web 服务器发送任何请求时，浏览器会把这些 Cookie 信息发送到服务器，服务器将使用这些信息来识别用户。

本章将向您讲解如何设置或重置 Cookie，如何访问它们，以及如何将它们删除。






















TODO java servlet ssssssssssssssssssssssssssssssssssss