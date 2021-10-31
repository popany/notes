# Reference

- [Reference](#reference)

## [Why disabling interrupts disables kernel preemption and how spin lock disables preemption](https://stackoverflow.com/a/20787680)

1. `preempt_disable()` **doesn't disable IRQ**. It just increases a `thread_info->preempt_count` variable.

2. Disabling interrupts also disables preemption because scheduler isn't working after that - but only on a single-CPU machine. On the SMP it isn't enough because when you close the interrupts on one CPU the other / others still does / do something asynchronously.

3. The Big Lock (means - closing all interrupts on all CPUs) is slowing the system down dramatically - so it is why it not anymore in use. This is also the reason why `preempt_disable()` doesn't close the IRQ.

You can see what is `preempt_disable()`. Try this:

1. Get a spinlock.

2. Call schedule()

In the dmesg you will see something like "BUG: scheduling while atomic". This happens when scheduler detects that your process in atomic (not preemptive) context but it schedules itself.

## [Why interrupt handlers (ISRs) cannot sleep?](https://stackoverflow.com/a/36215625)

You can't sleep in interrupt handlers in Linux because they are not backed by a thread of execution. In other words, they aren't schedulable entities.

Most systems break interrupt processing into two halves, commonly called a top half and a bottom half. The top half runs very quickly, interrupting (and in fact running as) whatever was executing when the interrupt occurred-the top half has no thread itself. Consequently, the top half is unable to sleep, as there isn't anything to schedule back into when the sleep completes.

