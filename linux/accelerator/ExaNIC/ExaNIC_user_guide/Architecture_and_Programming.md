# Architecture and Programming

- [Architecture and Programming](#architecture-and-programming)
  - [Introduction](#introduction)
  - [ExaNIC Internals](#exanic-internals)
    - [Receive architecture](#receive-architecture)
  - [ExaNIC Library (libexanic) Usage](#exanic-library-libexanic-usage)
  - [Quick start](#quick-start)
    - [In-place receive](#in-place-receive)

## [Introduction](https://exablaze.com/docs/exanic/user-guide/programming/)

This section of the user guide describes how to use the Cisco Nexus SmartNIC (formerly ExaNIC) as a developer. There are at least three different APIs that can be used depending on requirements:

- Existing sockets applications can be accelerated with the exasock TCP/UDP acceleration library. Generally this is simply a matter of running the application with the `exasock` command. For more details and known limitations, see the [exasock usage guide](https://exablaze.com/docs/exanic/user-guide/sockets/).

- Sending and receiving packets with low latency using the SmartNIC API library (`libexanic`). Refer to the [internals primer](https://exablaze.com/docs/exanic/user-guide/internals) for an introduction to the architecture of SmartNIC cards, and the [libexanic usage guide](https://exablaze.com/docs/exanic/user-guide/libexanic/) for API details. It is possible to use `libexanic` simultaneously with `exasock` (e.g. receiving UDP frames with `libexanic` and sending TCP frames with `exasock`), and it is also possible to use `exasock` to pre-build TCP frames and then send them using `libexanic` (see the [TCP acceleration](https://exablaze.com/docs/exanic/user-guide/sockets/#tcp-acceleration) section).

- Writing your own logic to run on the SmartNIC card's FPGA using the SmartNIC FDK. For more information refer to the [FDK documentation](https://exablaze.com/docs/exanic/user-guide/fdk_v2). Note that the FDK is an optional component that is licensed separately. When running a custom firmware image, all network interfaces are still exposed to software (subject to filtering by the user FPGA logic), so the normal software APIs are still available.

## [ExaNIC Internals](https://exablaze.com/docs/exanic/user-guide/internals/)

One of the key differences between a Cisco Nexus SmartNIC (formerly ExaNIC) and most other network cards is that the SmartNIC is optimised for the lowest possible latency. This focus on latency comes with a few design decisions that differ from conventional NICs.

### Receive architecture

To keep latency low, there is very little buffering done by SmartNIC cards, with data received from the network sent through to host memory as soon as possible. This could be considered an extreme version of "cut-through networking".

In host memory, the receive (RX) buffers are implemented as 2 megabyte ring buffers. There are up to 33 ring buffers per port: the default buffer (0) and up to 32 flow steering buffers.

As a packet comes off the wire, data is sent to the host in 'chunks' of 128 bytes, consisting of 120 bytes of data and 8 bytes of metadata. (This size was chosen as a trade-off between bandwidth and latency, and is assumed throughout the current architecture; it is not user-configurable.) Software normally waits for a whole frame to arrive before starting processing, however for some applications it may be useful to process frames chunk-by-chunk, which is possible with the SmartNIC API.

If the hardware gets more than 2 megabytes ahead of software, packets may be lost (this is described in the API as a "software overflow", or informally as "getting lapped"). The lack of flow control allows multiple applications to receive packets from the same receive buffers with no performance penalty. However, it means that keeping up with the packet rate matters more than for conventional cards.




## [ExaNIC Library (libexanic) Usage](https://exablaze.com/docs/exanic/user-guide/libexanic/)

The libexanic is a low-level access library for the Cisco Nexus SmartNIC (formerly ExaNIC) hardware. It can be used to transmit and receive raw Ethernet packets with minimum possible latency. Customers who require higher level TCP/IP functionality should instead consider using SmartNIC Sockets.

This user guide walks through the main functions in libexanic in a tutorial format. Documentation for each function is also provided in the header files included with libexanic: all of the functions exposed to the user have a brief comment explaining their purpose, a listing of all the required arguments, and their return values.

It is recommended that users first consult the SmartNIC Configuration Guide and ensure that that the software is installed and working.

## Quick start

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







