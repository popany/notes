# Linux Scheduling

- [Linux Scheduling](#linux-scheduling)
  - [Resources](#resources)
  - [Commands](#commands)
  - [Q & A](#q--a)
    - [Which real-time priority is the highest priority in Linux](#which-real-time-priority-is-the-highest-priority-in-linux)

## Resources

[Linux Scheduling](http://web.cse.ohio-state.edu/~champion.17/2431/04-SchedulingLinux.pdf)

[kernel.org - Linux Scheduler](https://www.kernel.org/doc/html/latest/scheduler/index.html)

## Commands

[`nice`](https://man7.org/linux/man-pages/man1/nice.1.html)

[`renice`](https://man7.org/linux/man-pages/man1/renice.1.html)

[`chrt`](https://man7.org/linux/man-pages/man1/chrt.1.html)

## Q & A

### [Which real-time priority is the highest priority in Linux](https://stackoverflow.com/a/52501811)

PR is the priority level (**range -100 to 39**). The lower the PR, the higher the priority of the process will be.

PR is calculated as follows:

- for normal processes: PR = 20 + NI (NI is nice and ranges from -20 to 19)

- for real time processes: PR = - 1 - real_time_priority (real_time_priority ranges from 1 to 99)

There are 2 types of processes, the normal ones and the real time For the normal ones (and only for those), nice is applied as follows:

- Nice

  The "niceness" scale goes from -20 to 19, whereas -20 it's the highest priority and 19 the lowest priority. The priority level is calculated as follows:

  - PR = 20 + NI

    Where NI is the nice level and PR is the priority level. So as we can see, the **-20 actually maps to 0**, while the **19 maps to 39**.

    By default, a program nice value is 0 bit it is possible for a root user to lunch programs with a specified nice value by using the following command:

        nice -n <nice_value> ./myProgram 

- Real Time

  We could go even further. The nice priority is actually used for user programs. Whereas the UNIX/LINUX overall priority has a range of 140 values, nice value enables the process to map to the last part of the range (from 100 to 139). This equation leaves the values from 0 to 99 unreachable which will correspond to a negative PR level (from -100 to -1). To be able to access to those values, the process should be stated as **"real time"**.

  There are 5 scheduling policies in a LINUX environment that can be displayed with the following command:

      chrt -m 

  Which will show the following list:

      1. SCHED_OTHER   the standard round-robin time-sharing policy
      2. SCHED_BATCH   for "batch" style execution of processes
      3. SCHED_IDLE    for running very low priority background jobs.
      4. SCHED_FIFO    a first-in, first-out policy
      5. SCHED_RR      a round-robin policy

  The scheduling processes could be divided into 2 groups, the normal scheduling policies (1 to 3) and the real time scheduling policies (4 and 5). The real time processes will always have priority over normal processes. A real time process could be called using the following command (The example is how to declare a SCHED_RR policy):

      chrt --rr <priority between 1-99> ./myProgram

  To obtain the PR value for a real time process the following equation is applied:

  PR = -1 - rt_prior

  Where rt_prior corresponds to the priority between 1 and 99. For that reason the process which will have the higher priority over other processes will be the one called with the number 99.

  It is important to note that for real time processes, the nice value is not used.











