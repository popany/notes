# [Concurrency: Atomic and volatile in C++11 memory model](https://stackoverflow.com/questions/8819095/concurrency-atomic-and-volatile-in-c11-memory-model)

- [Concurrency: Atomic and volatile in C++11 memory model](#concurrency-atomic-and-volatile-in-c11-memory-model)

Firstly, `volatile` does not imply atomic access. It is **designed for things like memory mapped I/O and signal handling**. `volatile` is completely unnecessary when used with `std::atomic`, and unless your platform documents otherwise, `volatile` has no bearing on **atomic access** or **memory ordering** between threads.

If you have a global variable which is shared between threads, such as:

    std::atomic<int> ai;

then the **visibility** and **ordering constraints** depend on the **memory ordering parameter** you use for operations, and the **synchronization effects** of locks, threads and accesses to other atomic variables.

In the absence of any additional synchronization, if one thread writes a value to `ai` then there is nothing that guarantees that another thread will see the value in any given time period. The standard specifies that it should be visible "in a reasonable period of time", but any given access may return a stale value.

The default memory ordering of `std::memory_order_seq_cst` provides a single global total order for all `std::memory_order_seq_cst` operations across all variables. This doesn't mean that you can't get stale values, but it does mean that the value you do get determines and is determined by where in this **total order** your operation lies.

If you have 2 shared variables `x` and `y`, initially zero, and have one thread write `1` to `x` and another write `2` to `y`, then a third thread that reads both may see either `(0,0)`, `(1,0)`, `(0,2)` or `(1,2)` since there is **no ordering constraint** between the operations, and thus the operations may appear in any order in the **global order**.

If both writes are from the same thread, which does `x=1` before `y=2` and the reading thread reads `y` before `x` then `(0,2)` is no longer a valid option, since the read of `y==2` implies that the earlier write to `x` is visible. The other 3 pairings `(0,0)`, `(1,0)` and `(1,2)` are still possible, depending how the 2 reads **interleave with** the 2 writes.

If you use other memory orderings such as `std::memory_order_relaxed` or `std::memory_order_acquire` then the constraints are relaxed even further, and the **single global ordering no longer applies**. Threads don't even necessarily have to agree on the ordering of two stores to separate variables if there is no additional synchronization.

**The only way to guarantee you have the "latest" value** is to use a read-modify-write operation such as `exchange()`, `compare_exchange_strong()` or `fetch_add()`. Read-modify-write operations have an additional constraint that they always operate on the "latest" value, so a sequence of `ai.fetch_add(1)` operations by a series of threads will return a sequence of values with no duplicates or gaps. **In the absence of additional constraints, there's still no guarantee which threads will see which values though**.

Working with atomic operations is a complex topic. I suggest you read a lot of background material, and examine published code before writing production code with atomics. In most cases it is easier to write code that uses locks, and not noticeably less efficient.
