# Template

- [Template](#template)
  - [Variadic Templates](#variadic-templates)
  - [Dependent names](#dependent-names)

## Variadic Templates

[C++ Insights - Variadic Templates](https://www.modernescpp.com/index.php/c-insights-variadic-templates)

[Variadic template](https://en.wikipedia.org/wiki/Variadic_template)

[Variadic templates (C++11)](https://www.ibm.com/docs/en/zos/2.3.0?topic=only-variadic-templates-c11)

[Variadic templates in C++](https://eli.thegreenplace.net/2014/variadic-templates-in-c/)

## [Dependent names](https://en.cppreference.com/w/cpp/language/dependent_name)

Similarly, in a template definition, a dependent name that is not a member of the current instantiation is not considered to be a template name unless the disambiguation keyword `template` is used or unless it was already established as a template name:

    template<typename T>
    struct S
    {
        template<typename U>
        void foo() {}
    };
     
    template<typename T>
    void bar()
    {
        S<T> s;
        s.foo<T>();          // error: < parsed as less than operator
        s.template foo<T>(); // OK
    }
    
    
