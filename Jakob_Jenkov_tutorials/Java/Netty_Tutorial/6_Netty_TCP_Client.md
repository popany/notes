# [Netty TCP Client](http://tutorials.jenkov.com/netty/netty-tcp-client.html)

- [Netty TCP Client](#netty-tcp-client)
  - [Creating an EventLoopGroup](#creating-an-eventloopgroup)
  - [Creating and Configuring a Bootstrap](#creating-and-configuring-a-bootstrap)
  - [Creating a ChannelInitializer](#creating-a-channelinitializer)
  - [Starting the Client](#starting-the-client)
  - [The ClientHandler](#the-clienthandler)

Netty can be used to create TCP clients too. In this tutorial I will explain how to create a Netty TCP client. To create a TCP client with Netty you need to:

- Create an EventLoopGroup
- Create and configure a Bootstrap
- Create a ChannelInitializer
- Start the client

Each of these steps are described in the following sections. Here is first a full Netty TCP client example:

    EventLoopGroup group = new NioEventLoopGroup();
    try{
        Bootstrap clientBootstrap = new Bootstrap();

        clientBootstrap.group(group);
        clientBootstrap.channel(NioSocketChannel.class);
        clientBootstrap.remoteAddress(new InetSocketAddress("localhost", 9999));
        clientBootstrap.handler(new ChannelInitializer<SocketChannel>() {
            protected void initChannel(SocketChannel socketChannel) throws Exception {
                socketChannel.pipeline().addLast(new ClientHandler());
            }
        });
        ChannelFuture channelFuture = clientBootstrap.connect().sync();
        channelFuture.channel().closeFuture().sync();
    } finally {
        group.shutdownGracefully().sync();
    }

## Creating an EventLoopGroup

The first step in creating a Netty TCP client is to create a Netty  `EventLoopGroup`. Since this example uses [Java NIO](http://tutorials.jenkov.com/java-nio/index.html) a `NioEventLoopGroup` is created. This line creates the `EventLoopGroup`:

    EventLoopGroup group = new NioEventLoopGroup();

## Creating and Configuring a Bootstrap

The second step in creating a TCP client with Netty is to create a Netty `Bootstrap` instance. Notice that a TCP server uses a `ServerBootstrap` but a TCP client uses a `Bootstrap` instance. This line creates the Netty `Bootstrap` instance:

    Bootstrap clientBootstrap = new Bootstrap();

The `Bootstrap` instance must also be configured. These lines configure the `Bootstrap` instance:

    clientBootstrap.group(group);
    clientBootstrap.channel(NioSocketChannel.class);
    clientBootstrap.remoteAddress(new InetSocketAddress("localhost", 9999));

These lines set the `EventLoopGroup` on the `Bootstrap` instance, specify that the `Bootstrap` instance is to use NIO, and set the remote IP address and TCP port to connect to.

## Creating a ChannelInitializer

The third step in creating a Netty TCP client is to create a `ChannelInitializer` and attach it to the `Bootstrap` instance. Here is how that is done:

    clientBootstrap.handler(new ChannelInitializer<SocketChannel>() {
        protected void initChannel(SocketChannel socketChannel) throws Exception {
            socketChannel.pipeline().addLast(new ClientHandler());
        }
    });

The `ChannelInitializer` attaches a `ClientHandler` instance to the `SocketChannel` it creates. The `ClientHandler` is called whenever data is received from the `SocketChannel` it is attached to.

The `ClientHandler` is attached to the `SocketChannel`'s channel pipeline.

## Starting the Client

The last step necessary to create a Netty TCP client is to start the TCP client. Here is the line that starts the TCP client:

    ChannelFuture channelFuture = clientBootstrap.connect().sync();

This line instructs the `Bootstrap` instance to connect to the remote server, and waits until it does.

The following line waits until the client shuts down:

    channelFuture.channel().closeFuture().sync();

## The ClientHandler

The `ClientHandler` attached to the `SocketChannel` connected to the remote server contains the actual client behaviour. Here is how the `ClientHandler` used in this example looks:

    public class ClientHandler extends SimpleChannelInboundHandler {

        @Override
        public void channelActive(ChannelHandlerContext channelHandlerContext){
            channelHandlerContext.writeAndFlush(Unpooled.copiedBuffer("Netty Rocks!", CharsetUtil.UTF_8));
        }

        @Override
        public void channelRead(ChannelHandlerContext channelHandlerContext, ByteBuf in) {
            System.out.println("Client received: " + in.toString(CharsetUtil.UTF_8));
        }

        @Override
        public void exceptionCaught(ChannelHandlerContext channelHandlerContext, Throwable cause){
            cause.printStackTrace();
            channelHandlerContext.close();
        }
    }
