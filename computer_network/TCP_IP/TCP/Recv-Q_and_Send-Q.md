# [Recv-Q and Send-Q](https://stackoverflow.com/questions/36466744/use-of-recv-q-and-send-q)

- [Recv-Q and Send-Q](#recv-q-and-send-q)
  - [Use of Recv-Q and Send-Q](#use-of-recv-q-and-send-q)
    - [EDIT:](#edit)
  - [linux : netstat listening queue length](#linux--netstat-listening-queue-length)

## [Use of Recv-Q and Send-Q](https://stackoverflow.com/questions/36466744/use-of-recv-q-and-send-q)

From my man page:

> Recv-Q
>
> Established: The count of bytes not copied by the user program connected to this socket.
>
> Listening: Since Kernel 2.6.18 this column contains the current syn backlog.
>
> Send-Q
>
> Established: The count of bytes not acknowledged by the remote host.
>
> Listening: Since Kernel 2.6.18 this column contains the maximum size of the syn backlog.

If you have this stuck to 0, this just mean that your applications, on both side of the connection, and the network between them, are doing OK. Actual instant values may be different from 0, but in such a transient, fugitive manner that you don't get a chance to actually observe it.

Example of real-life scenario where this might be different from 0 (on established connections, but I think you'll get the idea):

I recently worked on a Linux embedded device talking to a (poorly designed) third party device. On this third party device, the application clearly got stuck sometimes, not reading the data it received on TCP connection, resulting in its TCP window going down to 0 and staying stuck there for tens of seconds (phenomenon observed via wireshark on a mirrored port between the 2 hosts). In such case:

- **Recv-Q**: running `netstat` on the third party device (which I had no mean to do) may have show an increasing Recv-Q, up to some roof value where the other side (me) stop sending data because the window get down to 0, since the application does not read the data available on its socket, and these data stay buffered in the TCP implementation in the OS, not going to the stuck application -> from the receiver side, application issue.

- **Send-Q**: running `netstat` on my side (which I did not tried because 1/ the problem was clear from wireshark and was the first case above and 2/ this was not 100% reproducible) may have show a non-zero Send-Q, if the other side TCP implementation at the OS level have been stucked and stopped ACKnowleding my data -> from the sender side, receiving TCP implementation (typically at the OS level) issue.

Note that the Send-Q scenario depicted above may also be a sending side issue (my side) if my Linux TCP implementation was misbehaving and continued to send data after the TCP window went down to 0: the receiving side then has no more room for this data -> does not ACKnowledge.

Note also that the Send-Q issue may be caused not because of the receiver, but by some routing issue somewhere between the sender and the receiver. Some packets are "on the fly" between the 2 hosts, but not ACKnowledge yet. On the other hand, the Recv-Q issue is definitly on a host: packets received, ACKnowledged, but not read from the application yet.

### EDIT:

In real life, with non-crappy hosts and applications as you can reasonably expect, I'd bet the Send-Q issue to be caused most of the time by some routing issue/network poor performances between the sending and receiving side. The "on the fly" state of packets should never be forgotten:

- The packet may be on the network between the sender and the receiver,

- (or received but ACK not send yet, see above)

- or the ACK may be on the network between the receiver and the sender.

It takes a RTT (round time trip) for a packet to be send and then ACKed.

## [linux : netstat listening queue length](https://serverfault.com/questions/432022/linux-netstat-listening-queue-length)

Let's look into source code, as it's the best documentation in the world of open source.

`net/ipv4/tcp_diag.c`:

    if (sk->sk_state == TCP_LISTEN) {
        r->idiag_rqueue = sk->sk_ack_backlog;
        r->idiag_wqueue = sk->sk_max_ack_backlog;
    } else {
        r->idiag_rqueue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
        r->idiag_wqueue = tp->write_seq - tp->snd_una;
    }

The same thing we can see in unix domain sockets, `net/unix/diag.c`:

    if (sk->sk_state == TCP_LISTEN) {
        rql.udiag_rqueue = sk->sk_receive_queue.qlen;
        rql.udiag_wqueue = sk->sk_max_ack_backlog;
    } else {
        rql.udiag_rqueue = (u32) unix_inq_len(sk);
        rql.udiag_wqueue = (u32) unix_outq_len(sk);
    }

So.

If **socket is established**, Recv-Q and Send-Q means bytes as it's described in documentation.

If **socket is listening**, Recv-Q means current queue size, and Send-Q means configured backlog.

Going deeper into mans gives us folowing in [sock_diag(7)](http://man7.org/linux/man-pages/man7/sock_diag.7.html):

      UDIAG_SHOW_RQLEN
             The attribute reported in answer to this request is
             UNIX_DIAG_RQLEN.  The payload associated with this
             attribute is represented in the following structure:

                 struct unix_diag_rqlen {
                     __u32 udiag_rqueue;
                     __u32 udiag_wqueue;
                 };

             The fields of this structure are as follows:

             udiag_rqueue
                    For listening sockets: the number of pending
                    connections.  The length of the array associated
                    with the UNIX_DIAG_ICONS response attribute is
                    equal to this value.

                    For established sockets: the amount of data in
                    incoming queue.

             udiag_wqueue
                    For listening sockets: the backlog length which
                    equals to the value passed as the second argu‐
                    ment to listen(2).

                    For established sockets: the amount of memory
                    available for sending.

In other words, `ss -ln` is the only command you need
