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
  - [Chapter 5: Implementations](#chapter-5-implementations)
    - [Item 26: Postpone variable definitions as long as possible](#item-26-postpone-variable-definitions-as-long-as-possible)
    - [Item 27: Minimize casting](#item-27-minimize-casting)
    - [Item 29: Strive for exception-safe code](#item-29-strive-for-exception-safe-code)
  - [Item 30: Understand the ins and outs of inlining](#item-30-understand-the-ins-and-outs-of-inlining)
  - [Item 31: Minimize compilation dependencies between files](#item-31-minimize-compilation-dependencies-between-files)
  - [Chapter 6: Inheritance and Object-Oriented Design](#chapter-6-inheritance-and-object-oriented-design)
    - [Item 32: Make sure public inheritance models "is-a"](#item-32-make-sure-public-inheritance-models-is-a)

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

    class Widget {
    public:
        ...
        void swap(Widget& other)
        {
            using std::swap; // the need for this declaration is explained later in this Item

            swap(pImpl, other.pImpl);
        }
        ...
    };

    namespace std {
        template<>
        void swap<Widget>(Widget& a, Widget& b)
        {
            a.swap(b); // to swap Widgets, call their swap member function
        }
    }

特化 `std::swap` 模板函数的目的仅仅是为了调用 `Widget::swap`, 后者完成具体的交换操作(需要访问 `Widget` 的私有成员). `std::swap` 的使用者无需关心具体的实现方式, 只需期待通用的交换结果即可.

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

上述方案是对 `class` 和 `class template` 的通用方案. 但对于 `class` 的情况, 为了在更多场景下都能实现优化(主要为应对用户错误的直接调用 `std::swap` 的场景), 除了要定义与 `class` 同一命名空间的非成员 `swap` 函数外, 还需特化 class 对应的 `std::swap`.

考虑到 `swap` 函数分为三种情况, 即, 默认的 `std::swap` 或特化的 `std::swap` 或与特定类属于同一命名空间的 `swap`, 且后两种情况可能不存在或只存在一种. 当后两种情况不存在时需要退化到调用默认的 `std::swap`, `swap` 的具体使用方式如下所示:

    template<typename T>
    void doSomething(T& obj1, T& obj2)
    {
        using std::swap;
        ...
        swap(obj1, obj2);
        ...
    }

编译器会优先搜索与对应类属于同一命名空间的 `swap`, 之后是特化的 `std::swap`, 最后是默认的 `std::swap`.

对于成员函数 `swap`, 不能抛出异常, 以保证 `swap` 可用于实现异常安全场景, 参考 Item 29. 成员函数 `swap` 的高效性与不抛异常并不矛盾, 因为高效往往建立于对基础类型的操作上, 而对基础类型的操作是不会引发异常的.

## Chapter 5: Implementations

### Item 26: Postpone variable definitions as long as possible

关于循环中使用的对象, 其定义放在循环外(A 方案)还是循环外(B 方案).

- A 方案开销: 1 次构造 + 1 次析构 + n 次赋值

- B 方案开销: n 次构造 + n 次析构

如果赋值开销小于构造加析构的开销, A 方案性能更好, 尤其在 n 比较大的情况.

但是 A 方案中变量的作用域更广, 会提到理解与维护的成本. 因此除非在已明确 1) 赋值开销小于构造加析构的开销, 且, 2) 有高性能需求的场景, 其他场景应使用方案 B.

### Item 27: Minimize casting

- Avoid casts whenever practical, especially `dynamic_casts` in performance-sensitive code. If a design requires casting, try to develop a cast-free alternative.

- When casting is necessary, try to hide it inside a function. Clients can then call the function instead of putting casts in their own code.

- Prefer C++-style casts to old-style casts. They are easier to see, and they are more specific about what they do.

### Item 29: Strive for exception-safe code

    class PrettyMenu {
    public:
        ...
        void changeBackground(std::istream& imgSrc);
        ...
    private:
        Mutex mutex; 
        Image *bgImage;
        int imageChanges;
    };

    void PrettyMenu::changeBackground(std::istream& imgSrc)
    {
        lock(&mutex);
        delete bgImage;
        ++imageChanges;
        bgImage = new Image(imgSrc);
        unlock(&mutex);
    }

对于 **exception-safe 函数, 应满足如下两个基本要求(上例中的函数 `PrettyMenu::changeBackground` 一个也没有满足):

- **Leak no resources**. The code above fails this test, because if the `new Image(imgSrc)` expression yields an exception, the call to unlock never gets executed, and the `mutex` is held forever.

- **Don't allow data structures to become corrupted**. If `new Image(imgSrc)` throws, `bgImage` is left pointing to a deleted object. In addition, `imageChanges` has been incremented, even though it's not true that a new image has been installed. (On the other hand, the old image has definitely been eliminated, so I suppose you could argue that the image has been "changed.")

Exception-safe 函数按由弱到强可分为如下三类:

- Functions offering **the basic guarantee** promise that if an exception is thrown, everything in the program **remains in a valid state**. No objects or data structures become corrupted, and all objects are in an internally consistent state (e.g., all class invariants are satisfied). However, the **exact state** of the program may **not be predictable**.

- Functions offering **the strong guarantee** promise that if an exception is thrown, the **state of the program is unchanged**. Calls to such functions are atomic in the sense that if they succeed, they succeed completely, and if they fail, the program state is as if they'd never been called.

- Functions offering **the nothrow guarantee** promise never to throw exceptions, because they always do what they promise to do. All operations on built-in types (e.g., ints, pointers, etc.) are nothrow (i.e., offer the nothrow guarantee). This is a critical building block of exception-safe code.

如果允许, 应尽量编写符合 **the nothrow guarantee** 的函数, 但通常做不到.

要使得 `changeBackground` **几乎**满足 **the strong guarantee**, 需作如下两点修改:

1. 将 `bgImage` 换为智能指针

2. 修改 `++imageChanges` 的位置

修改后的代码如下:

    class PrettyMenu {
        ...
        std::tr1::shared_ptr<Image> bgImage;
        ...
    };

    void PrettyMenu::changeBackground(std::istream& imgSrc)
    {
        Lock ml(&mutex);
        bgImage.reset(new Image(imgSrc));
        ++imageChanges;
    }

上述代码之所以只是"**几乎**" **the strong guarantee** 的, 是因为当 `Image` 的构造函数抛异常时, `imgSrc` stream 的 read marker 可能发生了改变. 在解决该问题前, 上述代码只是 **the basic guarantee** 的.

此处暂时不纠结上述代码怎样满足 **ther strong guarantee**.

下面介绍一种可用于实现 **the strong guarantee** 的常用策略: **copy and swap**. 该策略的基本思路是, 创建一份将要修改的对象的副本, 并将所有的修改应用到该副本上. 即便在修改副本过程中发生异常, 也可保证原对象状态不变. 若副本修改成功, 则通过不抛异常的操作交换副本与原始对象.

实现 **copy and swap** 策略时通常借助 **"pimpl idiom"**, 代码如下所示:

    struct PMImpl {
        std::tr1::shared_ptr<Image> bgImage;
        int imageChanges;
    };

    class PrettyMenu {
        ...
    private:
        Mutex mutex;
        std::tr1::shared_ptr<PMImpl> pImpl;
    };

    void PrettyMenu::changeBackground(std::istream& imgSrc)
    {
        using std::swap;
        Lock ml(&mutex);
        std::tr1::shared_ptr<PMImpl> pNew(new PMImpl(*pImpl));
        pNew->bgImage.reset(new Image(imgSrc));
        ++pNew->imageChanges;
        swap(pImpl, pNew);
    }

"copy and swap" 策略虽然可以保证原对象状态不被修改, 但仍不足以保证 **the strong guarantee**. 参考下例:

    void someFunc()
    {
        ...  // make copy of local state
        f1();
        f2();
        ...  // swap modified state into place
    }

虽然 `someFunc` 使用了 "copy and swap" 策略, 但如果 `f1()` 或 `f2()` 不满足 **the strong guarantee**, 则, 函数 `someFunc` 不满足 **the strong guarantee**.

并且, 即使 `f1()` 与 `f2()` 均为 "**the strong guarantee**" 的, `someFunc` 依旧不满足 **the strong guarantee**. 考虑如下情况:

`f1()` 调用成功, 程序的状态发生了改变, `f2()` 调用过程中抛出异常, 此时程序的状态与 `someFunc` 调用前不同, 即, 不满足 **the strong guarantee**.

虽然在一些场景下可通过 "copy and swap" 策略实现 **the strong guarantee**, 但现实中往往由于性能、内存、代码复杂性的原因不得不采用 **the basic guarantee** 的方案.

对于一个软件系统, 要么其实异常安全的, 要么不是异常安全的, 不存在部分异常安全这种说法. 即便软件系统中只有一个函数不是异常安全的, 则该软件系统不是异常安全的. 因为对该函数的调用可能导致资源泄露或数据损坏.

在定义接口时, 应该确定该接口的异常安全级别, 并在文档中说明.

## Item 30: Understand the ins and outs of inlining

内联函数的问题:

- On machines with limited memory, overzealous inlining can give rise to programs that are too big for the available space.

- Even with virtual memory, inline-induced code bloat can lead to additional paging, a reduced instruction cache hit rate, and the performance penalties that accompany these things.

成员函数与友元函数均为隐式声明内联函数.

对于显示声明的内联函数, `inline` 关键字置于函数定义之前, 且函数定义在头文件中.

模板函数不是默认内联的, 定义内联的模板函数需使用 `inline` 关键字.

虚函数是无视内联的, 因为要等到运行时才知道具体调用的函数.

大多数编译器支持设置诊断等级, 当内联失败时, 打印错误.

## Item 31: Minimize compilation dependencies between files

- **Avoid using objects when object references and pointers will do**. You may define references and pointers to a type with only a declaration for the type. Defining objects of a type necessitates the presence of the type's definition.

- **Depend on class declarations instead of class definitions whenever you can**. Note that you never need a class definition to declare a function using that class, not even if the function passes or returns the class type by value:

      class Date;  // class declaration
      Date today();  // fine — no definition
      void clearAppointments(Date d);  // of Date is needed

  The ability to declare `today` and `clearAppointments` **without defining** `Date` may surprise you, but it's not as curious as it seems. If anybody calls those functions, `Date`'s definition must have been seen prior to the call. Why bother to declare functions that nobody calls, you wonder? Simple. It's not that nobody calls them, it's that not everybody calls them. If you have a library containing dozens of function declarations, it's unlikely that every client calls every function. By moving the onus of **providing class definitions** from your header file of function declarations to clients' files containing function calls, you eliminate artificial client dependencies on **type definitions** they don't really need.

- **Provide separate header files for declarations and definitions**. In order to facilitate adherence to the **above guidelines**, header files need to come in pairs: **one for declarations**, the **other for definitions**. These files must be kept consistent, of course. If a declaration is changed in one place, it must be changed in both. As a result, library clients should always `#include` a declaration file instead of forward-declaring something themselves, and **library authors should provide both header files**. For example, the `Date` client wishing to declare `today` and `clearAppointments` shouldn't manually forward-declare `Date` as shown above. Rather, it should `#include` the appropriate header of declarations:

      #include "datefwd.h" // header file declaring (but not defining) class Date
      Date today(); // as before
      void clearAppointments(Date d);

...

It would be a serious mistake, however, to dismiss **Handle classes** and **Interface classes** simply because they have a cost associated with them. So do virtual functions, and you wouldn't want to forgo those, would you? (If so, you're reading the wrong book.) Instead, consider using these techniques in an evolutionary manner. Use Handle classes and Interface classes during development to **minimize the impact on clients when implementations change**. Replace Handle classes and Interface classes with concrete classes for production use when it can be shown that the difference in **speed and/or size** is significant enough to justify the increased coupling between classes. 

## Chapter 6: Inheritance and Object-Oriented Design

### Item 32: Make sure public inheritance models "is-a"








