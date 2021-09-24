# Chapter 21. Multicasting

- [Chapter 21. Multicasting](#chapter-21-multicasting)
  - [21.1 Introduction](#211-introduction)
  - [21.2 Multicast Addresses](#212-multicast-addresses)
    - [IPv4 Class D Addresses](#ipv4-class-d-addresses)
    - [IPv6 Multicast Addresses](#ipv6-multicast-addresses)
    - [Scope of Multicast Addresses](#scope-of-multicast-addresses)
    - [Multicast Sessions](#multicast-sessions)
  - [21.3 Multicasting versus Broadcasting on a LAN](#213-multicasting-versus-broadcasting-on-a-lan)
  - [21.4 Multicasting on a WAN](#214-multicasting-on-a-wan)
  - [21.5 Source-Specific Multicast](#215-source-specific-multicast)
  - [21.6 Multicast Socket Options](#216-multicast-socket-options)
  - [21.7 `mcast_join` and Related Functions](#217-mcast_join-and-related-functions)
    - [`mcast_join` Function](#mcast_join-function)
    - [`mcast_set_loop` Function](#mcast_set_loop-function)
  - [21.8 `dg_cli` Function Using Multicasting](#218-dg_cli-function-using-multicasting)
    - [IP Fragmentation and Multicasts](#ip-fragmentation-and-multicasts)
  - [21.9 Receiving IP Multicast Infrastructure Session Announcements](#219-receiving-ip-multicast-infrastructure-session-announcements)
    - [Figure 21.14 `main` program to receive SAP/SDP announcements](#figure-2114-main-program-to-receive-sapsdp-announcements)
    - [Figure 21.15 Loop that receives and prints SAP/SDP announcements](#figure-2115-loop-that-receives-and-prints-sapsdp-announcements)
  - [21.10 Sending and Receiving](#2110-sending-and-receiving)
    - [Figure 21.17 Create sockets, `fork`, and start sender and receiver](#figure-2117-create-sockets-fork-and-start-sender-and-receiver)
    - [Figure 21.18 Send a multicast datagram every five seconds](#figure-2118-send-a-multicast-datagram-every-five-seconds)
    - [Figure 21.19 Receive all multicast datagrams for a group we have joined](#figure-2119-receive-all-multicast-datagrams-for-a-group-we-have-joined)
  - [21.11 Simple Network Time Protocol (SNTP)](#2111-simple-network-time-protocol-sntp)
    - [Figure 21.20 ntp.h header: NTP packet format and definitions](#figure-2120-ntph-header-ntp-packet-format-and-definitions)
    - [Figure 21.21 `main` function](#figure-2121-main-function)
    - [Figure 21.22 `sntp_proc` function: processes the NTP packet](#figure-2122-sntp_proc-function-processes-the-ntp-packet)
  - [21.12 Summary](#2112-summary)

## 21.1 Introduction

As shown in Figure 20.1, a unicast address identifies a single IP interface, a broadcast address identifies all IP interfaces on the subnet, and a **multicast address identifies a set of IP interfaces**. Unicasting and broadcasting are the extremes of the addressing spectrum (one or all) and the intent of multicasting is to allow addressing something in between. A multicast datagram should be received only by those interfaces interested in the datagram, that is, by the interfaces on the hosts running applications wishing to participate in the multicast group. Also, broadcasting is normally limited to a LAN, whereas multicasting can be used on a LAN or across a WAN. Indeed, applications multicast across a subset of the Internet on a daily basis.

The additions to the sockets API to support multicasting are simple; they comprise nine socket options: three that affect the sending of UDP datagrams to a multicast address and six that affect the host's reception of multicast datagrams.
 
## 21.2 Multicast Addresses

When describing multicast addresses, we must distinguish between IPv4 and IPv6.

### IPv4 Class D Addresses

Class D addresses, in the range 224.0.0.0 through 239.255.255.255, are the multicast addresses in IPv4 (Figure A.3). The low-order 28 bits of a class D address form the **multicast group ID** and the 32-bit address is called the **group address**.

Figure 21.1 shows how IP multicast addresses are mapped into Ethernet multicast addresses. This mapping for IPv4 multicast addresses is described in RFC 1112 [Deering 1989] for Ethernets, in RFC 1390 [Katz 1993] for FDDI networks, and in RFC 1469 [Pusateri 1993] for token-ring networks. We also show the mapping for IPv6 multicast addresses to allow easy comparison of the resulting Ethernet addresses.

Considering just the IPv4 mapping, the high-order 24 bits of the Ethernet address are always 01:00:5e. The next bit is always 0, and the low-order 23 bits are copied from the low-order 23 bits of the multicast group address. The high-order 5 bits of the group address are ignored in the mapping. This means that 32 multicast addresses map to a single Ethernet address: The mapping is not one-to-one.

The low-order 2 bits of the first byte of the Ethernet address identify the address as a universally administered group address. Universally administered means the high-order 24 bits have been assigned by the IEEE and group addresses are recognized and handled specially by receiving interfaces.

There are a few special IPv4 multicast addresses:

- 224.0.0.1 is the all-hosts group. All multicast-capable nodes (hosts, routers, printers, etc.) on a subnet must join this group on all multicast-capable interfaces. (We will talk about what it means to join a multicast group shortly.)

- 224.0.0.2 is the all-routers group. All multicast-capable routers on a subnet must join this group on all multicast-capable interfaces.

The range 224.0.0.0 through 224.0.0.255 (which we can also write as 224.0.0.0/24) is called **link local**. These addresses are reserved for low-level topology discovery or maintenance protocols, and datagrams destined to any of these addresses are **never forwarded by a multicast router**. We will say more about the scope of various IPv4 multicast addresses after looking at IPv6 multicast addresses.

### IPv6 Multicast Addresses

### Scope of Multicast Addresses

### Multicast Sessions

Especially in the case of streaming multimedia, the combination of an IP multicast address (either IPv4 or IPv6) and a transport-layer port (typically UDP) is referred to as a session. For example, an audio/video teleconference may comprise two sessions; one for audio and one for video. These sessions almost always use different ports and sometimes also use different groups for flexibility in choice when receiving. For example, one client may choose to receive only the audio session, and one client may choose to receive both the audio and the video session. If the sessions used the same group address, this choice would not be possible.

## 21.3 Multicasting versus Broadcasting on a LAN

The receiving application on the rightmost host starts and creates a UDP socket, binds port 123 to the socket, and then joins the multicast group 224.0.1.1. We will see shortly that this "join" operation is done by calling `setsockopt`. When this happens, the IPv4 layer saves the information internally and then **tells the appropriate datalink** to receive Ethernet frames destined to 01:00:5e:00:01:01 (Section 12.11 of TCPv2). This is the Ethernet address corresponding to the multicast address that the application has just joined using the mapping we showed in Figure 21.1.

The next step is for the sending application on the leftmost host to create a UDP socket and send a datagram to 224.0.1.1, port 123. **Nothing special is required** to send a multicast datagram: The application does not have to join the multicast group. The sending host converts the IP address into the corresponding Ethernet destination address and the frame is sent. Notice that the frame contains both the destination Ethernet address (which is examined by the interfaces) and the destination IP address (which is examined by the IP layers).

We assume that the host in the middle is not IPv4 multicast-capable (since support for IPv4 multicasting is optional). This host ignores the frame completely because: (i) the destination Ethernet address does not match the address of the interface; (ii) the destination Ethernet address is not the Ethernet broadcast address; and (iii) the interface has not been told to receive any group addresses (those with the low-order bit of the high-order byte set to 1, as in Figure 21.1).

The frame is received by the datalink on the right based on what we call imperfect filtering, which is done by the interface using the Ethernet destination address. We say this is imperfect because it is normally the case that when the interface is told to receive frames destined to one specific Ethernet multicast address, it can receive frames destined to other Ethernet multicast addresses, too.

Assuming that the datalink on the right receives the frame, since the Ethernet frame type is IPv4, the packet is passed to the IP layer. Since the received packet was destined to a multicast IP address, the IP layer compares this address against all the multicast addresses that applications on this host have joined. We call this perfect filtering since it is based on the entire 32-bit class D address in the IPv4 header. In this example, the packet is accepted by the IP layer and passed to the UDP layer, which in turn passes the datagram to the socket that is bound to port 123.

There are three scenarios that we do not show in Figure 21.4:

1. A host running an application that has joined the multicast address 225.0.1.1. Since the upper five bits of the group address are ignored in the mapping to the Ethernet address, this host's interface will also be receiving frames with a destination Ethernet address of 01:00:5e:00:01:01. In this case, the packet will be discarded by the perfect filtering in the IP layer.

2. A host running an application that has joined some multicast group whose corresponding Ethernet address just happens to be one that the interface receives when it is programmed to receive 01:00:5e:00:01:01. (i.e., the interface card performs imperfect filtering). This frame will be discarded either by the datalink layer or by the IP layer.

3. A packet destined to the same group, 224.0.1.1, but a different port, say 4000. The rightmost host in Figure 21.4 still receives the packet, which is accepted by the IP layer, but assuming a socket does not exist that has bound port 4000, the packet will be discarded by the UDP layer.

   This demonstrates that for a process to receive a multicast datagram, the process must join the group and bind the port.

## 21.4 Multicasting on a WAN

Multicasting on a single LAN, as discussed in the previous section, is simple. One host sends a multicast packet and any interested host receives the packet. The benefit of multicasting over broadcasting is reducing the load on all the hosts not interested in the multicast packets.

Multicasting is also beneficial on WANs. Consider the WAN shown in Figure 21.5, which shows five LANs connected with five multicast routers.

Next, assume that some program is started on five of the hosts (say a program that listens to a multicast audio session) and those five programs join a given multicast group. Each of the five hosts then joins that multicast group. We also assume that the multicast routers are all communicating with their neighbor multicast router using a multicast routing protocol, which we designate as just MRP. We show this in Figure 21.6.

When a process on a host joins a multicast group, that host sends an IGMP message to any attached multicast routers telling them that the host has just joined that group. The multicast routers then exchange this information using the MRP so that each multicast router knows what to do if it receives a packet destined to the multicast address.

Multicast routing is still a research topic and could easily consume a book on its own.

We now assume that a process on the host at the top left starts sending packets destined to the multicast address. Say this process is sending the audio packets that the multicast receivers are waiting to receive. We show these packets in Figure 21.7.

We can follow the steps taken as the multicast packets go from the sender to all the receivers:

- The packets are multicast on the top left LAN by the sender. Receiver H1 receives these (since it has joined the group) as does MR1 (since a multicast router must receive all multicast packets).

- MR1 forwards the multicast packet to MR2, because the MRP has informed MR1 that MR2 needs to receive packets destined to this group.

- MR2 multicasts the packet on to its attached LAN, since hosts H2 and H3 belong to the group. It also makes a copy of the packet and sends it to MR3.

  Making a copy of the packet, as MR2 does here, is something unique to multicast forwarding. A unicast packet is never duplicated as it is forwarded by routers.

- MR3 sends the multicast packet to MR4, but MR3 does not multicast a copy on its attached LAN because we assume no host on the LAN has joined the group.

- MR4 multicasts the packet onto its attached LAN, since hosts H4 and H5 belong to the group. It does not make a copy and send it to MR5 because none of the hosts on MR5's attached LAN belong to the group and MR4 knows this based on the multicast routing information it has exchanged with MR5.

Two less desirable alternatives to multicasting on a WAN are broadcast flooding and sending individual copies to each receiver. In the first case, the packets would be broadcast by the sender, and each router would broadcast the packets out each of its interfaces, except the arriving interface. It should be obvious that this increases the number of uninterested hosts and routers that must deal with the packet.

In the second case, the sender must know the IP address of all the receivers and send each one a copy. With the five receivers we show in Figure 21.7, this would require five packets on the sender's LAN, four packets going from MR1 to MR2, and two packets going from MR2 to MR3 to MR4. Now just imagine the situation with a million receivers!

## 21.5 Source-Specific Multicast

## 21.6 Multicast Socket Options

## 21.7 `mcast_join` and Related Functions

### `mcast_join` Function

    int mcast_join(int sockfd, const struct sockaddr *grp, socklen_t grplen, const char *ifname, u_int ifindex);

`mcast_join` joins the any-source multicast group whose IP address is contained within the socket address structure pointed to by `grp`, and whose length is specified by grplen. We can specify the interface on which to join the group by either the interface name (a non-null `ifname`) or a nonzero interface index (`ifindex`). If neither is specified, the kernel chooses the interface on which the group is joined. Recall that with IPv6, the interface is specified to the socket option by its index. If a name is specified for an IPv6 socket, we call `if_nametoindex` to obtain the index. With the IPv4 socket option, the interface is specified by its unicast IP address. If a name is specified for an IPv4 socket, we call `ioctl` with a request of `SIOCGIFADDR` to obtain the unicast IP address for the interface. If an index is specified for an IPv4 socket, we first call `if_indextoname` to obtain the name and then process the name as just described.

An interface name, such as `le0` or `ether0`, is normally the way users specify interfaces, and not with either the IP address or the index. tcpdump, for example, is one of the few programs that lets the user specify an interface, and its `-i` option takes an interface name as the argument.

    int
    mcast_join(int sockfd, const SA *grp, socklen_t grplen,
               const char *ifname, u_int ifindex)
    {
    #ifdef MCAST_JOIN_GROUP
        struct group_req req;
        if (ifindex > 0) {
            req.gr_interface = ifindex;
        } else if (ifname != NULL) {
            if ( (req.gr_interface = if_nametoindex(ifname)) == 0) {
                errno = ENXIO;      /* i/f name not found */
                return (-1);
            }
        } else {
            req.gr_interface = 0;
        }
        // The caller's socket address is copied directly into the request's group field. Recall that the group field is a sockaddr_storage, so it is big enough to handle any socket address type the system supports. However, to guard against buffer overruns caused by sloppy coding, we check the sockaddr size and return EINVAL if it is too large.
        if (grplen > sizeof(req.gr_group)) {
            errno = EINVAL;
            return -1;
        }
        memcpy(&req.gr_group, grp, grplen);
        // setsockopt performs the join. The level argument to setsockopt is determined using the family of the group address and our family_to_level function. Some systems support a mismatch between level and the socket's address family, for instance, using IPPROTO_IP with MCAST_JOIN_GROUP, even with an AF_INET6 socket, but not all do, so we turn the address family into the appropriate level. We do not show this trivial function, but the source code is freely available (see the Preface).
        return (setsockopt(sockfd, family_to_level(grp->sa_family),
                           MCAST_JOIN_GROUP, &req, sizeof(req)));
    #else
        switch (grp->sa_family) {
        case AF_INET:{
                struct ip_mreq mreq;
                struct ifreq ifreq;
     
                memcpy(&mreq.imr_multiaddr,
                       &((const struct sockaddr_in *) grp)->sin_addr,
                       sizeof(struct in_addr));
     
                if (ifindex > 0) {
                    // The IPv4 multicast address in the socket address structure is copied into an ip_mreq structure. If an index was specified, if_indextoname is called, storing the name into our ifreq structure. If this succeeds, we branch ahead to issue the ioctl.
                    if (if_indextoname(ifindex, ifreq.ifr_name) == NULL) {
                        errno = ENXIO; /*  i/f index not found */
                        return (-1);
                    }
                    goto doioctl;
                } else if (ifname != NULL) {
                    // The caller's name is copied into an ifreq structure, and an ioctl of SIOCGIFADDR returns the unicast address associated with this name. Upon success the IPv4 address is copied into the imr_interface member of the ip_mreq structure.
                    strncpy(ifreq.ifr_name, ifname, IFNAMSIZ);
                  doioctl:
                    if (ioctl(sockfd, SIOCGIFADDR, &ifreq) < 0)
                        return (-1);
                    memcpy(&mreq.imr_interface,
                           &((struct sockaddr_in *) &ifreq.ifr_addr)->sin_addr,
                           sizeof(struct in_addr));
                } else {
                    // If an index was not specified and a name was not specified, the interface is set to the wildcard address, telling the kernel to choose the interface.
                    mreq.imr_interface.s_addr = htonl(INADDR_ANY);
                }
     
                // setsockopt performs the join.
                return (setsockopt(sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP,
                                   &mreq, sizeof(mreq)));
            }
    #ifdef  IPV6
        case AF_INET6:{
                struct ipv6_mreq mreq6;
    
                // First the IPv6 multicast address is copied from the socket address structure into the ipv6_mreq structure.
                memcpy(&mreq6.ipv6mr_multiaddr,
                       &((const struct sockaddr_in6 *) grp) ->sin6_addr,
                       sizeof(struct in6_addr));
    
                // If an index was specified, it is stored in the ipv6mr_interface member; if a name was specified, the index is obtained by calling if_nametoindex; otherwise, the interface index is set to 0 for setsockopt, telling the kernel to choose the interface.
                if (ifindex > 0) {
                    mreq6.ipv6mr_interface = ifindex;
                } else if (ifname != NULL) {
                    if ( (mreq6.ipv6mr_interface = if_nametoindex(ifname)) == 0) {
                        errno = ENXIO;  /* i/f name not found */
                        return (-1);
                    }
                } else {
                    mreq6.ipv6mr_interface = 0;
                }
    
                // The group is joined.
                return (setsockopt(sockfd, IPPROTO_IPV6, IPV6_JOIN_GROUP,
                                   &mreq6, sizeof(mreq6)));
            }
    #endif
    
        default:
            errno = EAFNOSUPPORT;
            return (-1);
        }
    #endif
    }

### `mcast_set_loop` Function

    int mcast_set_loop(int sockfd, int flag);

`mcast_set_loop` sets the loopback option to either 0 or 1, and `mcast_set_ttl` sets either the IPv4 TTL or the IPv6 hop limit. The three `mcast_get_`XXX functions return the corresponding value.

    #include    "unp.h"
    
    int
    mcast_set_loop(int sockfd, int onoff)
    {
        switch (sockfd_to_family(sockfd)) {
        case AF_INET:{
                u_char  flag;
    
                flag = onoff;
                return (setsockopt(sockfd, IPPROTO_IP, IP_MULTICAST_LOOP,
                                   &flag, sizeof(flag)));
            }
    
    #ifdef  IPV6
        case AF_INET6:{
                u_int   flag;
    
                flag = onoff;
                return (setsockopt(sockfd, IPPROTO_IPV6, IPV6_MULTICAST_LOOP,
                                   &flag, sizeof(flag)));
            }
    #endif
    
        default:
            errno = EAFNOSUPPORT;
            return (-1);
        }
    }

## 21.8 `dg_cli` Function Using Multicasting

We modify our `dg_cli` function from Figure 20.5 by just removing the call to `setsockopt`. As we said earlier, none of the multicast socket options needs to be set to send a multicast datagram if the default settings for the outgoing interface, TTL, and loopback option are acceptable. We run a modified UDP echo server that joins the allhosts group, then run our program specifying the all-hosts group as the destination address.

We get a response from both systems on the subnet. They are each running the multicast echo server. Each reply is unicast because the source address of the request, which is used by each server as the destination address of the reply, is a unicast address.

### IP Fragmentation and Multicasts

We mentioned at the end of Section 20.4 that most systems do not allow the fragmentation of a broadcast datagram as a policy decision. Fragmentation is fine to use with multicasting, as we can easily verify using the same file with a 2,000-byte line.

    macosx % udpcli01 224.0.0.1 < 2000line
    from 172.24.37.78: xxxxxxxxxx[...]
    from 172.24.37.94: xxxxxxxxxx[...]

## 21.9 Receiving IP Multicast Infrastructure Session Announcements

The IP multicast infrastructure is the portion of the Internet with inter-domain multicast enabled. Multicast is not enabled on the entire Internet; the IP multicast infrastructure started life as the "MBone" in 1992 as an overlay network and moved toward being deployed as part of the Internet infrastructure in 1998. Multicast is widely deployed within enterprises, but being part of the inter-domain IP multicast infrastructure is less common.

### Figure 21.14 `main` program to receive SAP/SDP announcements

    #include    "unp.h"
    
    #define SAP_NAME     "sap.mcast.net" /* default group name and port */
    #define SAP_PORT     "9875"
    
    void     loop(int, socklen_t);
    
    int
    main(int argc, char **argv)
    {
        int     sockfd;
        const int on = 1;
        socklen_t salen;
        struct sockaddr *sa;
    
        // We call our udp_client function to look up the name and port, and it fills in the appropriate socket address structure. We use the defaults if no command-line arguments are specified; otherwise, we take the multicast address, port, and interface name from the command-line arguments.
        if (argc == 1)
            sockfd = Udp_client(SAP_NAME, SAP_PORT, (void **) &sa, &salen);
        else if (argc == 4)
            sockfd = Udp_client(argv[1], argv[2], (void **) &sa, &salen);
        else
            err_quit("usage: mysdr <mcast-addr> <port#> <interface-name>");
    
        // We set the SO_REUSEADDR socket option to allow multiple instances of this program to run on a host, and bind the port to the socket. By binding the multicast address to the socket, we prevent the socket from receiving any other UDP datagrams that may be received for the port. **Binding this multicast address is not required**, but it provides filtering by the kernel of packets in which we are not interested.
        Setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
        Bind(sockfd, sa, salen);
    
        // We call our mcast_join function to join the group. If the interface name was specified as a command-line argument, it is passed to our function; otherwise, we let the kernel choose the interface on which the group is joined.
        Mcast_join(sockfd, sa, salen, (argc == 4) ? argv[3] : NULL, 0);
    
        // We call our loop function, shown in Figure 21.15, to read and print all the announcements.
        loop(sockfd, salen);        /* receive and print */
    
        exit(0);
    }

### Figure 21.15 Loop that receives and prints SAP/SDP announcements

    #include    "mysdr.h"
    
    void
    loop(int sockfd, socklen_t salen)
    {
        socklen_t len;
        ssize_t n;
        char   *p;
        struct sockaddr *sa;
        // sap_packet describes the SDP packet: a 32-bit SAP header, followed by a 32-bit source address, followed by the actual announcement. The announcement is simply lines of ISO 8859–1 text and should not exceed 1,024 bytes. Only one session announcement is allowed in each UDP datagram.
        struct sap_packet {
            uint32_t sap_header;
            uint32_t sap_src;
            char    sap_data[BUFFSIZE];
        } buf;
    
        sa = Malloc(salen);
    
        for ( ; ; ) {
            len = salen;
            // recvfrom waits for the next UDP datagram destined to our socket. When one arrives, we place a null byte at the end of the buffer, fix the byte order of the header field, and print the source of the packet and SAP hash.
            n = Recvfrom(sockfd, &buf, sizeof(buf) - 1, 0, sa, &len);
            ((char *) &buf)[n] = 0; /* null terminate */
            buf.sap_header = ntohl(buf.sap_header);
    
            printf("From %s hash 0x%04x\n", Sock_ntop(sa, len),
                   buf.sap_header & SAP_HASH_MASK);
            // We check the SAP header to see if it is a type that we handle. We don't handle SAP packets with IPv6 addresses in the header, or compressed or encrypted packets.
            if (((buf.sap_header & SAP_VERSION_MASK) >> SAP_VERSION_SHIFT) > 1) {
                err_msg("... version field not 1 (0x%08x)", buf.sap_header);
                continue;
            }
            if (buf.sap_header & SAP_IPV6) {
                err_msg("... IPv6");
                continue;
            }
            if (buf.sap_header & (SAP_DELETE | SAP_ENCRYPTED | SAP_COMPRESSED)) {
                err_msg("... can't parse this packet type (0x%08x)",
                        buf.sap_header);
                continue;
            }
            // We skip over any authentication data that may be present, skip over the packet content type if it's present, and then print out the contents of the packet.
            p = buf.sap_data + ((buf.sap_header & SAP_AUTHLEN_MASK)
                                >> SAP_AUTHLEN_SHIFT);
            if (strcmp(p, "application/sdp") == 0)
                p += 16;
            printf("%s\n", p);
        }
    }

## 21.10 Sending and Receiving

The IP multicast infrastructure session announcement program in the previous section only received multicast datagrams. We will now develop a simple program that sends and receives multicast datagrams. Our program consists of two parts. The first part sends a multicast datagram to a specific group every five seconds and the datagram contains the sender's hostname and process ID. The second part is an infinite loop that joins the multicast group to which the first part is sending and prints every received datagram (containing the hostname and process ID of the sender). This allows us to start the program on multiple hosts on a LAN and easily see which host is receiving datagrams from which senders.

### Figure 21.17 Create sockets, `fork`, and start sender and receiver

We create two sockets, one for sending and one for receiving. We want the receiving socket to bind the multicast group and port, say 239.255.1.2 port 8888. (Recall that **we could just bind the wildcard IP address** and port 8888, but binding the multicast address prevents the socket from receiving any other datagrams that might arrive destined for port 8888.) We then want the receiving socket to join the multicast group. The sending socket will send datagrams to this same multicast address and port, say 239.255.1.2 port 8888. But if we try to use a single socket for sending and receiving, the source protocol address is 239.255.1.2:8888 from the bind (using netstat notation) and the destination protocol address for the sendto is also 239.255.1.2:8888. However, now the source protocol address that is bound to the socket becomes the source IP address of the UDP datagram, and RFC 1122 [Braden 1989] forbids an IP datagram from having a source IP address that is a multicast address or a broadcast address (see Exercise 21.2 also). Therefore, we must create two sockets: one for sending and one for receiving.

    #include    "unp.h"
    
    void    recv_all(int, socklen_t);
    void    send_all(int, SA *, socklen_t);
    
    int
    main(int argc, char **argv)
    {
        int     sendfd, recvfd;
        const int on = 1;
        socklen_t salen;
        struct sockaddr *sasend, *sarecv;
    
        if (argc != 3)
            err_quit("usage: sendrecv <IP-multicast-address> <port#>");
    
        Our udp_client function creates the sending socket, processing the two command-line arguments that specify the multicast address and port number. This function also returns a socket address structure that is ready for calls to sendto along with the length of this socket address structure.
        sendfd = Udp_client(argv[1], argv[2], (void **) &sasend, &salen);
    
        // We create the receiving socket using the same address family that was used for the sending socket. We set the SO_REUSEADDR socket option to allow multiple instances of this program to run at the same time on a host. We then allocate room for a socket address structure for this socket, copy its contents from the sending socket address structure (whose address and port were taken from the command-line arguments), and bind the multicast address and port to the receiving socket.
        recvfd = Socket(sasend->sa_family, SOCK_DGRAM, 0);
    
        Setsockopt(recvfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
    
        sarecv = Malloc(salen);
        memcpy(sarecv, sasend, salen);
        Bind(recvfd, sarecv, salen);
    
        // We call our mcast_join function to join the multicast group on the receiving socket and our mcast_set_loop function to disable the loopback feature on the sending socket. For the join, we specify the interface name as a null pointer and the interface index as 0, telling the kernel to choose the interface.
        Mcast_join(recvfd, sasend, salen, NULL, 0);
        Mcast_set_loop(sendfd, 0);
    
        if (Fork() == 0)
            // We fork and then the child is the receive loop and the parent is the send loop
            recv_all(recvfd, salen);    /* child -> receives */
    
        send_all(sendfd, sasend, salen);    /* parent -> sends */
    }

### Figure 21.18 Send a multicast datagram every five seconds

Our `send_all` function, which sends one multicast datagram every five seconds, is shown in Figure 21.18. The `main` function passes as arguments the socket descriptor, a pointer to a socket address structure containing the multicast destination and port, and the structure's length.

    #include    "unp.h"
    #include    <sys/utsname.h>
    
    #define SENDRATE     5           /* send one datagram every five seconds */
    
    void
    send_all(int sendfd, SA *sadest, socklen_t salen)
    {
        char    line[MAXLINE];      /* hostname and process ID */
        struct utsname myname;
    
        // We obtain the hostname from the uname function and build the output line containing it and the process ID.
        if (uname(&myname) < 0)
            err_sys("uname error");;
        snprintf(line, sizeof(line), "%s, %d\n", myname.nodename, getpid());
    
        for ( ; ; ) {
            Sendto(sendfd, line, strlen(line), 0, sadest, salen);
    
            sleep(SENDRATE);
        }
    }

### Figure 21.19 Receive all multicast datagrams for a group we have joined

    #include    "unp.h"
    
    void
    recv_all(int recvfd, socklen_t salen)
    {
        int     n;
        char    line[MAXLINE + 1];
        socklen_t len;
        struct sockaddr *safrom;
    
        // A socket address structure is allocated to receive the sender's protocol address for each call to recvfrom.
        safrom = Malloc(salen);
    
        for ( ; ; ) {
            len = salen;
            n = Recvfrom(recvfd, line, MAXLINE, 0, safrom, &len);
    
            line[n] = 0;            /* null terminate */
            printf("from %s: %s", Sock_ntop(safrom, len), line);
        }
    }

## 21.11 Simple Network Time Protocol (SNTP)

NTP is a sophisticated protocol for synchronizing clocks across a WAN or a LAN, and can often achieve millisecond accuracy. RFC 1305 [Mills 1992] describes the protocol in detail and RFC 2030 [Mills 1996] describes SNTP, a simplified but protocol-compatible version intended for hosts that do not need the complexity of a complete NTP implementation. It is common for a few hosts on a LAN to synchronize their clocks across the Internet to other NTP hosts and then redistribute this time on the LAN using either broadcasting or multicasting.

In this section, we will develop an SNTP client that listens for NTP broadcasts or multicasts on all attached networks and then prints the time difference between the NTP packet and the host's current time-of-day. We do not try to adjust the time-of-day, as that takes superuser privileges.

### Figure 21.20 ntp.h header: NTP packet format and definitions

    #define JAN_1970    2208988800UL     /* 1970 - 1900 in seconds */
    
    struct l_fixedpt {               /* 64-bit fixed-point */
        uint32_t int_part;
        uint32_t fraction;
    };
    
    struct s_fixedpt {               /* 32-bit fixed-point */
        uint16_t int_part;
        uint16_t fraction;
    };
    
    struct ntpdata {                 /* NTP header */
        u_char  status;
        u_char  stratum;
        u_char  ppoll;
        int     precision:8;
        struct s_fixedpt distance;
        struct s_fixedpt dispersion;
        uint32_t refid;
        struct l_fixedpt reftime;
        struct l_fixedpt org;
        struct l_fixedpt rec;
        struct l_fixedpt xmt;
    };
    
    #define VERSION_MASK    0x38
    #define MODE_MASK       0x07
    
    #define MODE_CLIENT     3
    #define MODE_SERVER     4
    #define MODE_BROADCAST  5

### Figure 21.21 `main` function

    #include    "sntp.h"
    
    int
    main(int argc, char **argv)
    {
        int     sockfd;
        char    buf[MAXLINE];
        ssize_t n;
        socklen_t salen, len;
        struct ifi_info *ifi;
        struct sockaddr *mcastsa, *wild, *from;
        struct timeval now;
    
        if (argc != 2)
            err_quit("usage: ssntp <IPaddress>");
    
        // When the program is executed, the user must specify the multicast address to join as the command-line argument. With IPv4, this would be 224.0.1.1 or the name ntp.mcast.net. With IPv6, this would be ff05::101 for the site-local scope NTP. Our udp_client function allocates space for a socket address structure of the correct type (either IPv4 or IPv6) and stores the multicast address and port in that structure. If this program is run on a host that does not support multicasting, any IP address can be specified, as only the address family and port are used from this structure. Note that our udp_client function does not bind the address to the socket; it just creates the socket and fills in the socket address structure.
        sockfd = Udp_client(argv[1], "ntp", (void **) &mcastsa, &salen);
    
        // We allocate space for another socket address structure and fill it in by copying the structure that was filled in by udp_client. This sets the address family and port. We call our sock_set_wild function to set the IP address to the wildcard and then call bind.
        wild = Malloc(salen);
        memcpy(wild, mcastsa, salen);   /* copy family and port */
        sock_set_wild(wild, salen);
        Bind(sockfd, wild, salen);  /* bind wildcard */
    
    #ifdef  MCAST
        // Our get_ifi_info function returns information on all the interfaces and addresses. The address family that we ask for is taken from the socket address structure that was filled in by udp_client based on the command-line argument.
            /* obtain interface list and process each one */
        for (ifi = Get_ifi_info(mcastsa->sa_family, 1); ifi != NULL;
             ifi = ifi->ifi_next) {
            // We call our mcast_join function to join the multicast group specified by the command-line argument for each multicast-capable interface. All these joins are done on the one socket that this program uses. As we said earlier, there is normally a limit of IP_MAX_MEMBERSHIPS (often 20) joins per socket, but few multihomed hosts have that many interfaces.
            if (ifi->ifi_flags & IFF_MULTICAST) {
                Mcast_join(sockfd, mcastsa, salen, ifi->ifi_name, 0);
                printf("joined %s on %s\n",
                       Sock_ntop(mcastsa, salen), ifi->ifi_name);
            }
        }
    #endif
    
        // Another socket address structure is allocated to hold the address returned by recvfrom and the program enters an infinite loop, reading all the NTP packets that the host receives and calling our sntp_proc function (described next) to process the packet. Since the socket was bound to the wildcard address, and since the multicast group was joined on all multicast-capable interfaces, the socket should receive any unicast, broadcast, or multicast NTP packet that the host receives. Before calling sntp_proc, we call gettimeofday to fetch the current time, because sntp_proc calculates the difference between the time in the packet and the current time.
        from = Malloc(salen);
        for ( ; ; ) {
            len = salen;
            n = Recvfrom(sockfd, buf, sizeof(buf), 0, from, &len);
            Gettimeofday(&now, NULL);
            sntp_proc(buf, n, &now);
        }
    }

### Figure 21.22 `sntp_proc` function: processes the NTP packet

    #include    "sntp.h"
    
    void
    sntp_proc(char *buf, ssize_t n, struct timeval *nowptr)
    {
        int     version, mode;
        uint32_t nsec, useci;
        double  usecf;
        struct timeval diff;
        struct ntpdata *ntp;
    
        // We first check the size of the packet and then print the version, mode, and server stratum. If the mode is MODE_CLIENT, the packet is a client request, not a server reply, and we ignore it.
        if (n < (ssize_t) sizeof(struct ntpdata)) {
            printf("\npacket too small: %d bytes\n", n);
            return;
        }
    
        ntp = (struct ntpdata *) buf;
        version = (ntp->status & VERSION_MASK) >> 3;
        mode = ntp->status & MODE_MASK;
        printf("\nv%d, mode %d, strat %d, ", version, mode, ntp->stratum);
        if (mode == MODE_CLIENT) {
            printf("client\n");
            return;
        }
    
        nsec = ntohl(ntp->xmt.int_part) - JAN_1970;
        useci = ntohl(ntp->xmt.fraction);   /* 32-bit integer fraction */
        usecf = useci;              /* integer fraction -> double */
        usecf /= 4294967296.0;      /* divide by 2**32 -> [0, 1.0) */
        useci = usecf * 1000000.0;  /* fraction -> parts per million */
    
        diff.tv_sec = nowptr->tv_sec - nsec;
        if ( (diff.tv_usec = nowptr->tv_usec - useci) < 0) {
            diff.tv_usec += 1000000;
            diff.tv_sec--;
        }
        useci = (diff.tv_sec * 1000000) + diff.tv_usec; /* diff in microsec */
        printf("clock difference = %d usec\n", useci);
    }

## 21.12 Summary

A multicast application starts by joining the multicast group assigned to the application. This tells the IP layer to join the group, which in turns tells the datalink layer to receive multicast frames that are sent to the corresponding hardware layer multicast address. Multicasting takes advantage of the hardware filtering present on most interface cards, and the better the filtering, the fewer the number of undesired packets received. Using this hardware filtering reduces the load on all the other hosts that are not participating in the application.

Multicasting on a WAN requires multicast-capable routers and a multicast routing protocol. Until all the routers on the Internet are multicast-capable, multicast is only available to a subset of Internet users. We use the term "IP multicast infrastructure" to describe the set of all multicast-capable systems on the Internet.

Nine socket options provide the API for multicasting:

- Join an any-source multicast group on an interface

- Leave a multicast group

- Block a source from a joined group

- Unblock a blocked source

- Join a source-specific multicast group on an interface

- Leave a source-specific multicast group

- Set the default interface for outgoing multicasts

- Set the TTL or hop limit for outgoing multicasts

Enable or disable loopback of multicasts

The first six are for receiving, and the last three are for sending. There is enough difference between the IPv4 socket options and the IPv6 socket options that protocol-independent multicasting code becomes littered with `#ifdefs` very quickly. We developed 12 functions of our own, all beginning with `mcast_`, that can help in writing multicast applications that work with either IPv4 or IPv6.








