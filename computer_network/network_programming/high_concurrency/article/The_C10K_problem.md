# [The C10K problem](http://www.kegel.com/c10k.html)

- [The C10K problem](#the-c10k-problem)
  - [Related Sites](#related-sites)
  - [Book to Read First](#book-to-read-first)

It's time for web servers to handle ten thousand clients simultaneously, don't you think? After all, the web is a big place now.

And computers are big, too. You can buy a 1000MHz machine with 2 gigabytes of RAM and an 1000Mbit/sec Ethernet card for $1200 or so. Let's see - at 20000 clients, that's 50KHz, 100Kbytes, and 50Kbits/sec per client. It shouldn't take any more horsepower than that to take four kilobytes from the disk and send them to the network once a second for each of twenty thousand clients. (That works out to $0.08 per client, by the way. Those $100/client licensing fees some operating systems charge are starting to look a little heavy!) So hardware is no longer the bottleneck.

In 1999 one of the busiest ftp sites, cdrom.com, actually handled 10000 clients simultaneously through a Gigabit Ethernet pipe. As of 2001, that same speed is now [being offered by several ISPs](http://www.senteco.com/telecom/ethernet.htm), who expect it to become increasingly popular with large business customers.

And the thin client model of computing appears to be coming back in style -- this time with the server out on the Internet, serving thousands of clients.

With that in mind, here are a few notes on how to configure operating systems and write code to support thousands of clients. The discussion centers around Unix-like operating systems, as that's my personal area of interest, but Windows is also covered a bit.

## Related Sites

See Nick Black's execellent [Fast UNIX Servers](http://dank.qemfd.net/dankwiki/index.php/Network_servers) page for a circa-2009 look at the situation.

In October 2003, Felix von Leitner put together an excellent web page and presentation about network scalability, complete with benchmarks comparing various networking system calls and operating systems. One of his observations is that the 2.6 Linux kernel really does beat the 2.4 kernel, but there are many, many good graphs that will give the OS developers food for thought for some time. (See also the Slashdot comments; it'll be interesting to see whether anyone does followup benchmarks improving on Felix's results.)

## Book to Read First







TODO c10k xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx