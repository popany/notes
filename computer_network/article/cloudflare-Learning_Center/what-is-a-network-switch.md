# [什么是网络交换机？| 交换机与路由器对比](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-a-network-switch/)

- [什么是网络交换机？| 交换机与路由器对比](#什么是网络交换机-交换机与路由器对比)
  - [交换机和路由器有什么区别？](#交换机和路由器有什么区别)
  - [什么是第 2 层交换机？什么是第 3 层交换机？](#什么是第-2-层交换机什么是第-3-层交换机)
  - [MAC 地址与 IP 地址有什么区别？](#mac-地址与-ip-地址有什么区别)
  - [什么是非托管交换机？什么是托管交换机？](#什么是非托管交换机什么是托管交换机)
  - [什么是以太网交换机？](#什么是以太网交换机)

网络交换机连接网络（通常为[局域网（LAN）](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-a-lan)）内的设备，并向或从这些设备转发数据包。与路由器不同，交换机仅将数据发送到它打算发送的单个设备（可以是另一台交换机、路由器或用户的计算机），而不是发送到多个设备的网络。

可以将网络交换机的概念与铁路交换机进行比较。在铁路上，交换机是列车可以从一条轨道转换到另一条轨道的点。当列车需要移动到其他轨道以到达目的地时，铁路员工会激活交换机。与其类似，网络交换机将数据包移动到正确的“轨道”或网络路径上，以帮助数据到达其目的地。

## 交换机和路由器有什么区别？

[路由器](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-routing)选择数据包通过网络并到达其目的地的路径。路由器通过连接不同的网络并在网络之间转发数据（包括 LAN、广域网（WAN）或[自治系统](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-an-autonomous-system)，它们是组成 Internet 的大型网络）来实现此目的。

本质上，路由器在交换机组之间转发数据，而交换机在设备组之间转发数据。实际上，这意味着路由器对于 Internet 连接是必需的，而交换机对于互连设备是必需的。家庭和小型办公室需要路由器才能访问 Internet，但大多数不需要网络交换机，除非它们需要大量的 Ethernet 端口。但是，大型办公室、网络和数据中心通常确实需要交换机。

*以太网是用于在设备之间发送数据的第 2 层协议。与 WiFi 不同，以太网需要通过以太网电缆进行物理连接。**

## 什么是第 2 层交换机？什么是第 3 层交换机？

网络交换机可以在 [OSI](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/open-systems-interconnection-model-osi) 第 2 层（数据链路层）或第 3 层（ 网络层 ）上运行。第 2 层交换机根据目标 MAC 地址转发数据（有关定义，请参见下文），而第 3 层交换机则根据目标 IP 地址转发数据。某些交换机可以同时执行这两种操作。

因为它们基于 IP 地址转发数据，所以，第 3 层交换机还可以充当路由器，在网络之间来回发送数据。

## MAC 地址与 IP 地址有什么区别？

每个连接到 Internet 的设备都有一个 IP 地址。IP 地址是一系列字母数字字符，例如 192.0.2.255 或 2001:0db8:85a3:0000:0000:8a2e:0370:7334。IP 地址的作用就像一个邮件地址，使指向该地址的 Internet 通信能够到达该设备。IP 地址经常更改：由于 IPv4 地址数量有限，因此当用户设备与网络建立新连接时，通常会为其分配新的地址。

IP 地址用于第 3 层，这意味着 Internet 上的所有计算机和设备都使用 IP 地址发送和接收数据，无论它们连接到哪个网络。所有 IP 数据包的标头中都包含其源 IP 地址和目标 IP 地址，就像一封邮件具有目标地址和返回地址一样。

相反，MAC 地址是每个硬件的永久标识符，有点像序列号。与 IP 地址不同，MAC 地址不会更改。MAC 地址用于第 2 层，而不是第 3 层 - 这意味着它们不包含在 IP 数据包标头中。换句话说，MAC 地址不是 Internet 流量的一部分。

但是，网络交换机引用 MAC 地址以便将 Internet 流量发送到正确的设备。网络交换机使用一种称为 IGMP 侦听的技术将 IP 地址映射到 MAC 地址。如果没有此过程，交换机将无法将 IP 数据包发送到正确的设备。（尽管此过程称为“侦听”，但 IGMP 侦听是无害的，并且实际上是有用的。）

## 什么是非托管交换机？什么是托管交换机？

非托管交换机只是在 LAN 上创建更多的以太网端口，以便更多的本地设备可以访问 Internet。非托管交换机根据设备 MAC 地址来回传递数据。

托管交换机可以为更大的网络实现相同的功能，并为网络管理员提供更多控制流量优先级的方法。它们还使管理员能够设置虚拟 LAN（VLAN），以将本地网络进一步细分为较小的块。

## 什么是以太网交换机？

以太网交换机是提供多个以太网端口的第 2 层交换机。以太网交换机更加便于计算机、打印机和其他设备之间实现可靠互联。非托管以太网交换机通常用于扩展网络路由器提供的以太网端口的数量。
