# [The Happens-Before Relation](https://preshing.com/20130702/the-happens-before-relation/)

- [The Happens-Before Relation](#the-happens-before-relation)
  - [Happens-Before Does Not Imply Happening Before](#happens-before-does-not-imply-happening-before)

Happens-before is a modern computer science term which is instrumental in describing the [software memory models](http://preshing.com/20120930/weak-vs-strong-memory-models) behind C++11, Java, Go and even LLVM.

You'll find a definition of the happens-before relation in the specifications of each of the above languages. Conveniently, the definitions given in those specifications are basically the same, though each specification has a different way of saying it. Roughly speaking, the common definition can be stated as follows:

Let A and B represent operations performed by a multithreaded process. If A **happens-before** B, then the memory effects of A effectively become visible to the thread performing B before B is performed.

When you consider the various ways in which memory reordering [can complicate](http://preshing.com/20120515/memory-reordering-caught-in-the-act) lock-free programming, the guarantee that A happens-before B is a desirable one. **There are several ways to obtain this guarantee**, differing slightly from one programming language to next – though obviously, **all languages must rely on the same mechanisms at the processor level**.

No matter which programming language you use, they all have one thing in common: **If operations A and B are performed by the same thread, and A's statement comes before B's statement in program order, then A happens-before B**. This is basically a formalization of the "cardinal rule of memory ordering" I [mentioned in an earlier post](http://preshing.com/20120625/memory-ordering-at-compile-time).

    int A, B;

    void foo()
    {
        // This store to A ...
        A = 5;

        // ... effectively becomes visible before the following loads. Duh!
        B = A * A;
    }

That's not the only way to achieve a happens-before relation. The C++11 standard states that, among other methods, you also can achieve it between operations in different threads using [acquire and release semantics](http://preshing.com/20120913/acquire-and-release-semantics). I'll talk about that more in the next post about [synchronizes-with](http://preshing.com/20130823/the-synchronizes-with-relation).

I’m pretty sure that the name of this relation may lead to confusion for some. It’s worth clearing up right away: The happens-before relation, under the definition given above, is not the same as A actually happening before B! In particular,

A happens-before B does not imply A happening before B.
A happening before B does not imply A happens-before B.
These statements might appear paradoxical, but they’re not. I’ll try to explain them in the following sections. Remember, happens-before is a formal relation between operations, defined by a family of language specifications; it exists independently of the concept of time. This is different from what we usually mean when we say that “A happens before B”; referring the order, in time, of real-world events. Throughout this post, I’ve been careful to always hyphenate the former term happens-before, in order to distinguish it from the latter.

## Happens-Before Does Not Imply Happening Before






