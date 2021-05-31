# [Dynamic Proxies in Java](https://www.baeldung.com/java-dynamic-proxies)

- [Dynamic Proxies in Java](#dynamic-proxies-in-java)
  - [1. Introduction](#1-introduction)
  - [2. Invocation Handler](#2-invocation-handler)
  - [3. Creating Proxy Instance](#3-creating-proxy-instance)
  - [4. Invocation Handler via Lambda Expressions](#4-invocation-handler-via-lambda-expressions)
  - [5. Timing Dynamic Proxy Example](#5-timing-dynamic-proxy-example)
  - [6. Conclusion](#6-conclusion)

## 1. Introduction

This article is about [Java's dynamic proxies](https://docs.oracle.com/javase/8/docs/technotes/guides/reflection/proxy.html) – which is one of the primary proxy mechanisms available to us in the language.

Simply put, proxies are fronts or wrappers that pass function invocation through their own facilities (usually onto real methods) – potentially **adding some functionality**.

Dynamic proxies allow one single class with one single method to service multiple method calls to arbitrary classes with an arbitrary number of methods. A dynamic proxy can be thought of as a kind of Facade, but one that can pretend to be an implementation of any interface. Under the cover, **it routes all method invocations to a single handler** – the `invoke()` method.

While it's not a tool meant for everyday programming tasks, dynamic proxies can be quite useful for framework writers. It may also be used in those cases where concrete class implementations won't be known until run-time.

This feature is built into the standard JDK, hence no additional dependencies are required.

## 2. Invocation Handler

Let us build a simple proxy that doesn't actually do anything except printing what method was requested to be invoked and return a hard-coded number.

First, we need to create a subtype of `java.lang.reflect.InvocationHandler`:

    public class DynamicInvocationHandler implements InvocationHandler {

        private static Logger LOGGER = LoggerFactory.getLogger(
        DynamicInvocationHandler.class);

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) 
        throws Throwable {
            LOGGER.info("Invoked method: {}", method.getName());

            return 42;
        }
    }

Here we've defined a simple proxy that logs which method was invoked and returns 42.

## 3. Creating Proxy Instance

A proxy instance serviced by the invocation handler we have just defined is created via a factory method call on the `java.lang.reflect.Proxy` class:

    Map proxyInstance = (Map) Proxy.newProxyInstance(
      DynamicProxyTest.class.getClassLoader(), 
      new Class[] { Map.class }, 
      new DynamicInvocationHandler());

Once we have a proxy instance we can invoke its interface methods as normal:

    proxyInstance.put("hello", "world");

As expected a message about `put()` method being invoked is printed out in the log file.

## 4. Invocation Handler via Lambda Expressions

Since `InvocationHandler` is a functional interface, it is possible to define the handler inline using lambda expression:

    Map proxyInstance = (Map) Proxy.newProxyInstance(
      DynamicProxyTest.class.getClassLoader(), 
      new Class[] { Map.class }, 
      (proxy, method, methodArgs) -> {
        if (method.getName().equals("get")) {
            return 42;
        } else {
            throw new UnsupportedOperationException(
              "Unsupported method: " + method.getName());
        }
    });

Here, we defined a handler that returns 42 for all get operations and throws `UnsupportedOperationException` for everything else.

It's invoked in the exactly the same way:

    (int) proxyInstance.get("hello"); // 42
    proxyInstance.put("hello", "world"); // exception

## 5. Timing Dynamic Proxy Example

Let's examine one potential real-world scenario for dynamic proxies.

Suppose we want to record how long our functions take to execute. To this extent, we first define a handler capable of wrapping the “real” object, tracking timing information and reflective invocation:

    public class TimingDynamicInvocationHandler implements InvocationHandler {
    
        private static Logger LOGGER = LoggerFactory.getLogger(
          TimingDynamicInvocationHandler.class);
        
        private final Map<String, Method> methods = new HashMap<>();
    
        private Object target;
    
        public TimingDynamicInvocationHandler(Object target) {
            this.target = target;
    
            for(Method method: target.getClass().getDeclaredMethods()) {
                this.methods.put(method.getName(), method);
            }
        }
    
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) 
          throws Throwable {
            long start = System.nanoTime();
            Object result = methods.get(method.getName()).invoke(target, args);
            long elapsed = System.nanoTime() - start;
    
            LOGGER.info("Executing {} finished in {} ns", method.getName(), 
              elapsed);
    
            return result;
        }
    }

Subsequently, this proxy can be used on various object types:

    Map mapProxyInstance = (Map) Proxy.newProxyInstance(
      DynamicProxyTest.class.getClassLoader(), new Class[] { Map.class }, 
      new TimingDynamicInvocationHandler(new HashMap<>()));
    
    mapProxyInstance.put("hello", "world");
    
    CharSequence csProxyInstance = (CharSequence) Proxy.newProxyInstance(
      DynamicProxyTest.class.getClassLoader(), 
      new Class[] { CharSequence.class }, 
      new TimingDynamicInvocationHandler("Hello World"));
    
    csProxyInstance.length()

Here, we have proxied a map and a char sequence (String).

Invocations of the proxy methods will delegate to the wrapped object as well as produce logging statements:

    Executing put finished in 19153 ns 
    Executing get finished in 8891 ns 
    Executing charAt finished in 11152 ns 
    Executing length finished in 10087 ns

## 6. Conclusion

In this quick tutorial, we have examined Java's dynamic proxies as well as some of its possible usages.

As always, the code in the examples can be found [over on GitHub](https://github.com/eugenp/tutorials/tree/master/core-java-modules/core-java-reflection).
