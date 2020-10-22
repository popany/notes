# [Same-threading](http://tutorials.jenkov.com/java-concurrency/same-threading.html)

- [Same-threading](#same-threading)
  - [Why Single-threaded Systems?](#why-single-threaded-systems)
  - [Same-threading: Single-threading Scaled Out](#same-threading-single-threading-scaled-out)
    - [One Thread Per CPU](#one-thread-per-cpu)
  - [No Shared State](#no-shared-state)

Same-threading is a **concurrency model** where a single-threaded systems are scaled out to N single-threaded systems. The result is N single-threaded systems running in parallel.

A **same-threaded system** is not a purely **single-threaded system**, because it contains of multiple threads. But - each of the threads run like a single-threaded system. Hence the term same-threaded instead of single-threaded.

## Why Single-threaded Systems?

You might be wondering why anyone would design single-threaded system today. Single-threaded systems have gained popularity because their concurrency models are **much simpler** than **multi-threaded systems**. Single-threaded systems do not share any state (objects / data) with other threads. This enables the single thread to use non-concurrent data structures, and utilize the CPU and CPU caches better.

Unfortunately, single-threaded systems do **not fully utilize modern CPUs**. A modern CPU often comes with 2, 4, 6, 8 more cores. Each core functions as an individual CPU. A single-threaded system can only utilize one of the cores, as illustrated here:

![fig0](./fig/Same-threading/same-threading-0.png)

## Same-threading: Single-threading Scaled Out

In order to utilize all the cores in the CPU, a single-threaded system can be scaled out to utilize the whole computer.

### One Thread Per CPU

Same-threaded systems usually has **1 thread running per CPU** in the computer. If a computer contains 4 CPUs, or a CPU with 4 cores, then it would be normal to run 4 instances of the same-threaded system (4 single-threaded systems). The illustration below shows this principle:

![fig0-1](./fig/Same-threading/same-threading-0-1.png)

## No Shared State

A same-threaded system looks similar to a traditional multi-threaded system, since a same-threaded system has multiple threads running inside it. But there is a subtle difference.

The difference between a same-threaded and a traditional multi-threaded system is that the threads in a same-threaded system **do not share state**. There is no shared memory which the threads access concurrently. No concurrent data structures etc. via which the threads share data. This difference is illustrated here:

![fig4](./fig/Same-threading/same-threading-4.png)

The lack of shared state is what makes each thread behave as it if was a single-threaded system. However, since a same-threaded system can contain more than a single thread - it is not really a "single-threaded system". In lack of a better name, I found it more precise to call such a system a same-threaded system, rather than a "multi-threaded system with a single-threaded design". Same-threaded is easier to say, and easier to understand.

Same-threaded basically means that data processing stays within the same thread, and that no threads in a same-threaded system share data concurrently. Sometimes this is also referred to just as no shared state concurrency, or separate state concurrency.








TODO java