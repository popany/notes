# [N2480: A Less Formal Explanation of the Proposed C++ Concurrency Memory Model](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2480.html)

- [N2480: A Less Formal Explanation of the Proposed C++ Concurrency Memory Model](#n2480-a-less-formal-explanation-of-the-proposed-c-concurrency-memory-model)
  - [Overview](#overview)
  - [Visibility of assignments](#visibility-of-assignments)
  - [The impact of unordered atomic operations](#the-impact-of-unordered-atomic-operations)
  - [Data races](#data-races)
  - [A note on the structure of 1.10](#a-note-on-the-structure-of-110)
  - [Simpler rules for programmers](#simpler-rules-for-programmers)

This is an attempt to informally explain the C++ memory model, as it was proposed in a sequence of committee papers ending with [WG21/N2429=J16/07-0299](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2429.htm), which was accepted into the working paper at the October 2007 meeting in Kona. This paper is purely informational. It was felt that it would be useful to have an update of WG21/N2138 that is consistent with the text actually accepted into the working paper. A very similar version of this paper was included in a prior C mailing as WG14/N1276. It is probably useful to refer to [N2429](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2429.htm) or section 1.10 of the post-Kona working paper ([N2462](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2461.pdf)) while reading this document.

## Overview

The meaning of a multi-threaded program is effectively given in two stages:

1. We explain when a particular value computation (effectively load of an object) can yield or "see" the value stored by a particular assignment to the object. This effectively defines what it means to run multiple threads concurrently, if we already understand the behavior of the individual threads. However, as discussed below, it also gives meaning to programs we would rather disallow.

2. We define (in 1.10p11) when, based on the definition from the preceding step, a program contains a data race (on a particular input). We then explicitly give such a program (on that input) undefined semantics.

If we omitted the last step, we would, for example, guarantee that if we have

    long long x = 0;

then the following program:

    Thread1    Thread2
    x = -1;    r1 = x;

could never result in the local variable `r1` being assigned a variable other than `0` or `-1`. In fact, it is likely that on a 32-bit machine, the assignment of `-1` would require two separate store instructions, and thread 2 might see the intermediate value. And it is often expensive to prevent such outcomes.

The preceding example is only one of many cases in which attempting to fully define the semantics of programs with data races would severely constrain the implementation. By prohibiting conflicting concurrent accesses, we remain consistent with pthread practice. We allow nearly all conventional compiler transformations on synchronization-free code, since we disallow any program that could detect invalid intermediate states introduced in the process.

Disallowing data races also has some more subtle and C++-specific consequences. In particular, when constructing an object with a virtual function table, we do not need to generate code that guards against another thread "seeing" the object with an uninitialized pointer to the table. Doing so would often require inserting expensive memory fence instructions. With our approach, no other thread can access the object and virtual function table pointer without either using sufficient synchronization to ensure that the correct function table pointer is visible, or introducing a data race.

We will assume that **each thread performs a sequence of evaluations in a known order**, described by a **sequenced-before relation**, as described in [N2239](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2239.htm), which was previously accepted into the C++ working paper. If `a` and `b` are performed by the same thread, and `a` "comes first", we say that `a` is sequenced before `b`.

(**C++ allows a number of different evaluation orders for each thread**, notably as a result of varying argument evaluation order, and **this choice may vary each time an expression is evaluated**. Here we assume that each thread **has already chosen** its argument evaluation orders in some way, and we simply define which multi-threaded executions are consistent with this choice. Even then, there may be evaluations in the same thread, neither one of which is sequenced before the other. Thus **sequenced-before is only a partial order**, even when only the evaluations of a single thread are considered. But for the purposes of this discussion all of this can generally be ignored.)

## Visibility of assignments

Consider a simple sequence of assignments to scalar variables that is sequentially executed, i.e. for every pair of distinct assignments, one is sequenced before the other. A value computation `b` that references `x` "sees" a previous assignment `a` to `x` if `a` is the last prior assignment to `x`, i.e. if

- `a` is not sequenced after `b`, and if

- There is no intervening assignment `m` to `x` such that `a` is sequenced before `m` and `m` is sequenced before `b`.

We phrased this second, more precise, formulation to also make sense if not all of the assignments are ordered, as with multiple threads, though in that case `b` might be able to see the effect of more than one possible `a`. If we very informally consider the (pseudo-code, not C++) program

    x = 1;

    x = 2;

    in parallel do

        Thread 1: x = 3;

        Thread 2: r1 = x;

The reference to `x` in thread 2 may "see" either a value of `2` or `3`, since in each case the corresponding assignment is not required to be executed after the assignment to `r1`, and there is no other intervening assignment to `x`. Thread 2 may not see the value of `1`, since the assignment `x = 2;` intervenes.

Thus our goal is essentially to define **the multi-threaded version of the sequenced-before relation**. We call this relation **happens-before**. (This is based on the terminology introduced for distributed systems in Lamport, "Time, Clocks and the Ordering Events in a Distributed System", CACM 21, 7 (July 1978).) As with sequenced-before in the single-threaded case, if `a` happens before `b`, then `b` must see the effect of `a`, or the effects of a later action that hides the effects of `a`. Similarly if `a` and `b` assign to the same object, later observers must consistently see an outcome reflecting the fact that a was performed first.

An evaluation `a` can **happen before** `b` either because they are executed in that order by a single thread, i.e `a` is sequenced before `b`, or because there is an intervening communication between the two threads that enforces ordering.

A thread T1 normally communicates with a thread T2 by assigning to some shared variable `x` and then synchronizing with T2. Most commonly, this synchronization would involve T1 acquiring a lock while it updates `x`, and then T2 acquiring the same lock while it reads `x`. Certainly any assignment performed prior to releasing a lock should be visible to another thread when acquiring the lock.

We describe this in several stages:

1. Any side effect such as the assignment to `x` performed by a thread before it releases the lock, is **sequenced before** the lock release, and hence **happens before** it.

2. The lock release operation **synchronizes with** the next acquisition of the same lock. The **synchronizes with relation** expresses the actual **ordering constraints** imposed by synchronization operations.

3. The lock acquire operation is again sequenced before value computations such as the one that reads `x`.

In general, an evaluation `a` happens before an evaluation `b` if they are ordered by a chain of synchronizes with and sequenced-before relationships. More formally happens-before is the transitive closure of the union of the synchronizes-with and happens-before relationships (1.10p8).

So far our discussion has been in terms of threads that communicate via lock-protected accesses to shared variables. This should indeed be the common case. But it is not the only case we wish to support.

Atomic variables are another, less common, way to communicate between threads. Experience has shown that such variables are most useful if they have at least the same kind of acquire-release semantics as locks. In particular a **store** to an atomic variable **synchronizes with** a **load** that sees the written value. (The atomics library also normally guarantees additional ordering properties, as specified in [N2427](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2427.htm) and in chapter 29 the post-Kona C++ working paper. These are not addressed here, except that they are necessary to derive the [simpler rules for programmers](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2480.html#simpler) mentioned below.)

If atomic variables have acquire/release properties, then we can ensure that the following code does not result in an assertion failure.

    int x = 0;

    atomic_int y = 0;

    in parallel do

        Thread 1: x = 17; y.store(1);

        Thread 2: while (!y.load()); assert(x == 17);

In this case, the assignment to `y` has **release semantics**, while the reference to `y` in the while condition has **acquire semantics**. The pair **behaves essentially like a lock release and acquisition with respect to the memory model**. The assignment `x = 17` is sequenced before the release operation `y.store(1)`. The release operation synchronizes with the last evaluation of the while condition, which is an acquire operation and loads the value stored by `y.store(1)`. Thus the assignment `x = 17` happens-before the evaluation of x in the assertion, and hence the assertion cannot fail, since the initialization of `x` to zero is no longer visible.

Once we have defined our happens-before ordering in this way, we largely define visibility as in the sequential case:

1. Each read must see a write that does not happen after it, and

2. there must be no intervening second write between the write and the read.

This condition is expressed in 1.10p9 and 1.10p10, for **ordinary memory operations**, and for **operations on atomics**, respectively.

For ordinary memory operations, we strengthen the first condition to require that the write actually happen before the read, as opposed to insisting only that it not happen after it. It is certainly possible that there is no happens-before ordering between the read and the write, in which case these statements are not the same. However, in this case, we have a data race, and we leave the meaning of the program undefined in either case. Thus the distinction does not matter; **without data races, an ordinary read must always see a write that happens before it**, and there must be a unique such write that also satisfies the second condition. 1.10p9 refers to this unique write as the **visible side effect**.

For atomic operations, things are somewhat different. For example, if an atomic variable is initialized to zero, and then has the value 1 assigned to it by one thread while another thread reads it, the reader may see either the initializing write or the write of the value 1 by the other thread. In general, it may see any write "between" the last one that happens before the read, and the first one that happens after the read (inclusively in the former case, and exclusively in the latter.) This is defined by 1.10p10 as the **visible sequence**.

## The impact of unordered atomic operations

Our memory model proposal differs from the Java one (see Manson, Pugh, Adve [The Java Memory Model](http://doi.acm.org/10.1145/1040305.1040336) or [the authors' expanded version](http://www.cs.umd.edu/users/jmanson/java/journal.pdf)) in that we completely disallow data races, as opposed to merely discouraging them. However, there are some cases in which some performance can be gained by allowing concurrent unsynchronized access to shared variables, without enforcing loads to be acquire operations, and stores to be release operations. This is particularly true, since

- Enforcing the kind of visibility constraints implied by **synchronizes-with** relationships commonly requires the compiler to insert relatively expensive "memory fence" instructions.

- Existing software often manually provides the necessary fence instructions in a platform-dependent way. It is easier to convert such software if we provide atomic operations that do not provide potentially redundant ordering properties.

The atomics library provides these unordered (called "relaxed") operations via functions on atomic objects with an explicit memory ordering argument. If `x` has atomic type, it can be read or written respectively with

    x.load(memory_order_relaxed);
    x.store(something, memory_order_relaxed);

The atomics library also allows other kinds of finely distinguished explicit ordering constraints. But they are not essential for the present discussion, and we only touch on them briefly below.

Note that it is quite difficult to use such operations correctly, and incorrect use is likely to result in very intermittent failures that are at best hard to test for, and at worst may only be visible on future implementations of a particular architecture. **These operations are intended for particularly performance sensitive and carefully written code, and should otherwise be avoided**.

In particular, if we rewrite the above example with relaxed atomics:

    int x = 0;

    atomic_int y = 0;

    in parallel do

        Thread 1: x = 17; y.store(1, memory_order_relaxed);

        Thread 2: while (!y.load(memory_order_relaxed)); assert(x == 17);

it now becomes entirely possible for the assertion to fail. The fact that the atomic load "sees" the value written by the atomic store no longer provides a **synchronizes-with** or **happens-before** ordering; hence there is no longer a guarantee that the assignment of `17` to `x` becomes visible before the assertion. For example, it is now perfectly legitimate for a compiler to treat the stores to `x` and `y` as independent and reorder them, or for a hardware write buffer to do the same.
So far, we have sufficiently few constraints on the behavior of relaxed atomics to allow even more counterintuitive behavior. Consider this example involving only a single atomic variable:

    Thread1                              Thread2
    x.store(1, memory_order_relaxed);    r1 = x.load(memory_order_relaxed);
    x.store(2, memory_order_relaxed);    r2 = x.load(memory_order_relaxed);

There is nothing in our current rules that prevents either store to be independently visible to either load. In particular `r1 = 2` and `r2 = 1` would be a perfectly acceptable outcome. In fact if thread 2 were to read `x` in a loop, it could **see an arbitrarily long sequence of alternating 1 and 2 values**.

Most hardware does not even allow this behavior at the machine level. Far more importantly, it was felt that, even in relation to the other surprising behaviors allowed by **relaxed** atomics, this is too unexpected to be directly usable by programmers. For example, a shared counter that was only ever modified via atomic increments in one thread could appear to decrease in another thread.

Hence **the memory model was designed to disallow visible reordering of operations on the same atomic variable**. This is expressed via another set of ordering relations. All changes to a single atomic variable appear to occur in a single total modification order, specific to that variable. This is introduced in 1.10p5, and the last non-note sentence of 1.10p10 states that loads of that variable must be consistent with this modification order.

Hence in the above example, one of the stores to x must come first in the modification order, and once the second store is seen by a load, the value stored by the first may not be seen again. Hence `r1 = 2` and `r2 = 1` is no longer possible.

Once we have used this notion of a modification sequence, it can be used to address another issue. Consider the following example (due to Peter Dimov, along with some of the other observations here). This uses an explicit `memory_order_release` specification to indicate that a `fetch_add` operation has only release semantics associated with the `store`, but no acquire semantics associated with the `load` part. Like `memory_order_relaxed` this is often risky but may provide significantly improved performance. (It also relaxes some other less relevant guarantees provided by the atomics library.)

Assume that `v` is `atomic`, and both `x` and `v` are initially zero.

    Thread1                                  Thread2                                  Thread3
    x = 1;                                   y = 1;                                   r1 = v.load();
    v.fetch_add(1, memory_order_relaxed);    v.fetch_add(1, memory_order_relaxed);    if (r1 == 2) assert(x == 1 && y == 1);

As we have described it so far, the memory model allows the assertion to fail. The problem is that only one of the `fetch_add()` operations writes the value seen by the `load()`, and hence synchronizes with it. Hence only one of the assignments to `x` and `y` is guaranteed to happen before the assertion.

Of course, this would not be an issue if the `fetch_add()` specified either `memory_order_acq_rel` or the default `memory_order_seq_cst`. In both cases `fetch_add()` would have both acquire and release semantics, and the first (in modification order, would synchronize with the second, which would synchronize with the `load()`, ensuring that both assignments happen before the assertion.

However, even in the presence of memory_order_release, an assertion failure here both seems strange, and is in fact not allowed by natural implementations on common hardware. An alternative would be to say that a store with release semantics synchronizes with a load with acquire semantics, not only if the load "sees" the stored value, but also if it "sees" the value stored by a later modification.

It turns out that this adjustment is not compatible with some common hardware. Hence we actually use a definition part-way between those two. In 1.10p6, we define a release sequence to consist of only certain modifications following a release store, namely those that are atomic read-modify-write operations with stronger than relaxed ordering, or that are later updates (to the same atomic) performed by the same thread as the original update.

A load must see an update performed by one of the updates in the release sequence in order for the initial store to synchronize with the load. This is a **compromise** that both allows efficient implementation on common hardware, and appears to guarantee the expected outcome for examples like the above.

## Data races

The above definitions tell us which assignments to scalar objects can be seen by particular value computations. Hence they tell us how threads interact and, together with the single threaded semantics already in the standard, give us a basic multi-threaded semantics. This semantics is used in the following two ways:

- It helps us to define when the execution of a program encounters a **data race**.

- It defines the semantics of **data-race-free** programs.

For reasons illustrated [previously](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2480.html#long_write_example), it does not define the semantics of programs with data races.

There are several possible definitions of a data race. Probably the most intuitive definition is that it occurs when two ordinary accesses to a scalar, at least one of which is a write, are performed simultaneously by different threads. Our definition is actually quite close to this, but varies in two ways:

1. Instead of restricting simultaneous execution, we ask that conflicting accesses by different threads be ordered by happens-before. This is equivalent in simpler cases, but the definition based on simultaneous execution would be inappropriate for weakly ordered atomics. See [N2338](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2338.html) for details. (They are also not equivalent in the presence of `pthread_mutex_trylock()` as currently defined. See [Boehm, Reordering Constraints for Pthread-Style Locks](http://www.hpl.hp.com/techreports/2005/HPL-2005-217R1.html) for details. This is addressed in the C++ threads API by allowing the analogous call to fail "spuriously" even if the lock is available. This is also addressed in N2338.)

2. We have to accommodate the fact that updates to bit-fields are normally implemented by loading and storing back groups of adjacent bit-fields. Thus a store to a bit-field may conflict with a concurrent store to an adjacent bit-field by another thread. If they overlap, one of the updates may be lost. This is reflected in the definition by defining data races in terms of abstract memory locations which include entire sequences of adjacent bit-fields, instead of just scalar objects. (1.7p3)

## A note on the structure of 1.10

The astute reader will notice that the definitions of 1.10 are circular. We define visible sequences based on the happens-before relation, which is defined in terms of the synchronizes-with relation, which is determined by the values seen by atomic loads, the possibilities for which are given by the visible sequences.
If we were to state this more mathematically, as opposed to in "standardese", this would be expressed as an existential quantification over the values seen by atomic loads, and over modification orders.

A particular program behavior is allowed by the standard if there exists an association of a store to each load, reflecting the value observed by each load, and total orders of all the modifications to each atomic variable such that

- The association of stores to loads, and the corresponding values seen by the loads, gives rise to the observed behavior of the program, and

- The resulting happens-before relation and visible sequences allow this association of stores to loads, i.e. each of the stores in the resulting visible sequence of the corresponding load.

## Simpler rules for programmers

Based on this definition, as shown in [N2338](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2338.html), it becomes a theorem that programs using locks and atomic variables with default ("sequentially consistent") ordering to protect other shared variables from simultaneous access (other than simultaneous read access) behave as though they were executed by simply interleaving the actions of each thread. We expect that this is the rule that will be taught to most programmers.
