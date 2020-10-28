# [SLF4J user manual](http://www.slf4j.org/manual.html)

- [SLF4J user manual](#slf4j-user-manual)
  - [Hello World](#hello-world)
  - [Typical usage pattern](#typical-usage-pattern)
  - [Fluent Logging API](#fluent-logging-api)
  - [Binding with a logging framework at deployment time](#binding-with-a-logging-framework-at-deployment-time)
  - [Libraries](#libraries)
  - [Declaring project dependencies for logging](#declaring-project-dependencies-for-logging)
  - [Binary compatibility](#binary-compatibility)
  - [Consolidate logging via SLF4J](#consolidate-logging-via-slf4j)
  - [Mapped Diagnostic Context (MDC) support](#mapped-diagnostic-context-mdc-support)
  - [Executive summary](#executive-summary)

The Simple Logging Facade for Java (SLF4J) serves as a simple facade or abstraction for various logging frameworks, such as **java.util.logging**, **logback** and **log4j**. SLF4J allows the end-user to plug in the desired logging framework at deployment time. Note that SLF4J-enabling your library/application implies the addition of only a single mandatory dependency, namely slf4j-api-2.0.0-alpha2-SNAPSHOT.jar.

## Hello World

As customary in programming tradition, here is an example illustrating the simplest way to output "Hello world" using SLF4J. It begins by getting a logger with the name "HelloWorld". This logger is in turn used to log the message "Hello World".

    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;

    public class HelloWorld {
        public static void main(String[] args) {
            Logger logger = LoggerFactory.getLogger(HelloWorld.class);
            logger.info("Hello World");
        }
    }

To run this example, you first need to [download the slf4j distribution](http://www.slf4j.org/download.html), and then to unpack it. Once that is done, add the file `slf4j-api-1.7.28.jar` to your class path.

Compiling and running HelloWorld will result in the following output being printed on the console.

    SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
    SLF4J: Defaulting to no-operation (NOP) logger implementation
    SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.

This warning is printed because no slf4j binding could be found on your class path.

The warning will disappear as soon as you add a binding to your class path. Assuming you add slf4j-simple-1.7.28.jar so that your class path contains:

- slf4j-api-1.7.28.jar
- slf4j-simple-1.7.28.jar

Compiling and running HelloWorld will now result in the following output on the console.

    0 [main] INFO HelloWorld - Hello World

## Typical usage pattern

The sample code below illustrates the typical usage pattern for SLF4J. Note the use of {}-placeholders on line 15. See the question "[What is the fastest way of logging?](http://www.slf4j.org/faq.html#logging_performance)" in the FAQ for more details.

    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;

    public class Wombat {
    
        final Logger logger = LoggerFactory.getLogger(Wombat.class);
        Integer t;
        Integer oldT;
    
        public void setTemperature(Integer temperature) {
    
            oldT = t;        
            t = temperature;

            logger.debug("Temperature set to {}. Old temperature was {}.", t, oldT);

            if(temperature.intValue() > 50) {
                logger.info("Temperature has risen above 50 degrees.");
            }
        }
    } 

## Fluent Logging API

...

## Binding with a logging framework at deployment time

As mentioned previously, SLF4J supports various logging frameworks. The SLF4J distribution ships with several jar files referred to as "**SLF4J bindings**", with each binding corresponding to a supported framework.

|||
|-|-|
slf4j-log4j12-1.7.28.jar | Binding for [log4j version 1.2](http://logging.apache.org/log4j/1.2/index.html), a widely used logging framework. You also need to place log4j.jar on your class path.
slf4j-jdk14-1.7.28.jar | Binding for java.util.logging, also referred to as JDK 1.4 logging
slf4j-nop-1.7.28.jar | Binding for [NOP](http://www.slf4j.org/api/org/slf4j/helpers/NOPLogger.html), silently discarding all logging.
slf4j-simple-1.7.28.jar | Binding for [Simple](http://www.slf4j.org/apidocs/org/slf4j/impl/SimpleLogger.html) implementation, which outputs all events to System.err. Only messages of level INFO and higher are printed. This binding may be useful in the context of small applications.
slf4j-jcl-1.7.28.jar | Binding for Jakarta Commons Logging. This binding will delegate all SLF4J logging to JCL.
logback-classic-1.2.3.jar (requires logback-core-1.2.3.jar) | NATIVE IMPLEMENTATION There are also SLF4J bindings external to the SLF4J project, e.g. [logback](http://logback.qos.ch/) which implements SLF4J natively. Logback's [ch.qos.logback.classic.Logger](http://logback.qos.ch/apidocs/ch/qos/logback/classic/Logger.html) class is a direct implementation of SLF4J's [org.slf4j.Logger](http://www.slf4j.org/apidocs/org/slf4j/Logger.html) interface. Thus, using SLF4J in conjunction with logback involves strictly zero memory and computational overhead.
|||

To switch logging frameworks, **just replace slf4j bindings on your class path**. For example, to switch from `java.util.logging` to `log4j`, just replace `slf4j-jdk14-1.7.28.jar` with `slf4j-log4j12-1.7.28.jar`.

SLF4J does not rely on any special class loader machinery. In fact, each SLF4J binding is **hardwired at compile time** to use one and only one specific logging framework. For example, the `slf4j-log4j12-1.7.28.jar` binding is bound at compile time to use `log4j`. In your code, in addition to `slf4j-api-1.7.28.jar`, you simply **drop one and only one binding of your choice onto the appropriate class path location**. Do not place more than one binding on your class path. Here is a graphical illustration of the general idea.

![fig1](./fig/SLF4J_user_manual/concrete-bindings.png)

The SLF4J interfaces and their various adapters are extremely simple. Most developers familiar with the Java language should be able to read and fully understand the code in less than one hour. No knowledge of class loaders is necessary as SLF4J does not make use nor does it directly access any class loaders. As a consequence, SLF4J suffers from none of the class loader problems or memory leaks observed with Jakarta Commons Logging (JCL).

Given the simplicity of the SLF4J interfaces and its deployment model, developers of new logging frameworks should find it very easy to write SLF4J bindings.

## Libraries

...

## Declaring project dependencies for logging

Given Maven's transitive dependency rules, for "regular" projects (not libraries or frameworks) declaring logging dependencies can be **accomplished with a single dependency declaration**.

**LOGBACK-CLASSIC** If you wish to use logback-classic as the underlying logging framework, all you need to do is to declare "`ch.qos.logback:logback-classic`" as a dependency in your pom.xml file as shown below. In addition to `logback-classic-1.2.3.jar`, this will pull `slf4j-api-1.7.28.jar` as well as `logback-core-1.2.3.jar` into your project. Note that explicitly declaring a dependency on `logback-core-1.2.3` or `slf4j-api-1.7.28.jar` is not wrong and may be necessary to impose the correct version of said artifacts by virtue of Maven's "nearest definition" dependency mediation rule.

    <dependency> 
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.3</version>
    </dependency>

**LOG4J** If you wish to use log4j as the underlying logging framework, all you need to do is to declare "`org.slf4j:slf4j-log4j12`" as a dependency in your `pom.xml` file as shown below. In addition to `slf4j-log4j12-1.7.28.jar`, this will pull `slf4j-api-1.7.28.jar` as well as `log4j-1.2.17.jar` into your project. Note that explicitly declaring a dependency on `log4j-1.2.17.jar` or `slf4j-api-1.7.28.jar` is not wrong and **may be necessary** to impose the correct version of said artifacts by virtue of Maven's "nearest definition" dependency mediation rule.

    <dependency> 
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-log4j12</artifactId>
        <version>1.7.28</version>
    </dependency>

**JAVA.UTIL.LOGGING** If you wish to use `java.util.logging` as the underlying logging framework, all you need to do is to declare "`org.slf4j:slf4j-jdk14`" as a dependency in your `pom.xml` file as shown below. In addition to `slf4j-jdk14-1.7.28.jar`, this will pull `slf4j-api-1.7.28.jar` into your project. Note that explicitly declaring a dependency on `slf4j-api-1.7.28.jar` is not wrong and may be necessary to impose the correct version of said artifact by virtue of Maven's "nearest definition" dependency mediation rule.

    <dependency> 
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-jdk14</artifactId>
        <version>1.7.28</version>
    </dependency>

## Binary compatibility

...

## Consolidate logging via SLF4J

Often times, a given project will depend on various components which rely on logging APIs other than SLF4J. It is common to find projects depending on a combination of `JCL`, `java.util.logging`, `log4j` and `SLF4J`. It then becomes desirable to consolidate logging through a single channel. SLF4J caters for this common use-case by providing bridging modules for `JCL`, `java.util.logging` and `log4j`. For more details, please refer to the page on [Bridging legacy APIs](http://www.slf4j.org/legacy.html).

## Mapped Diagnostic Context (MDC) support

...

## Executive summary

...
