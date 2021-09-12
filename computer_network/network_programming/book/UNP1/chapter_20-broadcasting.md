# Chapter 20. Broadcasting

- [Chapter 20. Broadcasting](#chapter-20-broadcasting)
  - [20.1 Introduction](#201-introduction)
    - [Figure 20.1. Different forms of addressing.](#figure-201-different-forms-of-addressing)
  - [20.2 Broadcast Addresses](#202-broadcast-addresses)
  - [20.3 Unicast versus Broadcast](#203-unicast-versus-broadcast)
    - [Figure 20.3. Unicast example of a UDP datagram.](#figure-203-unicast-example-of-a-udp-datagram)
    - [Figure 20.4. Example of a broadcast UDP datagram.](#figure-204-example-of-a-broadcast-udp-datagram)
  - [20.4 `dg_cli` Function Using Broadcasting](#204-dg_cli-function-using-broadcasting)
    - [Figure 20.5 `dg_cli` function that broadcasts.](#figure-205-dg_cli-function-that-broadcasts)
    - [Allocate room for server's address, set socket option](#allocate-room-for-servers-address-set-socket-option)
    - [Read line, send to socket, read all replies](#read-line-send-to-socket-read-all-replies)
    - [Print each received reply](#print-each-received-reply)
    - [Figure 20.5 `dg_cli` function that broadcasts.](#figure-205-dg_cli-function-that-broadcasts-1)
    - [IP Fragmentation and Broadcasts](#ip-fragmentation-and-broadcasts)
  - [20.5 Race Conditions](#205-race-conditions)

## 20.1 Introduction

### Figure 20.1. Different forms of addressing.

The important points in Figure 20.1 are:

- Multicasting support is optional in IPv4, but mandatory in IPv6.

- Broadcasting support is not provided in IPv6. Any IPv4 application that uses broadcasting must be recoded for IPv6 to use multicasting instead.

- Broadcasting and multicasting require datagram transport such as UDP or raw IP; they cannot work with TCP.

One use for broadcasting is to locate a server on the local subnet when the server is assumed to be on the local subnet but its unicast IP address is not known. This is sometimes called **resource discovery**. Another use is to minimize the network traffic on a LAN when there are multiple clients communicating with a single server. There are numerous examples of Internet applications that use broadcasting for this purpose. Some of these can also use multicasting.

## 20.2 Broadcast Addresses

If we denote an IPv4 address as {subnetid, hostid}, where subnetid represents the bits that are covered by the network mask (or the CIDR prefix) and hostid represents the bits that are not, then we have two types of broadcast addresses. We denote a field containing all one bits as –1.

1. Subnet-directed broadcast address: {subnetid, –1} - This addresses all the interfaces on the specified subnet. For example, if we have the subnet 192.168.42/24, then 192.168.42.255 would be the subnet-directed broadcast address for all interfaces on the 192.168.42/24 subnet.

2. Limited broadcast address: {–1, –1, –1} or 255.255.255.255 - Datagrams destined to this address must never be forwarded by a router.

## 20.3 Unicast versus Broadcast

### Figure 20.3. Unicast example of a UDP datagram.

The subnet address of the Ethernet is 192.168.42/24 with 24 bits in the network mask, leaving 8 bits for the host ID. The application on the left host calls sendto on a UDP socket, sending a datagram to 192.168.42.3, port 7433. The UDP layer prepends a UDP header and passes the UDP datagram to the IP layer. IP prepends an IPv4 header, determines the outgoing interface, and in the case of an Ethernet, ARP is invoked to map the destination IP address to the corresponding Ethernet address: 00:0a:95:79:bc:b4. The packet is then sent as an Ethernet frame with that 48-bit address as the destination Ethernet address. The frame type field of the Ethernet frame will be 0x0800, specifying an IPv4 packet. The frame type for an IPv6 packet is 0x86dd.

The Ethernet interface on the host in the middle sees the frame pass by and compares the destination Ethernet address to its own Ethernet address 00:04:ac:17:bf:38). Since they are not equal, the interface ignores the frame. With a unicast frame, there is no overhead whatsoever to this host. The interface ignores the frame.

The Ethernet interface on the host on the right also sees the frame pass by, and when it compares the destination Ethernet address with its own Ethernet address, they are equal. This interface reads in the entire frame, probably generates a hardware interrupt when the frame is complete, and the device driver reads the frame from the interface memory. Since the frame type is 0x0800, the packet is placed on the IP input queue.

When the IP layer processes the packet, it first compares the destination IP address (192.168.42.3) with all of its own IP addresses. (Recall that a host can be multihomed. Also recall our discussion of the **strong end system model** and the **weak end system model** in Section 8.8.) Since the destination address is one of the host's own IP addresses, the packet is accepted.

The IP layer then looks at the protocol field in the IPv4 header, and its value will be 17 for UDP. The IP datagram is passed to UDP.

The UDP layer looks at the destination port (and possibly the source port, too, if the UDP socket is connected), and in our example, places the datagram onto the appropriate socket **receive queue**. The process is awakened, if necessary, to read the newly received datagram.

The key point in this example is that a unicast IP datagram is received by only the one host specified by the destination IP address. No other hosts on the subnet are affected.

### Figure 20.4. Example of a broadcast UDP datagram.

When the host on the left sends the datagram, it notices that the destination IP address is the subnet-directed broadcast address and maps this into the Ethernet address of 48 one bits: ff:ff:ff:ff:ff:ff. This causes **every Ethernet interface on the subnet** to receive the frame. The two hosts on the right of this figure that are running IPv4 will both receive the frame. Since the Ethernet frame type is 0x0800, both hosts pass the packet to the IP layer. Since the destination IP address matches the broadcast address for each of the two hosts, and since the protocol field is 17 (UDP), both hosts pass the packet up to UDP.

The host on the right passes the UDP datagram to the application that has bound UDP port 520. Nothing special needs to be done by an application to receive a broadcast UDP datagram: It just creates a UDP socket and binds the application's **port number** to the socket. (We assume the IP address bound is `INADDR_ANY`, which is typical.)

On the host in the middle, no application has bound UDP port 520. The host's UDP code then discards the received datagram. This host **must not send an ICMP** "port unreachable," as doing so could generate a broadcast storm: a condition where lots of hosts on the subnet generate a response at about the same time, leading to the network being unusable for a period of time. In addition, it's not clear what the sending host would do with an ICMP error: What if some receivers report errors and others don't?

In this example, we also show the datagram that is output by the host on the left being delivered to itself. This is a property of broadcasts: By definition, a broadcast goes to every host on the subnet, which **includes the sender** (pp. 109–110 of TCPv2). We also assume that the sending application has bound the port that it is sending to (520), so it will receive a copy of each broadcast datagram it sends. (In general, however, there is no requirement that a process bind a UDP port to which it sends datagrams.)

This example shows the fundamental problem with broadcasting: Every IPv4 host on the subnet that is not participating in the application must completely process the broadcast UDP datagram all the way up the protocol stack, through and including the UDP layer, before discarding the datagram. (Recall our discussion following Figure 8.21.) Also, every non-IP host on the subnet (say a host running Novell's IPX) must also receive the entire frame at the datalink layer before discarding the frame (assuming the host does not support the frame type, which would be 0x0800 for an IPv4 datagram). For applications that generate IP datagrams at a high rate (audio or video, for example), this unnecessary processing can severely affect these other hosts on the subnet. We will see in the next chapter how multicasting gets around this problem to some extent.

## 20.4 `dg_cli` Function Using Broadcasting

Berkeley-derived implementations implement this sanity check. Solaris 2.5, on the other hand, accepts the datagram destined for the broadcast address even if we do not specify the socket option. The POSIX specification requires the `SO_BROADCAST` socket option to be set to send a broadcast packet.

### Figure 20.5 `dg_cli` function that broadcasts.

We modify our `dg_cli` function one more time, this time allowing it to broadcast to the standard UDP daytime server (Figure 2.18) and printing all replies. The only change we make to the main function (Figure 8.7) is to change the destination port number to 13.

  servaddr.sin_port = htons(13);

We first compile this modified main function with the unmodified dg_cli function from Figure 8.8 and run it on the host freebsd.

    freebsd % udpcli01 192.168.42.255
    hi
    sendto error: Permission denied

The command-line argument is the subnet-directed broadcast address for the secondary Ethernet. We type a line of input, the program calls `sendto`, and the error `EACCES` is returned. The reason we receive the error is that we are not allowed to send a datagram to a broadcast destination address unless we explicitly tell the kernel that we will be broadcasting. We do this by setting the `SO_BROADCAST` socket option (Section 7.5).

We now modify our `dg_cli` function as shown in Figure 20.5. This version sets the `SO_BROADCAST` socket option and prints all the replies received within five seconds.

### Allocate room for server's address, set socket option

11–13 `malloc` allocates room for the server's address to be returned by `recvfrom`. The `SO_BROADCAST` socket option is set and a signal handler is installed for `SIGALRM`.

### Read line, send to socket, read all replies

14–24 The next two steps, `fgets` and `sendto`, are similar to previous versions of this function. But since we are sending a broadcast datagram, we can receive multiple replies. We call recvfrom in a loop and print all the replies received within five seconds. After five seconds, `SIGALRM` is generated, our signal handler is called, and recvfrom returns the error `EINTR`.

### Print each received reply

25–29 For each reply received, we call sock_ntop_host, which in the case of IPv4 returns a string containing the dotted-decimal IP address of the server. This is printed along with the server's reply.

If we run the program specifying the subnet-directed broadcast address of 192.168.42.255, we see the following:

    freebsd % udpcli01 192.168.42.255
    hi
    from 192.168.42.2: Sat Aug 2 16:42:45 2003
    from 192.168.42.1: Sat Aug 2 14:42:45 2003
    from 192.168.42.3: Sat Aug 2 14:42:45 2003
    hello
    from 192.168.42.3: Sat Aug 2 14:42:57 2003
    from 192.168.42.2: Sat Aug 2 16:42:57 2003
    from 192.168.42.1: Sat Aug 2 14:42:57 2003

Each time we must type a line of input to generate the output UDP datagram. Each time we receive three replies, and this includes the sending host. As we said earlier, the destination of a broadcast datagram is all the hosts on the attached network, **including the sender**. Each **reply is unicast** because the source address of the request, which is used by each server as the **destination address of the reply, is a unicast address**.

### Figure 20.5 `dg_cli` function that broadcasts.

bcast/dgclibcast1.c

    #include      "unp.h"
    
    static void recvfrom_alarm(int);
    
    void
    dg_cli(FILE *fp, int sockfd, const SA *pservaddr, socklen_t servlen)
    {
        int     n;
        const int on = 1;
        char    sendline[MAXLINE], recvline[MAXLINE + 1];
        socklen_t len;
        struct sockaddr *preply_addr;
    
        preply_addr = Malloc(servlen);
    
        Setsockopt(sockfd, SOL_SOCKET, SO_BROADCAST, &on, sizeof(on));
    
        Signal(SIGALRM, recvfrom_alarm);
    
        while (Fgets(sendline, MAXLINE, fp) != NULL) {
    
            Sendto(sockfd, sendline, strlen(sendline), 0, pservaddr, servlen);
    
            alarm(5);
            for ( ; ; ) {
                len = servlen;
                n = recvfrom(sockfd, recvline, MAXLINE, 0, preply_addr, &len);
                if (n < 0) {
                    if (errno == EINTR)
                        break;      /* waited long enough for replies */
                    else
                        err_sys("recvfrom error");
                } else {
                    recvline[n] = 0; /* null terminate */
                    printf("from %s: %s",
                        Sock_ntop_host(preply_addr, len), recvline);
                }
            }
        }
        free(preply_addr);
    }
    
    static void
    recvfrom_alarm(int signo)
    {
        return;                     /* just interrupt the recvfrom() */
    }
    
### IP Fragmentation and Broadcasts

Berkeley-derived kernels do not allow a broadcast datagram to be fragmented. If the size of an IP datagram that is being sent to a broadcast address exceeds the outgoing interface MTU, `EMSGSIZE` is returned (pp. 233–234 of TCPv2). This is a policy decision that has existed since 4.2BSD. There is nothing that prevents a kernel from fragmenting a broadcast datagram, but the feeling is that broadcasting puts enough load on the network as it is, so there is no need to multiply this load by the number of fragments.

We can see this scenario with our program in Figure 20.5. We redirect standard input from a file containing a 2,000-byte line, which will require fragmentation on an Ethernet.

    freebsd % udpcli01 192.168.42.255 < 2000line
    sendto error: Message too long

AIX, FreeBSD, and MacOS implement this limitation. Linux, Solaris, and HP-UX fragment datagrams sent to a broadcast address. For portability, however, an application that needs to broadcast should determine the MTU of the outgoing interface using the SIOCGIFMTU ioctl, and then subtract the IP and transport header lengths to determine the maximum payload size. Alternately, it can pick a common MTU, like Ethernet's 1500, and use it as a constant.

## 20.5 Race Conditions












