# [什么是网络层？|网络与 Internet 层](https://www.cloudflare.com/zh-cn/learning/network-layer/what-is-the-network-layer/)

- [什么是网络层？|网络与 Internet 层](#什么是网络层网络与-internet-层)
  - [什么是网络？](#什么是网络)
  - [在网络层会发生什么？](#在网络层会发生什么)
  - [什么是数据包？](#什么是数据包)
  - [什么是 OSI 模型？](#什么是-osi-模型)
  - [OSI 模型与 TCP/IP 模型](#osi-模型与-tcpip-模型)
  - [网络层使用什么协议？](#网络层使用什么协议)

在 7 层 [OSI 模型](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/open-systems-interconnection-model-osi)（请参见下文）中，网络层是第 3 层。[互联网协议（IP）](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/internet-protocol)是该层使用的主要协议之一，另外还有一些其他的路由、测试和[加密](https://www.cloudflare.com/zh-cn/learning/ssl/what-is-encryption)协议。

## 什么是网络？

网络是连接起来的两台或多台计算设备群组。

## 在网络层会发生什么？

这包括设置数据包采用的路由，检查其他网络中的服务器是否在正常运行，以及寻址和接收来自其他网络的 IP 数据包。

## 什么是数据包？

通过 Internet 发送的所有数据都被分解为较小的块，称为“数据包”。

在网络层，当数据包通过 Internet 发出时，网络软件会在每个数据包上附加一个标头，另一方面，网络软件可以通过标头获知如何处理该数据包。

标头包含有关每个数据包的内容、源和目标的信息（有点像在信封上标记目的地和退回地址）。

## 什么是 OSI 模型？

开放系统互连（OSI）模型是对 Internet 工作方式的描述。它将通过 Internet 发送数据所涉及的功能分解为七层。

OSI 模型的七层包括：

- 应用程序层：由软件应用程序生成并可由其使用的数据。该层使用的主要协议是 [HTTP](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/hypertext-transfer-protocol-http)。
- 表示层：将数据转换为应用程序可以接受的形式。一些机构认为 [HTTPS](https://www.cloudflare.com/zh-cn/learning/ssl/what-is-https) 加密和解密在该层进行。
- 会话层：控制计算机之间的连接（这也可以通过 [TCP](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/tcp-ip) 协议在第 4 层进行处理）。
- 传输层：提供在两个连接方之间传输数据以及控制服务质量的方法。这里使用的主要协议是 TCP 和 [UDP](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/user-datagram-protocol-udp)。
- 网络层：处理不同网络之间的数据路由和发送。该层使用的最重要协议是 IP 和 ICMP。
- 数据链路层：处理同一网络上不同设备之间的通信。如果第 3 层是一封邮件中的地址，那么第 2 层就指明了该地址的办公室号或公寓号。以太网是此处最常用的协议。
- 物理层：数据包被转换为电脉冲、无线电脉冲或光脉冲，并以比特（信息的最小单位）的形式通过电线、无线电波或电缆进行传输。

请务必记住，OSI 模型是对使得 Internet 正常工作的众多流程的概念化的抽象描述，阐述模型以及将其应用到现实世界中的 Internet 时，有时是主观的。

OSI 模型有助于人们讨论网络设备和协议，确定哪些协议由哪些软件和硬件使用，并大致显示 Internet 的工作方式。但它并未严格地分步定义 Internet 连接的普遍运作方式。

## OSI 模型与 TCP/IP 模型

TCP/IP 模型是另一种 Internet 工作方式模型。它将涉及的流程分为四层，而不是七层。有人会认为 TCP/IP 模型更好地体现了当今 Internet 的工作方式，但人们理解 Internet 时仍会广泛参考 OSI 模型。两种模型都有其优缺点。

在 TCP/IP 模型中，四层包括：

- 应用程序层：这大约相当于 OSI 模型中的第 7 层。
- 传输层：对应于 OSI 模型中的第 4 层。
- Internet 层：对应于 OSI 模型中的第 3 层。
- 网络访问层：结合了 OSI 模型中第 1 层和第 2 层的流程。

## 网络层使用什么协议？

协议是公认的格式化数据的方式，以便两台或多台设备能够相互通信并相互理解。通过采用多种不同的协议，可以在网络层进行连接、测试、路由和加密，其中包括：

- IP
- IPsec
- ICMP
- IGMP
- GRE
