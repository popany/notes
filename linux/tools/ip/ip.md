# ip

- [ip](#ip)
  - [`route get`](#route-get)

## `route get`

You can query the kernel routing tables using the ip command. Its route get subcommand will tell you exactly how the kernel will route a packet to a destination address:

    $ ip route get to 10.0.2.2
    10.0.2.2 dev eth0  src 10.0.2.15

whereas

    $ ip route get to 192.168.3.5
    192.168.3.5 via 10.0.2.2 dev eth0  src 10.0.2.15

and

    $ ip route get to 127.0.1.1
    local 127.0.1.1 dev lo  src 127.0.0.1
