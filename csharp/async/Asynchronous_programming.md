# [Asynchronous programming](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/)

- [Asynchronous programming](#asynchronous-programming)
  - [Overview](#overview)
    - [Don't block, await instead](#dont-block-await-instead)
    - [Start tasks concurrently](#start-tasks-concurrently)
    - [Composition with tasks](#composition-with-tasks)
    - [Asynchronous exceptions](#asynchronous-exceptions)
    - [Await tasks efficiently](#await-tasks-efficiently)
  - [Asynchronous programming scenarios](#asynchronous-programming-scenarios)
    - [Overview of the asynchronous model](#overview-of-the-asynchronous-model)
      - [I/O-bound example: Download data from a web service](#io-bound-example-download-data-from-a-web-service)
      - [CPU-bound example: Perform a calculation for a game](#cpu-bound-example-perform-a-calculation-for-a-game)
      - [What happens under the covers](#what-happens-under-the-covers)
    - [Key pieces to understand](#key-pieces-to-understand)
    - [Recognize CPU-bound and I/O-bound work](#recognize-cpu-bound-and-io-bound-work)
    - [More examples](#more-examples)
      - [Extract data from a network](#extract-data-from-a-network)
      - [Wait for multiple tasks to complete](#wait-for-multiple-tasks-to-complete)


## Overview

The Task [asynchronous programming model (TAP)](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/task-asynchronous-programming-model) provides an abstraction over asynchronous code. You write code as a sequence of statements, just like always. You can read that code as though each statement completes before the next begins. The compiler performs many transformations because some of those statements may start work and return a Task that represents the ongoing work.

...

Successful modern applications require asynchronous code. Without language support, writing asynchronous code required **callbacks**, **completion events**, or other means that obscured the original intent of the code. The advantage of the synchronous code is that its step-by-step actions make it easy to scan and understand. Traditional asynchronous models forced you to focus on the asynchronous nature of the code, not on the fundamental actions of the code.

### Don't block, await instead

### Start tasks concurrently

### Composition with tasks

The previous change illustrated an important technique for working with asynchronous code. You compose tasks by separating the operations into a new method that returns a task. You can choose when to await that task. You can start other tasks concurrently.

### Asynchronous exceptions

Up to this point, you've implicitly assumed that all these tasks complete successfully. Asynchronous methods throw exceptions, just like their synchronous counterparts. Asynchronous support for exceptions and error handling strives for the same goals as asynchronous support in general: You should write code that reads like a series of synchronous statements. Tasks throw exceptions when they can't complete successfully. The client code can catch those exceptions when a started task is `awaited`.

...

There are two important mechanisms to understand: how an exception is stored in a faulted task, and how an exception is unpackaged and rethrown when code awaits a faulted task.

### Await tasks efficiently


## [Asynchronous programming scenarios](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/async-scenarios)

If you have any I/O-bound needs (such as requesting data from a network, accessing a database, or reading and writing to a file system), you'll want to utilize asynchronous programming. You could also have CPU-bound code, such as performing an expensive calculation, which is also a good scenario for writing async code.

C# has a language-level asynchronous programming model, which allows for easily writing asynchronous code without having to juggle callbacks or conform to a library that supports asynchrony. It follows what is known as the [Task-based Asynchronous Pattern (TAP)](https://learn.microsoft.com/en-us/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap).

### Overview of the asynchronous model

The core of async programming is the `Task` and `Task<T>` objects, which model asynchronous operations. They are supported by the `async` and `await` keywords. The model is fairly simple in most cases:

- For I/O-bound code, you await an operation that returns a `Task` or `Task<T>` inside of an `async` method.

- For CPU-bound code, you await an operation that is started on a background thread with the [Task.Run](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.task.run) method.

#### I/O-bound example: Download data from a web service

#### CPU-bound example: Perform a calculation for a game

#### What happens under the covers

On the C# side of things, the compiler transforms your code into a state machine that keeps track of things like yielding execution when an `await` is reached and resuming execution when a background job has finished.

For the theoretically inclined, this is an implementation of the [Promise Model of asynchrony](https://en.wikipedia.org/wiki/Futures_and_promises).

### Key pieces to understand

- Async code can be used for both I/O-bound and CPU-bound code, but differently for each scenario.

- Async code uses `Task<T>` and `Task`, which are constructs used to model work being done in the background.

- The `async` keyword turns a method into an async method, which allows you to use the `await` keyword in its body.

- When the `await` keyword is applied, it suspends the calling method and yields control back to its caller until the awaited task is complete.

- `await` can only be used inside an async method.

### Recognize CPU-bound and I/O-bound work

1. Will your code be "waiting" for something, such as data from a database?

   If your answer is "yes", then your work is **I/O-bound**.

2. Will your code be performing an expensive computation?

   If you answered "yes", then your work is **CPU-bound**.

If the work you have is **I/O-bound**, use `async` and `await` without `Task.Run`. **You should not use the Task Parallel Library**.

If the work you have is **CPU-bound** and you care about responsiveness, use `async` and `await`, but spawn off the work on another thread with `Task.Run`. If the work is appropriate for concurrency and parallelism, also consider using the [Task Parallel Library](https://learn.microsoft.com/en-us/dotnet/standard/parallel-programming/task-parallel-library-tpl).

Additionally, **you should always measure the execution of your code**. For example, you may find yourself in a situation where your CPU-bound work is not costly enough compared with the overhead of context switches when multithreading. Every choice has its tradeoff, and you should pick the correct tradeoff for your situation.

### More examples

#### Extract data from a network

#### Wait for multiple tasks to complete






