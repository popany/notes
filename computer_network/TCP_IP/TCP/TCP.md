# TCP

- [TCP](#tcp)
  - [Checksum](#checksum)
  - [整理](#整理)
    - [序号](#序号)
    - [SYN](#syn)
      - [SYN 报文占一个序号, ACK 报文不占序号](#syn-报文占一个序号-ack-报文不占序号)
    - [ACK](#ack)
    - [MSS(最大分段大小)](#mss最大分段大小)
    - [PUSH](#push)
    - [校验和](#校验和)
    - [没有选择确认或否认的滑动窗口协议](#没有选择确认或否认的滑动窗口协议)
    - [紧急指针](#紧急指针)
    - [MSL](#msl)
    - [RTT](#rtt)
    - [通路容量](#通路容量)
    - [缓冲区](#缓冲区)
      - [发送缓冲区](#发送缓冲区)
      - [接收缓冲区](#接收缓冲区)
    - [低水位](#低水位)
      - [发送低水位](#发送低水位)
      - [接收低水位](#接收低水位)
    - [SO_REUSEADDR / SO_REUSEPORT](#so_reuseaddr--so_reuseport)
      - [SO_REUSEADDR](#so_reuseaddr)
      - [SO_REUSEPORT](#so_reuseport)
    - [keep-alive](#keep-alive)
    - [异常终止连接](#异常终止连接)
    - [半打开连接](#半打开连接)
    - [呼入连接请求队列 (Incoming Connection Queue)](#呼入连接请求队列-incoming-connection-queue)
    - [慢启动](#慢启动)
    - [定时器](#定时器)
      - [重传定时器](#重传定时器)
      - [坚持(persist)定时器](#坚持persist定时器)
      - [保活(keepalive)定时器](#保活keepalive定时器)
      - [2MSL定时器](#2msl定时器)
  - [References](#references)
    - [What is Maximum Segment Lifetime (MSL) in TCP?](#what-is-maximum-segment-lifetime-msl-in-tcp)
    - [TCP 常用总结](#tcp-常用总结)
    - [[How many times will TCP retransmit]](#how-many-times-will-tcp-retransmit)

## Checksum

[The TCP/IP Checksum](https://locklessinc.com/articles/tcp_checksum/)

[If TCP is a reliable data transfer method, then how come its checksum is not 100% reliable?](https://networkengineering.stackexchange.com/questions/52200/if-tcp-is-a-reliable-data-transfer-method-then-how-come-its-checksum-is-not-100)

[Can a TCP checksum fail to detect an error? If yes, how is this dealt with?](https://stackoverflow.com/questions/3830206/can-a-tcp-checksum-fail-to-detect-an-error-if-yes-how-is-this-dealt-with)

## 整理

### 序号

序号是32 bit的无符号数，序号到达 $2^{32}-1$ 后又从 $0$ 开始

### SYN

#### SYN 报文占一个序号, ACK 报文不占序号

    # tcpdump -i any -#nnSU src port 5555
    tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
    listening on any, link-type LINUX_SLL (Linux cooked v1), capture size 262144 bytes
        1  23:13:30.652477 IP 127.0.0.1.5555 > 127.0.0.1.54694: Flags [S.], seq 2019922733, ack 3438172193, win 65483, options [mss 65495,sackOK,TS val 843611648 ecr 843611648,nop,wscale 7], length 0
        2  23:13:52.677322 IP 127.0.0.1.5555 > 127.0.0.1.54694: Flags [.], ack 3438172195, win 512, options [nop,nop,TS val 843633672 ecr 843633672], length 0
        3  23:14:12.674988 IP 127.0.0.1.5555 > 127.0.0.1.54694: Flags [P.], seq 2019922734:2019922736, ack 3438172195, win 512, options [nop,nop,TS val 843653670 ecr 843633672], length 2

上面示例中

1 为三次握手服务端回给客户端的 SYN+ACK 报文, 序号为 2019922733.

2 为服务端收到客户端第一个报文后回复的 ACK 报文, 这里没有显示序号, 实际上此报文中的序号依然为 2019922733.

3 为服务端首次向客户端发送数据对应的报文, 此报文中的序号为 2019922734, 即 SYN+ACK 报文的序号+1(即, SYN报文占一个序号).

注意: SYN 标志仅在三次握手中有效

### ACK

- ACK 序号为期望对端下次发送的序号值

- ACK 是累积的

  - 接收方不必确认每一个收到的分组

  - ACK 表示接收方已经正确收到了确认序号之前的所有字节

- ACK 可用于报告窗口张开

### MSS(最大分段大小)

- TCP 首部选项中的一个参数

- 一个 TCP 分段可传输的最大数据量(不包括 TCP 首部)

- 每个连接方通常都在通信的第一个报文段(设置SYN标志)中指明这个选项

### PUSH

- 发送方使用

  - 通知接收方将所收到的数据全部提交给接收进程

    - 包括与 PUSH 一起传送的数据以及接收方之前收到的数据

  - 大多数的 TCP 实现没有提供设置 PUSH 标志的 API

    - 许多实现认为 PUSH 标志已经过时

    - 一个好的 TCP 实现能够自行决定何时设置这个标志

    - 伯克利实现

      - 如果待发送数据将清空发送缓存, 则自动设置 PUSH 标志

      - 不将接收到的数据推迟交付给应用程序

        - 忽略所接收的 PUSH 标志

      - 未提供相关 API

        - 无法使用 API 通知 TCP 设置正在接收数据的 PUSH 标志

        - 或确定该数据是否被设置了 PUSH 标志

### 校验和

- 计算校验和时会包括一个伪首部

### 没有选择确认或否认的滑动窗口协议

- 没有选择确认

  如果 1~1024 字节已经成功收到, 下一报文段中包含序号从 2049~3072的字节, 收端并不能确认这个新的报文段. 它所能做的就是发回一个确认序号为 1025 的 ACK

- 没有否认

 如果收到包含 1025~2048 字节的报文段, 但它的检验和错, TCP 接收端所能做的就是发回一个确认序号为 1025 的 ACK

- 滑动窗口协议

  - 接收窗口

    - 又称 Receiver Window, rwnd, advertised window, 通告窗口, offered window

    - 为接收方流量控制所用

### 紧急指针

- URG 标志置 1 时紧急指针才有效

- 是一个正的偏移量, 和序号字段中的值相加表示紧急数据最后一个字节的序号

### MSL

- Maximum Segment Lifetime

- 报文最大生存时间

- RFC 793中规定 MSL 为 2 分钟, 实际应用中常用的是 30 秒，1 分钟和 2 分钟等

### RTT

- Round-Trip Time, 往返时间

- 发送方发送报文段到接收到该报文段数据的 ACK 经过的时间

  - 发送报文段与 ACK 可能不是一一对应

    - 但对应发送报文段的 ACK 要覆盖发送报文段的数据

### 通路容量

- 带宽时延乘积

### 缓冲区

#### 发送缓冲区

- SO_SNDBUF

- 对比 UDP, UDP 不需要发送缓冲区(不需要重发)

- 发送缓冲区满时会导致写入线程阻塞

- 收到对端 ACK 数据段后, 本端才会丢弃已确认的数据段

#### 接收缓冲区

- SO_RCVBUF

- 滑动窗口控制接收缓冲区不溢出, 若发送方无视滑动窗口大小发送了超出滑动窗口的数据段, 则该数据段被丢弃

- 对比 UDP, UDP 没有流量控制, 接收缓冲区慢时, 数据报会被丢弃

### 低水位

#### 发送低水位

- 接收缓冲区中的可用空间超过发送低水位, 内核通知进程"可写"(比如通过 select/epoll)

- 默认为 2048 字节

#### 接收低水位

- 接收缓冲区中的数据超过接收低水位, 内核通知进程"可读"(比如通过 select/epoll)

- 默认为 1 字节

### SO_REUSEADDR / SO_REUSEPORT

#### SO_REUSEADDR

- 若 TCP 状态为 TIME_WAIT, 则可以重用端口

- 一个套接字由五元组构成: 协议、本地地址、本地端口、远程地址、远程端口. SO_REUSEADDR 仅仅表示可以重用本地本地地址、本地端口

- 可能导致程序收到非期望数据

- 须慎重

#### [SO_REUSEPORT](https://my.oschina.net/miffa/blog/390931)

### keep-alive

- 默认为 2 小时

- 真实的网络很复杂, 可能存在各种原因导致 keep-alive 失效

- 通过在空闲时发送 keep-alive 数据段, 并接收 keep-alive ACK 实现

### 异常终止连接

若设置 socket 的 `SO_LINGER` 超时时间为 0, 则调用 `close` 函数后

- 对端会收到 RST 报文段

- 发送队列中残留的数据段会被丢弃

### 半打开连接

- 任何一端主机异常都可能导致发生该情况

- 只要不打算在半打开连接上传输数据, 仍处于连接状态的一方就不会检测另一方已经出现异常

### 呼入连接请求队列 (Incoming Connection Queue)

- 该队列中的连接已被 TCP 接收(三次握手完成)

- 该队列中的连接还没有被应用层接受 (调用 `accept`)

- 该队列的最大长度: backlog (积压值)

- 应用层接受连接前, 对端发送的数据会被放入缓冲队列

- 若该队列已满, TCP 不会处理收到的 SYN, 也不会发回任何报文段, 客户端主动打开将超时

### 慢启动

- 拥塞窗口

  - 又称 congestion window, cwnd

  - 初始化为对端通告的报文段大小 (MSS?)

  - 每收到 1 个 ACK, 则增加 1 个报文段大小

  - 为发送方流量控制所用

    - 发送方取拥塞窗口与通告窗口中的最小值作为发送上限

### 定时器

#### 重传定时器

- 重传超时(RTO, Retransmission Time Out)

  - 根据 RTT 的均值与方差计算

  - 根据指数退避计算下次重传时间

    - 最大 64 秒

  - 默认最大重传次数: 15

#### 坚持(persist)定时器

- 发送方使用

- 收到关闭窗口 ACK 后设置

- 目的为防止打开窗口 ACK 丢失

- 窗口探查报文段

  - 发送方发送

  - 包含 1 字节数据

  - 发送间隔(秒)
  
    5, 6, 12, 24, 48, 60, ... 60

  - 持续发送

    直到窗口开口或连接关闭

#### 保活(keepalive)定时器

- 保活定时器不属于 TCP 规范

  - 理由

    - 出现短暂差错的情况下, 这可能会使一个非常好的连接释放掉

    - 耗费不必要的带宽

    - 在按分组计费的情况下会在互联网上花掉更多的钱

- 探查报文段

  - 两小时发送一次

  - 若没有收到响应, 则按 75 秒间隔发送, 最多发送 10 次

- 异常情况

  - 对端崩溃但未重启

    错误信息为: 连接超时

  - 对端崩溃并重启

    错误信息为: 连接被对端复位

  - 线路故障

    错误信息为: 没有到达主机的路由

#### 2MSL定时器

## References

### [What is Maximum Segment Lifetime (MSL) in TCP?](https://stackoverflow.com/questions/289194/what-is-maximum-segment-lifetime-msl-in-tcp)

### [TCP 常用总结](https://www.cnblogs.com/abelian/p/6135042.html)

### [How many times will TCP retransmit]

f the server program crashes, the kernel will clean up all open sockets appropriately. (Well, appropriate from a TCP point of view; it might violate the application layer protocol, but applications should be prepared for this event.)

If the server kernel crashes and does not come back up, the number and timing of retries depends if the socket were connected yet or not:

    tcp_retries1 (integer; default: 3; since Linux 2.2)
           The number of times TCP will attempt to
           retransmit a packet on an established connection
           normally, without the extra effort of getting
           the network layers involved.  Once we exceed
           this number of retransmits, we first have the
           network layer update the route if possible
           before each new retransmit.  The default is the
           RFC specified minimum of 3.

    tcp_retries2 (integer; default: 15; since Linux 2.2)
           The maximum number of times a TCP packet is
           retransmitted in established state before giving
           up.  The default value is 15, which corresponds
           to a duration of approximately between 13 to 30
           minutes, depending on the retransmission
           timeout.  The RFC 1122 specified minimum limit
           of 100 seconds is typically deemed too short.

(From [tcp(7)](https://man7.org/linux/man-pages/man7/tcp.7.html).)

If the server kernel crashes and does come back up, it won't know about any of the sockets, and will `RST` those follow-on packets, enabling failure much faster.

If any single-point-of-failure routers along the way crash, if they come back up quickly enough, the connection may continue working. This would require that firewalls and routers be stateless, or if they are [stateful](http://en.wikipedia.org/wiki/Stateful_firewall), have rulesets that allow preexisting connections to continue running. (Potentially unsafe, different firewall admins have different policies about this.)

The failures are returned to the program with `errno` set to `ECONNRESET` (at least for [send(2)](https://www.man7.org/linux/man-pages/man2/send.2.html)).
