# [perf_event_open(2) — Linux manual page](https://www.man7.org/linux/man-pages/man2/perf_event_open.2.html)

- [perf_event_open(2) — Linux manual page](#perf_event_open2--linux-manual-page)
  - [NAME](#name)
  - [SYNOPSIS](#synopsis)
  - [DESCRIPTION](#description)

## NAME

`perf_event_open` - set up performance monitoring

## SYNOPSIS

    #include <linux/perf_event.h>    /* Definition of PERF_* constants */
    #include <linux/hw_breakpoint.h> /* Definition of HW_* constants */
    #include <sys/syscall.h>         /* Definition of SYS_* constants */
    #include <unistd.h>

    int syscall(SYS_perf_event_open, struct perf_event_attr *attr,
                pid_t pid, int cpu, int group_fd, unsigned long flags);

Note: glibc provides no wrapper for perf_event_open(), necessitating the use of [`syscall(2)`](https://www.man7.org/linux/man-pages/man2/syscall.2.html).

## DESCRIPTION

Given a list of parameters, `perf_event_open()` returns a file descriptor, for use in subsequent system calls ([`read(2)`](https://www.man7.org/linux/man-pages/man2/read.2.html), [`mmap(2)`](https://www.man7.org/linux/man-pages/man2/mmap.2.html), [`prctl(2)`](https://www.man7.org/linux/man-pages/man2/prctl.2.html), [`fcntl(2)`](https://www.man7.org/linux/man-pages/man2/fcntl.2.html), etc.).

A call to `perf_event_open()` creates a file descriptor that allows measuring performance information. Each file descriptor **corresponds to one event** that is measured; these can be **grouped together to measure multiple events** simultaneously.

Events can be enabled and disabled in two ways: via [`ioctl(2)`](https://www.man7.org/linux/man-pages/man2/ioctl.2.html) and via [`prctl(2)`](https://www.man7.org/linux/man-pages/man2/prctl.2.html). When an event is disabled it does not count or generate overflows but does continue to exist and maintain its count value.

Events come in two flavors: **counting** and **sampled**. A counting event is one that is used for counting the aggregate number of events that occur. In general, counting event results are gathered with a [`read(2)`](https://www.man7.org/linux/man-pages/man2/read.2.html) call. A sampling event periodically writes measurements to a buffer that can then be accessed via [`mmap(2)`](https://www.man7.org/linux/man-pages/man2/mmap.2.html).
