# Chapter 8. Elementary UDP Sockets

- [Chapter 8. Elementary UDP Sockets](#chapter-8-elementary-udp-sockets)
  - [8.1 Introduction](#81-introduction)
  - [8.2 `recvfrom` and `sendto` Functions](#82-recvfrom-and-sendto-functions)
  - [8.3 UDP Echo Server: `main` Function](#83-udp-echo-server-main-function)
    - [Figure 8.3 UDP echo server.](#figure-83-udp-echo-server)
  - [8.4 UDP Echo Server: `dg_echo` Function](#84-udp-echo-server-dg_echo-function)
    - [Figure 8.4 `dg_echo` function: echo lines on a datagram socket.](#figure-84-dg_echo-function-echo-lines-on-a-datagram-socket)
  - [8.5 UDP Echo Client: `main` Function](#85-udp-echo-client-main-function)
    - [Figure 8.7 UDP echo client.](#figure-87-udp-echo-client)
  - [8.6 UDP Echo Client: `dg_cli` Function](#86-udp-echo-client-dg_cli-function)
    - [Figure 8.8 `dg_cli` function: client processing loop.](#figure-88-dg_cli-function-client-processing-loop)
    - [8.7 Lost Datagrams](#87-lost-datagrams)
    - [8.8 Verifying Received Response](#88-verifying-received-response)

## 8.1 Introduction

UDP is a connectionless, unreliable, datagram protocol, quite unlike the connection-oriented, reliable byte stream provided by TCP.

Some popular applications are built using UDP: DNS, NFS, and SNMP, for example.

## 8.2 `recvfrom` and `sendto` Functions

    #include <sys/socket.h>
 
    ssize_t recvfrom(int sockfd, void *buff, size_t nbytes, int flags, struct sockaddr *from, socklen_t *addrlen);
 
    ssize_t sendto(int sockfd, const void *buff, size_t nbytes, int flags, const struct sockaddr *to, socklen_t addrlen);

Writing a datagram of length 0 is acceptable. 

If the `from` argument to `recvfrom` is a null pointer, then the corresponding length argument (`addrlen`) must also be a null pointer, and this indicates that we are not interested in knowing the protocol address of who sent us data.

Both `recvfrom` and `sendto` can be used with TCP, although there is normally no reason to do so.

## 8.3 UDP Echo Server: `main` Function

### Figure 8.3 UDP echo server.

udpcliserv/udpserv01.c

    #include     "unp.h"

    int
    main(int argc, char **argv)
    {
        int     sockfd;
        struct sockaddr_in servaddr, cliaddr;

        sockfd = Socket(AF_INET, SOCK_DGRAM, 0);

        bzero(&servaddr, sizeof(servaddr));
        servaddr.sin_family = AF_INET;
        servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
        servaddr.sin_port = htons(SERV_PORT);

        Bind(sockfd, (SA *) &servaddr, sizeof(servaddr));

        dg_echo(sockfd, (SA *) &cliaddr, sizeof(cliaddr));
    }

We create a UDP socket by specifying the second argument to socket as `SOCK_DGRAM` (a datagram socket in the IPv4 protocol). As with the TCP server example, the IPv4 address for the `bind` is specified as `INADDR_ANY` and the server's well-known port is the constant `SERV_PORT` from the unp.h header.

## 8.4 UDP Echo Server: `dg_echo` Function

### Figure 8.4 `dg_echo` function: echo lines on a datagram socket.

lib/dg_echo.c

    #include     "unp.h"

    void
    dg_echo(int sockfd, SA *pcliaddr, socklen_t clilen)
    {
        int     n;
        socklen_t len;
        char    mesg[MAXLINE];

        for ( ; ; ) {
            len = clilen;
            n = Recvfrom(sockfd, mesg, MAXLINE, 0, pcliaddr, &len);

            Sendto(sockfd, mesg, n, 0, pcliaddr, len);
        }
    }

In general, most TCP servers are concurrent and most UDP servers are iterative.

There is implied queuing taking place in the UDP layer for this socket. Indeed, each UDP socket has a receive buffer and each datagram that arrives for this socket is placed in that socket receive buffer. When the process calls `recvfrom`, the next datagram from the buffer is returned to the process in a first-in, first-out (FIFO) order. This way, if multiple datagrams arrive for the socket before the process can read what's already queued for the socket, the arriving datagrams are just added to the socket receive buffer. But, this buffer has a limited size. We discussed this size and how to increase it with the `SO_RCVBUF` socket option in Section 7.5.

There is only one server process and it has a single socket on which it receives all arriving datagrams and sends all responses. That socket has a receive buffer into which all arriving datagrams are placed.

## 8.5 UDP Echo Client: `main` Function

### Figure 8.7 UDP echo client.

udpcliserv/udpcli01.c

    #include     "unp.h"

    int
    main(int argc, char **argv)
    {
        int     sockfd;
        struct sockaddr_in servaddr;

        if(argc != 2)
        err_quit("usage: udpcli <IPaddress>");

        bzero(&servaddr, sizeof(servaddr));
        servaddr.sin_family = AF_INET;
        servaddr.sin_port = htons(SERV_PORT);
        Inet_pton(AF_INET, argv[1], &servaddr.sin_addr);

        sockfd = Socket(AF_INET, SOCK_DGRAM, 0);

        dg_cli(stdin, sockfd, (SA *) &servaddr, sizeof(servaddr));

        exit(0);
    }

## 8.6 UDP Echo Client: `dg_cli` Function

### Figure 8.8 `dg_cli` function: client processing loop.

lib/dg_cli.c

    #include     "unp.h"

    void
    dg_cli(FILE *fp, int sockfd, const SA *pservaddr, socklen_t servlen)
    {
        int     n;
        char    sendline[MAXLINE], recvline[MAXLINE + 1];

        while (Fgets(sendline, MAXLINE, fp) != NULL) {

            Sendto(sockfd, sendline, strlen(sendline), 0, pservaddr, servlen);

            n = Recvfrom(sockfd, recvline, MAXLINE, 0, NULL, NULL);

            recvline[n] = 0;        /* null terminate */
            Fputs(recvline, stdout);
        }
    }

Our client has not asked the kernel to assign an ephemeral port to its socket. (With a TCP client, we said the call to `connect` is where this takes place.) With a UDP socket, the first time the process calls `sendto`, if the socket has not yet had a local port bound to it, that is when an ephemeral port is chosen by the kernel for the socket. As with TCP, the client can call bind explicitly, but this is rarely done.

Notice that the call to `recvfrom` specifies a null pointer as the fifth and sixth arguments. This tells the kernel that we are not interested in knowing who sent the reply. There is a risk that any process, on either the same host or some other host, can send a datagram to the client's IP address and port, and that datagram will be read by the client, who will think it is the server's reply. We will address this in Section 8.8.

### 8.7 Lost Datagrams

Our UDP client/server example is not reliable. If a client datagram is lost (say it is discarded by some router between the client and server), the client will block forever in its call to `recvfrom` in the function `dg_cli`, waiting for a server reply that will never arrive. Similarly, if the client datagram arrives at the server but the server's reply is lost, the client will again block forever in its call to `recvfrom`. A typical way to prevent this is to place a timeout on the client's call to recvfrom. We will discuss this in Section 14.2.

Just placing a timeout on the recvfrom is not the entire solution. For example, if we do time out, we cannot tell whether our datagram never made it to the server, or if the server's reply never made it back. If the client's request was something like "transfer a certain amount of money from account A to account B" (instead of our simple echo server), it would make a big difference as to whether the request was lost or the reply was lost. We will talk more about adding reliability to a UDP client/server in Section 22.5.

### 8.8 Verifying Received Response






