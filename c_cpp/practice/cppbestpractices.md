# [C++ Best Practices](https://lefticus.gitbooks.io/cpp-best-practices/content/)

- [C++ Best Practices](#c-best-practices)
  - [Considering Performance](#considering-performance)
    - [Build Time](#build-time)
      - [Forward Declare When Possible](#forward-declare-when-possible)
    - [Runtime](#runtime)
      - [Reduce Copies and Reassignments as Much as Possible](#reduce-copies-and-reassignments-as-much-as-possible)
      - [Get rid of "new"](#get-rid-of-new)
      - [Prefer unique_ptr to shared_ptr](#prefer-unique_ptr-to-shared_ptr)
      - [Get rid of std::endl](#get-rid-of-stdendl)
      - [Limit Variable Scope](#limit-variable-scope)
      - [Never Use std::bind](#never-use-stdbind)

[cpp-best-practices/cppbestpractices](https://github.com/cpp-best-practices/cppbestpractices)

## Considering Performance

### Build Time

#### Forward Declare When Possible

### Runtime

#### Reduce Copies and Reassignments as Much as Possible

More complex cases can be facilitated with an [immediately-invoked lambda](http://blog2.emptycrate.com/content/complex-object-initialization-optimization-iife-c11).

#### Get rid of "new"

To make matters worse, creating a `shared_ptr` actually requires 2 heap allocations.

However, the `make_shared` function reduces this down to just one.

    std::shared_ptr<ModelObject_Impl>(new ModelObject_Impl());

    // should become
    std::make_shared<ModelObject_Impl>(); // (it's also more readable and concise)

#### Prefer unique_ptr to shared_ptr

If possible use `unique_ptr` instead of `shared_ptr`. The `unique_ptr` does not need to keep track of its copies because it is not copyable. Because of this it is more efficient than the `shared_ptr`. Equivalent to `shared_ptr` and `make_shared` you should use `make_unique` (C++14 or greater) to create the `unique_ptr`:

    std::make_unique<ModelObject_Impl>();

Current best practices suggest returning a `unique_ptr` from **factory functions** as well, then converting the `unique_ptr` to a `shared_ptr` if necessary.

    std::unique_ptr<ModelObject_Impl> factory();

    auto shared = std::shared_ptr<ModelObject_Impl>(factory());

#### Get rid of std::endl

`std::endl` implies a flush operation. It's equivalent to `"\n" << std::flush`.

#### Limit Variable Scope

Variables should be declared as late as possible, and ideally only when it's possible to initialize the object. Reduced variable scope results in less memory being used, more efficient code in general, and helps the compiler optimize the code further.

    // Good Idea
    for (int i = 0; i < 15; ++i)
    {
        MyObject obj(i);
        // do something with obj
    }

    // Bad Idea
    MyObject obj; // meaningless object initialization
    for (int i = 0; i < 15; ++i)
    {
        obj = MyObject(i); // unnecessary assignment operation
        // do something with obj
    }
    // obj is still taking up memory for no reason

For C++17 and onwards, consider using init-statement in the if and switch statements:

    if (MyObject obj(index); obj.good()) {
        // do something if obj is good
    } else {
        // do something if obj is not good
    }

#### Never Use std::bind

`std::bind` is almost always way more overhead (both compile time and runtime) than you need. Instead simply use a lambda.

    // Bad Idea
    auto f = std::bind(&my_function, "hello", std::placeholders::_1);
    f("world");

    // Good Idea
    auto f = [](const std::string &s) { return my_function("hello", s); };
    f("world");











TODO c++ ++++++++++++++++++++++++++++

