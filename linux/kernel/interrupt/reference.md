# Interrupt

- [Interrupt](#interrupt)

## [Difference between interrupt context and process context?](https://stackoverflow.com/a/58005391)

Process context is the current state of process, process context **can be go into the sleep**, **preemptable**, It perform time consumable task, acquiring and releasing mutex.

Interrupt context is when the interrupt occurs state/priority goes to interrupt handler, and current process stops/saves until we complete interrupt, Interrupt context is **not time consumable**, **non preemptable**, It **cannot go into the sleep**.

Bottom Half mechanism, SoftIRQ, Tasklet works in a interrupt context, workqueue can go into the sleep, so it is not run in interrupt context.

### Process Context

One of the most important parts of a process are the executing program code. This code was read in from a executable file and executed within the program's address space. Normal program execution occurs in User-space. When a program executes a **system call** or **triggers an exception**, it **enters Kernel-space**. At this point, the kernel are said to **being "executing on behalf of the process" and are in process context**. When in process context, the **current macro is valid**. Upon exiting the kernel, the process resumes execution in User-space, unless a higher-priority process have become runnable In the interim (transition period), in which case the scheduler is invoked to select the higher priority process.

### Interrupt Context

When executing a **interrupt handler** or **bottom half**, the kernel is in interrupt context. Recall That process context is the mode of operation the kernel are in while it's executing on behalf of a process-- For example, executing a system call or running a kernel thread. In process context, the current macro points to the associated task. Furthermore, because a process is coupled to the kernel in process context (because the process is connected to the kernel in the same way as the process above), **process context can SleeP or otherwise invoke the scheduler**.

Interrupt context, on the other hand, was not associated with a process. The current macro isn't relevant (although it points to the interrupted process). Without a backing process (because there is no process background), **interrupt context cannot sleep**-how would it ever reschedule? (or how to reschedule it again?) Therefore, cannot call certain functions from interrupt context. If A function sleeps, you cannot use it from your interrupt handler--this limits the functions so one can call from an Interrupt handler. (This is the limit on what functions can be used in an interrupt handler)

[Link](https://topic.alibabacloud.com/a/summary-of-process-context-and-interrupt-context_8_8_30142056.html) for more details.

## [Interrupt Context](http://books.gigatux.nl/mirror/kerneldevelopment/0672327201/ch06lev1sec5.html)

When executing an interrupt handler or bottom half, the kernel is in interrupt context. Recall that process context is the mode of operation the kernel is in while it is executing on behalf of a processfor example, executing a system call or running a kernel thread. In process context, the `current` macro points to the associated task. Furthermore, because a process is coupled to the kernel in process context, process context can sleep or otherwise invoke the scheduler.

Interrupt context, on the other hand, is not associated with a process. The `current` macro is not relevant (although it points to the interrupted process). Without a backing process, interrupt context cannot sleephow would it ever reschedule? Therefore, you cannot call certain functions from interrupt context. If a function sleeps, you cannot use it from your interrupt handlerthis limits the functions that one can call from an interrupt handler.

Interrupt context is time critical because the interrupt handler interrupts other code. Code should be quick and simple. **Busy looping is discouraged**. This is a very important point; always keep in mind that your interrupt handler has **interrupted other code** (possibly even another interrupt handler on a different line!). Because of this asynchronous nature, it is imperative that all interrupt handlers be as quick and as simple as possible. As much as possible, work should be pushed out from the interrupt handler and performed in a bottom half, which runs at a more convenient time.

The setup of an interrupt handler's stacks is a configuration option. Historically, interrupt handlers did not receive their own stacks. Instead, they would share the stack of the process that they interrupted[1]. The kernel stack is two pages in size; typically, that is 8KB on 32-bit architectures and 16KB on 64-bit architectures. Because in this setup interrupt handlers share the stack, they must be exceptionally frugal with what data they allocate there. Of course, the kernel stack is limited to begin with, so all kernel code should be cautious.

[1] A process is always running. When nothing else is schedulable, the idle task runs.

Early in the 2.6 kernel process, an option was added to reduce the stack size from two pages down to one, providing only a 4KB stack on 32-bit systems. This reduced memory pressure because every process on the system previously needed two pages of nonswappable kernel memory. To cope with the reduced stack size, interrupt handlers were given their own stack, one stack per processor, one page in size. This stack is referred to as the interrupt stack. Although the total size of the interrupt stack is half that of the original shared stack, the average stack space available is greater because interrupt handlers get the full page of memory to themselves.

Your interrupt handler should not care what stack setup is in use or what the size of the kernel stack is. Always use an absolute minimum amount of stack space.
