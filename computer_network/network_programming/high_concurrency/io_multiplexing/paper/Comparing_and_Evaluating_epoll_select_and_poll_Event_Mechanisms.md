# [Comparing and Evaluating epoll, select, and poll Event Mechanisms](https://www.kernel.org/doc/ols/2004/ols2004v1-pages-215-226.pdf)

- [Comparing and Evaluating epoll, select, and poll Event Mechanisms](#comparing-and-evaluating-epoll-select-and-poll-event-mechanisms)
  - [Abstract](#abstract)
  - [1 Introduction](#1-introduction)
  - [2 Background and Related Work](#2-background-and-related-work)
  - [3 Improving epoll Performance](#3-improving-epoll-performance)

Louay Gammo, Tim Brecht, Amol Shukla, and David Pariag
University of Waterloo

## Abstract

Interestingly, initial results show that the select and poll event mechanisms perform comparably to the epoll event mechanism in the absence of idle connections. Profiling data shows a significant amount of time spent in executing a large number of `epoll_ctl` system calls. 

## 1 Introduction

The Internet is expanding in size, number of users, and in volume of content, thus it is imperative to be able to support these changes with faster and more efficient HTTP servers. A common problem in HTTP server scalability is how to ensure that the server **handles a large number of connections simultaneously** without degrading the performance. An **event-driven** approach is often implemented in high-performance network servers to **multiplex** a large number of concurrent connections over a few server processes. In eventdriven servers it is important that the server focuses on connections that can be serviced **without blocking its main process**. An **event dispatch** mechanism such as `select` is used to determine the connections on which forward progress can be made without invoking a blocking system call. Many different event dispatch mechanisms have been used and studied in the context of network applications. These mechanisms range from `select`, `poll`, `/dev/poll`, `RT signals`, and `epoll`.

The `epoll` event mechanism is designed to **scale to larger numbers** of connections than `select` and `poll`. One of the problems with `select` and `poll` is that in a single call they must both inform the kernel of all of the **events of interest** and **obtain new events**. This can result in **large overheads**, particularly in environments with large numbers of connections and relatively few new events occurring. In a fashion similar to that described by Banga et al. `epoll` separates mechanisms for obtaining events (`epoll_wait`) from those used to declare and control interest in events (`epoll_ctl`). Further **reductions in the number of generated events** can be obtained by using **edge-triggered** epoll semantics. In this mode events are only provided when there is a **change in the state** of the socket descriptor of interest. For compatibility with the semantics offered by `select` and `poll`, `epoll` also provides `level-triggered` event mechanisms.

Interestingly, in this paper, we found that for some of the workloads considered `select` and `poll` perform as well as or **slightly better than** `epoll`.

## 2 Background and Related Work

Event-notification mechanisms have a long history in operating systems research and development, and have been a central issue in many performance studies. These studies have sought to improve mechanisms and interfaces for **obtaining information about the state of socket and file descriptors** from the operating system. Some of these studies have developed improvements to `select`, `poll` and `sigwaitinfo` by **reducing the amount of data copied between the application and kernel**. Other studies have reduced the number of events delivered by the kernel, for example, the signal-per-fd scheme proposed by Chandra et al. Much of the aforementioned work is tracked and discussed on the web site, “The C10K Problem”.

Early work by Banga and Mogul found that despite performing well under laboratory conditions, popular event-driven servers performed poorly under real-world conditions. They demonstrated that the discrepancy is due the inability of the `select` system call to scale to the large number of simultaneous connections that are found in WAN environments.

Subsequent work by Banga et al. sought to improve on select’s performance by (among other things) separating the declaration of interest in events from the retrieval of events on that interest set. Event mechanisms like `select` and `poll` have traditionally combined these tasks into a single system call. However, this amalgamation requires the server to **re-declare its interest set every time it wishes to retrieve events**, since the **kernel does not remember the interest sets from previous calls**. This results in **unnecessary data copying between the application and the kernel**.

The `/dev/poll` mechanism was adapted from Sun Solaris to Linux by Provos et al., and improved on `poll`’s performance by introducing a new interface that **separated** the **declaration** of interest in events from **retrieval**. Their `/dev/poll` mechanism further reduced data copying by using a shared memory region to return events to the application.

The kqueue event mechanism addressed many of the deficiencies of `select` and `poll` for FreeBSD systems. In addition to separating the declaration of interest from retrieval, kqueue allows an application to retrieve events from a variety of sources including `file/socket` descriptors, `signals`, `AIO` completions, file system changes, and changes in process state.

The `epoll` event mechanism investigated in this paper also **separates the declaration of interest in events from their retrieval**. The `epoll_create` system call instructs the kernel to create an event data structure that can be used to track events on a number of descriptors. Thereafter, the `epoll_ctl` call is used to modify interest sets, while the `epoll_wait` call is used to retrieve events.

Another drawback of `select` and `poll` is that they perform work that depends on the **size of the interest set**, rather than the number of events returned. This **leads to poor performance when the interest set is much larger than the active set**. The `epoll` mechanisms avoid this pitfall and provide performance that is **largely independent of the size of the interest set**.

## 3 Improving epoll Performance

These results demonstrate that the µserver with leveltriggered epoll does not perform as well as select under conditions that stress the event mechanisms. This led us to more closely examine these results. Using `gprof`, we observed that `epoll_ctl` was responsible for a large percentage of the run-time. As can been seen in Table 1 in Section 5 over 16% of the time is spent in `epoll_ctl`. The `gprof` output also indicates (not shown in the table) that `epoll_ctl` was being called a large number of times because it is **called for every state change** for each socket descriptor. We examine several approaches designed to **reduce the number of `epoll_ctl` calls**. These are outlined in the following paragraphs.

The first method uses `epoll` in an **edgetriggered** fashion, which requires the µserver to keep track of the current state of the socket descriptor. This is required because with the edge-triggered semantics, events are only received for transitions on the socket descriptor state. For example, once the server reads data from a socket, it needs to keep track of whether or not that socket is still readable, or if it will get another event from `epoll_wait` indicating that the socket is readable. Similar state information is maintained by the server regarding whether or not the socket can be written. This method is referred to in our graphs and the rest of the paper epoll-ET.

The second method, which we refer to as `epoll2`, simply calls `epoll_ctl` twice per socket descriptor. The first to register with the kernel that the server is interested in read and write events on the socket. The second call occurs when the socket is closed. It is used to tell epoll that we are no longer interested in events on that socket. All events are handled in a level-triggered fashion. Although this approach will **reduce the number of `epoll_ctl` calls**, it does have potential disadvantages. One disadvantage of the `epoll2` method is that because many of the sockets will continue to be readable or writable `epoll_wait` will **return sooner**, possibly with events that are currently not of interest to the server. For example, if the server is waiting for a read event on a socket it will not be interested in the fact that the socket is writable until later. Another disadvantage is that these calls return sooner, with **fewer events** being returned per call, resulting in a larger number of calls. Lastly, because many of the events will not be of interest to the server, the server is required to spend a bit of time to determine if it is or is not interested in each event and in discarding events that are not of interest.

The third method uses a new system call named `epoll_ctlv`. This system call is designed to reduce the overhead of multiple `epoll_ctl` system calls by aggregating several calls to `epoll_ctl` into one call to `epoll_ctlv`. This is achieved by passing an array of epoll events structures to `epoll_ctlv`, which then calls `epoll_ctl` for each element of the array. Events are generated in level-triggered fashion. This method is referred to in the figures and the remainder of the paper as `epollctlv`.







TODO epoll
