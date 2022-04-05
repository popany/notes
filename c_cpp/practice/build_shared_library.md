# build shared library

- [build shared library](#build-shared-library)

reference: [Build .so file from .c file using gcc command line](https://stackoverflow.com/questions/14884126/build-so-file-from-c-file-using-gcc-command-line)

To generate a shared library you need first to compile your C code with the `-fPIC` (position independent code) flag.

    gcc -c -fPIC hello.c -o hello.o

This will generate an object file (`.o`), now you take it and create the `.so` file:

    gcc hello.o -shared -o libhello.so

to do it in one step:

    gcc -shared -o libhello.so -fPIC hello.c
