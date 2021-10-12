# Note to ExaNIC User Guide

- [Note to ExaNIC User Guide](#note-to-exanic-user-guide)
  - [Architecture and Programming](#architecture-and-programming)
    - [receive (RX) buffers](#receive-rx-buffers)
    - [transmit (TX) buffers](#transmit-tx-buffers)
    - [exasock](#exasock)
    - [libexanic](#libexanic)
      - [Receive](#receive)
      - [In-place receive](#in-place-receive)
      - [Transmit](#transmit)
    - [Transmit preloading](#transmit-preloading)

## Architecture and Programming

### receive (RX) buffers

- located in host RAM

- 2 megabyte ring buffer

  - up to 33 ring buffers per port: 

    - the default buffer (0)

    - and up to 32 flow steering buffers

- lack of flow control

  - If the hardware gets more than 2 megabytes ahead of software, packets may be lost

  - allows multiple applications to receive packets from the same receive buffers with no performance penalty

  - keeping up with the packet rate matters more than for conventional cards

- chunk size

  - data is sent to the host in 'chunks' of 128 bytes

    - consisting of 120 bytes of data and 8 bytes of metadata.

    - This size was chosen as a trade-off between bandwidth and latency, and is assumed throughout the current architecture

### transmit (TX) buffers

- located on the SmartNIC

  - can be written directly by software via a memory mapping (but not read)

- To transmit a packet

  - software writes the packet data into the transmit buffer (together with a short header),

  - and then writes a register on the SmartNIC to start packet transmission.

- Applications can request parts of the transmit buffer, at a minimum granularity of 4KiB

### exasock

- allows applications to benefit from the low latency of direct access to the SmartNIC

  - without requiring modifications to the application

    - This is achieved by intercepting calls to the Linux socket APIs.

- It is possible to use `libexanic` simultaneously with `exasock`

### libexanic

#### Receive

- There is no limit to the number of applications that can connect to a receive buffer.

- Flow steering mode configures the SmartNIC hardware to redirect received frames from the default buffer to one of 32 userspace buffers.

#### In-place receive

  - direct consume the live RX ring buffer

  - the performance advantages are minimal

  - there is a risk of processing corrupt data if hardware overtakes software

#### Transmit

- Each application can allocate a portion of the available transmit buffer space.

### Transmit preloading

- loading the card with a packet before it is required to be sent,

- and using a single register write to trigger the packet to be sent.

- The general idea is to remove the overhead of transferring the packet from the critical path.















