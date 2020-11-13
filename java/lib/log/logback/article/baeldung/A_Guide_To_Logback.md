# [A Guide To Logback](https://www.baeldung.com/logback)

- [A Guide To Logback](#a-guide-to-logback)
  - [1. Overview](#1-overview)
  - [2. Logback Architecture](#2-logback-architecture)
  - [3. Setup](#3-setup)
    - [3.1. Maven Dependency](#31-maven-dependency)
    - [3.2. Classpath](#32-classpath)
  - [4. Basic Example and Configuration](#4-basic-example-and-configuration)
  - [5. Logger Contexts](#5-logger-contexts)
    - [5.1. Creating a Context](#51-creating-a-context)
    - [5.2. Using a Context](#52-using-a-context)
    - [5.3. Parameterized Messages](#53-parameterized-messages)
  - [6. Detailed Configuration](#6-detailed-configuration)
    - [6.1. Locating Configuration Information](#61-locating-configuration-information)
    - [6.2. Basic Configuration](#62-basic-configuration)
    - [6.3. Troubleshooting Configuration](#63-troubleshooting-configuration)
    - [6.4. Reloading Configuration Automatically](#64-reloading-configuration-automatically)
    - [6.5. Modifying Loggers](#65-modifying-loggers)
    - [6.6. Variable Substitution](#66-variable-substitution)
  - [7. Appenders](#7-appenders)
    - [7.1. ConsoleAppender](#71-consoleappender)
    - [7.2. FileAppender](#72-fileappender)
    - [7.3. RollingFileAppender](#73-rollingfileappender)
    - [7.4. Custom Appenders](#74-custom-appenders)
  - [8. Layouts](#8-layouts)
  - [9. Conclusion](#9-conclusion)

## 1. Overview

[Logback](https://logback.qos.ch/) is one of the most widely used logging frameworks in the Java Community. It's a [replacement for its predecessor, Log4j](https://logback.qos.ch/reasonsToSwitch.html). Logback offers a faster implementation than Log4j, provides more options for configuration, and more flexibility in archiving old log files.

## 2. Logback Architecture

Three classes comprise the Logback architecture: **Logger**, **Appender**, and **Layout**.

- A logger is a context for log messages. This is the class that **applications interact with** to create log messages.

- Appenders place log messages in their **final destinations**. A Logger can have **more than one** Appender. We generally think of Appenders as being attached to text files, but Logback is much more potent than that.

- Layout prepares messages for outputting. Logback supports the creation of custom classes for **formatting messages**, as well as robust configuration options for the existing ones.

## 3. Setup

### 3.1. Maven Dependency

Logback uses the **Simple Logging Facade** for Java (SLF4J) as its native interface. Before we can start logging messages, we need to add Logback and Slf4j to our pom.xml:

    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-core</artifactId>
        <version>1.2.3</version>
    </dependency>
    
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>1.7.30</version>
        <scope>test</scope>
    </dependency>

Maven Central has the [latest version of the Logback Core](https://search.maven.org/classic/#search%7Cgav%7C1%7Cg%3A%22ch.qos.logback%22%20AND%20a%3A%22logback-core%22) and the [most recent version of slf4j-api](https://search.maven.org/classic/#search%7Cgav%7C1%7Cg%3A%22org.slf4j%22%20AND%20a%3A%22slf4j-api%22).

### 3.2. Classpath

Logback also requires [logback-classic.jar](https://search.maven.org/classic/#search%7Cga%7C1%7Clogback-classic) on the classpath for runtime.

We'll add this to pom.xml as a test dependency:

    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.3</version>
    </dependency>

## 4. Basic Example and Configuration

Let's start with a quick example of using Logback in an application.

First, we need a configuration file. We'll create a text file named logback.xml and put it somewhere in our classpath:

    <configuration>
        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
    
        <root level="debug">
            <appender-ref ref="STDOUT" />
        </root>
    </configuration>

Next, we need a simple class with a main method:

    public class Example {
    
        private static final Logger logger = LoggerFactory.getLogger(Example.class);
    
        public static void main(String[] args) {
            logger.info("Example log from {}", Example.class.getSimpleName());
        }
    }

This class creates a `Logger` and calls `info()` to generate a log message.

When we run Example we see our message logged to the console:

    20:34:22.136 [main] INFO Example - Example log from Example

It's easy to see why Logback is so popular; we're up in running in minutes.

This configuration and code give us a few hints as to how this works.

- We have an appender named STDOUT that references a class name `ConsoleAppender`.
- There is a pattern that describes the format of our log message.
- Our code creates a `Logger` and we passed our message to it via an `info()` method.

Now that we understand the basics, let's have a closer look.

## 5. Logger Contexts

### 5.1. Creating a Context

To log a message to Logback, we initialized a `Logger` from SLF4J or Logback:

private static final Logger logger = LoggerFactory.getLogger(Example.class);

And then used it:

    logger.info("Example log from {}", Example.class.getSimpleName());

This is our logging context. When we created it, we passed `LoggerFactory` our class. This gives the `Logger` a name (there is also an overload that accepts a `String`).

Logging contexts exist in a hierarchy that closely resembles the Java object hierarchy:

- A logger is an **ancestor** when its name, followed by a dot, prefixes a descendant logger's name
- A logger is a **parent** when there are no ancestors between it and a child

For example, the `Example` class below is in the `com.baeldung.logback package`. There's another class named `ExampleAppender` in the `com.baeldung.logback.appenders` package.

`ExampleAppender`'s Logger is a **child** of `Example`'s Logger.

**All loggers are descendants of the predefined root logger**.

A Logger has a Level, which can be set either via configuration or with `Logger.setLevel()`. Setting the level in code overrides configuration files.

The possible levels are, in order of precedence: `TRACE`, `DEBUG`, `INFO`, `WARN` and `ERROR`. Each level has a corresponding method that we use to log a message at that level.

**If a Logger isn't explicitly assigned a level, it inherits the level of its closest ancestor**. The **root logger** defaults to `DEBUG`. We'll see how to override this below.

### 5.2. Using a Context

Let's create an example program that demonstrates using a context within logging hierarchies:

    ch.qos.logback.classic.Logger parentLogger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger("com.baeldung.logback");
 
    parentLogger.setLevel(Level.INFO);
 
    Logger childlogger = (ch.qos.logback.classic.Logger)LoggerFactory.getLogger("com.baeldung.logback.tests");
 
    parentLogger.warn("This message is logged because WARN > INFO.");
    parentLogger.debug("This message is not logged because DEBUG < INFO.");
    childlogger.info("INFO == INFO");
    childlogger.debug("DEBUG < INFO");

When we run this, we see these messages:

    20:31:29.586 [main] WARN com.baeldung.logback - This message is logged because WARN > INFO.
    20:31:29.594 [main] INFO com.baeldung.logback.tests - INFO == INFO

We start by retrieving a `Logger` named `com.baeldung.logback` and cast it to a `ch.qos.logback.classic.Logger`.

A Logback context is needed to set the level in the next statement; note that the SLF4J's abstract logger does not implement `setLevel()`.

We set the level of our context to `INFO`; we then create another logger named `com.baeldung.logback.tests`.

We log two messages with each context to demonstrate the hierarchy. Logback logs the `WARN`, and `INFO` messages and filters the `DEBUG` messages.

Now, let's use the root logger:

    ch.qos.logback.classic.Logger logger = (ch.qos.logback.classic.Logger)LoggerFactory.getLogger("com.baeldung.logback");
    logger.debug("Hi there!");
    
    Logger rootLogger = (ch.qos.logback.classic.Logger)LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME);
    logger.debug("This message is logged because DEBUG == DEBUG.");
    
    rootLogger.setLevel(Level.ERROR);
    
    logger.warn("This message is not logged because WARN < ERROR.");
    logger.error("This is logged.");

We see these messages when we execute this snippet:

    20:44:44.241 [main] DEBUG com.baeldung.logback - Hi there!
    20:44:44.243 [main] DEBUG com.baeldung.logback - This message is logged because DEBUG == DEBUG.
    20:44:44.243 [main] ERROR com.baeldung.logback - This is logged.

To conclude, we started with a Logger context and printed a `DEBUG` message.

We then retrieved the root logger using its statically defined name and set its level to `ERROR`.

And finally, we demonstrated that Logback actually does filter any statement less than an error.

### 5.3. Parameterized Messages

Unlike the messages in the sample snippets above, most useful log messages required appending `Strings`. This entails allocating memory, serializing objects, concatenating Strings, and potentially cleaning up the garbage later.

Consider the following message:

    log.debug("Current count is " + count);

We incur the cost of building the message whether the Logger logs the message or not.

Logback offers an alternative with its parameterized messages:

    log.debug("Current count is {}", count);

The braces `{}` will accept any Object and uses its `toString()` method to build a message only **after verifying that the log message is required**.

Let's try some different parameters:

    String message = "This is a String";
    Integer zero = 0;
    
    try {
        logger.debug("Logging message: {}", message);
        logger.debug("Going to divide {} by {}", 42, zero);
        int result = 42 / zero;
    } catch (Exception e) {
        logger.error("Error dividing {} by {} ", 42, zero, e);
    }

This snippet yields:

    21:32:10.311 [main] DEBUG com.baeldung.logback.LogbackTests - Logging message: This is a String
    21:32:10.316 [main] DEBUG com.baeldung.logback.LogbackTests - Going to divide 42 by 0
    21:32:10.316 [main] ERROR com.baeldung.logback.LogbackTests - Error dividing 42 by 0
    java.lang.ArithmeticException: / by zero
    at com.baeldung.logback.LogbackTests.givenParameters_ValuesLogged(LogbackTests.java:64)
    ...

We see how a `String`, an `int`, and an `Integer` can be passed in as parameters.

Also, when an Exception is passed as the last argument to a logging method, Logback will print the **stack trace** for us.

## 6. Detailed Configuration

In the previous examples, we were using the 11-line configuration file to we created in section 4 to print log messages to the console. This is Logback's default behavior; if it cannot find a configuration file, it creates a `ConsoleAppender` and associates it with the **root logger**.

### 6.1. Locating Configuration Information

A configuration file can be placed in the classpath and named either `logback.xml` or `logback-test.xml`.

Here's how Logback will attempt to find configuration data:

- Search for files named `logback-test`.xml, `logback.groovy`, or `logback.xml` in the `classpath`, in that order.
- If the library does not find those files, it will attempt to use Java's `ServiceLoader` to locate an implementor of the `com.qos.logback.classic.spi.Configurator`.
- Configure itself to log output directly to the console

Note: the current version of Logback does not support Groovy configuration due to there not being a version of Groovy compatible with Java 9.

### 6.2. Basic Configuration

Let's take a closer look at our [example configuration](https://www.baeldung.com/logback#example).

The entire file is in `<configuration>` tags.

We see a tag that declares an `Appender` of type `ConsoleAppender`, and names it `STDOUT`. Nested within that tag is an `encoder`. It has a pattern with what looks like `sprintf-style` escape codes:

    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

Last, we see a `root` tag. This tag sets the root logger to `DEBUG` mode and associates its output with the `Appender` named `STDOUT`:

    <root level="debug">
        <appender-ref ref="STDOUT" />
    </root>

### 6.3. Troubleshooting Configuration

Logback configuration files can get complicated, so there are several built-in mechanisms for troubleshooting.

To **see debug information as Logback processes the configuration**, you can turn on debug logging:

    <configuration debug="true">
        ...
    </configuration>

Logback will print status information to the console as it processes the configuration:

    23:54:23,040 |-INFO in ch.qos.logback.classic.LoggerContext[default] - Found resource [logback-test.xml] 
      at [file:/Users/egoebelbecker/ideaProjects/logback-guide/out/test/resources/logback-test.xml]
    23:54:23,230 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - About to instantiate appender 
      of type [ch.qos.logback.core.ConsoleAppender]
    23:54:23,236 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - Naming appender as [STDOUT]
    23:54:23,247 |-INFO in ch.qos.logback.core.joran.action.NestedComplexPropertyIA - Assuming default type 
      [ch.qos.logback.classic.encoder.PatternLayoutEncoder] for [encoder] property
    23:54:23,308 |-INFO in ch.qos.logback.classic.joran.action.RootLoggerAction - Setting level of ROOT logger to DEBUG
    23:54:23,309 |-INFO in ch.qos.logback.core.joran.action.AppenderRefAction - Attaching appender named [STDOUT] to Logger[ROOT]
    23:54:23,310 |-INFO in ch.qos.logback.classic.joran.action.ConfigurationAction - End of configuration.
    23:54:23,313 |-INFO in ch.qos.logback.classic.joran.JoranConfigurator@5afa04c - Registering current configuration 
      as safe fallback point

If warnings or errors are encountered while parsing the configuration file, Logback writes status messages to the console.

There is a second mechanism for printing status information:

    <configuration>
        <statusListener class="ch.qos.logback.core.status.OnConsoleStatusListener" />  
            ...
    </configuration>

The `StatusListener` intercepts status messages and prints them during configuration and while the program is running.

The output from all configuration files is printed, making it useful for locating “rogue” configuration files on the classpath.

### 6.4. Reloading Configuration Automatically

Reloading logging configuration while an application is running is a powerful troubleshooting tool. Logback makes this possible with the scan parameter:

    <configuration scan="true">
        ...
    </configuration>

The default behavior is to scan the configuration file for changes every 60 seconds. Modify this interval by adding scanPeriod:

    <configuration scan="true" scanPeriod="15 seconds">
        ...
    </configuration>

We can specify values in milliseconds, seconds, minutes, or hours.

### 6.5. Modifying Loggers

In our sample file above we set the level of the root logger and associated it with the console `Appender`.

We can set the level for any logger:

    <configuration>
        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
        <logger name="com.baeldung.logback" level="INFO" /> 
        <logger name="com.baeldung.logback.tests" level="WARN" /> 
        <root level="debug">
            <appender-ref ref="STDOUT" />
        </root>
    </configuration>

Let's add this to our classpath and run this code:

    Logger foobar = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger("com.baeldung.foobar");
    Logger logger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger("com.baeldung.logback");
    Logger testslogger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger("com.baeldung.logback.tests");
    
    foobar.debug("This is logged from foobar");
    logger.debug("This is not logged from logger");
    logger.info("This is logged from logger");
    testslogger.info("This is not logged from tests");
    testslogger.warn("This is logged from tests");

We see this output:

    00:29:51.787 [main] DEBUG com.baeldung.foobar - This is logged from foobar
    00:29:51.789 [main] INFO com.baeldung.logback - This is logged from logger
    00:29:51.789 [main] WARN com.baeldung.logback.tests - This is logged from tests

By not setting the level of our Loggers programmatically, the configuration sets them; `com.baeldung.foobar` inherits `DEBUG` from the root logger.

Loggers also inherit the `appender-ref` from the root logger. As we'll see below, we can override this.

### 6.6. Variable Substitution

Logback configuration files support variables. We define variables inside the configuration script or externally. A variable can be specified at any point in a configuration script in place of a value.

For example, here is the configuration for a `FileAppender`:

    <property name="LOG_DIR" value="/var/log/application" />
    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>${LOG_DIR}/tests.log</file>
        <append>true</append>
        <encoder>
            <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
        </encoder>
    </appender>

At the top of the configuration, we declared a property named `LOG_DIR`. Then we used it as part of the path to the file inside the appender definition.

Properties are declared in a `<property>` tag in configuration scripts. But they are also available from outside sources, such as `system properties`. We could omit the property declaration in this example and set the value of `LOG_DIR` on the command line:

    $ java -DLOG_DIR=/var/log/application com.baeldung.logback.LogbackTests

We specify the value of the property with `${propertyname}`. Logback implements variables as **text replacement**. Variable substitution can occur at any point in a configuration file where a value can be specified.

## 7. Appenders

Loggers pass `LoggingEvents` to `Appenders`. `Appenders` do the actual work of logging. We usually think of logging as something that goes to a file or the console, but Logback is capable of much more. `Logback-core` provides several useful appenders.

### 7.1. ConsoleAppender

We've seen `ConsoleAppender` in action already. Despite its name, `ConsoleAppender` appends messages to `System.out` or `System.err`.

It uses an `OutputStreamWriter` to buffer the I/O, so directing it to `System.err` does not result in unbuffered writing.

### 7.2. FileAppender

`FileAppender` appends messages to a file. It supports a broad range of configuration parameters. Let's add a file appender to our basic configuration:

    <configuration debug="true">
        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <!-- encoders are assigned the type
                ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
    
        <appender name="FILE" class="ch.qos.logback.core.FileAppender">
            <file>tests.log</file>
            <append>true</append>
            <encoder>
                <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
            </encoder>
        </appender>
        
        <logger name="com.baeldung.logback" level="INFO" /> 
        <logger name="com.baeldung.logback.tests" level="WARN"> 
            <appender-ref ref="FILE" /> 
        </logger> 
    
        <root level="debug">
            <appender-ref ref="STDOUT" />
        </root>
    </configuration>

The `FileAppender` is configured with a file name via `<file>`. The `<append>` tag instructs the `Appender` to append to an existing file rather than truncating it. If we run the test several times, we see that the logging output is appended to the same file.

If we re-run our test from above, messages from `com.baeldung.logback.tests` go to both the console and to a file named `tests.log`. The descendant logger inherits the root logger's association with the `ConsoleAppender` with its association with `FileAppender`. Appenders are cumulative.

We can override this behavior:

    <logger name="com.baeldung.logback.tests" level="WARN" additivity="false" > 
        <appender-ref ref="FILE" /> 
    </logger> 
    
    <root level="debug">
        <appender-ref ref="STDOUT" />
    </root>

Setting **additivity** to false disables the default behavior. Tests will not log to the console, and neither will any of its descendants.

### 7.3. RollingFileAppender

Oftentimes, appending log messages to the same file is not the behavior we need. We want files to “roll” based on **time**, log file **size**, or a **combination of both**.

For this, we have `RollingFileAppender`:

    <property name="LOG_FILE" value="LogFile" />
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_FILE}.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- daily rollover -->
            <fileNamePattern>${LOG_FILE}.%d{yyyy-MM-dd}.gz</fileNamePattern>
    
            <!-- keep 30 days' worth of history capped at 3GB total size -->
            <maxHistory>30</maxHistory>
            <totalSizeCap>3GB</totalSizeCap>
        </rollingPolicy>
        <encoder>
            <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
        </encoder>
    </appender> 

A `RollingFileAppender` has a `RollingPolicy`. In this sample configuration, we see a `TimeBasedRollingPolicy`.

Similar to the `FileAppender`, we configured this appender with a file name. We declared a property and used it for this because we'll be reusing the file name below.

We define a `fileNamePattern` inside the `RollingPolicy`. This pattern defines not just the name of files, but also how often to roll them. `TimeBasedRollingPolicy` examines the pattern and rolls at the most finely defined period.

For example:

    <property name="LOG_FILE" value="LogFile" />
    <property name="LOG_DIR" value="/var/logs/application" />
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_DIR}/${LOG_FILE}.log</file> 
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_DIR}/%d{yyyy/MM}/${LOG_FILE}.gz</fileNamePattern>
            <totalSizeCap>3GB</totalSizeCap>
        </rollingPolicy>

The active log file is `/var/logs/application/LogFile`. This file rolls over at the beginning of each month into `/Current Year/Current Month/LogFile.gz` and `RollingFileAppender` creates a new active file.

When the total size of archived files reaches 3GB, `RollingFileAppender` deletes archives on a first-in-first-out basis.

There are codes for a week, hour, minute, second, and even millisecond. Logback has a reference here.

`RollingFileAppender` also has built-in support for compressing files. It compresses our rolled files because named our them `LogFile.gz`.

`TimeBasedPolicy` isn't our only option for rolling files. Logback also offers `SizeAndTimeBasedRollingPolicy`, which will roll based on current log file size as well as time. It also offers a `FixedWindowRollingPolicy` which rolls log file names each time the logger is started.

We can also write our own [`RollingPolicy`](https://logback.qos.ch/manual/appenders.html#onRollingPolicies).

### 7.4. Custom Appenders

We can create custom appenders by extending one of Logback's base appender classes. We have a tutorial for creating custom appenders [here](https://www.baeldung.com/custom-logback-appender).

## 8. Layouts

Layouts format log messages. Like the rest of Logback, Layouts are extensible and we can [create our own](https://logback.qos.ch/manual/layouts.html#writingYourOwnLayout). However, the default `PatternLayout` offers what most applications need and then some.

We've used `PatternLayout` in all of our examples so far:

    <encoder>
        <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
    </encoder>

This configuration script contains the configuration for `PatternLayoutEncoder`. We pass an `Encoder` to our `Appender`, and this encoder uses the `PatternLayout` to format the messages.

The text in the `<pattern>` tag defines how log messages are formatting. `PatternLayout` implements a large variety of conversion words and format modifiers for creating patterns.

Let's break this one down. `PatternLayout` recognizes conversion words with a `%`, so the conversions in our pattern generate:

- %d{HH:mm:ss.SSS} – a timestamp with hours, minutes, seconds and milliseconds
- [%thread] – the thread name generating the log message, surrounded by square brackets
- %-5level – the level of the logging event, padded to 5 characters
- %logger{36} – the name of the logger, truncated to 35 characters
- %msg%n – the log messages followed by the platform dependent line separator character

So we see messages similar to this:

    21:32:10.311 [main] DEBUG com.baeldung.logback.LogbackTests - Logging message: This is a String

An exhaustive list of conversion words and format modifiers can be found [here](https://logback.qos.ch/manual/layouts.html#conversionWord).

## 9. Conclusion

In this extensive guide, we covered the fundamentals of using Logback in an application.

We looked at the three major components in Logback's architecture: **loggers**, **appenders**, and **layout**. Logback's has powerful configuration scripts, which we used to manipulate components for filtering and formatting messages. We also looked at the two most commonly used file appenders to create, roll over, organize, and compress log files.

As usual, code snippets can be found [over on GitHub](https://github.com/eugenp/tutorials/tree/master/logging-modules/logback).
