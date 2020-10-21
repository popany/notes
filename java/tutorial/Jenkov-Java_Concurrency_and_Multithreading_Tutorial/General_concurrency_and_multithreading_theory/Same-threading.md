# [Same-threading](http://tutorials.jenkov.com/java-concurrency/same-threading.html)

- [Same-threading](#same-threading)
  - [Why Single-threaded Systems?](#why-single-threaded-systems)

Same-threading is a **concurrency model** where a single-threaded systems are scaled out to N single-threaded systems. The result is N single-threaded systems running in parallel.

A **same-threaded system** is not a purely **single-threaded system**, because it contains of multiple threads. But - each of the threads run like a single-threaded system. Hence the term same-threaded instead of single-threaded.

## Why Single-threaded Systems?

You might be wondering why anyone would design single-threaded system today. Single-threaded systems have gained popularity because their concurrency models are **much simpler** than **multi-threaded systems**. Single-threaded systems do not share any state (objects / data) with other threads. This enables the single thread to use non-concurrent data structures, and utilize the CPU and CPU caches better.

Unfortunately, single-threaded systems do **not fully utilize modern CPUs**. A modern CPU often comes with 2, 4, 6, 8 more cores. Each core functions as an individual CPU. A single-threaded system can only utilize one of the cores, as illustrated here:



