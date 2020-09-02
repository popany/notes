# functional

- [functional](#functional)
  - [std::bind](#stdbind)
    - [How to combine the use of std::bind with std::shared_ptr](#how-to-combine-the-use-of-stdbind-with-stdshared_ptr)

## [std::bind](https://en.cppreference.com/w/cpp/utility/functional/bind)

As described in [Callable](https://en.cppreference.com/w/cpp/named_req/Callable), when invoking a pointer to non-static member function or pointer to non-static data member, the first argument has to be a reference or pointer (including, possibly, smart pointer such as std::shared_ptr and std::unique_ptr) to an object whose member will be accessed.

The arguments to bind are copied or moved, and are never passed by reference unless wrapped in std::ref or std::cref.

Duplicate placeholders in the same bind expression (multiple _1's for example) are allowed, but the results are only well defined if the corresponding argument (u1) is an lvalue or non-movable rvalue.

### [How to combine the use of std::bind with std::shared_ptr](https://stackoverflow.com/questions/13272831/how-to-combine-the-use-of-stdbind-with-stdshared-ptr)
