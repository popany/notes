# [Process context vs. interrupt context](https://titanwolf.org/Network/Articles/Article?AID=909ac131-712a-442a-9c5d-fac7056f7792)

- [Process context vs. interrupt context](#process-context-vs-interrupt-context)

Kernel space and user space are two working modes of modern operating systems. Kernel modules run in kernel space, and user mode applications run in user space. They represent different levels and have different access rights to system resources. The kernel module runs at the highest level (kernel mode), all operations at this level are trusted by the system, and the application runs at a lower level (user mode). At this level, the processor controls direct access to hardware and unauthorized access to memory. **Kernel mode and user mode have their own memory map, that is, their own address space**.

The processor is always in one of the following states:

1. Kernel mode, running in the **process context**, the kernel runs in the kernel space on **behalf of the process**;

2. Kernel state, running in **interrupt context**, kernel running on kernel space on **behalf of hardware**;

3. User mode, running in user space.

Application programs in user space enter the kernel space through system calls. The kernel runs on behalf of the process in the kernel space, which involves context switching. User space and kernel space have **different address mappings**, general or special register sets, and user space processes have to pass many variables and parameters to the kernel. The kernel should also save some registers, variables, etc. of the user process, so that after the system call is completed, it returns to the user space to continue execution.

The so-called "process context" is the value of all registers of the CPU, the state of the process and the contents of the stack when a process is executed. When the kernel needs to switch to another process, it needs to save all the state of the current process, That is, save the process context of the current process, so that when the process is executed again, the state at the time of switching can be restored and the execution continues.

Through the trigger signal, the hardware causes the kernel to call the interrupt handler and enter the kernel space. During this process, some variables and parameters of the hardware are also passed to the kernel, and the kernel uses these parameters to perform interrupt processing.

The so-called "interrupt context" can actually be regarded as these **parameters passed by the hardware** and some other environments that the kernel needs to save (mainly the currently interrupted process environment).

When a process is executing, the values ​​in all registers of the CPU, the state of the process, and the contents of the stack are called the context of the process. When the kernel needs to switch to another process, it needs to save all the state of the current process, that is, save the context of the current process, so that when the process is executed again, the state at the time of switching must be executed. In LINUX, **the current process context is stored in the task data structure** of the process. When an interrupt occurs, the kernel executes the interrupt service routine in the kernel state **in the context of the interrupted process**. But at the same time, all the resources needed will be reserved so that the execution of the interrupted process can be resumed when the relay service ends.

The Linux kernel works in process context or interrupt context. The kernel code that provides the system call service runs in the process context on behalf of the application that initiated the system call; on the other hand, the interrupt handler runs asynchronously in the interrupt context. **The interrupt context has nothing to do with a specific process**.

Context: The context is simply an environment, relative to the process, it is the environment when the process is executed. Specifically, it is each variable and data, including all register variables, files opened by the process, and memory information.

The context of a process can be divided into three parts: user-level context, register context, and system-level context.

- User-level context: text, data, user stack, and shared storage area;

- register context: general-purpose register, program register (IP), processor status register (EFLAGS), stack pointer (ESP);

- system-level context: process control block task_struct Memory management information (mm_struct, vm_area_struct, pgd, pte), kernel stack.

When process scheduling occurs, a process switch is a context switch. The operating system must switch all the information mentioned above before the newly scheduled process can run. The **system call is a mode switch**. Compared with process switching, mode switching is much easier and saves time, because the main task of mode switching is to switch the context of the process register.

The process context is mainly exception handlers and kernel threads. The reason why the kernel enters the process context is because some work of the process itself needs to be done in the kernel. For example, system calls **serve the current process**, and exceptions usually **deal with error conditions caused by the process**. So it makes sense to refer to current in the context of the process.

The kernel enters the interrupt context due to **interrupt processing** or **soft interrupts caused by interrupt signals**. The interrupt signal occurs randomly. The interrupt handler and soft interrupt cannot predict in advance which process is currently running when the interrupt occurs, so **it is possible to refer to current in the interrupt context, but it does not make sense**. In fact, the interrupt signal that the A process wishes to wait for may occur during the execution of the B process. For example, the A process starts the disk write operation, and the B process is running after the A process sleeps. When the disk is written, **the disk interrupt signal interrupts the B process, and the A process will be woken up during the interrupt processing**.

The kernel can be in two contexts: process context and interrupt context. After the system call, the user application enters the kernel space, and then the kernel space runs in the process context for the representative of the corresponding process in the user space. An interrupt that occurs asynchronously will cause the interrupt handler to be called, and the interrupt handler will run in the interrupt context. **The interrupt context and the process context cannot happen at the same time**.

The kernel code running in the process context is **preemptible**, but the interrupt context will run until the end and will **not be preempted**. Therefore, the kernel restricts the work of the interrupt context and does not allow it to perform the following operations:

1. Go to sleep or give up CPU actively;

   Since the **interrupt context does not belong to any process**, it **has nothing to do with current** (although current points to the interrupted process at this time), so once the interrupt context sleeps or gives up the CPU, it cannot be awakened. So it is also called **atomic context**.

2 Occupy the mutex;

   In order to protect the critical resources of the interrupt handle, mutexes cannot be used. If the semaphore is not available, the code will sleep, and the same situation as above will occur. If you must use a lock, **use spinlock**.

3. Perform time-consuming tasks;

   Interrupt processing should be as fast as possible, because the kernel has to respond to a large number of services and requests, and interrupting the context to take too much CPU time will seriously affect system functions. When a time-consuming task is executed in an interrupt processing routine, it should be handled by the **bottom half** of the interrupt processing routine.

4. Access user space virtual memory.

   Because the interrupt context has nothing to do with a specific process, it is the kernel running in kernel space on behalf of the hardware, so the virtual address of user space cannot be accessed in the interrupt context

5. Interrupt handling routines should not be set to reentrant (routines that can be called in parallel or recursively).

   Because when the interrupt occurs, **both preempt and irq are disabled** until the interrupt returns. Therefore, the interrupt context is not the same as the process context. Different instances of the interrupt processing routine are not allowed to run concurrently on the SMP.

6. The interrupt processing routine can be interrupted by a higher level IRQ.

   If you want to disable this interrupt, you can define the interrupt processing routine as a fast processing routine, which is equivalent to telling the CPU to prohibit all interrupt requests on the local CPU when the routine is running. The direct result of this is that the system performance is degraded due to delayed response to other interrupts
