# [Java Networking: ServerSocket](http://tutorials.jenkov.com/java-networking/server-sockets.html)

- [Java Networking: ServerSocket](#java-networking-serversocket)
  - [Creating a ServerSocket](#creating-a-serversocket)
  - [Listening For Incoming Connections](#listening-for-incoming-connections)
  - [Closing Client Sockets](#closing-client-sockets)
  - [Closing Server Sockets](#closing-server-sockets)

In order to implement a Java server that listens for incoming connections from clients via TCP/IP, you need to use a `java.net.ServerSocket`. In case you prefer to use Java NIO instead of Java Networking (standard API), then you can also use a [ServerSocketChannel](http://tutorials.jenkov.com/java-nio/server-socket-channel.html) instead of the `java.net.ServerSocket`.

## Creating a ServerSocket

Here is a simple code example that creates a `ServerSocket` that listens on port `9000`:

    ServerSocket serverSocket = new ServerSocket(9000);

## Listening For Incoming Connections

In order to accept incoming connections you must call the `ServerSocket.accept()` method. The `accept()` method returns a `Socket` which behaves like an ordinary [Java Socket](http://tutorials.jenkov.com/java-networking/sockets.html). Here is how that looks:

    ServerSocket serverSocket = new ServerSocket(9000);

    boolean isStopped = false;
    while(!isStopped){
        Socket clientSocket = serverSocket.accept();

        //do something with clientSocket
    }

Only one incoming connection is opened for each call to the `accept()` method.

Additionally, incoming connections can only be accepted while the thread running the server has called `accept()`. All the time the thread is executing outside of this method no clients can connect. Therefore the "accepting" thread normally passes incoming connections (Socket's) on to a pool of worker threads, who then communicate with the client. See the tutorial trail [Java Multithreaded Servers](http://tutorials.jenkov.com/java-multithreaded-servers/index.html) for more information on multithreaded server design.

## Closing Client Sockets

Once a client request is finished, and no further requests will be received from that client, you must close that `Socket`, just like you would close a normal client `Socket`. This is done by calling:

    socket.close();

## Closing Server Sockets

Once the server is to shut down you need to close the `ServerSocket`. This is done by calling:

    serverSocket.close();
