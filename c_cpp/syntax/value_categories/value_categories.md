# [Value categories](https://en.cppreference.com/w/cpp/language/value_category)

- [Value categories](#value-categories)
  - [Primary categories](#primary-categories)
    - [lvalue](#lvalue)
    - [prvalue](#prvalue)

Each C++ [expression](https://en.cppreference.com/w/cpp/language/expressions) (an operator with its operands, a literal, a variable name, etc.) is characterized by **two independent properties**: a [**type**](https://en.cppreference.com/w/cpp/language/type) and a **value category**. Each expression has some **non-reference** type, and each expression belongs to exactly one of the three primary value categories: **`prvalue`**, **`xvalue`**, and **`lvalue`**.

- a glvalue ("generalized" lvalue) is an expression whose evaluation determines the **identity** of an object or function;

- a prvalue ("pure" rvalue) is an expression whose evaluation

  - computes the value of an operand of a **built-in** operator (such prvalue **has no result object**), or

  - initializes an object (such prvalue is said to **have a result object**).

    The result object may be a variable, an object created by [new-expression](https://en.cppreference.com/w/cpp/language/new), a temporary created by [temporary materialization](https://en.cppreference.com/w/cpp/language/implicit_conversion#Temporary_materialization), or a member thereof. Note that non-void [discarded](https://en.cppreference.com/w/cpp/language/expressions#Discarded-value_expressions) expressions have a result object (the materialized temporary). Also, every class and array prvalue has a result object except when it is the operand of [decltype](https://en.cppreference.com/w/cpp/language/decltype);

- an xvalue (an “eXpiring” value) is a glvalue that denotes an object whose resources can be reused;

- an lvalue (so-called, historically, because lvalues could appear on the left-hand side of an assignment expression) is a glvalue that is not an xvalue;

- an rvalue (so-called, historically, because rvalues could appear on the right-hand side of an assignment expression) is a prvalue or an xvalue.

Note: this taxonomy went through significant changes with past C++ standard revisions, see [History](https://en.cppreference.com/w/cpp/language/value_category#History) below for details.

## Primary categories

### lvalue

The following expressions are **lvalue expressions**:

the name of a variable, a function, a [template parameter object](https://en.cppreference.com/w/cpp/language/template_parameters#Non-type_template_parameter) (since C++20), or a data member, **regardless of type**, such as `std::cin` or `std::endl`. **Even if the variable's type is rvalue reference, the expression consisting of its name is an lvalue expression**;

a function call or an overloaded operator expression, whose return type is lvalue reference, such as std::getline(std::cin, str), std::cout << 1, str1 = str2, or ++it;
a = b, a += b, a %= b, and all other built-in assignment and compound assignment expressions;
++a and --a, the built-in pre-increment and pre-decrement expressions;
*p, the built-in indirection expression;
a[n] and p[n], the built-in subscript expressions, where one operand in a[n] is an array lvalue (since C++11);
a.m, the member of object expression, except where m is a member enumerator or a non-static member function, or where a is an rvalue and m is a non-static data member of object type;
p->m, the built-in member of pointer expression, except where m is a member enumerator or a non-static member function;
a.*mp, the pointer to member of object expression, where a is an lvalue and mp is a pointer to data member;
p->*mp, the built-in pointer to member of pointer expression, where mp is a pointer to data member;
a, b, the built-in comma expression, where b is an lvalue;
a ? b : c, the ternary conditional expression for certain b and c (e.g., when both are lvalues of the same type, but see definition for detail);
a string literal, such as "Hello, world!";
a cast expression to lvalue reference type, such as static_cast<int&>(x);
a function call or an overloaded operator expression, whose return type is rvalue reference to function;
a cast expression to rvalue reference to function type, such as static_cast<void (&&)(int)>(x).
(since C++11)
Properties:

Same as glvalue (below).
Address of an lvalue may be taken by built-in address-of operator: &++i[1] and &std::endl are valid expressions.
A modifiable lvalue may be used as the left-hand operand of the built-in assignment and compound assignment operators.
An lvalue may be used to initialize an lvalue reference; this associates a new name with the object identified by the expression.

### prvalue



TODO rvalueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee