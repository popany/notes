# Value Categories

- [Value Categories](#value-categories)
  - [type v.s. category](#type-vs-category)
  - [A cast expression to non-reference type is `prvalue` expression](#a-cast-expression-to-non-reference-type-is-prvalue-expression)
  - [glvalue](#glvalue)
    - [lvalue Examples](#lvalue-examples)
  - [rvalue](#rvalue)
    - [prvalue](#prvalue)
  - [xvalue](#xvalue)
  - [lvalue reference](#lvalue-reference)
  - [rvalue reference](#rvalue-reference)

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

## glvalue

glvalue is the set of things with identity.

glvalues contains both lvalues (also known as **classical lvalues**) and **xvalues**.

- identity

  If you have (or you can take) the memory address of a value and use it safely, then the value **has identity**.

- lvalue 

  is a kind of glvalue that cannot be moved

- xvalue

  is a kind of glvalue that can be moved

### lvalue Examples

- Examples of expressions that are lvalues include:

  - a named variable or constant;

  - or a function that returns a reference.

- Examples of expressions that are not lvalues include:

  - a temporary;

  - or a function that returns by value.

## rvalue

A value that is movable is known as an rvalue (or classical rvalue)

### prvalue

doesn't have identity, but is movable

## xvalue

An xvalue (an "eXpiring" value) is a glvalue that denotes an object whose resources can be reused

xvalue expressions:

- a **function call or an overloaded operator expression**, whose return type is rvalue reference to object, such as `std::move(x)`

- a **cast expression** to rvalue reference to object type, such as `static_cast<char&&>(x)`

- ...

## lvalue reference

- An lvalue reference can bind to an lvalue, but not to an rvalue.

- An lvalue const reference can bind to an lvalue or to an rvalue.

## rvalue reference

- An unnamed rvalue reference is an xvalue so it's an rvalue.

- Conversely, if an rvalue reference has a name, then the expression consisting of that name is an lvalue.

  You can use `static_cast<T&&>(name)` to get the unnamed rvalue reference




