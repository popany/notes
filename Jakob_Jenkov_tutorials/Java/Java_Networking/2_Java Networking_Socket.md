# [Java Networking: Socket](http://tutorials.jenkov.com/java-networking/sockets.html)

- [Java Networking: Socket](#java-networking-socket)
  - [Creating a Socket](#creating-a-socket)
  - [Writing to a Socket](#writing-to-a-socket)
  - [Reading from a Socket](#reading-from-a-socket)
  - [Closing a Socket](#closing-a-socket)

In order to connect to a server over the internet (via TCP/IP) in Java, you need to create a `java.net.Socket` and connect it to the server. Alternatively you can use a [Java NIO SocketChannel](http://tutorials.jenkov.com/java-nio/socketchannel.html), in case you prefer to use Java NIO.

## Creating a Socket

This code example connects to the server with IP address `78.46.84.171` on port 80. That server happens to be my web server (www.jenkov.com), and port 80 is the web servers port.

    Socket socket = new Socket("78.46.84.171", 80);

You can also use a domain name instead of an IP address, like this:

    Socket socket = new Socket("jenkov.com", 80);

## Writing to a Socket

To write to a Java `Socket` you must obtain its [`OutputStream`]. Here is how that is done:

    Socket socket = new Socket("jenkov.com", 80);
    OutputStream out = socket.getOutputStream();

    out.write("some data".getBytes());
    out.flush();
    out.close();

    socket.close();

That's how simple it is!

Don't forget to call `flush()` when you really, really want the data sent across the internet to the server. The underlying TCP/IP implementation in your OS may buffer the data and send it in larger chunks to fit with the size of TCP/IP packets.

## Reading from a Socket

To read from a Java Socket you will need to obtains its [`InputStream`](http://tutorials.jenkov.com/java-io/inputstream.html). Here is how that is done:

    Socket socket = new Socket("jenkov.com", 80);
    InputStream in = socket.getInputStream();

    int data = in.read();
    //... read more data...

    in.close();
    socket.close();

Pretty simple, right?

Keep in mind that you cannot always just read from the Socket's `InputStream` until it returns `-1`, as you can when reading a file. The reason is that `-1` is only returned when the **server closes the connection**. But a server may not always close the connection. Perhaps you want to send multiple requests over the same connection. In that case it would be pretty stupid to close the connection.

Instead you must know how many bytes to read from the Socket's `InputStream`. This can be done by either the **server telling how many bytes** it is sending, or by looking for a special **end-of-data character**.

## Closing a Socket

When you are done using a Java `Socket` you must close it to close the connection to the server. This is done by calling the `Socket.close()` method, like this:

    Socket socket = new Socket("jenkov.com", 80);

    socket.close();
