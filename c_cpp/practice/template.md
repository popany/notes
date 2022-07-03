# template

- [template](#template)
  - [[overload char* and const char (&)[N]](https://stackoverflow.com/a/28182952)](#overload-char-and-const-char-n)

## [overload char* and const char (&)[N]](https://stackoverflow.com/a/28182952)

    #include <iostream>

    template<typename T>
    std::enable_if_t<std::is_pointer<T>::value>
    foo(T) { std::cout << "pointer\n"; }

    template<typename T, std::size_t sz>
    void foo(T(&)[sz]) { std::cout << "array\n"; }

    int main()
    {
        char const* c;
        foo(c);
        foo("hello");
    }




