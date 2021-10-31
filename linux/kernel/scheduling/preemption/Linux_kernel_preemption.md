# [Linux kernel preemption](https://titanwolf.org/Network/Articles/Article?AID=e894cc6a-6b6e-4d27-afaf-4b883cac8221)

- [Linux kernel preemption](#linux-kernel-preemption)
  - [1. Basic concepts](#1-basic-concepts)
  - [2. Implementation of kernel preemption](#2-implementation-of-kernel-preemption)
    - [percpu variable `__preempt_count`](#percpu-variable-__preempt_count)
    - [The role of `__preempt_count`](#the-role-of-__preempt_count)
    - [`thread_info` flags](#thread_info-flags)
    - [`__preempt_count` related operations](#__preempt_count-related-operations)
  - [3. The implementation of system call and interrupt processing flow and the impact of preemption](#3-the-implementation-of-system-call-and-interrupt-processing-flow-and-the-impact-of-preemption)
    - [Basic flow of system call entry](#basic-flow-of-system-call-entry)
    - [Interrupt the basic process of entrance](#interrupt-the-basic-process-of-entrance)
  - [4. Seize concurrent security with SMP](#4-seize-concurrent-security-with-smp)
  - [5. Several questions as a review](#5-several-questions-as-a-review)

It mainly introduces the related concepts and specific implementation of kernel preemption, and some effects of preemption on kernel scheduling and kernel race and synchronization.

(Used kernel version 3.19.3)

## 1. Basic concepts

User preemption and kernel preemption

- User preemption occurs

  - When returning to user mode from a **system call** or **interrupt context**, the `need_resched` flag will be checked, and if set, the user mode task will be re-selected for execution

- Kernel preemption occurs

  - When returning to kernel mode from the **interrupt context**, check the `need_resched` flag and `__preemp_count` count. If the flag is set and can be preempted, the scheduler `preempt_schedule_irq()` will be triggered

  - The kernel code directly or indirectly displays the **`schedule` call** due to blocking and other reasons, such as `preemp_disable` may trigger `preempt_schedule()`

- In essence, the tasks in the kernel state share a kernel address space. On the same core, the task returned from the interrupt is likely to execute the same code as the preempted task, and the two are waiting for their respective resources to be released. If the user changes the same shared variable, it will cause a deadlock or race state. For user state preemption, because each user state process has an independent address space, it returns to the user from the kernel code (system call or interrupt) At the time of the state, because it is a lock or shared variable in different address spaces, there will be no deadlocks or race conditions between different address spaces, and there is no need to check `__preempt_count`, which is safe. `__preempt_count` is mainly responsible for kernel preemption count.

## 2. Implementation of kernel preemption

### percpu variable `__preempt_count`

    Preemption count 8 bits, PREEMPT_MASK =>  0x000000ff 
    soft interrupt count 8 bits, SOFTIRQ_MASK =>  0x0000ff00 
    hard interrupt count 4 bits, HARDIRQ_MASK =>  0x000f0000 
    non-maskable interrupt 1 bit, NMI_MASK =>  0x00100000
    PREEMPTIVE_ACTIVE(identifies the kernel preemption triggered schedule) =>  0x00200000 
    scheduling flag 1 bit, PREEMPT_NEED_RESCHED =>  0x80000000

### The role of `__preempt_count`

- Preemption count

- Determine the current context

- Reschedule ID

### `thread_info` flags

One of the flags of `thread_info` is `TIF_NEED_RESCHED`. When the **system call** returns, **interrupt** returns, and `preempt_disable`, it will check whether it is set. If it is set and the preemption count is 0 (preemptable), it will trigger `reschedule()` or `preempt_schedule()` Or `preempt_schedule_irq()`. Normally, the `scheduler_tick` will check whether this flag is set (triggered once for each HZ), and then check when the next interrupt returns. If the setting will trigger rescheduling, this flag will be cleared in `schedule()`.

    //kernel/sched/core.c 
    //Set the need_resched flag of thread_info flags and __preempt_count 
    void resched_curr(struct rq *rq)
    {
        /* Omit */
        if (cpu == smp_processor_id()) {
        //Set thread_info's need_resched flag
            set_tsk_need_resched(curr);
        //Set the need_resched flag in the preemption count __preempt_count
            set_preempt_need_resched();
            return;
        }
        /* Omit */
    }
    
    //Clear the need_resched flag in thread_info and __preempt_count in schedule ()
    static void __sched __schedule(void)
    {
        /* Omit */
    need_resched:
        //Close preemption to read the current CPU id in the percpu variable and run the queue
        preempt_disable();
        cpu = smp_processor_id(); 
        rq = cpu_rq(cpu);
        rcu_note_context_switch();
        prev = rq->curr;
        /* omitted */
        //close local interrupt, preemption closed, acquire a spin lock rq
        raw_spin_lock_irq(&rq->lock);
        switch_count =  &prev->nivcsw;
      //0x00200000 PREEMPT_ACTIVE 
      //= the preempt_count __preempt_count & (~ (0x80000000)) 
      //if the process is not in the running state or the identifier provided PREEMPT_ACTIVE 
      //(i.e., this is because the kernel schedule preemption ), The current process will not be moved out of the queue 
      //The PREEMPT_ACTIVE flag is called when the interrupt returns to the kernel space 
      //preempt_schdule_irq or the kernel space calls preempt_schedule 
      //and is set, indicating that the schedule is caused by kernel preemption The current 
      //process 
        will not be taken from the run queue, because it may not be able to run again. if (prev>state &&  !(preempt_count() & PREEMPT_ACTIVE)) {
        //run_queue 
            if (unlikely(signal_pending_state(prev>state, prev))) {
                prev>state = TASK_RUNNING;
            } else { //otherwise remove the queue and let it sleep
                deactivate_task(rq, prev, DEQUEUE_SLEEP);
                prev->on_rq =  0;
                //work queue if a kernel thread wake- 
                IF (prev->flags & PF_WQ_WORKER) {
                    struct task_struct *to_wakeup;
    
                    to_wakeup = wq_worker_sleeping(prev, cpu);
                    if (to_wakeup)
                        try_to_wake_up_local(to_wakeup);
                }
            }
            switch_count =  &prev->nvcsw;
        }
        /* Omit */
        next = pick_next_task(rq, prev);
        //Clear the need_resched flag of the previous task
        clear_tsk_need_resched(prev);
        //Clear the need_resched flag of preemption count
        clear_preempt_need_resched();
        rq->skip_clock_update =  0;
        //not the current process context switch 
        IF (likely(prev =! next)) {
            rq->nr_switches++;
            rq->curr = next;
            ++ *switch_count;
            rq = context_switch(rq, prev, next);
            cpu = cpu_of(rq);
        } The else
            raw_spin_unlock_irq(&rq->lock);
        post_schedule(rq);
        //Reopen preemption
        sched_preempt_enable_no_resched();
        //Check again need_resched 
        if (need_resched())
            goto need_resched;
    }

### `__preempt_count` related operations

    ///////need_resched logo related /////////
    
    //If the PREEMPT_NEED_RESCHED bit is 0, scheduling is required 
    # define PREEMPT_NEED_RESCHED 0x80000000
    
    static __always_inline void set_preempt_need_resched(void)
    {
      //Clear the highest bit of __preempt_count to indicate need_resched
      raw_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
    }
    
    static __always_inline void clear_preempt_need_resched(void)
    {
      //__preempt_count highest position
      raw_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
    }
    
    static __always_inline bool test_preempt_need_resched(void)
    {
      return !(raw_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
    }
    
    //Whether rescheduling is required, two conditions: 1. The preemption count is 0; 2. The highest bit is cleared 
    static __always_inline bool should_resched(void)
    {
      return unlikely(!raw_cpu_read_4(__preempt_count));
    }
    
    //////////Preemption count related /////////
    
    # define PREEMPT_ENABLED (0 + PREEMPT_NEED_RESCHED) 
    # define PREEMPT_DISABLE (1 + PREEMPT_ENABLED) 
    //Read __preempt_count and ignore the need_resched flag 
    static __always_inline int preempt_count(void)
    {
      return raw_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
    }
    static __always_inline void __preempt_count_add(int val)
    {
      raw_cpu_add_4(__preempt_count, val);
    }
    static __always_inline void __preempt_count_sub(int val)
    {
      raw_cpu_add_4(__preempt_count, -val);
    }
    //Preemption count plus 1 to close preemption 
    # define preempt_disable ()\
    do {\
      preempt_count_inc();\
      barrier();\
    } while (0)
    //Re-open preemption and test whether rescheduling is required 
    # define preempt_enable ()\
    do {\
      barrier();\
      if (unlikely(preempt_count_dec_and_test()))\
        __preempt_schedule();\
    } while (0)
    
    //preempt and reschedule 
    //setting PREEMPT_ACTIVE here will affect the behavior in schdule ()
    asmlinkage __visible void __sched notrace preempt_schedule(void)
    {
      //If the preemption count is not 0 or there is no interrupt, then do not schedule 
      if (likely(!preemptible()))
        return;
      do {
        __preempt_count_add(PREEMPT_ACTIVE);
        __schedule();
        __preempt_count_sub(PREEMPT_ACTIVE);
        barrier();
      } while (need_resched());
    }
    //Check thread_info flags 
    static __always_inline bool need_resched(void)
    {
      return unlikely(tif_need_resched());
    }
    
    ////// Interrupt related ////////
    
    //hardware interrupt count 
    # define hardirq_count () (preempt_count () & HARDIRQ_MASK) 
    //soft interrupt count 
    # define softirq_count () (preempt_count () & SOFTIRQ_MASK) 
    //interrupt count 
    # define irq_count () (preempt_count () & (HARDIRQ_MASK | SOFTIRQ_MASK\
             | NMI_MASK))
    //Is it in an external interrupt context 
    # define in_irq () (hardirq_count ()) 
    //Is it in a soft interrupt context 
    # define in_softirq () (softirq_count ()) 
    //Is it in an interrupt context 
    # define in_interrupt () (irq_count ()) 
    # define in_serving_softirq () (softirq_count () & SOFTIRQ_OFFSET)
    
    //Whether it is in a non-maskable interrupt environment 
    # define in_nmi () (preempt_count () & NMI_MASK)
    
    //Whether it can be preempted: the preemption count is 0 and it is not in the environment where preemption is turned off 
    # define preemptible () (preempt_count () == 0 &&! Irqs_disabled ())

## 3. The implementation of system call and interrupt processing flow and the impact of preemption

(arch/x86/kernel/entry_64.S)

### Basic flow of system call entry

- Save the current rsp, and **point to the kernel stack**, save the register state

- Call the corresponding processing function in the system call function table with the interrupt number

- Check the flags of `thread_info`, signal processing and `need_resched` when returning

  - If there is no signal and `need_resched`, directly restore the register and return to user space

  - If there is signal processing signal, and check again

  - If there is `need_resched`, reschedule and return to check again

### Interrupt the basic process of entrance

- Save register state

- call `do_IRQ`

- Interrupt return, restore the stack, check whether the **kernel context** or **user context** is interrupted

  - If it is a **user context**, check whether the `thread_info` flags need to **process the signal** and `need_resched`, if necessary, process the signal and `need_resched`, and check again; otherwise, directly interrupt to return to user space

  - If it is a **kernel context**, check whether `need_resched` is required, if necessary, check whether `__preempt_count` is 0 (can be preempted), if it is 0, call `preempt_schedule_irq` to reschedule

.

    //Processing logic of system call 
    
    ENTRY(system_call)
      /* ... omitted ... */
      //Save the current stack top pointer to the percpu variable
      movq  % rsp,PER_CPU_VAR(old_rsp)
      //Assign the kernel stack bottom pointer to rsp, which is moved to the kernel stack
      movq  PER_CPU_VAR(kernel_stack),% rsp 
      /* ... omit ... */
    system_call_fastpath:
    #if __SYSCALL_MASK == ~0
      cmpq $ __ NR_syscall_max,% rax
    #else
      andl $ __ SYSCALL_MASK,% eax
      cmpl $ __ NR_syscall_max,% eax
    #endif
      ja ret_from_sys_call  /* and return regs-> ax */
      movq % r10,% rcx  
      //system call
      call * sys_call_table(,% rax,8)  # XXX:  rip relative
      movq % rax,RAX-ARGOFFSET(% rsp)
    
    ret_from_sys_call:
      movl $ _TIF_ALLWORK_MASK,% edi 
      /* edi: flagmask */
    
    //Check flags of thread_info when returning
    sysret_check:  
      LOCKDEP_SYS_EXIT
      DISABLE_INTERRUPTS(CLBR_NONE)
      TRACE_IRQS_OFF
      movl TI_flags+THREAD_INFO(% rsp,RIP-ARGOFFSET),% edx
      andl % edi,% edx
      jnz  sysret_careful  //If there are thread_info flags that need to be processed, such as need_resched 
      ////return directly
      CFI_REMEMBER_STATE
      /* * sysretq will re-enable interrupts: */
      TRACE_IRQS_ON
      movq RIP-ARGOFFSET(% rsp),% rcx
      CFI_REGISTER  rip,rcx
      RESTORE_ARGS 1,-ARG_SKIP,0 
      /* CFI_REGISTER rflags, r11 */
      //Save the top stack address (rsp) in the percpu variable before restoration
      movq  PER_CPU_VAR(old_rsp), % rsp 
      //Return to user space
      USERGS_SYSRET64
    
      CFI_RESTORE_STATE
    
      ////If the thread_info flag is set, you need to return after processing 
      /* Handle reschedules */
    sysret_careful:
      bt $ TIF_NEED_RESCHED,% edx   //Check if rescheduling is required
      jnc sysret_signal //If there is a signal 
      //deal with need_resched if there is no signal
      TRACE_IRQS_ON
      ENABLE_INTERRUPTS(CLBR_NONE)
      pushq_cfi % rdi
      SCHEDULE_USER  //Call schedule () to return to user mode without checking __preempt_count
      popq_cfi % rdi
      jmp sysret_check  //Check again
    
      //If a signal occurs, the signal needs to be processed
    sysret_signal:
      TRACE_IRQS_ON
      ENABLE_INTERRUPTS(CLBR_NONE)
    
      FIXUP_TOP_OF_STACK % r11, -ARGOFFSET
      //If there is a signal, jump unconditionally
      jmp int_check_syscall_exit_work
    
      /* ... omitted ... */
    GLOBAL(int_ret_from_sys_call)
      DISABLE_INTERRUPTS(CLBR_NONE)
      TRACE_IRQS_OFF
      movl $ _TIF_ALLWORK_MASK,% edi 
      /* edi: mask to check */
    GLOBAL(int_with_check)
      LOCKDEP_SYS_EXIT_IRQ
      GET_THREAD_INFO(% rcx)
      movl TI_flags(% rcx),% edx
      andl % edi,% edx
      jnz   int_careful
      andl    $ ~TS_COMPAT,TI_status(% RCX)
      jmp   retint_swapgs
    
      /* Either reschedule or signal or syscall exit tracking needed. */
      /* First do a reschedule test. */
      /* Edx: work, edi: workmask */
    int_careful:
      bt $ TIF_NEED_RESCHED,% edx
      jnc  int_very_careful  //If not only need_resched, jump
      TRACE_IRQS_ON
      ENABLE_INTERRUPTS(CLBR_NONE)
      pushq_cfi % rdi
      SCHEDULE_USER  //Schedule
      popq_cfi % rdi
      DISABLE_INTERRUPTS(CLBR_NONE)
      TRACE_IRQS_OFF
      jmp int_with_check  //Check again
    
      /* handle signals and tracing-both require a full stack frame */
    int_very_careful:
      TRACE_IRQS_ON
      ENABLE_INTERRUPTS(CLBR_NONE)
    int_check_syscall_exit_work:
      SAVE_REST
      /* Check for syscall exit trace */
      testl $ _TIF_WORK_SYSCALL_EXIT,% edx
      jz int_signal
      pushq_cfi % rdi
      leaq 8( % rsp),% rdi # &ptregs -> arg1
      call syscall_trace_leave
      popq_cfi % RDI
      andl $ ~(_TIF_WORK_SYSCALL_EXIT|_TIF_SYSCALL_EMU),% EDI
      jmp int_restore_rest
    
    int_signal:
      testl $ _TIF_DO_NOTIFY_MASK,% edx
      jz 1f
      movq % rsp,% rdi    # &ptregs -> arg1
      xorl % esi,% esi    # oldset -> arg2
      call do_notify_resume
    1:  movl $ _TIF_WORK_MASK,% edi
    int_restore_rest:
      RESTORE_REST
      DISABLE_INTERRUPTS(CLBR_NONE)
      TRACE_IRQS_OFF
      jmp int_with_check  //Check thread_info flags again
      CFI_ENDPROC
    END(system_call)
    //Interrupt the basic process of entrance
    
    //Call the function wrapper of do_IRQ
      .macro interrupt func
      subq $ ORIG_RAX-RBP,% rsp
      CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
      SAVE_ARGS_IRQ//Save the register when entering the interrupt processing context
      call\func
     /* ... omitted ...*/
    
    common_interrupt:
     /*... omitted ... */
      interrupt do_IRQ//Call c function do_IRQ to actually handle interrupt
    
    ret_from_intr://Interrupt return
      DISABLE_INTERRUPTS (CLBR_NONE)
      TRACE_IRQS_OFF
      decl PER_CPU_VAR (irq_count)//Decrease irq count
    
     /* Restore saved previous stack */
     //restore the previous stack
      popq% rsi
      CFI_DEF_CFA rsi, SS + 8-RBP /* reg/off reset after def_cfa_expr */
      leaq ARGOFFSET-RBP(%rsi), %rsp
      CFI_DEF_CFA_REGISTER  rsp
      CFI_ADJUST_CFA_OFFSET RBP-ARGOFFSET
    
    exit_intr:
      GET_THREAD_INFO(%rcx)
      testl $3 , CS-ARGOFFSET (% rsp)//Check if the kernel is interrupted
      je retint_kernel//Return to kernel space from interrupt
    
     /* Interrupt came from user space */
     /*
       * Has a correct top of stack, but a partial stack frame
       *% rcx: thread info. Interrupts off.
       */
     //User space is interrupted, return to user space
    retint_with_reschedule:
      movl $ _TIF_WORK_MASK,% edi
    retint_check:
      LOCKDEP_SYS_EXIT_IRQ
      movl TI_flags (% rcx),% edx
      andl% edi,% edx
      CFI_REMEMBER_STATE
      jnz retint_careful//Need to handle need_resched
    
    retint_swapgs:/* return to user-space */
     /*
       * The iretq could re-enable interrupts:
       */
      DISABLE_INTERRUPTS(CLBR_ANY)
      TRACE_IRQS_IRETQ
      SWAPGS
      jmp restore_args
    
    retint_restore_args: /* return to kernel space */
      DISABLE_INTERRUPTS(CLBR_ANY)
     /*
       * The iretq could re-enable interrupts:
       */
      TRACE_IRQS_IRETQ
    restore_args:
      RESTORE_ARGS 1,8,1
    
    irq_return:
      INTERRUPT_RETURN//native_irq enter
    
    ENTRY (native_iret)
     /* ... omitted ... */
     /* edi: workmask, edx: work */
    retint_careful:
      CFI_RESTORE_STATE
      bt $ TIF_NEED_RESCHED,% edx
      jnc retint_signal//signal needs to be processed
      TRACE_IRQS_ON
      ENABLE_INTERRUPTS (CLBR_NONE)
      pushq_cfi% rdi
      SCHEDULE_USER//Schedule before returning to user space
      popq_cfi% rdi
      GET_THREAD_INFO (% rcx)
      DISABLE_INTERRUPTS (CLBR_NONE)
      TRACE_IRQS_OFF
      jmp retint_check//Check thread_info flags again
    
    retint_signal:
      testl $ _TIF_DO_NOTIFY_MASK,% edx
      jz retint_swapgs
      TRACE_IRQS_ON
      ENABLE_INTERRUPTS (CLBR_NONE)
      SAVE_REST
      movq $ -1,ORIG_RAX(%rsp)
      xorl %esi,%esi    # oldset
      movq %rsp,%rdi    # & pt_regs
      call do_notify_resume
      RESTORE_REST
      DISABLE_INTERRUPTS (CLBR_NONE)
      TRACE_IRQS_OFF
      GET_THREAD_INFO (% rcx)
      jmp retint_with_reschedule//After processing the signal, jump again to process need_resched
    
    ////Note that if the kernel configuration supports preemption, use this retint_kernel when returning to the kernel
    #ifdef CONFIG_PREEMPT
     /* Returning to kernel space. Check if we need preemption */
     /* rcx: threadinfo. interrupts off. */
    ENTRY (retint_kernel)
     //Check if __preempt_count is 0 
      cmpl $0 , PER_CPU_VAR (__ preempt_count)  
      jnz retint_restore_args//not 0 , then preemption is prohibited
      bt $ 9 , EFLAGS-ARGOFFSET (% rsp)/* interrupts off? */
      jnc retint_restore_args
      call preempt_schedule_irq//can preempt the kernel
      jmp exit_intr//check again
    #endif
      CFI_ENDPROC
    END(common_interrupt)

## 4. Seize concurrent security with SMP

- Interrupt nesting may lead to deadlocks and race conditions, the general interrupt context will close the local interrupt

- Soft interrupt

- When a task on a core accesses a percpu variable, it may be rescheduled to another core due to kernel preemption to continue to access the percpu variable of the same name on the other core, which may cause deadlock and race conditions.

- Spinlock needs to close both local interrupt and kernel preemption at the same time

...

## 5. Several questions as a review

- When can it be seized?

- When do you need to preempt rescheduling?

- Why does spin lock need to close interrupt and preempt at the same time?

- Why can't the interrupt context sleep? Can I sleep after turning off preemption?

- Why do we need to prohibit preemption when accessing percpu variables?

...
