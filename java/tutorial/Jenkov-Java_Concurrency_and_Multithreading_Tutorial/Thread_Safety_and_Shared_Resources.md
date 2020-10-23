# [Thread Safety and Shared Resources](http://tutorials.jenkov.com/java-concurrency/thread-safety.html)

- [Thread Safety and Shared Resources](#thread-safety-and-shared-resources)
  - [Local Variables](#local-variables)
  - [Local Object References](#local-object-references)
  - [Object Member Variables](#object-member-variables)

Code that is safe to call by multiple threads simultaneously is called **thread safe**. If a piece of code is thread safe, then it contains no [race conditions](http://tutorials.jenkov.com/java-concurrency/race-conditions-and-critical-sections.html). Race condition only occur when multiple threads update shared resources. Therefore it is important to know what resources Java threads share when executing.

## Local Variables

Local variables are stored in each **thread's own stack**. That means that local variables are never shared between threads. That also means that all local primitive variables are thread safe. Here is an example of a thread safe local primitive variable:

    public void someMethod(){
        long threadSafeInt = 0;
        threadSafeInt++;
    }

## Local Object References

Local references to objects are a bit different. The reference itself is not shared. The **object referenced** however, is not stored in each threads's local stack. All objects are **stored in the shared heap**.

If an object created locally never escapes the method it was created in, it is thread safe. In fact you can also pass it on to other methods and objects as long as none of these methods or objects make the passed object available to other threads.

Here is an example of a thread safe local object:

    public void someMethod(){
    
        LocalObject localObject = new LocalObject();

        localObject.callMethod();
        method2(localObject);
    }

    public void method2(LocalObject localObject){
        localObject.setValue("value");
    }

The `LocalObject` instance in this example is not returned from the method, nor is it passed to any other objects that are accessible from outside the `someMethod()` method. Each thread executing the `someMethod()` method will create its own `LocalObject` instance and assign it to the `localObject` reference. Therefore the use of the `LocalObject` here is thread safe.

In fact, the whole method `someMethod()` is thread safe. Even if the `LocalObject` instance is passed as parameter to other methods in the same class, or in other classes, the use of it is thread safe.

The only exception is of course, if one of the methods called with the `LocalObject` as parameter, stores the `LocalObject` instance in a way that allows access to it from other threads.

## Object Member Variables





TODO java