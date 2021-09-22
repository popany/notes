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










