# [Introduction to message queuing](https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_8.0.0/com.ibm.mq.pro.doc/q002620_.htm)

- [Introduction to message queuing](#introduction-to-message-queuing)
  - [What is a message queue?](#what-is-a-message-queue)
  - [Different styles of message queuing](#different-styles-of-message-queuing)
    - [Point-to-point](#point-to-point)
    - [Publish/Subscribe](#publishsubscribe)
  - [Benefits of message queuing to the application designer and developer](#benefits-of-message-queuing-to-the-application-designer-and-developer)

The IBM® MQ products enable programs to communicate with one another **across a network of unlike components** (processors, operating systems, subsystems, and communication protocols) using a consistent application programming interface.

Applications designed and written using this interface are known as message queuing applications, because they use the messaging and queuing style:

|||
|-|-|
Messaging | Programs communicate by sending each other data in messages **rather than calling each other directly**.
queuing | Messages are placed on queues in storage, allowing programs to run independently of each other, at **different speeds and times**, in **different locations**, and **without having a logical connection** between them.
|||

Message queuing has been used in data processing for many years. It is most commonly used today in electronic mail. Without queuing, sending an electronic message over long distances requires every node on the route to be available for forwarding messages, and the addressees to be logged on and conscious of the fact that you are trying to send them a message. In a queuing system, messages are stored at intermediate nodes until the system is ready to forward them. At their final destination they are stored in an electronic mailbox until the addressee is ready to read them.

Even so, many complex business transactions are processed today without queuing. In a large network, the system might be maintaining many thousands of connections in a ready-to-use state. If one part of the system suffers a problem, many parts of the system become unusable.

You can think of message queuing as being electronic mail for programs. In a message queuing environment, each program that makes up part of an application suite performs a well-defined, self-contained function in response to a specific request. To communicate with another program, a program must put a message on a predefined queue. The other program retrieves the message from the queue, and processes the requests and information contained in the message. So message queuing is a style of program-to-program communication.

Queuing is the mechanism by which messages are held until an application is ready to process them. Queuing allows you to:

- Communicate between programs (which might each be running in different environments) without having to write the communication code.
- Select the order in which a program processes messages.
- Balance loads on a system by arranging for more than one program to service a queue when the number of messages exceeds a threshold.
- Increase the availability of your applications by arranging for an alternative system to service the queues if your primary system is unavailable.

## What is a message queue?

A message queue, known simply as a queue, is a **named destination** to which messages can be sent. Messages accumulate on queues until they are retrieved by programs that service those queues.

Queues reside in, and are managed by, a **queue manager**, (see [Message queuing terminology](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.pro.doc/q002640_.htm?view=kc)). The physical nature of a queue depends on the operating system on which the queue manager is running. A queue can either be a volatile buffer area in the memory of a computer, or a data set on a permanent storage device (such as a disk). The physical management of queues is the responsibility of the queue manager and is not made apparent to the participating application programs.

Programs access queues only through the external services of the queue manager. They can **open a queue**, **put messages** on it, **get messages** from it, and **close the queue**. They can also **set**, and **inquire** about, the **attributes** of queues.

## Different styles of message queuing

### Point-to-point

One message is placed on the queue and one application receives that message.

In point-to-point messaging, **a sending application must know information about the receiving application** before it can send a message to that application. For example, the sending application might **need to know the name of the queue** to which to send the information, and might also **specify a queue manager name**.

### Publish/Subscribe

A copy of each message published by a publishing application is delivered to every interested application. There might be many, one, or no interested applications. In publish/subscribe an interested application is known as a subscriber and the messages are queued on a **queue identified by a subscription**.

Publish/subscribe messaging allows you to decouple the provider of information from the consumers of that information. The sending application and receiving application **do not need to know as much about each other** for the information to be sent and received. For more information, see [Publish/subscribe messaging](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.pro.doc/q004870_.htm?view=kc).

## Benefits of message queuing to the application designer and developer

IBM MQ allows application programs to use message queuing to participate in **message-driven** processing. Application programs can communicate across different platforms by using the appropriate message queuing software products. For example, z/OS® applications can communicate through IBM MQ for z/OS. The applications are shielded from the mechanics of the underlying communications. Some of the other benefits of message queuing are:

- You can design applications using small programs that you can share between many applications.
- You can quickly build new applications by reusing these building blocks.
- Applications written to use message queuing techniques are not affected by changes in the way that queue managers work.
- You do not need to use any communication protocols. The queue manager deals with all aspects of communication for you.
- Programs that receive messages need not be running at the time that messages are sent to them. The messages are retained on queues.

Designers can reduce the cost of their applications because development is faster, fewer developers are needed, and demands on programming skill are lower than those for applications that do not use message queuing.

IBM MQ implements a common application programming interface known as the message queue interface (or MQI) wherever the applications run. This makes it easier for you to port application programs from one platform to another.

For details about the MQI, see [The Message Queue Interface overview](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.dev.doc/q025710_.htm?view=kc).

- [Main features and benefits of message queuing](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.pro.doc/q002630_.htm?view=kc)

  This information highlights some features and benefits of message queuing. It describes features such as security and data integrity of message queuing.

- [Message queuing terminology](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.pro.doc/q002640_.htm?view=kc)

  This information gives an insight into some terms used in message queuing.

- [Messages and queues](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.pro.doc/q002650_.htm?view=kc)

  Messages and queues are the basic components of a message queuing system.
