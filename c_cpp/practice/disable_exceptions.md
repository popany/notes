# Disable Exceptions

- [Disable Exceptions](#disable-exceptions)
  - [Disabling C++ exceptions, how can I make any `std:: throw()` immediately terminate?](#disabling-c-exceptions-how-can-i-make-any-std-throw-immediately-terminate)
  - [mock `__cxa_xxx`](#mock-__cxa_xxx)

## [Disabling C++ exceptions, how can I make any `std:: throw()` immediately terminate?](https://stackoverflow.com/a/7249442)

- Option #1: Simply never catch exceptions.

- Option #2: Pass `-fno-exceptions`.

  This flag instructs G++ to [do two things](http://gcc.gnu.org/onlinedocs/libstdc++/manual/using_exceptions.html):

  1. All exception handling in STL libraries are removed; throws are replaced with `abort()` calls

  2. Stack unwind data and code is removed. This saves some code space, and may make register allocation marginally easier for the compiler (but I doubt it'll have much performance impact). Notably, however, if an exception is thrown, and the library tries to unwind through `-fno-exceptions` code, it will abort at that point, as there is no unwind data.

  This will, effectively, turn all exceptions into `abort()`s, as you would like. Note, **however, that you will not be allowed to `throw`** - any actual `throw`s or `catch`s in your code will result in a compile-time error.

- Option #3: (Nonportable and not recommended!) Hook `__cxa_allocate_exception`.

  C++ exceptions are implemented using (**among others**) the `__cxa_allocate_exception` and `__cxa_throw` internal library functions. You can implement a `LD_PRELOAD` library that hooks these functions to `abort()`:

      void __cxa_allocate_exception() { abort(); }
      void __cxa_throw() { abort(); }

  WARNING: This is a horrible hack. It should work on x86 and x86-64, but I strongly recommend against this. Notably, it won't actually improve performance or save code space, as `-fno-exceptions` might. However, it will allow the throw syntax, while turning throws into `abort()`s.

## mock `__cxa_xxx`

    __cxa_allocate_exception
    __cxa_atexit
    __cxa_bad_cast
    __cxa_begin_catch
    __cxa_demangle
    __cxa_end_catch
    __cxa_finalize
    __cxa_free_exception
    __cxa_guard_abort
    __cxa_guard_acquire
    __cxa_guard_release
    __cxa_pure_virtual
    __cxa_rethrow
    __cxa_thread_atexit
    __cxa_throw
    __cxa_throw_bad_array_new_length




