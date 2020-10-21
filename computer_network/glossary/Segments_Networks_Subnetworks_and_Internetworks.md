# [Segments, Networks, Subnetworks and Internetworks](http://www.tcpipguide.com/free/t_SegmentsNetworksSubnetworksandInternetworks.htm)

- [Segments, Networks, Subnetworks and Internetworks](#segments-networks-subnetworks-and-internetworks)
  - [Network](#network)
  - [Subnetwork (Subnet)](#subnetwork-subnet)
  - [Segment (Network Segment)](#segment-network-segment)
  - [Internetwork (or Internet)](#internetwork-or-internet)

## Network

This is the least specific of the terms mentioned here. Basically, a network can be of pretty much any size, from two devices to thousands. When networks get very large, however, and are clearly comprised of smaller networks connected together, they are often no longer called networks but internetworks, as we will see momentarily. Despite this, it is fairly common to hear someone refer to something like “Microsoft's corporate network”, which obviously contains thousands or even tens of thousands of machines.

## Subnetwork (Subnet)

A subnetwork is a portion of a network, or a network that is part of a larger internetwork. This term is also a rather subjective one; subnetworks can in fact be rather large when they are part of a network that is very large.

The abbreviated term “subnet” can refer generically to a subnetwork, but also has a [specific meaning in the context of TCP/IP addressing](http://www.tcpipguide.com/free/t_IPSubnetAddressingSubnettingConcepts.htm).

## Segment (Network Segment)

A segment is a small section of a network. In some contexts, a **segment** is the same as a **subnetwork** and the terms are used **interchangeably**. More often, however, the term “segment” implies something smaller than a subnetwork. Networks are often designed so that, for the sake of efficiency, with computers that are related to each other or that are used by the same groups of people put on the same network segment.

This term is notably problematic because it is routinely used in two different ways, especially in discussions related to Ethernet. The earliest forms of Ethernet used coaxial cables, and the coax cable itself was called a “segment”. The segment was shared by all devices connected to it, and became the collision domain for the network (a phrase referring generally to a collection of hardware devices where only one can transmit at a time.)

Each Ethernet physical layer had specific rules about how many devices could be on a segment, how many segments could be connected together, and so on, depending on what sort of network interconnection devices were being used. Devices such as hubs and repeaters were used to extend collision domains by connecting together these segments of cable into wider networks. Over time, the terms “collision domain” and “segment” started to be used interchangeably. Thus today a “segment” can refer either to a specific piece of cable, or to a collection of cables connected electrically that represent a single collision domain.

## Internetwork (or Internet)

Most often, this refers to a larger networking structure that is formed by connecting together smaller ones. Again, the term can have either a generic or a specific meaning, depending on context. In some technologies, an internetwork is just a very large network that has networks as components. In others, a network is differentiated from an internetwork based on how the devices are connected together.

An important example of the latter definition is TCP/IP, where a **network** usually refers to a collection of machines that are linked at [layer two of the OSI Reference Model](http://www.tcpipguide.com/free/t_DataLinkLayerLayer2.htm), using technologies like Ethernet or Token Ring and interconnection devices such as hubs and switches. An **internetwork** is formed when these networks are linked together at [layer three](http://www.tcpipguide.com/free/t_NetworkLayerLayer3.htm), using routers that pass Internet Protocol datagrams between networks. Naturally, this is highly simplified, but in studying TCP/IP you should keep this in mind when you encounter the terms “network” and “internetwork”.
