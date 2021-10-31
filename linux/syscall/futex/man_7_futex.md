# [futex(7) — Linux manual page](https://man7.org/linux/man-pages/man7/futex.7.html)

- [futex(7) — Linux manual page](#futex7--linux-manual-page)
  - [NAME](#name)
  - [SYNOPSIS](#synopsis)
  - [DESCRIPTION](#description)

## NAME

futex - fast user-space locking

## SYNOPSIS

    #include <linux/futex.h>

## DESCRIPTION

The Linux kernel provides futexes ("Fast user-space mutexes") as a building block for fast user-space locking and semaphores. **Futexes are very basic and lend themselves well for building higher-level locking abstractions such as mutexes, condition variables, read-write locks, barriers, and semaphores**.

Most programmers will in fact not be using futexes directly but will instead rely on system libraries built on them, such as the Native POSIX Thread Library (NPTL) (see [`pthreads(7)`](https://man7.org/linux/man-pages/man7/pthreads.7.html)).

**A futex is identified by a piece of memory which can be shared between processes or threads**. In these different processes, the futex need not have identical addresses. In its bare form, a futex has semaphore semantics; it is a counter that can be incremented and decremented atomically; processes can wait for the value to become positive.

Futex operation occurs entirely in user space for the noncontended case. The kernel is involved only to arbitrate the contended case. As any sane design will strive for noncontention, futexes are also optimized for this situation.

In its bare form, a futex is an aligned integer which is touched only by atomic assembler instructions. This integer is four bytes long on all platforms.  Processes can share this integer using [`mmap(2)`](https://man7.org/linux/man-pages/man2/mmap.2.html), via shared memory segments, or because they share memory space, in which case the application is commonly called multithreaded.
