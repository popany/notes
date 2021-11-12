# Effective C++

- [Effective C++](#effective-c)

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









