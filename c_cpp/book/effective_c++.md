# Effective C++

- [Effective C++](#effective-c)

- [Effective C++](#effective-c)
  - [Chapter 1: Accustoming Yourself to C++](#chapter-1-accustoming-yourself-to-c)
    - [Item 3: Use const whenever possible](#item-3-use-const-whenever-possible)
  - [Chapter 2: Constructors, Destructors, and Assignment Operators](#chapter-2-constructors-destructors-and-assignment-operators)
    - [Item 8: Prevent exceptions from leaving destructors](#item-8-prevent-exceptions-from-leaving-destructors)
    - [Item 9: Never call virtual functions during construction or destruction](#item-9-never-call-virtual-functions-during-construction-or-destruction)
  - [Chapter 3: Resource Management](#chapter-3-resource-management)
    - [Item 14: Think carefully about copying behavior in resource-managing classes](#item-14-think-carefully-about-copying-behavior-in-resource-managing-classes)
  - [Chapter 4: Designs and Declarations](#chapter-4-designs-and-declarations)
    - [Item 20: Prefer pass-by-reference-to-const to pass-byvalue](#item-20-prefer-pass-by-reference-to-const-to-pass-byvalue)
    - [Item 21: Don't try to return a reference when you must return an object](#item-21-dont-try-to-return-a-reference-when-you-must-return-an-object)
    - [Item 23: Prefer non-member non-friend functions to member functions](#item-23-prefer-non-member-non-friend-functions-to-member-functions)
    - [Item 25: Consider support for a non-throwing swap](#item-25-consider-support-for-a-non-throwing-swap)

## Chapter 1: Accustoming Yourself to C++

### Item 3: Use const whenever possible

If `operator[]` did return a simple char, statements like this wouldn't compile:

    tb[0] = 'x';

That's because it's never legal to modify the return value of a function that returns a **built-in type**.

...

So having the non-const `operator[]` call the const version is a safe way to avoid code duplication, even though it requires a cast. Here's the code, but it may be clearer after you read the explanation that follows:

    class TextBlock {
    public:
        ...
        const char& operator[](std::size_t position) const // same as before
        {
            ...
            ...
            ...
            return text[position];
        }
        char& operator[](std::size_t position) // now just calls const op[]
        {
            return
              const_cast<char&>( // cast away const on
                                 // op[]'s return type;
                static_cast<const TextBlock&>(*this) // add const to *this's type;
                  [position]     // call const version of op[]
            );
        }
        ...
    };

As you can see, the code has **two casts**, not one.

## Chapter 2: Constructors, Destructors, and Assignment Operators

### Item 8: Prevent exceptions from leaving destructors

If an operation may fail by throwing an exception and there may be a need to handle that exception, the exception has to come from some non-destructor function.

### Item 9: Never call virtual functions during construction or destruction

An object doesn't become a derived class object until execution of a derived class constructor begins.

Upon entry to the base class destructor, the object becomes a base class object, and all parts of C++ - virtual functions, dynamic_casts, etc., - treat it that way.

## Chapter 3: Resource Management

### Item 14: Think carefully about copying behavior in resource-managing classes

    class Lock {
    public:
        explicit Lock(Mutex *pm)   // init shared_ptr with the Mutex
        : mutexPtr(pm, unlock)     // to point to and the unlock func as the deleter
        {
            lock(mutexPtr.get());
        }
    private:
        std::tr1::shared_ptr<Mutex> mutexPtr;
    };

If construction of a `std::tr1::shared_ptr` throws, the deleter is automatically called, but in this case, that will yield a call to `unlock` without a call to `lock` having been made. Such an unmatched call to `unlock` will also occur if the call to `lock` throws. fxw suggests this constructor rewrite:

    explicit Lock(Mutex *pm)
    {
        lock(pm);
        mutexPtr.reset(pm, unlock);
    }

There was no room in the book for this explanation, so I left the code in the book unchanged, but I added a footnote pointing to this errata entry.

## Chapter 4: Designs and Declarations

### Item 20: Prefer pass-by-reference-to-const to pass-byvalue

For built-in types, then, when you have a choice between pass-by-value and pass-by-reference-to-const, it's not unreasonable to choose pass-by-value. This same advice applies to iterators and function objects in the STL, because, by convention, they are designed to be passed by value. Implementers of iterators and function objects are responsible for seeing to it that they are efficient to copy and are not subject to the slicing problem.

...

In general, the only types for which you can reasonably assume that pass-by-value is inexpensive are built-in types and STL iterator and function object types. For everything else, follow the advice of this Item and prefer pass-by-reference-to-const over pass-by-value.

### Item 21: Don't try to return a reference when you must return an object

The right way to write a function that must return a new object is to have that function return a new object. For Rational’s operator*, that means either the following code or something essentially equivalent:

    inline const Rational operator*(const Rational& lhs, const Rational& rhs) 
    {
        return Rational(lhs.n * rhs.n, lhs.d * rhs.d);
    }

Sure, you may incur the cost of constructing and destructing `operator*`'s return value, but in the long run, that's a small price to pay for correct behavior. Besides, the bill that so terrifies you may never arrive. Like all programming languages, C++ allows compiler implementers to apply optimizations to improve the performance of the generated code without changing its observable behavior, and it turns out that **in some cases, construction and destruction of `operator*`'s return value can be safely eliminated**. When compilers take advantage of that fact (and compilers often do), your program continues to behave the way it's supposed to, just faster than you expected.

### Item 23: Prefer non-member non-friend functions to member functions

refer non-member non-friend functions to member functions. Doing so increases encapsulation, packaging flexibility, and functional extensibility.

### Item 25: Consider support for a non-throwing swap

`std::swap` 可用于支持拷贝构造函数且支持拷贝赋值运算符的类.

`std::swap` 的默认行为可能引发性能问题.

例如:

    class WidgetImpl {
    public:
        ...
    private:
        int a, b, c;
        std::vector<double> v;  // expensive to copy!
        ...
    };

    class Widget {
    public:
        Widget(const Widget& rhs);
        Widget& operator=(const Widget& rhs)
        {
            ...
            *pImpl = *(rhs.pImpl);
            ...
        }
        ...
    private:
        WidgetImpl *pImpl; 
    };

`Widget` 的拷贝方式为深拷贝, 但对于 `swap`, 显然只需要交换 `pImpl` 指针即可. 对于默认的 `std::move`, 由于会调用 `Widget` 拷贝构造函数和拷贝赋值运算符, 即, 会采用深拷贝的方式, 而不是交换 `pImpl` 指针, 这造成性能的浪费.

为此, 需为 `Widget` 定义特化的 `std::swap`, 并在 `Widget` 中定义 public `swap` 成员函数:

    class Widget {  // same as above, except for the addition of the swap mem func
    public:
        ...
        void swap(Widget& other)
        {
            using std::swap; // the need for this declaration is explained later in this Item

            swap(pImpl, other.pImpl);  // to swap Widgets, swap their pImpl pointers
        }
        ...
    };

    namespace std {
        template<>  // revised specialization of std::swap
        void swap<Widget>(Widget& a, Widget& b)
        {
            a.swap(b); // to swap Widgets, call their swap member function
        }
    }

特化 `std::swap` 模板函数的目的仅仅是为了调用 `Widget::swap`, 后者完成具体的交换动作(需要访问 `Widget` 的私有成员). `std::swap` 的使用者无需关心具体的实现方式, 只需期待通用的交换结果即可.

这种形式与 STL 容器相一致, 后者也是提供了 public `swap` 成员函数及调用该函数的特化的 `std::swap`.

说明: `swap` 函数前的 `template<>` 代表该函数为 `std::swap` 模板函数的全特化, 函数名之后的 `<Widget>` 说明该特换用于模板类型为 `Widget` 的情况. 一般情况下不允许对 `std` 命名空间的内容进行修改, 但可以全特化 `std` 中的模板.

上述方案在当 `Widget` 与 `WidgetImpl` 时不可行. 原因如下:

对于

    template<typename T>
    class WidgetImpl { ... };

    template<typename T>
    class Widget { ... };

`std::swap` 特化为

    namespace std {
        template<typename T>
        void swap<Widget<T> >(Widget<T>& a, Widget<T>& b)
        {
            a.swap(b);
        }
    }

这是非法的, 因为 C++ 不允许模板函数偏特化.

对于需要偏特化模板函数的场景, 通常直接采用函数重载的方式

    namespace std {
        template<typename T>
        void swap(Widget<T>& a, Widget<T>& b)
        {
            a.swap(b);
        }
    }

但这也是行不通的, 因为用户不被允许在 STL 库中新增定义. 虽然也可能可以通过编译并执行, 但可能会引发未定义的行为.

替代方案是: 依然定义一个非成员函数的 `swap` 并定义一个成员函数的 `swap`. 但非成员函数的 `swap` 不再特化或者重载 `std::swap`. 如下例所示, 将非成员函数 `swap` 与 `Widget` 定义在同一个命名空间 `WidgetStuff`:

    namespace WidgetStuff {
        ...
        template<typename T>
        class Widget { ... };
        ...

        template<typename T>
        void swap(Widget<T>& a, Widget<T>& b)
        {
            a.swap(b);
        }
    }

在任意位置调用传入两个 `Widget` 对象的 `swap` 函数, 根据 c++ 的符号查找规则(argument-dependent lookup 或称为 Koenig lookup) 会匹配到 `WidgetStuff` 命名空间中的 `swap` 函数.

若 `Widget` 定义在全局命名空间中, 则对应的非对象 `swap` 函数也定义成全局的即可(依然符合与 `Widget` 属于同一命名空间).

上述方案是对 `class` 和 `class template` 的通用方案. 但对于 `class` 的情况, 为了在更多场景下都能实现优化(比如用户直接调用 `std::swap` 的场景), 除了要定义与 `class` 同一命名空间的非成员 `swap` 函数外, 还需特化 class 对应的 `std::swap`.

考虑到 `swap` 函数分为三种情况, 即, 默认的 `std::swap` 或特化的 `std::swap` 或与特定类属于同一命名空间的 `swap`, 且后两种情况可能不存在或只存在一种. 当后两种情况不存在时需要退化到默认的 `std::swap`. `swap` 的具体使用方式如下所示:

    template<typename T>
    void doSomething(T& obj1, T& obj2)
    {
        using std::swap;
        ...
        swap(obj1, obj2);
        ...
    }

编译器会优先搜索与对应类属于同一命名空间的 `swap`, 之后是特化的 `std::swap`, 最后是默认的 `std::swap`.

对于成员函数 `swap`, 不能抛出异常, 以保证 `swap` 可用于实现异常安全场景, 参考 Item 29. 成员函数 `swap` 的高效性与不抛异常并不矛盾, 因为高效往往建立于对基础类型的操作上,而对基础类型的操作是不会引发异常的.
