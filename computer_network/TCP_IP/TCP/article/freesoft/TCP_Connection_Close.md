# [TCP Connection Close](https://www.freesoft.org/CIE/Course/Section4/11.htm)

- [TCP Connection Close](#tcp-connection-close)
  - [Case 1: Local user initiates the close](#case-1-local-user-initiates-the-close)
  - [Case 2: TCP receives a `FIN` from the network](#case-2-tcp-receives-a-fin-from-the-network)
  - [Case 3: both users close simultaneously](#case-3-both-users-close-simultaneously)

`CLOSE` is an operation meaning "I have no more data to send." The notion of closing a full-duplex connection is subject to ambiguous interpretation, of course, since it may not be obvious how to treat the receiving side of the connection. We have chosen to treat `CLOSE` in a simplex fashion. **The user who `CLOSE`s may continue to `RECEIVE` until he is told that the other side has `CLOSED` also**. Thus, a program could initiate several `SEND`s followed by a `CLOSE`, and then continue to `RECEIVE` until signaled that a `RECEIVE` failed because the other side has `CLOSED`. We assume that the TCP will signal a user, even if no `RECEIVE`s are outstanding, that the other side has closed, so the user can terminate his side gracefully. **A TCP will reliably deliver all buffers `SENT` before the connection was `CLOSED`** so a user who expects no data in return need only wait to hear the connection was `CLOSED` successfully to know that all his data was received at the destination TCP. Users must keep reading connections they **close for sending** until the TCP says no more data. There are essentially three cases:

1. The user initiates by telling the TCP to `CLOSE` the connection

2. The remote TCP initiates by sending a `FIN` control signal

3. Both users `CLOSE` simultaneously

## Case 1: Local user initiates the close

In this case, a **`FIN` segment** can be constructed and placed on the outgoing segment queue. **No further `SEND`s from the user will be accepted by the TCP**, and it enters the `FIN-WAIT-1` state. `RECEIVE`s are allowed in this state. All segments preceding and including `FIN` will be **retransmitted** until acknowledged. When the other TCP has both acknowledged the `FIN` and sent a `FIN` of its own, the first TCP can `ACK` this `FIN`. Note that a TCP receiving a `FIN` will `ACK` but **not send its own `FIN` until its user has `CLOSED` the connection** also.

## Case 2: TCP receives a `FIN` from the network

If an unsolicited `FIN` arrives from the network, the receiving TCP can `ACK` it and tell **the user that the connection is closing**. The user will respond with a `CLOSE`, upon which the TCP can send a `FIN` to the other TCP **after sending any remaining data**. The TCP then waits until its own `FIN` is acknowledged whereupon it deletes the connection. If an `ACK` is not forthcoming, after the user timeout the connection is **aborted** and the user is told.

## Case 3: both users close simultaneously

A simultaneous `CLOSE` by users at both ends of a connection causes `FIN` segments to be exchanged. When all segments preceding the `FIN`s have been processed and acknowledged, each TCP can `ACK` the `FIN` it has received. Both will, upon receiving these `ACK`s, delete the connection.

        TCP A                                                TCP B
  
    1.  ESTABLISHED                                          ESTABLISHED
  
    2.  (Close)
        FIN-WAIT-1  --> <SEQ=100><ACK=300><CTL=FIN,ACK>  --> CLOSE-WAIT
  
    3.  FIN-WAIT-2  <-- <SEQ=300><ACK=101><CTL=ACK>      <-- CLOSE-WAIT
  
    4.                                                       (Close)
        TIME-WAIT   <-- <SEQ=300><ACK=101><CTL=FIN,ACK>  <-- LAST-ACK
  
    5.  TIME-WAIT   --> <SEQ=101><ACK=301><CTL=ACK>      --> CLOSED
  
    6.  (2 MSL)
        CLOSED                                                      
  
                           Normal Close Sequence
  
                                 Figure 13.
        TCP A                                                TCP B
  
    1.  ESTABLISHED                                          ESTABLISHED
  
    2.  (Close)                                              (Close)
        FIN-WAIT-1  --> <SEQ=100><ACK=300><CTL=FIN,ACK>  ... FIN-WAIT-1
                    <-- <SEQ=300><ACK=100><CTL=FIN,ACK>  <--
                    ... <SEQ=100><ACK=300><CTL=FIN,ACK>  -->
  
    3.  CLOSING     --> <SEQ=101><ACK=301><CTL=ACK>      ... CLOSING
                    <-- <SEQ=301><ACK=101><CTL=ACK>      <--
                    ... <SEQ=101><ACK=301><CTL=ACK>      -->
  
    4.  TIME-WAIT                                            TIME-WAIT
        (2 MSL)                                              (2 MSL)
        CLOSED                                               CLOSED
  
                        Simultaneous Close Sequence
  
                                 Figure 14.
