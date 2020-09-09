# [Copy assignment operator](https://en.cppreference.com/w/cpp/language/copy_assignment)

- [Copy assignment operator](#copy-assignment-operator)
  - [Trivial copy assignment operator](#trivial-copy-assignment-operator)

A copy assignment operator of class T is a non-template non-static member function with the name operator= that takes exactly one parameter of type T, T&, const T&, volatile T&, or const volatile T&. For a type to be CopyAssignable, it must have a public copy assignment operator.

## Trivial copy assignment operator

The copy assignment operator for class T is trivial if all of the following is true:

- it is not user-provided (meaning, it is implicitly-defined or defaulted);
- T has no virtual member functions;
- T has no virtual base classes;
- the copy assignment operator selected for every direct base of T is trivial;
- the copy assignment operator selected for every non-static class type (or array of class type) member of T is trivial.

A trivial copy assignment operator makes a copy of the object representation as if by [std::memmove](https://en.cppreference.com/w/cpp/string/byte/memmove). All data types compatible with the C language (POD types) are trivially copy-assignable.