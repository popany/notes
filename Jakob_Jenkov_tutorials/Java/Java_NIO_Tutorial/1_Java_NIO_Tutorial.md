# [Java NIO Tutorial](http://tutorials.jenkov.com/java-nio/index.html)

- [Java NIO Tutorial](#java-nio-tutorial)
  - [Java NIO: Non-blocking IO](#java-nio-non-blocking-io)
  - [Java NIO: Channels and Buffers](#java-nio-channels-and-buffers)
  - [Java NIO: Selectors](#java-nio-selectors)
  - [Java NIO Concepts](#java-nio-concepts)

Java NIO (New IO) is an alternative IO API for Java, meaning alternative to the standard [Java IO](http://tutorials.jenkov.com/java-io/index.html) and [Java Networking](http://tutorials.jenkov.com/java-networking/index.html) API's. Java NIO offers a different IO programming model than the traditional IO APIs. Note: Sometimes NIO is claimed to mean Non-blocking IO. However, this is not what NIO meant originally. Also, parts of the NIO APIs are actually blocking - e.g. the file APIs - so the label "Non-blocking" would be slightly misleading.

## Java NIO: Non-blocking IO

Java NIO enables you to do non-blocking IO. For instance, a thread can **ask a channel to read data into a buffer**. While the channel reads data into the buffer, the thread can do something else. Once data is read into the buffer, the thread can then continue processing it. The same is true for writing data to channels.

## Java NIO: Channels and Buffers

In the standard IO API you work with byte streams and character streams. In NIO you work with channels and buffers. Data is always **read from a channel into a buffer**, or **written from a buffer to a channel**.

## Java NIO: Selectors

Java NIO contains the concept of "selectors". A selector is an object that can **monitor multiple channels** for events (like: connection opened, data arrived etc.). Thus, a single thread can monitor multiple channels for data.

## Java NIO Concepts

There are several new concepts to learn in Java NIO compared to the old Java IO model. These concepts are listed below:

- [Channels](http://tutorials.jenkov.com/java-nio/channels.html)
- [Buffers](http://tutorials.jenkov.com/java-nio/buffers.html)
- [Scatter - Gather](http://tutorials.jenkov.com/java-nio/scatter-gather.html)
- [Channel to Channel Transfers](http://tutorials.jenkov.com/java-nio/channel-to-channel-transfers.html)
- [Selectors](http://tutorials.jenkov.com/java-nio/selectors.html)
- [FileChannel](http://tutorials.jenkov.com/java-nio/file-channel.html)
- [SocketChannel](http://tutorials.jenkov.com/java-nio/socketchannel.html)
- [ServerSocketChannel](http://tutorials.jenkov.com/java-nio/server-socket-channel.html)
- [Non-blocking Server Design](http://tutorials.jenkov.com/java-nio/non-blocking-server.html)
- [DatagramChannel](http://tutorials.jenkov.com/java-nio/datagram-channel.html)
- [Pipe](http://tutorials.jenkov.com/java-nio/pipe.html)
- [NIO vs. IO](http://tutorials.jenkov.com/java-nio/nio-vs-io.html)
- [Path](http://tutorials.jenkov.com/java-nio/path.html)
- [Files](http://tutorials.jenkov.com/java-nio/files.html)
- [AsynchronousFileChannel](http://tutorials.jenkov.com/java-nio/asynchronousfilechannel.html)
