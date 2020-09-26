# Pattern-Oriented Software Architecture, Patterns for Concurrent and Networked Objects, Volume 2

- [Pattern-Oriented Software Architecture, Patterns for Concurrent and Networked Objects, Volume 2](#pattern-oriented-software-architecture-patterns-for-concurrent-and-networked-objects-volume-2)
  - [Chapter 1: Concurrent and Networked Objects](#chapter-1-concurrent-and-networked-objects)
    - [1.1 Motivation](#11-motivation)
    - [1.2 Challenges of Concurrent and Networked Software](#12-challenges-of-concurrent-and-networked-software)
      - [Challenge 1: Service Access and Configuration](#challenge-1-service-access-and-configuration)
      - [Challenge 2: Event Handling](#challenge-2-event-handling)
      - [Challenge 3: Concurrency](#challenge-3-concurrency)
  - [Chapter 2: Service Access and Configuration Patterns](#chapter-2-service-access-and-configuration-patterns)
    - [Wrapper Facade](#wrapper-facade)

## Chapter 1: Concurrent and Networked Objects

This chapter introduces topics related to **concurrent and networked objects**. We first motivate the need for advanced software development techniques in this area. Next, we present an overview of key design challenges faced by developers of **concurrent and networked objectoriented applications and middleware**. To illustrate how patterns can be applied to resolve these problems, we examine a case study of an object-oriented framework and a high-performance Web server implemented using this framework. In the case study we focus on key patterns presented in this book that help to simplify four important aspects of concurrent and networked applications:

- Service access and configuration
- Event handling
- Synchronization and
- Concurrency

### 1.1 Motivation

Although hardware improvements have alleviated the need for some low-level software optimizations, the lifecycle cost and effort required to develop software—particularly mission-critical concurrent and networked applications—continues to rise. The disparity between the rapid rate of hardware advances versus the slower software progress stems from a number of factors, including:

- Inherent and accidental complexities.

- Inadequate methods and techniques.

- Continuous re-invention and re-discovery of core concepts and techniques.

No single silver bullet can slay all the demons plaguing concurrent and networked software. Over the past decade, however, it has become clear that patterns and pattern languages help to alleviate many inherent and accidental software complexities.

A pattern is a recurring solution schema to a standard problem in a particular context. Patterns help to capture and reuse the static and dynamic structure and collaboration of key participants in software designs. They are useful for **documenting recurring micro-architectures**, which are abstractions of software components that experienced developers apply to resolve common design and implementation problems.

When related patterns are woven together, they form a 'language' that helps to both

- Define a vocabulary for talking about software development problems and
- Provide a process for the orderly resolution of these problems

By studying and applying patterns and pattern languages, developers can often escape traps and pitfalls that have been avoided traditionally only via long and costly apprenticeship.

Until recently patterns for developing concurrent and networked software existed only in programming folklore, the heads of expert researchers and developers, or were buried deep in complex source code. These locations are not ideal, for three reasons:

- Re-discovering patterns opportunistically from source code is expensive and timeconsuming, because it is hard to separate the essential design decisions from the implementation details.

- If the insights and rationale of experienced designers are not documented, they will be lost over time and thus cannot help guide subsequent software maintenance and enhancement activities.

- Without guidance from earlier work, developers of concurrent and networked software face the Herculean task of engineering complex systems from the ground up, rather than reusing proven solutions.

When used properly, however, the patterns described in this book help alleviate many of the
complexities enumerated earlier. In particular, the patterns

- Direct developer focus towards higher-level software application architecture and design concerns, such as the specification of suitable **service access and configuration**, **event processing**, and **threading models**. These are some of the key strategic aspects of concurrent and networked software. If they are addressed properly, the impact of many vexing complexities can be alleviated greatly.

- Redirect developer focus away from a preoccupation with low-level operating system and networking protocols and mechanisms. While having a solid grasp of these topics is important, they are tactical in scope and must be placed in the proper context within the overall software architecture and development effort.

### 1.2 Challenges of Concurrent and Networked Software

There are three common reasons to adopt a networked architecture:

- Collaboration and connectivity.
- Enhanced performance, scalability, and fault tolerance.
- Cost effectiveness.

Although networked applications offer many potential benefits, they are harder to design, implement, debug, optimize, and manage than stand-alone applications. For example, developers must address topics that are either not relevant or are less problematic for standalone applications in order to handle the requirements of networked applications. These topics include:

- Connection establishment and service initialization
- Event demultiplexing and event handler dispatching
- Interprocess communication (IPC) and network protocols
- Primary and secondary storage management and caching
- Static and dynamic component configuration
- Concurrency and synchronization

These topics are generally independent of specific application requirements, so learning to master them helps to address a wide range of software development problems. Moreover, in the context of these topics many design and programming challenges arise due to several inherent and accidental complexities associated with concurrent and networked systems:

- Common inherent complexities associated with concurrent and networked systems include **managing bandwidth**, **minimizing delays (latency)** and **delay variation (jitter)**, detecting and recovering from **partial failures**, determining appropriate **service partitioning** and **load balancing** strategies, and ensuring causal **ordering of events**. Similarly, common inherent complexities found in concurrent programming include eliminating **race conditions** and avoiding **deadlocks**, determining suitable **thread scheduling strategies**, and optimizing **end-system protocol processing** performance.

- Common accidental complexities associated with concurrent and networked systems include lack of **portable operating system APIs**, inadequate **debugging support** and lack of **tools for analyzing** concurrent and networked applications, widespread use of algorithmic--rather than object-oriented--**decomposition**, and continual **rediscovery and reinvention** of core concepts and common components.

#### Challenge 1: Service Access and Configuration

Components in a stand-alone application can collaborate within a single address space by passing parameters via function calls and by accessing global variables. In contrast, components in networked applications can collaborate using:

- **Interprocess communication (IPC) mechanisms**, for example shared memory, pipes, and Sockets, which are based on network protocols like TCP, UDP and IP, or ATM.

- **Communication protocols**, such as TELNET, FTP, SMTP, HTTP, and LDAP, which are used by many types of services, for example remote log-in, file transfer, email, Web content delivery, and distributed directories, to export cohesive software components and functionality to applications.

- Remote operations on application-level service components using high-level
**communication middleware**, such as COM+ [Box97] and CORBA [OMG98c]

Applications and software components can access these communication mechanisms via programming APIs defined at all levels of abstraction in a networked system:

- Application Layer
- Middleware Layer
- Operating System Layer

For infrastructure networking or systems programs, such as TELNET or FTP, service access
traditionally involved calling

- Concurrency service access APIs, such as UNIX processes, POSIX Pthreads, or Win32 threads, to manage concurrency and
- IPC service access APIs, such as UNIX- and Internet-domain Sockets, toconfigure connections and communicate between processes co-located on a single host and on different hosts, respectively.

Several accidental complexities arise, however, when accessing networking and host services via low-level operating system C APIs:

- Excessive low-level details.

- Continuous rediscovery and reinvention of incompatible higher-level programming abstractions.

- High potential for errors.

- Lack of portability.

- Steep learning curve.

- Inability to scale up to handle increasing complexity.

Key design challenges for infrastructure networking or system programs thus center on minimizing the accidental complexities outlined above without sacrificing performance.

Supporting the static and dynamic evolution of services and applications is another key challenge in networked software systems. Evolution can occur in two ways:

- Interfaces to and connectivity between component service roles can change, often at run-time, and new service roles can be implemented and installed into existing components.

- Distributed system performance can be improved by reconfiguring service load to harness the processing power of multiple hosts.

Ideally these component configuration and reconfiguration changes should be transparent to client applications that access the various services. Another design challenge therefore is to ensure that an entire system need not be shut down, recompiled, relinked, and restarted simply because a particular service role in a component is reconfigured or its load is redistributed.

Many modern operating systems and run-time environments provide explicit dynamic linking APIs that enable the configuration of applications on-demand:

- UNIX defines the dlopen(), dlsym(), and dlclose() API that can be used to load a designated dynamically linked library (DLL) into an application process explicitly, extract a designated factory function from the DLL, and unlink/unload the DLL, respectively.

- Win32 provides the LoadLibrary(), GetProcAddr(), and CloseHandle() API that perform the same functionality as the UNIX DLL API.

- Java's Java.applet.Applet class defines init(), start(), stop(), and destroy() hook methods that support the initializing, starting, stopping, and terminating of applets loaded dynamically.

However, configuring services into applications on-demand requires more than dynamic linking mechanisms—it requires patterns for **coordinating (re)configuration policies**. Here the design challenges are two-fold. First, an application must **export new services**, even though it may not know their detailed interfaces. Second, an application must **integrate these services** into its own control flow and processing sequence transparently and robustly, even at run-time.

Chapter 2, Service Access and Configuration Patterns, presents four patterns for designing effective programming APIs to access and configure services and components in standalone and networked software systems and applications. These patterns are **Wrapper Facade**, **Component Configurator**, **Interceptor**, and **Extension Interface**.

#### Challenge 2: Event Handling

As systems become increasingly networked, software development techniques that support event-driven applications have become increasingly pervasive. Three characteristics differentiate event-driven applications from those with the traditional 'self-directed' flow of control:

- Application behavior is triggered by external or internal events that occur asynchronously. Common sources of events include device drivers, I/O ports, sensors, keyboards or mice, signals, timers, or other asynchronous software components.

- Most events must be handled promptly to prevent CPU starvation, improve perceived response time, and keep hardware devices with real-time constraints from failing or corrupting data.

- Finite state machines may be needed to control event processing and
detect illegal transitions, because event-driven applications generally have little or no control over the order in which events arrive.

Therefore, event-driven applications are often structured as layered architectures with so-called 'inversion of control':

- At the bottom layer are event sources, which detect and retrieve events from various hardware devices or low-level software device drivers that reside within an operating system.

- At the next layer is an event demultiplexer, such as `select()`, which waits for events to arrive on the various event sources and then dispatches events to their corresponding event handler callbacks.

- The event handlers, together with the application code, form yet another layer that performs application-specific processing in response to callbacks—hence the term 'inversion of control'.

The separation of concerns in this event-driven architecture allows developers to concentrate on application layer functionality, rather than rewriting the event source and demultiplexer layers repeatedly for each new system or application.

In many networked systems, applications communicate via peer-to-peer protocols, such as TCP/IP, and are implemented using the layered event-driven architecture outlined above. The events that are exchanged between peers in this architecture play four different roles:

- PEER<sub>1</sub>, the client initiator application, invokes a send operation to pass a request event to PEER<sub>2</sub>, the service provider application. The event can contain data necessary for PEER<sub>1</sub> and PEER<sub>2</sub> to collaborate. For example, a PEER<sub>1</sub> request may contain a CONNECT event to initiate a bidirectional connection, or a DATA event to pass an operation and its parameters to be executed remotely at PEER<sub>2</sub>.

- The PEER<sub>2</sub> service provider application is notified of the request event arrival via an indication event. PEER<sub>2</sub> can then invoke a receive operation to obtain and use the indication event data to perform its processing. The demultiplexing layer of PEER<sub>2</sub> often waits for a set of indication events to arrive from multiple peers.

- After the PEER<sub>2</sub> service provider application finishes processing the indication event, it invokes a send operation to pass a response event to PEER<sub>1</sub>, acknowledging the original event and returning any results. For example, PEER<sub>2<sub> could acknowledge the CONNECT event as part of an initialization 'handshake', or it could acknowledge the DATA event in a reliable two-way remote method invocation.

- The PEER<sub>1</sub> client initiator application is notified of a response event arrival via a completion event. At this point it can use a receive operation to obtain the results of the request event it sent to the PEER<sub>2</sub> service provider earlier.

If after sending a request event the PEER<sub>1</sub> application blocks to receive the completion event containing PEER<sub>2</sub>'s response, it is termed a synchronous client. In contrast, if PEER<sub>1</sub> does not block after sending a request it is termed an asynchronous client. Asynchronous clients can receive completion events via asynchrony mechanisms, such as UNIX signal handlers or Win32 I/O completion ports.

Traditional networked applications detect, demultiplex, and dispatch various types of control and data events using low-level operating system APIs, such as Sockets, select(), poll(), WaitForMultipleObjects(), and I/O completion ports. However, using these low-level APIs increases the accidental complexity of eventdriven programming. Programming with these low-level APIs also increases code duplication and maintenance effort by coupling the I/O and demultiplexing aspects of an application with its connection and concurrency mechanisms.

Chapter 3, **Event Handling Patterns**, presents four patterns that describe how to initiate, receive, demultiplex, dispatch, and process various types of events effectively in networked software frameworks. The patterns are **Reactor**, **Proactor**, **Asynchronous Completion Token**, and **Acceptor-Connector**.

#### Challenge 3: Concurrency












## Chapter 2: Service Access and Configuration Patterns

This chapter presents four patterns for designing effective application programming interfaces (APIs) to access and configure services and components in stand-alone and networked systems: **Wrapper Facade**, **Component Configurator**, **Interceptor**, and **Extension Interface**.

The topics of service access and configuration involve more challenges than are addressed by the patterns in this section. These challenges include:

- Mediating access to remote services via local proxies
- Managing the lifecycle of services, locating services in a distributed system and
- Controlling the operating system and computing resources a server can provide to the service implementations it hosts

Other patterns in the literature address these issues, such as **Activator**, **Evictor**, **Half Object plus Protocol**, **Locator**, **Object Lifetime Manager**, and **Proxy**. These patterns complement those presented in this section and together describe key principles that well-structured distributed systems should apply to configure and provide access to the services they offer.

### Wrapper Facade
