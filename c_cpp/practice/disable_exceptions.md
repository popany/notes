# Disable Exceptions

- [Disable Exceptions](#disable-exceptions)
  - [Disabling C++ exceptions, how can I make any `std:: throw()` immediately terminate?](#disabling-c-exceptions-how-can-i-make-any-std-throw-immediately-terminate)
  - [mock `__cxa_xxx`](#mock-__cxa_xxx)
    - [Code](#code)
    - [compile](#compile)
    - [run](#run)

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
    __cxa_throw

https://github.com/llvm-mirror/libcxxabi/blob/master/src/cxa_exception.cpp

https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/libsupc%2B%2B/eh_throw.cc

### Code

[stackstrace.h](https://panthema.net/2008/0901-stacktrace-demangled/stacktrace.h)

    // stacktrace.h (c) 2008, Timo Bingmann from http://idlebox.net/
    // published under the WTFPL v2.0
    
    #ifndef _STACKTRACE_H_
    #define _STACKTRACE_H_
    
    #include <stdio.h>
    #include <stdlib.h>
    #include <execinfo.h>
    #include <cxxabi.h>
    
    /** Print a demangled stack backtrace of the caller function to FILE* out. */
    static inline void print_stacktrace(FILE *out = stderr, unsigned int max_frames = 63)
    {
        fprintf(out, "stack trace:\n");
    
        // storage array for stack trace address data
        void* addrlist[max_frames+1];
    
        // retrieve current stack addresses
        int addrlen = backtrace(addrlist, sizeof(addrlist) / sizeof(void*));
    
        if (addrlen == 0) {
    	fprintf(out, "  <empty, possibly corrupt>\n");
    	return;
        }
    
        // resolve addresses into strings containing "filename(function+address)",
        // this array must be free()-ed
        char** symbollist = backtrace_symbols(addrlist, addrlen);
    
        // allocate string which will be filled with the demangled function name
        size_t funcnamesize = 256;
        char* funcname = (char*)malloc(funcnamesize);
    
        // iterate over the returned symbol lines. skip the first, it is the
        // address of this function.
        for (int i = 1; i < addrlen; i++)
        {
    	char *begin_name = 0, *begin_offset = 0, *end_offset = 0;
    
    	// find parentheses and +address offset surrounding the mangled name:
    	// ./module(function+0x15c) [0x8048a6d]
    	for (char *p = symbollist[i]; *p; ++p)
    	{
    	    if (*p == '(')
    		begin_name = p;
    	    else if (*p == '+')
    		begin_offset = p;
    	    else if (*p == ')' && begin_offset) {
    		end_offset = p;
    		break;
    	    }
    	}
    
    	if (begin_name && begin_offset && end_offset
    	    && begin_name < begin_offset)
    	{
    	    *begin_name++ = '\0';
    	    *begin_offset++ = '\0';
    	    *end_offset = '\0';
    
    	    // mangled name is now in [begin_name, begin_offset) and caller
    	    // offset in [begin_offset, end_offset). now apply
    	    // __cxa_demangle():
    
    	    int status;
    	    char* ret = abi::__cxa_demangle(begin_name,
    					    funcname, &funcnamesize, &status);
    	    if (status == 0) {
    		funcname = ret; // use possibly realloc()-ed string
    		fprintf(out, "  %s : %s+%s\n",
    			symbollist[i], funcname, begin_offset);
    	    }
    	    else {
    		// demangling failed. Output function name as a C function with
    		// no arguments.
    		fprintf(out, "  %s : %s()+%s\n",
    			symbollist[i], begin_name, begin_offset);
    	    }
    	}
    	else
    	{
    	    // couldn't parse the line? print the whole line.
    	    fprintf(out, "  %s\n", symbollist[i]);
    	}
        }
    
        free(funcname);
        free(symbollist);
    }
    
    #endif // _STACKTRACE_H_

mythrow.cc

    #include <dlfcn.h>
    #include <stdio.h>
    #include "stacktrace.h"
    
    extern "C" {
    
    typedef void (*FuncCxaThrow)(void* thrown_exception, struct type_info *tinfo, void (*dest)(void*));
    FuncCxaThrow real_cxa_throw = 0;
    
    int init() {
        real_cxa_throw = (FuncCxaThrow)dlsym(RTLD_NEXT, "__cxa_throw");
        return 0;
    }
    
    void __cxa_throw(void* thrown_exception, struct type_info *tinfo, void (*dest)(void*)) {
        static bool initialized = init();
        fprintf(stderr, "__cxa_throw called\n");
        print_stacktrace();
        real_cxa_throw(thrown_exception, tinfo, dest);
    }
    
    }

main.cc

    #include <iostream>
    #include <dlfcn.h>
    
    void foo() {
        throw "xxx";
    }
    void bar() {
        foo();
    }
    
    int main() {
        try {
            bar();
        } catch (...) {
            std::cout << "exception catched" << std::endl;
        }
    
        return 0;
    }

### compile

    g++ -shared -o libmythrow.so mythrow.cc -fPIC -ldl 
    g++ -g -o test main.cc -rdynamic

### run

    LD_PRELOAD=./libmythrow.so ./test
    __cxa_throw called
    stack trace:
      ./libmythrow.so : __cxa_throw()+0x96
      ./test : bar()+0
      ./test : bar()+0x9
      ./test : main()+0xe
      /lib/x86_64-linux-gnu/libc.so.6 : __libc_start_main()+0xf0
      ./test : _start()+0x29
    exception catched
