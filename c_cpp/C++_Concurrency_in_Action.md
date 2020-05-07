# C++ Concurrency in Action

- [C++ Concurrency in Action](#c-concurrency-in-action)
  - [5 The C++ memory model and operations on atomic types](#5-the-c-memory-model-and-operations-on-atomic-types)
    - [5.1 Memory model basics](#51-memory-model-basics)
    - [5.2 Atomic operations and types in C++](#52-atomic-operations-and-types-in-c)
      - [5.2.3 Operations on std::atomic\<bool\>](#523-operations-on-stdatomicbool)
        - [STORING A NEW VALUE (OR NOT) DEPENDING ON THE CURRENT VALUE](#storing-a-new-value-or-not-depending-on-the-current-value)
      - [5.2.4 Operations on std::atomic<T*>: pointer arithmetic](#524-operations-on-stdatomict-pointer-arithmetic)
      - [5.2.5 Operations on standard atomic integral types](#525-operations-on-standard-atomic-integral-types)
      - [5.2.6 The std::atomic<> primary class template](#526-the-stdatomic-primary-class-template)
      - [5.2.7 Free functions for atomic operations](#527-free-functions-for-atomic-operations)
    - [5.3 Synchronizing operations and enforcing ordering](#53-synchronizing-operations-and-enforcing-ordering)

## 5 The C++ memory model and operations on atomic types

### 5.1 Memory model basics

### 5.2 Atomic operations and types in C++

#### 5.2.3 Operations on std::atomic\<bool\>

##### STORING A NEW VALUE (OR NOT) DEPENDING ON THE CURRENT VALUE

This new operation is called **compare-exchange**, and it comes in the form of the `compare_exchange_weak()` and `compare_exchange_strong()` member functions. The compare-exchange operation is the cornerstone of programming with atomic types; it compares the value of the atomic variable with a supplied expected value and stores the supplied desired value if they’re equal. If the values aren’t equal, the expected value is updated with the value of the atomic variable. The return type of the compare-exchange functions is a bool, which is true if the store was performed and false otherwise. The operation is said to succeed if the store was done (because the values were equal), and fail otherwise; the return value is true for success, and false for failure.

---

**Comment:**

*When compare-exchange function returned, `expected` value is equal to `atomic variable`; if the return value is `true`, store to atomic variable is done.*

*`expected` variable has two functions: 1. pass the value to be compared with atomic variable; 2. get the value of atomic variable when atomic opertion is processing.*

---

Because `compare_exchange_weak()` can **fail spuriously**, it must typically be used in a loop:

    bool expected=false;
    extern atomic<bool> b; // set somewhere else
    while(!b.compare_exchange_weak(expected,true) && !expected);

In this case, you keep looping as long as expected is still false, indicating that the `compare_exchange_weak()` call failed spuriously.

---

**Comment:**

*In this case, the only situation that the `while` loop not break is spurious failure happen.*

---

If you want to change the variable **whatever the initial value is** (perhaps with an updated value that depends on the current value), the update of expected becomes useful; **each time through the loop, expected is reloaded**, so if no other thread modifies the value in the meantime, the `compare_exchange_weak()` or `compare_exchange_strong()` call should be **successful the next time around the loop**. If the calculation of the value **to be stored** is simple, it may be beneficial to use `compare_exchange_weak()` in order to avoid a **double loop** on **platforms** where `compare_exchange_weak()` can fail spuriously (and so **`compare_exchange_strong()` contains a loop**). On the other hand, if the calculation of the value to be stored is time-consuming, it may makesense to use `compare_exchange_strong()` to avoid having to recalculate the value to store when the expected value hasn’t changed. For `std::atomic<bool>` this isn’t so important—there are only two possible values after all—but for the larger atomic types this can make a difference.

---

**Comment:**

demo

    extern atomic<bool> b; // set somewhere else
    bool expected = false;
    bool desired = CalcValue(b);
    while (!b.compare_exchange_weak(expected, desired)) {
        expected = CalcValue(desired);
    }

Unlike compare_exchange_weak, this strong version is required to always return true when expected indeed compares equal to the contained object, not allowing spurious failures. However, 

On certain machines `compare_exchange_strong` contains a loop.

---

The compare-exchange functions are also unusual in that they can take **two memoryordering parameters**. This allows for the memory-ordering semantics to differ in the case of success and failure; it might be desirable for a successful call to have memory_order_acq_rel semantics, whereas a failed call has memory_order_relaxed semantics. A failed compare-exchange doesn’t do a store, so it can’t have memory_order_release or memory_order_acq_rel semantics. It’s therefore not permitted to supply these values as the ordering for failure. You also can’t supply stricter memory ordering for failure than for success; if you want memory_order_acquire or memory_order_seq_cst semantics for failure, you must specify those for success as well.

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

The presence of the primary template allows a user to create an atomic variant of a user-defined type, in addition to the standard atomic types. Given a user-defined type `UDT`, `std::atomic<UDT>` provides the same interface as `std::atomic<bool>` (as described in section 5.2.3), except that the bool parameters and return types that relate to the stored value (rather than the success/failure result of the compare exchange operations) are `UDT` instead. You **can’t use just any user-defined type with `std::atomic<>`**, though; the type has to fulfill certain criteria. In order to use `std::atomic<UDT>` for some user-defined type `UDT`,, this type must have a **trivial copy-assignment operator**. This means that the type must **not have any virtual functions or virtual base classes** and must **use the compiler-generated copy-assignment operator**. Not only that, but every **base class** and **non-static data member** of a user-defined type must also have a trivial copy-assignment operator. This permits the compiler to use `memcpy()` or an equivalent operation for assignment operations, because there’s no user-written code to run.

Finally, it is worth noting that the compare-exchange operations do **bitwise comparison** as if using memcmp, rather than using any comparison operator that may be defined for UDT. If the type provides comparison operations that **have different semantics**, or the type has **padding bits** that do not participate in normal comparisons, then this can lead to a **compare-exchange operation failing**, even though the values compare equally.

The reasoning behind these restrictions goes back to one of the guidelines from chapter 3: **don’t pass pointers and references to protected data outside the scope of the lock by passing them as arguments to user-supplied functions**. In general, the compiler **isn’t going to be able to generate lock-free code** for `std::atomic<UDT>`, so it will have to use an internal lock for all the operations. If user-supplied copy-assignment or comparison operators were permitted, this would require passing a reference to the protected data as an argument to a user-supplied function, violating the guideline. Also, the library is entirely at liberty to use a single lock for all atomic operations that need it, and allowing user-supplied functions to be called while holding that lock might cause deadlock or cause other threads to block because a comparison operation took a long time. Finally, these restrictions increase the chance that the compiler will be able to make use of atomic instructions directly for `std::atomic<UDT>` (and make a particular instantiation lock-free), because it can treat the user-defined type as a set of raw bytes.

Note that although you can use `std::atomic<float>` or `std::atomic<double>`, because the built-in floating point types do satisfy the criteria for use with `memcpy` and `memcmp`, the behavior may be surprising in the case of `compare_exchange_strong` (`compare_exchange_weak` can **always fail** for arbitrary internal reasons, as described previously). The operation may fail even though the old stored value was equal in value to the comparand, **if the stored value had a different representation**. Note that there are **no atomic arithmetic operations on floating-point values**. You’ll get similar behavior with `compare_exchange_strong` if you use `std::atomic<>` with a userdefined type that has an equality-comparison operator defined, and that operator differs from the comparison using memcmp—the operation may fail because the otherwise-equal values have a different representation.

If your `UDT` is the same size as (or smaller than) an `int` or a `void*`, most common platforms will be able to use atomic instructions for `std::atomic<UDT>`. Some platforms will also be able to use atomic instructions for user-defined types that are twice the size of an `int` or `void*`. These platforms are typically those that support a so-called **double-word-compare-and-swap (DWCAS)** instruction corresponding to the compare_exchange_xxx functions. As you’ll see in chapter 7, such support can be helpful when writing lock-free code.

These restrictions mean that you can’t, for example, create `std::atomic<std::vector<int>>` (because it has a non-trivial copy constructor and copy assignment operator), but you can instantiate `std::atomic<>` with classes containing counters or flags or pointers or even **arrays of simple data elements**. This isn’t particularly a problem; the more complex the data structure, the more likely you’ll want to do operations on it other than simple assignment and comparison. If that’s the case, you’re **better off using an `std::mutex`** to ensure that the data is appropriately protected for the desired operations, as described in chapter 3.

As already mentioned, when instantiated with a user-defined type `T`, the interface of `std::atomic<T>` is **limited to the set of operations available** for **std::atomic<bool>**: **load()**, **store()**, **exchange()**, **compare_exchange_weak()**, **compare_exchange_strong()**, and **assignment from** and **conversion to** an instance of type `T`.

#### 5.2.7 Free functions for atomic operations




















### 5.3 Synchronizing operations and enforcing ordering



