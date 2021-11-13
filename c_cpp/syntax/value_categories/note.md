# Value Categories

- [Value Categories](#value-categories)
  - [type v.s. category](#type-vs-category)
  - [A cast expression to non-reference type is `prvalue` expression](#a-cast-expression-to-non-reference-type-is-prvalue-expression)

## type v.s. category

- type 是变量的属性, 而 category 是表达式的属性

- type 为右值引用的变量作为表达式的类型为左值

参考:

[Value categories](https://en.cppreference.com/w/cpp/language/value_category)

> the name of a variable, a function, a template parameter object (since C++20), or a data member, regardless of type, such as `std::cin` or `std::endl`. Even if the variable's type is rvalue reference, the expression consisting of its name is an lvalue expression;

举例:

    void func(int&& a)
    {
        a++;
    }

变量 `a` 的类型为 `int` 右值引用, 表达式 `a` 为左值表达式.

## A cast expression to non-reference type is `prvalue` expression

such as `static_cast<double>(x)`, `std::string{}`, or `(int)42`

举例:

    int a = 0;
    static_cast<int>(a) = 2;

编译报错

    error: lvalue required as left operand of assignment
