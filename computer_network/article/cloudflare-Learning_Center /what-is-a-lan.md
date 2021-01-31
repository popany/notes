# [什么是 LAN (局域网)？](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-a-lan/)

- [什么是 LAN (局域网)？](#什么是-lan-局域网)
  - [“LAN” 代表什么？](#lan-代表什么)
  - [LAN 如何工作？](#lan-如何工作)
  - [搭建 LAN 需要什么设备？](#搭建-lan-需要什么设备)
  - [什么是虚拟机？](#什么是虚拟机)
  - [LAN 和 WAN 有什么区别？](#lan-和-wan-有什么区别)
  - [LAN 与互联网的其余部分有何关系？](#lan-与互联网的其余部分有何关系)

## “LAN” 代表什么？

LAN 代表局域网。[网络](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-the-network-layer)是由两个或两个以上相连的计算机组成，LAN 是包含在较小地理区域内的网络，通常位于同一建筑物内。家庭 WiFi 网络和小型企业网络是常见的 LAN 示例。LAN 规模也可以相当大，尽管如果它们占用多座建筑物，通常会将它们划归为广域网（WAN）或城域网（MAN）更准确。

## LAN 如何工作？

大多数 LAN 是从一个中心位置连接到[互联网](https://www.cloudflare.com/zh-cn/learning/network-layer/how-does-the-internet-work)，即[路由器](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-routing)。家庭 LAN 通常使用单个路由器，而较大空间中的 LAN 可能另外使用[网络交换机](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-a-network-switch) ，以提高数据包传输效率。

LAN 几乎总是使用以太网、WiFi 或同时使用两者来连接网络中的设备。以太网是用于物理网络连接的协议，需要使用以太网电缆。WiFi 是通过无线电波连接到网络的协议。

各种各样的设备都可以连接到 LAN，包括服务器、台式计算机、笔记本电脑、打印机、IoT 设备，甚至游戏机。在办公室，LAN 通常用于为内部员工提供对连接的打印机或服务器的共享访问。

## 搭建 LAN 需要什么设备？

连接到互联网的最简单LAN，仅需一台**路由器**和一种将计算设备连接到路由器的方式，如通过以太网电缆或 WiFi 热点。无互联网连接的 LAN 需要交换机来交换数据。大型 LAN（例如大型办公大楼中的 LAN）可能需要其他**路由器或交换机**，才能更有效地将数据转发到正确的设备。

并非所有的 LAN 都连接到互联网。实际上，LAN 要早于互联网：二十世纪 70 年代末，LAN 首次用在企业当中。（这些旧的 LAN 所使用的网络协议如今已不再使用。）搭建 LAN 的唯一要求是所连接的设备能够交换数据。这通常需要一台用于交换数据包的网络设备，例如网络交换机。如今，即使不与互联网连接的 LAN，也使用互联网上的相同网络协议（例如 IP ）。

## 什么是虚拟机？

虚拟 LAN 或 VLAN 是一种将同一物理网络上的流量划分到两个网络的方法。想象一下，在同一房间内设置两个单独的 LAN，每个 LAN 都有自己的路由器和互联网连接。VLAN 就是这样，但是它们实际上是使用软件而不是物理上的硬件进行划分的 - 仅需要一台连接互联网的路由器。

VLAN 有助于网络管理，特别是对于超大型 LAN。通过细分网络，管理员可以更轻松地管理网络。（VLAN 与[子网](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-a-subnet)完全不同，后者是将网络细分以提高效率的另一种方法。）

## LAN 和 WAN 有什么区别？

WAN 或称广域网，是相互连接的 LAN 的集合。它是本地网络的广泛网络。WAN 可以是任何大小，甚至数千英里宽。它不限于指定的区域。

## LAN 与互联网的其余部分有何关系？

互联网是网络的网络。LAN 通常连接到更大的网络，即[自治系统（AS）](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-an-autonomous-system)。AS 是具有自己的路由策略并控制某些IP地址的超大型网络。互联网服务提供商（ISP）是 AS 的一个示例。

将 LAN 想象成一个小型网络，它连接到更大的网络，又连接到其他非常大的网络，所有这些网络都包含 LAN。这就是互联网，连接到相距数千英里的两个不同 LAN 的两台计算机可以通过网络之间的这些连接发送数据来彼此通信。
