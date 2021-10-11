# Architecture and Programming

- [Architecture and Programming](#architecture-and-programming)
  - [Introduction](#introduction)
  - [ExaNIC Internals](#exanic-internals)
    - [Receive architecture](#receive-architecture)
    - [Transmit architecture](#transmit-architecture)
  - [ExaNIC Sockets (exasock) Usage](#exanic-sockets-exasock-usage)
    - [Software installation](#software-installation)
    - [Usage](#usage)
    - [Displaying Exanic sockets accelerated connections](#displaying-exanic-sockets-accelerated-connections)
    - [Disabling acceleration per-socket](#disabling-acceleration-per-socket)
    - [Multicast sockets](#multicast-sockets)
    - [TCP acceleration](#tcp-acceleration)
    - [Frame warming](#frame-warming)
    - [Known issues and limitations](#known-issues-and-limitations)
    - [Tips for best performance](#tips-for-best-performance)
  - [ExaNIC Library (libexanic) Usage](#exanic-library-libexanic-usage)
    - [Quick start](#quick-start)

## [Introduction](https://exablaze.com/docs/exanic/user-guide/programming/)

This section of the user guide describes how to use the Cisco Nexus SmartNIC (formerly ExaNIC) as a developer. There are at least three different APIs that can be used depending on requirements:

- Existing sockets applications can be accelerated with the exasock TCP/UDP acceleration library. Generally this is simply a matter of running the application with the `exasock` command. For more details and known limitations, see the [exasock usage guide](https://exablaze.com/docs/exanic/user-guide/sockets/).

- Sending and receiving packets with low latency using the SmartNIC API library (`libexanic`). Refer to the [internals primer](https://exablaze.com/docs/exanic/user-guide/internals) for an introduction to the architecture of SmartNIC cards, and the [libexanic usage guide](https://exablaze.com/docs/exanic/user-guide/libexanic/) for API details. It is possible to use `libexanic` simultaneously with `exasock` (e.g. receiving UDP frames with `libexanic` and sending TCP frames with `exasock`), and it is also possible to use `exasock` to pre-build TCP frames and then send them using `libexanic` (see the [TCP acceleration](https://exablaze.com/docs/exanic/user-guide/sockets/#tcp-acceleration) section).

- Writing your own logic to run on the SmartNIC card's FPGA using the SmartNIC FDK. For more information refer to the [FDK documentation](https://exablaze.com/docs/exanic/user-guide/fdk_v2). Note that the FDK is an optional component that is licensed separately. When running a custom firmware image, all network interfaces are still exposed to software (subject to filtering by the user FPGA logic), so the normal software APIs are still available.

## [ExaNIC Internals](https://exablaze.com/docs/exanic/user-guide/internals/)

One of the key differences between a Cisco Nexus SmartNIC (formerly ExaNIC) and most other network cards is that the SmartNIC is optimised for the lowest possible latency. This focus on latency comes with a few design decisions that differ from conventional NICs.

### Receive architecture

To keep latency low, there is very little buffering done by SmartNIC cards, with data received from the network sent through to host memory as soon as possible. This could be considered an extreme version of "cut-through networking".

In host memory, the receive (RX) buffers are implemented as **2 megabyte ring buffers**. There are up to 33 ring buffers per port: the default buffer (0) and up to 32 flow steering buffers.

As a packet comes off the wire, data is sent to the host in 'chunks' of 128 bytes, consisting of 120 bytes of data and 8 bytes of metadata. (This size was chosen as a trade-off between bandwidth and latency, and is assumed throughout the current architecture; it is not user-configurable.) Software normally waits for a whole frame to arrive before starting processing, however for some applications it may be useful to process frames chunk-by-chunk, which is possible with the SmartNIC API.

If the hardware gets more than 2 megabytes ahead of software, **packets may be lost** (this is described in the API as a "software overflow", or informally as "getting lapped"). The **lack of flow control** allows multiple applications to receive packets from the same receive buffers with no performance penalty. However, it means that **keeping up with the packet rate matters** more than for conventional cards.

It is possible to achieve loss-free 10G line rate reception from a single buffer if attention is paid to CPU allocation (e.g. pinning the receive thread to a free CPU) and if the work done by the receive thread is kept to a minimum. Larger receive buffers are a common request and may be implemented in the future for capture applications. Note however that if an application is lagging by 2 MiB of data, then the packets it is receiving are many **milliseconds old**. Thus larger buffers are not a good solution for low-latency applications. Drops in a low-latency application are an indication of application slowness or hiccups that should be investigated.

Flow steering and flow hashing can be used to distribute load to multiple buffers and increase the effective buffer space while still maintaining low latency for important flows. Note that, for latency and PCI Express bandwidth reasons, the SmartNIC only ever delivers each packet to one buffer. If one application needs to listen to flows A and B and another needs to listen to flows B and C, then either all the flows need to be directed to one buffer, or each application needs to listen on two buffers.

### Transmit architecture

Unlike the **receive buffers which are located in host RAM**, the **transmit (TX) buffers are located on the SmartNIC itself**. They can be **written directly by software via a memory mapping** (but not read). To transmit a packet, software writes the packet data into the transmit buffer (together with a short header), and then writes a **register on the SmartNIC** to start packet transmission.

The amount of transmit buffer memory varies from card to card, further details can be found here.

Applications can request parts of the transmit buffer, at a **minimum granularity of 4KiB**. The SmartNIC driver usually also acquires one 4KiB chunk for packets being sent from the kernel, although this can be disabled by setting the interface to **bypass-only mode** with exanic-config. (Note that exasock will not function correctly in this mode, however, since it relies on the kernel driver for TCP slow path processing; it is **only useful when using libexanic exclusively**.)

The **packet header** written to the TX buffer together with each packet contains a **feedback slot index** and **feedback ID**. After sending the packet, the card writes the given ID to the given slot (within a feedback structure in host memory). This allows software to determine when packet transmission is complete.

## ExaNIC Sockets (exasock) Usage

The Cisco Nexus SmartNIC (formerly ExaNIC) Sockets acceleration library allows applications to benefit from the low latency of direct access to the SmartNIC **without requiring modifications to the application**. This is achieved by **intercepting calls to the Linux socket APIs**.

While SmartNIC Sockets should be compatible with most applications using Linux socket APIs, there are some cases where programs may not work as expected. Feedback and bug reports would be greatly appreciated (create a case with Cisco TAC).

### Software installation

Build the SmartNIC driver and libraries as per the [SmartNIC Installation and Configuration Guide](https://exablaze.com/docs/exanic/user-guide/installation). SmartNIC Sockets is built and installed as a standard component, and the exasock kernel module is loaded automatically when an SmartNIC interface is brought up.

### Usage

First ensure that the application works without SmartNIC Sockets. All IP addresses should be configured as if you were running the application through the normal Linux network interface corresponding to the SmartNIC.

Then, to accelerate the application, simply prefix it with the `exasock` command. For example, to run the UNIX netcat (`nc`) utility to listen for UDP datagrams on port 1234:

    $ exasock nc -u -l 1234

Another simple example application that receives and sends UDP multicast datagrams is located in the SmartNIC source code distribution (`examples/exasock/multicast-echo.c`). Note that this is a normal Linux sockets application that can be run either with or without the SmartNIC Sockets acceleration library.

Sometimes it can be difficult to determine if the kernel bypass is functioning correctly. Setting the `EXASOCK_DEBUG` environment variable prints extra debugging information that can help. For example:

    $ EXASOCK_DEBUG=1 exasock nc -u -l 123
    exasock: enabled bypass on fd 4

In this case, the message `exasock: enabled bypass on fd 4` indicates that kernel bypass has been enabled for the socket associated with file descriptor 4.

The exasock command itself can take several arguments:

- `--help`: display a message summarising these arguments

- `--debug`: use the debug version of `libexasock`

- `--trace`: record system calls, their arguments and their return values to stdout

`--no-warn`: turn off warning messages

`--no-auto`: disable acceleration on new sockets by default. It is still possible to opt-in to acceleration by calling `setsockopt()` with `SO_EXA_NO_ACCEL` and supplying zero as the argument.

### Displaying Exanic sockets accelerated connections

To provide insight into the current SmartNIC accelerated socket connections the utility `exasock-stat` is provided. By default running `exasock-stat` will display all accelerated UDP and TCP, listening and connected sockets.

The `exasock-stat` application was introduced with the v2.0.0 SmartNIC driver and software package and can be found within the `util` directory. This application will build as part of the utils build however the `libnl3-devel` package is not present by default in which case building `exasock-stat` will be skipped. To ensure it can be built first run the appropriate command to install the missing libnl-3-dev package e.g. `sudo apt-get install libnl-3-dev` or `sudo yum install libnl3-devel.x86_64` then re-run `make && make install`.

Then when running:

    exasock-stat

you should see a table similar to the following:

    Active SmartNIC Sockets accelerated connections (servers and established):
      Proto | Recv-Q   | Send-Q   | Local Address            | Foreign Address    | State
      UDP   | 0        | 0        | 192.168.10.10:12345      | *:*                | -

The columns shown are:

    Proto:
       The protocol used by the socket (TCP or UDP)
    Recv-Q:
       Connected: The count of bytes not copied by the user program
                  connected to this socket
       Listening: The count of connections waiting to be accepted by the
                  user program
    Send-Q:
       Connected: The count of bytes not acknowledged by the remote host
       Listening: N/A
    Local Address:
       Address and port number of the local end of the socket
    Foreign Address:
       Address and port number of the remote end of the socket
    State:
       The state of the socket


    Extended Output not shown (-e/--extend enabled):
    User:
       The username or the user id (UID) of the owner of the socket
    PID:FD:
       PID of the process that owns the socket and value of the socket's
       file descriptor
    Program:
       Process name of the process that owns the socket

Exactly what the application displays can be controlled by providing arguments from the command line. To see the arguments available run `exasock-stat --help`

### Disabling acceleration per-socket

If only the SmartNIC Sockets acceleration library is used, then each socket bound to either an SmartNIC interface or to a wildcard address (`INADDR_ANY`) gets automatically accelerated (i.e. the kernel is bypassed to allow direct access to the SmartNIC).

As of exasock version 2.0.0 it is **possible to disable default acceleration** on a given socket, even if bound to an SmartNIC interface (or bound to a wildcard address or joined a multicast group with an SmartNIC interface).

In order to use this feature the application is required to include the `<exasock/socket.h>` header file and to disable the acceleration as needs be for each socket. This is done by either setting the exasock private `SO_EXA_NO_ACCEL` socket option, or alternatively by calling the `exasock_disable_acceleration()` helper function.

Disabling acceleration on a socket is not allowed if the socket has already been accelerated (either by binding it to an SmartNIC interface or joining a multicast group with an SmartNIC interface).

Once acceleration has been disabled on a socket, it can no longer be re-enabled.

Documentation for both the exasock private socket option and the helper function can be found in the header file `<exasock/socket.h>`.

### Multicast sockets

Versions of exasock older than 2.0.0 automatically accelerate each socket bound to a multicast address. Newer versions (2.0.0 and beyond) accelerate a multicast socket only if joined a multicast group (via `IP_ADD_MEMBERSHIP` socket option) with an SmartNIC interface. For any accelerated socket exasock version 2.0.0 (or later) receives multicast packets only from the interface with which the socket has joined the multicast group.

### TCP acceleration

exasock 1.7.0 and later include a library called `exasock_ext` that allows user applications to detect that they are running under exasock and access functionality beyond the standard Linux socket calls. In particular, the current version provides a TCP acceleration feature that allows programmers to achieve even lower TCP latencies than possible with the normal send/sendto/sendmsg APIs.

Using this TCP acceleration feature, an application can **construct partial or complete TCP packets** ahead of time. These pre-built packets can then be transmitted through the lower level `libexanic` library, or can even be pushed to a user FPGA application on the SmartNIC card for ultra-low latency responses to triggers. To learn more about this method, see the section on [TX preloading](https://exablaze.com/docs/exanic/user-guide/libexanic/#transmit-preloading).

Since some of the setup for TX preloading needs to know the port number, the following function is provided for convenience when trying to find out which SmartNIC name and port number correspond to a given file descriptor:

    int exasock_tcp_get_device(int fd, char *dev, size_t dev_len, int *port_num);

`fd` is the file descriptor you want to know more about. `dev` is a buffer in which to put the SmartNIC name, and `dev_len` is the amount of space available in that buffer. `port_num` is also a return parameter, and will contain the port number associated with the file descriptor. This function returns 0 on success and -1 on error, in which case `errno` will be set appropriately.

The following function constructs a header for the frame you want to send, and inserts it into the buffer provided:

    ssize_t exasock_tcp_build_header(int fd, void *buf, size_t len, size_t offset, int flags);

Note that this builds not only the TCP header, but the IP and Ethernet headers as well. `fd` is the file descriptor for the connection (e.g. that returned by `accept`). `buf` is the buffer to be used for the header data, and `len` is the length of that buffer. `offset` and `flags` are currently unused, and should be set to 0.

The following functions sets the length in the IP field, and calculates the IP checksum. Note that this function assumes the IP and TCP headers have no added options, which will be the case for headers generated by `exasock_tcp_build_header`.

    int exasock_tcp_set_length(void *hdr, size_t hdr_len, size_t data_len);

`hdr` is a pointer to some header bytes, and `hdr_len` is the number of bytes available after that pointer. `data_len` is the length of the payload. The return value for this function is normally zero, and -1 if an error has occurred.

The following function calculates the TCP checksum for the header and data pointed to, and places it in the header:

    int exasock_tcp_calc_checksum(void *hdr, size_t hdr_len, const void *data, size_t data_len);

`hdr` is a pointer to the header bytes of the frame, and `hdr_len` is the number of bytes valid after this address. `data` is the TCP payload, and `data_len` is the length of the payload. The function returns 0 on success, and -1 if an error has occurred.

The following function is intended to be called after your frame has been sent. It will update Exasock's TCP state to account for the packet that was just transmitted by copying the just-sent data to the retransmission buffer, and updating its sequence numbers.

    int exasock_tcp_send_advance(int fd, const void *data, size_t data_len);

`fd` is the file descriptor for the TCP connection, `data` is the payload that was transmitted, and `data_len` is the length of the payload.

There is an example tying these concepts together available in `src/examples/exasock/tcp-raw-send.c`.

### Frame warming

Calling `send`, `sendto` or `sendmsg` under Exasock with the `MSG_EXA_WARM` flag present in the `flags` argument will result in the message being aborted as close possible to the end of the TX code path. This is intended to warm the cache.

Note that this flag was introduced in Exasock 2.2.0. Using this flag in prior versions will cause the frame to be sent as normal. As such, you should only use this flag in versions of Exasock after 2.2.0. You can check the Exasock version in your program:

    if (exasock_version_code() < EXASOCK_VERSION(2,2,0)) {
        // do something else
    }

### Known issues and limitations

- Each thread that calls a blocking I/O call - e.g. `select()`, `poll()`, `epoll_wait()`, `recv()`, `read()` or `accept()` - will spin waiting on data. This normally provides optimal latency but can induce performance problems if there are more threads than available CPUs. Other blocking modes will be provided in the future.

- If a socket is bound to a wildcard address (`INADDR_ANY`), it will only receive packets that arrive on SmartNIC interfaces when run with the acceleration library.

- If exasock version older than 2.0.0 is used and a socket is bound to a multicast address, or exasock version 2.0.0 or newer is used and a socket has joined a multicast group (`IP_ADD_MEMBERSHIP` socket option) with an SmartNIC interface, it will only receive packets that arrive on SmartNIC interfaces when run with the acceleration library.

- Connecting to an accelerated socket from the same host is not supported (for example, if a socket is bound to 192.168.1.1:80, then it is not possible to connect to 192.168.1.1:80 from the local host).

- Transmitted multicast datagrams are not looped back to local sockets.

- The `MSG_WAITALL` flag to `recv()` is not currently supported (to be resolved).

- No support for recursive addition of epoll file descriptors to epoll sets.

- No support for IP fragmentation.

- Sockets may not be correctly maintained across `fork()` or `execve()`.

- Sockets cannot be transferred to other processes with `sendmsg()`.

- `recvmmsg()` duplicates the Linux behavior of only checking the timeout after the receipt of each datagram, so that if up to vlen-1 datagrams received before the timeout expires, but then no further datagrams are received, the call will block forever.

### Tips for best performance

- Wherever possible, do not mix accelerated sockets with non-accelerated sockets and other file descriptors in `select()` and `poll()` calls.

- For the best possible performance, pin threads to CPU cores in the CPU socket directly connected to the SmartNIC.

## [ExaNIC Library (libexanic) Usage](https://exablaze.com/docs/exanic/user-guide/libexanic/)

The libexanic is a low-level access library for the Cisco Nexus SmartNIC (formerly ExaNIC) hardware. It can be used to transmit and receive raw Ethernet packets with minimum possible latency. Customers who require higher level TCP/IP functionality should instead consider using SmartNIC Sockets.

This user guide walks through the main functions in libexanic in a tutorial format. Documentation for each function is also provided in the header files included with libexanic: all of the functions exposed to the user have a brief comment explaining their purpose, a listing of all the required arguments, and their return values.

It is recommended that users first consult the SmartNIC Configuration Guide and ensure that that the software is installed and working.

### Quick start







