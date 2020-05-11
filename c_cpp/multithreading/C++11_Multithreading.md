# C++11 Multithreading

- [C++11 Multithreading](#c11-multithreading)
  - [C++11 Multithreading - Part 1 : Three Different ways to Create Threads](#c11-multithreading---part-1--three-different-ways-to-create-threads)
    - [Introduction to C++11 Thread Library](#introduction-to-c11-thread-library)
    - [Thread Creation in C++11](#thread-creation-in-c11)
      - [What std::thread accepts in constructor](#what-stdthread-accepts-in-constructor)
    - [Differentiating between threads](#differentiating-between-threads)
  - [C++11 Multithreading – Part 2: Joining and Detaching Threads](#c11-multithreading-%e2%80%93-part-2-joining-and-detaching-threads)
    - [Joining Threads with `std::thread::join()`](#joining-threads-with-stdthreadjoin)
    - [Detaching Threads using `std::thread::detach()`](#detaching-threads-using-stdthreaddetach)
      - [Be careful with calling `detach()` and `join()` on Thread Handles](#be-careful-with-calling-detach-and-join-on-thread-handles)
        - [Case 1: Never call `join()` or `detach()` on `std::thread` object with no associated executing thread](#case-1-never-call-join-or-detach-on-stdthread-object-with-no-associated-executing-thread)
        - [Case 2 : Never forget to call either join or detach on a `std::thread` object with associated executing thread](#case-2--never-forget-to-call-either-join-or-detach-on-a-stdthread-object-with-associated-executing-thread)
  - [C++11 Multithreading – Part 3: Carefully Pass Arguments to Threads](#c11-multithreading-%e2%80%93-part-3-carefully-pass-arguments-to-threads)
    - [Passing simple arguments to a std::thread in C++11](#passing-simple-arguments-to-a-stdthread-in-c11)
    - [How not to pass arguments to threads in C++11](#how-not-to-pass-arguments-to-threads-in-c11)

## [C++11 Multithreading - Part 1 : Three Different ways to Create Threads](https://thispointer.com/c-11-multithreading-part-1-three-different-ways-to-create-threads/)

### Introduction to C++11 Thread Library

Original C++ Standard supported only single thread programming. The new C++ Standard (referred to as C++11 or C++0x) was published in 2011. In C++11 a new thread library is introduced.

Compilers Required:  

- Linux: gcc 4.8.1 (Complete Concurrency support)
- Windows: Visual Studio 2012 and MingW

How to compile on Linux: `g++ –std=c++11 sample.cpp -lpthread`

### Thread Creation in C++11

In every C++ application there is one default main thread i.e. `main()` function. In C++ 11 we can create additional threads by creating objects of `std::thread` class.

Each of the `std::thread` object can be associated with a thread.

Header Required:

    #include <thread>

#### What std::thread accepts in constructor

We can attach a callback with the `std::thread` object, that will be executed when this new thread starts. These callbacks can be,

1. Function Pointer
2. Function Objects
3. Lambda functions

Thread objects can be created like this,

    std::thread thObj(<CALLBACK>);

New **Thread will start just after the creation of new object** and will execute the passed callback in parallel to thread that has started it.

Moreover, **any thread can wait for another to exit** by calling `join()` function on that thread’s object.

### Differentiating between threads

Each of the `std::thread` object has an associated ID and we can fetch using,

    std::thread::get_id()

To get the identifier for the current thread use,

    std::this_thread::get_id()

If `std::thread` object does not have an associated thread then `get_id()` will return a default constructed `std::thread::id` object i.e. not any thread.

`std::thread::id` is a Object, it can be compared and printed on console too.

## [C++11 Multithreading – Part 2: Joining and Detaching Threads](https://thispointer.com//c11-multithreading-part-2-joining-and-detaching-threads/)

### Joining Threads with `std::thread::join()`

Once a thread is started then another thread can wait for this new thread to finish. For this another need need to call `join()` function on the `std::thread` object i.e.

    std::thread th(funcPtr);
 
    // Some Code
 
    th.join();

### Detaching Threads using `std::thread::detach()`

Detached threads are also called daemon / Background threads.  To detach a thread we need to call `std::detach()` function on `std::thread` object i.e.

    std::thread th(funcPtr);
    th.detach();

After calling `detach()`, `std::thread` **object is no longer associated with the actual thread** of execution.

#### Be careful with calling `detach()` and `join()` on Thread Handles

##### Case 1: Never call `join()` or `detach()` on `std::thread` object with no associated executing thread

    std::thread threadObj( (WorkerThread()) );
    threadObj.join();
    threadObj.join(); // It will cause Program to Terminate

When a `join()` function is called on an thread object, then when this join(`0` returns then that `std::thread` object has no associated thread with it. In case again `join()` function is called on such object then it will cause the program to Terminate.

Similarly calling `detach()` makes the `std::thread` object not linked with any thread function. In that case calling detach(`0` function twice on an `std::thread` object will cause the program to terminate.

    std::thread threadObj( (WorkerThread()) );
    threadObj.detach();
    threadObj.detach(); // It will cause Program to Terminate

Therefore, before calling `join()` or `detach()` we should check if thread is join-able every time.

##### Case 2 : Never forget to call either join or detach on a `std::thread` object with associated executing thread

If neither join or detach is called with a `std::thread` object that has associated executing thread then during that object’s destructor it will terminate the program.

Because inside the destructor it checks if Thread is Still Join-able then Terminate the program.

## [C++11 Multithreading – Part 3: Carefully Pass Arguments to Threads](https://thispointer.com//c11-multithreading-part-3-carefully-pass-arguments-to-threads/)

To Pass arguments to thread’s associated callable object or function just pass additional arguments to the `std::thread` constructor.

By default all arguments are **copied into** the internal storage of new thread.

### Passing simple arguments to a std::thread in C++11

    #include <iostream>
    #include <string>
    #include <thread>
    void threadCallback(int x, std::string str)
    {
        std::cout<<"Passed Number = "<<x<<std::endl;
        std::cout<<"Passed String = "<<str<<std::endl;
    }
    int main()  
    {
        int x = 10;
        std::string str = "Sample String";
        std::thread threadObj(threadCallback, x, str);
        threadObj.join();
        return 0;
    }

### How not to pass arguments to threads in C++11

Don’t pass addresses of variables from local stack to thread’s callback function. Because it might be possible that local variable in Thread 1 goes out of scope but Thread 2 is still trying to access it through it’s address.

In such scenario accessing invalid address can cause unexpected behaviour.



































