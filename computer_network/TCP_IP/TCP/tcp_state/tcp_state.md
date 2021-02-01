# TCP State

- [TCP State](#tcp-state)

## [Why is the last ACK needed in TCP four way termination](https://networkengineering.stackexchange.com/questions/38805/why-is-the-last-ack-needed-in-tcp-four-way-termination)

    A -----FIN-----> B
    FIN_WAIT_1       CLOSE_WAIT
    A <----ACK------ B
    FIN_WAIT_2

    (B can send more data here, this is half-close state)

    A <----FIN------ B
    TIME_WAIT        LAST_ACK
    A -----ACK-----> B
    |                CLOSED
    2MSL Timer
    |
    CLOSED

The ACK to a FIN is required because the end sending the FIN will retransmit it until it receives an ACK. So, the question is, why TCP keeps sending the FIN if not ACK is received? My understanding is that given that a connection may be in a half-close state, the side that is receiving the last FIN (A in your diagram) may be waiting for data "indefinitely" wasting resources in that end when no more data will be received. B needs to be sure that A received the FIN (and closes the connection), hence it requires an ACK.

### Edit

To be more precise about half-close. In your example, A can close its side of the connection sending the first FIN and receiving the first ACK, but B can keep sending more data at will for any period of time before closing the connection and sending the last FIN. So, the time between the first FIN/ACK sequence and the second one can't be determined or timed-out. A needs the last FIN to be sure B has closed its side of the connection.

### Edit 2

What happen if the last FIN from B to A is lost? Then, B will not receive the ACK and will retransmit the FIN until it receives an ACK. So, A will eventually get the FIN and transition to the TIME_WAIT state.

    A -----FIN-----> B
    FIN_WAIT_1       CLOSE_WAIT
    A <----ACK------ B
    FIN_WAIT_2

    (B can send more data here, this is half-close state)

    A  X<--FIN------ B
    FIN_WAIT_2       LAST_ACK
                    (timeout waiting for ACK)
    A <----FIN------ B
    TIME_WAIT
    A -----ACK-----> B
    |                CLOSED
    2MSL Timer
    |
    CLOSED

What happen if the last ACK is lost? Then, B will think that A did not receive the FIN and will retransmit the FIN. From B point of view this is the same as if the FIN was lost, from A point of view this different since A now is in the TIME_WAIT or CLOSED state. When A receives the new FIN from A if it is in the TIME_WAIT state it will send the ACK again.

    A -----FIN-----> B
    FIN_WAIT_1       CLOSE_WAIT
    A <----ACK------ B
    FIN_WAIT_2

    (B can send more data here, this is half-close state)

    A <----FIN------ B
    TIME_WAIT        LAST_ACK
    A -----ACK-->X   B
    TIME_WAIT        LAST_ACK
                    (timeout waiting for ACK)
    A <----FIN------ B
    A -----ACK-----> B
    |                CLOSED
    2MSL Timer
    |
    CLOSED

If A is in the CLOSED state it will send a RESET, in either case B will be able to close its side of the connection.

    A -----FIN-----> B
    FIN_WAIT_1       CLOSE_WAIT
    A <----ACK------ B
    FIN_WAIT_2

    (B can send more data here, this is half-close state)

    A <----FIN------ B
    TIME_WAIT        LAST_ACK
    A -----ACK-->X   B
    TIME_WAIT        LAST_ACK
    |
    2MSL Timer
    |
    CLOSED
                    (timeout waiting for ACK)
    A <----FIN------ B
    A -----RST-----> B
                    CLOSED

## [Bug 25986 - Socket would hang at LAST_ACK forever](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=25986)

## [What is the purpose of TIME WAIT in TCP connection tear down?](https://networkengineering.stackexchange.com/questions/19581/what-is-the-purpose-of-time-wait-in-tcp-connection-tear-down)

> Will the passive closer resend the `FIN` and then the active closer knows the `ACK` was lost?

Yes. Quoting from TCP/IP Illustrated Volume 1, in the TCP Connection Management section:

> To complete the close, the final segment contains an `ACK` for the last `FIN`. Note that if a `FIN` is lost, it is retransmitted until an `ACK` for it is received.

There is a timeout. When in `LAST_ACK`, the passive closer will resend `FIN` when there is a timeout, assuming that it was lost. If it was indeed lost, then the active closer will eventually receive the retransmitted `FIN` and enter `TIME_WAIT`. If the `FIN` was not lost but the final `ACK` was lost, then the active closer is in `TIME_WAIT` and receives `FIN` again. When this happens - receiving a `FIN` in `TIME_WAIT` - the `ACK` is retransmitted.

The timeout value in `TIME_WAIT` is NOT used for retransmission purposes. When there is a timeout in `TIME_WAIT`, it is assumed that the final `ACK` was successfully delivered because the passive closer didn't retransmit `FIN` packets. So, the timeout in `TIME_WAIT` is just an amount of time after which we can safely assume that if the other end didn't send anything, then it's because he received the final `ACK` and closed the connection.

## [The `TIME-WAIT` State](http://www.tcpipguide.com/free/t_TCPConnectionTermination-3.htm)

The device receiving the initial `FIN` may have to wait a fairly long time (in networking terms) in the `CLOSE-WAIT` state for the application it is serving to indicate that it is ready to shut down. TCP cannot make any assumptions about how long this will take. During this period of time, the server in our example above may continue sending data, and the client will receive it. However, the client will not send data to the server.

Eventually, the second device (the server in our example) will send a `FIN` to close its end of the connection. The device that originally initiated the close (the client above) will send an `ACK` for this `FIN`. However, the client cannot immediately go to the `CLOSED` state right after sending that `ACK`. The reason is that it must allow time for the `ACK` to travel to the server. Normally this will be quick, but delays might result in it being slowed down somewhat.

The `TIME-WAIT` state is required for two main reasons. **The first is to provide enough time to ensure that the `ACK` is received by the other device, and to retransmit it if it is lost. The second is to provide a "buffering period" between the end of this connection and any subsequent ones**. If not for this period, it is possible that packets from different connections could be mixed, creating confusion.

The standard specifies that the client should wait double a particular length of time called the **maximum segment lifetime (MSL)** before finishing the close of the connection. The TCP standard defines MSL as being a value of 120 seconds (2 minutes). In modern networks this is an eternity, so TCP allows implementations to choose a lower value if it is believed that will lead to better operation.
