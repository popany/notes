# Effective C++

- [Effective C++](#effective-c)

- [Effective C++](#effective-c)
  - [Chapter 1: Accustoming Yourself to C++](#chapter-1-accustoming-yourself-to-c)
    - [Item 3: Use const whenever possible](#item-3-use-const-whenever-possible)
  - [Chapter 2: Constructors, Destructors, and Assignment Operators](#chapter-2-constructors-destructors-and-assignment-operators)
    - [Item 8: Prevent exceptions from leaving destructors](#item-8-prevent-exceptions-from-leaving-destructors)
    - [Item 9: Never call virtual functions during construction or destruction](#item-9-never-call-virtual-functions-during-construction-or-destruction)
  - [Chapter 3: Resource Management](#chapter-3-resource-management)
    - [Item 14: Think carefully about copying behavior in resource-managing classes](#item-14-think-carefully-about-copying-behavior-in-resource-managing-classes)

## Chapter 1: Accustoming Yourself to C++

### Item 3: Use const whenever possible

If `operator[]` did return a simple char, statements like this wouldn't compile:

    tb[0] = 'x';

That's because it's never legal to modify the return value of a function that returns a **built-in type**.

...

So having the non-const `operator[]` call the const version is a safe way to avoid code duplication, even though it requires a cast. Here's the code, but it may be clearer after you read the explanation that follows:

    class TextBlock {
    public:
        ...
        const char& operator[](std::size_t position) const // same as before
        {
            ...
            ...
            ...
            return text[position];
        }
        char& operator[](std::size_t position) // now just calls const op[]
        {
            return
              const_cast<char&>( // cast away const on
                                 // op[]'s return type;
                static_cast<const TextBlock&>(*this) // add const to *this's type;
                  [position]     // call const version of op[]
            );
        }
        ...
    };

As you can see, the code has **two casts**, not one.

## Chapter 2: Constructors, Destructors, and Assignment Operators

### Item 8: Prevent exceptions from leaving destructors

If an operation may fail by throwing an exception and there may be a need to handle that exception, the exception has to come from some non-destructor function.

### Item 9: Never call virtual functions during construction or destruction

An object doesn’t become a derived class object until execution of a derived class constructor begins.

Upon entry to the base class destructor, the object becomes a base class object, and all parts of C++ - virtual functions, dynamic_casts, etc., - treat it that way.

## Chapter 3: Resource Management

### Item 14: Think carefully about copying behavior in resource-managing classes

    class Lock {
    public:
        explicit Lock(Mutex *pm)   // init shared_ptr with the Mutex
        : mutexPtr(pm, unlock)     // to point to and the unlock func as the deleter
        {
            lock(mutexPtr.get());
        }
    private:
        std::tr1::shared_ptr<Mutex> mutexPtr;
    };

If construction of a `std::tr1::shared_ptr` throws, the deleter is automatically called, but in this case, that will yield a call to `unlock` without a call to `lock` having been made. Such an unmatched call to `unlock` will also occur if the call to `lock` throws. fxw suggests this constructor rewrite:

    explicit Lock(Mutex *pm)
    {
        lock(pm);
        mutexPtr.reset(pm, unlock);
    }

There was no room in the book for this explanation, so I left the code in the book unchanged, but I added a footnote pointing to this errata entry.




