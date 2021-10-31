# [Kernel Level Concurrency: Locks and Kernel Preemption](https://people.cs.pitt.edu/~ouyang/20150225-kernel-concurreny.html)

- [Kernel Level Concurrency: Locks and Kernel Preemption](#kernel-level-concurrency-locks-and-kernel-preemption)
  - [Mutual Exclusion 101](#mutual-exclusion-101)
    - [Terms](#terms)
    - [Race Condition](#race-condition)
  - [Kernel level Concurrency](#kernel-level-concurrency)
    - [SMP](#smp)
    - [Preemption](#preemption)
    - [Interrupt Handlers](#interrupt-handlers)
  - [FAQ](#faq)
    - [spinlock v.s. spinlock_irq v.s. spinlock_irqsave](#spinlock-vs-spinlock_irq-vs-spinlock_irqsave)
    - [disable preemption v.s. disable interrupts](#disable-preemption-vs-disable-interrupts)
  - [Conclusion](#conclusion)

Modern operating system is inherently concurrent, because of the support for SMP, interrupts, as well as kernel preemption. To ensure correctness of the kernel and prevent data corruption resulting from race conditions, certain mechanisms have to be used to ensure mutual exclusion.

## Mutual Exclusion 101

### Terms

- `control path`: logical entity of program execution, as well as the basic unit participating synchronization activities. It could be a thread, or a piece of code without a context such as a interrupt handler.

- `synchronization`: coordination between multiple entities, i.e. control paths in programs, examples including mutual exclusion, producer-consumer, etc.

- `mutual exclusion`: the relation between multiple control paths that only allows one control path to access certain data at any time.

- `race condition`: a situation when mutual exclusion fails, control paths race with each other to access the data without synchronization.

- `critical section`: a code segment that accesses data in a mutual exclusive way.

- `atomic operation`: in the context of kernel programming, atomic operations refer to hardware atomic read, write, add, compare-and-exchange instructions. They are the fundamental building blocks of high level synchronization primitives like locks and semphores.

Note that, it is important to distinguish between code and data in mutual exclusion. Mutual exclusion is always associated with certain piece of data and multiple control paths accessing the shared data. Critical section is the code segment that accesses the data.

### Race Condition

Race condition happens where more than two control paths trying to access the same data at the same time without synchronization.

For example, in the code below, two threads access a share counter without synchonization.

    int counter=0;
    void thread1(void){counter++;}
    void thread2(void){counter++;}

Race condition happens when,

    thread1: read from memory, counter=0
    thread2: read from memory, counter=0
    thread1: add in CPU, counter=1
    thread2: add in CPU, counter=1
    thread1: write back to memory, counter=1
    thread2: write back to memory, counter=1

The final value of `counter` is 1. However, because each thread has executed once and add 1 to `counter`, we would expect the final value to be 2.

To prevent race condition, we need to enforce mutual execution between the two threads when accessing the shared data `counter`. Thus, we add spinlocks protect code blocks that access the shared data, and get code like this,

    int counter=0;
    spinlock_t lock;
    void thread1(void){
            spinlock(&lock);
            counter++;
            spin_unlock(&unlock);
    }
    void thread2(void){
            ... same as thread1 ...
    }

The rule of thumb about mutual exclusion is any data shared between multiple control paths should to be protected by some synchronization primitives (e.g. lock, semaphore, etc.) to enforce mutual exclusion, unless the data is accessed with atomic operations or race condition is intendedly allowed.

## Kernel level Concurrency

Modern operating system kernels are inherently concurrent, thus every kernel engineer should be very familiar with kernel level concurrency and the mechanisms to enforce mutual exclusion in OS kernels.

Kernel level concurrency comes from

1. **SMP**: the same piece of kernel code is running in parallel on multiple processors while sharing all kernel data.

2. **Kernel Preemption**: even for a uniprocessor system, the kernel is still concurrent if we allow kernel preemption. Specifically, a process running in kernel space during a system call is allowed to be preempted by another high priority process, which could also call into the kernel and access the same data. Thus, kernel data need to be protected from preemptions.

3. **Interrupt Handlers**: assuming an operating system with only one control path running on a uniprocessor machine, thus there are no preemption or SMP issues. Then interrupt handlers are the final source of concurrency. Whenever an interrupt is trigger by hardware, the current kernel control path is preempted by the interrupt handler, unless interrupts delivery are disabled. If the interrupt handler accesses shared data, mutual exclusion has to be enforced.

To ensure kernel correctness, mutual execution has to be ensured between all possible sources of concurrency.

### SMP

Spinlocks are the common way to enforce mutual exclusion between SMP kernel control paths. Any **data shared between multiple cores need to be protected by spinlocks**. Consequently, **per-cpu data does not need to be protected by spinlocks** because there are only access by local CPU; however, they are still vulnerable to other sources of concurrency, including kernel preemptions and interrupt handlers.

Let's look at an example of how to use spinlock to enforce mutual exclusion in an SMP kernel. In the example below, the simple kernel just add one to a shared counter. Because the kernel supports SMP, spinlocks are used to protect the counter to enforce mutual exclusion between kernel control paths on different cores.

    int counter=0;
    spinlock_t lock;
    void kernel(void){
            spinlock(&lock);
            counter++;
            spin_unlock(&unlock);
    }

Note that, until now this simple kernel does not take preemption or interrupts into account. And the spinlock here has no impact on preemption or interrupts, unlike spinlock APIs provided in current Linux, which implicitly changes kernel preemption state.

### Preemption

In the old days, many commodity kernels are implemented non-preemptive for simplicity. Besides, SMP machines are not widely available yet at that time. Consequently, for non-preemptable kernels, interrupt handlers are the only source of concurrency kernel programmers need to worry about.

The example below shows a simple kernel that is not preemptable. Specifically, we have two applications using the same system call. They enter kernel mode when conducting system call, and returns to user mode once the system call completed. To this end, the `syscall()` have to be thread-safe or reentrant. To achieve this goal, we simply disable kernel preemption whenever we enter kernel code.

    void application1(void){syscall();}
    void application2(void){syscall();}
    
    int a=0;
    void syscall(void){
            int b;
            disable_preemption();
            ... operation on private var b ...
            a++;
            ... operation on private var b ...
            enable_preemption();
    }

The disadvantages of this approach include,

- It decrease kernel responsiveness. Assuming application2 has higher priority but application1 is currently in kernel mode. Disabling preemption prevents a high priority process to preempt a lower priority process. It is especially harmful for realtime applications or latency sensitive applications.

- If there is a dead-loop bug in `syscall()`, or more likely in a driver code called by `syscall()`, then no other applications are going to get the CPU again since preemption is disabled.

Consequently, most modern kernels are preemptable to certain degree. Therefore, shared data need to be protected from **kernel preemptions** as well as **SMP accesses**. To this end, we disable kernel preemption using finer-grain protection. As in the following example, preemption is only disabled when necessary, i.e. when shared variable is accessed.

    void application1(void){syscall();}
    void application2(void){syscall();}
    
    int a=0;
    void syscall(void){
            int b;
            ... operation on private var b ...
            disable_preemption();
            a++;
            enable_preemption();
            ... operation on private var b ...
    }

Now, let's take SMP into account, we could get a kernel as below,

    void application1(void){syscall();}
    void application2(void){syscall();}
    
    int a=0;
    spinlock_t lock;
    void syscall(void){
            int b;
            ... operation on private var b ...
            spin_lock(&lock);
            disable_preemption();
            a++;
            enable_preemption();
            spin_unlock(&lock);
            ... operation on private var b ...
    }

In Linux, **`spin_lock()` will automatically disable preemption by increasing an global variable called `preemption_count`**. In this way, **SMP safe data protected by spinlocks are automatically preemption safe**. However, special attention need to be paid to per-cpu data, which are not protected by locks. Take all these into account, we got kernel code as following,

    void application1(void){syscall();}
    void application2(void){syscall();}
    
    int a=0;
    PER_CPU_VAR x_per_cpu;
    spinlock_t lock;
    void syscall(void){
            int b;
            ... operation on private var b ...
            linux_spin_lock(&lock);
            a++;
            linux_spin_unlock(&lock);
            ...
            disable_preemption();
            x_per_cpu++;
            enable_preemption();
            ... operation on private var b ...
    }

In the code above, `spin_lock()` disables preemption implicitly, and explicit preemption protection is only add to per-cpu data. Besides, **Linux also has the `get_cpu()` and `put_cpu()` interface to disable and enable preemption**.

### Interrupt Handlers

Finally, let's deal with interrupt handlers.

An interrupt is an signal trigger by hardware to notify some events. When interrupt happens, interrupt handler would **preempt any current control path**, unless interrupts are disabled. Therefore, any **data shared between normal kernel control path and interrupt handles need to protected by disabling interrupts**.

We have discussed in previous section that Linux `spin_lock()` protects data from **SMP** as well as **preemption**, however, it does not protects data from **interrupts**. For example, **kernel control path holding a lock using `spin_lock()` could be preempted by an interrupt handler, which may access the same data and try to acquire the same lock**. On uniprocessors, this results in **deadlock** because the lock is holder by another kernel control path which can only execute after current interrupt handler returns. In case of SMP machines, the interrupt handler may finally get the lock if the control path holding the lock is **migrated to another core** and release the lock, which still causes significant performance slowdown. Thus in practice, **data shared between kernel code and interrupt handlers need to be protected**.

To address this issue, and correctly share data between interrupt handlers we should **acquire spinlock and disabling interrupts at the same time**, e.g. using Linux API `spin_lock_irqsave()`.

For per-cpu data, if it is shared with interrupt handlers, preemption and interrupts need to disabled at the same time.

An interesting question is **if interrupts are disabled, reschedule events triggered by timer interrupts are thus disabled**, why do we need to disable preemption? This question is addressed in FAQ.

## FAQ

### spinlock v.s. spinlock_irq v.s. spinlock_irqsave

All these Linux spinlock APIs disable preemption. However, they have different semantic regards interrupt handling.

If you want to disable interrupts while acquiring a lock, you typically want to use `spinlock_irqsave` instead of `spinlock_irq`. Because the former has a save and restore semantic when disabling interrupts, so that you will restore interrupt status instead of enable it blindly. Imaging you are holding nested spinlocks, inside spinlock should not enable interrupts, if outside spinlock disabled it.

### disable preemption v.s. disable interrupts

Disabling interrupts largely prevents kernel preemption since **timer interrupts** that triggers reschedule are disabled. However, **even with interrupts disabled preemption is still possible when the protected code calls another kernel function that triggers reschedule**. Thus, **disable interrupts protects you from kernel preemption only if the protected code does not trigger preemption itself**.

## Conclusion

To conclude, three sources of kernel concurrency uses different mechanisms to enforce mutual exclusion. If data is shared by between two or three sources, multiple mechanisms have to be used. For example, `spin_lock_irqsave()` in Linux combined all three mechanisms in one API.

Finally, the three sources of kernel level concurrency and the corresponding protection mechanism are listed in the table below.

|Source of Concurrency|Protection Mechanism|
|-|-|
SMP|spinlock
Kernel Preemption|disable preemption
Interrupt Handler|disable interrupts
|
