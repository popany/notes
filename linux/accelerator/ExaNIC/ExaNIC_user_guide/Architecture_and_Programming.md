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
    - [Opening the device](#opening-the-device)
    - [Receive](#receive)
    - [In-place receive](#in-place-receive)
    - [Transmit](#transmit)
    - [Transmit preloading](#transmit-preloading)
    - [Releasing resources](#releasing-resources)
    - [Flow steering](#flow-steering)
    - [Flow hashing](#flow-hashing)

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

Here are two short examples which illustrate basic frame transmission and reception. The functions used are elaborated on in further sections.

    #include <stdio.h>
    #include <string.h>
    #include <exanic/exanic.h>
    #include <exanic/fifo_tx.h>
    
    int main(void)
    {
        char *device = "exanic0";
        int port = 0;
    
        exanic_t *exanic = exanic_acquire_handle(device);
        if (!exanic)
        {
            fprintf(stderr, "exanic_acquire_handle: %s\n", exanic_get_last_error());
            return 1;
        }
    
        exanic_tx_t *tx = exanic_acquire_tx_buffer(exanic, port, 0);
        if (!tx)
        {
            fprintf(stderr, "exanic_acquire_tx_buffer: %s\n", exanic_get_last_error());
            return 1;
        }
    
        char frame[1000];
        memset(frame, 0xff, 1000);
        if (exanic_transmit_frame(tx, frame, sizeof(frame)) == 0)
            printf("Transmitted a frame\n");
    
        exanic_release_tx_buffer(tx);
        exanic_release_handle(exanic);
        return 0;
    }

.

    #include <stdio.h>
    #include <exanic/exanic.h>
    #include <exanic/fifo_rx.h>
    
    int main(void)
    {
        char *device = "exanic0";
        int port = 0;
    
        exanic_t *exanic = exanic_acquire_handle(device);
        if (!exanic)
        {
            fprintf(stderr, "exanic_acquire_handle: %s\n", exanic_get_last_error());
            return 1;
        }
    
        exanic_rx_t *rx = exanic_acquire_rx_buffer(exanic, port, 0);
        if (!rx)
        {
            fprintf(stderr, "exanic_acquire_rx_buffer: %s\n", exanic_get_last_error());
            return 1;
        }
    
        char buf[2048];
        exanic_cycles32_t timestamp;
    
        while (1)
        {
            ssize_t sz = exanic_receive_frame(rx, buf, sizeof(buf), &timestamp);
            if (sz > 0)
            {
                printf("Got a valid frame\n");
                break;
            }
        }
    
        exanic_release_rx_buffer(rx);
        exanic_release_handle(exanic);
        return 0;
    }

### Opening the device

The first step is to open a handle to the device:

    #include <exanic/exanic.h>

    exanic_t * exanic_acquire_handle(const char *device);

The SmartNIC cards in the system will be `"exanic0", "exanic1"`, ... in order of PCI ID. This is the same device name reported by the `exanic-config` utility.

To avoid hardcoding the SmartNIC device name in an application, the following function can also be used to look up the **device name** and **port number** from a **Linux interface name**:

    #include <exanic/config.h>
   
    int exanic_find_port_by_interface_name(const char *name, char *device,
                                           size_t device_len, int *port_number);

`device_len` specifies the length of the `device` buffer into which the device name is returned; it should be at least 8 bytes. The return value is `0` on success and `-1` if the requested interface name was not found.

### Receive

The SmartNIC delivers packets into logical receive buffers. To attach to a receive buffer, the programmer should call:

    #include <exanic/fifo_rx.h>
    
    exanic_rx_t * exanic_acquire_rx_buffer(exanic_t *exanic,
                                           int port_number, int buffer_number);

There is **no limit to the number of applications** that can connect to a receive buffer. By default, all received traffic on a given port will arrive in the buffer obtained by setting buffer_number = 0. Frames destined for other hosts are filtered out by hardware unless promiscuous mode is enabled. When hardware flow steering is enabled, and for buffer_number > 0, this function can be used to attach to a **userspace flow steering** or **flow hashing buffer**. Flow steering mode configures the SmartNIC hardware to redirect received frames from the default buffer to one of 32 userspace buffers. For details on enabling and configuring flow steering, see the flow steering section of this document.

To receive a frame, call:

    ssize_t exanic_receive_frame(exanic_rx_t *rx,
                                 char *rx_buf, size_t rx_buf_size,
                                 uint32_t *timestamp);

The caller should poll this function in a loop, possibly interspersed with other work. (There is currently no API that would put the current process to sleep waiting for a packet; this may be available in the future, but would naturally involve higher latency.)

The return value will be one of:

    >0                         The length of the frame acquired
    0                          No frame currently available
    -EXANIC_RX_FRAME_ABORTED   Frame aborted by sender
    -EXANIC_RX_FRAME_CORRUPT   Frame failed hardware CRC check
    -EXANIC_RX_FRAME_HWOVFL    Frame lost due to hardware overflow
                               (e.g. insufficient PCIe/memory bandwidth)
    -EXANIC_RX_FRAME_SWOVFL    Frame lost due to software overflow
                               (e.g. scheduling issue)
    -EXANIC_RX_FRAME_TRUNCATED Supplied buffer was too short

The frame delivered to `rx_buf` is a complete **Ethernet frame** including the CRC footer, however the CRC has already been verified by the hardware.

The frame timestamp is returned via the provided `timestamp` pointer. `timestamp` can be `NULL` if the timestamp is not required. The returned timestamp provides the lower 32 bits of the card's internal time stamp counter when the first byte of the packet arrived. Within the next second or so one should pass this value to `exanic_expand_timestamp()` which adds the upper 32 bits to produce a full 64-bit timestamp:

    #include <exanic/time.h>

    exanic_cycles_t exanic_expand_timestamp(exanic_t *exanic,
                                       exanic_cycles32_t timestamp);

The resulting 64-bit timestamp is a value in cycles since the UNIX epoch. You can operate directly on these values in cycles space (subtraction, addition, etc). You can convert the results into nanoseconds, picoseconds and timespec formats using the below functions:

    #include <exanic/time.h>

    void exanic_cycles_to_timespec(exanic_t *exanic,
                                    exanic_cycles_t timestamp,
                                                   struct timespec *ts);
    void exanic_cycles_to_timespecps(exanic_t *exanic,
                                      exanic_cycles_t timestamp,
                                       struct exanic_timespecps *tsps);
    uint64_t exanic_cycles_to_ns(exanic_t *exanic,
                                exanic_cycles_t timestamp);
    uint64_t exanic_cycles_to_ps(exanic_t *exanic,
                                exanic_cycles_t timestamp,
                                bool *overflow);

|||
|-|-|
Note|exanic_cycles_to_ps() will truncate the result to 64 bits; it can be used for relative times but use exanic_cycles_to_timespecps() if an absolute time with picosecond precision is required (there are more than 64 bits worth of picoseconds since epoch).
|

|||
|-|-|
Note|The above timestamp manipulations functions are new. For 1.8.1 and earlier versions, use exanic_timestamp_to_counter(exanic, timestamp), which is equivalent to exanic_expand_timestamp() followed by exanic_cycles_to_ns().
|

|||
|-|-|
Note|Although all of the above functions will work with any SmartNIC device, only the Cisco Nexus NIC HPT (formerly ExaNIC HPT) device supports true picosecond resolution timestamps.
|

The function `exanic_receive_frame` may spin for a very short period of time (<2 µs) to wait for additional fragments of the frame to arrive via PCI Express. To avoid blocking, there is another function for receiving partial frames:

    ssize_t exanic_receive_chunk(exanic_rx_t *rx, char *rx_buf, int *more_chunks);

This function receives frames in chunks of at most 120 bytes.

When a new chunk is available, `exanic_receive_chunk` will deliver the data to `rx_buf` and return the number of bytes received. `*more_chunks` will be set to `1` if there are more chunks in the frame, or `0` if this is the last chunk. If there is no new data available, `exanic_receive_chunk` will return `0` and `*more_chunks` will be left unchanged.

To receive a complete frame, the caller should poll `exanic_receive_chunk` in a loop until `*more_chunks` is set to `0`.

If `*more_chunks` is 1 but the caller is not interested in the remainder of the frame, there is a convenience function available that skips the rest of the current frame:

    int exanic_receive_abort(exanic_rx_t *rx);

Finally there is an `exanic_receive_chunk_ex` function; this takes an info parameter that returns extra frame metadata:

    exanic_receive_chunk_ex(exanic_rx_t *rx, char *rx_buf, int *more_chunks,
                            struct rx_chunk_info *info);

In particular `info.timestamp` can be used to obtain the frame timestamp which is not otherwise available through the `exanic_receive_chunk` API. Note that each chunk of the frame will contain the same timestamp (the start-of-frame timestamp).

### In-place receive

There are also in-place versions of `exanic_receive_chunk` and `exanic_receive_chunk_ex` that return pointers into the live RX ring buffer. These functions are only intended for advanced users; the performance advantages are minimal (note that Cisco published performance numbers use the normal `exanic_receive_frame` APIs) and there is a risk of processing corrupt data if hardware overtakes software. After consuming the data buffer, the user should call `exanic_receive_chunk_recheck` with the previously returned chunk ID to determine whether corrupt data may have been read.

    ssize_t exanic_receive_chunk_inplace(exanic_rx_t *rx, char **rx_buf_ptr,
                                         uint32_t *chunk_id,
                                         int *more_chunks);
    ssize_t exanic_receive_chunk_inplace_ex(exanic_rx_t *rx,
                                            char **rx_buf_ptr,
                                            uint32_t *chunk_id,
                                            int *more_chunks,
                                            struct rx_chunk_info *info);
    int exanic_receive_chunk_recheck(exanic_rx_t *rx, uint32_t chunk_id);

### Transmit

The SmartNIC also contains transmit buffers from which packets are transmitted. To attach to a transmit buffer, the programmer should call:

    #include <exanic/fifo_tx.h>
    
    exanic_tx_t * exanic_acquire_tx_buffer(exanic_t *exanic,
                                           int port_number, size_t requested_size);

Each application is allocated a portion of the available transmit buffer space. The maximum amount of memory that can be allocated per port depends on the card:

|Model | Buffer Memory|
|-|-|
Cisco Nexus SmartNIC K3P-S (formerly X25) | 128KiB per port (256KiB total) <br> 1MB per port (2MB in total) as a separately available firmware image. The images built with 1MB per port incur an additional port-to-wire latency of ~20ns
Cisco Nexus SmartNIC K35-S (formerly X10) <br> Cisco Nexus NIC GM (formerly ExaNIC GM) <br> Cisco Nexus NIC HPT (formerly ExaNIC HPT) | 128KiB per port (256KiB total)
| Cisco Nexus SmartNIC K35-Q (formerly X40) <br> Cisco Nexus SmartNIC+ V5P <br> Cisco Nexus SmartNIC K3P-Q (formerly X100) |64KiB per port (512KiB total)
|

The `requested_size` should be 0 or a multiple of 4096. A value of 0 indicates to use the default size, which is currently 4096. Larger values can increase transmit bandwidth for applications that send many packets close together, at the expense of reducing the number of applications that can share a port.

To transmit a packet, call:

    int exanic_transmit_frame(exanic_tx_t *tx, const char *frame, size_t frame_size);

The frame to be sent should include the Ethernet header but not include the CRC footer which is added by the hardware. Note that once a frame has been moved into a transmit buffer, it cannot be read back out.

It is also possible to obtain a pointer directly into the NIC frame buffer with:

    char * exanic_begin_transmit_frame(exanic_tx_t *tx, size_t frame_size);

Packet transmission is then triggered with:

    int exanic_end_transmit_frame(exanic_tx_t *tx, size_t frame_size);

`frame_size` should be less than or equal to the size allocated in `exanic_begin_transmit_frame`. Care should be taken when using this direct write interface because the returned pointer is **in PCI Express memory space**; to ensure processor write coalescing it should be written in an approximately sequential fashion and it must not be read from. If in doubt, use the simpler `exanic_transmit_frame` API (published performance numbers for the SmartNIC use that function, the performance difference is minimal).

There is another variant of `exanic_transmit_frame` available, called `exanic_transmit_frame_ex`. This function takes an additional argument: `uint32_t flags`. The only currently-available flag is `EXA_FRAME_WARM`, which causes a **dummy register** write to be triggered, in order to bring the hot path into the instruction cache.

The hardware transmit timestamp of the frame most recently sent on a port can be retrieved with:

    exanic_cycles32_t exanic_get_tx_timestamp(exanic_tx_t *tx);

This can be converted to a time in cycles since the UNIX epoch using the `exanic_expand_timestamp()` function. See `exanic_receive_frame()` for more details on timestamp manipulation functions.

|||
|-|-|
|Note|Both exanic_transmit_frame and exanic_begin_transmit_frame may spin for a very short period of time (<2 µs) if the transmit buffer is full.
|

### Transmit preloading

In some cases, the packet to be sent, or a choice of packets to be sent, is known ahead of time. Transmit preloading refers to the notion of **loading the card with a packet before it is required to be sent**, and using a single register write to trigger the packet to be sent. The general idea is to remove the overhead of transferring the packet from the critical path.

For a single packet, this can be done using `exanic_begin_transmit_frame` and `exanic_end_transmit_frame` as described above. The API does not currently support preloading more than one packet per TX buffer handle however.

To preload more than a few packets at a time, it becomes necessary to manually manage the TX buffer. To do this, first acquire a TX buffer of the desired size using `exanic_acquire_tx_buffer`. Then, write the packets to be preloaded into the buffer pointed to by `tx->buffer`. Each packet must be prefixed by an 8-byte chunk header (`struct tx_chunk`) and 2 bytes of padding (such that the IP header is word aligned). The chunk header should be filled out as follows:

- `feedback_slot_index` should be set to `tx->feedback_slot`, or 0x8000 if feedback is not required.

- `feedback_id` is the value to be written into the feedback slot when packet transmission completes.

- `length` is the length of the frame plus the 2 padding bytes.

- `type` should be `EXANIC_TX_TYPE_RAW`.

- `flags` are currently unused in the context of transmit preloading, and should be left as 0.

The preloaded frame(s) can then be sent when required by writing to the the `TX_COMMAND` register. The value written should be `tx->buffer_offset` plus the offset pointing to the chunk to be transmitted. When packet transmission completes, the card will write the value specified in `feedback_id` to `*(tx->feedback)`.

There is an example of using this feature in `examples/exanic/exanic-tx-preload.c`, including detailed implementations of all of the above steps.

|||
|-|-|
Note|The SmartNIC transmit buffers are mapped in write-combining mode, which means multiple writes can be buffered by the CPU and sent together. For preloading purposes, it is usually desired to flush the data to the NIC immediately after filling out the buffer. The most reliable way of doing this is to perform a **dummy write to a read-only register**, such as register 0.
|

### Releasing resources

The API handles should be freed with the following functions:

    void exanic_release_handle(exanic_t *exanic);
    void exanic_release_rx_buffer(exanic_rx_t *rx);
    void exanic_release_tx_buffer(exanic_rx_t *rx);

### Flow steering

Flow steering is available in newer releases of the SmartNIC firmware, which can be obtained from the Exablaze repository. It is supported in firmware versions 2014-05-28 and later. All flow steering is performed in hardware on the SmartNIC, freeing the host CPU to perform other work. Use of SmartNIC flow steering does **not** incur any additional latency penalty on received frames.

Flow steering makes use of the concepts of filters and buffers. Each physical port on the card has a default receive buffer (buffer 0) in host memory to which all traffic is normally delivered and which is shared between the kernel and userspace applications. All ports have an additional 32 userspace buffers, numbered 1 to 32, that can be obtained by a user's application as follows.

First, to attach to an unused receive filter buffer for a given card port, use the function:

    #include <exanic/fifo_rx.h>
    
    exanic_rx_t * exanic_acquire_unused_filter_buffer(exanic_t *exanic,
                                                      int port_number);

This returns an `exanic_rx_t` instance with an unused receive buffer. The `buffer_number` field of this instance indicates which of the 32 userspace buffers was allocated. To obtain a reference to a specific buffer at a later time, use:

    exanic_rx_t * exanic_acquire_rx_buffer(exanic_t *exanic,
                                        int port_number, int buffer_number);

The `buffer_number` argument should be set to the number of the desired buffer. If this buffer has not yet been allocated it will be allocated by this function. There is no limit to the number of applications that can connect to a given buffer.

|||
|-|-|
|Note|`exanic_acquire_rx_buffer()` / `exanic_acquire_unused_filter_buffer()` may fail with an error "Cannot allocate memory" even though sufficient buffers remain.
|

This problem occurs due to Linux memory fragmentation. The function needs to allocate contiguous memory to operate. If a machine is up for a long time (especially if it undergoes heavy memory churn), memory can become fragmented and congested which limits the number of pages available for allocation.

The SmartNIC driver will report this in the system log as "'exanic0: Failed to allocate 512 page(s) for filter DMA region".

A suggestion to resolve this is to run:

    echo 1 >/proc/sys/vm/compact_memory

which will attempt to compact the memory in the kernel to free up contiguous blocks.

If that doesn't help you could try:

    sync; echo 3 >/proc/sys/vm/drop_caches

This should cause the kernel to drop its caches (e.g. for file system objects) and again free up contiguous memory.

Once the application has acquired userspace buffers, it can begin to define rules that direct traffic towards them. Rules exist in two sets, MAC address rules and IP address rules. Current versions of the firmware supports 128 IP address rules and 64 MAC address rules per physical port, but this may be increased in future firmware revisions.

To define an IP address rule, use the exanic_ip_filter_t struct, shown below, setting any fields that you wish to perform a wildcard match on to zero. All fields are stored in network byte order – so you must use appropriate calls to htons and htonl prior to assignment.

    #include <exanic/filter.h>

    typedef struct exanic_ip_filter
    {
        uint32_t src_addr; /**< Source IP address of packet */
        uint32_t dst_addr; /**< Destination IP address of packet */
        uint16_t src_port; /**< Source port of packet */
        uint16_t dst_port; /**< Destination port of packet */
        uint8_t protocol; /**< IPPROTO_UDP or IPPROTO_TCP */
    } exanic_ip_filter_t;

To bind the rule to the previously obtained buffer use the function `exanic_filter_add_ip`, passing in the previously obtained buffer and the filter rule you have defined:

    int exanic_filter_add_ip(exanic_t *exanic,
                             const exanic_rx_t *buffer,
                             const exanic_ip_filter_t *filter);

This function will return a unique positive integer ID for each rule created on a given port, or -1 if no further rules can be allocated. From this point on, frames matching the given rule will be steered by the hardware to the defined userspace buffer, and will not reach the Linux network stack or the default userspace buffer. Calls to `exanic_receive_frame`, using the acquired buffer as the first argument, will only return frames matching the rules associated with the buffer. Frames not matching any rules will still be delivered to buffer 0.

To add a MAC address rule, first define the rule using the `exanic_mac_filter_t` struct, where all fields are in network byte order. This means that `dst_mac[0]` is the most significant byte of the destination MAC address. Set to zero any field to perform a wildcard match.

    typedef struct exanic_mac_filter
    {
        uint8_t dst_mac[6];
        uint16_t ethertype;
        uint16_t vlan;
        int vlan_match_method;
    } exanic_mac_filter_t;

In the case of VLAN tagged frames, a number of match modes can be used. These are defined in the enumeration `vlan_match_method`:

    #include <exanic/pcie_if.h>

    enum vlan_match_method
    {
        /** Match on all frames, whether VLAN or not. */
        EXANIC_VLAN_MATCH_METHOD_ALL = 0,

        /** Only match on the VLAN given. */
        EXANIC_VLAN_MATCH_METHOD_SPECIFIC = 1,

        /** Only match if frame does not have a vlan tag. */
        EXANIC_VLAN_MATCH_METHOD_NOT_VLAN = 2,

        /** Match frames that have a VLAN tag, but not those that don't. */
        EXANIC_VLAN_MATCH_METHOD_ALL_VLAN = 3,
    };

Then, bind the filter to a previously acquired buffer using:

    int exanic_filter_add_mac(exanic_t *exanic,
                              const exanic_rx_t *buffer,
                              const exanic_mac_filter_t *filter);

This function will return a unique positive integer ID for each MAC address rule on a given port, or -1 if no hardware rules remain. As in the case of IP rules, once a rule is bound to a buffer, calls to `exanic_receive_frame` for that buffer will only return frames matching rules associated with that buffer.

It should be mentioned that it is possible to create rules such that more than one rule matches an incoming ethernet frame. When this is the case, priority is resolved as follows:

- MAC address rules have higher priority than IP address rules,

- Within a given set of MAC or IP address rules, the lower the rule ID, the higher the rule priority.

Rules can be released using:

    int exanic_filter_remove_ip(exanic_t *exanic, int port_number, int filter_id);

    int exanic_filter_remove_mac(exanic_t *exanic, int port_number, int filter_id);

### Flow hashing

The SmartNIC also supports hardware flow hashing which can be used to distribute load evenly amongst a number of host processors. When enabled, the SmartNIC hardware will deliver received frames to one of a number of userspace receive buffers based on a hash computed over IP headers. The hash function guarantees that all frames belonging to a given flow will always arrive in the same buffer. For a given SmartNIC port, flow steering and flow hashing cannot be used at the same time.

To enable flow hashing on a specific port, use the function:

    #include <exanic/fifo_rx.h>

    int exanic_enable_flow_hashing(exanic_t *exanic, int port_number,
                                   int max_buffers, int hash_function);

This function will allocate up to `max_buffers` userspace receive buffers and distribute IP traffic evenly among them using the `hash_function`. The number of buffers must be a power of 2, and currently a maximum of 32 buffers are available. The number of actual receive buffers allocated is returned by this function. The available hash functions are defined in `rx_hash_function`.

    enum rx_hash_function
    {
        /* Symmetric hash over source port, destination port */
        EXANIC_RX_HASH_FUNCTION_PORT = 0,

        /* Symmetric hash over source ip, destination ip */
        EXANIC_RX_HASH_FUNCTION_IP = 1,

        /* Symmetric hash over source ip & port, destination ip & port */
        EXANIC_RX_HASH_FUNCTION_PORT_IP = 2,
    };

The application can then attach to the userspace flow hashing buffers by calling `exanic_acquire_rx_buffer`, passing in buffer numbers from 1 to the number of allocated userspace receive buffers. IP traffic will be balanced across each of these buffers, and `exanic_receive_frame` can be used to obtain the traffic in each buffer.

To disable flow hashing and free all allocated buffers, use:

    void exanic_disable_flow_hashing(exanic_t *exanic, int port_number);



















