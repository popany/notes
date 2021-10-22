# [Kernel Stack and User Space Stack](https://www.baeldung.com/linux/kernel-stack-and-user-space-stack)

- [Kernel Stack and User Space Stack](#kernel-stack-and-user-space-stack)
  - [1. Overview](#1-overview)
  - [2. Stack](#2-stack)
  - [3. Kernel Space and User Space](#3-kernel-space-and-user-space)
  - [4. User and Kernel Stacks](#4-user-and-kernel-stacks)
  - [5. Conclusion](#5-conclusion)

## 1. Overview

The kernel stack and the user stack are implemented using the stack data structure and, taken together, serve as a call stack. In this article, we’ll discuss the usage of the call stack in the user and kernel space. We’ll also briefly explore virtual memory and its mapping for a process.

## 2. Stack

A stack is a LIFO data structure. We can perform push to add an item onto the stack and pop to remove one. The stack data structure can be useful in expression evaluation/conversion, syntax checking, order reversing, backtracing, and function calls.

Programs usually consist of many functions, which in turn can call other functions. A recursive (reentrant) function can also call itself. In either case, we can describe program execution flow with a call graph of callers and callees.

As we follow the program execution, we need to save states for the transfer of control among functions. For this purpose, we use a call stack that is based on the stack data structure. Certain architecture-dependent conventions define what states are saved by caller and callee during execution.

Within a call stack, we can find a series of stack frames. A stack frame consists of data relevant to a particular function. It usually includes function arguments, the return address, and local data. As we go deep into the call graph, more frames are allocated, which increases the size of the call stack.

## 3. Kernel Space and User Space

Memory in modern systems is not accessed directly. A virtual address space is used that is backed by physical memory. Conceptually, virtual and physical memory is divided into chunks called pages. The typical page size is 4096 bytes.

So, what does this buy us? Well, quite a lot, as it turns out. For one, there's less memory management hassle while sharing memory among processes. This model is also more secure, as each process has its own virtual memory space (memory isolation). It also yields virtually unlimited memory, as backing with physical pages can be on-demand (demand paging). Moreover, the system can swap inactive pages to the hard drive. Refer to our article on managing swap-space for additional information.

Virtual memory space is segregated into user and kernel space. The kernel space is the higher part of the virtual memory address space. For example, in x86_64 architecture, this mapping starts at 0xffff800000000000.

Besides memory regions, hardware architectures also provide restrictions on I/O ports and CPU instructions. For example, in x86, we have four protection rings numbered 0 to 3, although in Linux, we only use ring-0 (kernel mode) and ring-3 (user mode).

If a user process requires services that are restricted, it can use system calls (syscalls). Collectively, these syscalls form an interface for user applications to access kernel resources.

## 4. User and Kernel Stacks

In the user space, we can find the user stack that grows downward to lower addresses, whereas dynamic allocations (heap) grow upwards to higher addresses. The user stack is only used while the process is running in user mode.

The **kernel stack is part of the kernel space**. Hence, it is not directly accessible from a user process. Whenever a user process uses a syscall, the CPU mode switches to kernel mode. **During the syscall, the kernel stack of the running process is used**.

The size of the kernel stack is configured during compilation and remains fixed. This is usually two pages (8KB) for each thread. Moreover, additional **per-CPU interrupt stacks** are used to process external interrupts. While the process runs in user mode, these special stacks don't have any useful data.

Unlike the kernel stack, we can change the **user stack**:

    # ulimit -s
    8192
    # ulimit -s 32768
    # ulimit -s
    32768
    # ulimit -s unlimited
    # ulimit -s
    unlimited
    #

Using the ulimit command, we can check the current limits. We can set or view the user stack size (in Kbytes) with the `-s` option. The value unlimited means that the stack size has no limits.

Let's now execute a custom program that requires large stack space:

    # ulimit -s 
    8192
    # ./ackermann.x 3 12
    Ackermann(3,12) = 32765
    # ./ackermann.x 3 15
    Segmentation fault (core dumped)
    # ulimit -s 1048576
    # ulimit -s 
    1048576
    # ./ackermann.x 3 15
    Ackermann(3,15) = 262141
    #

Our custom program implements the [Ackermann function](https://en.wikipedia.org/wiki/Ackermann_function), which can use a lot of stack space for some inputs. For instance, in this example, we’ve increased the stack limit to 1 GB for inputs 3 and 15.

## 5. Conclusion

With separate user and kernel stacks for each process or thread, we have better isolation. Problems in the user stack can’t cause a crash in the kernel. This isolation makes the kernel more secure because it only trusts the stack area that is under its control.

However, since the stack grows with deeply nested calls, we need to be cautious about the space complexity of algorithms. This becomes more important for kernel code because we can’t easily change the kernel stack size.
