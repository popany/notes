# half-close half-open

- [half-close half-open](#half-close-half-open)

## [TCP half-open - wikipedia](https://en.wikipedia.org/wiki/TCP_half-open)

The term **half-open** refers to TCP connections whose state is out of synchronization between the two communicating hosts, possibly due to a crash of one side. A connection which is in the process of being established is also known as **embryonic connection**. The lack of synchronization could be due to [malicious intent](https://en.wikipedia.org/wiki/SYN_flood).

## TCP half-close - TCP/IP Illustrated, Volume 1 Second Edition 13.2 TCP Connection Establishment and Termination

While it takes three segments to establish a connection, it takes four to terminate one. It is also possible for the connection to be in a **half-open** state (see Section 13.6.3), although this is not common. This reason is that TCP’s data communications model is bidirectional, meaning it is possible to have only one of the two directions operating. The **half-close** operation in TCP closes only a single direction of the data flow. Two half-close operations together close the entire connection. The rule is that either end can send a `FIN` when it is done sending data. When a TCP receives a `FIN`, it must notify the application that the other end has terminated that direction of data flow. The sending of a `FIN` is normally the result of the application issuing a close operation, which typically causes both directions to close.

## TCP half-open - TCP/IP Illustrated, Volume 1 Second Edition 13.6.3 Half-Open Connections

A TCP connection is said to be `half-open` if one end has closed or aborted the connection without the knowledge of the other end. This can happen anytime one of the **peers crashes**. As long as there is **no attempt to transfer data** across a `half-open` connection, the end that is still up **does not detect** that the other end has crashed.

Another common cause of a `half-open` connection is when **one host is powered off** instead of shut down properly. This happens, for example, when PCs are being used to run remote login clients and are switched off at the end of the day. If there was no data transfer going on when the power was cut, the **server will never know that the client disappeared** (it would still think the connection is in the `ESTABLISHED` state). When the user comes in the next morning, powers on the PC, and starts a new session, a new occurrence of the server is started on the server host. This can **lead to many half-open TCP connections on the server host**. (In Chapter 17 we will see a way for one end of a TCP connection to discover that the other end has disappeared using **TCP’s keepalive option**.)

We can easily create a `half-open` connection. In this case, we do so on the client rather than the server. We will execute the Telnet client on `10.0.0.1`, connecting to the Sun RPC Service (`sunrpc`, port 111) server at `10.0.0.7` (see Listing 13-7). We type one line of input and watch it go across with `tcpdump`, and then we disconnect the Ethernet cable on the server’s host and reboot the server host. This simulates the server host crashing. (We disconnect the Ethernet cable before rebooting the server to prevent it from sending a `FIN` out of the open connections, which some TCPs do when they are shut down.) After the server has rebooted, we reconnect the cable and try to send another line from the client to the server. After rebooting, the server’s TCP has lost all memory of the connections that existed before, so it knows nothing about the connection that the data segment references. The rule of TCP is that the receiver responds with a reset.

## [TCP Connection Life](https://stackoverflow.com/questions/158674/tcp-connection-life)

### Bart Read

I agree with Zan Lynx. There's no guarantee, but you can keep a connection alive **almost indefinitely** by sending data over it, assuming there are no connectivity or bandwidth issues.

Generally I've gone for the **application level keep-alive** approach, although this has usually because it's been in the client spec so I've had to do it. But just send some short piece of data every minute or two, to which you expect some sort of acknowledgement.

Whether you count one failure to acknowledge as the connection having failed is up to you. Generally this is what I have done in the past, although there was a case I had wait for three failed responses in a row to drop the connection because the app at the other end of the connection was extremely flaky about responding to "are you there?" requests.

If the connection fails, which at some point it probably will, even with machines on the same network, then just try to reestablish it. If that fails a set number of times then you have a problem. If your connection persistently fails after it's been connected for a while then again, you have a problem. Most likely in both cases it's probably some network issue, rather than your code, or maybe a problem with the TCP/IP stack on your machine (has been known: I encountered issues with this on an old version of QNX--it'd just randomly fall over). Having said that you might have a software problem, and the only way to know for sure is often to attach a debugger, or to get some logging in there. E.g. if you can always connect successfully, but after a time you stop getting ACKs, even after reconnect, then maybe your server is deadlocking, or getting stuck in a loop or something.

What's really useful is to set up a series of long-running tests under a variety of load conditions, from just sending the keep alive are you there?/ack requests and responses, to absolutely battering the server. This will generally give you more confidence about your software components, and can be really useful in shaking out some really weird problems which won't necessarily cause a problem with your connection, although they might result in problems with the transactions taking place. For example, I was once writing a telecoms application server that provided services such as number translation, and we'd just leave it running for days at a time. The thing was that when Saturday came round, for the whole day, it would reject every call request that came in, which amounted to millions of calls, and we had no idea why. It turned out to be because of a single typo in some date conversion code that only caused a problem on Saturdays.

Hope that helps.

### community wiki benc

I think the most important idea here is theory vs. practice.

The original theory was that the connections had no lifetimes. If you had a connection, it stayed **open forever**, even if there was no traffic, until an event caused it to close.

The new theory is that most OS releases have turned on the **keep-alive timer**. This means that connections will last forever, as long as the system on the other end responds to an occasional TCP-level exchange.

In reality, many connections will be terminated after time, with a variety of criteria and situations.

Two really good examples are: The remote client is using **DHCP**, the lease expires, and the IP address changes.

Another example is **firewalls**, which seem to be increasingly intelligent, and can identify keep-alive traffic vs. real data, and close connections based on any high level criteria, especially idle time.

How you want to implement reconnect logic depends a lot on your architecture, the working environment, and your performance goals.
