# [Creating a Custom Logback Appender](https://www.baeldung.com/custom-logback-appender)

- [Creating a Custom Logback Appender](#creating-a-custom-logback-appender)
  - [1. Introduction](#1-introduction)
  - [2. Base Logback Appenders](#2-base-logback-appenders)
  - [3. Custom Appender](#3-custom-appender)
  - [4. Setting Properties](#4-setting-properties)
  - [5. Error Handling](#5-error-handling)
  - [6. Conclusion](#6-conclusion)

## 1. Introduction

In this article, we'll explore creating a custom Logback appender. If you are looking for the introduction to logging in Java, please take a look at [this article](https://www.baeldung.com/java-logging-intro).

Logback ships with many built-in appenders that write to **standard out**, **file system**, or **database**. The beauty of this framework’s architecture is its modularity, which means we can easily customize it.

In this tutorial, we'll focus on logback-classic, which requires the following Maven dependency:

    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.3</version>
    </dependency>

The latest version of this dependency is available on Maven Central.

## 2. Base Logback Appenders

Logback provides base classes we can extend to create a custom appender.

`Appender` is the generic interface that all appenders must implement. The **generic type** is either `ILoggingEvent` or `AccessEvent`, depending on if we're using `logback-classic` or `logback-access`, respectively.

Our custom appender should extend either `AppenderBase` or `UnsynchronizedAppenderBase`, which both implement `Appender` and handle functions such as filters and status messages.

`AppenderBase` is thread-safe; `UnsynchronizedAppenderBase` subclasses are responsible for managing their thread safety.

Just as the `ConsoleAppender` and the `FileAppender` both extend `OutputStreamAppender` and call the super method `setOutputStream()`, the custom appender should subclass `OutputStreamAppender` if it is writing to an `OutputStream`.

## 3. Custom Appender

For our custom example, we'll create a toy appender named `MapAppender`. This appender will insert all logging events into a `ConcurrentHashMap`, with the timestamp for the key. To begin, we'll subclass `AppenderBase` and use `ILoggingEvent` as the **generic type**:

    public class MapAppender extends AppenderBase<ILoggingEvent> {
    
        private ConcurrentMap<String, ILoggingEvent> eventMap 
        = new ConcurrentHashMap<>();
    
        @Override
        protected void append(ILoggingEvent event) {
            eventMap.put(System.currentTimeMillis(), event);
        }
        
        public Map<String, ILoggingEvent> getEventMap() {
            return eventMap;
        }
    }

Next, to enable the `MapAppender` to start receiving logging events, let's add it as an appender in our configuration file `logback.xml`:

    <configuration>
        <appender name="map" class="com.baeldung.logback.MapAppender"/>
        <root level="info">
            <appender-ref ref="map"/>
        </root>
    </configuration>

## 4. Setting Properties

Logback uses **JavaBeans introspection** to analyze properties set on the appender. Our custom appender will need **getter and setter methods** to allow the introspector to find and set these properties.

Let's add a property to `MapAppender` that gives the eventMap a prefix for its key:

    public class MapAppender extends AppenderBase<ILoggingEvent> {
    
        //...
    
        private String prefix;
    
        @Override
        protected void append(ILoggingEvent event) {
            eventMap.put(prefix + System.currentTimeMillis(), event);
        }
    
        public String getPrefix() {
            return prefix;
        }
    
        public void setPrefix(String prefix) {
            this.prefix = prefix;
        }
    
        //...
    
    }

Next, add a property to our configuration to set this prefix:

    <configuration debug="true">
    
        <appender name="map" class="com.baeldung.logback.MapAppender">
            <prefix>test</prefix>
        </appender>
    
        //...
    
    </configuration>

## 5. Error Handling

To handle errors during the creation and configuration of our custom appender, we can use methods inherited from `AppenderBase`.

For example, when the prefix property is a null or an empty string, the `MapAppender` can call `addError()` and return early:

    public class MapAppender extends AppenderBase<ILoggingEvent> {
    
        //...
    
        @Override
        protected void append(final ILoggingEvent event) {
            if (prefix == null || "".equals(prefix)) {
                addError("Prefix is not set for MapAppender.");
                return;
            }
    
            eventMap.put(prefix + System.currentTimeMillis(), event);
        }
    
        //...
    
    }

When the debug flag is turned on in our configuration, we'll see an error in the console that alerts us that the prefix property has not been set:

    <configuration debug="true">
    
        //...
    
    </configuration>

## 6. Conclusion

In this quick tutorial, we focused on how to implement our custom appender for Logback.

As usual, the example can be found [over on Github](https://github.com/eugenp/tutorials/tree/master/logging-modules/logback).
