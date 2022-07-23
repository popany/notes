# template

- [template](#template)
  - [[overload char* and const char (&)[N]](https://stackoverflow.com/a/28182952)](#overload-char-and-const-char-n)
  - [C++ template functions priority](#c-template-functions-priority)

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

## [C++ template functions priority](https://stackoverflow.com/questions/31047860/c-template-functions-priority)

You declare in the second function that you second argument to be const. The below example of your with applied correction calls the second one:

    #include <iostream>

    template <class U, class T>
    void foo(U&, T&)
    {
        std::cout << "first";
    }

    template <class T>
    void foo(int&, T&)
    {
        std::cout << "second";
    }

    int main()
    {
        int a;
        double g = 2.;
        foo(a, g);

        return 0;
    }

On the other hand, when you explicitly declare second argument do be const in main(), the application calls second function in your above example as expected:

    #include <iostream>

    template <class U, class T>
    void foo(U&, T&)
    {
        std::cout << "first";
    }

    template <class T>
    void foo(int&, const T&)
    {
        std::cout << "second";
    }

    int main()
    {
        int a;
        const double g = 2.;
        foo(a, g);

        return 0;
    }
