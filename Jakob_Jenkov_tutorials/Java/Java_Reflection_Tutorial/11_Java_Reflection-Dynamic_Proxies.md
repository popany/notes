# [Java Reflection - Dynamic Proxies](http://tutorials.jenkov.com/java-reflection/dynamic-proxies.html)

- [Java Reflection - Dynamic Proxies](#java-reflection---dynamic-proxies)
  - [Creating Proxies](#creating-proxies)
  - [InvocationHandler's](#invocationhandlers)
  - [Known Use Cases](#known-use-cases)
    - [Database Connection and Transaction Management](#database-connection-and-transaction-management)
    - [Dynamic Mock Objects for Unit Testing](#dynamic-mock-objects-for-unit-testing)
  - [Adaptation of DI Container to Custom Factory Interfaces](#adaptation-of-di-container-to-custom-factory-interfaces)
    - [AOP-like Method Interception](#aop-like-method-interception)

Using Java Reflection you create **dynamic implementations of interfaces** at runtime. You do so using the class `java.lang.reflect.Proxy`. The name of this class is why I refer to these dynamic interface implementations as dynamic proxies. Dynamic proxies can be used for many different purposes, e.g. **database connection** and **transaction management**, **dynamic mock** objects for unit testing, and other **AOP**-like method intercepting purposes.

## Creating Proxies

You create dynamic proxies using the `Proxy.newProxyInstance()` method. The `newProxyInstance()` methods takes 3 parameters:

1. The `ClassLoader` that is to "load" the dynamic proxy class.
2. An array of interfaces to implement.
3. An `InvocationHandler` to forward all methods calls on the proxy to.

Here is an example:

    InvocationHandler handler = new MyInvocationHandler();
    MyInterface proxy = (MyInterface) Proxy.newProxyInstance(
                                MyInterface.class.getClassLoader(),
                                new Class[] { MyInterface.class },
                                handler);

After running this code the `proxy` variable contains a dynamic implementation of the `MyInterface` interface. All calls to the proxy will be forwarded to the `handler` implementation of the general `InvocationHandler` interface. InvocationHandler's are covered in the next section.

## InvocationHandler's

As mentioned earlier you must pass an `InvocationHandler` implementation to the `Proxy.newProxyInstance()` method. All method calls to the dynamic proxy are forwarded to this `InvocationHandler` implementation. Here is how the `InvocationHandler` interface looks:

    public interface InvocationHandler{
      Object invoke(Object proxy, Method method, Object[] args)
             throws Throwable;
    }

Here is an example implementation:

    public class MyInvocationHandler implements InvocationHandler{
    
      public Object invoke(Object proxy, Method method, Object[] args)
      throws Throwable {
        //do something "dynamic"
      }
    }

The `proxy` parameter passed to the `invoke()` method is the dynamic proxy object implementing the interface. Most often you don't need this object.

The `Method` object passed into the `invoke()` method represents the method called on the interface the dynamic proxy implements. From the `Method` object you can obtain the method name, parameter types, return type, etc. See the text on [Methods](http://tutorials.jenkov.com/java-reflection/methods.html) for more information.

The `Object[] args` array contains the parameter values passed to the proxy when the method in the interface implemented was called. Note: Primitives (int, long etc) in the implemented interface are wrapped in their object counterparts (Integer, Long etc.).

## Known Use Cases

Dynamic proxies are known to be used for at least the following purposes:

- Database Connection and Transaction Management
- Dynamic Mock Objects for Unit Testing
- Adaptation of DI Container to Custom Factory Interfaces
- AOP-like Method Interception

### Database Connection and Transaction Management

The Spring framework has a transaction proxy that can start and commit / rollback a transaction for you. How this works is described in more detail in the text [Advanced Connection and Transaction Demarcation and Propagation](http://tutorials.jenkov.com/java-persistence/advanced-connection-and-transaction-demarcation-and-propagation.html), so I'll only describe it briefly. The call sequence becomes something along this:

    web controller --> proxy.execute(...);
      proxy --> connection.setAutoCommit(false);
      proxy --> realAction.execute();
        realAction does database work
      proxy --> connection.commit();

### Dynamic Mock Objects for Unit Testing

The [Butterfly Testing Tools](http://butterfly.jenkov.com/) makes use of dynamic proxies to implement dynamic stubs, mocks and proxies for unit testing. When testing a class A that uses another class B (interface really), you can pass a mock implementation of B into A instead of a real B. All method calls on B are now recorded, and you can set what return values the mock B is to return.

Furthermore Butterfly Testing Tools allow you to wrap a real B in a mock B, so that all method calls on the mock are recorded, and then forwarded to the real B. This makes it possible to check what methods were called on a real functioning B. For instance, if testing a DAO you can wrap the database connection in a mock. The DAO will not see the difference, and the DAO can read/write data to the database as usual since the mock forwards all calls to the database. But now you can check via the mock if the DAO uses the connection properly, for instance if the `connection.close()` is called (or NOT called), if you expected that. This is normally not possible to determine from the return value of a DAO.

## Adaptation of DI Container to Custom Factory Interfaces

The dependency injection container [Butterfly Container](http://butterfly.jenkov.com/) has a powerful feature that allows you to inject the whole container into beans produced by it. But, since you don't want a dependency on the container interface, the container is capable of adapting itself to a custom factory interface of your design. You only need the interface. No implementation. Thus the factory interface and your class could look something like this:

    public interface IMyFactory {
      Bean   bean1();
      Person person();
      ...
    }
    public class MyAction{
    
      protected IMyFactory myFactory= null;
    
      public MyAction(IMyFactory factory){
        this.myFactory = factory;
      }
    
      public void execute(){
        Bean bean = this.myFactory.bean();
        Person person = this.myFactory.person();
      }
    
    }

When the `MyAction` class calls methods on the `IMyFactory` instance injected into its constructor by the container, the method calls are translated into calls to the `IContainer.instance()` method, which is the method you use to obtain instances from the container. That way an object can use Butterfly Container as a factory at runtime, rather than only to have dependencies injected into itself at creation time. And this without having any dependencies on any Butterfly Container specific interfaces.

### AOP-like Method Interception

The Spring framework makes it possible to intercept method calls to a given bean, provided that bean implements some interface. The Spring framework wraps the bean in a dynamic proxy. All calls to the bean are then intercepted by the proxy. The proxy can decide to call other methods on other objects either before, instead of, or after delegating the method call to the bean wrapped.
