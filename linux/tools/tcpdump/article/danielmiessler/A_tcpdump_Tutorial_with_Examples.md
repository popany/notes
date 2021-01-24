# [A tcpdump Tutorial with Examples](https://danielmiessler.com/study/tcpdump/)

- [A tcpdump Tutorial with Examples](#a-tcpdump-tutorial-with-examples)
  - [Examples](#examples)
    - [everything on an interface](#everything-on-an-interface)
    - [find traffic by ip](#find-traffic-by-ip)
    - [filtering by source and/or destination](#filtering-by-source-andor-destination)
    - [finding packets by network](#finding-packets-by-network)
    - [get packet contents with hex output](#get-packet-contents-with-hex-output)
    - [show traffic related to a specific port](#show-traffic-related-to-a-specific-port)
    - [show traffic of one protocol](#show-traffic-of-one-protocol)
    - [show only ip6 traffic](#show-only-ip6-traffic)
    - [find traffic using port ranges](#find-traffic-using-port-ranges)
    - [find traffic based on packet size](#find-traffic-based-on-packet-size)
    - [reading / writing captures to a file (pcap)](#reading--writing-captures-to-a-file-pcap)
  - [advanced](#advanced)
    - [More options](#more-options)
  - [It’s All About the Combinations](#its-all-about-the-combinations)
    - [raw output view](#raw-output-view)
    - [from specific ip and destined for a specific port](#from-specific-ip-and-destined-for-a-specific-port)
    - [from one network to another](#from-one-network-to-another)
    - [non icmp traffic going to a specific ip](#non-icmp-traffic-going-to-a-specific-ip)
    - [traffic from a host that isn’t on a specific port](#traffic-from-a-host-that-isnt-on-a-specific-port)
  - [isolate tcp flags](#isolate-tcp-flags)
    - [Isolate TCP RST flags](#isolate-tcp-rst-flags)
    - [Isolate TCP SYN flags](#isolate-tcp-syn-flags)
    - [Isolate packets that have both the SYN and ACK flags set](#isolate-packets-that-have-both-the-syn-and-ack-flags-set)
    - [Isolate TCP URG flags](#isolate-tcp-urg-flags)
    - [Isolate TCP ACK flags](#isolate-tcp-ack-flags)
  - [everyday recipe examples](#everyday-recipe-examples)
    - [both syn and rst set](#both-syn-and-rst-set)
    - [find http user agents](#find-http-user-agents)
    - [cleartext get requests](#cleartext-get-requests)
    - [find http host headers](#find-http-host-headers)
    - [find http cookies](#find-http-cookies)
    - [find ssh connections](#find-ssh-connections)
    - [find dns traffic](#find-dns-traffic)
    - [find ftp traffic](#find-ftp-traffic)
    - [find ntp traffic](#find-ntp-traffic)
    - [find cleartext passwords](#find-cleartext-passwords)
    - [find traffic with evil bit](#find-traffic-with-evil-bit)
  - [summary](#summary)

`tcpdump` is without question the premier network analysis tool because it provides both power and simplicity in one interface.
my other tutorials

This tutorial will show you how to isolate traffic in various ways—from IP, to port, to protocol, to application-layer traffic—to make sure you find exactly what you need as quickly as possible.

> tcpdump is the tool everyone should learn as their base for packet analysis.

Let’s start with a basic command that will get us HTTPS traffic:

> Install tcpdump with apt install tcpdump (Ubuntu), or yum install tcpdump (Redhat/Centos)

    tcpdump -nnSX port 443

    04:45:40.573686 IP 78.149.209.110.27782 > 172.30.0.144.443: Flags [.], ack 
    278239097, win 28, options [nop,nop,TS val 939752277 ecr 1208058112], length 0
        0x0000:  4500 0034 0014 0000 2e06 c005 4e8e d16e  E..4........N..n
        0x0010:  ac1e 0090 6c86 01bb 8e0a b73e 1095 9779  ....l......>...y
        0x0020:  8010 001c d202 0000 0101 080a 3803 7b55  ............8.{U
        0x0030:  4801 8100

> You can get a single packet with `-c 1`, or n number with `-c n`.

This showed some HTTPS traffic, with a hex display visible on the right portion of the output (alas, it’s encrypted). Just remember—when in doubt, run the command above with the port you’re interested in, and you should be on your way.

## Examples

Now that you are able to get basic traffic, let’s step through numerous examples that you are likely to need during your job in networking, security, or as any type of PacketWizard™.

### everything on an interface

Just see what’s going on, by looking at what’s hitting your interface.

> Or get all interfaces with `-i any`.

    tcpdump -i eth0

### find traffic by ip

One of the most common queries, using `host`, you can see traffic that’s going to or from 1.1.1.1.

> - Expression Types:
>
>   `host`, `net`, and `port`.
>
> - Directions:
>
>   `src` and `dst`.
>
> - Types:
>
>   `host`, `net`, and `port`.
>
> - Protocols:
>
>   `tcp`, `udp`, `icmp`, and many more.

    tcpdump host 1.1.1.1

    06:20:25.593207 IP 172.30.0.144.39270 > one.one.one.one.domain: 
    12790+ A? google.com. 
    (28) 06:20:25.594510 IP one.one.one.one.domain > 172.30.0.144.39270: 
    12790 1/0/0 A 172.217.15.78 (44)

### filtering by source and/or destination

If you only want to see traffic in one direction or the other, you can use `src` and `dst`.

    tcpdump src 1.1.1.1
    tcpdump dst 1.0.0.1

### finding packets by network

To find packets going to or from a particular network or subnet, use the `net` option.

> You can combine this with the `src` and `dst` options as well.

    tcpdump net 1.2.3.0/24

### get packet contents with hex output

Hex output is useful when you want to see the content of the packets in question, and it’s often best used when you’re isolating a few candidates for closer scrutiny.

    tcpdump -c 1 -X icmp

### show traffic related to a specific port

> Common Options:
>
> - `-nn` : Don’t resolve hostnames or port names.
>
> - `-S` : Get the entire packet.
>
> - `-X` : Get hex output.

You can find specific port traffic by using the port option followed by the port number.

    tcpdump port 3389
    tcpdump src port 1025

### show traffic of one protocol

If you’re looking for one particular kind of traffic, you can use tcp, udp, icmp, and many others as well.

    tcpdump icmp

### show only ip6 traffic

You can also find all IP6 traffic using the protocol option.

    tcpdump ip6

### find traffic using port ranges

You can also use a range of ports to find traffic.

    tcpdump portrange 21-23

### find traffic based on packet size

If you’re looking for packets of a particular size you can use these options. You can use less, greater, or their associated symbols that you would expect from mathematics.

    tcpdump less 32
    tcpdump greater 64
    tcpdump <= 128

### reading / writing captures to a file (pcap)

It’s often useful to save packet captures into a file for analysis in the future. These files are known as PCAP (PEE-cap) files, and they can be processed by hundreds of different applications, including network analyzers, intrusion detection systems, and of course by `tcpdump` itself. Here we’re writing to a file called `capture_file` using the `-w` switch.

    tcpdump port 80 -w capture_file

You can read PCAP files by using the `-r` switch. Note that you can use all the regular commands within tcpdump while reading in a file; you’re only limited by the fact that you can’t capture and process what doesn’t exist in the file already.

    tcpdump -r capture_file

## advanced

Now that we’ve seen what we can do with the basics through some examples, let’s look at some more advanced stuff.

### More options

Here are some additional ways to tweak how you call `tcpdump`.

- `-X` : Show the packet’s contents in both hex and ascii.

- `-XX` : Same as `-X`, but also shows the ethernet header.

- `-D` : Show the list of available interfaces

- `-l` : Line-readable output (for viewing as you save, or sending to other commands)

- `-q` : Be less verbose (more quiet) with your output.

- `-t` : Give human-readable timestamp output.

- `-tttt` : Give maximally human-readable timestamp output.

- `-i eth0` : Listen on the eth0 interface.

- `-vv` : Verbose output (more v’s gives more output).

- `-c` : Only get x number of packets and then stop.

- `-s` : Define the snaplength (size) of the capture in bytes. Use `-s0` to get everything, unless you are intentionally capturing less.

- `-S` : Print absolute sequence numbers.

- `-e` : Get the ethernet header as well.

- `-q` : Show less protocol information.

- `-E` : Decrypt IPSEC traffic by providing an encryption key.

## It’s All About the Combinations

Being able to do these various things individually is powerful, but the real magic of `tcpdump` comes from the ability to **combine options in creative ways** in order to isolate exactly what you’re looking for. There are three ways to do combinations, and if you’ve studied programming at all they’ll be pretty familiar to you.

1. AND

   `and` or `&&`

2. OR

   `or` or `||`

3. EXCEPT

   `not` or `!`

### raw output view

Use this combination to see verbose output, with no resolution of hostnames or port numbers, using absolute sequence numbers, and showing human-readable timestamps.

    tcpdump -ttnnvvS

Here are some examples of combined commands.

### from specific ip and destined for a specific port

Let’s find all traffic from 10.5.2.3 going to any host on port 3389.

    tcpdump -nnvvS src 10.5.2.3 and dst port 3389

### from one network to another

Let’s look for all traffic coming from 192.168.x.x and going to the 10.x or 172.16.x.x networks, and we’re showing hex output with no hostname resolution and one level of extra verbosity.

    tcpdump -nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16

### non icmp traffic going to a specific ip

This will show us all traffic going to 192.168.0.2 that is not ICMP.

    tcpdump dst 192.168.0.2 and src net and not icmp

### traffic from a host that isn’t on a specific port

This will show us all traffic from a host that isn’t SSH traffic (assuming default port usage).

    tcpdump -vv src mars and not dst port 22

As you can see, you can build queries to find just about anything you need. The key is to first figure out precisely what you’re looking for and then to build the syntax to isolate that specific type of traffic.

Keep in mind that when you’re building complex queries you **might have to group your options using single quotes**. Single quotes are used in order to tell `tcpdump` to ignore certain special characters—in this case below the “( )” brackets. This same technique can be used to group using other expressions such as `host`, `port`, `net`, `etc`.

    tcpdump 'src 10.0.2.4 and (dst port 3389 or 22)'

## isolate tcp flags

You can also use filters to isolate packets with specific TCP flags set.

### Isolate TCP RST flags

> The filters below find these various packets because `tcp[13]` looks at offset 13 in the TCP header, the number represents the location within the byte, and the !=0 means that the flag in question is set to 1, i.e. it’s on.

    tcpdump 'tcp[13] & 4!=0'
    tcpdump 'tcp[tcpflags] == tcp-rst'

### Isolate TCP SYN flags

tcpdump 'tcp[13] & 2!=0'
tcpdump 'tcp[tcpflags] == tcp-syn'

### Isolate packets that have both the SYN and ACK flags set

    tcpdump 'tcp[13]=18'

> Only the PSH, RST, SYN, and FIN flags are displayed in `tcpdump`'s flag field output. URGs and ACKs are displayed, but they are shown elsewhere in the output rather than in the flags field.

### Isolate TCP URG flags

    tcpdump 'tcp[13] & 32!=0'
    tcpdump 'tcp[tcpflags] == tcp-urg'

### Isolate TCP ACK flags

tcpdump 'tcp[13] & 16!=0'
tcpdump 'tcp[tcpflags] == tcp-ack'

Isolate TCP PSH flags.
tcpdump 'tcp[13] & 8!=0'
tcpdump 'tcp[tcpflags] == tcp-push'

Isolate TCP FIN flags.
tcpdump 'tcp[13] & 1!=0'
tcpdump 'tcp[tcpflags] == tcp-fin'

## everyday recipe examples

> Because tcpdump can output content in ASCII, you can use it to search for cleartext content using other command-line tools like `grep`.

Finally, now that we the theory out of the way, here are a number of quick recipes you can use for catching various kinds of traffic.

### both syn and rst set

    tcpdump 'tcp[13] = 6'

### find http user agents

> The `-l` switch lets you see the traffic as you’re capturing it, and helps when sending to commands like `grep`.

    tcpdump -vvAls0 | grep 'User-Agent:'

### cleartext get requests

    tcpdump -vvAls0 | grep 'GET'

### find http host headers

    tcpdump -vvAls0 | grep 'Host:'

### find http cookies

    tcpdump -vvAls0 | grep 'Set-Cookie|Host:|Cookie:'

### find ssh connections

This one works regardless of what port the connection comes in on, because it’s getting the banner response.

    tcpdump 'tcp[(tcp[12]>>2):4] = 0x5353482D'

### find dns traffic

    tcpdump -vvAs0 port 53

### find ftp traffic

    tcpdump -vvAs0 port ftp or ftp-data

### find ntp traffic

    tcpdump -vvAs0 port 123

### find cleartext passwords

    tcpdump port http or port ftp or port smtp or port imap or port pop3 or port telnet -lA | egrep -i -B5 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd= |password=|pass:|user:|username:|password:|login:|pass |user '

### find traffic with evil bit

There’s a bit in the IP header that never gets set by legitimate applications, which we call the “Evil Bit”. Here’s a fun filter to find packets where it’s been toggled.

    tcpdump 'ip[6] & 128 != 0'

> Check out [my other tutorials](https://danielmiessler.com/study/) as well.

## summary

Here are the takeaways.

1. `tcpdump` is a valuable tool for anyone looking to get into networking or [information security](https://danielmiessler.com/information-security/).

2. The raw way it interfaces with traffic, combined with the precision it offers in inspecting packets make it the best possible tool for learning TCP/IP.

3. Protocol Analyzers like Wireshark are great, but if you want to truly master packet-fu, you must become one with `tcpdump` first.

Well, this primer should get you going strong, but [the man page](https://www.tcpdump.org/manpages/tcpdump.1.html) should always be handy for the most advanced and one-off usage scenarios. I truly hope this has been useful to you, and feel free to [contact me](https://danielmiessler.com/about/) if you have any questions.
