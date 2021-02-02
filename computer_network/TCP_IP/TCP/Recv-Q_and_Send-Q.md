# [Recv-Q and Send-Q](https://stackoverflow.com/questions/36466744/use-of-recv-q-and-send-q)

- [Recv-Q and Send-Q](#recv-q-and-send-q)
  - [Use of Recv-Q and Send-Q](#use-of-recv-q-and-send-q)
    - [EDIT:](#edit)

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
