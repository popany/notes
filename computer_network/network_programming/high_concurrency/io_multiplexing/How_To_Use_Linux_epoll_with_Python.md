# [How To Use Linux epoll with Python](http://scotdoyle.com/python-epoll-howto.html)

- [How To Use Linux epoll with Python](#how-to-use-linux-epoll-with-python)
  - [Introduction](#introduction)
  - [Blocking Socket Programming Examples](#blocking-socket-programming-examples)
    - [Example 1](#example-1)
    - [Example 2](#example-2)
    - [Benefits of Asynchronous Sockets and Linux epoll](#benefits-of-asynchronous-sockets-and-linux-epoll)
  - [Asynchronous Socket Programming Examples with epoll](#asynchronous-socket-programming-examples-with-epoll)

## Introduction

As of version 2.6, [Python](http://www.python.org/) includes an [API](http://docs.python.org/3.0/library/select.html#epoll-objects) for accessing the Linux [epoll](http://linux.die.net/man/4/epoll) library. This article uses Python 3 examples to briefly demonstrate the API.

## Blocking Socket Programming Examples

### Example 1

is a simple Python server that listens on port 8080 for an HTTP request message, prints it to the console, and sends an HTTP response message back to the client.

The official [HOWTO](http://docs.python.org/3.0/howto/sockets.html) has a more detailed description of socket programming with Python.

    import socket
 
    EOL1 = b'\n\n'
    EOL2 = b'\n\r\n'
    response  = b'HTTP/1.0 200 OK\r\nDate: Mon, 1 Jan 1996 01:01:01 GMT\r\n'
    response += b'Content-Type: text/plain\r\nContent-Length: 13\r\n\r\n'
    response += b'Hello, world!'

    # Create the server socket.
    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Permits the bind() even if another program was recently listening on the same port. Otherwise this program could not run until a minute or two after the previous program using that port had finished.
    serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    # Bind the server socket to port 8080 of all available IPv4 addresses on this machine.
    serversocket.bind(('0.0.0.0', 8080))

    # Tell the server socket to start accepting incoming connections from clients.
    serversocket.listen(1)

    # The program will stop here until a connection is received. When this happens, the server socket will create a new socket on this machine that is used to talk to the client. This new socket is represented by the clientconnection object returned from the accept() call. The address object indicates the IP address and port number at the other end of the connection.
    connectiontoclient, address = serversocket.accept()
    
    # Assemble the data being transmitted by the client until a complete. HTTP request has been transmitted
    request = b''
    while EOL1 not in request and EOL2 not in request:
        request += connectiontoclient.recv(1024)

    # Print the request to the console, in order to verify correct operation.
    print(request.decode())

    # Send the response to the client.
    connectiontoclient.send(response)

    # Close the connection to the client as well as the listening server socket.
    connectiontoclient.close()
    serversocket.close()

### Example 2

adds a loop in line 15 to repeatedly processes client connections until interrupted by the user (e.g. with a keyboard interrupt). This illustrates more clearly that the server socket is never used to exchange data with the client. Rather, it accepts a connection from a client, and then creates a new socket on the server machine that is used to communicate with the client.

    import socket
 
    EOL1 = b'\n\n'
    EOL2 = b'\n\r\n'
    response  = b'HTTP/1.0 200 OK\r\nDate: Mon, 1 Jan 1996 01:01:01 GMT\r\n'
    response += b'Content-Type: text/plain\r\nContent-Length: 13\r\n\r\n'
    response += b'Hello, world!'
 
    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    serversocket.bind(('0.0.0.0', 8080))
    serversocket.listen(1)

    try:
        while True:
            connectiontoclient, address = serversocket.accept()
            request = b''
            while EOL1 not in request and EOL2 not in request:
                request += connectiontoclient.recv(1024)

            print('-'*40 + '\n' + request.decode()[:-2])
            connectiontoclient.send(response)
            connectiontoclient.close()
    finally:
        serversocket.close()

### Benefits of Asynchronous Sockets and Linux epoll

The sockets shown in Example 2 are called **blocking sockets**, because the Python program stops running until an event occurs. The `accept()` call in line 16 blocks until a connection has been received from a client. The `recv()` call in line 19 blocks until data has been received from the client (or until there is no more data to receive). The `send()` call in line 21 blocks until all of the data being returned to the client has been **queued by Linux** in preparation for transmission.

When a program uses blocking sockets it often **uses one thread (or even a dedicated process) to carry out the communication on each of those sockets**. The main program thread will contain the listening server socket which accepts incoming connections from clients. It will accept these connections one at a time, passing the newly created socket off to a separate thread which will then interact with the client. Because each of these threads only communicates with one client, any blockage does not prohibit other threads from carrying out their respective tasks.

The use of blocking sockets with multiple threads results in straightforward code, but comes with [a number of drawbacks](http://www.virtualdub.org/blog/pivot/entry.php?id=62). It can be difficult to ensure the threads cooperate appropriately when sharing resources. And this style of programming can be less efficient on computers with only one CPU.

[The C10K Problem](http://www.kegel.com/c10k.html) discusses some of the alternatives for handling multiple concurrent sockets, such as the use of **asynchronous sockets**. These sockets don't block until some event occurs. Instead, the program performs an action on an asynchronous socket and is **immediately notified** as to whether that action **succeeded or failed**. This information allows the program to decide how to proceed. Since asynchronous sockets are non-blocking, there is no need for multiple threads of execution. All work may be done in a single thread. This single-threaded approach comes with its own challenges, but can be a good choice for many programs. It can also be combined with the multi-threaded approach: asynchronous sockets using a single thread can be used for the networking component of a server, and threads can be used to access other blocking resources, e.g. databases.

Linux has a number of mechanisms for managing asynchronous sockets, three of which are exposed by the Python `select`, `poll` and `epoll` API's.  `epoll` and `poll` are better than `select` because the Python program does not have to inspect each socket for events of interest. Instead it can rely on the operating system to tell it which sockets may have these events. And `epoll` is better than `poll` because it does not require the operating system to inspect all sockets for events of interest each time it is queried by the Python program. Rather Linux tracks these events as they occur, and returns a list when queried by Python. [These graphs](http://lse.sourceforge.net/epoll/index.html) show `epoll`'s advantage when using thousands of concurrent socket connections.

## Asynchronous Socket Programming Examples with epoll










TODO epoll