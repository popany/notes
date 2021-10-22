# [Processes and Threads](https://www.cs.umb.edu/~eoneil/cs444_f06/class10.html)

- [Processes and Threads](#processes-and-threads)
  - [Process Table Entries](#process-table-entries)
  - [Interrupt Processing steps (Interrupt cycle + interrupt handler execution)](#interrupt-processing-steps-interrupt-cycle--interrupt-handler-execution)
  - [Each process has a kernel stack (or more generally, each thread has its own stack)](#each-process-has-a-kernel-stack-or-more-generally-each-thread-has-its-own-stack)
  - [The kernel stack (of the currently running process or thread) is also used by interrupt handlers](#the-kernel-stack-of-the-currently-running-process-or-thread-is-also-used-by-interrupt-handlers)
  - [Threads](#threads)

## Process Table Entries

To the kernel, processes are software objects, like a banking application regards a checking account. Each process has a process table entry in the process table.

See Tan., pg. 80 for info in the process entry. The "registers" here are better called "saved registers", because they are copies of the CPU registers at the moment the process loses the CPU because it's blocking or being preempted.  These saved registers save the CPU state for the next moment that the process is scheduled, at which point the values are copied back into the CPU. Once the CPU state is set back, and the address space set up again, the CPU continues execution just where it left off.  This is the basic time-sharing mechanism that allows multiple processes all to think they have "the CPU".

Tan. intro's interrupts at this point, since they are crucial to the understanding of preemption and unblocking. Luckily we already have studied them in the simpler situation of standalone programming. Here are the steps from Tan., pg. 80:

## Interrupt Processing steps (Interrupt cycle + interrupt handler execution)

1. CPU stacks PC, etc. <- on kernel stack, see below

2. CPU loads new PC from int. vector

3. As fn saves registers

4. As fn sets up new stack

5. C interrupt handler runs, typically reads and buffers input

6. Scheduler (a C fn) decides which process is to run next (decision only, i.e., figure out pid)

7. C fn returns to as fn

8. As fn starts up (dispatches) new current process (and saves CPU state for old process in old process entry before loading CPU state from new process entry) (often the new process is the same as the old one, so this is a nop)

Note that steps 1. and 2. are part of the **CPU interrupt cycle**, and note that the CPU switches to the kernel stack pointer before pushing these items on the stack, so they end up on the kernel stack. Steps 3-8 constitute the interrupt handler.

Steps 4, 6, and 8 are new to us:

Step 4: Actually this is optional. Many OS kernels allow interrupt handlers to execute on the kernel stack that the CPU just used to stack the PC.

Step 6: **Scheduler** loops through process table entries, looking for highest priority ready/running process. This is preparation for possible preemption.

Step 8: This is the real process switch, where the CPU state is switched, along with the address-space (like a brain transplant). This may or may not happen, since often the same old process is allowed to continue execution.

We can list a step 9 here, where the iret occurs. In the case of a process switch, this will be executed later (if we are following the lifetime of the old process), after the CPU state is restored for this process.

## Each process has a kernel stack (or more generally, each thread has its own stack)

Just like there has to be a separate place for each process to hold its set of saved registers (in its process table entry), **each process also needs its own kernel stack, to work as its execution stack when it is executing in the kernel**.

For example, if a process is doing a read syscall, it is executing the kernel **code** for read, and needs a **stack** to do this. It could block on user input, and give up the CPU, but that whole execution environment held on the stack (and in the saved CPU state in the **process table entry**) has to be saved for its later use. Another process could run meanwhile and do its own syscall, and then it needs its **own kernel stack**, separate from that blocked reader's stack, to support its **own kernel execution**.

Since threads can also do system calls, each needs a kernel stack as well.

**In Linux, the process/thread table entry and kernel stack are bundled up in one block of memory for each thread**. Other OS's organize the memory differently, but still have both of these for each process/thread.

Sometimes the kernel stack is completely empty, notably when the process is executing user code. Then when it does a system call, the kernel stack starts growing, and later shrinking back to nothing at the system call return.

## The kernel stack (of the currently running process or thread) is also used by interrupt handlers

The **kernel stack** is also used for **interrupt handler execution**, for the interrupts that occur while a particular thread is running. As we have talked about already, the interrupts are almost always doing something for another, blocked process/thread. After all, that process is blocked waiting for something to happen, and **all the hardware happenings are signaled by interrupts**.

So **interrupt handlers "borrow" the current process's kernel stack to do their own execution**. When they finish, the kernel stack is back to its previous state, empty if the current process is running at user level or non-empty if it was running in some system call. Note that interrupt handlers are not themselves allowed to block, so their execution is not delayed that way. They can be involved in process switches, as shown by step 8 above, but only just as they are returning, not in the middle of their work, so their changes to system state are complete.

We are beginning to see that system call code and interrupt handler code are somewhat differently handled kinds of kernel code.

## Threads

So far, we have been mainly considering single-threaded processes, with one program counter saying where in the code the CPU is now executing, and one stack. Some programs have multiple ongoing activities that can benefit from multiple threads.

Example: mtip rewritten with threads:  recall that mtip has two processes:

- running the keymon fn, reads from user
- running the linemon fn, reads from SAPC.
 
The more modern approach would be to use an explicit `thread_create` to make a second thread for linemon, leaving the original thread to run keymon

    thread_create(linemon, ...);

Then we end up with two threads, with two stacks and two relevant PCs, one in keymon and one in linemon at each point in time, all in one address space.  This is a higher-performance implementation, because it avoids a lot of address-space switches needed between the two processes.

Next time: look at Tanenbaum's example of the multithreaded web server.
