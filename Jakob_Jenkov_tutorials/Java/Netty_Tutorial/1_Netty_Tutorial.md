# [Netty Tutorial](http://tutorials.jenkov.com/netty/index.html)

- [Netty Tutorial](#netty-tutorial)
  - [Netty Website](#netty-website)
  - [Netty Advantages](#netty-advantages)
  - [Netty Tools](#netty-tools)
  - [Netty Runs Embedded](#netty-runs-embedded)
  - [Understanding Netty is Important](#understanding-netty-is-important)

Netty is a **high performance IO toolkit** for Java. Netty is open source, so you can use it freely, and even contribute to it if you want to. This Netty tutorial will explain how Netty works, and how to get started with Netty. This tutorial will not cover every single detail of Netty.

## Netty Website

The Netty website address is:

[netty.io](http://netty.io/)

## Netty Advantages

In general, Netty makes it a lot easier to build scalable, robust networked applications compared to implemeting the same using standard Java. Netty also contains some OS specific optimizations, like using **EPOLL** on Linux etc.

## Netty Tools

Netty contains an impressive set of IO tools. Some of these tools are:

- HTTP Server
- HTTPS Server
- WebSocket Server
- TCP Server
- UDP Server
- In VM Pipe

Netty contains more than this, and Netty **keeps growing**.

Using Netty's IO tools it is easy to start an **HTTP server**, **WebSocket server** etc. It takes just a few lines of code.

## Netty Runs Embedded

Netty runs embedded in your own Java applications. That means that you create a Java application with a class with a `main()` method and inside that application you create one of the Netty servers. This is different from Java EE servers, where the server has its own main method and loads your code from the disk somehow.

That Netty runs embedded means that you can create very flexible architectures with Netty. You are not forced to use the model provided for you by Java EE. **Netty is completey independent of the Java EE specification**.

## Understanding Netty is Important

Even though Netty is fairly easy to use, it is necessary to understand how Netty works internally. Netty uses a **single-threaded concurrency model**, and is designed around **non-blocking IO**. This results in a significantly different programming model than when implementing Java EE applications. It takes a while getting used to, but once you get the hang out it, it's not too big a hazzle to work with.
