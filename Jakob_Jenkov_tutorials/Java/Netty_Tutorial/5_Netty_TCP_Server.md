# [Netty TCP Server](http://tutorials.jenkov.com/netty/netty-tcp-server.html)

- [Netty TCP Server](#netty-tcp-server)
  - [Creating an EventLoopGroup](#creating-an-eventloopgroup)
  - [Creating a ServerBootStrap](#creating-a-serverbootstrap)
  - [Creating a ChannelInitializer](#creating-a-channelinitializer)
  - [Start the Server](#start-the-server)
  - [The HelloServerHandler](#the-helloserverhandler)

One of Netty's servers is a TCP server. To create a Netty TCP server you must:

- Create an EventLoopGroup
- Create and configure a ServerBootstrap
- Create a ChannelInitializer
- Start the server

Here is a code example showing how to create a Netty TCP server:

    EventLoopGroup group = new NioEventLoopGroup();

    try{
        ServerBootstrap serverBootstrap = new ServerBootstrap();
        serverBootstrap.group(group);
        serverBootstrap.channel(NioServerSocketChannel.class);
        serverBootstrap.localAddress(new InetSocketAddress("localhost", 9999));

        serverBootstrap.childHandler(new ChannelInitializer<SocketChannel>() {
            protected void initChannel(SocketChannel socketChannel) throws Exception {
                socketChannel.pipeline().addLast(new HelloServerHandler());
            }
        });
        ChannelFuture channelFuture = serverBootstrap.bind().sync();
        channelFuture.channel().closeFuture().sync();
    } catch(Exception e){
        e.printStackTrace();
    } finally {
        group.shutdownGracefully().sync();
    }

The process is broken down into smaller steps and described individually in the following sections.

## Creating an EventLoopGroup

The first step in creating a Netty TCP server is to create a Netty `EventLoopGroup`. Since this example uses [Java NIO](http://tutorials.jenkov.com/java-nio/index.html) a `NioEventLoopGroup` is created. This is the line that creates the EventLoopGroup:

    EventLoopGroup group = new NioEventLoopGroup();

## Creating a ServerBootStrap

The next step in creating a Netty TCP server is to create and configure a `ServerBootStrap`. This is done with these lines:

    ServerBootstrap serverBootstrap = new ServerBootstrap();
    serverBootstrap.group(group);
    serverBootstrap.channel(NioServerSocketChannel.class);
    serverBootstrap.localAddress(new InetSocketAddress("localhost", 9999));

- First a `ServerBootstrap` instance is created.

- Second the `EventLoopGroup` is set on the `ServerBootstrap` instance.

- Third, the `NioServerSocketChannel` class instance is set on the `ServerBootstrap` instance. This is necessary because the example uses a `NioEventLoopGroup`.

- Fourth, the local IP address / domain + TCP port is set on the `ServerBootstrap`. This is needed for the Netty TCP server to boot.

## Creating a ChannelInitializer

The third step in booting up a Netty TCP server is to create a `ChannelInitializer` and attach it to the `ServerBootstrap` instance. The `ChannelInitializer` **initializes the sockets of all incoming TCP connections**.

Creating and attaching the ChannelInitializer is done in these lines:

    serverBootstrap.childHandler(new ChannelInitializer<SocketChannel>() {
        protected void initChannel(SocketChannel socketChannel) throws Exception {
            socketChannel.pipeline().addLast(new HelloServerHandler());
        }
    });

The Netty `ChannelInitializer` class is an abstract class. Its method `initChannel()` is called whenever a new incoming TCP connection is accepted by the TCP server. As you can see, it attaches a new `HelloServerHandler` (a `ChannelHandler`) to each new `SocketChannel`. It is also possible to reuse the same `ChannelHandler` across all new `SocketChannel` instances, instead of creating a new every time as is done here.

As you can see, the `ChannelInitializer` is added to the `ServerBootstrap` using the `childHandler()` method. The reason it is called a "child" handler is that each **accepted `SocketChannel` is considered a "child" of the server socket that accepts it**.

## Start the Server

The final step of booting a Netty TCP server is to start up the server. Starting the TCP server is done with this line:

    ChannelFuture channelFuture = serverBootstrap.bind().sync();

The `serverBootstrap.bind()` method returns a `ChannelFuture` which can be used to know when the binding of the server (binding to local address and TCP port) is done. By calling `sync()` on the `ChannelFuture` the main thread that creates the server waits until the server has started, before continuing. The `sync()` method also returns a `ChannelFuture`, by the way.

## The HelloServerHandler

The `HelloServerHandler` added to each `SocketChannel` by the `ChannelInitializer` is the component that handles the incoming data from the client connections. Here is how the `HelloServerHandler` code looks:

public class HelloServerHandler extends ChannelInboundHandlerAdapter {

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        ByteBuf inBuffer = (ByteBuf) msg;

        String received = inBuffer.toString(CharsetUtil.UTF_8);
        System.out.println("Server received: " + received);

        ctx.write(Unpooled.copiedBuffer("Hello " + received, CharsetUtil.UTF_8));
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        ctx.writeAndFlush(Unpooled.EMPTY_BUFFER)
                .addListener(ChannelFutureListener.CLOSE);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
        ctx.close();
    }
}

The `channelRead()` method is called whenever data is received from the `SocketChannel` the `HelloServerHandler` instance is attached to. As you can see, the `channelRead()` responds with "Hello " + whatever the client sent to the server.

The `channelReadComplete()` method is called when there is no more data to read from the `SocketChannel`.

The `exceptionCaught()` method is called if an exception is thrown while receiving or sending data from the `SocketChannel`. In here you can decide what should happen, like closing the connection, or responding with an error code etc.
