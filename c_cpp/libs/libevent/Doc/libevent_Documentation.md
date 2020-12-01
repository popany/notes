# [libevent Documentation](https://libevent.org/doc/)

- [libevent Documentation](#libevent-documentation)
  - [Introduction](#introduction)
  - [Standard usage](#standard-usage)
  - [Library setup](#library-setup)
  - [Creating an event base](#creating-an-event-base)
  - [Event notification](#event-notification)
  - [Dispatching events](#dispatching-events)
  - [I/O Buffers](#io-buffers)
  - [Timers](#timers)
  - [Asynchronous DNS resolution](#asynchronous-dns-resolution)
  - [Event-driven HTTP servers](#event-driven-http-servers)
  - [A framework for RPC servers and clients](#a-framework-for-rpc-servers-and-clients)
  - [API Reference](#api-reference)

## Introduction

Libevent is an event notification library for developing scalable network servers. The Libevent API provides a mechanism to execute a **callback function** when a specific **event occurs** on a **file descriptor** or **after a timeout** has been reached. Furthermore, Libevent also support callbacks due to **signals** or **regular timeouts**.

Libevent is meant to replace the event loop found in event driven network servers. An application just needs to call [`event_base_dispatch()`](https://libevent.org/doc/event_8h.html#a19d60cb72a1af398247f40e92cf07056) and then add or remove events dynamically without having to change the event loop.

Currently, Libevent supports `/dev/poll`, `kqueue`(2), `select`(2), `poll`(2), `epoll`(4), and `evports`. The internal event mechanism is completely independent of the exposed event API, and a simple update of Libevent can provide new functionality without having to redesign the applications. As a result, Libevent allows for portable application development and provides the most scalable event notification mechanism available on an operating system. Libevent can also be used for multithreaded programs. Libevent should compile on `Linux`, `*BSD`, `Mac OS X`, `Solaris` and, `Windows`.

## Standard usage

Every program that uses Libevent must include the [`<event2/event.h>`](https://libevent.org/doc/event_8h.html) header, and pass the `-levent` flag to the linker. (You can instead link `-levent_core` if you only want the main event and buffered IO-based code, and don't want to link any protocol code.)

## Library setup

Before you call any other Libevent functions, you need to set up the library. If you're going to use Libevent from multiple threads in a multithreaded application, you need to **initialize thread support** – typically by using [`evthread_use_pthreads()`](https://libevent.org/doc/thread_8h.html#acc0cc708c566c14f4659331ec12f8a5b) or [`evthread_use_windows_threads()`](https://libevent.org/doc/thread_8h.html#a1b0fe36dcb033da2c679d39ce8a190e2). See [`<event2/thread.h>`](https://libevent.org/doc/thread_8h.html) for more information.

This is also the point where you can replace Libevent's memory management functions with `event_set_mem_functions`, and enable debug mode with [`event_enable_debug_mode()`](https://libevent.org/doc/event_8h.html#a37441a3defac55b5d2513521964b2af5).

## Creating an event base

Next, you need to create an [`event_base`](https://libevent.org/doc/structevent__base.html) structure, using [`event_base_new()`](https://libevent.org/doc/event_8h.html#af34c025430d445427a2a5661082405c3) or [`event_base_new_with_config()`](https://libevent.org/doc/event_8h.html#a864798e5b3c6aa8d2f9e9c5035a3e6da). The [`event_base`](https://libevent.org/doc/structevent__base.html) is responsible for keeping track of which events are "pending" (that is to say, being watched to see if they become active) and which events are "active". **Every event is associated with a single [`event_base`](https://libevent.org/doc/structevent__base.html)**.

## Event notification

For each **file descriptor** that you wish to monitor, you must create an event structure with [`event_new()`](https://libevent.org/doc/event_8h.html#a6cd300e5cd15601c5e4570b221b20397). (You may also declare an event structure and call [`event_assign()`](https://libevent.org/doc/event_8h.html#a3e49a8172e00ae82959dfe64684eda11) to initialize the members of the structure.) To enable notification, you add the structure to the **list of monitored events** by calling [`event_add()`](https://libevent.org/doc/event_8h.html#ab0c85ebe9cf057be1aa17724c701b0c8). The event structure must remain allocated as long as it is active, so it should generally be allocated on the heap.

## Dispatching events

Finally, you call [`event_base_dispatch()`](https://libevent.org/doc/event_8h.html#a19d60cb72a1af398247f40e92cf07056) to **loop** and **dispatch** events. You can also use [`event_base_loop()`](https://libevent.org/doc/event_8h.html#acd7da32086d1e37008e7c76c9ea54fc4) for more fine-grained control.

Currently, **only one thread can be dispatching a given [`event_base`](https://libevent.org/doc/structevent__base.html) at a time**. If you want to run events in multiple threads at once, you can either have a **single [`event_base`](https://libevent.org/doc/structevent__base.html) whose events add work to a work queue**, or you can create **multiple [`event_base`](https://libevent.org/doc/structevent__base.html) objects**.

## I/O Buffers

Libevent provides a buffered I/O abstraction on top of the regular event callbacks. This abstraction is called a **bufferevent**. A bufferevent provides input and output buffers that get filled and drained automatically. The user of a buffered event **no longer deals directly with the I/O**, but instead is reading from input and writing to output buffers.

Once initialized via [`bufferevent_socket_new()`](https://libevent.org/doc/bufferevent_8h.html#a71181be5ab504e26f866dd3d91494854), the bufferevent structure can be used repeatedly with [`bufferevent_enable()`](https://libevent.org/doc/bufferevent_8h.html#aa8a5dd2436494afd374213b99102265b) and [`bufferevent_disable()`](https://libevent.org/doc/bufferevent_8h.html#a4f3974def824e73a6861d94cff71e7c6). Instead of reading and writing directly to a socket, you would call [`bufferevent_read()`](https://libevent.org/doc/bufferevent_8h.html#a9e36c54f6b0ea02183998d5a604a00ef) and [`bufferevent_write()`](https://libevent.org/doc/bufferevent_8h.html#a7873bee379202ca1913ea365b92d2ed1).

When read enabled the bufferevent will try to read from the file descriptor and call the read callback. The write callback is executed whenever the output buffer is drained below the write low watermark, which is 0 by default.

See `<event2/bufferevent*.h>` for more information.

## Timers

Libevent can also be used to create timers that invoke a callback after a certain amount of time has expired. The evtimer_new() macro returns an event struct to use as a timer. To activate the timer, call evtimer_add(). Timers can be deactivated by calling evtimer_del(). (These macros are thin wrappers around event_new(), event_add(), and event_del(); you can also use those instead.)

## Asynchronous DNS resolution

Libevent provides an asynchronous DNS resolver that should be used instead of the standard DNS resolver functions. See the [`<event2/dns.h>`](https://libevent.org/doc/dns_8h.html) functions for more detail.

## Event-driven HTTP servers

Libevent provides a very simple event-driven HTTP server that can be embedded in your program and used to service HTTP requests.

To use this capability, you need to include the [`<event2/http.h>`](https://libevent.org/doc/http_8h.html) header in your program. See that header for more information.

## A framework for RPC servers and clients

Libevent provides a framework for creating RPC servers and clients. It takes care of **marshaling** and **unmarshaling** all data structures.

## API Reference

To browse the complete documentation of the libevent API, click on any of the following links.

- [`event2/event.h`](https://libevent.org/doc/event_8h.html) The primary libevent header

- [`event2/thread.h`](https://libevent.org/doc/thread_8h.html) Functions for use by multithreaded programs

- [`event2/buffer.h`](https://libevent.org/doc/buffer_8h.html) and [`event2/bufferevent.h`](https://libevent.org/doc/bufferevent_8h.html) Buffer management for network reading and writing

- [`event2/util.h`](https://libevent.org/doc/util_8h.html) Utility functions for portable nonblocking network code

- [`event2/dns.h`](https://libevent.org/doc/dns_8h.html) Asynchronous DNS resolution

- [`event2/http.h`](https://libevent.org/doc/http_8h.html) An embedded libevent-based HTTP server

- [`event2/rpc.h`](https://libevent.org/doc/rpc_8h.html) A framework for creating RPC servers and clients

- [`event2/watch.h`](https://libevent.org/doc/watch_8h.html) "Prepare" and "check" watchers.
