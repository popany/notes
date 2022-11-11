# shared library

- [shared library](#shared-library)
  - [C++ static initialization vs `__attribute__((constructor))`](#c-static-initialization-vs-__attribute__constructor)
  - [shared object can't find symbols in main binary, C++](#shared-object-cant-find-symbols-in-main-binary-c)
  - [.symtab and .dynsym](#symtab-and-dynsym)

## [C++ static initialization vs `__attribute__((constructor))`](https://stackoverflow.com/questions/8433484/c-static-initialization-vs-attribute-constructor)

`__attribute__((constructor))` is not Standard C++. It is GCC's extension. So the behavior of your program depends on how GCC has defined it.

## [shared object can't find symbols in main binary, C++](https://stackoverflow.com/questions/3623375/shared-object-cant-find-symbols-in-main-binary-c)

Without the `-rdynamic` (or something equivalent, like `-Wl,--export-dynamic`), symbols from the application itself will not be available for dynamic linking.

Reading: [GCC Options for Linking](https://gcc.gnu.org/onlinedocs/gcc-4.8.3/gcc/Link-Options.html)

For CMake:

    add_link_options(-rdynamic)
    add_executable(some_bin main.cpp)

## [.symtab and .dynsym](https://blogs.oracle.com/solaris/post/inside-elf-symbol-tables#:~:text=The%20symtab%20contains%20everything%2C%20but,needed%20to%20support%20runtime%20operation.)

Sharable objects and dynamic executables usually have 2 distinct symbol tables, one named ".symtab", and the other ".dynsym". (To make this easier to read, I am going to refer to these without the quotes or leading dot from here on.)

The dynsym is a smaller version of the symtab that only contains global symbols. The information found in the dynsym is therefore also found in the symtab, while the reverse is not necessarily true. You are almost certainly wondering why we complicate the world with two symbol tables. Won't one table do? Yes, it would, but at the cost of using more memory than necessary in the running process.

To understand how this works, we need to understand the difference between allocable and a non-allocable ELF sections. ELF files contain some sections (e.g. code and data) needed at runtime by the process that uses them. These sections are marked as being allocable. There are many other sections that are needed by linkers, debuggers, and other such tools, but which are not needed by the running program. These are said to be non-allocable. When a linker builds an ELF file, it gathers all of the allocable sections together in one part of the file, and all of the non-allocable sections are placed elsewhere. When the operating system loads the resulting file, only the allocable part is mapped into memory. The non-allocable part remains in the file, but is not visible in memory. [strip(1)](http://docs.oracle.com/cd/E86824_01/html/E54763/strip-1.html) can be used to remove certain non-allocable sections from a file. This reduces file size by throwing away information. The program is still runnable, but debuggers may be hampered in their ability to tell you what the program is doing.

The full symbol table contains a large amount of data needed to link or debug our files, but not needed at runtime. In fact, in the days before sharable libraries and dynamic linking, none of it was needed at runtime. There was a single, non-allocable symbol table (reasonably named "symtab"). When dynamic linking was added to the system, the original designers faced a choice: Make the symtab allocable, or provide a second smaller allocable copy. The symbols needed at runtime are a small subset of the total, so a second symbol table saves virtual memory in the running process. This is an important consideration. Hence, a second symbol table was invented for dynamic linking, and consequently named "dynsym".

And so, we have two symbol tables. The symtab contains everything, but it is non-allocable, can be stripped, and has no runtime cost. The dynsym is allocable, and contains the symbols needed to support runtime operation. This division has served us well over the years.

