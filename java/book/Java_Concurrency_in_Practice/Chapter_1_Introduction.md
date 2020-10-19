# Chapter 1 Introduction

- [Chapter 1 Introduction](#chapter-1-introduction)
  - [1.1 A (very) brief history of concurrency](#11-a-very-brief-history-of-concurrency)
  - [1.2 Benefits of threads](#12-benefits-of-threads)
    - [1.2.1 Exploiting multiple processors](#121-exploiting-multiple-processors)
    - [1.2.2 Simplicity of modeling](#122-simplicity-of-modeling)
    - [1.2.3 Simplified handling of asynchronous events](#123-simplified-handling-of-asynchronous-events)
    - [1.2.4 More responsive user interfaces](#124-more-responsive-user-interfaces)
  - [1.3 Risks of threads](#13-risks-of-threads)
    - [1.3.1 Safety hazards](#131-safety-hazards)
    - [1.3.2 Liveness hazards](#132-liveness-hazards)

## 1.1 A (very) brief history of concurrency

Operating systems evolved to allow more than one program to run at once,
running individual programs in processes: isolated, independently executing programs to which the operating system allocates resources such as **memory**, **file handles**, and **security credentials**. If they needed to, processes could communicate with one another through a variety of coarse-grained communication mechanisms: **sockets**, **signal handlers**, **shared memory**, **semaphores**, and **files**.

The same concerns (resource utilization, fairness, and convenience) that motivated the development of processes also motivated the development of threads. Threads allow multiple streams of program control flow to coexist within a process. They share process-wide resources such as memory and file handles, but each thread has its own **program counter**, **stack**, and **local variables**. Threads also provide a natural decomposition for exploiting hardware parallelism on multiprocessor systems; multiple threads within the same program can be scheduled simultaneously on multiple CPUs.

Threads are sometimes called lightweight processes, and most modern operating systems treat threads, not processes, as the **basic units of scheduling**. In the absence of explicit coordination, threads execute simultaneously and asynchronously with respect to one another. Since threads share the memory address space of their owning process, all threads within a process have access to the same variables and allocate objects from the same heap, which allows finer-grained data sharing than inter-process mechanisms. But without explicit synchronization to coordinate access to shared data, a thread may modify variables that another thread is in the middle of using, with unpredictable results.

## 1.2 Benefits of threads

### 1.2.1 Exploiting multiple processors

Since the basic unit of scheduling is the thread, a program with only **one thread can run on at most one processor at a time**. On a two-processor system, a single-threaded program is giving up access to half the available CPU resources; on a 100-processor system, it is giving up access to 99%. On the other hand, programs with multiple active threads can execute simultaneously on multiple processors. When properly designed, multithreaded programs can improve throughput by utilizing available processor resources more effectively.

### 1.2.2 Simplicity of modeling

This benefit is often exploited by frameworks such as **servlets** or **RMI** (Remote Method Invocation). The framework handles the details of request management, thread creation, and load balancing, dispatching portions of the request handling to the appropriate application component at the appropriate point in the workflow. Servlet writers do not need to worry about how many other requests are being processed at the same time or whether the socket input and output streams block; when a servlet’s service method is called in response to a web request, it can process the request synchronously as if it were a single-threaded program. This can simplify component development and reduce the learning curve for using such frameworks.

### 1.2.3 Simplified handling of asynchronous events

A server application that accepts socket connections from multiple remote clients may be easier to develop when each connection is allocated its own thread and allowed to use synchronous I/O.

If an application goes to read from a socket when no data is available, read blocks until some data is available. In a single-threaded application, this means that not only does processing the corresponding request stall, but processing of all requests stalls while the single thread is blocked. To avoid this problem, singlethreaded server applications are forced to use nonblocking I/O, which is far more complicated and error-prone than synchronous I/O. However, if each request has its own thread, then blocking does not affect the processing of other requests.

### 1.2.4 More responsive user interfaces

GUI applications used to be single-threaded, which meant that you had to either frequently **poll throughout the code** for input events (which is messy and intrusive) or execute all application code indirectly through a “**main event loop**”. If code called from the main event loop takes too long to execute, the user interface appears to “freeze” until that code finishes, because subsequent user interface events cannot be processed until control is returned to the main event loop.

Modern GUI frameworks, such as the AWT and Swing toolkits, replace the main event loop with an **event dispatch thread (EDT)**. When a user interface event such as a button press occurs, application-defined event handlers are called in the **event thread**. Most GUI frameworks are single-threaded subsystems, so the main event loop is effectively still present, but it runs in its own thread under the control of the GUI toolkit rather than the application. 

If only short-lived tasks execute in the event thread, the interface remains responsive since the event thread is always able to process user actions reasonably quickly. However, processing a long-running task in the event thread, such as spell-checking a large document or fetching a resource over the network, impairs responsiveness. If the user performs an action while this task is running, there is a long delay before the event thread can process or even acknowledge it. To add insult to injury, not only does the UI become unresponsive, but it is impossible to cancel the offending task even if the UI provides a cancel button because the event thread is busy and cannot handle the cancel button-press event until the lengthy task completes! If, however, the long-running task is instead executed in a **separate thread**, the event thread remains free to process UI events, making the UI more responsive.

## 1.3 Risks of threads

### 1.3.1 Safety hazards

Thread safety can be unexpectedly subtle because, in the absence of sufficient synchronization, the ordering of operations in multiple threads is unpredictable and sometimes surprising. `UnsafeSequence` in Listing 1.1, which is supposed to generate a sequence of unique integer values, offers a simple illustration of how the interleaving of actions in multiple threads can lead to undesirable results. It behaves correctly in a single-threaded environment, but in a multithreaded environment does not.

    @NotThreadSafe
    public class UnsafeSequence {
        private int value;
        /** Returns a unique value. */
        public int getNext() {
            return value++;
        }
    }

Listing 1.1. Non-thread-safe sequence generator

The problem with `UnsafeSequence` is that with some unlucky timing, two threads could call `getNext` and receive the same value. Figure 1.1 shows how this can happen. The increment notation, `someVariable++`, may appear to be a single operation, but is in fact three separate operations: read the value, add one to it, and write out the new value. Since operations in multiple threads may be **arbitrarily interleaved** by the runtime, it is possible for two threads to read the value at the same time, both see the same value, and then both add one to it. The result is that the same sequence number is returned from multiple calls in different threads.

`UnsafeSequence` illustrates a common concurrency hazard called a **race condition**. Whether or not getNext returns a unique value when called from multiple threads, as required by its specification, depends on how the runtime interleaves the operations—which is not a desirable state of affairs.

`UnsafeSequence` can be fixed by making `getNext` a `synchronized` method, as shown in Sequence in Listing 1.2 thus preventing the unfortunate interaction in Figure 1.1. (Exactly why this works is the subject of Chapters 2 and 3.)

    @ThreadSafe
    public class Sequence {
        @GuardedBy("this") private int value;
        public synchronized int getNext() {
            return value++;
        }
    }

Listing 1.2. Thread-safe sequence generator.

In the absence of synchronization, the compiler, hardware, and runtime are allowed to take substantial liberties with the timing and ordering of actions, such as **caching variables** in registers or processor-local caches where they are temporarily (or even permanently) invisible to other threads. These tricks are in aid of better performance and are generally desirable, but they place a burden on the developer to clearly identify where data is being shared across threads so that these optimizations do not undermine safety. (Chapter 16 gives the gory details on exactly what **ordering guarantees** the JVM makes and **how synchronization affects those guarantees**, but if you follow the rules in Chapters 2 and 3, you can safely avoid these low-level details.)

### 1.3.2 Liveness hazards




