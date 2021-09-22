# [Overloading new and delete](https://stackoverflow.com/a/4421791)

- [Overloading new and delete](#overloading-new-and-delete)
  - [Basics](#basics)
  - [Placement new](#placement-new)
  - [Class-specific new and delete](#class-specific-new-and-delete)
  - [Global new and delete](#global-new-and-delete)

## Basics

In C++, when you write a **new expression** like `new T(arg)` two things happen when this expression is evaluated: First **`operator new`** is invoked to obtain raw memory, and then the appropriate constructor of **`T`** is invoked to turn this raw memory into a valid object. Likewise, when you delete an object, first its destructor is called, and then the memory is returned to **`operator delete`**.

C++ allows you to tune both of these operations: memory management and the construction/destruction of the object at the allocated memory. The latter is done by writing constructors and destructors for a class. Fine-tuning memory management is done by writing your own `operator new` and `operator delete`.

The first of the basic rules of operator overloading - **don't do it** - applies especially to overloading `new` and `delete`. Almost the only reasons to overload these operators are **performance problems** and **memory constraints**, and in many cases, other actions, like changes to the algorithms used, will provide a much higher cost/gain ratio than attempting to tweak memory management.

The C++ standard library comes with a set of **predefined `new` and `delete` operators**. The most important ones are these:

    void* operator new(std::size_t) throw(std::bad_alloc); 
    void  operator delete(void*) throw(); 
    void* operator new[](std::size_t) throw(std::bad_alloc); 
    void  operator delete[](void*) throw(); 

The first two allocate/deallocate memory for an object, the latter two for an array of objects. If you provide your own versions of these, they will **not overload, but replace** the ones from the standard library.

If you overload `operator new`, you should always also overload the matching `operator delete`, even if you never intend to call it. The reason is that, if a constructor throws during the evaluation of a new expression, the run-time system will return the memory to the `operator delete` matching the `operator new` that was called to allocate the memory to create the object in. If you do not provide a matching `operator delete`, the default one is called, which is almost always wrong.

If you overload `new` and `delete`, you should consider overloading the **array variants**, too.

## Placement new

C++ allows new and delete operators to take additional arguments.
So-called placement new allows you to create an object at a certain address which is passed to:

    class X { /* ... */ };
    char buffer[ sizeof(X) ];
    void f()
    { 
      X* p = new(buffer) X(/*...*/);
      // ... 
      p->~X(); // call destructor 
    } 

The standard library comes with the appropriate overloads of the new and delete operators for this:

    void* operator new(std::size_t,void* p) throw(std::bad_alloc); 
    void  operator delete(void* p,void*) throw(); 
    void* operator new[](std::size_t,void* p) throw(std::bad_alloc); 
    void  operator delete[](void* p,void*) throw(); 

Note that, in the example code for placement new given above, `operator delete` is never called, unless the constructor of X throws an exception.

You can also overload `new` and `delete` with other arguments. As with the **additional argument for placement new**, these arguments are also listed within parentheses after the keyword `new`. Merely for historical reasons, such variants are often **also called placement new**, even if their arguments are not for placing an object at a specific address.

## Class-specific new and delete

Most commonly you will want to fine-tune memory management because measurement has shown that instances of a specific class, or of a group of related classes, are created and destroyed often and that the default memory management of the run-time system, tuned for general performance, deals inefficiently in this specific case. To improve this, you can **overload new and delete for a specific class**:

    class my_class { 
      public: 
        // ... 
        void* operator new();
        void  operator delete(void*,std::size_t);
        void* operator new[](size_t);
        void  operator delete[](void*,std::size_t);
        // ... 
    }; 

Overloaded thus, new and delete behave like static member functions. For objects of `my_class`, the `std::size_t` argument will always be `sizeof(my_class)`. However, these operators are also called for dynamically allocated objects of **derived classes**, in which case it might be greater than that.

## Global new and delete

To overload the global new and delete, simply replace the pre-defined operators of the standard library with our own. However, this rarely ever needs to be done.
