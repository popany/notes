# [Value categories](https://en.cppreference.com/w/cpp/language/value_category)

- [Value categories](#value-categories)
  - [Primary categories](#primary-categories)
    - [lvalue](#lvalue)
    - [prvalue](#prvalue)
    - [xvalue](#xvalue)
  - [Mixed categories](#mixed-categories)
    - [glvalue](#glvalue)
    - [rvalue](#rvalue)
  - [Special categories](#special-categories)
    - [Pending member function call](#pending-member-function-call)
    - [Void expressions](#void-expressions)
    - [Bit fields](#bit-fields)

Each C++ [expression](https://en.cppreference.com/w/cpp/language/expressions) (an operator with its operands, a literal, a variable name, etc.) is characterized by **two independent properties**: a [**type**](https://en.cppreference.com/w/cpp/language/type) and a **value category**. Each expression has some **non-reference** type, and each expression belongs to exactly one of the three primary value categories: **`prvalue`**, **`xvalue`**, and **`lvalue`**.

- a glvalue ("generalized" lvalue) is an expression whose evaluation determines the **identity** of an object or function;

- a prvalue ("pure" rvalue) is an expression whose evaluation

  - computes the value of an operand of a **built-in** operator (such prvalue **has no result object**), or

  - initializes an object (such prvalue is said to **have a result object**).

    The result object may be a variable, an object created by [new-expression](https://en.cppreference.com/w/cpp/language/new), a temporary created by [temporary materialization](https://en.cppreference.com/w/cpp/language/implicit_conversion#Temporary_materialization), or a member thereof. Note that non-void [discarded](https://en.cppreference.com/w/cpp/language/expressions#Discarded-value_expressions) expressions have a result object (the materialized temporary). Also, every class and array prvalue has a result object except when it is the operand of [decltype](https://en.cppreference.com/w/cpp/language/decltype);

- an xvalue (an "eXpiring" value) is a glvalue that denotes an object whose resources can be reused;

- an lvalue (so-called, historically, because lvalues could appear on the left-hand side of an assignment expression) is a glvalue that is not an xvalue;

- an rvalue (so-called, historically, because rvalues could appear on the right-hand side of an assignment expression) is a prvalue or an xvalue.

Note: this taxonomy went through significant changes with past C++ standard revisions, see [History](https://en.cppreference.com/w/cpp/language/value_category#History) below for details.

## Primary categories

### lvalue

The following expressions are **lvalue expressions**:

- the name of a variable, a function, a [template parameter object](https://en.cppreference.com/w/cpp/language/template_parameters#Non-type_template_parameter) (since C++20), or a data member, **regardless of type**, such as `std::cin` or `std::endl`. **Even if the variable's type is rvalue reference, the expression consisting of its name is an lvalue expression**;

- a function call or an overloaded operator expression, whose return type is lvalue reference, such as `std::getline(std::cin, str)`, `std::cout << 1`, `str1 = str2`, or `++it`;

- `a = b`, `a += b`, `a %= b`, and all other built-in [assignment and compound assignment](https://en.cppreference.com/w/cpp/language/operator_assignment) expressions;

- `++a` and `--a`, the built-in [pre-increment and pre-decrement](https://en.cppreference.com/w/cpp/language/operator_incdec#Built-in_prefix_operators) expressions;

- `*p`, the built-in [indirection](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_indirection_operator) expression;

- `a[n]` and `p[n]`, the built-in [subscript](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_subscript_operator) expressions, where one operand in `a[n]` is an array lvalue (since C++11);

- `a.m`, the [member of object](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_member_access_operators) expression, except where `m` is a member enumerator or a non-static member function, or where a is an rvalue and `m` is a non-static data member of object type;

- p->m, the built-in [member of pointer](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_member_access_operators) expression, except where `m` is a member enumerator or a non-static member function;

- `a.*mp`, the [pointer to member of object](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_pointer-to-member_access_operators) expression, where `a` is an lvalue and `mp` is a pointer to data member;

- `p->*mp`, the built-in [pointer to member of pointer](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_pointer-to-member_access_operators) expression, where `mp` is a pointer to data member;

- `a, b`, the built-in [comma](https://en.cppreference.com/w/cpp/language/operator_other#Built-in_comma_operator) expression, where b is an lvalue;

- `a ? b : c`, the [ternary conditional](https://en.cppreference.com/w/cpp/language/operator_other#Conditional_operator) expression for certain b and c (e.g., when both are lvalues of the same type, but see [definition](https://en.cppreference.com/w/cpp/language/operator_other#Conditional_operator) for detail);

- a [string literal](https://en.cppreference.com/w/cpp/language/string_literal), such as "Hello, world!";

- a cast expression to lvalue reference type, such as `static_cast<int&>(x)`;

- a function call or an overloaded operator expression, whose return type is rvalue reference to function;

- a cast expression to rvalue reference to function type, such as `static_cast<void (&&)(int)>(x)`.

Properties:

- Same as glvalue (below).

- **Address** of an lvalue may be taken by built-in address-of operator: `&++i` and `&std::endl` are valid expressions.

- A modifiable lvalue may be used as the **left-hand operand** of the built-in assignment and compound assignment operators.

- An lvalue may be used to [initialize an lvalue reference](https://en.cppreference.com/w/cpp/language/reference_initialization); this associates a new name with the object identified by the expression.

### prvalue

The following expressions are prvalue expressions:

- a [literal](https://en.cppreference.com/w/cpp/language/expressions#Literals) (except for [string literal](https://en.cppreference.com/w/cpp/language/string_literal)), such as `42`, `true` or `nullptr`;

- a function call or an overloaded operator expression, whose return type is non-reference, such as `str.substr(1, 2)`, `str1 + str2`, or `it++`;

- `a++` and `a--`, the built-in [post-increment and post-decrement](https://en.cppreference.com/w/cpp/language/operator_incdec#Built-in_postfix_operators) expressions;

- `a + b`, `a % b`, `a & b`, `a << b`, and all other built-in [arithmetic](https://en.cppreference.com/w/cpp/language/operator_arithmetic) expressions;

- `a && b`, `a || b`, `!a`, the built-in [logical](https://en.cppreference.com/w/cpp/language/operator_logical) expressions;

- `a < b`, `a == b`, `a >= b`, and all other built-in [comparison](https://en.cppreference.com/w/cpp/language/operator_comparison) expressions;

- `&a`, the built-in [address-of](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_address-of_operator) expression;

- a.m, the [member of object](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_member_access_operators) expression, where `m` is a member enumerator or a non-static member function, or where `a` is an rvalue and m is a non-static data member of non-reference type (until C++11);

- `p->m`, the built-in [member of pointer](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_member_access_operators) expression, where m is a member enumerator or a non-static member function;

- `a.*mp`, the [pointer to member of object](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_pointer-to-member_access_operators) expression, where `mp` is a pointer to member function, or where a is an rvalue and `mp` is a pointer to data member (until C++11);

- `p->*mp`, the built-in [pointer to member of pointer](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_pointer-to-member_access_operators) expression, where mp is a pointer to member function;

- `a, b`, the built-in [comma](https://en.cppreference.com/w/cpp/language/operator_other#Built-in_comma_operator) expression, where b is an rvalue;

- `a ? b : c`, the [ternary conditional](https://en.cppreference.com/w/cpp/language/operator_other#Conditional_operator) expression for certain `b` and `c` (see [definition](https://en.cppreference.com/w/cpp/language/operator_other#Conditional_operator) for detail);

- a cast expression to non-reference type, such as `static_cast<double>(x)`, `std::string{}`, or `(int)42`;

- the this pointer;

- an enumerator;

- non-type [template parameter](https://en.cppreference.com/w/cpp/language/template_parameters) unless its type is a class or (since C++20) an lvalue reference type;

- a [lambda expression](https://en.cppreference.com/w/cpp/language/lambda), such as `[](int x){ return x * x; }`; (since C++11)

- a [requires-expression](https://en.cppreference.com/w/cpp/language/constraints), such as `requires (T i) { typename T::type; }`; (since C++20)

- a specialization of a [concept](https://en.cppreference.com/w/cpp/language/constraints), such as `std::equality_comparable<int>`. (since C++20)

Properties:

- Same as rvalue (below).

- A prvalue cannot be [polymorphic](https://en.cppreference.com/w/cpp/language/object#Polymorphic_objects): the [dynamic type](https://en.cppreference.com/w/cpp/language/type#Dynamic_type) of the object it denotes is always the type of the expression.

- A non-class non-array prvalue cannot be [cv-qualified](https://en.cppreference.com/w/cpp/language/cv), unless it is [materialized](https://en.cppreference.com/w/cpp/language/implicit_conversion#Temporary_materialization) in order to be [bound to a reference](https://en.cppreference.com/w/cpp/language/reference_initialization) to a cv-qualified type (since C++17). (Note: a function call or cast expression may result in a prvalue of non-class cv-qualified type, but the cv-qualifier is generally immediately stripped out.)

- A prvalue cannot have [incomplete type](https://en.cppreference.com/w/cpp/language/type#Incomplete_type) (except for type `void`, see below, or when used in [decltype specifier](https://en.cppreference.com/w/cpp/language/decltype))

- A prvalue cannot have [abstract class type](https://en.cppreference.com/w/cpp/language/abstract_class) or an array thereof.

### xvalue

The following expressions are xvalue expressions:

- a function call or an overloaded operator expression, whose return type is rvalue reference to object, such as `std::move(x)`;

- `a[n]`, the built-in [subscript](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_subscript_operator) expression, where one operand is an array rvalue;

- `a.m`, the [member of object](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_member_access_operators) expression, where a is an rvalue and m is a non-static data member of non-reference type;

- `a.*mp`, the [pointer to member of object](https://en.cppreference.com/w/cpp/language/operator_member_access#Built-in_pointer-to-member_access_operators) expression, where `a` is an rvalue and `mp` is a pointer to data member;

- `a ? b : c`, the `ternary conditional` expression for certain b and c (see [definition](https://en.cppreference.com/w/cpp/language/operator_other#Conditional_operator) for detail);

- a cast expression to rvalue reference to object type, such as `static_cast<char&&>(x)`;

- any expression that designates a temporary object, after [temporary materialization](https://en.cppreference.com/w/cpp/language/implicit_conversion#Temporary_materialization). (since C++17)

Properties:

- Same as rvalue (below).

- Same as glvalue (below).

In particular, like all rvalues, xvalues bind to rvalue references, and like all glvalues, xvalues may be polymorphic, and non-class xvalues may be cv-qualified.

## Mixed categories

### glvalue

A glvalue expression is either lvalue or xvalue.

Properties:

- A glvalue may be implicitly converted to a prvalue with lvalue-to-rvalue, array-to-pointer, or function-to-pointer [implicit conversion](https://en.cppreference.com/w/cpp/language/implicit_conversion).

- A glvalue may be [polymorphic](https://en.cppreference.com/w/cpp/language/object#Polymorphic_objects): the [dynamic type](https://en.cppreference.com/w/cpp/language/type#Dynamic_type) of the object it identifies is not necessarily the static type of the expression.

- A glvalue can have [incomplete type](https://en.cppreference.com/w/cpp/language/type#Incomplete_type), where permitted by the expression.

### rvalue

An rvalue expression is either prvalue or xvalue.

Properties:

- Address of an rvalue cannot be taken by built-in address-of operator: `&int()`, `&i++`, `&42`, and `&std::move(x)` are invalid.

- An rvalue can't be used as the left-hand operand of the built-in assignment or compound assignment operators.

- An rvalue may be used to [initialize a const lvalue reference](https://en.cppreference.com/w/cpp/language/reference_initialization), in which case the lifetime of the object identified by the rvalue is [extended](https://en.cppreference.com/w/cpp/language/reference_initialization#Lifetime_of_a_temporary) until the scope of the reference ends.

- An rvalue may be used to [initialize an rvalue reference](https://en.cppreference.com/w/cpp/language/reference_initialization), in which case the lifetime of the object identified by the rvalue is [extended](https://en.cppreference.com/w/cpp/language/reference_initialization#Lifetime_of_a_temporary) until the scope of the reference ends.

- When used as a function argument and when [two overloads](https://en.cppreference.com/w/cpp/language/overload_resolution) of the function are available, one taking rvalue reference parameter and the other taking lvalue reference to const parameter, an rvalue binds to the rvalue reference overload (thus, if both copy and move constructors are available, an rvalue argument invokes the [move constructor](https://en.cppreference.com/w/cpp/language/move_constructor), and likewise with copy and move assignment operators).

## Special categories

### Pending member function call

The expressions `a.mf` and `p->mf`, where `mf` is a [non-static member function](https://en.cppreference.com/w/cpp/language/member_functions), and the expressions `a.*pmf` and `p->*pmf`, where `pmf` is a [pointer to member function](https://en.cppreference.com/w/cpp/language/pointer#Pointers_to_member_functions), are classified as prvalue expressions, but they cannot be used to initialize references, as function arguments, or for any purpose at all, except as the left-hand argument of the function call operator, e.g. `(p->*pmf)(args)`.

### Void expressions

Function call expressions returning `void`, cast expressions to `void`, and [throw-expressions](https://en.cppreference.com/w/cpp/language/throw) are classified as prvalue expressions, but they cannot be used to initialize references or as function arguments. They can be used in discarded-value contexts (e.g. on a line of its own, as the left-hand operand of the comma operator, etc.) and in the `return` statement in a function returning `void`. In addition, throw-expressions may be used as the second and the third operands of the [conditional operator ?:](https://en.cppreference.com/w/cpp/language/operator_other).

Void expressions have no result object.

### Bit fields

An expression that designates a [bit field](https://en.cppreference.com/w/cpp/language/bit_field) (e.g. `a.m`, where a is an lvalue of type `struct A { int m: 3; }`) is a glvalue expression: it may be used as the left-hand operand of the assignment operator, but its address cannot be taken and a non-const lvalue reference cannot be bound to it. A const lvalue reference or rvalue reference can be initialized from a bit-field glvalue, but a temporary copy of the bit-field will be made: it won't bind to the bit field directly.
