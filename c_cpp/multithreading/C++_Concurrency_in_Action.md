# C++ Concurrency in Action

- [C++ Concurrency in Action](#c-concurrency-in-action)
  - [5 The C++ memory model and operations on atomic types](#5-the-c-memory-model-and-operations-on-atomic-types)
    - [5.1 Memory model basics](#51-memory-model-basics)
    - [5.2 Atomic operations and types in C++](#52-atomic-operations-and-types-in-c)
      - [5.2.1 The standard atomic types](#521-the-standard-atomic-types)
      - [5.2.2 Operations on std::atomic_flag](#522-operations-on-stdatomic_flag)
        - [Listing 5.1 Implementation of a spinlock mutex using std::atomic_flag](#listing-51-implementation-of-a-spinlock-mutex-using-stdatomic_flag)
      - [5.2.3 Operations on `std::atomic<bool>`](#523-operations-on-stdatomicbool)
        - [STORING A NEW VALUE (OR NOT) DEPENDING ON THE CURRENT VALUE](#storing-a-new-value-or-not-depending-on-the-current-value)
      - [5.2.4 Operations on std::atomic<T*>: pointer arithmetic](#524-operations-on-stdatomict-pointer-arithmetic)
      - [5.2.5 Operations on standard atomic integral types](#525-operations-on-standard-atomic-integral-types)
      - [5.2.6 The std::atomic<> primary class template](#526-the-stdatomic-primary-class-template)
      - [5.2.7 Free functions for atomic operations](#527-free-functions-for-atomic-operations)
    - [5.3 Synchronizing operations and enforcing ordering](#53-synchronizing-operations-and-enforcing-ordering)
      - [Listing 5.2 Reading and writing variables from different threads](#listing-52-reading-and-writing-variables-from-different-threads)
      - [5.3.1 The synchronizes-with relationship](#531-the-synchronizes-with-relationship)
      - [5.3.2 The happens-before relationship](#532-the-happens-before-relationship)

## 5 The C++ memory model and operations on atomic types

### 5.1 Memory model basics

### 5.2 Atomic operations and types in C++

#### 5.2.1 The standard atomic types

The standard atomic types can be found in the <atomic> header. All operations on such types are atomic, and only operations on these types are atomic in the sense of the language definition, although you can use mutexes to make other operations appear atomic. In fact, the standard atomic types themselves might use such emulation: they **(almost) all** have an **`is_lock_free()`** member function, which allows the user to determine whether operations on a given type are done directly with atomic instructions (x.is_lock_free() returns true) or done by using a lock internal to the compiler and library (x.is_lock_free() returns false).

This is important to know in many cases—the key use case for atomic operations is as a replacement for an operation that would otherwise use a mutex for synchronization; if the atomic operations themselves use an internal mutex then the hoped-for performance gains will probably not materialize, and **you might be better off using the easier-to-get-right mutex-based implementation instead**. This is the case with lockfree data structures such as those discussed in chapter 7.

The **only type that doesn’t provide an `is_lock_free()`** member function is
std::atomic_flag. This type is a simple Boolean flag, and operations on this type are required to be lock-free; once you have a simple lock-free Boolean flag, you can use that to implement a simple lock and implement all the other atomic types using that as a basis. When I said simple, I meant it: objects of the std::atomic_flag type are initialized to clear, and they can then either be queried and set (with the test_and_set() member function) or cleared (with the clear() member function). That’s it: **no assignment, no copy construction, no test and clear, no other operations** at all.

The remaining atomic types are all accessed through specializations of the std::atomic<> class template and are a bit more full-featured but may not be lockfree (as explained previously). On most popular platforms it’s expected that the atomic variants of all the built-in types (such as `std::atomic<int>` and std::atomic <void*>) are indeed lock-free, but it isn’t required. As you’ll see shortly, the interface of each specialization reflects the properties of the type; bitwise operations such as `&=` aren't defined for plain pointers, so they aren't defined for atomic pointers either, for example.

The standard atomic types are **not copyable or assignable** in the conventional
sense, in that they **have no copy constructors or copy assignment operators**. They do, however, support assignment from and implicit conversion to the corresponding built-in types as well as direct load() and store() member functions, exchange(), compare_exchange_weak(), and compare_exchange_strong(). They also support the compound assignment operators where appropriate: +=, -=, *=, |=, and so on, and the integral types and std::atomic<> specializations for ++ and -- pointers support. These operators also have corresponding named member functions with the same functionality: fetch_add(), fetch_or(), and so on. The return value from the assignment operators and member functions is either the value stored (in the case of the assignment operators) or the value prior to the operation (in the case of the named functions). This avoids the potential problems that could stem from the usual habit of these assignment operators returning a reference to the object being assigned to. In order to get the stored value from these references, the code would have to perform a separate read, allowing another thread to modify the value between the assignment and the read and opening the door for a race condition.

The std::atomic<> class template isn't only a set of specializations, though. It does have a primary template that can be used to create an atomic variant of a userdefined type. Because it's a generic class template, the **operations are limited to load(), store() (and assignment from and conversion to the user-defined type), exchange(), compare_exchange_weak(), and compare_exchange_strong()**.

Each of the operations on the atomic types has an optional memory-ordering argument which is one of the values of the std::memory_order enumeration. This argument is used to specify the required memory-ordering semantics. The std::memory_order enumeration has six possible values: std::memory_order_relaxed, std::memory_order_acquire, std::memory_order_consume, std::memory_order_acq_rel, std::memory_order_release, and std::memory_order_seq_cst.

The permitted values for the memory ordering depend on the operation category. If you don't specify an ordering value, then the default ordering is used, which is the strongest ordering: std::memory_order_seq_cst. The precise semantics of the memory-ordering options are covered in section 5.3. For now, it suffices to know that the operations are divided into three categories:

- Store operations, which can have memory_order_relaxed, memory_order_release,
or memory_order_seq_cst ordering
- Load operations, which can have memory_order_relaxed, memory_order_consume,
memory_order_acquire, or memory_order_seq_cst ordering
- Read-modify-write operations, which can have memory_order_relaxed, memory_
order_consume, memory_order_acquire, memory_order_release, memory_order
_acq_rel, or memory_order_seq_cst ordering

#### 5.2.2 Operations on std::atomic_flag

std::atomic_flag is the simplest standard atomic type, which represents a Boolean flag. Objects of this type can be in one of two states: set or clear. It’s deliberately basic and is intended as a building block only. As such, I’d never expect to see it in use, except under special circumstances. Even so, it will serve as a starting point for discussing the other atomic types, because it shows some of the general policies that apply to the atomic types

Objects of the std::atomic_flag type must be initialized with ATOMIC_FLAG_INIT. This initializes the flag to a clear state. There’s no choice in the matter; the flag always starts clear:

    std::atomic_flag f=ATOMIC_FLAG_INIT;

This applies no matter where the object is declared and what scope it has. It’s the only atomic type to require such special treatment for initialization, but it’s also **the only type guaranteed to be lock-free**. If the std::atomic_flag object has static storage duration, it’s guaranteed to be statically initialized, which means that there are no initialization-order issues; it will always be initialized by the time of the first operation on the flag.

You can’t copy-construct another std::atomic_flag object from the first, and you **can't assign one std::atomic_flag to another. This isn’t something peculiar to std::atomic_flag but something common with all the atomic types**. All operations on an atomic type are defined as atomic, and assignment and copy-construction involve two objects. **A single operation on two distinct objects can't be atomic**. In the case of copyconstruction or copy-assignment, the value must first be read from one object and then written to the other. These are two separate operations on two separate objects, and the combination can't be atomic. Therefore, these operations aren't permitted.

The limited feature set makes std::atomic_flag ideally suited to use as a spinlock mutex. Initially, the flag is clear and the mutex is unlocked. To lock the mutex, loop on test_and_set() until the old value is false, indicating that this thread set the value to true. Unlocking the mutex is simply a matter of clearing the flag. This implementation is shown in the following listing.

##### Listing 5.1 Implementation of a spinlock mutex using std::atomic_flag

    class spinlock_mutex
    {
        std::atomic_flag flag;
    public:
        spinlock_mutex():
        flag(ATOMIC_FLAG_INIT)
        {}
        void lock()
        {
            while(flag.test_and_set(std::memory_order_acquire));
        }
        void unlock()
        {
            flag.clear(std::memory_order_release);
        }
    };

> **NOTE**
>
>     bool test_and_set(std::memory_order order = std::memory_order_seq_cst) noexcept;
> Atomically changes the state of a std::atomic_flag to set (true) and returns the value it held before.

std::atomic_flag is so limited that it can’t even be used as a general Boolean flag, because it doesn’t have a simple nonmodifying query operation. For that you’re better off using `std::atomic<bool>`, so I’ll cover that next.

#### 5.2.3 Operations on `std::atomic<bool>`

The most basic of the atomic integral types is `std::atomic<bool>`. This is a more fullfeatured Boolean flag than std::atomic_flag, as you might expect. Although it’s still
**not copy-constructible or copy-assignable**, you can construct it from a non-atomic
bool, so it can be initially true or false, and you can also assign to instances of
`std::atomic<bool>` from a non-atomic bool:

    std::atomic<bool> b(true);
    b=false;

One other thing to note about the assignment operator from a non-atomic bool is that it differs from the general convention of returning a reference to the object it’s assigned to: it returns a bool with the value assigned instead. This is another common pattern with the atomic types: the assignment operators they support **return values (of the corresponding non-atomic type) rather than references**. If a reference to the atomic variable was returned, any code that depended on the result of the assignment would then have to explicitly load the value, potentially getting the result of a modification by another thread. By returning the result of the assignment as a non-atomic value, you can avoid this additional load, and you know that the value obtained is the value stored.

##### STORING A NEW VALUE (OR NOT) DEPENDING ON THE CURRENT VALUE

This new operation is called **compare-exchange**, and it comes in the form of the `compare_exchange_weak()` and `compare_exchange_strong()` member functions. The compare-exchange operation is the cornerstone of programming with atomic types; it compares the value of the atomic variable with a supplied expected value and stores the supplied desired value if they’re equal. If the values aren’t equal, the expected value is updated with the value of the atomic variable. The return type of the compare-exchange functions is a bool, which is true if the store was performed and false otherwise. The operation is said to succeed if the store was done (because the values were equal), and fail otherwise; the return value is true for success, and false for failure.

> **NOTE**
>
>     bool compare_exchange_weak( T& expected, T desired,
>                               std::memory_order order =
>                               std::memory_order_seq_cst ) noexcept;
> The weak forms of the functions are allowed to fail spuriously, that is, act as if *this != expected even if they are equal. When a compare-and-exchange is in a loop, the weak version will yield better performance on some platforms.
>
> When compare-exchange function returned, `expected` value is equal to `atomic variable`; if the return value is `true`, store to atomic variable is done.
>
>`expected` variable has two functions:
>
> 1. pass the value to be compared with atomic variable
> 2. get the value of atomic variable when atomic opertion is processing.

Because `compare_exchange_weak()` can **fail spuriously**, it must typically be used in a loop:

    bool expected=false;
    extern atomic<bool> b; // set somewhere else
    while(!b.compare_exchange_weak(expected,true) && !expected);

In this case, you keep looping as long as expected is still false, indicating that the `compare_exchange_weak()` call failed spuriously.

> **NOTE**
>
> In this case, the only situation that the `while` loop not break is spurious failure happen.

If you want to change the variable **whatever the initial value is** (perhaps with an updated value that depends on the current value), the update of expected becomes useful; **each time through the loop, expected is reloaded**, so if no other thread modifies the value in the meantime, the `compare_exchange_weak()` or `compare_exchange_strong()` call should be **successful the next time around the loop**. If the calculation of the value **to be stored** is simple, it may be beneficial to use `compare_exchange_weak()` in order to avoid a **double loop** on **platforms** where `compare_exchange_weak()` can fail spuriously (and so **`compare_exchange_strong()` contains a loop**). On the other hand, if the calculation of the value to be stored is time-consuming, it may makesense to use `compare_exchange_strong()` to avoid having to recalculate the value to store when the expected value hasn’t changed. For `std::atomic<bool>` this isn’t so important—there are only two possible values after all—but for the larger atomic types this can make a difference.

> **DEMO**
>
> Change atomic variable with an updated value that depends on the current value.
>
>     extern atomic<bool> b; // set somewhere else
>     bool expected = false;
>     bool desired = CalcValue(b);
>     while (!b.compare_exchange_weak(expected, desired)) {
>         desired = CalcValue(expected);
>     }
>
> **NOTE**
>
> Unlike atomic_compare_exchange_weak, this strong version is required to always return true when expected indeed compares equal to the contained object, not allowing spurious failures. However, on certain machines, and for certain algorithms that check this in a loop, compare_exchange_weak may lead to significantly better performance.

The compare-exchange functions are also unusual in that they can take **two memoryordering parameters**. This allows for the memory-ordering semantics to differ in the case of success and failure; it might be desirable for a successful call to have memory_order_acq_rel semantics, whereas a failed call has memory_order_relaxed semantics. A failed compare-exchange doesn’t do a store, so it can’t have memory_order_release or memory_order_acq_rel semantics. It’s therefore not permitted to supply these values as the ordering for failure. You also can’t supply stricter memory ordering for failure than for success; if you want memory_order_acquire or memory_order_seq_cst semantics for failure, you must specify those for success as well.

> **NOTE**
>
>     bool compare_exchange_weak( T& expected, T desired,
>                                 std::memory_order order =
>                                 std::memory_order_seq_cst ) noexcept;

If you don’t specify an ordering for failure, it’s assumed to be the same as that for success, except that the release part of the ordering is stripped: memory_order_release becomes memory_order_relaxed, and memory_order_acq_rel becomes memory_order_acquire. If you specify neither, they default to memory_order_seq_cst as usual, which provides the full sequential ordering for both success and failure. The following two calls to compare_exchange_weak() are equivalent:

    std::atomic<bool> b;
    bool expected;
    b.compare_exchange_weak(expected,true,
    memory_order_acq_rel,memory_order_acquire);
    b.compare_exchange_weak(expected,true,memory_order_acq_rel);

#### 5.2.4 Operations on std::atomic<T*>: pointer arithmetic

The atomic form of a pointer to some type `T` is `std::atomic<T*>`, just as the atomic form of bool is `std::atomic<bool>`. The interface is the same, although it operates on values of the corresponding pointer type rather than bool values. Like `std::atomic<bool>`, it’s **neither copy-constructible nor copy-assignable**, although it can be both constructed and assigned from the suitable pointer values. As well as the obligatory `is_lock_free()` member function, `std::atomic<T*>` also has `load()`, `store()`, `exchange()`, `compare_exchange_weak()`, and `compare_exchange_strong()`
member functions, with similar semantics to those of `std::atomic<bool>`, again taking and returning `T*` rather than `bool`.

Because both `fetch_add()` and `fetch_sub()` are read-modify-write operations, they can have any of the **memory-ordering** tags and can participate in a release sequence. Specifying the ordering semantics isn’t possible for the operator forms, because there’s no way of providing the information: these forms therefore always have memory_order_seq_cst semantics.

The remaining basic atomic types are all the same: they’re all atomic integral types and have the same interface as each other, except that the associated built-in type is different. We’ll look at them as a group.

#### 5.2.5 Operations on standard atomic integral types

As well as the usual set of operations (`load()`, `store()`, `exchange()`, `compare_exchange_weak()`, and `compare_exchange_strong()`), the atomic integral types such as `std::atomic<int>` or `std::atomic<unsigned long long>` have quite a comprehensive set of operations available: `fetch_add()`, `fetch_sub()`, `fetch_and()`, `fetch_or()`, `fetch_xor()`, compound-assignment forms of these operations (`+=`, `-=`, `&=`, `|=`, and
`^=`), and pre- and post-increment and decrement (`++x`, `x++`, `--x`, and `x--`). It’s not quite the full set of compound-assignment operations you could do on a normal integral type, but it’s close enough: **only division, multiplication, and shift operators are missing**. Because atomic integral values are typically used either as counters or as bitmasks, this isn’t a particularly noticeable loss; additional operations can easily be done using `compare_exchange_weak()` in a loop, if required.

The semantics closely match those of `fetch_add()` and `fetch_sub()` for `std::atomic<T*>`; the **named functions** atomically perform their operation and return the **old value**, whereas the **compound-assignment** operators return the **new value**. Pre- and post- increment and decrement work as usual: **++x** increments the variable and returns the **new value**, whereas **x++** increments the variable and returns the
**old value**. As you’ll be expecting, the result is a value of the associated integral type in
both cases.

We’ve now looked at all the basic atomic types; all that remains is the generic `std::atomic<>` primary class template rather than the specializations, so let’s look at that next.

#### 5.2.6 The std::atomic<> primary class template

The presence of the primary template allows a user to create an atomic variant of a user-defined type, in addition to the standard atomic types. Given a user-defined type `UDT`, `std::atomic<UDT>` provides the same interface as `std::atomic<bool>` (as described in section 5.2.3), except that the bool parameters and return types that relate to the stored value (rather than the success/failure result of the compare exchange operations) are `UDT` instead. You **can’t use just any user-defined type with `std::atomic<>`**, though; the type has to fulfill certain criteria. In order to use `std::atomic<UDT>` for some user-defined type `UDT`, this type must have a **trivial copy-assignment operator**. This means that the type must **not have any virtual functions or virtual base classes** and must **use the compiler-generated copy-assignment operator**. Not only that, but every **base class** and **non-static data member** of a user-defined type must also have a trivial copy-assignment operator. This permits the compiler to use `memcpy()` or an equivalent operation for assignment operations, because there’s no user-written code to run.

Finally, it is worth noting that the compare-exchange operations do **bitwise comparison** as if using memcmp, rather than using any comparison operator that may be defined for UDT. If the type provides comparison operations that **have different semantics**, or the type has **padding bits** that do not participate in normal comparisons, then this can lead to a **compare-exchange operation failing**, even though the values compare equally.

The reasoning behind these restrictions goes back to one of the guidelines from chapter 3: **don’t pass pointers and references to protected data outside the scope of the lock by passing them as arguments to user-supplied functions**. In general, the compiler **isn’t going to be able to generate lock-free code** for `std::atomic<UDT>`, so it will have to use an internal lock for all the operations. If user-supplied copy-assignment or comparison operators were permitted, this would require passing a reference to the protected data as an argument to a user-supplied function, violating the guideline. Also, the library is entirely at liberty to use a single lock for all atomic operations that need it, and allowing user-supplied functions to be called while holding that lock might cause deadlock or cause other threads to block because a comparison operation took a long time. Finally, these restrictions increase the chance that the compiler will be able to make use of atomic instructions directly for `std::atomic<UDT>` (and make a particular instantiation lock-free), because it can treat the user-defined type as a set of raw bytes.

Note that although you can use `std::atomic<float>` or `std::atomic<double>`, because the built-in floating point types do satisfy the criteria for use with `memcpy` and `memcmp`, the behavior may be surprising in the case of `compare_exchange_strong` (`compare_exchange_weak` can **always fail** for arbitrary internal reasons, as described previously). The operation may fail even though the old stored value was equal in value to the comparand, **if the stored value had a different representation**. Note that there are **no atomic arithmetic operations on floating-point values**. You’ll get similar behavior with `compare_exchange_strong` if you use `std::atomic<>` with a userdefined type that has an equality-comparison operator defined, and that operator differs from the comparison using memcmp—the operation may fail because the otherwise-equal values have a different representation.

If your `UDT` is the same size as (or smaller than) an `int` or a `void*`, most common platforms will be able to use atomic instructions for `std::atomic<UDT>`. Some platforms will also be able to use atomic instructions for user-defined types that are twice the size of an `int` or `void*`. These platforms are typically those that support a so-called **double-word-compare-and-swap (DWCAS)** instruction corresponding to the compare_exchange_xxx functions. As you’ll see in chapter 7, such support can be helpful when writing lock-free code.

These restrictions mean that you can’t, for example, create `std::atomic<std::vector<int>>` (because it has a non-trivial copy constructor and copy assignment operator), but you can instantiate `std::atomic<>` with classes containing counters or flags or pointers or even **arrays of simple data elements**. This isn’t particularly a problem; the more complex the data structure, the more likely you’ll want to do operations on it other than simple assignment and comparison. If that’s the case, you’re **better off using an `std::mutex`** to ensure that the data is appropriately protected for the desired operations, as described in chapter 3.

As already mentioned, when instantiated with a user-defined type `T`, the interface of `std::atomic<T>` is **limited to the set of operations available** for **`std::atomic<bool>`**: **load()**, **store()**, **exchange()**, **compare_exchange_weak()**, **compare_exchange_strong()**, and **assignment from** and **conversion to** an instance of type `T`.

#### 5.2.7 Free functions for atomic operations

Up until now I’ve limited myself to describing the member function forms of the operations on the atomic types. But there are also equivalent nonmember functions for all the operations on the various atomic types. For the most part, the nonmember functions are named after the corresponding member functions but with an atomic_prefix (for example, std::atomic_load()). These functions are then overloaded for each of the atomic types. Where there’s opportunity for specifying a memory-ordering tag, they come in two varieties: one without the tag and one with an _explicit suffix and an additional parameter or parameters for the memory-ordering tag or tags (for example, std::atomic_store(&atomic_var,new_value) versus std::atomic_store_explicit(&atomic_var,new_value,std::memory_order_release). Whereas the atomic object being referenced by the member functions is implicit, all the free functions take a pointer to the atomic object as the first parameter.

The C++ Standard Library also provides free functions for accessing instances of std::shared_ptr<> in an atomic fashion. This is a break from the principle that only the atomic types support atomic operations, because std::shared_ptr<> is quite definitely not an atomic type (accessing the same `std::shared_ptr<T>` object from multiple threads without using the atomic access functions from all threads, or using suitable other external synchronization, is a data race and undefined behavior). But the C++ Standards Committee felt it was sufficiently important to provide these extra functions. The atomic operations available are load, store, exchange, and compare-exchange, which are provided as overloads of the same operations on the standard atomic types, taking an std::shared_ptr<>* as the first argument:

    std::shared_ptr<my_data> p;
    void process_global_data()
    {
        std::shared_ptr<my_data> local=std::atomic_load(&p);
        process_data(local);
    }
    void update_global_data()
    {
        std::shared_ptr<my_data> local(new my_data);
        std::atomic_store(&p,local);
    }

As with the atomic operations on other types, the _explicit variants are also provided to allow you to specify the desired memory ordering, and the std::atomic_is_lock_free() function can be used to check whether the implementation uses locks to ensure the atomicity.

As described in the introduction, the standard atomic types do more than avoid the undefined behavior associated with a data race; they **allow the user to enforce an ordering of operations between threads**. This enforced ordering is **the basis of the facilities for protecting data and synchronizing operations such as std::mutex and std::future<>**. With that in mind, let’s move on to the real meat of this chapter: the details of the concurrency aspects of the memory model and how atomic operations can be used to synchronize data and enforce ordering

### 5.3 Synchronizing operations and enforcing ordering

Suppose you have two threads, one of which is populating a data structure to be read by the second. In order to avoid a problematic race condition, the first thread sets a flag to indicate that the data is ready, and the second thread doesn’t read the data until the flag is set. The following listing shows such a scenario.

#### Listing 5.2 Reading and writing variables from different threads

    #include <vector>
    #include <atomic>
    #include <iostream>
    std::vector<int> data;
    std::atomic<bool> data_ready(false);

    void reader_thread()
    {
        while(!data_ready.load())
        {
            std::this_thread::sleep(std::chrono::milliseconds(1));
        }
        std::cout<<"The answer="<<data[0]<<"\n";
    }
    void writer_thread()
    {
        data.push_back(42);
        data_ready=true;
    }

All this might seem fairly intuitive: the operation that writes a value happens before an operation that reads that value. With the **default** atomic operations, that’s indeed true (which is why this is the default), but it does need spelling out: the atomic operations **also have other options** for the ordering requirements, which I’ll come to shortly.

#### 5.3.1 The synchronizes-with relationship

The synchronizes-with relationship is something that you **can get only between operations on atomic types**. Operations on a data structure (such as **locking a mutex**) might provide this relationship if the data structure contains atomic types and the operations on that data structure perform the appropriate atomic operations internally, but fundamentally it **comes only from operations on atomic types**.

The basic idea is this: a suitably-tagged atomic write operation, W, on a variable, x, synchronizes with a suitably-tagged atomic read operation on x that reads the value stored by either that write, W, or a subsequent atomic write operation on x by the same thread that performed the initial write, W, or a sequence of atomic read-modify-write operations on x (such as fetch_add() or compare_exchange_weak()) by any thread, where the value read by the first thread in the sequence is the value written by W (see section 5.3.4).

> **NOTE**
>
> We say a suitably-tagged atomic write operation, W, on a variable, x, synchronizes with a suitably-tagged atomic read operation on x, if the "value" read by the read operation
>
> 1. is the "value" that stored by W;
> 2. is the "value" that stored by a subsequent atomic write operation on x by the same thread performs W;
> 3. is the "value" that stored by a sequece of atomic read-modify-write operations (satisfies the value read by the first thread in the sequence is the value written by W) on x by any thread.

Leave the "suitably-tagged" part aside for now, because all operations on atomic types are **suitably tagged by default**. This means what you might expect: if thread A stores a value and thread B reads that value, there’s a synchronizes-with relationship between the store in thread A and the load in thread B, as in listing 5.2. This is illustrated in figure 5.2.

> "suitably tagged by default" means default memory order parameter is std::memory_order_seq_cst for atomic operations

As I’m sure you’ve guessed, the nuances are all in the "suitably-tagged" part. The C++ memory model allows **various ordering constraints** to be applied to the operations on atomic types, and this is the tagging to which I refer. The various options for memory ordering and how they relate to the synchronizes-with relationship are covered in section 5.3.3. First, let’s step back and look at the happens-before relationship.

#### 5.3.2 The happens-before relationship


