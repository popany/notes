# [Java Concurrency and Multithreading Tutorial](http://tutorials.jenkov.com/java-concurrency/index.html)

- [Java Concurrency and Multithreading Tutorial](#java-concurrency-and-multithreading-tutorial)
  - [What is Multithreading?](#what-is-multithreading)
  - [Why Multithreading?](#why-multithreading)
    - [Better Utilization of a Single CPU](#better-utilization-of-a-single-cpu)
    - [Better Utilization of Multiple CPUs or CPU Cores](#better-utilization-of-multiple-cpus-or-cpu-cores)
    - [Better User Experience with Regards to Responsiveness](#better-user-experience-with-regards-to-responsiveness)
    - [Better User Experience with Regards to Fairness](#better-user-experience-with-regards-to-fairness)
  - [Multithreading vs. Multitasking](#multithreading-vs-multitasking)
    - [Multitasking](#multitasking)
    - [Multithreading](#multithreading)
  - [Multithreading is Hard](#multithreading-is-hard)
  - [Multithreading and Concurrency in Java](#multithreading-and-concurrency-in-java)
  - [Concurrency Models](#concurrency-models)
  - [Java Concurrency Study Guide](#java-concurrency-study-guide)
    - [General concurrency and multithreading theory:](#general-concurrency-and-multithreading-theory)
    - [The basics of Java concurrency:](#the-basics-of-java-concurrency)
    - [Typical problems in Java concurrency:](#typical-problems-in-java-concurrency)
    - [Java concurrency constructs that help against the issues above:](#java-concurrency-constructs-that-help-against-the-issues-above)
    - [Java Concurrency Utilities (java.util.concurrent):](#java-concurrency-utilities-javautilconcurrent)
    - [Further topics:](#further-topics)

## What is Multithreading?

Multithreading means that you have multiple threads of execution inside the same application. A thread is like a separate CPU executing your application. Thus, a multithreaded application is like an application that has multiple CPUs executing different parts of the code at the same time.

A thread is not equal to a CPU though. Usually a single CPU will share its execution time among multiple threads, switching between executing each of the threads for a given amount of time. It is also possible to have the threads of an application be executed by different CPUs.

## Why Multithreading?

There are several reasons as to why one would use multithreading in an application. Some of the most common reasons for multithreading are:

- Better utilization of a single CPU.
- Better utilization of multiple CPUs or CPU cores.
- Better user experience with regards to responsiveness.
- Better user experience with regards to fairness.

I will explain each of these reasons in more detail in the following sections.

### Better Utilization of a Single CPU

One of the most common reasons is to be able to better utilize the resources in the computer. For instance, if one thread is waiting for the response to a request sent over the network, then another thread could use the CPU in the meantime to do something else. Additionally, if the computer has multiple CPUs, or if the CPU has multiple execution cores, then multithreading can also help your application utilize these extra CPU cores.

### Better Utilization of Multiple CPUs or CPU Cores

If a computer contains multiple CPUs or the CPU contains multiple execution cores, then you need to use multiple threads for your application to be able to utilize all of the CPUs or CPU cores. A single thread can at most utilize a single CPU, and as I mentioned above, sometimes not even completely utilize a single CPU.

### Better User Experience with Regards to Responsiveness

Another reason to use multithreading is to provide a better user experience. For instance, if you click on a button in a GUI and this results in a request being sent over the network, then it matters which thread performs this request. If you use the same thread that is also updating the GUI, then the user might experience the GUI "hanging" while the GUI thread is waiting for the response for the request. Instead, such a request could be performed by a backgroun thread so the GUI thread is free to respond to other user requests in the meantime.

### Better User Experience with Regards to Fairness

A fourth reason is to share resources of a computer more fairly among users. As example imagine a server that receives requests from clients, and only has one thread to execute these requests. If a client sends a requests that takes a long time to process, then all other client's requests would have to wait until that one request has finished. By having each client's request executed by its own thread then no single task can monopolize the CPU completely.

## Multithreading vs. Multitasking

Back in the old days a computer had a single CPU, and was only capable of executing a single program at a time. Most smaller computers were not really powerful enough to execute multiple programs at the same time, so it was not attempted. To be fair, many mainframe systems have been able to execute multiple programs at a time for many more years than personal computers.

### Multitasking

Later came multitasking which meant that computers could execute multiple programs (AKA tasks or processes) at the same time. It wasn't really "at the same time" though. The single CPU was shared between the programs. The operating system would switch between the programs running, executing each of them for a little while before switching.

Along with multitasking came new challenges for software developers. Programs can no longer assume to have all the CPU time available, nor all memory or any other computer resources. A "good citizen" program should release all resources it is no longer using, so other programs can use them.

### Multithreading

Later yet came multithreading which mean that you could have multiple threads of execution inside the same program. A thread of execution can be thought of as a CPU executing the program. When you have multiple threads executing the same program, it is like having multiple CPUs execute within the same program.

## Multithreading is Hard

Multithreading can be a great way to increase the performance of some types of programs. However, mulithreading is even more challenging than multitasking. The threads are executing within the same program and are hence reading and writing the same memory simultaneously. This can result in errors not seen in a singlethreaded program. Some of these errors may not be seen on single CPU machines, because two threads never really execute "simultaneously". Modern computers, though, come with multi core CPUs, and even with multiple CPUs too. This means that separate threads can be executed by separate cores or CPUs simultaneously.

If a thread reads a memory location while another thread writes to it, what value will the first thread end up reading? The old value? The value written by the second thread? Or a value that is a mix between the two? Or, if two threads are writing to the same memory location simultaneously, what value will be left when they are done? The value written by the first thread? The value written by the second thread? Or a mix of the two values written?

Without proper precautions any of these outcomes are possible. The behaviour would not even be predictable. The outcome could change from time to time. Therefore it is important as a developer to know how to take the right precautions - meaning learning to control how threads access shared resources like memory, files, databases etc. That is one of the topics this Java concurrency tutorial addresses.

## Multithreading and Concurrency in Java

Java was one of the first languages to make multithreading easily available to developers. Java had multithreading capabilities from the very beginning. Therefore, Java developers often face the problems described above. That is the reason I am writing this trail on Java concurrency. As notes to myself, and any fellow Java developer whom may benefit from it.

The trail will primarily be concerned with multithreading in Java, but some of the problems occurring in multithreading are similar to problems occurring in multitasking and in distributed systems. References to multitasking and distributed systems may therefore occur in this trail too. Hence the word "concurrency" rather than "multithreading".

## Concurrency Models

The first Java concurrency model assumed that multiple threads executing within the same application would also share objects. This type of concurrency model is typically referred to as a "**shared state concurrency model**". A lot of the concurrency language constructs and utilities are designed to support this concurrency model.

However, a lot has happened in the world of concurrent architecture and design since the first Java concurrency books were written, and even since the Java 5 concurrency utilities were released

The shared state concurrency model causes a lot of concurrency problems which can be hard to solve elegantly. Therefore, an alternative concurrency model referred to as "**shared nothing**" or "**separate state**" has gained popularity. In the separate state concurrency model the threads do not share any objects or data. This avoids a lot of the concurrent access problems of the shared state concurrency model.

New, asynchronous "separate state" platforms and toolkits like `Netty`, `Vert.x` and `Play` / `Akka` and `Qbit` have emerged. New non-blocking concurrency algorithms have been published, and new non-blocking tools like the LMax Disrupter have been added to our toolkits. New functional programming parallelism has been introduced with the Fork and Join framework in Java 7, and the collection streams API in Java 8.

With all these new developments it is about time that I updated this Java Concurrency tutorial. Therefore, this tutorial is once again work in progress. New tutorials will be published whenever time is available to write them.

## Java Concurrency Study Guide

### General concurrency and multithreading theory:

- [Multithreading Benefits](http://tutorials.jenkov.com/java-concurrency/benefits.html)
- [Multithreading Costs](http://tutorials.jenkov.com/java-concurrency/costs.html)
- [Concurrency Models](http://tutorials.jenkov.com/java-concurrency/concurrency-models.html)
- [Same-threading](http://tutorials.jenkov.com/java-concurrency/same-threading.html)
- [Concurrency vs. Parallelism](http://tutorials.jenkov.com/java-concurrency/concurrency-vs-parallelism.html)

### The basics of Java concurrency:

- [Creating and Starting Java Threads](http://tutorials.jenkov.com/java-concurrency/creating-and-starting-threads.html)
- [Race Conditions and Critical Sections](http://tutorials.jenkov.com/java-concurrency/race-conditions-and-critical-sections.html)
- [Thread Safety and Shared Resources](http://tutorials.jenkov.com/java-concurrency/thread-safety.html)
- [Thread Safety and Immutability](http://tutorials.jenkov.com/java-concurrency/thread-safety-and-immutability.html)
- [Java Memory Model](http://tutorials.jenkov.com/java-concurrency/java-memory-model.html)
- [Java Synchronized Blocks](http://tutorials.jenkov.com/java-concurrency/synchronized.html)
- [Java Volatile Keyword](http://tutorials.jenkov.com/java-concurrency/volatile.html)
- [Java ThreadLocal](http://tutorials.jenkov.com/java-concurrency/threadlocal.html)
- [Java Thread Signaling](http://tutorials.jenkov.com/java-concurrency/thread-signaling.html)

### Typical problems in Java concurrency:

- [Deadlock](http://tutorials.jenkov.com/java-concurrency/deadlock.html)
- [Deadlock Prevention](http://tutorials.jenkov.com/java-concurrency/deadlock-prevention.html)
- [Starvation and Fairness](http://tutorials.jenkov.com/java-concurrency/starvation-and-fairness.html)
- [Nested Monitor Lockout](http://tutorials.jenkov.com/java-concurrency/nested-monitor-lockout.html)
- [Slipped Conditions](http://tutorials.jenkov.com/java-concurrency/slipped-conditions.html)

### Java concurrency constructs that help against the issues above:

- [Locks in Java](http://tutorials.jenkov.com/java-concurrency/locks.html)
- [Read / Write Locks in Java](http://tutorials.jenkov.com/java-concurrency/read-write-locks.html)
- [Reentrance Lockout](http://tutorials.jenkov.com/java-concurrency/reentrance-lockout.html)
- [Semaphores](http://tutorials.jenkov.com/java-concurrency/semaphores.html)
- [Blocking Queues](http://tutorials.jenkov.com/java-concurrency/blocking-queues.html)
- [Thread Pools](http://tutorials.jenkov.com/java-concurrency/thread-pools.html)
- [Compare and Swap](http://tutorials.jenkov.com/java-concurrency/compare-and-swap.html)

### Java Concurrency Utilities (java.util.concurrent):

- [Java Concurrency Utilities - java.util.concurrent](http://tutorials.jenkov.com/java-util-concurrent/index.html)

### Further topics:

- [Anatomy of a Synchronizer](http://tutorials.jenkov.com/java-concurrency/anatomy-of-a-synchronizer.html)
- [Non-blocking Algorithms](http://tutorials.jenkov.com/java-concurrency/non-blocking-algorithms.html)
- [Amdahl's Law](http://tutorials.jenkov.com/java-concurrency/amdahls-law.html)
- [References](http://tutorials.jenkov.com/java-concurrency/references.html)
