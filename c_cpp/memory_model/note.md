# Memory Model

- [Memory Model](#memory-model)
  - [atomic](#atomic)
    - [Sequentially Consistent](#sequentially-consistent)
    - [Relaxed](#relaxed)
    - [Acquire/Release](#acquirerelease)
    - [Consume](#consume)
  - [Sequenced Before](#sequenced-before)
  - [Happen Before](#happen-before)
  - [synchronizes with relation](#synchronizes-with-relation)
  - [References](#references)

## atomic

Hence the memory model was designed to disallow visible reordering of operations on the same atomic variable:

- All changes to a single atomic variable appear to occur in a single total modification order, specific to that variable. This is introduced in 1.10p5, and the last non-note sentence of 1.10p10 states that loads of that variable must be consistent with this modification order.

### Sequentially Consistent

- This is the default mode used when none is specified,

- and it is the most restrictive.

- It can also be explicitly specified via `std::memory_order_seq_cst`.

From a practical point of view, this amounts to all atomic operations acting as optimization barriers:

- Its OK to re-order things between atomic operations, but not across the operation.

- Thread local stuff is also unaffected since there is no visibility to other threads.

### Relaxed

- can be specified via `std::memory_order_relaxed`

- allows for much less synchronization by removing the happens-before restrictions

Without any happens-before edges:

- no thread can count on a specific ordering from another thread.

- The only ordering imposed is that once a value for a variable from thread 1 is observed in thread 2, thread 2 can not see an "earlier" value for that variable from thread 1.

There is also the presumption that relaxed stores from one thread are seen by relaxed loads in another thread within a reasonable amount of time.

- That means that on non-cache-coherent architectures, relaxed operations need to flush the cache (although these flushes can be merged across several relaxed operations)

The relaxed mode is most commonly used when the programmer simply wants an variable to be atomic in nature rather than using it to synchronize threads for other shared memory data.

### Acquire/Release

- is similar to the sequentially consistent mode, except it only applies a happens-before relationship to dependent variables

- The interactions of non-atomic variables are still the same. Any store before an atomic operation must be seen in other threads that synchronize

### Consume

- is a further subtle refinement in the release/acquire memory model that relaxes the requirements slightly by removing the happens before ordering on non-dependent shared variables as well.

## Sequenced Before

If `a` and `b` are performed by the same thread, and `a` "comes first", we say that `a` is sequenced before `b`

C++ allows a number of different evaluation orders for each thread, notably as a result of varying argument [evaluation order](https://en.cppreference.com/w/cpp/language/eval_order), and this choice may **vary each time** an expression is evaluated. Here we assume that each thread has already chosen its argument evaluation orders in some way, and we simply define which multi-threaded executions are consistent with this choice. Even then, there may be evaluations in the same thread, **neither one of which is sequenced before the other**. Thus **sequenced-before is only a partial order**, even when only the evaluations of a single thread are considered. But for the purposes of this discussion all of this can generally be ignored.

## Happen Before

The multi-threaded version of the sequenced-before relation.

If `a` happens before `b`, then `b` must see the effect of `a`, or the effects of a later action that hides the effects of `a`.

An evaluation `a` can happen before `b` either because they are executed in that order by a single thread, i.e `a` is sequenced before `b`, or because there is an intervening communication between the two threads that enforces ordering.

In general, an evaluation `a` **happens before** an evaluation `b` if they are ordered by a chain of **synchronizes with** and **sequenced-before** relationships.

## synchronizes with relation

A thread T1 normally **communicates with** a thread T2 by assigning to some shared variable `x` and then **synchronizing with** T2.

- Most commonly, this synchronization would involve T1 acquiring a lock while it updates `x`, and then T2 acquiring the same lock while it reads `x`. Certainly any assignment performed prior to releasing a lock should be visible to another thread when acquiring the lock.

- Atomic variables are another, less common, way to communicate between threads. Experience has shown that such variables are most useful if they have at least the same kind of **acquire-release semantics** as locks. In particular a **store** to an atomic variable **synchronizes with** a **load** that sees the written value. (The atomics library also normally guarantees additional ordering properties, as specified in [N2427](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2427.htm) and in chapter 29 the post-Kona C++ working paper. These are not addressed here, except that they are necessary to derive the [simpler rules for programmers](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2480.html#simpler) mentioned below.)

  Assignment to atomic variable has **release semantics**, while reference to atomic variable has **acquire semantics**. The pair **behaves essentially like a lock release and acquisition with respect to the memory model**.

## References

[Memory model synchronization modes](https://gcc.gnu.org/wiki/Atomic/GCCMM/AtomicSync)

[N2480: A Less Formal Explanation of the Proposed C++ Concurrency Memory Model](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2480.html)
