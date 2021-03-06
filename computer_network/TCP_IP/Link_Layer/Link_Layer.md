# Link layer

- [Link layer](#link-layer)
  - [整理](#整理)
    - [以太网](#以太网)
    - [802 标准集](#802-标准集)
    - [帧格式](#帧格式)
    - [MTU (最大传输单元)](#mtu-最大传输单元)

## 整理

### 以太网

- 1982 年联合公布

- 是当今 TCP/IP 采用的主要的局域网技术

- 采用 CSMA/CD (Carrier Sense, Multiple Access with Collision Detection, 即, 带冲突检测的载波侦听多路) 接入方法

- 速率为 10 Mb/s

- 地址为 48 bit

- IP 数据报封装定义在 [RFC 894](https://tools.ietf.org/html/rfc894)

- MTU = 1500

### 802 标准集

- IEEE(电子电气工程师协会) 802 委员会公布

- 802.3 标准

  - 针对整个 CSMA/CD 网络

  - 地址一般为 48 bit, 支持 16 bit

- 802.4 标准
  
  - 针对令牌总线网络

- 802.5 标准

  - 针对令牌环网络

- 802.2 标准

  - 定义前三者的通用特性

- IP 数据报封装定义在 [RFC 1042](https://tools.ietf.org/html/rfc1042)

- MTU = 1492

### 帧格式

    |<--------802.3 MAC-------->|<---802.2 LLC--->|<--802.2 SNAP--->|
    +---------+---------+-------+-----+-----+-----+---------+-------+---------------------------------+-----+
    |   DST   |   SRC   |Length |DSAP |SSAP |cntl |org code | Type  |              Data               | CRC |
    |         |         |       | AA  | AA  | 03  |   00    |       |                                 |     |
    +---------+---------+-------+-----+-----+-----+---------+-------+---------------------------------+-----+
         6         6        2   |  1     1     1       3        2                 38~1492             |  4
                                |                                                                     |
                                |                                                                     |
                                |                           +-------+---------------------------------+
                                |                           | Type  |           IP Datagram           |
                                |                           | 0800  |                                 |
                                |                           +-------+---------------------------------+
                                |                               2                 38~1492             |
                                |                                                                     |
                                |                           +-------+----------------------+----+     |
                                |                           | Type  | ARP Request/Response |PAD |     |
                                |                           | 0806  |                      |    |     |
                                |                           +-------+----------------------+----+     |
                                |                               2               28           10       |
                                |                                                                     |
                                |                           +-------+----------------------+----+     |
                                |                           | Type  |RARP Request/Response |PAD |     |
                                |                           | 0835  |                      |    |     |
                                |                           +-------+----------------------+----+     |
                                |                               2               28           10       |
                                |                                                                     |
                                |                                                                     |
                                |                                                                     |
                                |                                                                     |
                                |                                                                     |
                                |                                                                     |
                                |                                                                     |
                                |                                                                     |
    Ethernet encapsulation      |                                                                     |
    (RFC 894)                   |                                                                     |
    +---------+---------+-------+---------------------------------------------------------------------+-----+
    |   DST   |   SRC   | Type  |                                Data                                 | CRC |
    |         |         |       |                                                                     |     |
    +---------+---------+-------+---------------------------------------------------------------------+-----+
         6         6        2                                   46~1500                                  4
    
                        +-------+---------------------------------------------------------------------+
                        | Type  |                             IP Datagram                             |
                        | 0800  |                                                                     |
                        +-------+---------------------------------------------------------------------+
                            2                                   46~1500 

                        +-------+----------------------+----+
                        | Type  | ARP Request/Response |PAD |
                        | 0806  |                      |    |
                        +-------+----------------------+----+
                            2              28            18

                        +-------+----------------------+----+
                        | Type  |RARP Request/Response |PAD |
                        | 0835  |                      |    |
                        +-------+----------------------+----+
                            2              28            18

### MTU (最大传输单元)

- 数据链路层(OSI模型中对应第二层)所能通过的最大数据包大小(以字节为单位)

  - 数据包是OSI模型中对第三层的数据单位的称呼

- 与最大帧长度有关, 但不同
