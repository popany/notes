# [Memory model](https://en.cppreference.com/w/cpp/language/memory_model#Threads_and_data_races)

- [Memory model](#memory-model)
  - [Byte](#byte)
  - [Memory location](#memory-location)
  - [Threads and data races](#threads-and-data-races)
  - [Memory order](#memory-order)
  - [Forward progress](#forward-progress)
    - [Obstruction freedom](#obstruction-freedom)
    - [Lock freedom](#lock-freedom)
    - [Progress guarantee](#progress-guarantee)

## Byte

A byte is the smallest addressable unit of memory.

## Memory location

A memory location is

- an object of [scalar type](https://en.cppreference.com/w/cpp/language/type) (arithmetic type, pointer type, enumeration type, or std::nullptr_t)

- or the largest contiguous sequence of [bit fields](https://en.cppreference.com/w/cpp/language/bit_field) of non-zero length

Note: Various features of the language, such as [references](https://en.cppreference.com/w/cpp/language/reference) and [virtual functions](https://en.cppreference.com/w/cpp/language/virtual), might involve additional memory locations that are not accessible to programs but are managed by the implementation.

    struct S {
        char a;     // memory location #1
        int b : 5;  // memory location #2
        int c : 11, // memory location #2 (continued)
            : 0,
            d : 8;  // memory location #3
        struct {
            int ee : 8; // memory location #4
        } e;
    } obj; // The object 'obj' consists of 4 separate memory locations

## Threads and data races

A thread of execution is a flow of control within a program that begins with the invocation of a top-level function by [std::thread::thread](https://en.cppreference.com/w/cpp/thread/thread/thread), [std::async](https://en.cppreference.com/w/cpp/thread/async), or other means.

Any thread can potentially access any object in the program (objects with automatic and thread-local [storage duration](https://en.cppreference.com/w/cpp/language/storage_duration) may still be accessed by another thread through a pointer or by reference).

Different threads of execution are always allowed to access (read and modify) different memory locations concurrently, with no interference and no synchronization requirements.

When an [evaluation](https://en.cppreference.com/w/cpp/language/eval_order) of an expression writes to a memory location and another evaluation reads or modifies the same memory location, the expressions are said to conflict. A program that has two conflicting evaluations has a data race unless

- both evaluations execute on the same thread or in the same [signal handler](https://en.cppreference.com/w/cpp/utility/program/signal#Signal_handler), or

- both conflicting evaluations are atomic operations (see [std::atomic](https://en.cppreference.com/w/cpp/atomic/atomic)), or

- one of the conflicting evaluations happens-before another (see [std::memory_order](https://en.cppreference.com/w/cpp/atomic/memory_order))

If a data race occurs, the behavior of the program is undefined.

(In particular, release of a [std::mutex](https://en.cppreference.com/w/cpp/thread/mutex) is synchronized-with, and therefore, happens-before acquisition of the same mutex by another thread, which makes it possible to use mutex locks to guard against data races.)

## Memory order

When a thread reads a value from a memory location, it may see the initial value, the value written in the same thread, or the value written in another thread. See [std::memory_order](https://en.cppreference.com/w/cpp/atomic/memory_order) for details on the order in which writes made from threads become visible to other threads.

## Forward progress

### Obstruction freedom

When only one thread that is not blocked in a standard library function executes an atomic function that is lock-free, that execution is guaranteed to complete (all standard library lock-free operations are [obstruction-free](https://en.wikipedia.org/wiki/Non-blocking_algorithm#Obstruction-freedom))

### Lock freedom

When one or more lock-free atomic functions run concurrently, at least one of them is guaranteed to complete (all standard library lock-free operations are [lock-free](https://en.wikipedia.org/wiki/Non-blocking_algorithm#Lock-freedom) -- it is the job of the implementation to ensure they cannot be live-locked indefinitely by other threads, such as by continuously stealing the cache line)

### Progress guarantee

In a valid C++ program, every thread eventually does one of the following:

- terminate
- makes a call to an I/O library function
- performs an access through a volatile glvalue
- performs an atomic operation or a synchronization operation

No thread of execution can execute forever without performing any of these observable behaviors.

Note that it means that a program with endless recursion or endless loop (whether implemented as a for-statement or by looping goto or otherwise) has [undefined behavior](https://en.cppreference.com/w/cpp/language/ub). This allows the compilers to remove all loops that have no observable behavior, without having to prove that they would eventually terminate.

A thread is said to make progress if it performs one of the execution steps above (I/O, volatile, atomic, or synchronization), blocks in a standard library function, or calls an atomic lock-free function that does not complete because of a non-blocked concurrent thread.
