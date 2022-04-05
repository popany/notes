# mock function

- [mock function](#mock-function)
  - [mock function `foo` at link time](#mock-function-foo-at-link-time)
  - [mock `malloc`/`free`](#mock-mallocfree)
    - [mymalloc.c](#mymallocc)
    - [fix segfault in runtime case](#fix-segfault-in-runtime-case)

## mock function `foo` at link time

reference: [How to wrap functions with the `--wrap` option correctly?](https://stackoverflow.com/questions/46444052/how-to-wrap-functions-with-the-wrap-option-correctly)

main.c:

    #include <stdio.h>
    extern int foo();
    extern int __real_foo();

    int __wrap_foo() {
        printf("wrap foo\n");
        return 0;
    }

    int main () {
        printf("foo:");foo();
        printf("wrapfoo:");__wrap_foo();
        printf("realfoo:");__real_foo();
        return 0;
    }

foo.c:

    #include <stdio.h>
    int foo() {
        printf("foo\n");
        return 0;
    }

Then compile:

    gcc main.c foo.c -Wl,--wrap=foo -o main

And the the amazing output after running ./main:

    foo:wrap foo
    wrapfoo:wrap foo
    realfoo:foo

## mock `malloc`/`free`

reference:

[Overriding 'malloc' using the LD_PRELOAD mechanism](https://stackoverflow.com/questions/6083337/overriding-malloc-using-the-ld-preload-mechanism)

### [mymalloc.c](http://www.cs.cmu.edu/afs/cs/academic/class/15213-s03/src/interposition/mymalloc.c)

    /* 
     * mymalloc.c - Examples of run-time, link-time, and compile-time 
     *              library interposition. 
     */
    
    #ifdef RUNTIME
    /*
     * Run-time interposition of malloc and free based 
     * on the dynamic linker's (ld-linux.so) LD_PRELOAD mechanism
     * 
     * Example (Assume a.out calls malloc and free):
     *   linux> gcc -O2 -Wall -o mymalloc.so -shared mymalloc.c
     *
     *   tcsh> setenv LD_PRELOAD "/usr/lib/libdl.so ./mymalloc.so"
     *   tcsh> ./a.out
     *   tcsh> unsetenv LD_PRELOAD
     * 
     *   ...or 
     * 
     *   bash> (LD_PRELOAD="/usr/lib/libdl.so ./mymalloc.so" ./a.out)    
     */
    
    #include <stdio.h>
    #include <dlfcn.h>
    
    void *malloc(size_t size)
    {
        static void *(*mallocp)(size_t size);
        char *error;
        void *ptr;
    
        /* get address of libc malloc */
        if (!mallocp) {
            mallocp = dlsym(RTLD_NEXT, "malloc");
            if ((error = dlerror()) != NULL) {
                fputs(error, stderr);
                exit(1);
            }
        }
        ptr = mallocp(size);
        printf("malloc(%d) = %p\n", size, ptr);     
        return ptr;
    }
    
    void free(void *ptr)
    {
        static void (*freep)(void *);
        char *error;
    
        /* get address of libc free */
        if (!freep) {
            freep = dlsym(RTLD_NEXT, "free");
            if ((error = dlerror()) != NULL) {
                fputs(error, stderr);
                exit(1);
            }
        }
        printf("free(%p)\n", ptr);     
        freep(ptr);
    }
    #endif
    
    
    #ifdef LINKTIME
    /* 
     * Link-time interposition of malloc and free using the static
     * linker's (ld) "--wrap symbol" flag.
     * 
     * Compile the executable using "-Wl,--wrap,malloc -Wl,--wrap,free".
     * This tells the linker to resolve references to malloc as
     * __wrap_malloc, free as __wrap_free, __real_malloc as malloc, and
     * __real_free as free.
     */
    #include <stdio.h>
    
    void *__real_malloc(size_t size);
    void __real_free(void *ptr);
    
    
    /* 
     * __wrap_malloc - malloc wrapper function 
     */
    void *__wrap_malloc(size_t size)
    {
        void *ptr = __real_malloc(size);
        printf("malloc(%d) = %p\n", size, ptr);
        return ptr;
    }
    
    /* 
     * __wrap_free - free wrapper function 
     */
    void __wrap_free(void *ptr)
    {
        __real_free(ptr);
        printf("free(%p)\n", ptr);
    }
    #endif
    
    
    #ifdef COMPILETIME
    /*
     * Compile-time interposition of malloc and free using C
     * preprocessor. A local malloc.h file defines malloc (free) as
     * wrappers mymalloc (myfree) respectively. 
     */
    
    #include <stdio.h>
    #include <malloc.h>
    
    /* 
     * mymalloc - malloc wrapper function 
     */
    void *mymalloc(size_t size, char *file, int line)
    {
        void *ptr = malloc(size);
        printf("%s:%d: malloc(%d)=%p\n", file, line, size, ptr); 
        return ptr;
    } 
    
    /* 
     * myfree - free wrapper function 
     */
    void myfree(void *ptr, char *file, int line)
    {
        free(ptr);
        printf("%s:%d: free(%p)\n", file, line, ptr); 
    }
    #endif

### fix segfault in runtime case

reference:

1. https://stackoverflow.com/a/10008252

   The segfault was caused by dlsym calling calloc for 32 bytes, causing a recursion to the end of the stack.

   My solution was to create a super-simple static allocator that takes care of allocations before dlsym returns the malloc function pointer.

mymalloc.c

    #define _GNU_SOURCE
    #include <dlfcn.h>
    #include <stddef.h>
    #include <stdio.h>
    #include <stdlib.h>
    
    char tmpbuff[1024];
    unsigned long tmppos = 0;
    unsigned long tmpallocs = 0;
    
    void *memset(void*,int,size_t);
    void *memmove(void *to, const void *from, size_t size);
    
    /*=========================================================
     * interception points
     */
    
    static void * (*real_calloc)(size_t nmemb, size_t size);
    static void * (*real_malloc)(size_t size);
    static void   (*real_free)(void *ptr);
    static void * (*real_realloc)(void *ptr, size_t size);
    static void * (*real_aligned_alloc)(size_t alignment, size_t size);
    
    static void init()
    {
        real_malloc = dlsym(RTLD_NEXT, "malloc");
        real_free = dlsym(RTLD_NEXT, "free");
        real_calloc = dlsym(RTLD_NEXT, "calloc");
        real_realloc = dlsym(RTLD_NEXT, "realloc");
        real_aligned_alloc = dlsym(RTLD_NEXT, "aligned_alloc");
    
        if (!real_malloc || !real_free || !real_calloc || !real_realloc || !real_aligned_alloc)
        {
            fprintf(stderr, "Error in `dlsym`: %s\n", dlerror());
            exit(1);
        }
    }
    
    void *malloc(size_t size)
    {
        static int initializing = 0;
        if (real_malloc == NULL) {
            if (!initializing) {
                initializing = 1;
                init();
                initializing = 0;
    
                fprintf(stdout, "jcheck: allocated %lu bytes of temp memory in %lu chunks during initialization\n", tmppos, tmpallocs);
            } else {
                if (tmppos + size < sizeof(tmpbuff)) {
                    void *retptr = tmpbuff + tmppos;
                    tmppos += size;
                    ++tmpallocs;
                    return retptr;
                } else {
                    fprintf(stdout, "jcheck: too much memory requested during initialisation - increase tmpbuff size\n");
                    exit(1);
                }
            }
        }
    
        void *ptr = real_malloc(size);
        fprintf(stderr, "malloc(%zd) = %p\n", size, ptr);
        return ptr;
    }
    
    void free(void *ptr)
    {
        // something wrong if we call free before one of the allocators!
        // if (real_malloc == NULL)
        //     init();
    
        if (ptr >= (void*) tmpbuff && ptr <= (void*)(tmpbuff + tmppos)) {
            fprintf(stdout, "freeing temp memory\n");
        } else {
            real_free(ptr);
            fprintf(stderr, "free(%p)\n", ptr);
        }
    }
    
    void *realloc(void *ptr, size_t size)
    {
        if (real_malloc == NULL) {
            void *nptr = malloc(size);
            if (nptr && ptr) {
                memmove(nptr, ptr, size);
                free(ptr);
            }
            return nptr;
        }
    
        void *nptr = real_realloc(ptr, size);
        fprintf(stderr, "realloc(%p, %zd) = %p\n", ptr, size, nptr);
        return nptr;
    }
    
    void *calloc(size_t nmemb, size_t size)
    {
        if (real_malloc == NULL) {
            void *ptr = malloc(nmemb*size);
            if (ptr) {
                memset(ptr, 0, nmemb*size);
            }
            return ptr;
        }
    
        void *ptr = real_calloc(nmemb, size);
        fprintf(stderr, "calloc(%zd, %zd) = %p\n", nmemb, size, ptr);
        return ptr;
    }
    
    void *aligned_alloc(size_t alignment, size_t size)
    {
        if (real_malloc == NULL) {
            void* ptr = malloc(0);
            free(ptr);
        }

        void *ptr = real_aligned_alloc(alignment, size);
        fprintf(stderr, "aligned_alloc(%zd, %zd) = %p\n", alignment, size, ptr);
        return ptr;
    }

main.c

    #include <stdio.h>
    #include <stdlib.h>

    int main()
    {
        void* p = NULL;

        p = aligned_alloc(4, 8);
        free(p);

        p = calloc(4, 8);
        free(p);

        p = malloc(8);

        p = realloc(p, 1 << 20);
        free(p);

        return 0;
    }

compile

    gcc -shared -o libmymalloc.so -fPIC -ldl mymalloc.c

    gcc main.c

run

    LD_PRELOAD=./libmymalloc.so ./a.out

output:

    malloc(1024) = 0x146e2a0
    jcheck: allocated 0 bytes of temp memory in 0 chunks during initialization
    malloc(0) = 0x146e6b0
    free(0x146e6b0)
    aligned_alloc(4, 8) = 0x146e6b0
    free(0x146e6b0)
    calloc(4, 8) = 0x146e6d0
    free(0x146e6d0)
    malloc(8) = 0x146e6b0
    realloc(0x146e6b0, 1048576) = 0x7f89377d8010
    free(0x7f89377d8010)




