# [Memory Ordering at Compile Time](https://preshing.com/20120625/memory-ordering-at-compile-time/)

- [Memory Ordering at Compile Time](#memory-ordering-at-compile-time)
  - [Compiler Instruction Reordering](#compiler-instruction-reordering)

Between the time you type in some C/C++ source code and the time it executes on a CPU, the memory interactions of that code may be reordered according to certain rules. **Changes to memory ordering are made both by the compiler (at compile time) and by the processor (at run time), all in the name of making your code run faster**.

The cardinal rule of memory reordering, which is universally followed by compiler developers and CPU vendors, could be phrased as follows:

Thou shalt not modify the behavior of a single-threaded program.

As a result of this rule, memory reordering goes largely unnoticed by programmers writing single-threaded code. It often goes unnoticed in multithreaded programming, too, since mutexes, semaphores and events are all designed to prevent memory reordering around their call sites. It’s only when lock-free techniques are used – when memory is shared between threads without any kind of mutual exclusion – that the cat is finally out of the bag, and the effects of memory reordering can be plainly observed.

Mind you, it is possible to write lock-free code for multicore platforms without the hassles of memory reordering. As I mentioned in my introduction to lock-free programming, one can take advantage of sequentially consistent types, such as volatile variables in Java or C++11 atomics – possibly at the price of a little performance. I won’t go into detail about those here. In this post, I’ll focus on the impact of the compiler on memory ordering for regular, non-sequentially-consistent types.

## Compiler Instruction Reordering
