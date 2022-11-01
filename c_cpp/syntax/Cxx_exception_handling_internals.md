# [C++ exception handling internals](https://monoinfinito.wordpress.com/series/exception-handling-in-c/)

- [C++ exception handling internals](#c-exception-handling-internals)
  - [C++ exceptions under the hood](#c-exceptions-under-the-hood)
  - [C++ exceptions under the hood: a tiny ABI](#c-exceptions-under-the-hood-a-tiny-abi)
  - [C++ exceptions under the hood: an ABI to appease the linker](#c-exceptions-under-the-hood-an-abi-to-appease-the-linker)
  - [C++ exceptions under the hood: catching what you throw](#c-exceptions-under-the-hood-catching-what-you-throw)
  - [C++ exceptions under the hood: magic around `__cxa_begin_catch` and `__cxa_end_catch`](#c-exceptions-under-the-hood-magic-around-__cxa_begin_catch-and-__cxa_end_catch)
  - [C++ exceptions under the hood: `gcc_except_table` and the personality function](#c-exceptions-under-the-hood-gcc_except_table-and-the-personality-function)
  - [C++ exceptions under the hood: a nice personality](#c-exceptions-under-the-hood-a-nice-personality)
  - [C++ exceptions under the hood: two-phase handling](#c-exceptions-under-the-hood-two-phase-handling)
  - [C++ exceptions under the hood: catching our first exception](#c-exceptions-under-the-hood-catching-our-first-exception)
  - [C++ exceptions under the hood: _Unwind_ and call frame info](#c-exceptions-under-the-hood-unwind-and-call-frame-info)

## C++ exceptions under the hood

Everyone knows that good exception handling is hard. Reasons for this abound, in every single layer of an exception "lifetime": it's hard to write exception safe code, an exception might be thrown from unexpected places (pun intended!), it's can be complicated to understand badly designed exception hierarchies, it's slow because a lot of voodoo is happening under the hood, it's dangerous because improperly throwing an exception might call the unforgiving `std::terminate`. And although anyone who might have had to battle an "exceptional" program might know this, the reasons for this mess are not widespread knowledge.

The first question we need to ask ourselves is then, how does it all work. This is the first article on a long series, in which I'll be writing about how exceptions are implemented under the hood in c++ (actually, c++ compiled with gcc on x86 platforms but this might apply to other platforms too). On these articles the process of throwing and catching an exception will be explained with quite a lot of detail, but for the impatient people here is a small brief of all the articles that will follow: how is an exception thrown in gcc/x86:

1. When we write a `throw` statement, the compiler will translate it into a pair of calls into `libstdc++` functions that allocate the exception and then start the stack unwinding process by calling `libstdc`.

2. For each catch statement, the compiler will write some special information after the method's body, a table of exceptions this method can catch and a cleanup table (more on the cleanup table later).

3. As the unwinder goes through the stack it will call a special function provided by `libstdc++` (called personality routine) that checks for each function in the stack which exceptions can be caught.

4. If no matching catch is found for the exception, `std::terminate` is called.

5. If a matching catch is found, the unwinder now starts again on the top of the stack.

6. As the unwinder goes through the stack a second time it will ask the personality routine to perform a cleanup for this method.

7. The personality routine will check the cleanup table on the current method. If there are any cleanup actions to be run, it will "jump" into the current stack frame and run the cleanup code. This will run the destructor for each object allocated at the current scope.

8. Once the unwinder reaches the frame in the stack that can handle the exception it will jump into the proper catch statement.

9. Upon finishing the execution of the catch statement, a cleanup function will be called to release the memory held for the exception.

This already looks quite complicated and we haven't even started; that was but a short and inaccurate description of all the complexities needed to handle an exception.

To learn about all the details that happen under the hood on the next article we will start to implement our own mini `libstdlibc++ `. Not all of it though, only the part that handles exceptions. Actually not even all of that, only the bare minimum we need to make a simple `throw`/`catch` statement work. Some assembly will be needed, but nothing too fancy. A lot of patience will be required, I'm afraid.

If you are too curious and want to start reading about exception handling implementation then you can start here, for a full specification of what we are going to implement on the next few articles. I'll try to make these articles a bit more didactic and easier to follow though, so see you next time to start our ABI!

## C++ exceptions under the hood: a tiny ABI

If we are going to try and understand why exceptions are complex and how do they work, we can either read a lot of manuals or we can try to write something to handle the exceptions ourselves. Actually, I was surprised by the lack of good information on this topic: pretty much everything I found is either incredibly detailed or very basic, with one exception or two. Of course there are some specifications to implement (most notably the [ABI for c++](https://itanium-cxx-abi.github.io/cxx-abi/) but we also have [CFI](http://www.logix.cz/michal/devel/gas-cfi/), [DWARF](http://www.logix.cz/michal/devel/gas-cfi/dwarf-2.0.0.pdf) and `libstdc`) but reading the specification alone is not enough to really learn what's going on under the hood.

Let's start with the obvious then: wheel reinvention! We know for a fact that plain C doesn't handle exceptions, so let's try to link a throwing C++ program with a plain C linker and see what happens. I came up with something simple like this:

    #include "throw.h"
    extern "C" {
        void seppuku() {
            throw Exception();
        }
    }

Don't forget the extern stuff, otherwise g++ will helpfully mangle our little function's name and we won't be able to link it with our plain C program. Of course, we need a header file to "link" (no pun intended) the C++ world with the C world:

struct Exception {};
 
    #ifdef __cplusplus
    extern "C" {
    #endif
    
        void seppuku();
    
    #ifdef __cplusplus
    }
    #endif

And a very simple main:

    #include "throw.h"
    
    int main()
    {
        seppuku();
        return 0;
    }

What happens now if we try to compile and link together this frankencode?

    g++ -c -o throw.o -O0 -ggdb throw.cpp
    gcc -c -o main.o -O0 -ggdb main.c

Note: You can download the full sourcecode for this project [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v01).

So far so good. Both g++ and gcc are happy in their little world. Chaos will ensue once we try to link them, though:

    gcc main.o throw.o -o app
    throw.o: In function `foo()':
    throw.cpp:4: undefined reference to `__cxa_allocate_exception'
    throw.cpp:4: undefined reference to `__cxa_throw'
    throw.o:(.rodata._ZTI9Exception[typeinfo for Exception]+0x0): undefined reference to `vtable for __cxxabiv1::__class_type_info'
    collect2: ld returned 1 exit status

And sure enough, gcc complains about missing C++ symbols. Those are very special C++ symbols, though. Check the last error line: a `vtable for cxxabiv1` is missing. cxxabi, defined in libstdc++, refers to the application binary interface for C++. So now we have learned that the exception handling is done with some help of the standard C++ library with an interface defined by C++'s ABI.

The C++ ABI defines a standard binary format so we can link objects together in a single program; if we compile a `.o` file with two different compilers, and those compilers use a different ABI, we won't be able to link the `.o` objects into an application. The ABI will also define some other formats, like for example the interface to perform stack unwinding or the throwing of an exception. In this case, the ABI defines an interface (not necessarily a binary format, just an interface) between C++ and some other library in our program which will handle the stack unwinding, ie the ABI defines C++ specific stuff so it can talk to non-C++ libraries: this is what would enable exceptions thrown from other languages to be caught in C++, amongst other things.

In any case, the linker errors are pointing us to the first layer into exception handling under the hood: an interface we'll have to implement ourselves, the cxxabi. For the next article we'll be starting our own mini ABI, as defined in the C++ ABI.

## C++ exceptions under the hood: an ABI to appease the linker

On our journey to understand exceptions we discovered that the heavy-lifting is done in libstdc++ as specified by the C++ ABI. Reading some linker errors we deduced last time that for handling exceptions we need help from the C++ ABI; we created a throwing C++ program, linked it together with a plain C program and found that the compiler somehow translated our throw instruction into something that is now calling a few libstd++ functions to actually throw an exception. Lost already? You can check the sourcode for this project so far [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v01).

Anyway, we want to understand exactly how an exception is thrown, so we will try to implement our own mini-ABI, capable of throwing an exception. To do this, a lot of [RTFM](https://itanium-cxx-abi.github.io/cxx-abi/) is needed, but a full ABI interface can be found [here, for LLVM](http://libcxxabi.llvm.org/spec.html). Let's start by remembering what those missing functions are:

    gcc main.o throw.o -o app
    throw.o: In function `foo()':
    throw.cpp:4: undefined reference to `__cxa_allocate_exception'
    throw.cpp:4: undefined reference to `__cxa_throw'
    throw.o:(.rodata._ZTI9Exception[typeinfo for Exception]+0x0): undefined reference to `vtable for __cxxabiv1::__class_type_info'
    collect2: ld returned 1 exit status

- `__cxa_allocate_exception`

  The name is quite self explanatory, I guess. `__cxa_allocate_exception` receives a `size_t` and allocates enough memory to hold the exception being thrown. There is more to this that what you would expect: when an exception is being thrown some magic will be happening with the stack, so allocating stuff here is not a good idea. Allocating memory on the heap might also not be a good idea, though, because we might have to throw if we're out of memory. A static allocation is also not a good idea, since we need this to be thread safe (otherwise two throwing threads at the same time would equal disaster). Given these constraints, most implementations seem to allocate memory on a local thread storage (heap) but resort to an emergency storage (presumably static) if out of memory. We, of course, don't want to worry about the ugly details so we can just have a static buffer if we want to.


- `__cxa_throw`

  The function doing all the throw-magic! According to the ABI reference, once the exception has been created `__cxa_throw` will be called. This function will be responsible of starting the stack unwinding. An important effect of this: `__cxa_throw` is never supposed to return. It either delegates execution to the correct catch block to handle the exception or calls (by default) `std::terminate`, but it never ever returns.


- `vtable for __cxxabiv1::__class_type_info`

  A weird one... `__class_type_info` is clearly some sort of RTTI, but what exactly? It's not easy to answer this one now and it's not terribly important for our mini ABI; we'll leave it to an appendix for after we are done analyzing the process of throwing exceptions, for now let's just say this is the entry point the ABI defines to know (in runtime) whether two types are the same or not. This is the function that gets called to determine whether a catch(Parent) can handle a throw Child. For now we'll focus on the basics: we need to give it an address for the linker (ie defining it won't be enough, we need to instantiate it) and it has to have a `vtable` (that is, it must have a virtual method).


Lot's of stuff happen on these functions, but let's try to implement the simplest exception thrower possible: one that will call exit when an exception is thrown. Our application was almost OK but missing some ABI-stuff, so let's create a `mycppabi.cpp`. Reading our ABI specification we can figure out the signatures for `__cxa_allocate_exception` and `__cxa_throw`:

    #include
    #include
    #include 
    
    namespace __cxxabiv1 {
        struct __class_type_info {
            virtual void foo() {}
        } ti;
    }
    
    #define EXCEPTION_BUFF_SIZE 255
    char exception_buff[EXCEPTION_BUFF_SIZE];
    
    extern "C" {
    
    void* __cxa_allocate_exception(size_t thrown_size)
    {
        printf("alloc ex %i\n", thrown_size);
        if (thrown_size > EXCEPTION_BUFF_SIZE) printf("Exception too big");
        return &exception_buff;
    }
    
    void __cxa_free_exception(void *thrown_exception);
    
    #include
    void __cxa_throw(
              void* thrown_exception,
              struct type_info *tinfo,
              void (*dest)(void*))
    {
        printf("throw\n");
        // __cxa_throw never returns
        exit(0);
    }
    
    } // extern "C"

Note: You can download the full sourcecode for this project [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v01).

If we now compile `mycppabi.cpp` and link it with the other two `.o` files, we'll get a working binary which should print "alloc ex 1\nthrow" and then exit. Pretty simple, but an amazing feat nonetheless: we've managed to throw an exception without calling libc++. We've written a (very small) part of a C++ ABI!

Another important bit of wisdom we gained by creating our own mini ABI: **the throw keyword is compiled into two function calls to libstdc++**. No voodoo there, it's actually a pretty simple transformation. We can even disassemble our throwing function to verify it. Let's run this command "g++ -S throw.cpp".

    seppuku:
    .LFB3:
        [...]
        call    __cxa_allocate_exception
        movl    $0, 8(%esp)
        movl    $_ZTI9Exception, 4(%esp)
        movl    %eax, (%esp)
        call    __cxa_throw
        [...]

Even more magic happening: when the throw keyword gets translated into these two calls, the compiler doesn't even know how the exception is going to be handled. Since libstdc++ is the one defining `__cxa_throw` and friends, and libstdc++ is dynamically linked on runtime, the exception handling method could be chosen when we first run our executable.

We are now seeing some progress but we still have a long way to go. Our ABI can only throw exceptions right now. Can we extend it to handle a catch as well? We'll see how next time.

## C++ exceptions under the hood: catching what you throw

In this series about exception handling, we have discovered quite a bit about exception throwing by looking at compiler and linker errors but we have so far not learned anything yet about exception catching. Let's sum up the few things we learned about exception throwing:

- A `throw` statement will be translated by the compiler into two calls, `__cxa_allocate_exception` and `__cxa_throw`.

- `__cxa_allocate_exception` and `__cxa_throw` "live" on `libstdc++`

- `__cxa_allocate_exception` will allocate memory for the new exception.

- `__cxa_throw` will prepare a bunch of stuff and forward this exception to `_Unwind_`, a set of functions that live in `libstdc` and perform the real stack unwinding (the ABI defines the interface for these functions).

Quite simple so far, but exception catching is a bit more complicated, specially because it requires certain degree of reflexion (that is, the ability of a program to analyze its own source code). Let's keep on trying our same old method, let's add some catch statements throughout our code, compile it and see what happens:

    #include "throw.h"
    #include 
    
    // Notice we're adding a second exception type
    struct Fake_Exception {};
    
    void raise() {
        throw Exception();
    }
    
    // We will analyze what happens if a try block doesn't catch an exception
    void try_but_dont_catch() {
        try {
            raise();
        } catch(Fake_Exception&) {
            printf("Running try_but_dont_catch::catch(Fake_Exception)\n");
        }
    
        printf("try_but_dont_catch handled an exception and resumed execution");
    }
    
    // And also what happens when it does
    void catchit() {
        try {
            try_but_dont_catch();
        } catch(Exception&) {
            printf("Running try_but_dont_catch::catch(Exception)\n");
        } catch(Fake_Exception&) {
            printf("Running try_but_dont_catch::catch(Fake_Exception)\n");
        }
    
        printf("catchit handled an exception and resumed execution");
    }
    
    extern "C" {
        void seppuku() {
            catchit();
        }
    }

Note: You can download the full sourcecode for this project [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v02).

Just like before, we have our `seppuku` function linking the C world with the C++ world, only this time we have added some more function calls to make our stack more interesting, plus we have added a bunch of `try`/`catch` blocks so we can analyze how does `libstdc++` handles them.

And just like before, we get some linker errors about missing ABI functions:

    g++ -c -o throw.o -O0 -ggdb throw.cpp
    gcc main.o throw.o mycppabi.o -O0 -ggdb -o app
    throw.o: In function `try_but_dont_catch()':
    throw.cpp:12: undefined reference to `__cxa_begin_catch'
    throw.cpp:12: undefined reference to `__cxa_end_catch'
    
    throw.o: In function `catchit()':
    throw.cpp:20: undefined reference to `__cxa_begin_catch'
    throw.cpp:20: undefined reference to `__cxa_end_catch'
    
    throw.o:(.eh_frame+0x47): undefined reference to `__gxx_personality_v0'
    
    collect2: ld returned 1 exit status

Again we see a lot of interesting stuff going on here. The calls to `__cxa_begin_catch` and `__cxa_end_catch` are probably something we could have expected: we don't know what they are yet, but we can presume they are the equivalent of the `throw`/`__cxa_allocate`/`throw` conversions (you do remember that our `throw` keyword got translated to a pair of `__cxa_allocate_exception` and `__cxa_throw` functions, right?). The `__gxx_personality_v0` thing is new, though, and the central piece of the next few articles.

What does the personality function do? We already said something about it on the introduction to this series but we will be looking into it with some more detail next time, together with our new two friends, `__cxa_begin_catch` and `__cxa_end_catch`.

## C++ exceptions under the hood: magic around `__cxa_begin_catch` and `__cxa_end_catch`

After learning how exceptions are thrown we are now on our way to learn how they are caught. Last time we added to our example application a bunch of `try`/`catch` statements to see what they did, and sure enough we got a bunch of linker errors, just like we did when we were trying to find out what does the throw statement do. This is what the linker says when trying to process `throw.o`:

Note: You can download the full sourcecode for this project [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v02).

    g++ -c -o throw.o -O0 -ggdb throw.cpp
    gcc main.o throw.o mycppabi.o -O0 -ggdb -o app
    throw.o: In function `try_but_dont_catch()':
    throw.cpp:12: undefined reference to `__cxa_begin_catch'
    throw.cpp:12: undefined reference to `__cxa_end_catch'
    
    throw.o: In function `catchit()':
    throw.cpp:20: undefined reference to `__cxa_begin_catch'
    throw.cpp:20: undefined reference to `__cxa_end_catch'
    
    throw.o:(.eh_frame+0x47): undefined reference to `__gxx_personality_v0'
    
    collect2: ld returned 1 exit status

And our theory, of course, is that a catch statement is translated by the compiler into a pair of `__cxa_begin_catch/end_catch` calls into `libstdc++`, plus something new called the personality function of which we know nothing yet.

Let's begin by checking if our theory about `__cxa_begin_catch` and `__cxa_end_catch` holds. Let's compile `throw.cpp` with `-S` and analyze the assembly. There is a lot to see but if I strip it to the bare minimum this is what I get:

    _Z5raisev:
        call    __cxa_allocate_exception
        call    __cxa_throw

So far so good: the same old definition we got for `raise()`, just throw an exception.

    _Z18try_but_dont_catchv:
        .cfi_startproc
        .cfi_personality 0,__gxx_personality_v0
        .cfi_lsda 0,.LLSDA1

The definition for `try_but_dont_catch()`, mangled by the compiler. There is something new, though: a reference to `__gxx_personality_v0` and to something else called LSDA. These are seemingly innocent declarations but they are actually quite important:

- The linker will use these according to a CFI specification; CFI stands for call frame information, and [here](http://www.logix.cz/michal/devel/gas-cfi/) there is a full spec for it. It will be used, mostly, to unwind the stack.

- LSDA on the other hand means language specific data area, and it will be used by the personality function to know which exceptions can be handled by this function

We'll be talking a lot more about CFI and LSDA in the next articles; don’t forget about them, but for now let’s move on:

    [...]
    call    _Z5raisev
    jmp .L8

Another easy one: just call "raise", and then `jump` to `L8; `L8` will return normally from this function. If `raise` didn't execute properly then the execution (somehow, we don't know how yet!) shouldn't resume in the next instruction but in the exception handlers (which in ABI-speak are **called landing pads**. More on that later).

        cmpl    $1, %edx
        je  .L5
    
    .LEHB1:
        call    _Unwind_Resume
    .LEHE1:
    
    .L5:
        call    __cxa_begin_catch
        call    __cxa_end_catch

This is quite difficult to follow but it's actually quite straight forward. Here most of the magic will happen: first we check if this is an exception we can handle, if we can't then we say so by calling `_Unwind_Resume`, if it is then we call `__cxa_begin_catch` and `__cxa_end_catch`; after calling these functions the execution should resume normally and thus `L8` will be executed (that is, `L8` is right below our `catch` block):

    .L8:
        leave
        .cfi_restore 5
        .cfi_def_cfa 4, 4
        ret
        .cfi_endproc

Just a normal return from our function... with some CFI stuff on it.

So this is it for exception catching, although we don't know yet how `__cxa_begin/end_catch` work, we have an idea that these pair forms what's called a landing pad, a place in the function to handle the raised exception. What we don't know yet is how the landing pads are found. `_Unwind_` must somehow go through all the calls in the stack, check if any call (stack frame, to be precise) has a valid `try` block with a landing pad that can `catch` the exception, and then resume the execution there.

This is no small feat, and we'll see how that works next time.

## C++ exceptions under the hood: `gcc_except_table` and the personality function

We learned last time that, just as a `throw` statement is translated into a pair of `__cxa_allocate_exception/throw` calls, a catch block is translated into a pair of `__cxa_begin/end_catch` calls, plus something called CFI (call frame information) to find the landing pads, the points on a function where an exception can be handled.

What we don't yet know is how does `_Unwind_*` know where the landing pads are. When an exception is thrown there are a bunch of functions in the stack; all the CFI stuff will let Unwind know which functions these are but it's also necessary to know which landing pads each function provides so we can call each one and check if it wants to handle the exception (and we're ignoring functions with multiple `try/catch` blocks!).

To know where the landing pads are, something called `gcc_except_table` is used. This can be found (with a bunch of CFI stuff) after the function's end:

    .LFE1:
        .globl  __gxx_personality_v0
        .section    .gcc_except_table,"a",@progbits
        [...]
    .LLSDACSE1:
        .long   _ZTI14Fake_Exception

The section `.gcc_except_table` is where **all information to locate a landing pad is stored**, and we'll see more about it once we get to analyzing the personality function; for now, we'll just say that LSDA means language specific data area and it's the place where the personality function will check if there are any landing pads for a function (it is also used to run the destructors when unwinding the stack).

To wrap it up: for every function where at least a `catch` is found, the compiler will translate this statement into a pair of `__cxa_begin_catch/__cxa_end_catch` calls and then the personality function, which will be called by `__cxa_throw`, will read the `gcc_except_table` for every method in the stack, to find something call LSDA. The personality function will then check in the LSDA whether a catch can handle an exception and if there is any cleanup code to run (this is what triggers the destructors when needed).

We can also draw an interesting conclusion here: if we use the nothrow specifier (or the empty throw specifier) then the compiler can omit the `gcc_except_table` for this method. The way gcc implements exceptions, that won't have a great impact on performance but it will indeed reduce code size. What's the `catch`? If an exception is thrown when `nothrow` was specified the LSDA won't be there and the personality function won't know what to do. When the personality function doesn't know what to do it will invoke the default exception handler, meaning that in most cases throwing from a `nothrow` method will end up calling `std::terminate`.

Now that we have an idea of what the personality function does, can we implement one? We'll see how next time.

## C++ exceptions under the hood: a nice personality

On our journey to learn about exceptions we have learned so far how a `throw` is done, that something called "call frame information" helps a library called Unwind to do the stack unwinding, and that the compiler writes something called LSDA, language specific data area, to know which exceptions can a method handle. And we know by now that a lot of magic is done on the personality function; we've never seen it in action though. Let's recap in a bit more of detail about how an exception will be thrown and catched (or, more precisely, how we know so far it will be thrown catched):

- The compiler will translate our throw statement into a pair of `__cxa_allocate_exception/__cxa_throw`

- `__cxa_allocate_exception` will create the exception in memory

- `__cxa_throw` will initialize a bunch of stuff and forward this exception to a lower-level unwind library by calling `_Unwind_RaiseException`

- Unwind will use CFI to know which functions are on the stack (ie to know how to start the stack unwinding)

- Each function will have an LSDA (language specific data area) part, added into something called ".gcc_except_table"

- Unwind will invoke the personality function with the current stack frame and the LSDA; this function should reply to unwind whether this stack can handle the exception or not

Knowing this, it's about time we implement our own personality function. Our ABI used to print this when an exception was thrown:

    alloc ex 1
    __cxa_throw called
    no one handled __cxa_throw, terminate!

Let's go back to our `mycppabi` and let's add something like this (link to full `mycppabi.cpp` file):

    void __gxx_personality_v0()
    {
        printf("Personality function FTW\n");
    }

Note: You can download the full sourcecode for this project [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v02).

And sure enough, when we run it we should see our personality function being called. We know we're on the right track and now we have an idea of what we want for our personality function; let's start using the proper definition for this function:

    _Unwind_Reason_Code __gxx_personality_v0 (
                        int version, _Unwind_Action actions, uint64_t exceptionClass,
                        _Unwind_Exception* unwind_exception, _Unwind_Context* context);

If we put that into our `mycppabi.cpp` file we get:

    #include
    #include
    #include
    #include 
    
    namespace __cxxabiv1 {
        struct __class_type_info {
            virtual void foo() {}
        } ti;
    }
    
    #define EXCEPTION_BUFF_SIZE 255
    char exception_buff[EXCEPTION_BUFF_SIZE];
    
    extern "C" {
    
    void* __cxa_allocate_exception(size_t thrown_size)
    {
        printf("alloc ex %i\n", thrown_size);
        if (thrown_size > EXCEPTION_BUFF_SIZE) printf("Exception too big");
        return &exception_buff;
    }
    
    void __cxa_free_exception(void *thrown_exception);
    
    #include 
    
    typedef void (*unexpected_handler)(void);
    typedef void (*terminate_handler)(void);
    
    struct __cxa_exception {
        std::type_info *    exceptionType;
        void (*exceptionDestructor) (void *);
        unexpected_handler  unexpectedHandler;
        terminate_handler   terminateHandler;
        __cxa_exception *   nextException;
    
        int         handlerCount;
        int         handlerSwitchValue;
        const char *        actionRecord;
        const char *        languageSpecificData;
        void *          catchTemp;
        void *          adjustedPtr;
    
        _Unwind_Exception   unwindHeader;
    };
    
    void __cxa_throw(void* thrown_exception, struct type_info *tinfo, void (*dest)(void*))
    {
        printf("__cxa_throw called\n");
    
        __cxa_exception *header = ((__cxa_exception *) thrown_exception - 1);
        _Unwind_RaiseException(&header->unwindHeader);
    
        // __cxa_throw never returns
        printf("no one handled __cxa_throw, terminate!\n");
        exit(0);
    }
    
    void __cxa_begin_catch()
    {
        printf("begin FTW\n");
    }
    
    void __cxa_end_catch()
    {
        printf("end FTW\n");
    }
    
    _Unwind_Reason_Code __gxx_personality_v0 (
                        int version, _Unwind_Action actions, uint64_t exceptionClass,
                        _Unwind_Exception* unwind_exception, _Unwind_Context* context)
    {
        printf("Personality function FTW!\n");
    }
    
    }

Let's compile and link everything, then run it and start by analyzing each param to this function with some help of gdb:

    Breakpoint 1, __gxx_personality_v0 (version=1, actions=1, exceptionClass=134514792, unwind_exception=0x804a060, context=0xbffff0f0)

- The `version` and the `exceptionClass` are related to language/ABI/compiler toolchain/native or non-native exception, etc. We don't need to worry about it for our mini ABI, we'll just handle all the exceptions.

- Actions: this is what `_Unwind_` uses to tell the personality function what it should do (more on that later)

- `unwind_exception`: the exception allocated by `__cxa_allocate_exception` (kind of... there's a lot of pointer arithmetic going on but that pointer can be used to access our original exception anyway)

- `context`: this holds all the information regarding the current stack frame, for example the language specific data area (LSDA). This is what we will be using to detect whether this stack can handle the thrown exception (and also to detect whether we need to run any destructors)

So there we have it, a working (well, linkeable) personality function. Doesn’t do much, though, so next time we'll start adding some real behavior and try to make it handle an exception.

## C++ exceptions under the hood: two-phase handling

We finished last chapter on the series about C++ exceptions by adding a personality function that `_Unwind_` was able to call. It didn't do much but there it was. The ABI we have been implementing can now throw exceptions and the catch is already halfway implemented, but the personality function needed to properly choose the catch block (landing pad) is bit dumb so far. Let's start this new chapter by trying to understand what are the parameters that the personality function receives and next time we'll begin adding some real behavior to `__gxx_personality_v0`: when `__gxx_personality_v0` is called we should say "yes, this stack frame can indeed handle this exception".

We already said we won't care for the version or the `exceptionClass` for our mini ABI. Let's ignore the context too, for now: we'll just handle every exception with the first stack frame above the function throwing; note this implies there must be a try/catch block on the function immediately above the throwing function, otherwise everything will break. This also implies the catch will ignore its exception specification, effectively turning it into a catch(...). How do we let `_Unwind_` know we want to handle the current exception?

`_Unwind_Reason_Code` is the return value from the personality functions; this tells `_Unwind_` whether we found a landing pad to handle the exception or not. Let's implement our personality function to return `_URC_HANDLER_FOUND` then, and see what happens:

    alloc ex 1
    __cxa_throw called
    Personality function FTW
    Personality function FTW
    no one handled __cxa_throw, terminate!

See that? We told `_Unwind_` we found a handler, and it called the personality function yet again! What is going on there?

Remember the action parameter? That's how `_Unwind_` tells us what he is expecting, and that is because the **exception catching is handled in two phases: lookup and cleanup** (or `_UA_SEARCH_PHASE` and `_UA_CLEANUP_PHASE`). Let's go again over our exception throwing and catching recipe:

- `__cxa_throw/__cxa_allocate_exception` will create an exception and forward it to a lower-level unwind library by calling `_Unwind_RaiseException`

- Unwind will use CFI to know which functions are on the stack (ie to know how to start the stack unwinding)

- Each function has have an LSDA (language specific data area) part, added into something called ".gcc_except_table"

- Unwind will try to locate a **landing pad** for the exception:

  - Unwind will call the personality function with the action `_UA_SEARCH_PHASE` and a context pointing to the current stack frame.

  - The personality function will check if the current stack frame can handle the exception being thrown by analyzing the LSDA.

  - If the exception can be handled it will return `_URC_HANDLER_FOUND`.

  - If the exception can not be handled it will return `_URC_CONTINUE_UNWIND` and Unwind will then try the next stack frame.

- If no landing pad was found, the default exception handler will be called (normally `std::terminate`).

- If a landing pad was found:

  - Unwind will iterate the stack again, calling the personality function with the action `_UA_CLEANUP_PHASE`.

  - The personality function will check if it can handle the current exception again:

  - If this frame can't handle the exception it will then run a cleanup function described by the LSDA and tell Unwind to continue with the next frame (this is actually a very important step: the cleanup function will run the destructor of all the objects allocated in this stack frame!)

  - If this frame can handle the exception, don't run any cleanup code: tell Unwind we want to resume execution on this landing pad.

There are two important bits of information to note here:

- Running a two-phase exception handling procedure means that in case no handler was found then the default exception handler can get the original exception's stack trace (if we were to unwind the stack as we go it would get no stack trace, or we would need to keep a copy of it somehow!).

- Running a `_UA_CLEANUP_PHASE` and calling a second time each frame, even though we already know the frame that will handle the exception, is also really important: the personality function will take this chance to run all the destructors for objects built on this scope. It is what makes RAII an exception safe idiom!

Now that we understand how the catch lookup phase works we can continue our personality function implementation. The next time.

## C++ exceptions under the hood: catching our first exception

We finished last chapter on the series about C++ exceptions by adding a personality function that `_Unwind_` was able to call and then analyzing the parameters that the personality function receives. Now it's time to begin adding some real behavior to `__gxx_personality_v0`: when `__gxx_personality_v0` is called we should say "yes, this stack frame can indeed handle this exception".

We have been building up to this point quite a bit: the time where we can implement for the first time a personality function capable of detecting when an exception is thrown, and then saying "yes, I will handle this exception". For that we had to learn how the two-phase lookup work, so we can now reimplement our personality function and our throw test file:

    #include
    #include "throw.h"
     
    struct Fake_Exception {};
     
    void raise() {
        throw Exception();
    }
     
    void try_but_dont_catch() {
        try {
            raise();
        } catch(Fake_Exception&) {
            printf("Caught a Fake_Exception!\n");
        }
     
        printf("try_but_dont_catch handled the exception\n");
    }
     
    void catchit() {
        try {
            try_but_dont_catch();
        } catch(Exception&) {
            printf("Caught an Exception!\n");
        }
     
        printf("catchit handled the exception\n");
    }
     
    extern "C" {
        void seppuku() {
            catchit();
        }
    }

And our personality function:

    _Unwind_Reason_Code __gxx_personality_v0 (
                        int version, _Unwind_Action actions, uint64_t exceptionClass,
                        _Unwind_Exception* unwind_exception, _Unwind_Context* context)
    {
        if (actions & _UA_SEARCH_PHASE)
        {
            printf("Personality function, lookup phase\n");
            return _URC_HANDLER_FOUND;
        } else if (actions & _UA_CLEANUP_PHASE) {
            printf("Personality function, cleanup\n");
            return _URC_INSTALL_CONTEXT;
        } else {
            printf("Personality function, error\n");
            return _URC_FATAL_PHASE1_ERROR;
        }
    }

Note: You can download the full sourcecode for this project [in my github repo](https://github.com/nicolasbrailo/cpp_exception_handling_abi/tree/master/abi_v03).

Let's run it, see what happens:

    alloc ex 1
    __cxa_throw called
    Personality function, lookup phase
    Personality function, cleanup
    try_but_dont_catch handled the exception
    catchit handled the exception

It works, but something is missing: the `catch` inside the `catch/try` block is not being executed! This is happening because the personality function tells Unwind to "install a context" (ie to resume execution) but it never says which context. In this case it's probably resuming executing from after the landing pad, but I'd bet this is actually undefined behavior. We'll see next time how we can specify we want to resume executing from a specific landing pad using the information available on `.gcc_except_table` (our old friend, the LSDA).

## C++ exceptions under the hood: _Unwind_ and call frame info

TODO xxxxxxxxxxxxxxxxxxxxxxxxxxxxx







