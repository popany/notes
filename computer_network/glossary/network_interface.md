# network interface

- [network interface](#network-interface)
  - [TCP/IP network interfaces](#tcpip-network-interfaces)
    - [TCP/IP supports types of network interfaces:](#tcpip-supports-types-of-network-interfaces)

## [TCP/IP network interfaces](https://www.ibm.com/support/knowledgecenter/en/ssw_aix_71/network/tcpip_interfaces.html)

The TCP/IP Network Interface layer **formats IP datagrams** at the Network layer into packets that specific network technologies can understand and transmit.

A network interface is the **network-specific software** that communicates with the network-specific device driver and the IP layer in order to **provide the IP layer with a consistent interface** to all network adapters that might be present.

The IP layer selects the appropriate network interface based on the destination address of the packet to be transmitted. Each network interface has a network address. The Network Interface layer is responsible for **adding or removing any link layer protocol header** required to deliver a message to its destination. The network adapter device driver controls the network adapter card.

Although not required, a network interface is **usually associated with a network adapter**. For instance, the **loopback interface has no network adapter** associated with it. A machine must have one network adapter card for each network (not network type) to which it connects. However, a machine requires only one copy of the network interface software for each network adapter it uses. For instance, if a host attaches to two token-ring networks, it must have two network adapter cards. However, only one copy of the token-ring network interface software and one copy of the token-ring device driver is required.

### TCP/IP supports types of network interfaces:

- Standard Ethernet Version 2 (en)
- IEEE 802.3 (et)
- Token-ring (tr)
- Serial Line Internet Protocol (SLIP)
- Loopback (lo)
- FDDI
- Serial Optical (so)
- ATM (at)
- Point-to-Point Protocol (PPP)
- Virtual IP Address (vi)

The ***Ethernet***, ***802.3***, and ***token-ring*** interfaces are for use with **local area networks (LANs)**. The ***SLIP*** interface is for use with **serial connections**. The ***loopback*** interface is used by a host to **send messages back to itself**. The ***Serial Optical*** interface is for use with **optical point-to-point networks** using the Serial Optical Link device handler. The ***ATM*** interface is for use with 100 Mb/sec and 155 Mb/sec **ATM connections**. Point to Point protocol is most often used when connecting to another computer or network via a modem. The ***Virtual IP Address*** interface (also called virtual interface) is **not associated with any particular network adapter**. Multiple instances of a virtual interface can be configured on a host. When virtual interfaces are configured, the address of the first virtual interface becomes the source address unless an application has chosen a different interface. Processes that use a virtual IP address as their source address can send packets through any network interface that provides the best route for that destination. Incoming packets destined for a virtual IP address are delivered to the process regardless of the interface through which they arrive.
