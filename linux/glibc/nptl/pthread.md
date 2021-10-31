# Pthread

- [Pthread](#pthread)
  - [pthreads(7) — Linux manual page](#pthreads7--linux-manual-page)
    - [Linux implementations of POSIX threads](#linux-implementations-of-posix-threads)

## [pthreads(7) — Linux manual page](https://man7.org/linux/man-pages/man7/pthreads.7.html)

### Linux implementations of POSIX threads

Over time, two threading implementations have been provided by the GNU C library on Linux:

- LinuxThreads

  This is the original Pthreads implementation.  Since glibc 2.4, this implementation is no longer supported.

- NPTL (Native POSIX Threads Library)

  This is the modern Pthreads implementation. By comparison with LinuxThreads, NPTL provides closer conformance to the requirements of the POSIX.1 specification and better performance when creating large numbers of threads.  NPTL is available since glibc 2.3.2, and requires features that are present in the Linux 2.6 kernel.

Both of these are so-called 1:1 implementations, meaning that each thread maps to a kernel scheduling entity. Both threading implementations employ the Linux [`clone(2)`](https://man7.org/linux/man-pages/man2/clone.2.html) system call.  In NPTL, thread synchronization primitives (mutexes, thread joining, and so on) are implemented using the Linux [`futex(2)`](https://man7.org/linux/man-pages/man2/futex.2.html) system call.
