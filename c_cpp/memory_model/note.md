# Memory Model

- [Memory Model](#memory-model)
  - [c++ memory model synchronization modes](#c-memory-model-synchronization-modes)
    - [`std::memory_order_seq_cst`](#stdmemory_order_seq_cst)
    - [`std::memory_order_relaxed`](#stdmemory_order_relaxed)
    - [`std::memory_order_acquire/release/acq_rel`](#stdmemory_order_acquirereleaseacq_rel)
    - [`std::memory_order_consume`](#stdmemory_order_consume)
  - [atomic](#atomic)
    - [atomic variable](#atomic-variable)
    - [atomic operation](#atomic-operation)
    - [operations on the same atomic variable](#operations-on-the-same-atomic-variable)
  - [Sequentially Consistent](#sequentially-consistent)
  - [Sequenced Before](#sequenced-before)
  - [Happens-Before](#happens-before)
    - [The Common Definition of The Happens-Before Relation](#the-common-definition-of-the-happens-before-relation)
    - [Happens-Before Does Not Imply Happening Before](#happens-before-does-not-imply-happening-before)
    - [Happening Before Does Not Imply Happens-Before](#happening-before-does-not-imply-happens-before)
  - [synchronizes with relation](#synchronizes-with-relation)
    - [communication between threads](#communication-between-threads)
    - [synchronizes-with](#synchronizes-with)
  - [acquire/release semantics](#acquirerelease-semantics)
  - [processor reordering](#processor-reordering)
    - [four types of memory barrier](#four-types-of-memory-barrier)
      - [#LoadLoad](#loadload)
      - [#StoreStore](#storestore)
      - [#LoadStore`](#loadstore)
      - [#StoreLoad](#storeload)
  - [strong hardware memory model](#strong-hardware-memory-model)
  - [总结](#总结)
    - [内存排序](#内存排序)
    - [acquire / release 语义](#acquire--release-语义)
  - [References](#references)
    - [1. Memory model synchronization modes](#1-memory-model-synchronization-modes)
    - [2. N2480: A Less Formal Explanation of the Proposed C++ Concurrency Memory Model](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)
    - [3. An Introduction to Lock-Free Programming](#3-an-introduction-to-lock-free-programming)
    - [4. Acquire and Release Semantics](#4-acquire-and-release-semantics)
    - [5. Memory Barriers Are Like Source Control Operations](#5-memory-barriers-are-like-source-control-operations)
    - [6. The Synchronizes-With Relation](#6-the-synchronizes-with-relation)
    - [7. Atomic vs. Non-Atomic Operations](#7-atomic-vs-non-atomic-operations)
    - [8. The Happens-Before Relation](#8-the-happens-before-relation)
    - [9. Weak vs. Strong Memory Models](#9-weak-vs-strong-memory-models)
    - [10. Acquire and Release Fences](#10-acquire-and-release-fences)

## c++ memory model synchronization modes

### `std::memory_order_seq_cst`

This is the default mode used when none is specified, and it is the most restrictive. [[1]](#1-memory-model-synchronization-modes)

From a practical point of view, this amounts to all atomic operations acting as optimization barriers: [[1]](#1-memory-model-synchronization-modes)

- Its OK to re-order things between atomic operations, but not across the operation.

- Thread local stuff is also unaffected since there is no visibility to other threads.

### `std::memory_order_relaxed`

This model allows for much less synchronization by removing the happens-before restrictions. [[1]](#1-memory-model-synchronization-modes)

Without any happens-before edges:

- no thread can count on a specific ordering from another thread.

- The only ordering imposed is that once a value for a variable from thread 1 is observed in thread 2, thread 2 can not see an "earlier" value for that variable from thread 1. [[1]](#1-memory-model-synchronization-modes)

There is also the presumption that relaxed stores from one thread are seen by relaxed loads in another thread within a reasonable amount of time. [[1]](#1-memory-model-synchronization-modes)

- That means that on non-cache-coherent architectures, relaxed operations need to flush the cache (although these flushes can be merged across several relaxed operations)

The relaxed mode is most commonly used when the programmer simply wants an variable to be atomic in nature rather than using it to synchronize threads for other shared memory data. [[1]](#1-memory-model-synchronization-modes)

### `std::memory_order_acquire/release/acq_rel`

The third mode is a hybrid between the other two. The acquire/release mode is similar to the sequentially consistent mode, except it only applies a happens-before relationship to dependent variables. This allows for a relaxing of the synchronization required between independent reads of independent writes. [[1]](#1-memory-model-synchronization-modes)

The interactions of non-atomic variables are still the same. Any store before an atomic operation must be seen in other threads that synchronize. [[1]](#1-memory-model-synchronization-modes)

### `std::memory_order_consume`

`std:memory_order_consume` is a further subtle refinement in the release/acquire memory model that relaxes the requirements slightly by removing the happens before ordering on non-dependent shared variables as well.  [[1]](#1-memory-model-synchronization-modes)

## atomic

### atomic variable

Atomic variables are primarily used to synchronize shared memory accesses between threads. [[1]](#1-memory-model-synchronization-modes)

### atomic operation

A memory operation can be non-atomic even when performed by a single CPU instruction. [[7]](#7-atomic-vs-non-atomic-operations)

### operations on the same atomic variable

Hence the memory model was designed to disallow visible reordering of operations **on the same atomic variable**:

- All changes to a single atomic variable appear to occur in a single total modification order, specific to that variable. This is introduced in 1.10p5, and the last non-note sentence of 1.10p10 states that loads of that variable must be consistent with this modification order. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

## Sequentially Consistent

Sequential consistency means that all threads agree on the order in which memory operations occurred, and that order is consistent with the order of operations in the program source code. [[3]](#3-an-introduction-to-lock-free-programming)

## Sequenced Before

If `a` and `b` are performed by the same thread, and `a` "comes first", we say that `a` is sequenced before `b`. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

C++ allows a number of different evaluation orders for each thread, notably as a result of varying argument [evaluation order](https://en.cppreference.com/w/cpp/language/eval_order), and this choice may **vary each time** an expression is evaluated. Here we assume that each thread has already chosen its argument evaluation orders in some way, and we simply define which multi-threaded executions are consistent with this choice. Even then, there may be evaluations in the same thread, **neither one of which is sequenced before the other**. Thus **sequenced-before is only a partial order**, even when only the evaluations of a single thread are considered. But for the purposes of this discussion all of this can generally be ignored. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

## Happens-Before

The multi-threaded version of the sequenced-before relation. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

If `a` happens before `b`, then `b` must see the effect of `a`, or the effects of a later action that hides the effects of `a`. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

An evaluation `a` can happen before `b` either because they are executed in that order by a single thread, i.e `a` is **sequenced before** `b`, or because there is an **intervening communication** between the two threads that enforces ordering. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

### The Common Definition of The Happens-Before Relation

Let A and B represent operations performed by a multithreaded process. If A **happens-before** B, then the memory effects of A effectively become visible to the thread performing B before B is performed. [[8]](#8-the-happens-before-relation)

If operations A and B are performed by the same thread, and A's statement comes before B's statement in program order, then A happens-before B. [[8]](#8-the-happens-before-relation)

### Happens-Before Does Not Imply Happening Before

参考 [[8]](#8-the-happens-before-relation)

注: 这里的例子中的 Happens-Before 与 Happening Before 不一致是指令重排后源代码中的赋值顺序与编译后的指令的循序不一致导致的, 并且实际运行的指令的语义也与源码中的语义有差别, 最后的实际执行效果符合源码语义的 Happens-Before. 编译生的汇编码中的两条赋值语句实际上是解耦的, 即便发生运行时的乱序也不影响在本线程中的 Happens-Before.

### Happening Before Does Not Imply Happens-Before

The happens-before relationship only exists where the language standards say it exists. [[8]](#8-the-happens-before-relation)

## synchronizes with relation

### communication between threads

A thread T1 normally **communicates with** a thread T2 by assigning to some shared variable `x` and then synchronizing with T2. Most commonly, this synchronization would involve T1 acquiring a **lock** while it updates `x`, and then T2 acquiring the same lock while it reads `x`. Certainly any assignment performed prior to releasing a lock should be visible to another thread when acquiring the lock. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

We describe this in several stages: [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

1. Any side effect such as the assignment to `x` performed by a thread before it releases the lock, is sequenced before the lock release, and hence happens before it.

2. The lock release operation synchronizes with the next acquisition of the same lock. The synchronizes with relation expresses the actual ordering constraints imposed by synchronization operations.

3. The lock acquire operation is again sequenced before value computations such as the one that reads `x`.

In general, an evaluation `a` **happens before** an evaluation `b` if they are ordered by a chain of **synchronizes with** and **sequenced-before** relationships. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

Atomic variables are another, less common, way to communicate between threads. Experience has shown that such variables are most useful if they have at least the same kind of **acquire-release semantics** as locks. In particular a store to an atomic variable **synchronizes with** a load that sees the written value. [[2]](#2-n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)

### synchronizes-with

A release fence A **synchronizes with** an acquire fence B if there exist atomic operations X and Y, both operating on some atomic object M, such that A is **sequenced before** X, X modifies M, Y is **sequenced before** B, and Y reads the value written by X or a value written by **any side effect** in the hypothetical release sequence X would head if it were a release operation. [[10]](#10-acquire-and-release-fences)

We just need a way to **safely propagate modifications from one thread to another** once they're complete. That's where the **synchronizes-with** relation comes in. [[6]](#6-the-synchronizes-with-relation)

In every synchronizes-with relationship, you should be able to identify two key ingredients, which I like to call the **guard variable** and the **payload**. The payload is the set of data being propagated between threads, while the guard variable protects access to the payload. [[6]](#6-the-synchronizes-with-relation)

An atomic operation A that performs a release operation on an atomic object M **synchronizes with** an atomic operation B that performs an acquire operation on M and takes its value from **any side effect** in the release sequence headed by A. [[6]](#6-the-synchronizes-with-relation)

As for the condition that the read-acquire must "take its value from **any side effect**" – let's just say it's **sufficient** for the read-acquire to read the value written by the write-release. If that happens, the **synchronized-with** relationship is complete, and we've achieved the coveted **happens-before** relationship between threads. Some people like to call this a synchronize-with or happens-before "edge". [[6]](#6-the-synchronizes-with-relation)

Just as synchronizes-with is **not only way** to achieve a happens-before relationship, a pair of write-release/read-acquire operations is **not the only way** to achieve synchronizes-with; **nor are C++11 atomics the only way to achieve acquire and release semantics**. [[6]](#6-the-synchronizes-with-relation)

Unlocking a mutex always synchronizes-with a subsequent lock of that mutex. [[6]](#6-the-synchronizes-with-relation)

## acquire/release semantics

- **Acquire semantics** is a property that can only apply to operations that **read** from shared memory, whether they are [read-modify-write](http://preshing.com/20120612/an-introduction-to-lock-free-programming#atomic-rmw) operations or plain loads. The operation is then considered a **read-acquire**. Acquire semantics prevent memory **reordering** of the **read-acquire with any read or write** operation that **follows** it in program order. [[4]](#4-acquire-and-release-semantics)

- **Release semantics** is a property that can only apply to operations that **write** to shared memory, whether they are read-modify-write operations or plain stores. The operation is then considered a **write-release**. Release semantics prevent memory reordering of the **write-release with any read or write** operation that precedes it in program order. [[4]](#4-acquire-and-release-semantics)

Acquire and release semantics can be achieved using simple combinations of the memory barrier types as flow: [[4]](#4-acquire-and-release-semantics)

- Acquire semantics

  `#LoadLoad` + `#LoadStore` placed after the read-acquire operation

- Release semantics

  `#LoadStore` + `#StoreStore` placed before the write-acquire operation

注: 这里没有搞明白为什么需要 `#LoadStore`

The barriers must (somehow) be placed after the read-acquire operation, but before the write-release. [Update: Please note that these barriers are technically more strict than what’s required for acquire and release semantics on a single memory operation, but they do achieve the desired effect.] [[4]](#4-acquire-and-release-semantics)

These semantics are particularly suitable in cases when there's a producer/consumer relationship, where one thread publishes some information and the other reads it. [[3]](#3-an-introduction-to-lock-free-programming)

## processor reordering

Like compiler reordering, **processor reordering** is invisible to a single-threaded program. It only becomes apparent when [**lock-free** techniques](http://preshing.com/20120612/an-introduction-to-lock-free-programming) are used – that is, when shared memory is manipulated without any mutual exclusion between threads. However, unlike compiler reordering, the effects of processor reordering are [only visible in multicore and multiprocessor systems](http://preshing.com/20120515/memory-reordering-caught-in-the-act). [[5]](#5-memory-barriers-are-like-source-control-operations)

### four types of memory barrier

Each type of memory barrier is **named after the type of memory reordering it's designed to prevent**: for example, `#StoreLoad` is designed to prevent the reordering of a store followed by a load. [[5]](#5-memory-barriers-are-like-source-control-operations)

#### #LoadLoad

A LoadLoad barrier effectively prevents reordering of loads performed before the barrier with loads performed after the barrier. [[5]](#5-memory-barriers-are-like-source-control-operations)

#### #StoreStore

A StoreStore barrier effectively prevents reordering of stores performed before the barrier with stores performed after the barrier. [[5]](#5-memory-barriers-are-like-source-control-operations)

#### #LoadStore`

A LoadStore barrier effectively prevents reordering of loads performed before the barrier with stores performed after the barrier.

On a real CPU, instructions which act as a `#LoadStore` barrier typically act as at least one of `#LoadLoad` or `#StoreStore` barrier type. [[5]](#5-memory-barriers-are-like-source-control-operations)

#### #StoreLoad

A StoreLoad barrier ensures that all stores performed before the barrier are **visible to other processors**, and that all loads performed after the barrier receive the latest value that is visible at the time of the barrier. In other words, it effectively prevents reordering of all stores before the barrier against all loads after the barrier, respecting the way a [sequentially consistent](http://preshing.com/20120612/an-introduction-to-lock-free-programming#sequential-consistency) multiprocessor would perform those operations. [[5]](#5-memory-barriers-are-like-source-control-operations)

On most processors, instructions that act as a `#StoreLoad` barrier tend to be more expensive than instructions acting as the other barrier types. [[5]](#5-memory-barriers-are-like-source-control-operations)

[As Doug Lea also points out](http://g.oswego.edu/dl/jmm/cookbook.html), it just so happens that on all current processors, every instruction which acts as a `#StoreLoad` barrier also acts as a **full memory fence**. [[5]](#5-memory-barriers-are-like-source-control-operations)

## strong hardware memory model

strong hardware memory model definition:

- A strong hardware memory model is one in which every machine instruction comes implicitly with [acquire and release semantics](http://preshing.com/20120913/acquire-and-release-semantics). As a result, when one CPU core performs a sequence of writes, every other CPU core sees those values change in the same order that they were written. [[9]](#9-weak-vs-strong-memory-models)

Under the above definition, the x86/64 family of processors is usually strongly-ordered. There are certain cases in which some of x86/64's [strong ordering guarantees are lost](http://preshing.com/20120913/acquire-and-release-semantics#comment-20810), but for the most part, as application programmers, we can ignore those cases. [[9]](#9-weak-vs-strong-memory-models)

## 总结

### 内存排序

在多线程程序的执行过程中, 每一线程均可能对全局内存进行操作, 所有的这些操作构成一个集合 `S`.

- 对于一次程序执行, 每一线程均可在 `S` 上定义一个偏序, 该偏序关系来自两个方面:

  1. 发生于该线程的内存操作指令的实际执行顺序.

     该顺序可能与代码编译产生的指令顺序不一致, 并且每次程序运行, 该顺序可能发生变化. 可通过在内存操作指令间加入 memory barrier 的方式限定指令的执行顺序.

  2. 由该线程的内存操作结果可推断出的发生于其他线程的内存操作的顺序. 该顺序可能与实际所在的线程中的顺序不同.

- 对于分别执行于不同线程的内存操作, 可以通过线程间的同步([The Synchronizes-With Relation](https://preshing.com/20130823/the-synchronizes-with-relation/))定义偏序关系.

对于 sequentially consistent 内存模型, 每次程序执行, 所有线程所定义的偏序关系之间不存在矛盾.

### acquire / release 语义

- 可通过对 atomic 变量的 acquire 模式读获得 acquire 语义

- 可通过对 atomic 变量的 release 模式写获得 release 语义

- 也可通过 relaxed 模式操作 atomic 变量 + memory barrier 的方式获得 acquire / release 语义

- 可通过 acquire / release 语义获得两个线程的同步(the synchronizes-with relation)

- 可通过 synchronizes-with relation 获得跨线程的两个内存操作之间的 happens-before relation

- 可通过 sequenced-before relation 获得同一个线程执行的两个内存操作之间的 happens-before relation

## References

### 1. [Memory model synchronization modes](https://gcc.gnu.org/wiki/Atomic/GCCMM/AtomicSync)

### 2. [N2480: A Less Formal Explanation of the Proposed C++ Concurrency Memory Model](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2480.html)

### 3. [An Introduction to Lock-Free Programming](https://preshing.com/20120612/an-introduction-to-lock-free-programming/)

### 4. [Acquire and Release Semantics](https://preshing.com/20120913/acquire-and-release-semantics/)

### 5. [Memory Barriers Are Like Source Control Operations](https://preshing.com/20120710/memory-barriers-are-like-source-control-operations/)

### 6. [The Synchronizes-With Relation](https://preshing.com/20130823/the-synchronizes-with-relation/)

### 7. [Atomic vs. Non-Atomic Operations](https://preshing.com/20130618/atomic-vs-non-atomic-operations/)

### 8. [The Happens-Before Relation](https://preshing.com/20130702/the-happens-before-relation/)

### 9. [Weak vs. Strong Memory Models](https://preshing.com/20120930/weak-vs-strong-memory-models/)

### 10. [Acquire and Release Fences](https://preshing.com/20130922/acquire-and-release-fences/)
