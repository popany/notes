# [Netty](https://netty.io/index.html)

- [Netty](#netty)
  - [Documentation](#documentation)
  - [Repository](#repository)
  - [Note](#note)
    - [`ChannelInboundHandlerAdapter`](#channelinboundhandleradapter)
    - [`ChannelHandlerContext`](#channelhandlercontext)
    - [`ChannelPipeline`](#channelpipeline)
      - [Creation of a pipeline](#creation-of-a-pipeline)
      - [How an event flows in a pipeline](#how-an-event-flows-in-a-pipeline)
      - [Forwarding an event to the next handler](#forwarding-an-event-to-the-next-handler)
      - [Building a pipeline](#building-a-pipeline)
      - [Thread safety](#thread-safety)
    - [`Channel`](#channel)
      - [All I/O operations are asynchronous.](#all-io-operations-are-asynchronous)
      - [Channels are hierarchical](#channels-are-hierarchical)
      - [Downcast to access transport-specific operations](#downcast-to-access-transport-specific-operations)
      - [Release resources](#release-resources)
    - [`ChannelConfig`](#channelconfig)
      - [Option map](#option-map)
    - [`SocketChannelConfig`](#socketchannelconfig)
      - [Available options](#available-options)
    - [`ServerChannel`](#serverchannel)
    - [`ChannelFuture`](#channelfuture)
      - [Prefer `addListener(GenericFutureListener)` to `await()`](#prefer-addlistenergenericfuturelistener-to-await)
      - [Do not call `await()` inside `ChannelHandler`](#do-not-call-await-inside-channelhandler)
      - [Do not confuse I/O timeout and await timeout](#do-not-confuse-io-timeout-and-await-timeout)
    - [`ChannelFutureListener`](#channelfuturelistener)
      - [Return the control to the caller quickly](#return-the-control-to-the-caller-quickly)
    - [`EventLoopGroup`](#eventloopgroup)
      - [Method Summary](#method-summary)
        - [`ChannelFuture register(Channel channel)`](#channelfuture-registerchannel-channel)
    - [`EventLoop`](#eventloop)
    - [`MultithreadEventLoopGroup`](#multithreadeventloopgroup)
    - [`NioEventLoopGroup`](#nioeventloopgroup)
    - [`EpollEventLoopGroup`](#epolleventloopgroup)
    - [`AbstractBootstrap`](#abstractbootstrap)
      - [Method Summary](#method-summary-1)
      - [`B channel(Class<? extends C> channelClass)`](#b-channelclass-extends-c-channelclass)
      - [`<T> B	option(ChannelOption<T> option, T value)`](#t-boptionchanneloptiont-option-t-value)
    - [`ServerBootstrap`](#serverbootstrap)
      - [Method Summary](#method-summary-2)
        - [`ServerBootstrap childHandler(ChannelHandler childHandler)`](#serverbootstrap-childhandlerchannelhandler-childhandler)
        - [`<T> ServerBootstrap childOption(ChannelOption<T> childOption, T value)`](#t-serverbootstrap-childoptionchanneloptiont-childoption-t-value)
        - [`ServerBootstrap group(EventLoopGroup parentGroup, EventLoopGroup childGroup)`](#serverbootstrap-groupeventloopgroup-parentgroup-eventloopgroup-childgroup)
    - [`ChannelInitializer`](#channelinitializer)
      - [Method Summary](#method-summary-3)
        - [`protected abstract void initChannel(C ch)`](#protected-abstract-void-initchannelc-ch)
    - [`ByteToMessageDecoder`](#bytetomessagedecoder)
      - [Frame detection](#frame-detection)
      - [Pitfalls](#pitfalls)
    - [`ReplayingDecoder`](#replayingdecoder)
      - [How does this work?](#how-does-this-work)
      - [Limitations](#limitations)
      - [Improving the performance](#improving-the-performance)
        - [Calling `checkpoint(T)` with an Enum](#calling-checkpointt-with-an-enum)
        - [Calling `checkpoint()` with no parameter](#calling-checkpoint-with-no-parameter)
        - [Replacing a decoder with another decoder in a pipeline](#replacing-a-decoder-with-another-decoder-in-a-pipeline)
    - [`IdleStateHandler`](#idlestatehandler)
      - [Supported idle states](#supported-idle-states)

## [Documentation](https://netty.io/wiki/index.html)

## [Repository](https://github.com/netty/netty)

## Note

### [`ChannelInboundHandlerAdapter`](https://netty.io/4.1/api/io/netty/channel/ChannelInboundHandlerAdapter.html)

    public class ChannelInboundHandlerAdapter
    extends ChannelHandlerAdapter
    implements ChannelInboundHandler

Abstract base class for [`ChannelInboundHandler`](https://netty.io/4.1/api/io/netty/channel/ChannelInboundHandler.html) implementations which provide implementations of all of their methods.

This implementation **just forward the operation** to the next [[`ChannelHandler`](https://netty.io/4.1/api/io/netty/channel/ChannelHandler.html) in the [`ChannelPipeline`](https://netty.io/4.1/api/io/netty/channel/ChannelPipeline.html). Sub-classes may override a method implementation to change this.

Be aware that messages are **not released** after the [`channelRead(ChannelHandlerContext, Object)`](https://netty.io/4.1/api/io/netty/channel/ChannelInboundHandlerAdapter.html#channelRead-io.netty.channel.ChannelHandlerContext-java.lang.Object-) method returns automatically. If you are looking for a [`ChannelInboundHandler`](https://netty.io/4.1/api/io/netty/channel/ChannelInboundHandler.html) implementation that releases the received messages automatically, please see [`SimpleChannelInboundHandler`](https://netty.io/4.1/api/io/netty/channel/SimpleChannelInboundHandler.html).

### [`ChannelHandlerContext`](https://netty.io/4.1/api/io/netty/channel/ChannelHandlerContext.html)

    public interface ChannelHandlerContext
    extends AttributeMap, ChannelInboundInvoker, ChannelOutboundInvoker

Enables a [`ChannelHandler`](https://netty.io/4.1/api/io/netty/channel/ChannelHandler.html) to interact with its [`ChannelPipeline`](https://netty.io/4.1/api/io/netty/channel/ChannelPipeline.html) and other handlers. Among other things a handler can notify the next `ChannelHandler` in the `ChannelPipeline` as well as modify the `ChannelPipeline` it belongs to dynamically.

### [`ChannelPipeline`](https://netty.io/4.1/api/io/netty/channel/ChannelPipeline.html)

    public interface ChannelPipeline
    extends ChannelInboundInvoker, ChannelOutboundInvoker, Iterable<Map.Entry<String,ChannelHandler>>

A list of `ChannelHandler`s which handles or intercepts inbound events and outbound operations of a [`Channel`](https://netty.io/4.1/api/io/netty/channel/Channel.html). `ChannelPipeline` implements an advanced form of the [Intercepting Filter pattern](https://www.oracle.com/technetwork/java/interceptingfilter-142169.html) to give a user full control over how an event is handled and how the `ChannelHandler`s in a pipeline interact with each other.

#### Creation of a pipeline

Each channel has its own pipeline and it is **created automatically** when a new channel is created.

#### How an event flows in a pipeline

The following diagram describes how I/O events are processed by `ChannelHandler`s in a `ChannelPipeline` typically. An I/O event is handled by either a `ChannelInboundHandler` or a `ChannelOutboundHandler` and be forwarded to its closest handler by calling the event **propagation methods** defined in `ChannelHandlerContext`, such as `ChannelHandlerContext.fireChannelRead(Object)` and `ChannelOutboundInvoker.write(Object)`.

                                                   I/O Request
                                              via Channel or
                                          ChannelHandlerContext
                                                        |
    +---------------------------------------------------+---------------+
    |                           ChannelPipeline         |               |
    |                                                  \|/              |
    |    +---------------------+            +-----------+----------+    |
    |    | Inbound Handler  N  |            | Outbound Handler  1  |    |
    |    +----------+----------+            +-----------+----------+    |
    |              /|\                                  |               |
    |               |                                  \|/              |
    |    +----------+----------+            +-----------+----------+    |
    |    | Inbound Handler N-1 |            | Outbound Handler  2  |    |
    |    +----------+----------+            +-----------+----------+    |
    |              /|\                                  .               |
    |               .                                   .               |
    | ChannelHandlerContext.fireIN_EVT() ChannelHandlerContext.OUT_EVT()|
    |        [ method call]                       [method call]         |
    |               .                                   .               |
    |               .                                  \|/              |
    |    +----------+----------+            +-----------+----------+    |
    |    | Inbound Handler  2  |            | Outbound Handler M-1 |    |
    |    +----------+----------+            +-----------+----------+    |
    |              /|\                                  |               |
    |               |                                  \|/              |
    |    +----------+----------+            +-----------+----------+    |
    |    | Inbound Handler  1  |            | Outbound Handler  M  |    |
    |    +----------+----------+            +-----------+----------+    |
    |              /|\                                  |               |
    +---------------+-----------------------------------+---------------+
                    |                                  \|/
    +---------------+-----------------------------------+---------------+
    |               |                                   |               |
    |       [ Socket.read() ]                    [ Socket.write() ]     |
    |                                                                   |
    |  Netty Internal I/O Threads (Transport Implementation)            |
    +-------------------------------------------------------------------+

An inbound event is handled by the inbound handlers in the bottom-up direction as shown on the left side of the diagram. An inbound handler usually handles the inbound data generated by the I/O thread on the bottom of the diagram. The inbound data is often read from a remote peer via the actual input operation such as `SocketChannel.read(ByteBuffer)`. If an inbound event **goes beyond the top** inbound handler, it is discarded silently, or logged if it needs your attention.

An outbound event is handled by the outbound handler in the top-down direction as shown on the right side of the diagram. An outbound handler usually generates or transforms the outbound traffic such as write requests. If an outbound event goes beyond the bottom outbound handler, it is handled by an I/O thread associated with the `Channel`. The I/O thread often performs the actual output operation such as `SocketChannel.write(ByteBuffer)`.

For example, let us assume that we created the following pipeline:

    ChannelPipeline p = ...;
    p.addLast("1", new InboundHandlerA());
    p.addLast("2", new InboundHandlerB());
    p.addLast("3", new OutboundHandlerA());
    p.addLast("4", new OutboundHandlerB());
    p.addLast("5", new InboundOutboundHandlerX());

In the example above, the class whose name starts with **Inbound** means it is an inbound handler. The class whose name starts with **Outbound** means it is a outbound handler.

In the given example configuration, the handler evaluation order is 1, 2, 3, 4, 5 when an event goes inbound. When an event goes outbound, the order is 5, 4, 3, 2, 1. On top of this principle, `ChannelPipeline` **skips** the evaluation of certain handlers to shorten the stack depth:

- 3 and 4 don't implement `ChannelInboundHandler`, and therefore the actual evaluation order of an inbound event will be: 1, 2, and 5.

- 1 and 2 don't implement `ChannelOutboundHandler`, and therefore the actual evaluation order of a outbound event will be: 5, 4, and 3.

- If 5 implements both `ChannelInboundHandler` and `ChannelOutboundHandler`, the evaluation order of an inbound and a outbound event could be 125 and 543 respectively.

#### Forwarding an event to the next handler

As you might noticed in the diagram shows, a handler has to invoke the event propagation methods in `ChannelHandlerContext` to forward an event to its next handler. Those methods include:

- Inbound event propagation methods:

  - ChannelHandlerContext.fireChannelRegistered()
  - ChannelHandlerContext.fireChannelActive()
  - ChannelHandlerContext.fireChannelRead(Object)
  - ChannelHandlerContext.fireChannelReadComplete()
  - ChannelHandlerContext.fireExceptionCaught(Throwable)
  - ChannelHandlerContext.fireUserEventTriggered(Object)
  - ChannelHandlerContext.fireChannelWritabilityChanged()
  - ChannelHandlerContext.fireChannelInactive()
  - ChannelHandlerContext.fireChannelUnregistered()

- Outbound event propagation methods:

  - ChannelOutboundInvoker.bind(SocketAddress, ChannelPromise)
  - ChannelOutboundInvoker.connect(SocketAddress, SocketAddress, ChannelPromise)
  - ChannelOutboundInvoker.write(Object, ChannelPromise)
  - ChannelHandlerContext.flush()
  - ChannelHandlerContext.read()
  - ChannelOutboundInvoker.disconnect(ChannelPromise)
  - ChannelOutboundInvoker.close(ChannelPromise)
  - ChannelOutboundInvoker.deregister(ChannelPromise)

and the following example shows how the event propagation is usually done:

    public class MyInboundHandler extends ChannelInboundHandlerAdapter {
        @Override
        public void channelActive(ChannelHandlerContext ctx) {
            System.out.println("Connected!");
            ctx.fireChannelActive();
        }
    }

    public class MyOutboundHandler extends ChannelOutboundHandlerAdapter {
        @Override
        public void close(ChannelHandlerContext ctx, ChannelPromise promise) {
            System.out.println("Closing ..");
            ctx.close(promise);
        }
    }

#### Building a pipeline

A user is supposed to have one or more `ChannelHandler`s in a pipeline to receive I/O events (e.g. read) and to request I/O operations (e.g. write and close). For example, a **typical server** will have the following handlers in each channel's pipeline, but your mileage may vary depending on the complexity and characteristics of the protocol and business logic:

- Protocol Decoder - translates binary data (e.g. ByteBuf) into a Java object.
- Protocol Encoder - translates a Java object into binary data.
- Business Logic Handler - performs the actual business logic (e.g. database access).

and it could be represented as shown in the following example:

    static final EventExecutorGroup group = new DefaultEventExecutorGroup(16);
    ...
   
    ChannelPipeline pipeline = ch.pipeline();
   
    pipeline.addLast("decoder", new MyProtocolDecoder());
    pipeline.addLast("encoder", new MyProtocolEncoder());
   
    // Tell the pipeline to run MyBusinessLogicHandler's event handler methods
    // in a different thread than an I/O thread so that the I/O thread is not blocked by
    // a time-consuming task.
    // If your business logic is fully asynchronous or finished very quickly, you don't
    // need to specify a group.
    pipeline.addLast(group, "handler", new MyBusinessLogicHandler());

Be aware that while using `DefaultEventLoopGroup` will **offload** the operation from the `EventLoop` it will still process tasks in a serial fashion per `ChannelHandlerContext` and so guarantee ordering. Due the ordering it may still become a bottle-neck. If ordering is not a requirement for your use-case you may want to consider using `UnorderedThreadPoolEventExecutor` to maximize the parallelism of the task execution.

#### Thread safety

A `ChannelHandler` can be added or removed at any time because a `ChannelPipeline` is **thread safe**. For example, you can insert an encryption handler when sensitive information is about to be exchanged, and remove it after the exchange.

### [`Channel`](https://netty.io/4.1/api/io/netty/channel/Channel.html)

    public interface Channel
    extends AttributeMap, ChannelOutboundInvoker, Comparable<Channel>

A nexus to a network **socket** or a component which is capable of I/O operations such as read, write, connect, and bind.

A channel provides a user:

- the current state of the channel (e.g. is it open? is it connected?),
- the configuration parameters of the channel (e.g. receive buffer size),
- the I/O operations that the channel supports (e.g. read, write, connect, and bind), and
- the `ChannelPipeline` which handles all I/O events and requests associated with the channel.

#### All I/O operations are asynchronous.

All I/O operations in Netty are asynchronous. It means any I/O calls will return immediately with no guarantee that the requested I/O operation has been completed at the end of the call. Instead, you will be returned with a [`ChannelFuture`](https://netty.io/4.1/api/io/netty/channel/ChannelFuture.html) instance which will notify you when the requested I/O operation has succeeded, failed, or canceled.

#### Channels are hierarchical

A `Channel` can have a parent depending on how it was created. For instance, a `SocketChannel`, that was accepted by `ServerSocketChannel`, will return the `ServerSocketChannel` as its parent on `parent()`.

The semantics of the hierarchical structure depends on the transport implementation where the `Channel` belongs to. For example, you could write a new `Channel` implementation that creates the sub-channels that **share one socket connection**, as [BEEP](http://beepcore.org/) and [SSH](https://en.wikipedia.org/wiki/Secure_Shell) do.

#### Downcast to access transport-specific operations

Some transports exposes additional operations that is specific to the transport. Down-cast the `Channel` to sub-type to invoke such operations. For example, with the old I/O datagram transport, multicast join / leave operations are provided by `DatagramChannel`.

#### Release resources

It is important to call `ChannelOutboundInvoker.close()` or `ChannelOutboundInvoker.close(ChannelPromise)` to release all resources once you are done with the `Channel`. This ensures all resources are released in a proper way, i.e. filehandles.

### [`ChannelConfig`](https://netty.io/4.1/api/io/netty/channel/ChannelConfig.html)

    public interface ChannelConfig

A set of configuration properties of a Channel.

Please down-cast to more specific configuration type such as [`SocketChannelConfig`](https://netty.io/4.1/api/io/netty/channel/socket/SocketChannelConfig.html) or use [`setOptions(Map)`](https://netty.io/4.1/api/io/netty/channel/ChannelConfig.html#setOptions-java.util.Map-) to set the transport-specific properties:

    Channel ch = ...;
    SocketChannelConfig cfg = (SocketChannelConfig) ch.getConfig();
    cfg.setTcpNoDelay(false);

#### Option map

An option map property is a dynamic write-only property which allows the configuration of a `Channel` without down-casting its associated `ChannelConfig`. To update an option map, please call `setOptions(Map)`.

All `ChannelConfig` has the following options:

|Name|Associated setter method|
|-|-|
`ChannelOption.CONNECT_TIMEOUT_MILLIS`|`setConnectTimeoutMillis(int)`
`ChannelOption.WRITE_SPIN_COUNT`|`setWriteSpinCount(int)`
`ChannelOption.WRITE_BUFFER_WATER_MARK`|`setWriteBufferWaterMark(WriteBufferWaterMark)`
`ChannelOption.ALLOCATOR`|`setAllocator(ByteBufAllocator)`
`ChannelOption.AUTO_READ`|`setAutoRead(boolean)`
|

More options are available in the sub-types of `ChannelConfig`. For example, you can configure the parameters which are specific to a TCP/IP socket as explained in `SocketChannelConfig`.

### [`SocketChannelConfig`](https://netty.io/4.1/api/io/netty/channel/socket/SocketChannelConfig.html)

    public interface SocketChannelConfig
    extends DuplexChannelConfig

A `ChannelConfig` for a `SocketChannel`.

#### Available options

In addition to the options provided by [`DuplexChannelConfig`](https://netty.io/4.1/api/io/netty/channel/socket/DuplexChannelConfig.html), `SocketChannelConfig` allows the following options in the option map:

|Name|Associated setter method|
|-|-|
`ChannelOption.SO_KEEPALIVE`|`setKeepAlive(boolean)`
`ChannelOption.SO_REUSEADDR`|`setReuseAddress(boolean)`
`ChannelOption.SO_LINGER`|`setSoLinger(int)`
`ChannelOption.TCP_NODELAY`|`setTcpNoDelay(boolean)`
`ChannelOption.SO_RCVBUF`|`setReceiveBufferSize(int)`
`ChannelOption.SO_SNDBUF`|`setSendBufferSize(int)`
`ChannelOption.IP_TOS`|`setTrafficClass(int)`
`ChannelOption.ALLOW_HALF_CLOSURE`|`setAllowHalfClosure(boolean)`
|

### [`ServerChannel`](https://netty.io/4.1/api/io/netty/channel/ServerChannel.html)

    public interface ServerChannel
    extends Channel

A `Channel` that accepts an incoming connection attempt and creates its child `Channel`s by accepting them. `ServerSocketChannel` is a good example.

### [`ChannelFuture`](https://netty.io/4.1/api/io/netty/channel/ChannelFuture.html)

    public interface ChannelFuture
    extends Future<Void>

The result of an asynchronous `Channel` I/O operation.

All I/O operations in Netty are asynchronous. It means any I/O calls will return immediately with no guarantee that the requested I/O operation has been completed at the end of the call. Instead, you will be returned with a `ChannelFuture` instance which gives you the information about the result or status of the I/O operation.

A `ChannelFuture` is either uncompleted or completed. When an I/O operation begins, a new future object is created. The new future is uncompleted initially - it is neither succeeded, failed, nor cancelled because the I/O operation is not finished yet. If the I/O operation is finished either successfully, with failure, or by cancellation, the future is marked as completed with more specific information, such as the cause of the failure. Please note that even failure and cancellation belong to the **completed state**.

                                         +---------------------------+
                                         | Completed successfully    |
                                         +---------------------------+
                                    +---->      isDone() = true      |
    +--------------------------+    |    |   isSuccess() = true      |
    |        Uncompleted       |    |    +===========================+
    +--------------------------+    |    | Completed with failure    |
    |      isDone() = false    |    |    +---------------------------+
    |   isSuccess() = false    |----+---->      isDone() = true      |
    | isCancelled() = false    |    |    |       cause() = non-null  |
    |       cause() = null     |    |    +===========================+
    +--------------------------+    |    | Completed by cancellation |
                                    |    +---------------------------+
                                    +---->      isDone() = true      |
                                         | isCancelled() = true      |
                                         +---------------------------+

Various methods are provided to let you check if the I/O operation has been completed, wait for the completion, and retrieve the result of the I/O operation. It also allows you to add `ChannelFutureListener`s so you can get notified when the I/O operation is completed.

#### Prefer `addListener(GenericFutureListener)` to `await()`

It is recommended to prefer `addListener(GenericFutureListener)` to `await()` wherever possible to get notified when an I/O operation is done and to do any follow-up tasks.

`addListener(GenericFutureListener)` is non-blocking. It simply adds the specified `ChannelFutureListener` to the `ChannelFuture`, and **I/O thread** will notify the listeners when the I/O operation associated with the future is done. `ChannelFutureListener` yields the best performance and resource utilization because it does not block at all, but it could be tricky to implement a sequential logic if you are not used to event-driven programming.

By contrast, `await()` is a blocking operation. Once called, the caller thread blocks until the operation is done. It is easier to implement a sequential logic with `await()`, but the caller thread blocks unnecessarily until the I/O operation is done and there's relatively expensive cost of **inter-thread notification**. Moreover, there's a chance of **dead lock** in a particular circumstance, which is described below.

#### Do not call `await()` inside `ChannelHandler`

The event handler methods in `ChannelHandler` are usually called by an **I/O thread**. If `await()` is called by an event handler method, which is called by the **I/O thread**, the I/O operation it is waiting for might never complete because `await()` can block the I/O operation it is waiting for, which is a **dead lock**.

    // BAD - NEVER DO THIS
     @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        ChannelFuture future = ctx.channel().close();
        future.awaitUninterruptibly();
        // Perform post-closure operation
        // ...
    }
   
    // GOOD
     @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) {
        ChannelFuture future = ctx.channel().close();
        future.addListener(new ChannelFutureListener() {
            public void operationComplete(ChannelFuture future) {
                // Perform post-closure operation
                // ...
            }
        });
    }

In spite of the disadvantages mentioned above, there are certainly the cases where it is more convenient to call `await()`. In such a case, please make sure you do not call `await()` in an I/O thread. Otherwise, `BlockingOperationException` will be raised to prevent a dead lock.

#### Do not confuse I/O timeout and await timeout

The timeout value you specify with `Future.await(long)`, `Future.await(long, TimeUnit)`, `Future.awaitUninterruptibly(long)`, or `Future.awaitUninterruptibly(long, TimeUnit)` are not related with I/O timeout at all. If an I/O operation times out, the future will be marked as 'completed with failure,' as depicted in the diagram above. For example, connect timeout should be configured via a transport-specific option:

    // BAD - NEVER DO THIS
    Bootstrap b = ...;
    ChannelFuture f = b.connect(...);
    f.awaitUninterruptibly(10, TimeUnit.SECONDS);
    if (f.isCancelled()) {
        // Connection attempt cancelled by user
    } else if (!f.isSuccess()) {
        // You might get a NullPointerException here because the future
        // might not be completed yet.
        f.cause().printStackTrace();
    } else {
        // Connection established successfully
    }

    // GOOD
    Bootstrap b = ...;
    // Configure the connect timeout option.
    b.option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 10000);
    ChannelFuture f = b.connect(...);
    f.awaitUninterruptibly();
   
    // Now we are sure the future is completed.
    assert f.isDone();
   
    if (f.isCancelled()) {
        // Connection attempt cancelled by user
    } else if (!f.isSuccess()) {
        f.cause().printStackTrace();
    } else {
        // Connection established successfully
    }

### [`ChannelFutureListener`](https://netty.io/4.1/api/io/netty/channel/ChannelFutureListener.html)

    public interface ChannelFutureListener
    extends GenericFutureListener<ChannelFuture>

Listens to the result of a `ChannelFuture`. The result of the asynchronous Channel I/O operation is notified once this listener is added by calling `ChannelFuture.addListener(GenericFutureListener)`.

#### Return the control to the caller quickly

`GenericFutureListener.operationComplete(Future)` is directly called by an **I/O thread**. Therefore, performing a time consuming task or a blocking operation in the handler method can cause an unexpected pause during I/O. If you need to perform a blocking operation on I/O completion, try to execute the operation in a different thread using a thread pool.

### [`EventLoopGroup`](https://netty.io/4.1/api/io/netty/channel/EventLoopGroup.html)

    public interface EventLoopGroup
    extends EventExecutorGroup

Special `EventExecutorGroup` which allows registering `Channel`s that get processed for later selection during the event loop.

#### Method Summary

##### `ChannelFuture register(Channel channel)`

Register a Channel with this [`EventLoop`](https://netty.io/4.1/api/io/netty/channel/EventLoop.html).

### [`EventLoop`](https://netty.io/4.1/api/io/netty/channel/EventLoop.html)

    public interface EventLoop
    extends OrderedEventExecutor, EventLoopGroup

Will handle all the I/O operations for a `Channel` once registered. One `EventLoop` instance will usually handle more than one `Channel` but this may depend on implementation details and internals.

### [`MultithreadEventLoopGroup`](https://netty.io/4.1/api/io/netty/channel/MultithreadEventLoopGroup.html)

    public abstract class MultithreadEventLoopGroup
    extends MultithreadEventExecutorGroup
    implements EventLoopGroup

Abstract base class for `EventLoopGroup` implementations that handles their tasks with multiple threads at the same time.

### [`NioEventLoopGroup`](https://netty.io/4.1/api/io/netty/channel/nio/NioEventLoopGroup.html)

    public class NioEventLoopGroup
    extends MultithreadEventLoopGroup

`MultithreadEventLoopGroup` implementations which is used for NIO `Selector` based `Channel`s.

### [`EpollEventLoopGroup`](https://netty.io/4.1/api/io/netty/channel/epoll/EpollEventLoopGroup.html)

    public final class EpollEventLoopGroup
    extends MultithreadEventLoopGroup

`EventLoopGroup` which uses epoll under the covers. Because of this it only works on linux.

### [`AbstractBootstrap`](https://netty.io/4.1/api/io/netty/bootstrap/AbstractBootstrap.html)

    public abstract class AbstractBootstrap<B extends AbstractBootstrap<B,C>,C extends Channel>
    extends Object
    implements Cloneable

`AbstractBootstrap` is a helper class that makes it easy to bootstrap a `Channel`. It support method-chaining to provide an easy way to configure the `AbstractBootstrap`.

When not used in a `ServerBootstrap` context, the `bind()` methods are useful for connectionless transports such as datagram (UDP).

#### Method Summary

#### `B channel(Class<? extends C> channelClass)`

The Class which is used to create Channel instances from.

#### `<T> B	option(ChannelOption<T> option, T value)`

Allow to specify a `ChannelOption` which is used for the `Channel` instances once they got created.

### [`ServerBootstrap`](https://netty.io/4.1/api/io/netty/bootstrap/ServerBootstrap.html)

    public class ServerBootstrap
    extends AbstractBootstrap<ServerBootstrap,ServerChannel>

[`Bootstrap`](https://netty.io/4.1/api/io/netty/bootstrap/Bootstrap.html) sub-class which allows easy bootstrap of [`ServerChannel`](https://netty.io/4.1/api/io/netty/channel/ServerChannel.html)

#### Method Summary

##### `ServerBootstrap childHandler(ChannelHandler childHandler)`

Set the ChannelHandler which is used to serve the request for the Channel's.

##### `<T> ServerBootstrap childOption(ChannelOption<T> childOption, T value)`

Allow to specify a `ChannelOption` which is used for the `Channel` instances once they get created (after the acceptor accepted the `Channel`).

##### `ServerBootstrap group(EventLoopGroup parentGroup, EventLoopGroup childGroup)`

Set the `EventLoopGroup` for the parent (acceptor) and the child (client).

### [`ChannelInitializer`](https://netty.io/4.1/api/io/netty/channel/ChannelInitializer.html)

    @ChannelHandler.Sharable
    public abstract class ChannelInitializer<C extends Channel>
    extends ChannelInboundHandlerAdapter

A special `ChannelInboundHandler` which offers an easy way to initialize a `Channel` once it was registered to its `EventLoop`. Implementations are most often used in the context of `AbstractBootstrap.handler(ChannelHandler)`, `AbstractBootstrap.handler(ChannelHandler)` and `ServerBootstrap.childHandler(ChannelHandler)` to setup the `ChannelPipeline` of a `Channel`.

    public class MyChannelInitializer extends ChannelInitializer {
        public void initChannel(Channel channel) {
            channel.pipeline().addLast("myHandler", new MyHandler());
        }
    }

    ServerBootstrap bootstrap = ...;
    ...
    bootstrap.childHandler(new MyChannelInitializer());
    ...

Be aware that this class is marked as `ChannelHandler.Sharable` and so the implementation must be safe to be re-used.

#### Method Summary

##### `protected abstract void initChannel(C ch)`

This method will be called once the `Channel` was registered.

### [`ByteToMessageDecoder`](https://netty.io/4.1/api/io/netty/handler/codec/ByteToMessageDecoder.html)

    public abstract class ByteToMessageDecoder
    extends ChannelInboundHandlerAdapter

`ChannelInboundHandlerAdapter` which decodes bytes in a stream-like fashion from one `ByteBuf` to an other Message type. For example here is an implementation which reads all readable bytes from the input `ByteBuf` and create a new `ByteBuf`.

    public class SquareDecoder extends ByteToMessageDecoder {
        @Override
        public void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out)
                throws Exception {
            out.add(in.readBytes(in.readableBytes()));
        }
    }

#### Frame detection

Generally frame detection should be handled earlier in the pipeline by adding a `DelimiterBasedFrameDecoder`, `FixedLengthFrameDecoder`, `LengthFieldBasedFrameDecoder`, or `LineBasedFrameDecoder`.

If a custom frame decoder is required, then one needs to be careful when implementing one with `ByteToMessageDecoder`. Ensure there are enough bytes in the buffer for a complete frame by checking `ByteBuf.readableBytes()`. If there are not enough bytes for a complete frame, return without modifying the reader index to allow more bytes to arrive.

To check for complete frames without modifying the reader index, use methods like `ByteBuf.getInt(int)`. One MUST use the reader index when using methods like `ByteBuf.getInt(int)`. For example calling `in.getInt(0)` is assuming the frame starts at the beginning of the buffer, which is not always the case. Use `in.getInt(in.readerIndex())` instead.

#### Pitfalls

Be aware that sub-classes of `ByteToMessageDecoder` MUST NOT annotated with `@Sharable`.

Some methods such as `ByteBuf.readBytes(int)` will cause a memory leak if the returned buffer is not released or added to the out List. Use derived buffers like `ByteBuf.readSlice(int)` to avoid leaking memory.

### [`ReplayingDecoder`](https://netty.io/4.1/api/io/netty/handler/codec/ReplayingDecoder.html)

    public abstract class ReplayingDecoder<S>
    extends ByteToMessageDecoder

A specialized variation of `ByteToMessageDecoder` which enables implementation of a non-blocking decoder in the blocking I/O paradigm.

The biggest difference between `ReplayingDecoder` and `ByteToMessageDecoder` is that `ReplayingDecoder` allows you to implement the `decode()` and `decodeLast()` methods just like **all required bytes were received already**, rather than checking the availability of the required bytes. For example, the following `ByteToMessageDecoder` implementation:

    public class IntegerHeaderFrameDecoder extends ByteToMessageDecoder {
   
        @Override
        protected void decode(ChannelHandlerContext ctx,
                              ByteBuf buf, List<Object> out) throws Exception {
   
            if (buf.readableBytes() < 4) {
                return;
            }
    
            buf.markReaderIndex();
            int length = buf.readInt();
    
            if (buf.readableBytes() < length) {
                buf.resetReaderIndex();
                return;
            }
   
            out.add(buf.readBytes(length));
        }
    }

is simplified like the following with `ReplayingDecoder`:

    public class IntegerHeaderFrameDecoder
        extends ReplayingDecoder<Void> {

        protected void decode(ChannelHandlerContext ctx,
                              ByteBuf buf, List<Object> out) throws Exception {

            out.add(buf.readBytes(buf.readInt()));
        }
    }

#### How does this work?

`ReplayingDecoder` passes a specialized `ByteBuf` implementation which throws an Error of certain type when there's not enough data in the buffer. In the `IntegerHeaderFrameDecoder` above, you just assumed that there will be 4 or more bytes in the buffer when you call `buf.readInt()`. If there's really 4 bytes in the buffer, it will return the integer header as you expected. Otherwise, the Error will be raised and the control will be returned to `ReplayingDecoder`. If `ReplayingDecoder` catches the Error, then it will rewind the readerIndex of the buffer back to the 'initial' position (i.e. the beginning of the buffer) and call the `decode(..)` method again when more data is received into the buffer.

Please note that `ReplayingDecoder` always throws the same cached Error instance to avoid the overhead of creating a new Error and filling its stack trace for every throw.

#### Limitations

At the cost of the simplicity, `ReplayingDecoder` enforces you a few limitations:

- Some buffer operations are prohibited.

- Performance can be worse if the network is slow and the message format is complicated unlike the example above. In this case, your decoder might have to decode the same part of the message over and over again.

- You must keep in mind that `decode(..)` method can be called many times to decode a single message. For example, the following code will not work:

      public class MyDecoder extends ReplayingDecoder<Void> {
     
          private final Queue<Integer> values = new LinkedList<Integer>();
       
          @Override
          public void decode(.., ByteBuf buf, List<Object> out) throws Exception {
       
              // A message contains 2 integers.
              values.offer(buf.readInt());
              values.offer(buf.readInt());
       
              // This assertion will fail intermittently since values.offer()
              // can be called more than two times!
              assert values.size() == 2;
              out.add(values.poll() + values.poll());
          }
      }

  The correct implementation looks like the following, and you can also utilize the 'checkpoint' feature which is explained in detail in the next section.

      public class MyDecoder extends ReplayingDecoder<Void> {
     
          private final Queue<Integer> values = new LinkedList<Integer>();
       
          @Override
          public void decode(.., ByteBuf buf, List<Object> out) throws Exception {
       
              // Revert the state of the variable that might have been changed
              // since the last partial decode.
              values.clear();
         
              // A message contains 2 integers.
              values.offer(buf.readInt());
              values.offer(buf.readInt());
         
              // Now we know this assertion will never fail.
              assert values.size() == 2;
              out.add(values.poll() + values.poll());
          }
      }

#### Improving the performance

Fortunately, the performance of a complex decoder implementation can be improved significantly with the `checkpoint()` method. The `checkpoint()` method updates the 'initial' position of the buffer so that `ReplayingDecoder` rewinds the readerIndex of the buffer to the last position where you called the `checkpoint()` method.

##### Calling `checkpoint(T)` with an Enum

Although you can just use `checkpoint()` method and manage the state of the decoder by yourself, the easiest way to manage the state of the decoder is to create an `Enum` type which represents the current state of the decoder and to call `checkpoint(T)` method whenever the state changes. You can have as many states as you want depending on the complexity of the message you want to decode:

    public enum MyDecoderState {
        READ_LENGTH,
        READ_CONTENT;
    }
   
    public class IntegerHeaderFrameDecoder
        extends ReplayingDecoder<MyDecoderState> {
   
        private int length;
   
        public IntegerHeaderFrameDecoder() {
            // Set the initial state.
            super(MyDecoderState.READ_LENGTH);
        }
   
        @Override
        protected void decode(ChannelHandlerContext ctx,
                              ByteBuf buf, List<Object> out) throws Exception {
            switch (state()) {
            case READ_LENGTH:
                length = buf.readInt();
                checkpoint(MyDecoderState.READ_CONTENT);
            case READ_CONTENT:
                ByteBuf frame = buf.readBytes(length);
                checkpoint(MyDecoderState.READ_LENGTH);
                out.add(frame);
                break;
            default:
                throw new Error("Shouldn't reach here.");
            }
        }
    }

##### Calling `checkpoint()` with no parameter

An alternative way to manage the decoder state is to manage it by yourself.

    public class IntegerHeaderFrameDecoder
        extends ReplayingDecoder<Void> {
   
        private boolean readLength;
        private int length;
   
        @Override
        protected void decode(ChannelHandlerContext ctx,
                              ByteBuf buf, List<Object> out) throws Exception {
            if (!readLength) {
                length = buf.readInt();
                readLength = true;
                checkpoint();
            }
    
            if (readLength) {
                ByteBuf frame = buf.readBytes(length);
                readLength = false;
                checkpoint();
                out.add(frame);
            }
        }
    }

##### Replacing a decoder with another decoder in a pipeline

If you are going to write a protocol multiplexer, you will probably want to replace a `ReplayingDecoder (protocol detector)` with another `ReplayingDecoder`, `ByteToMessageDecoder` or `MessageToMessageDecoder` (actual protocol decoder). It is not possible to achieve this simply by calling `ChannelPipeline.replace(ChannelHandler, String, ChannelHandler)`, but some additional steps are required:

    public class FirstDecoder extends ReplayingDecoder<Void> {
   
         @Override
        protected void decode(ChannelHandlerContext ctx,
                                ByteBuf buf, List<Object> out) {
            ...
            // Decode the first message
            Object firstMessage = ...;
   
            // Add the second decoder
            ctx.pipeline().addLast("second", new SecondDecoder());
   
            if (buf.isReadable()) {
                // Hand off the remaining data to the second decoder
                out.add(firstMessage);
                out.add(buf.readBytes(super.actualReadableBytes()));
            } else {
                // Nothing to hand off
                out.add(firstMessage);
            }
            // Remove the first decoder (me)
            ctx.pipeline().remove(this);
        }
    }

### [`IdleStateHandler`](https://netty.io/4.1/api/io/netty/handler/timeout/IdleStateHandler.html)

    public class IdleStateHandler
    extends ChannelDuplexHandler

Triggers an `IdleStateEvent` when a `Channel` has not performed read, write, or both operation for a while.

#### Supported idle states

|Property|Meaning|
|-|-|
`readerIdleTime`|an `IdleStateEvent` whose state is `IdleState.READER_IDLE` will be triggered when no read was performed for the specified period of time. Specify `0` to disable.
`writerIdleTime`|an `IdleStateEvent` whose state is `IdleState.WRITER_IDLE` will be triggered when no write was performed for the specified period of time. Specify `0` to disable.
`allIdleTime`|an `IdleStateEvent` whose state is `IdleState.ALL_IDLE` will be triggered when neither read nor write was performed for the specified period of time. Specify `0` to disable.
|

    // An example that sends a ping message when there is no outbound traffic
    // for 30 seconds.  The connection is closed when there is no inbound traffic
    // for 60 seconds.
   
    public class MyChannelInitializer extends ChannelInitializer<Channel> {
         @Override
        public void initChannel(Channel channel) {
            channel.pipeline().addLast("idleStateHandler", new IdleStateHandler(60, 30, 0));
            channel.pipeline().addLast("myHandler", new MyHandler());
        }
    }
   
    // Handler should handle the IdleStateEvent triggered by IdleStateHandler.
    public class MyHandler extends ChannelDuplexHandler {
         @Override
        public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
            if (evt instanceof IdleStateEvent) {
                IdleStateEvent e = (IdleStateEvent) evt;
                if (e.state() == IdleState.READER_IDLE) {
                    ctx.close();
                } else if (e.state() == IdleState.WRITER_IDLE) {
                    ctx.writeAndFlush(new PingMessage());
                }
            }
        }
    }
   
    ServerBootstrap bootstrap = ...;
    ...
    bootstrap.childHandler(new MyChannelInitializer());
    ...
