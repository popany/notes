# [Linux Wait Queue](https://programmer.help/blogs/linux-wait-queue-wait-queue.html)

- [Linux Wait Queue](#linux-wait-queue)
  - [1. Introduction](#1-introduction)
  - [2. Basic concepts](#2-basic-concepts)
  - [3. Static relationship between waiting queues and processes](#3-static-relationship-between-waiting-queues-and-processes)
    - [3.1 Waiting for Queue Creation](#31-waiting-for-queue-creation)
      - [3.1.1 Static Creation](#311-static-creation)
      - [3.1.2 Dynamic Creation](#312-dynamic-creation)
    - [3.2 Create waiting queue members](#32-create-waiting-queue-members)
    - [3.3 Add/Remove Waiting Queue Members](#33-addremove-waiting-queue-members)
    - [3.4 Wake-up waiting queue](#34-wake-up-waiting-queue)
  - [4. Example application of waiting queue](#4-example-application-of-waiting-queue)
    - [4.1 Direct use of wait queue basic operations](#41-direct-use-of-wait-queue-basic-operations)
    - [Encapsulation methods provided by 4.2 kernel](#encapsulation-methods-provided-by-42-kernel)
  - [5. Summary](#5-summary)

## 1. Introduction

Waiting queues in the linux kernel are closely related to **process scheduling**, and in some cases processes must **wait for certain events**, such as the termination of a disk operation, the release of system resources, or a specified time interval.

The wait queue achieves a conditional wait on an event: a process that wants to wait for a particular event **puts itself in the appropriate wait queue** and gives up control.

Therefore, the **wait queue represents a set of sleep processes** that the kernel wakes up when a certain condition is met.

Based on the basic description of the waiting queue above, it is intuitive to ask the following questions, which we analyze with questions:

1. How do waiting queues build? What is its basic structure?

2. How does a process wait for a so-called specific event to be represented?

3. How does a process enter a waiting queue? How was it waked up?

4. How is the entire life cycle of a process waiting on a queue scheduled?

Note: This article is based on linux-4.9.

## 2. Basic concepts

As the name implies, a wait queue is a special queue, and the code uses two data structures to describe a wait queue: `wait_queue_head_t` and `wait_queue_t`.

These two data structures are defined in the `include/linux/wait.h` header file.

    struct __wait_queue_head {
        spinlock_t        lock;
        struct list_head    task_list;
    };
    typedef struct __wait_queue_head wait_queue_head_t;

    struct __wait_queue {
        unsigned int        flags;
        void            *private;
        wait_queue_func_t    func;
        struct list_head    task_list;
    };
    typedef struct __wait_queue wait_queue_t;

The wait queue is a two-way queue, with `wait_queue_head_t` representing the head of the queue, `wait_queue_t` representing the valid members of the queue, and its **private pointer pointing to the `task_struct` structure of the associated process**.

A wait queue has **only one `wait_queue_head_t`**, because the wait queue may be empty and does not contain a `wait_queue_t` member, a separate head is used to keep the queue.

The structure of `wait_queue_head_t` is simple, with only one spinlock and one `list_head` member forming the queue, which only maintains the head of the wait queue.

`wait_queue_t` is a valid member of the wait queue and contains three attributes except `list_head`:

- `unsigned int flags`: Identifies the **state and attributes** of `wait_queue_t` members with the following two flag values:

  - `#define WQ_FLAG_EXCLUSIVE    0x01`

  - `#define WQ_FLAG_WOKEN        0x02`

- `void *private`: `task_struct` used to **bind `wait_queue_t` associated process**

- `wait_queue_func_t func`: Binds a **wake up function** that calls the wake-up process in the `wake_up` method

So far, we've defined the basic data structure of the waiting queue, which seems fairly straightforward.

The next question is how the wait queue is associated with the process, or how does the process use the wait queue?

## 3. Static relationship between waiting queues and processes

### 3.1 Waiting for Queue Creation

First you need to **assign a `wait_queue_head_t` structure and initialize** it. There are two ways to do this: static and dynamic creation

#### 3.1.1 Static Creation

    #define __WAIT_QUEUE_HEAD_INITIALIZER(name) {                \
         .lock        = __SPIN_LOCK_UNLOCKED(name.lock),        \
         .task_list    = { &(name).task_list, &(name).task_list } }
    
    #define DECLARE_WAIT_QUEUE_HEAD(name) \
         wait_queue_head_t name = __WAIT_QUEUE_HEAD_INITIALIZER(name)

Create a `wait_queue_head_t` named `name` by referencing `DECLARE_WAIT_QUEUE_HEAD(name)` with storage allocated to the data segment

#### 3.1.2 Dynamic Creation

Another way to create it is to initialize the function `init_waitqueue_head` using `wait_queue_head_t`, which is defined in the `include/linux/wait.h` header file.

    #define init_waitqueue_head(q)                \
        do {                        \
            static struct lock_class_key __key;    \
                                \
            __init_waitqueue_head((q), #q, &__key);    \
        } while (0)

    void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
    {
        spin_lock_init(&q->lock);
        lockdep_set_class_and_name(&q->lock, key, name);
        INIT_LIST_HEAD(&q->task_list);
    }

The `init_waitqueue_head` function only initializes the data members of `wait_queue_head_t`, and its storage space is allocated beforehand, which allows the programmer to handle flexibly:

You can either allocate data segments statically or allocate space on the heap dynamically.

Here you've just created an empty queue that hasn't worked yet.

### 3.2 Create waiting queue members

The process uses a wait queue and needs to associate a `wait_queue_t` data structure

    #define __WAITQUEUE_INITIALIZER(name, tsk) {                \
        .private    = tsk,                        \
        .func        = default_wake_function,            \
        .task_list    = { NULL, NULL } }

    #define DECLARE_WAITQUEUE(name, tsk)                    \
        wait_queue_t name = __WAITQUEUE_INITIALIZER(name, tsk)

You can use the `DECLARE_WAITQUEUE(name, tsk)` macro to create a waiting queue member that expands to:

That is, declare a `wait_queue_t` structure named `name`, **noting that the life cycle** of `wait_queue_t` is related to the location of the macro reference, and if used within a function, the life cycle of `wait_queue_t` is limited within that function.

### 3.3 Add/Remove Waiting Queue Members

Add waiting queue members:

    static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
    {
        list_add (&new->task_list, &head->task_list);
    }
    
    void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
    {
        unsigned long flags;
    
        wait->flags &= ~WQ_FLAG_EXCLUSIVE;
        spin_lock_irqsave(&q->lock, flags);
        __add_wait_queue(q, wait);
        spin_unlock_irqrestore(&q->lock, flags);
    }
    EXPORT_SYMBOL(add_wait_queue);
     
    
    static inline void __add_wait_queue_tail(wait_queue_head_t *head,
                         wait_queue_t *new)
    {
        list_add_tail(&new->task_list, &head->task_list);
    }
    
    void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
    {
        unsigned long flags;
    
        wait->flags |= WQ_FLAG_EXCLUSIVE;
        spin_lock_irqsave(&q->lock, flags);
        __add_wait_queue_tail(q, wait);
        spin_unlock_irqrestore(&q->lock, flags);
    }

Delete waiting queue members:

    static inline void __remove_wait_queue(wait_queue_head_t *head, wait_queue_t *old)
    {
        list_del(&old->task_list);
    }

    void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
    {
        unsigned long flags;

        spin_lock_irqsave(&q->lock, flags);
        __remove_wait_queue(q, wait);
        spin_unlock_irqrestore(&q->lock, flags);
    }
    EXPORT_SYMBOL(remove_wait_queue);

Adding/deleting waiting queue members is a **simple chain table operation**, inserting or removing the `wait_queue_t` structure **representing the process into or from the queue**.

Note: **exclusive wait processes are inserted at the end of the wait queue**.

When does the process go into hibernation? How can I wake up from a waiting queue?

Next, let's look at how the wakeup function for the waiting queue is implemented.

### 3.4 Wake-up waiting queue

From the creation macro `DECLARE_WAITQUEUE` of the wait queue, you can see that there is a private pointer to `task_struct` in `wait_queue_t` that associates `wait_queue_t` with a process `tast_struct`.

The `wait_queue_func_t` function member is also bound to the **`default_wake_function` function**.

The **`wake_up` function** is provided in `include/linux/wait.h` and `kernel/sched/wait.c`, which **wakes processes in the waiting queue**.

See through the code what this `wake_up` function does and how it should be called.

`wait.h` provides a series of encapsulations of the `wake_up` function, all based on the `wake_up()` function in `wait.c`:

    #define wake_up(x)            __wake_up(x, TASK_NORMAL, 1, NULL)
    #define wake_up_nr(x, nr)        __wake_up(x, TASK_NORMAL, nr, NULL)
    #define wake_up_all(x)            __wake_up(x, TASK_NORMAL, 0, NULL)
    #define wake_up_locked(x)        __wake_up_locked((x), TASK_NORMAL, 1)
    #define wake_up_all_locked(x)        __wake_up_locked((x), TASK_NORMAL, 0)

    #define wake_up_interruptible(x)    __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
    #define wake_up_interruptible_nr(x, nr)    __wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
    #define wake_up_interruptible_all(x)    __wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
    #define wake_up_interruptible_sync(x)    __wake_up_sync((x), TASK_INTERRUPTIBLE, 1)

From this series of interface forms, it can be seen that the core of them are `wake_up` functions, which are applied to different scenarios and different types of processes.

    /*
    * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
    * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
    * number) then we wake all the non-exclusive tasks and one exclusive task.
    *
    * There are circumstances in which we can try to wake a task which has already
    * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
    * zero in this (rare) case, and we handle it by continuing to scan the queue.
    */
    static void 
    __wake_up_common
    (wait_queue_head_t *q, unsigned int mode,
                int nr_exclusive, int wake_flags, void *key)
    {
        wait_queue_t *curr, *next;

        
        list_for_each_entry_safe
        (curr, next, &q->task_list, task_list) {
            unsigned flags = curr->flags;
            /* Notice the three criteria here, which directly determine the result of the wakeup function */
            if (curr->func(curr, mode, wake_flags, key) &&
                    (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
                break;
        }
    }

    /**
    * __wake_up - wake up threads blocked on a waitqueue.
    * @q: the waitqueue
    * @mode: which threads
    * @nr_exclusive: how many wake-one or wake-many threads to wake up
    * @key: is directly passed to the wakeup function
    *
    * It may be assumed that this function implies a write memory barrier before
    * changing the task state if and only if any tasks are woken up.
    */
    void __wake_up(wait_queue_head_t *q, unsigned int mode,
                int nr_exclusive, void *key)
    {
        unsigned long flags;

        spin_lock_irqsave(&q->lock, flags);
        __wake_up_common(q, mode, nr_exclusive, 0, key);
        spin_unlock_irqrestore(&q->lock, flags);
    }
    EXPORT_SYMBOL(__wake_up);
 
As you can see from the `wake_up` code, its core operation is to **traverse the waiting queue** in `wake_up_common` and then call the `func` functions of its members.

Let's look back at the `func` function, which is bound to `default_wake_function` when using the `DECLARE_WAITQUEUE(name, tsk)` macro to create waiting queue members.

Note: If you do not use the `DECLARE_WAITQUEUE(name, tsk)` macro to create waiting queue members, you can **customize the `func` function for `wait_queue_t`**.

    int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
                void *key)
    {
        return try_to_wake_up(curr->private, mode, wake_flags);
    }
    EXPORT_SYMBOL(default_wake_function);

`default_wake_function` and the `try_to_wake_up` function it calls are both defined in `kernel/sched/core.c`. The core function is `try_to_wake_up`. This article does not go into the function details, only the prototype and comment of the function

    /**
      * try_to_wake_up - wake up a thread
      * @p: the thread to be awakened
      * @state: the mask of task states that can be woken
      * @wake_flags: wake modifier flags (WF_*)
      *
      * Put it on the run-queue if it's not already there. The "current"
      * thread is always on the run-queue (except when the actual
      * re-schedule is in progress), and as such you're allowed to do
      * the simpler "current->state = TASK_RUNNING" to mark yourself
      * runnable without the overhead of this.
      *
      * Return: %true if @p was woken up, %false if it was already running.
      * or @state didn't match @p's state.
      */
    
    static int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags);

The function is to **set the process state** represented by the process descriptor passed in the call parameter to `TASK_RUNNING` and **place it in run-queue**, which is then scheduled by the dispatcher.

Here you need to focus on the three break conditions in `wake_up_common` that traverse the waiting queue:

    if (curr->func(curr, mode, wake_flags, key) && (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
        break;

Note the execution of multiple criteria in C. In this case, when one of the current criteria is false, the direct break will not continue to execute the subsequent conditional expression.

- When the `func` function returns false, there is no actual wakeup process, and the `next` member is traversed directly.

- When the `func` function returns true, the waiting process traverses the `next` member directly when it is not of type `EXCLUSIVE`;

- When the `func` function returns true and the waiting process is of type `EXCLUSIVE`, it jumps out of traversal if `nr_exclusive` decreases to 0, otherwise it continues to traverse the `next` member

- If the incoming `nr_exclusive` parameter is 0, the `nr_exclusive` first judgement becomes negative, causing all `EXCLUSIVE` processes to wakeup

In a wait queue, processes of type `EXCLUSIVE` are inserted at the end of the queue, so the semantics of the `wake_up_common` function are as follows:

1. When `wake_up_common` is called, all non-EXCLUSIVE processes in the head of the wake up queue are called at once;

2. Process of type `EXCLUSIVE` with wakeup to `nr_exclusive` queue tails at the same time

The `wake_up` function has four parameters:

1. `wait_queue_head_t *q`: This parameter is intuitive, that is, wait for the head of the queue, through which all nodes in the queue can be traversed

2. `unsigned int mode`: The comment for this parameter is "which threads", which is an unsigned int type. What does it mean?

   Let's look at the parameters passed in when referring to `wake_up` and how `wake_up` uses it

   The `wake_up` series functions in `wait.h` pass in the mode l parameters `TASK_NORMAL` and `TASK_INTERRUPTIBLE`, which are defined as follows:

       #define TASK_NORMAL        (TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)

   This is the `flag` definition representing the state of the process, and its path of delivery:

       __wake_up  --> __wake_up_common –> default_wake_function –> try_to_wake_up

   The second parameter that will ultimately work in `try_to_wake_up` is:

       @state: the mask of task states that can be woken

   To summarize, the second parameter of `wake_up` indicates whether this call will wake a process in the `TASK_NORMAL` state or only the `TASK_INTERRUPTIBLE` process.

3. `int nr_exclusive`: The parameter comment "how many wake-one or wake-many threads to wake up" is an int type

   This parameter indicates **how many mutually exclusive waiting processes** will be waked up by this `wake_up` call, and its delivery path:

       __wake_up  --> __wake_up_common

4. `void *key`: This parameter will be passed to the fourth parameter of the `func`, which is **not used by `default_wake_function`** and will not be further analyzed. The key parameter has other uses if you use a user-defined `func` function.

## 4. Example application of waiting queue

From the above analysis process, a basic idea can be drawn:

A waiting queue is a two-way queue that maintains a series of processes. The processes in the waiting queue are divided into mutually exclusive (with `WQ_FLAG_EXCLUSIVE` identity) and non-mutually exclusive (without `WQ_FLAG_EXCLUSIVE` identity).

A series of functions are provided in the kernel to insert or remove processes from the waiting queue, and a wakeup function is provided to wake up processes in the waiting queue.

So where is the so-called Wait Queue's Wait font now? How should waiting queues be used?

### 4.1 Direct use of wait queue basic operations

Take `mmc_claim_host` and `mmc_release_host` in the kernel `mmc` driver as examples to see the specific use of waiting queues.

Some operations on the host in the kernel `mmc` driver must be mutually exclusive, because some operations on the host hardware must remain complete and cannot be accessed in parallel by multiple processes.

Therefore, before performing such operations, the driver calls the `mmc_claim_host` declaration to occupy the host, and after the operation is completed, uses the `mmc_release_host` to release the host resource.

We'll add a comment directly to the code below to illustrate the role that waiting queues play in it.

    /**
      *    __mmc_claim_host - exclusively claim a host
      *    @host: mmc host to claim
      *    @abort: whether or not the operation should be aborted
      *
      *    Claim a host for a set of operations.  If @abort is non null and
      *    dereference a non-zero value then this will return prematurely with
      *    that non-zero value without acquiring the lock.  Returns zero
      *    with the lock held otherwise.
      */
    int __mmc_claim_host(struct mmc_host *host, atomic_t *abort)
    {
        /*
         * Declare a wait_queue_t structure named wait, bound to the current process
         * Notice that wait's life cycle is within the function, and its storage space is allocated on the function stack
         */
        DECLARE_WAITQUEUE(wait, current);
        unsigned long flags;
        int stop;
        bool pm = false;
    
        might_sleep();
    
        /*
         * Add wait to host->wq wait queue
         * host->wq Is a member variable of host, which is initialized when the driver loads
         */
        add_wait_queue(&host->wq, &wait);
        spin_lock_irqsave(&host->lock, flags);
        while (1) {
            /* Sets the state of the current process, is no longer in RUNNING state, and will not be rescheduled for execution */
            set_current_state(TASK_UNINTERRUPTIBLE);
            stop = abort ? atomic_read(abort) : 0;
            /* This reflects the wait condition and jumps out of the while(1) loop when either of the following conditions is met*/
            if (stop || !host->claimed || host->claimer == current)
                break;
            spin_unlock_irqrestore(&host->lock, flags);
            /* If the above waiting conditions are not satisfied, give up CPU resources and enter the waiting state */
            schedule();
            /*
             * When host->wq is awakened by the wakeup function, the process may be scheduled for execution again
             * Again, from while(1) you will be checking the above waiting conditions to see if you can get access to the host
             */
            spin_lock_irqsave(&host->lock, flags);
        }
        /* Run here to indicate that while(1) break condition is met and set process state to TASK_RUNNING */
        set_current_state(TASK_RUNNING);
        if (!stop) {
            host->claimed = 1;
            host->claimer = current;
            host->claim_cnt += 1;
            if (host->claim_cnt == 1)
                pm = true;
        } else
             wake_up(&host->wq);
        spin_unlock_irqrestore(&host->lock, flags);
        /* Remove wait from host->wq */
        remove_wait_queue(&host->wq, &wait);
    
        if (pm)
            pm_runtime_get_sync(mmc_dev(host));
    
        return stop;
    }
    
    /* Simple encapsulation of mmc_claim_host without special attention */
    static inline void mmc_claim_host(struct mmc_host *host)
    {
        __mmc_claim_host(host, NULL);
    }
    
    /**
      *    mmc_release_host - release a host
      *    @host: mmc host to release
      *
      *    Release a MMC host, allowing others to claim the host
      *    for their operations.
      */
    void mmc_release_host(struct mmc_host *host)
    {
        /* When driver finishes mutually exclusive operation of host, call this function to release host resources */
        unsigned long flags;
    
        WARN_ON(!host->claimed);
    
        spin_lock_irqsave(&host->lock, flags);
        if (--host->claim_cnt) {
            /* Release for nested claim */
            spin_unlock_irqrestore(&host->lock, flags);
        } else {
            host->claimed = 0;
            host->claimer = NULL;
            spin_unlock_irqrestore(&host->lock, flags);
            /* Call wakeup to wake up host->wq waiting for other waiting processes in the queue to run */
            wake_up(&host->wq);
            pm_runtime_mark_last_busy(mmc_dev(host));
            pm_runtime_put_autosuspend(mmc_dev(host));
        }
    }

### Encapsulation methods provided by 4.2 kernel

include/linux/wait.h provides a series of convenient ways to use wait queues, such as:

- `wait_event(wq, condition)`
- `wait_event_timeout(wq, condition, timeout)`
- `wait_event_interruptible(wq, condition)`
- `wait_event_interruptible_timeout(wq, condition, timeout)`
- `io_wait_event(wq, condition)`

These methods are macro definitions that function similarly but have different semantics and can be used in different scenarios.

Let's look at its implementation using `wait_event` as an example, with the following code (note the highlighted section in the comment describes its semantics):

    /**
      * wait_event - sleep until a condition gets true
      * @wq: the waitqueue to wait on
      * @condition: a C expression for the event to wait for
      *
      * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
      * @condition evaluates to true. The @condition is checked each time
      * the waitqueue @wq is woken up.
      *
      * wake_up() has to be called after changing any variable that could
      * change the result of the wait condition.
      */
     #define wait_event(wq, condition)                    \
     do {                                    \
         might_sleep();                            \
         if (condition)                            \
             break;                            \
         __wait_event(wq, condition);                    \
     } while (0)
    
    /*
      * The below macro ___wait_event() has an explicit shadow of the __ret
      * variable when used from the wait_event_*() macros.
      *
      * This is so that both can use the ___wait_cond_timeout() construct
      * to wrap the condition.
      *
      * The type inconsistency of the wait_event_*() __ret variable is also
      * on purpose; we use long where we can return timeout values and int
      * otherwise.
      */
    #define ___wait_event(wq, condition, state, exclusive, ret, cmd)    \
     ({                                    \
         __label__ __out;                        \
         wait_queue_t __wait;                        \
         long __ret = ret;    /* explicit shadow */            \
                                         \
         init_wait_entry(&__wait, exclusive ? WQ_FLAG_EXCLUSIVE : 0);    \
         for (;;) {                            \
             long __int = prepare_to_wait_event(&wq, &__wait, state);\
                                         \
             if (condition)                        \
                 break;                        \
                                         \
             if (___wait_is_interruptible(state) && __int) {        \
                 __ret = __int;                    \
                 goto __out;                    \
             }                            \
                                         \
             cmd;                            \
         }                                \
         finish_wait(&wq, &__wait);                    \
     __out:    __ret;                                \
     })
    
    #define __wait_event(wq, condition)                    \
         (void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,    \
                     schedule())

The above implementation of `wait_event(wq, condition)` is a series of macro definitions.

Expand the `wait_event(wq, condition)` macro to get the following code snippet, which does not return a value, so `wait_event` cannot be used as a right value.

We add comments to this code snippet to explain how it works:

    do {
        might_sleep();
        /* If the condition condition condition is true, it will not enter the wait state */
        if (condition)
            break;
    
        (void)({
            __label__ __out;
            /* Create waiting queue members */
            wait_queue_t __wait;
            long __ret = 0;    /* explicit shadow */
        
            /* Initialization __wait, Notice the func bound when init_wait_entry initializes wait */
            init_wait_entry(&__wait, 0);
            for (;;) {
                /*
                * Add wait to the waiting queue, returning 0 means wait joins the waiting queue, not 0 means not joined
                * Because the state parameter passed in when wait_event is expanded is TASK_UNINTERRUPTIBLE，
                * So the return value for int here must be zero
                */
                long __int = prepare_to_wait_event(&wq, &__wait, TASK_UNINTERRUPTIBLE);
                if (condition)
                    break;
                /* The result of this if criterion must be false */
                if (___wait_is_interruptible(TASK_UNINTERRUPTIBLE) && __int) {
                    __ret = __int;
                    goto __out;
                }
                /* Allow CPU resources to wait */
                schedule();
            }
            /* Set the current process to TASK_RUNNING state and remove u wait from the waiting queue wq */
            finish_wait(&wq, &__wait);
            __out:
            __ret;
        })
    } while (0)

The key function codes involved in the code snippet for the macro expansion described above are as follows:

    void init_wait_entry(wait_queue_t *wait, int flags)
    {
        wait->flags = flags;
        wait->private = current;
        wait->func = autoremove_wake_function;
        INIT_LIST_HEAD(&wait->task_list);
    }
    
    int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
    {
        int ret = default_wake_function(wait, mode, sync, key);
    
        if (ret)
            list_del_init(&wait->task_list);
        return ret;
    }
    
    long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
    {
        unsigned long flags;
        long ret = 0;
    
        spin_lock_irqsave(&q->lock, flags);
        if (unlikely(signal_pending_state(state, current))) {
            /*
             * Exclusive waiter must not fail if it was selected by wakeup,
             * it should "consume" the condition we were waiting for.
             *
             * The caller will recheck the condition and return success if
             * we were already woken up, we can not miss the event because
             * wakeup locks/unlocks the same q->lock.
             *
             * But we need to ensure that set-condition + wakeup after that
             * can't see us, it should wake up another exclusive waiter if
             * we fail.
             */
            list_del_init(&wait->task_list);
            ret = -ERESTARTSYS;
        } else {
            if (list_empty(&wait->task_list)) {
                if (wait->flags & WQ_FLAG_EXCLUSIVE)
                    __add_wait_queue_tail(q, wait);
                else
                    __add_wait_queue(q, wait);
            }
            set_current_state(state);
        }
        spin_unlock_irqrestore(&q->lock, flags);
    
        return ret;
    }
    EXPORT_SYMBOL(prepare_to_wait_event);

The actual workflow of `wait_event(wq, condition)` is similar to the `mmc_claim_host` described in chapter 4.1, and `wait_event` encapsulates this process to provide a more convenient way to use it

To wait for a specific event using `wait_event`, a process needs three basic steps:

1. Initialize a `wait_queue_head_t` structure as the first parameter of `wait_event(wq, condition)`

2. Call `wait_event(wq, condition)` as the second parameter to enter the wait state

3. Another process wakes up `wait_queue_head_t` by calling the corresponding wakeup function when the condition condition condition is met

Using `wait_event` series macros to manipulate wait queues is simpler, more intuitive, and less prone to error than in u `mmc_claim_host`.

To use the `wait_event` series macros correctly, the key is to understand the semantics of each macro as well as the applicable scenarios, which can be further understood by reading the source code.

## 5. Summary

Waiting queues are an important mechanism related to process scheduling in Linux kernels and provide a convenient way to synchronize between processes.

The premise of using wait queue correctly is to understand its basic implementation principle, master the semantics and applicable scenarios of `wait_event` series macros, and gain a deep understanding on the basis of reading the source code.
