# Linux Device Drivers

- [Linux Device Drivers](#linux-device-drivers)
  - [Chapter 5 Enhanced Char Driver Operations](#chapter-5-enhanced-char-driver-operations)
    - [`ioctl`](#ioctl)
    - [Blocking I/O](#blocking-io)
      - [Going to Sleep and Awakening](#going-to-sleep-and-awakening)
      - [A Deeper Look at Wait Queues](#a-deeper-look-at-wait-queues)
      - [Writing Reentrant Code](#writing-reentrant-code)
      - [Blocking and Nonblocking Operations](#blocking-and-nonblocking-operations)
      - [A Sample Implementation: scullpipe](#a-sample-implementation-scullpipe)
    - [poll and select](#poll-and-select)
      - [Interaction with read and write](#interaction-with-read-and-write)
      - [Reading data from the device](#reading-data-from-the-device)
      - [Writing to the device](#writing-to-the-device)
      - [Flushing pending output](#flushing-pending-output)
      - [The Underlying Data Structure](#the-underlying-data-structure)
    - [Asynchronous Notification](#asynchronous-notification)

## [Chapter 5 Enhanced Char Driver Operations](https://www.xml.com/ldd/chapter/book/ch05.html)

### `ioctl`

### Blocking I/O

One problem that might arise with read is what to do when there's no data yet, but we're not at end-of-file.

The default answer is "go to sleep waiting for data." This section shows how a process is put to sleep, how it is awakened, and how an application can ask if there is data without just blindly issuing a read call and blocking. We then apply the same concepts to write.

#### Going to Sleep and Awakening

Whenever a process must wait for an event (such as the arrival of data or the termination of a process), it should go to sleep. Sleeping causes the process to suspend execution, freeing the processor for other uses. At some future time, when the event being waited for occurs, the process will be woken up and will continue with its job.

There are several ways of handling sleeping and waking up in Linux, each suited to different needs. All, however, work with the same basic data type, a wait queue (`wait_queue_head_t`). A wait queue is exactly that -- **a queue of processes** that are waiting for an event. Wait queues are declared and initialized as follows:

    wait_queue_head_t my_queue;
    init_waitqueue_head (&my_queue);

Once the wait queue is declared and initialized, a process may use it to go to sleep. Sleeping is accomplished by calling one of the variants of sleep_on, depending on how deep a sleep is called for.

- `sleep_on(wait_queue_head_t *queue);`

  Puts the process to sleep on this queue. sleep_on has the disadvantage of not being interruptible; as a result, the process can end up being stuck (and un-killable) if the event it's waiting for never happens.

- `interruptible_sleep_on(wait_queue_head_t *queue);`

  The interruptible variant works just like sleep_on, except that the sleep can be interrupted by a signal. This is the form that device driver writers have been using for a long time, before wait_event_interruptible (described later) appeared.

- `sleep_on_timeout(wait_queue_head_t *queue, long timeout);`
  `interruptible_sleep_on_timeout(wait_queue_head_t *queue, long timeout);`

  These two functions behave like the previous two, with the exception that the sleep will last no longer than the given timeout period.

  `void wait_event(wait_queue_head_t queue, int condition);`
  `int wait_event_interruptible(wait_queue_head_t queue, int condition)`

  These macros are the preferred way to sleep on an event. They combine waiting for an event and testing for its arrival in a way that avoids race conditions.

Just as there is more than one way to sleep, so there is also more than one way to wake up. The high-level functions provided by the kernel to wake up processes are as follows:

- `wake_up(wait_queue_head_t *queue);`

  This function will wake up all processes that are waiting on this event queue.

- `wake_up_interruptible(wait_queue_head_t *queue);`

  wake_up_interruptible wakes up only the processes that are in interruptible sleeps. Any process that sleeps on the wait queue using a noninterruptible function or macro will continue to sleep.

- `wake_up_sync(wait_queue_head_t *queue);`
  `wake_up_interruptible_sync(wait_queue_head_t *queue);`

  Normally, a wake_up call can cause an immediate reschedule to happen, meaning that other processes might run before wake_up returns. The "synchronous" variants instead make any awakened processes runnable, but do not reschedule the CPU. This is used to avoid rescheduling when the current process is known to be going to sleep, thus forcing a reschedule anyway.

An important thing to remember with wait queues is that being woken up does not guarantee that the event you were waiting for has occurred; a process can be woken for other reasons, mainly because it received a signal. Any code that sleeps should do so in a loop that tests the condition after returning from the sleep, as discussed in "A Sample Implementation: scullpipe" later in this chapter.

#### A Deeper Look at Wait Queues

The `wait_queue_head_t` type is a fairly simple structure, defined in `<linux/wait.h>`. It contains only a lock variable and a linked list of sleeping processes. The individual data items in the list are of type `wait_queue_t`, and the list is the generic list defined in `<linux/list.h>` and described in "Linked Lists" in Chapter 10, "Judicious Use of Data Types". Normally the `wait_queue_t` structures are allocated on the stack by functions like interruptible_sleep_on; the structures end up in the stack because they are simply declared as automatic variables in the relevant functions. In general, the programmer need not deal with them.

Some advanced applications, however, can require dealing with   `wait_queue_t` variables directly. For these, it's worth a quick look at what actually goes on inside a function like `interruptible_sleep_on`. The following is a simplified version of the implementation of `interruptible_sleep_on` to put a process to sleep:

    void simplified_sleep_on(wait_queue_head_t *queue)
    {
        wait_queue_t wait;

        init_waitqueue_entry(&wait, current);
        current->state = TASK_INTERRUPTIBLE;

        add_wait_queue(queue, &wait);
        schedule();
        remove_wait_queue(queue, &wait);
    }

The code here creates a new `wait_queue_t` variable (`wait`, which gets allocated on the stack) and initializes it. The state of the task is set to `TASK_INTERRUPTIBLE`, meaning that it is in an interruptible sleep. The wait queue entry is then added to the queue (the `wait_queue_head_t *` argument). Then `schedule` is called, which relinquishes the processor to somebody else. schedule returns only when somebody else has woken up the process and set its state to `TASK_RUNNING`. At that point, the wait queue entry is removed from the queue, and the sleep is done.

One other reason for calling the scheduler explicitly, however, is to do exclusive waits. There can be situations in which several processes are waiting on an event; when `wake_up` is called, all of those processes will try to execute. Suppose that the event signifies the arrival of an atomic piece of data. Only one process will be able to read that data; all the rest will simply wake up, see that no data is available, and go back to sleep.

This situation is sometimes referred to as the "thundering herd problem." In high-performance situations, thundering herds can waste resources in a big way. The creation of a large number of runnable processes that can do no useful work generates a large number of context switches and processor overhead, all for nothing. Things would work better if those processes simply remained asleep.

For this reason, the 2.3 development series added the concept of an **exclusive sleep**. If processes sleep in an exclusive mode, they are telling the kernel to wake only one of them. The result is improved performance in some situations.

The code to perform an exclusive sleep looks very similar to that for a regular sleep:

    void simplified_sleep_exclusive(wait_queue_head_t *queue)
    {
        wait_queue_t wait;

        init_waitqueue_entry(&wait, current);
        current->state = TASK_INTERRUPTIBLE | TASK_EXCLUSIVE;

        add_wait_queue_exclusive(queue, &wait);
        schedule();
        remove_wait_queue (queue, &wait);
   }

Adding the `TASK_EXCLUSIVE` flag to the task state indicates that the process is in an exclusive wait. The call to `add_wait_queue_exclusive` is also necessary, however. That function adds the process to the end of the wait queue, behind all others. The purpose is to leave any processes in nonexclusive sleeps at the beginning, where they will always be awakened. As soon as `wake_up` hits the first exclusive sleeper, it knows it can stop.

#### Writing Reentrant Code

#### Blocking and Nonblocking Operations

#### A Sample Implementation: scullpipe

### poll and select

Applications that use nonblocking I/O often use the `poll` and `select` system calls as well. poll and selecthave essentially the same functionality: both allow a process to determine whether it can read from or write to one or more open files without blocking. They are thus often used in applications that must use multiple input or output streams without blocking on any one of them. The same functionality is offered by two separate functions because they were implemented in Unix almost at the same time by two different groups: select was introduced in BSD Unix, whereas poll was the System V solution.

Support for either system call requires support from the device driver to function. In version 2.0 of the kernel the device method was modeled on select (and no poll was available to user programs); from version 2.1.23 onward both were offered, and the device method was based on the newly introduced poll system call because poll offered more detailed control than select.

Implementations of the `poll` method, implementing both the `poll` and `select` system calls, have the following prototype:

    unsigned int (*poll) (struct file *, poll_table *);

The driver's method will be called whenever the user-space program performs a `poll` or `select` system call involving a file descriptor associated with the driver. The device method is in charge of these two steps:

1. Call `poll_wait` on one or more wait queues that could indicate a change in the poll status.

2. Return a **bit mask** describing operations that could be immediately performed without blocking.

Both of these operations are usually straightforward, and tend to look very similar from one driver to the next. They rely, however, on information that only the driver can provide, and thus must be implemented individually by each driver.

The `poll_table` structure, the second argument to the `poll` method, is used within the kernel to implement the `poll` and `select` calls; it is declared in `<linux/poll.h>`, which must be included by the driver source. Driver writers need know nothing about its internals and must use it as an opaque object; it is passed to the driver method so that every event queue that could wake up the process and change the status of the poll operation can be added to the `poll_table` structure by calling the function `poll_wait`:

    void poll_wait (struct file *, wait_queue_head_t *, poll_table *);

The second task performed by the `poll` method is returning the bit mask describing which operations could be completed immediately; this is also straightforward. For example, if the device has data available, a read would complete without sleeping; the poll method should indicate this state of affairs.

The description of `poll` takes up a lot of space for something that is relatively simple to use in practice. Consider the scullpipe implementation of the `poll` method:

    unsigned int scull_p_poll(struct file *filp, poll_table *wait)
    {
        Scull_Pipe *dev = filp->private_data;
        unsigned int mask = 0;

        /*
         * The buffer is circular; it is considered full
         * if "wp" is right behind "rp". "left" is 0 if the
         * buffer is empty, and it is "1" if it is completely full.
         */
       int left = (dev->rp + dev->buffersize - dev->wp) % dev->buffersize;

       poll_wait(filp, &dev->inq, wait);
       poll_wait(filp, &dev->outq, wait);
       if (dev->rp != dev->wp) mask |= POLLIN | POLLRDNORM; /* readable */
       if (left != 1)     mask |= POLLOUT | POLLWRNORM; /* writable */

       return mask;
    }

This code simply adds the two scullpipewait queues to the `poll_table`, then sets the appropriate mask bits depending on whether data can be read or written.

#### Interaction with read and write

The purpose of the poll and select calls is to determine in advance if an I/O operation will block. In that respect, they complement read and write. More important, poll and selectare useful because they let the application wait simultaneously for several data streams, although we are not exploiting this feature in the scull examples.

A correct implementation of the three calls is essential to make applications work correctly. Though the following rules have more or less already been stated, we'll summarize them here.

#### Reading data from the device

- If there is data in the input buffer, the readcall should return immediately, with no noticeable delay, even if less data is available than the application requested and the driver is sure the remaining data will arrive soon. You can always return less data than you're asked for if this is convenient for any reason (we did it in scull), provided you return at least one byte.

- If there is no data in the input buffer, by default read must block until at least one byte is there. If O_NONBLOCK is set, on the other hand, read returns immediately with a return value of -EAGAIN (although some old versions of System V return 0 in this case). In these cases poll must report that the device is unreadable until at least one byte arrives. As soon as there is some data in the buffer, we fall back to the previous case.

- If we are at end-of-file, read should return immediately with a return value of 0, independent of O_NONBLOCK. poll should report POLLHUP in this case.

#### Writing to the device

- If there is space in the output buffer, writeshould return without delay. It can accept less data than the call requested, but it must accept at least one byte. In this case, poll reports that the device is writable.

- If the output buffer is full, by default writeblocks until some space is freed. If O_NONBLOCK is set, write returns immediately with a return value of -EAGAIN (older System V Unices returned 0). In these cases poll should report that the file is not writable. If, on the other hand, the device is not able to accept any more data, write returns -ENOSPC ("No space left on device''), independently of the setting of O_NONBLOCK.

- Never make a write call wait for data transmission before returning, even if O_NONBLOCK is clear. This is because many applications use select to find out whether a write will block. If the device is reported as writable, the call must consistently not block. If the program using the device wants to ensure that the data it enqueues in the output buffer is actually transmitted, the driver must provide an fsync method. For instance, a removable device should have an fsync entry point.

Although these are a good set of general rules, one should also recognize that each device is unique and that sometimes the rules must be bent slightly. For example, record-oriented devices (such as tape drives) cannot execute partial writes.

#### Flushing pending output

#### The Underlying Data Structure

The actual implementation of the `poll` and `select` system calls is reasonably simple, for those who are interested in how it works. Whenever a user application calls either function, the kernel invokes the `poll` method of all files referenced by the system call, passing the same `poll_table` to each of them. The structure is, for all practical purposes, an array of `poll_table_entry` structures allocated for a specific `poll` or `select` call. Each `poll_table_entry` contains the struct file pointer for the open device, a `wait_queue_head_t` pointer, and a `wait_queue_t` entry. When a driver calls `poll_wait`, one of these entries gets filled in with the information provided by the driver, and the wait queue entry **gets put onto the driver's queue**. The pointer to `wait_queue_head_t` is used to track the wait queue where the current poll table entry is registered, in order for `free_wait` to be able to dequeue the entry before the wait queue is awakened.

If none of the drivers being polled indicates that I/O can occur without blocking, the `poll` call simply sleeps until one of the (perhaps many) wait queues it is on wakes it up.

What's interesting in the implementation of pollis that the file operation may be called with a NULL pointer as poll_table argument. This situation can come about for a couple of reasons. If the application calling poll has provided a timeout value of 0 (indicating that no wait should be done), there is no reason to accumulate wait queues, and the system simply does not do it. The poll_table pointer is also set to NULL immediately after any driver being polled indicates that I/O is possible. Since the kernel knows at that point that no wait will occur, it does not build up a list of wait queues.

When the poll call completes, the poll_table structure is **deallocated**, and all wait queue entries previously added to the poll table (if any) are **removed** from the table and their wait queues.

Actually, things are somewhat more complex than depicted here, because the poll table is not a simple array but rather a set of one or more pages, each hosting an array. This complication is meant to avoid putting too low a limit (dictated by the page size) on the maximum number of file descriptors involved in a poll or select system call.

We tried to show the data structures involved in polling in Figure 5-2; the figure is a simplified representation of the real data structures because it ignores the multipage nature of a poll table and disregards the file pointer that is part of each poll_table_entry. The reader interested in the actual implementation is urged to look in <linux/poll.h> and fs/select.c.

### Asynchronous Notification





















