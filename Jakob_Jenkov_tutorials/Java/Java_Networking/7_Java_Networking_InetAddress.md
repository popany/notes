# [Java Networking: InetAddress](http://tutorials.jenkov.com/java-networking/inetaddress.html)

- [Java Networking: InetAddress](#java-networking-inetaddress)
  - [Creating an InetAddress Instance](#creating-an-inetaddress-instance)
  - [Additional InetAddress Methods](#additional-inetaddress-methods)

The `InetAddress` is Java's representation of an IP address. Instances of this class are used together with UDP [DatagramSockets](http://tutorials.jenkov.com/java-networking/udp-datagram-sockets.html) and normal [Socket's](http://tutorials.jenkov.com/java-networking/sockets.html) and [ServerSocket's](http://tutorials.jenkov.com/java-networking/server-sockets.html).

## Creating an InetAddress Instance

`InetAddress` has no public contructor, so you must obtain instances via a set of **static methods**.

Here is how to get the `InetAddress` instance for a domain name:

    InetAddress address = InetAddress.getByName("jenkov.com");

And here is how to get the `InetAddress` matching a String representation of an IP address:

    InetAddress address = InetAddress.getByName("78.46.84.171");

And, here is how to obtain the IP address of the localhost (the computer the program is running on):

    InetAddress address = InetAddress.getLocalHost();

## Additional InetAddress Methods

The `InetAddress` class has a lot of additional methods you can use. For instance, you can obtain the IP address as a byte array by calling `getAddress()` etc. To learn more about these methods, it is easier to read the JavaDoc for the `InetAddress` class though.
