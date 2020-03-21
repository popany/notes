# TCP/IP

- [TCP/IP](#tcpip)
  - [IPv4 datagram](#ipv4-datagram)
  - [IPv4 fragment](#ipv4-fragment)
    - [An Example Reassembly Procedure <ref>](#an-example-reassembly-procedure-ref)
  - [maximum transmission unit (MTU)](#maximum-transmission-unit-mtu)
  - [socket](#socket)
    - [`connect`](#connect)
    - [others](#others)

## IPv4 datagram

The maximum size of an IPv4 datagram is 65,535 bytes.

All hosts must be prepared to accept datagrams of up to 576 octets (whether they arrive whole or in fragments). <[ref](https://tools.ietf.org/html/rfc791)>

The maximal internet header is 60 octets, and a typical internet header is 20 octets, allowing a margin for headers of higher level protocols. <[ref](https://tools.ietf.org/html/rfc791)>

## IPv4 fragment

To assemble the fragments of an internet datagram, an internet protocol module (for example at a destination host) combines internet datagrams that all have the same value for the four fields: identification, source, destination, and protocol. <[ref](https://tools.ietf.org/html/rfc791)>

### An Example Reassembly Procedure <[ref](https://tools.ietf.org/html/rfc791)>

For each datagram the buffer identifier is computed as the concatenation of the source, destination, protocol, and identification fields. If this is a whole datagram (that is both the fragment offset and the more fragments fields are zero), then any reassembly resources associated with this buffer identifier are released and the datagram is forwarded to the next step in datagram processing.

If no other fragment with this buffer identifier is on hand then reassembly resources are allocated. The reassembly resources consist of a data buffer, a header buffer, a fragment block bit table, a total data length field, and a timer. The data from the fragment is placed in the data buffer according to its fragment offset and length, and bits are set in the fragment block bit table corresponding to the fragment blocks received.

If this is the first fragment (that is the fragment offset is zero) this header is placed in the header buffer. If this is the last fragment (that is the more fragments field is zero) the total data length is computed. If this fragment completes the datagram (tested by checking the bits set in the fragment block table), then the datagram is sent to the next step in datagram processing; otherwise the timer is set to the maximum of the current timer value and the value of the time to live field from this fragment; and the reassembly routine gives up control.

## maximum transmission unit (MTU)

The maximum sized datagram that can be transmitted through the next network is called the maximum transmission unit (MTU). <[ref](https://tools.ietf.org/html/rfc791)>

Every internet module must be able to forward a datagram of 68 octets without further fragmentation. This is because an internet header may be up to 60 octets, and the minimum fragment is 8 octets. <[ref](https://tools.ietf.org/html/rfc791)>

## socket

### `connect`

If `connect` fails, the socket is no longer usable and must be closed. We cannot call `connect` again on the socket, we must close the socket descriptor and call socket again.

When `connect` is interrupted by a caught signal and is not automatically restarted, we must call `select` to wait for the connection to complete.

### others

[How do SO_REUSEADDR and SO_REUSEPORT differ?](https://stackoverflow.com/questions/14388706/how-do-so-reuseaddr-and-so-reuseport-differ)

[Example: Nonblocking I/O and select()](https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/rzab6/xnonblock.htm)
