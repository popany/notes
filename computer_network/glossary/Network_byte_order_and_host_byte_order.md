# [Network byte order and host byte order](https://www.ibm.com/support/knowledgecenter/en/SSB27U_6.4.0/com.ibm.zvm.v640.kiml0/asonetw.htm)

- [Network byte order and host byte order](#network-byte-order-and-host-byte-order)

**Ports** and **addresses** are always specified in calls to the socket functions using the **network byte order convention**. This convention is a method of sorting bytes that is **independent of specific machine architectures**. Host byte order, on the other hand, sorts bytes in the manner which is most natural to the host software and hardware. There are two common host byte order methods:

- **Little-endian** byte ordering places the least significant byte first. This method is used in **Intel microprocessors**, for example.

- **Big-endian** byte ordering places the most significant byte first. This method is used in IBM® z/Architecture® and S/390® mainframes and Motorola microprocessors, for example.

The **network byte order is defined to always be big-endian**, which may differ from the host byte order on a particular machine. Using network byte ordering for data exchanged between hosts allows hosts using different architectures to exchange address information without confusion because of byte ordering. The following C functions allow the application program to switch numbers easily back and forth between the host byte order and network byte order without having to first know what method is used for the host byte order:

- `htonl()` translates an unsigned long integer into network byte order.
- `htons()` translates an unsigned short integer into network byte order.
- `ntohl()` translates an unsigned long integer into host byte order.
- `ntohs()` translates an unsigned short integer into host byte order.


