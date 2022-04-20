# enable_if

- [enable_if](#enable_if)

main.cpp

    #include <iostream>
    #include <type_traits>

    template <typename T>
    std::enable_if_t<std::is_floating_point<T>::value, void>
    func(T v)
    {
        std::cout << "float: " << v << std::endl;
    }

    template <typename T>
    std::enable_if_t<std::is_integral<T>::value, void>
    func(T v)
    {
        std::cout << "int: " << v << std::endl;
    }

    int main()
    {
        func(0.1);
        func(1);

        return 0;
    }

compile

    g++ -std=c++14 main.cpp

run

    float: 0.1
    int: 1
