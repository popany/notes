# TCP

- [TCP](#tcp)
  - [Checksum](#checksum)
  - [整理](#整理)
    - [SYN 报文占一个序号, ACK 报文不占序号](#syn-报文占一个序号-ack-报文不占序号)
    - [ACK 序号为期望对端下次发送的序号值](#ack-序号为期望对端下次发送的序号值)
    - [MSS(最大分段大小)](#mss最大分段大小)
    - [校验和](#校验和)
    - [没有选择确认或否认的滑动窗口协议](#没有选择确认或否认的滑动窗口协议)
    - [紧急指针](#紧急指针)
    - [MSL](#msl)

## Checksum

[The TCP/IP Checksum](https://locklessinc.com/articles/tcp_checksum/)

[If TCP is a reliable data transfer method, then how come its checksum is not 100% reliable?](https://networkengineering.stackexchange.com/questions/52200/if-tcp-is-a-reliable-data-transfer-method-then-how-come-its-checksum-is-not-100)

[Can a TCP checksum fail to detect an error? If yes, how is this dealt with?](https://stackoverflow.com/questions/3830206/can-a-tcp-checksum-fail-to-detect-an-error-if-yes-how-is-this-dealt-with)

## 整理

### SYN 报文占一个序号, ACK 报文不占序号

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

### ACK 序号为期望对端下次发送的序号值

### MSS(最大分段大小)

- TCP 首部选项中的一个参数

- 一个 TCP 分段可传输的最大数据量(不包括 TCP 首部)

- 每个连接方通常都在通信的第一个报文段(设置SYN标志)中指明这个选项

### 校验和

- 计算校验和时会包括一个伪首部

### 没有选择确认或否认的滑动窗口协议

- 没有选择确认

  如果 1~1024 字节已经成功收到, 下一报文段中包含序号从 2049~3072的字节, 收端并不能确认这个新的报文段. 它所能做的就是发回一个确认序号为 1025 的 ACK

- 没有否认

 如果收到包含 1025~2048 字节的报文段, 但它的检验和错, TCP 接收端所能做的就是发回一个确认序号为 1025 的 ACK

- 滑动窗口

### 紧急指针

- URG 标志置 1 时紧急指针才有效

- 是一个正的偏移量, 和序号字段中的值相加表示紧急数据最后一个字节的序号

### MSL

- Maximum Segment Lifetime

- 报文最大生存时间

- RFC 793中规定 MSL 为 2 分钟, 实际应用中常用的是 30 秒，1 分钟和 2 分钟等


