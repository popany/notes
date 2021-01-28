# [How to Build a TCP Connection in Scapy](https://www.fir3net.com/Programming/Python/how-to-build-a-tcp-connection-in-scapy.html)

- [How to Build a TCP Connection in Scapy](#how-to-build-a-tcp-connection-in-scapy)
  - [PREVENT RST](#prevent-rst)
  - [CODE](#code)
  - [EXAMPLE](#example)

## PREVENT RST

At the point you send the SYN from Scapy and the SYN-ACK is returned. Because the Linux kernel receives the SYN-ACK but didn't send the SYN it will issue a RST. To prevent this IPtables can be used, using the syntax below,

    iptables -A OUTPUT -p tcp --tcp-flags RST RST -j DROP
    iptables -L

## CODE

In order to perform a 3WHS with Scapy the following code is used. 

    #!/usr/local/bin/python
    from scapy.all import *

    # VARIABLES
    src = sys.argv[1]
    dst = sys.argv[2]
    sport = random.randint(1024,65535)
    dport = int(sys.argv[3])

    # SYN
    ip=IP(src=src,dst=dst)
    SYN=TCP(sport=sport,dport=dport,flags='S',seq=1000)
    SYNACK=sr1(ip/SYN)

    # ACK
    ACK=TCP(sport=sport, dport=dport, flags='A', seq=SYNACK.ack, ack=SYNACK.seq + 1)
    send(ip/ACK)

## EXAMPLE

To run the script above (based on you saving the script as `3WHS.py`) the following syntax is used  `./3WHS.py <src ip> <dst ip> <dst port>`

Once run your see the following packets sent and received via a `tcpdump`,

    [root@client ~]# tcpdump -ni any port 443 -S
    14:53:14.402953 IP 172.16.120.5.62409 > 172.16.100.101.https: S 1000:1000(0) win 8192
    14:53:14.406422 IP 172.16.100.101.https > 172.16.120.5.62409: S 1629791522:1629791522(0) ack 1001 win 18484
    14:53:14.505963 IP 172.16.120.5.62409 > 172.16.100.101.https: . ack 1629791523 win 8192

    # 172.16.120.5 = client / 172.16.100.101 = server

On the server you will then see the connection estblished by running a netstat,

    [root@server ~]# netstat -anp | grep 443 | grep EST
    tcp        0      0 ::ffff:127.0.0.1:443        ::ffff:172.16.120.5:42375   ESTABLISHED 2611/httpd
