# [Programming With XTI and TLI](https://docs.oracle.com/cd/E26505_01/html/E27001/tli-33281.html)

- [Programming With XTI and TLI](#programming-with-xti-and-tli)
  - [What Are XTI and TLI?](#what-are-xti-and-tli)
  - [XTI/TLI Versus Socket Interfaces](#xtitli-versus-socket-interfaces)

This chapter describes the Transport Layer Interface (TLI) and the X/Open Transport Interface (XTI). Advanced topics such as asynchronous execution mode are discussed in [Advanced XTI/TLI Topics](https://docs.oracle.com/cd/E26505_01/html/E27001/tli-54555.html#scrolltoc).

Some recent additions to XTI, such as scatter/gather data transfer, are discussed in [Additions to the XTI Interface](https://docs.oracle.com/cd/E26505_01/html/E27001/tli-1ad.html#scrolltoc).

The transport layer of the OSI model (layer 4) is the lowest layer of the model that provides applications and higher layers with end-to-end service. This layer hides the topology and characteristics of the underlying network from users. The transport layer also defines a set of services common to many contemporary protocol suites including the OSI protocols, Transmission Control Protocol and TCP/IP Internet Protocol Suite, Xerox Network Systems (XNS), and Systems Network Architecture (SNA).

TLI s modeled on the industry standard Transport Service Definition (ISO 8072). It also can be used to access both TCP and UDP. XTI and TLI are a set of interfaces that constitute a network programming interface. **XTI is an evolution from the older TLI interface** available on the SunOS 4 platform. The Solaris operating system supports both interfaces, although XTI represents the future direction of this set of interfaces. The Solaris software implements XTI and TLI as a user library using the STREAMS I/O mechanism.

## What Are XTI and TLI?

...

## XTI/TLI Versus Socket Interfaces

XTI/TLI and sockets are different methods of **handling the same tasks**. Although they provide mechanisms and services that are **functionally similar**, they do not provide one-to-one compatibility of routines or low-level services. Observe the similarities and differences between the XTI/TLI and socket-based interfaces before you decide to port an application.

The following issues are related to transport independence, and can have some bearing on RPC applications:

- Privileged ports – Privileged ports are an artifact of the Berkeley Software Distribution (BSD) implementation of the TCP/IP Internet Protocols. These ports are not portable. The notion of privileged ports is not supported in the transport-independent environment.

- Opaque addresses – Separating the portion of an address that names a host from the portion of an address that names the service at that host cannot be done in a transport-independent fashion. Be sure to change any code that assumes it can discern the host address of a network service.

- Broadcast – No transport-independent form of broadcast address exists.
