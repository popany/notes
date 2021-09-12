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
    - [Compare returned address](#compare-returned-address)
    - [Figure 8.9 Version of dg_cli that verifies returned socket address.](#figure-89-version-of-dg_cli-that-verifies-returned-socket-address)
  - [8.9 Server Not Running](#89-server-not-running)
    - [Figure 8.10 tcpdump output when server process not started on server host.](#figure-810-tcpdump-output-when-server-process-not-started-on-server-host)
  - [8.10 Summary of UDP Example](#810-summary-of-udp-example)
    - [Figure 8.11. Summary of UDP client/server from client's perspective.](#figure-811-summary-of-udp-clientserver-from-clients-perspective)
    - [Figure 8.12. Summary of UDP client/server from server's perspective.](#figure-812-summary-of-udp-clientserver-from-servers-perspective)
    - [Figure 8.13. Information available to server from arriving IP datagram.](#figure-813-information-available-to-server-from-arriving-ip-datagram)
  - [8.11 `connect` Function with UDP](#811-connect-function-with-udp)
    - [Figure 8.14. TCP and UDP sockets: can a destination protocol address be specified?](#figure-814-tcp-and-udp-sockets-can-a-destination-protocol-address-be-specified)
    - [Figure 8.15. Connected UDP socket.](#figure-815-connected-udp-socket)
    - [Figure 8.16. Example of DNS clients and servers and the connect function.](#figure-816-example-of-dns-clients-and-servers-and-the-connect-function)
    - [Calling `connect` Multiple Times for a UDP Socket](#calling-connect-multiple-times-for-a-udp-socket)
    - [Performance](#performance)
  - [8.12 dg_cli Function (Revisited)](#812-dg_cli-function-revisited)
    - [Figure 8.17 dg_cli function that calls connect.](#figure-817-dg_cli-function-that-calls-connect)
    - [Figure 8.18 tcpdump output when running Figure 8.17.](#figure-818-tcpdump-output-when-running-figure-817)
  - [8.13 Lack of Flow Control with UDP](#813-lack-of-flow-control-with-udp)
    - [UDP Socket Receive Buffer](#udp-socket-receive-buffer)
  - [8.14 Determining Outgoing Interface with UDP](#814-determining-outgoing-interface-with-udp)
    - [Figure 8.23 UDP program that uses `connect` to determine outgoing interface.](#figure-823-udp-program-that-uses-connect-to-determine-outgoing-interface)
  - [8.15 TCP and UDP Echo Server Using `select`](#815-tcp-and-udp-echo-server-using-select)
  - [8.16 Summary](#816-summary)

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

## 8.8 Verifying Received Response

At the end of Section 8.6, we mentioned that any process that knows the client's ephemeral port number could send datagrams to our client, and these would be intermixed with the normal server replies. What we can do is change the call to `recvfrom` in Figure 8.8 to return the IP address and port of who sent the reply and ignore any received datagrams that are not from the server to whom we sent the datagram. There are a few pitfalls with this, however, as we will see.

### Compare returned address

In the call to `recvfrom`, we tell the kernel to return the address of the sender of the datagram. We first compare the length returned by `recvfrom` in the value-result argument and then compare the socket address structures themselves using `memcmp`.

Section 3.2 says that even if the socket address structure contains a length field, we need never set it or examine it. However, `memcmp` compares every byte of data in the two socket address structures, and the length field is set in the socket address structure that the kernel returns; so in this case we must set it when constructing the sockaddr. If we don't, the `memcmp` will compare a 0 (since we didn't set it) with a 16 (assuming `sockaddr_in`) and will not match.

### Figure 8.9 Version of dg_cli that verifies returned socket address.

udpcliserv/dgcliaddr.c

    #include     "unp.h"

    void
    dg_cli(FILE *fp, int sockfd, const SA *pservaddr, socklen_t servlen)
    {
        int     n;
        char    sendline[MAXLINE], recvline[MAXLINE + 1];
        socklen_t len;
        struct sockaddr *preply_addr;

        preply_addr = Malloc(servlen);

        while (Fgets(sendline, MAXLINE, fp) != NULL) {

            Sendto(sockfd, sendline, strlen(sendline), 0, pservaddr, servlen);

            len = servlen;
            n = Recvfrom(sockfd, recvline, MAXLINE, 0, preply_addr, &len);
            if (len != servlen || memcmp(pservaddr, preply_addr, len) != 0) {
                printf("reply from %s (ignored)\n", Sock_ntop(preply_addr, len));
                continue;
            }

            recvline[n] = 0;      /* null terminate */
            Fputs(recvline, stdout);
        }
    }

This new version of our client works fine if the server is on a host with just a single IP address. But this program can fail if the server is multihomed. We run this program to our host freebsd4, which has two interfaces and two IP addresses.

    macosx % host freebsd4
    freebsd4.unpbook.com has address 172.24.37.94
    freebsd4.unpbook.com has address 135.197.17.100
    macosx % udpcli02 135.197.17.100
    hello
    reply from 172.24.37.94:7 (ignored)
    goodbye
    reply from 172.24.37.94:7 (ignored)

We specified the IP address that does not share the same subnet as the client.

This is normally allowed. Most IP implementations accept an arriving IP datagram that is destined for any of the host's IP addresses, regardless of the interface on which the datagram arrives (pp. 217–219 of TCPv2). RFC 1122 [Braden 1989] calls this the **weak end system model**. If a system implemented what this RFC calls the strong end system model, it would accept an arriving datagram only if that datagram arrived on the interface to which it was addressed.

The IP address returned by recvfrom (the source IP address of the UDP datagram) is not the IP address to which we sent the datagram. When the server sends its reply, the destination IP address is 172.24.37.78. The routing function within the kernel on freebsd4 chooses 172.24.37.94 as the outgoing interface. Since the server has not bound an IP address to its socket (the server has bound the wildcard address to its socket, which is something we can verify by running netstat on freebsd), the kernel chooses the source address for the IP datagram. It is chosen to be the primary IP address of the outgoing interface (pp. 232–233 of TCPv2). Also, since it is the primary IP address of the interface, if we send our datagram to a nonprimary IP address of the interface (i.e., an alias), this will also cause our test in Figure 8.9 to fail.

One solution is for the client to verify the responding host's domain name instead of its IP address by looking up the server's name in the DNS (Chapter 11), given the IP address returned by `recvfrom`. Another solution is for the UDP server to create one socket for every IP address that is configured on the host, bind that IP address to the socket, use select across all these sockets (waiting for any one to become readable), and then reply from the socket that is readable. Since the socket used for the reply was bound to the IP address that was the destination address of the client's request (or the datagram would not have been delivered to the socket), this guaranteed that the source address of the reply was the same as the destination address of the request. We will show an example of this in Section 22.6.

On a multihomed Solaris system, the source IP address for the server's reply is the destination IP address of the client's request. The scenario described in this section is for Berkeley-derived implementations that choose the source IP address based on the outgoing interface.

## 8.9 Server Not Running

### Figure 8.10 tcpdump output when server process not started on server host.

    0.0                    arp who-has freebsd4 tell macosx
    0.003576 ( 0.0036)     arp reply freebsd4 is-at 0:40:5:42:d6:de

    0.003601 ( 0.0000)     macosx.51139 > freebsd4.9877: udp 13
    0.009781 ( 0.0062)     freebsd4 > macosx: icmp: freebsd4 udp port 9877 unreachable

First we notice that an ARP request and reply are needed before the client host can send the UDP datagram to the server host. (We left this exchange in the output to reiterate the potential for an ARP request-reply before an IP datagram can be sent to another host or router on the local network.)

In line 3, we see the client datagram sent but the server host responds in line 4 with an ICMP "port unreachable." (The length of 13 accounts for the 12 characters and the newline.) This ICMP error, however, is not returned to the client process, for reasons that we will describe shortly. Instead, the client blocks forever in the call to recvfrom in Figure 8.8. We also note that ICMPv6 has a "port unreachable" error, similar to ICMPv4 (Figures A.15 and A.16), so the results described here are similar for IPv6.

We call this ICMP error an **asynchronous error**. The error was caused by `sendto`, but `sendto` returned successfully. Recall from Section 2.11 that a successful return from a UDP output operation only means there was room for the resulting IP datagram on the interface output queue. The ICMP error is not returned until later (4 ms later in Figure 8.10), which is why it is called asynchronous.

The basic rule is that an asynchronous error is not returned for a UDP socket unless the socket has been connected. We will describe how to call `connect` for a UDP socket in Section 8.11. Why this design decision was made when sockets were first implemented is rarely understood. (The implementation implications are discussed on pp. 748–749 of TCPv2.)

Consider a UDP client that sends three datagrams in a row to three different servers (i.e., three different IP addresses) on a single UDP socket. The client then enters a loop that calls `recvfrom` to read the replies. Two of the datagrams are correctly delivered (that is, the server was running on two of the three hosts) but the third host was not running the server. This third host responds with an ICMP port unreachable. This ICMP error message contains the IP header and UDP header of the datagram that caused the error. (ICMPv4 and ICMPv6 error messages always contain the IP header and all of the UDP header or part of the TCP header to allow the receiver of the ICMP error to determine which socket caused the error. We will show this in Figures 28.21 and 28.22.) The client that sent the three datagrams needs to know the destination of the datagram that caused the error to distinguish which of the three datagrams caused the error. But how can the kernel return this information to the process? The only piece of information that `recvfrom` can return is an `errno` value; `recvfrom` has no way of returning the destination IP address and destination UDP port number of the datagram in error. The decision was made, therefore, to return these asynchronous errors to the process only if the process connected the UDP socket to exactly one peer.

Linux returns most ICMP "destination unreachable" errors even for unconnected sockets, as long as the `SO_BSDCOMPAT` socket option is not enabled. All the ICMP "destination unreachable" errors from Figure A.15 are returned, except codes 0, 1, 4, 5, 11, and 12.

We return to this problem of asynchronous errors with UDP sockets in Section 28.7 and show an easy way to obtain these errors on unconnected sockets using a daemon of our own.

## 8.10 Summary of UDP Example

### Figure 8.11. Summary of UDP client/server from client's perspective.

The client must specify the server's IP address and port number for the call to `sendto`. Normally, the client's IP address and port are chosen automatically by the kernel, although we mentioned that the client can call `bind` if it so chooses. If these two values for the client are chosen by the kernel, we also mentioned that the client's **ephemeral port is chosen once**, on the first `sendto`, and then it never changes. The client's **IP address, however, can change for every UDP datagram** that the client sends, assuming the client does not bind a specific IP address to the socket. The reason is shown in Figure 8.11: If the client host is multihomed, the client could alternate between two destinations, one going out the datalink on the left, and the other going out the datalink on the right. In this worst-case scenario, the client's IP address, as chosen by the kernel based on the outgoing datalink, would change for every datagram.

What happens if the client binds an IP address to its socket, but the kernel decides that an outgoing datagram must be sent out some other datalink? In this case the IP datagram will contain a source IP address that is **different from the IP address of the outgoing datalink** (see Exercise 8.6).

### Figure 8.12. Summary of UDP client/server from server's perspective.

There are at least four pieces of information that a server might want to know from an arriving IP datagram: the source IP address, destination IP address, source port number, and destination port number. Figure 8.13 shows the function calls that return this information for a TCP server and a UDP server.

### Figure 8.13. Information available to server from arriving IP datagram.

|From client's IP datagram|TCP server|UDP server|
|-|-|-|
Source IP address|accept|recvfrom
Source port number|accept|recvfrom
Destination IP address|getsockname|recvmsg
Destination port number|getsockname|getsockname
|

A TCP server always has easy access to all four pieces of information for a connected socket, and these four values remain constant for the lifetime of a connection. With a UDP socket, however, the destination IP address can only be obtained by setting the `IP_RECVDSTADDR` socket option for IPv4 or the `IPV6_PKTINFO` socket option for IPv6 and then calling `recvmsg` instead of `recvfrom`. Since UDP is connectionless, the destination IP address can change for each datagram that is sent to the server. A UDP server can also receive datagrams destined for one of the host's broadcast addresses or for a multicast address, as we will discuss in Chapters 20 and 21. We will show how to determine the destination address of a UDP datagram in Section 22.2, after we cover the recvmsg function.

## 8.11 `connect` Function with UDP

We mentioned at the end of Section 8.9 that an asynchronous error is not returned on a UDP socket unless the socket has been connected. Indeed, we are able to call `connect` (Section 4.3) for a UDP socket. But this does not result in anything like a TCP connection: There is no three-way handshake. Instead, the kernel just **checks for any immediate errors** (e.g., an obviously unreachable destination), **records the IP address and port number** of the peer (from the socket address structure passed to `connect`), and returns immediately to the calling process.

With this capability, we must now distinguish between

- An unconnected UDP socket, the default when we create a UDP socket

- A connected UDP socket, the result of calling `connect` on a UDP socket

With a connected UDP socket, three things change, compared to the default unconnected UDP socket:

1. We can no longer specify the destination IP address and port for an output operation. That is, we do not use `sendto`, but `write` or `send` instead. Anything written to a connected UDP socket is automatically sent to the protocol address (e.g., IP address and port) specified by `connect`.

   Similar to TCP, we can call `sendto` for a connected UDP socket, but we cannot specify a destination address. The fifth argument to `sendto` (the pointer to the socket address structure) must be a null pointer, and the sixth argument (the size of the socket address structure) should be 0. The POSIX specification states that when the fifth argument is a null pointer, the sixth argument is ignored.

2. We do not need to use `recvfrom` to learn the sender of a datagram, but `read`, `recv`, or `recvmsg` instead. The only datagrams returned by the kernel for an input operation on a connected UDP socket are those arriving from the protocol address specified in `connect`. Datagrams destined to the connected UDP socket's local protocol address (e.g., IP address and port) but arriving from a protocol address other than the one to which the socket was connected are not passed to the connected socket. This limits a connected UDP socket to exchanging datagrams with one and only one peer.

   Technically, a connected UDP socket exchanges datagrams with only one IP address, because it is possible to connect to a multicast or broadcast address.

3. Asynchronous errors are returned to the process for connected UDP sockets.

   The corollary, as we previously described, is that unconnected UDP sockets do not receive asynchronous errors.

### Figure 8.14. TCP and UDP sockets: can a destination protocol address be specified?

|Type of socket|write or send|sendto that does not specify a destination|sendto that specifies a destination|
|-|-|-|-|
TCP socket|OK|OK|EISCONN
UDP socket, connected|OK|OK|EISCONN
UDP socket, unconnected|EDESTADDRREQ|EDESTADDRREQ|OK
|

The POSIX specification states that an output operation that does not specify a destination address on an unconnected UDP socket should return `ENOTCONN`, not `EDESTADDRREQ`.

### Figure 8.15. Connected UDP socket.

The application calls `connect`, specifying the IP address and port number of its peer. It then uses `read` and `write` to exchange data with the peer.

Datagrams arriving from any other IP address or port (which we show as "???" in Figure 8.15) are not passed to the connected socket because either the source IP address or source UDP port does not match the protocol address to which the socket is connected. These datagrams could be delivered to some other UDP socket on the host. If there is no other matching socket for the arriving datagram, UDP will discard it and generate an ICMP "port unreachable" error.

In summary, we can say that a UDP client or server can call `connect` only if that process uses the UDP socket to communicate with exactly one peer. Normally, it is a UDP client that calls `connect`, but there are applications in which the UDP server communicates with a single client for a long duration (e.g., TFTP); in this case, both the client and server can call `connect`.

### Figure 8.16. Example of DNS clients and servers and the connect function.

A DNS client can be configured to use one or more servers, normally by listing the IP addresses of the servers in the file `/etc/resolv.conf`. If a single server is listed (the leftmost box in the figure), the client can call `connect`, but if multiple servers are listed (the second box from the right in the figure), the client cannot call `connect`. Also, a DNS server normally handles any client request, so the servers cannot call `connect`.

### Calling `connect` Multiple Times for a UDP Socket

A process with a connected UDP socket can call `connect` again for that socket for one of two reasons:

- To specify a new IP address and port

- To unconnect the socket

The first case, specifying a new peer for a connected UDP socket, differs from the use of connect with a TCP socket: connect can be called only one time for a TCP socket.

To unconnect a UDP socket, we call `connect` but set the family member of the socket address structure (`sin_family` for IPv4 or `sin6_family` for IPv6) to `AF_UNSPEC`. This might return an error of `EAFNOSUPPORT` (p. 736 of TCPv2), but that is acceptable. It is the process of calling connect on an already connected UDP socket that causes the socket to become unconnected (pp. 787–788 of TCPv2).

### Performance

When an application calls `sendto` on an unconnected UDP socket, Berkeley-derived kernels temporarily connect the socket, send the datagram, and then unconnect the socket (pp. 762–763 of TCPv2). Calling `sendto` for two datagrams on an unconnected UDP socket then involves the following six steps by the kernel:

- Connect the socket

- Output the first datagram

- Unconnect the socket

- Connect the socket

- Output the second datagram

- Unconnect the socket

Another consideration is the number of searches of the routing table. The first temporary connect searches the routing table for the destination IP address and saves (caches) that information. The second temporary connect notices that the destination address equals the destination of the cached routing table information (we are assuming two sendtos to the same destination) and we do not need to search the routing table again (pp. 737–738 of TCPv2).


When the application knows it will be sending multiple datagrams to the same peer, it is more efficient to connect the socket explicitly. Calling connect and then calling write two times involves the following steps by the kernel:

- Connect the socket

- Output first datagram

- Output second datagram

In this case, the kernel copies only the socket address structure containing the destination IP address and port one time, versus two times when sendto is called twice. [Partridge and Pink 1993] note that the temporary connecting of an unconnected UDP socket accounts for nearly one-third of the cost of each UDP transmission.

## 8.12 dg_cli Function (Revisited)

### Figure 8.17 dg_cli function that calls connect.

udpcliserv/dgcliconnect.c

    #include     "unp.h"

    void
    dg_cli(FILE *fp, int sockfd, const SA *pservaddr, socklen_t servlen)
    {
        int     n;
        char    sendline[MAXLINE], recvline[MAXLINE + 1];

        Connect(sockfd, (SA *) pservaddr, servlen);

        while (Fgets(sendline, MAXLINE, fp) != NULL) {

            Write(sockfd, sendline, strlen(sendline));

            n = Read(sockfd, recvline, MAXLINE);

            recvline[n] = 0;        /* null terminate */
            Fputs(recvline, stdout);
        }
    }

The changes are the new call to `connect` and replacing the calls to `sendto` and `recvfrom` with calls to `write` and `read`. This function is still protocol-independent since it doesn't look inside the socket address structure that is passed to `connect`. Our client main function, Figure 8.7, remains the same.

If we run this program on the host macosx, specifying the IP address of the host freebsd4 (which is not running our server on port 9877), we have the following output:

    macosx % udpcli04 172.24.37.94
    hello, world
    read error: Connection refused

The first point we notice is that we do not receive the error when we start the client process. The error occurs only after we send the first datagram to the server. It is sending this datagram that elicits the ICMP error from the server host. But when a TCP client calls `connect`, specifying a server host that is not running the server process, `connect` returns the error because the call to `connect` causes the TCP three-way handshake to happen, and the first packet of that handshake elicits an RST from the server TCP (Section 4.3).

### Figure 8.18 tcpdump output when running Figure 8.17.

    macosx % tcpdump
    1  0.0                    macosx.51139 > freebsd4.9877: udp 13
    2  0.006180 ( 0.0062)     freebsd4 > macosx: icmp: freebsd4 udp port 9877 unreachable

We also see in Figure A.15 that this ICMP error is mapped by the kernel into the error `ECONNREFUSED`, which corresponds to the message string output by our `err_sys` function: "Connection refused."

## 8.13 Lack of Flow Control with UDP

### UDP Socket Receive Buffer

## 8.14 Determining Outgoing Interface with UDP

A connected UDP socket can also be used to determine the outgoing interface that will be used to a particular destination. This is because of a side effect of the connect function when applied to a UDP socket: The kernel chooses the local IP address (assuming the process has not already called bind to explicitly assign this). This local IP address is chosen by searching the routing table for the destination IP address, and then using the primary IP address for the resulting interface.

### Figure 8.23 UDP program that uses `connect` to determine outgoing interface.

udpcliserv/udpcli09.c

    #include     "unp.h"

    int
    main(int argc, char **argv)
    {
        int     sockfd;
        socklen_t len;
        struct sockaddr_in cliaddr, servaddr;

        if (argc != 2)
            err_quit("usage: udpcli <IPaddress>");

        sockfd = Socket(AF_INET, SOCK_DGRAM, 0);

        bzero(&servaddr, sizeof(servaddr));
        servaddr.sin_family = AF_INET;
        servaddr.sin_port = htons(SERV_PORT);
        Inet_pton(AF_INET, argv[1], &servaddr.sin_addr);

        Connect(sockfd, (SA *) &servaddr, sizeof(servaddr));

        len = sizeof(cliaddr);
        Getsockname(sockfd, (SA *) &cliaddr, &len);
        printf("local address %s\n", Sock_ntop((SA *) &cliaddr, len));

        exit(0);
    }

If we run the program on the multihomed host freebsd, we have the following output:

    freebsd % udpcli09 206.168.112.96
    local address 12.106.32.254:52329

    freebsd % udpcli09 192.168.42.2
    local address 192.168.42.1:52330

    freebsd % udpcli09 127.0.0.1
    local address 127.0.0.1:52331

The first time we run the program, the command-line argument is an IP address that follows the default route. The kernel assigns the local IP address to the primary address of the interface to which the default route points. The second time, the argument is the IP address of a system connected to a second Ethernet interface, so the kernel assigns the local IP address to the primary address of this second interface. Calling connect on a UDP socket does not send anything to that host; it is entirely a local operation that saves the peer's IP address and port. We also see that calling connect on an unbound UDP socket also assigns an ephemeral port to the socket.

## 8.15 TCP and UDP Echo Server Using `select`

## 8.16 Summary

Converting our echo client/server to use UDP instead of TCP was simple. But lots of features provided by TCP are missing: detecting lost packets and retransmitting, verifying responses as being from the correct peer, and the like. We will return to this topic in Section 22.5 and see what it takes to add some reliability to a UDP application.

UDP sockets can generate asynchronous errors, that is, errors that are reported some time after a packet is sent. TCP sockets always report these errors to the application, but with UDP, the socket must be connected to receive these errors.

UDP has no flow control, and this is easy to demonstrate. Normally, this is not a problem, because many UDP applications are built using a request-reply model, and not for transferring bulk data.

There are still more points to consider when writing UDP applications, but we will save these until Chapter 22, after covering the interface functions, broadcasting, and multicasting.
 








