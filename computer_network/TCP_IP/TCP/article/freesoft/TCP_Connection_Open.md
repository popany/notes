# [TCP Connection Open](https://www.freesoft.org/CIE/Course/Section4/10.htm)

- [TCP Connection Open](#tcp-connection-open)
  - [Half-Open Connections and Other Anomalies](#half-open-connections-and-other-anomalies)
  - [Reset Generation](#reset-generation)
  - [Reset Processing](#reset-processing)

The "three-way handshake" is the procedure used to establish a connection. This procedure **normally is initiated by one TCP and responded to by another TCP**. The procedure **also works if two TCP simultaneously initiate the procedure**. **When simultaneous attempt occurs, each TCP receives a "SYN" segment which carries no acknowledgment after it has sent a "SYN"**. Of course, the arrival of an old duplicate "SYN" segment can potentially make it appear, to the recipient, that a simultaneous connection initiation is in progress. Proper use of "reset" segments can disambiguate these cases.

Several examples of connection initiation follow. Although these examples do not show connection synchronization using data-carrying segments, this is perfectly legitimate, **so long as the receiving TCP doesn't deliver the data to the user until it is clear the data is valid** (i.e., the data must be buffered at the receiver until the connection reaches the `ESTABLISHED` state). The three-way handshake reduces the possibility of false connections. It is the implementation of a **trade-off between memory and messages** to provide information for this checking.

**The simplest three-way handshake is shown in figure 7 below**. The figures should be interpreted in the following way. Each line is numbered for reference purposes. Right arrows (-->) indicate departure of a TCP segment from TCP A to TCP B, or arrival of a segment at B from A. Left arrows (<--), indicate the reverse. Ellipsis (...) indicates a segment which is still in the network (delayed). An "XXX" indicates a segment which is lost or rejected. Comments appear in parentheses. TCP states represent the state AFTER the departure or arrival of the segment (whose contents are shown in the center of each line). Segment contents are shown in abbreviated form, with sequence number, control flags, and ACK field. Other fields such as window, addresses, lengths, and text have been left out in the interest of clarity.

        TCP A                                                TCP B
  
    1.  CLOSED                                               LISTEN
  
    2.  SYN-SENT    --> <SEQ=100><CTL=SYN>               --> SYN-RECEIVED
  
    3.  ESTABLISHED <-- <SEQ=300><ACK=101><CTL=SYN,ACK>  <-- SYN-RECEIVED
  
    4.  ESTABLISHED --> <SEQ=101><ACK=301><CTL=ACK>       --> ESTABLISHED
  
    5.  ESTABLISHED --> <SEQ=101><ACK=301><CTL=ACK><DATA> --> ESTABLISHED
  
            Basic 3-Way Handshake for Connection Synchronization
  
                                  Figure 7.

In line 2 of figure 7, TCP A begins by sending a SYN segment indicating that it will use sequence numbers starting with sequence number 100. In line 3, TCP B sends a SYN and acknowledges the SYN it received from TCP A. Note that the acknowledgment field indicates TCP B is now expecting to hear sequence 101, acknowledging the SYN which occupied sequence 100.

At line 4, TCP A responds with an empty segment containing an ACK for TCP B's SYN; and in line 5, TCP A sends some data. Note that the sequence number of the segment in line 5 is the same as in line 4 because the **ACK does not occupy sequence number space** (if it did, we would wind up ACKing ACK's!).

**Simultaneous initiation is only slightly more complex, as is shown in figure 8**. Each TCP cycles from `CLOSED` to `SYN-SENT` to `SYN-RECEIVED` to `ESTABLISHED`.

        TCP A                                            TCP B
  
    1.  CLOSED                                           CLOSED
  
    2.  SYN-SENT     --> <SEQ=100><CTL=SYN>              ...
  
    3.  SYN-RECEIVED <-- <SEQ=300><CTL=SYN>              <-- SYN-SENT
  
    4.               ... <SEQ=100><CTL=SYN>              --> SYN-RECEIVED
  
    5.  SYN-RECEIVED --> <SEQ=100><ACK=301><CTL=SYN,ACK> ...
  
    6.  ESTABLISHED  <-- <SEQ=300><ACK=101><CTL=SYN,ACK> <-- SYN-RECEIVED
  
    7.               ... <SEQ=101><ACK=301><CTL=ACK>     --> ESTABLISHED
  
                  Simultaneous Connection Synchronization
  
                                 Figure 8.

The principle reason for the three-way handshake is to prevent old duplicate connection initiations from causing confusion. To deal with this, a special control message, reset, has been devised. If the receiving TCP is in a **non-synchronized state** (i.e., `SYN-SENT`, `SYN-RECEIVED`), it returns to LISTEN on receiving an acceptable reset. If the TCP is in one of the **synchronized states** (`ESTABLISHED`, `FIN-WAIT-1`, `FIN-WAIT-2`, `CLOSE-WAIT`, `CLOSING`, `LAST-ACK`, TIME-WAIT), it aborts the connection and informs its user. We discuss this latter case under "half-open" connections below.

        TCP A                                                TCP B
  
    1.  CLOSED                                               LISTEN
  
    2.  SYN-SENT    --> <SEQ=100><CTL=SYN>               ...
  
    3.  (duplicate) ... <SEQ=90><CTL=SYN>               --> SYN-RECEIVED
  
    4.  SYN-SENT    <-- <SEQ=300><ACK=91><CTL=SYN,ACK>  <-- SYN-RECEIVED
  
    5.  SYN-SENT    --> <SEQ=91><CTL=RST>               --> LISTEN
  
    6.              ... <SEQ=100><CTL=SYN>               --> SYN-RECEIVED
  
    7.  SYN-SENT    <-- <SEQ=400><ACK=101><CTL=SYN,ACK>  <-- SYN-RECEIVED
  
    8.  ESTABLISHED --> <SEQ=101><ACK=401><CTL=ACK>      --> ESTABLISHED
  
                      Recovery from Old Duplicate SYN
  
                                 Figure 9.

**As a simple example of recovery from old duplicates, consider figure 9**. At line 3, an **old duplicate `SYN`** arrives at TCP B. TCP B cannot tell that this is an old duplicate, so it responds normally (line 4). TCP A detects that the ACK field is incorrect and returns a `RST` (reset) with its `SEQ` field selected to make the segment believable. TCP B, on receiving the `RST`, returns to the `LISTEN` state. When the original `SYN` (pun intended) finally arrives at line 6, the synchronization proceeds normally. If the SYN at line 6 had arrived before the RST, a more complex exchange might have occurred with RST's sent in both directions.

## Half-Open Connections and Other Anomalies

An established connection is said to be "**half-open**" if one of the TCPs has closed or aborted the connection at its end without the knowledge of the other, or if the two ends of the connection have become desynchronized owing to a crash that resulted in loss of memory. Such connections will automatically become reset if an attempt is made to send data in either direction. However, **half-open connections are expected to be unusual, and the recovery procedure is mildly involved**.

If at site A the connection no longer exists, then an attempt by the user at site B to send any data on it will result in the site B TCP receiving a **reset control message**. Such a message indicates to the site B TCP that something is wrong, and it is expected to abort the connection.

Assume that two user processes A and B are communicating with one another when a crash occurs causing loss of memory to A's TCP. Depending on the operating system supporting A's TCP, it is likely that some error recovery mechanism exists. When the TCP is up again, A is likely to start again from the beginning or from a recovery point. As a result, A will probably try to `OPEN` the connection again or try to `SEND` on the connection it believes open. In the latter case, it receives the error message "connection not open" from the local (A's) TCP. In an attempt to establish the connection, A's TCP will send a segment containing `SYN`. This scenario leads to the example shown in figure 10. After TCP A crashes, the user attempts to re-open the connection. TCP B, in the meantime, thinks the connection is open.

        TCP A                                           TCP B
  
    1.  (CRASH)                               (send 300,receive 100)
  
    2.  CLOSED                                           ESTABLISHED
  
    3.  SYN-SENT --> <SEQ=400><CTL=SYN>              --> (??)
  
    4.  (!!)     <-- <SEQ=300><ACK=100><CTL=ACK>     <-- ESTABLISHED
  
    5.  SYN-SENT --> <SEQ=100><CTL=RST>              --> (Abort!!)
  
    6.  SYN-SENT                                         CLOSED
  
    7.  SYN-SENT --> <SEQ=400><CTL=SYN>              -->
  
                       Half-Open Connection Discovery
  
                                 Figure 10.

When the SYN arrives at line 3, TCP B, being in a synchronized state, and the incoming segment outside the window, responds with an acknowledgment indicating what sequence it next expects to hear (`ACK` 100). TCP A sees that this segment does not acknowledge anything it sent and, being unsynchronized, sends a reset (`RST`) because it has detected a half-open connection. TCP B aborts at line 5. TCP A will continue to try to establish the connection; the problem is now reduced to the basic 3-way handshake of figure 7.

An interesting alternative case occurs when TCP A crashes and TCP B tries to send data on what it thinks is a synchronized connection. This is illustrated in figure 11. In this case, the data arriving at TCP A from TCP B (line 2) is unacceptable because no such connection exists, so TCP A sends a `RST`. The `RST` is acceptable so TCP B processes it and aborts the connection.

          TCP A                                              TCP B
  
    1.  (CRASH)                                   (send 300,receive 100)
  
    2.  (??)    <-- <SEQ=300><ACK=100><DATA=10><CTL=ACK> <-- ESTABLISHED
  
    3.          --> <SEQ=100><CTL=RST>                   --> (ABORT!!)
  
             Active Side Causes Half-Open Connection Discovery
  
                                 Figure 11.

In figure 12, we find the two TCPs A and B with passive connections waiting for `SYN`. An old duplicate arriving at TCP B (line 2) stirs B into action. A `SYN-ACK` is returned (line 3) and causes TCP A to generate a `RST` (the ACK in line 3 is not acceptable). TCP B accepts the reset and returns to its passive `LISTEN` state.

        TCP A                                         TCP B
  
    1.  LISTEN                                        LISTEN
  
    2.       ... <SEQ=Z><CTL=SYN>                -->  SYN-RECEIVED
  
    3.  (??) <-- <SEQ=X><ACK=Z+1><CTL=SYN,ACK>   <--  SYN-RECEIVED
  
    4.       --> <SEQ=Z+1><CTL=RST>              -->  (return to LISTEN!)
  
    5.  LISTEN                                        LISTEN
  
         Old Duplicate SYN Initiates a Reset on two Passive Sockets
  
                                 Figure 12.

A variety of other cases are possible, all of which are accounted for by the following rules for `RST` generation and processing.

## Reset Generation

As a general rule, reset (`RST`) must be sent whenever a segment arrives which apparently is not intended for the current connection. A reset must not be sent if it is not clear that this is the case.

There are three groups of states:

1. If the connection does not exist (`CLOSED`) then a reset is sent in response to any incoming segment except another reset. In particular, `SYN`s addressed to a non-existent connection are rejected by this means.

   If the incoming segment has an `ACK` field, the reset takes its sequence number from the `ACK` field of the segment, otherwise the reset has sequence number zero and the `ACK` field is set to the sum of the sequence number and segment length of the incoming segment. The connection remains in the `CLOSED` state.

2. If the connection is in any non-synchronized state (`LISTEN`, `SYN-SENT`, `SYN-RECEIVED`), and the incoming segment acknowledges something not yet sent (the segment carries an unacceptable `ACK`), or if an incoming segment has a security level or compartment which does not exactly match the level and compartment requested for the connection, a reset is sent.

   If our SYN has not been acknowledged and the precedence level of the incoming segment is higher than the precedence level requested then either raise the local precedence level (if allowed by the user and the system) or send a reset; or if the precedence level of the incoming segment is lower than the precedence level requested then continue as if the precedence matched exactly (if the remote TCP cannot raise the precedence level to match ours this will be detected in the next segment it sends, and the connection will be terminated then).  If our SYN has been acknowledged (perhaps in this incoming segment) the precedence level of the incoming segment must match the local precedence level exactly, if it does not a reset must be sent.

   If the incoming segment has an ACK field, the reset takes its sequence number from the ACK field of the segment, otherwise the reset has sequence number zero and the ACK field is set to the sum of the sequence number and segment length of the incoming segment. The connection remains in the same state.

3. If the connection is in a synchronized state (ESTABLISHED, FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT), any unacceptable segment (out of window sequence number or unacceptible acknowledgment number) must elicit only an empty acknowledgment segment containing the current send-sequence number and an acknowledgment indicating the next sequence number expected to be received, and the connection remains in the same state.

  If an incoming segment has a security level, or compartment, or precedence which does not exactly match the level, and compartment, and precedence requested for the connection,a reset is sent and connection goes to the CLOSED state. The reset takes its sequence number from the ACK field of the incoming segment.

## Reset Processing

In all states except `SYN-SENT`, all reset (`RST`) segments are validated by checking their SEQ-fields. **A reset is valid if its sequence number is in the window**. In the `SYN-SENT` state (a `RST` received in response to an initial `SYN`), the `RST` is acceptable if the `ACK` field acknowledges the `SYN`.

The receiver of a `RST` first validates it, then changes state. If the receiver was in the `LISTEN` state, it ignores it. If the receiver was in `SYN-RECEIVED` state and had previously been in the `LISTEN` state, then the receiver returns to the `LISTEN` state, otherwise the receiver aborts the connection and goes to the `CLOSED` state. If the receiver was in any other state, it aborts the connection and advises the user and goes to the `CLOSED` state.
