# Simultaneous Open

- [Simultaneous Open](#simultaneous-open)
  - [tcp two sides trying to connect simultaneously](#tcp-two-sides-trying-to-connect-simultaneously)
    - [sigjuice's anwser](#sigjuices-anwser)
    - [Nikolai Fetissov' answer](#nikolai-fetissov-answer)

## [tcp two sides trying to connect simultaneously](https://stackoverflow.com/questions/2231283/tcp-two-sides-trying-to-connect-simultaneously)

### sigjuice's anwser

It is possible to cause a simultaneous TCP open using the sockets API. As Nikolai mentions, it is a matter of executing the following sequence with a timing such that the initial SYNs cross each other.

    bind addr1, port1
    connect addr2, port2
    bind addr2, port2
    connect addr1, port1

Here's how I achieved a simultaneous open using a single Linux host.

1. Slow down the loopback interface using [netem](http://www.linuxfoundation.org/collaborate/workgroups/networking/netem)

       tc qdisc add dev lo root handle 1:0 netem delay 5sec

2. Run `netcat` twice

       netcat -p 3000 127.0.0.1 2000
       netcat -p 2000 127.0.0.1 3000

The two netcat processes connect to each other resulting in a single TCP connection

    $ lsof -nP -c netcat -a -i # some columns removed 
    COMMAND   PID NAME
    netcat  27911 127.0.0.1:2000->127.0.0.1:3000 (ESTABLISHED)
    netcat  27912 127.0.0.1:3000->127.0.0.1:2000 (ESTABLISHED)

Here's what `tcpdump` showed me (output edited for clarity)

    127.0.0.1.2000 > 127.0.0.1.3000: Flags [S], seq 1139279069
    127.0.0.1.3000 > 127.0.0.1.2000: Flags [S], seq 1170088782
    127.0.0.1.3000 > 127.0.0.1.2000: Flags [S.], seq 1170088782, ack 1139279070
    127.0.0.1.2000 > 127.0.0.1.3000: Flags [S.], seq 1139279069, ack 1170088783

### Nikolai Fetissov' answer

We do passive server and active client because it's easy to understand, [relatively] easy to implement, and easy to code for. Think of a store and a customer, we'd be in one of these situations:

- Customer goes to the store (active client), the store is open (passive server) - both are happy.

- Customer goes to the store, the store is closed (no server listening) no luck for the customer.

- Store is open, no customers come - no luck for the store.

- Store is closed and no customers come - who a cares :)

Since the server passively waits for clients to connect it's easy to predict when a connection can take place. No pre-agreements (other then server address and port number) are necessary.

The simultaneous open, on the other hand, is subject to connect timeouts on both sides, i.e. this has to be carefully orchestrated for connection to take place so that SYNs cross "in-flight". It's an interesting artifact of the TCP protocol but I don't see any use for it in practice.

You can probably try simulating this by opening a socket, binding it to a port (so the other side knows where to connect to), and trying to connect. Both sides are symmetric. Can probably try that with `netcat` with `-p` option. You'd have to be pretty quick though :)
