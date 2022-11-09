# shared library

- [shared library](#shared-library)
  - [C++ static initialization vs `__attribute__((constructor))`](#c-static-initialization-vs-__attribute__constructor)

## [C++ static initialization vs `__attribute__((constructor))`](https://stackoverflow.com/questions/8433484/c-static-initialization-vs-attribute-constructor)

`__attribute__((constructor))` is not Standard C++. It is GCC's extension. So the behavior of your program depends on how GCC has defined it.

