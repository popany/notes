# Boost.Asio

- [Boost.Asio](#boostasio)
  - [Boost.Asio Official Documentation](#boostasio-official-documentation)
    - [Overview](#overview)
      - [Rationale](#rationale)
      - [Core Concepts and Functionality](#core-concepts-and-functionality)
        - [Basic Boost.Asio Anatomy](#basic-boostasio-anatomy)
  - [Tutorial](#tutorial)
    - [Boost.Asio C++ 网络编程](#boostasio-c-网络编程)
    - [C++网络编程之ASIO](#c网络编程之asio)
      - [C++网络编程之ASIO(一)](#c网络编程之asio一)
  - [Boost.Asio C++ Network Programming](#boostasio-c-network-programming)
    - [Getting Started with Boost.Asi](#getting-started-with-boostasi)
  - [Boost.Asio C++ Network Programming Cookbook](#boostasio-c-network-programming-cookbook)

## [Boost.Asio Official Documentation](https://www.boost.org/doc/libs/1_72_0/doc/html/boost_asio.html)

Boost.Asio is a cross-platform C++ library for **network** and **low-level I/O** programming that provides developers with a consistent **asynchronous model** using a modern C++ approach.

### [Overview](https://www.boost.org/doc/libs/1_72_0/doc/html/boost_asio/overview.html)

An overview of the features included in Boost.Asio, plus rationale and design information.

#### [Rationale](https://www.boost.org/doc/libs/1_72_0/doc/html/boost_asio/overview/rationale.html)

Most programs interact with the outside world in some way, whether it be via a **file**, a network, a **serial cable**, or the **console**. Sometimes, as is the case with networking, individual I/O operations can take a long time to complete. This poses particular challenges to application development.

Boost.Asio provides the tools to manage these long **running operations**, **without** requiring programs to use **concurrency models** based on threads and explicit locking.

The Boost.Asio library is intended for programmers using C++ for systems programming, where access to operating system functionality such as networking is often required. In particular, Boost.Asio addresses the following goals:

- **Portability**. The library should support a range of commonly used operating systems, and provide consistent behaviour across these operating systems. 

- **Scalability**. The library should facilitate the development of network applications that **scale to thousands of concurrent connections**. The library implementation for each operating system should use the mechanism that best enables this scalability. 

- **Efficiency**. The library should support techniques such as **scatter-gather I/O**, and allow programs to minimise data copying.

- **Model concepts from established APIs, such as BSD sockets**. The BSD socket API is widely implemented and understood, and is covered in much literature. Other programming languages often use a similar interface for networking APIs. As far as is reasonable, Boost.Asio should leverage existing practice.

- **Ease of use**. The library should provide a lower entry barrier for new users by taking a toolkit, rather than framework, approach. That is, it should try to minimise the up-front investment in time to just learning a few basic rules and guidelines. After that, a library user should only need to understand the specific functions that are being used.

- **Basis for further abstraction**. The library should permit the development of other libraries that provide higher levels of abstraction. For example, implementations of commonly used protocols such as HTTP.

Although Boost.Asio started life focused primarily on networking, its concepts of asynchronous I/O have been extended to include other operating system resources such as serial ports, file descriptors, and so on.

#### [Core Concepts and Functionality](https://www.boost.org/doc/libs/1_72_0/doc/html/boost_asio/overview/core.html)

##### [Basic Boost.Asio Anatomy](https://www.boost.org/doc/libs/1_72_0/doc/html/boost_asio/overview/core/basics.html)

## Tutorial

### [Boost.Asio C++ 网络编程](https://mmoaay.gitbooks.io/boost-asio-cpp-network-programming-chinese/content/Chapter1.html)

### C++网络编程之ASIO

#### [C++网络编程之ASIO(一)](https://zhuanlan.zhihu.com/p/37590580)

## Boost.Asio C++ Network Programming

### Getting Started with Boost.Asi

First, your program needs at least an `io_service` instance. Boost.Asio uses `io_service` to talk to the operating system's input/output services. Usually one instance of an `io_service` will be enough.

Note that the `service.run()` loop will run as long as there are asynchronous operations pending. In the preceding example, there's only one such operation, that is, the socket `async_connect`. After that, `service.run()` exits.

## Boost.Asio C++ Network Programming Cookbook
