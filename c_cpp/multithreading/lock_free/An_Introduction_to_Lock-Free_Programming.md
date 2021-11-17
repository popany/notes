# [An Introduction to Lock-Free Programming](https://preshing.com/20120612/an-introduction-to-lock-free-programming/)

- [An Introduction to Lock-Free Programming](#an-introduction-to-lock-free-programming)
  - [What Is It?](#what-is-it)
  - [Lock-Free Programming Techniques](#lock-free-programming-techniques)

Lock-free programming is a challenge, not just because of the complexity of the task itself, but because of how difficult it can be to penetrate the subject in the first place.

I was fortunate in that my first introduction to lock-free (also known as lockless) programming was Bruce Dawson’s excellent and comprehensive white paper, [Lockless Programming Considerations](http://msdn.microsoft.com/en-us/library/windows/desktop/ee418650(v=vs.85).aspx). And like many, I’ve had the occasion to put Bruce’s advice into practice developing and debugging lock-free code on platforms such as the Xbox 360.

Since then, a lot of good material has been written, ranging from abstract theory and proofs of correctness to practical examples and hardware details. I'll leave a list of references in the footnotes. At times, the information in one source may appear orthogonal to other sources: For instance, some material assumes [sequential consistency](http://en.wikipedia.org/wiki/Sequential_consistency), and thus sidesteps the memory ordering issues which typically plague lock-free C/C++ code. The new [C++11 atomic library standard](http://en.cppreference.com/w/cpp/atomic) throws another wrench into the works, challenging the way many of us express lock-free algorithms.

In this post, I'd like to re-introduce lock-free programming, first by defining it, then by distilling most of the information down to a few key concepts. I'll show how those concepts relate to one another using flowcharts, then we'll dip our toes into the details a little bit. At a minimum, any programmer who dives into lock-free programming should already understand how to write correct multithreaded code using mutexes, and other high-level synchronization objects such as semaphores and events.

## What Is It?

People often describe lock-free programming as programming without mutexes, which are also referred to as [locks](http://preshing.com/20111118/locks-arent-slow-lock-contention-is). That's true, but it’s only part of the story. The generally accepted definition, based on academic literature, is a bit more broad. At its essence, **lock-free is a property used to describe some code**, without saying too much about how that code was actually written.

Basically, if some part of your program satisfies the following conditions, then that part can rightfully be considered lock-free. Conversely, if a given part of your code doesn’t satisfy these conditions, then that part is not lock-free.

![fig1](./fig/An_Introduction_to_Lock-Free_Programming/its-lock-free.png)

In this sense, the **lock** in lock-free does not refer directly to **mutexes**, but rather to the possibility of "locking up" the entire application in some way, whether it's deadlock, livelock – or even due to hypothetical thread scheduling decisions made by your worst enemy. That last point sounds funny, but it's key. Shared mutexes are ruled out trivially, because as soon as one thread obtains the mutex, your worst enemy could simply never schedule that thread again. Of course, real operating systems don't work that way – we're merely defining terms.

Here's a simple example of an operation which contains no mutexes, but is still not lock-free. Initially, X = 0. As an exercise for the reader, consider how two threads could be scheduled in a way such that neither thread exits the loop.

    while (X == 0)
    {
        X = 1 - X;
    }

Nobody expects a large application to be entirely lock-free. Typically, we identify a specific set of lock-free operations out of the whole codebase. For example, in a lock-free queue, there might be a handful of lock-free operations such as push, pop, perhaps isEmpty, and so on.

Herlihy & Shavit, authors of The Art of Multiprocessor Programming, tend to express such operations as class methods, and offer the following succinct definition of lock-free (see slide 150): “In an infinite execution, infinitely often some method call finishes.” In other words, as long as the program is able to keep calling those lock-free operations, the number of completed calls keeps increasing, no matter what. It is algorithmically impossible for the system to lock up during those operations.

One important consequence of lock-free programming is that if you suspend a single thread, it will never prevent other threads from making progress, as a group, through their own lock-free operations. This hints at the value of lock-free programming when writing interrupt handlers and real-time systems, where certain tasks must complete within a certain time limit, no matter what state the rest of the program is in.

A final precision: Operations that are designed to block do not disqualify the algorithm. For example, a queue’s pop operation may intentionally block when the queue is empty. The remaining codepaths can still be considered lock-free.

## Lock-Free Programming Techniques






