# Effective C++

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
    - [Item 24: Declare non-member functions when type conversions should apply to all parameters](#item-24-declare-non-member-functions-when-type-conversions-should-apply-to-all-parameters)
    - [Item 25: Consider support for a non-throwing swap](#item-25-consider-support-for-a-non-throwing-swap)
  - [Chapter 5: Implementations](#chapter-5-implementations)
    - [Item 26: Postpone variable definitions as long as possible](#item-26-postpone-variable-definitions-as-long-as-possible)
    - [Item 27: Minimize casting](#item-27-minimize-casting)
    - [Item 29: Strive for exception-safe code](#item-29-strive-for-exception-safe-code)
    - [Item 30: Understand the ins and outs of inlining](#item-30-understand-the-ins-and-outs-of-inlining)
    - [Item 31: Minimize compilation dependencies between files](#item-31-minimize-compilation-dependencies-between-files)
  - [Chapter 6: Inheritance and Object-Oriented Design](#chapter-6-inheritance-and-object-oriented-design)
    - [Item 32: Make sure public inheritance models "is-a"](#item-32-make-sure-public-inheritance-models-is-a)
    - [Item 33: Avoid hiding inherited names](#item-33-avoid-hiding-inherited-names)
    - [Item 34: Differentiate between inheritance of interface and inheritance of implementation](#item-34-differentiate-between-inheritance-of-interface-and-inheritance-of-implementation)
    - [Item 35: Consider alternatives to virtual functions](#item-35-consider-alternatives-to-virtual-functions)
      - [The Template Method Pattern via the Non-Virtual Interface Idiom](#the-template-method-pattern-via-the-non-virtual-interface-idiom)
      - [The Strategy Pattern via Function Pointers](#the-strategy-pattern-via-function-pointers)
      - [The Strategy Pattern via `tr1::function`](#the-strategy-pattern-via-tr1function)
      - [The "Classic" Strategy Pattern](#the-classic-strategy-pattern)
    - [Item 36: Never redefine an inherited non-virtual function](#item-36-never-redefine-an-inherited-non-virtual-function)
    - [Item 37: Never redefine a function's inherited default parameter value](#item-37-never-redefine-a-functions-inherited-default-parameter-value)
    - [Item 38: Model "has-a" or "is-implemented-in-terms-of" through composition](#item-38-model-has-a-or-is-implemented-in-terms-of-through-composition)
    - [Item 39: Use private inheritance judiciously](#item-39-use-private-inheritance-judiciously)
    - [Item 40: Use multiple inheritance judiciously](#item-40-use-multiple-inheritance-judiciously)
  - [Chapter 7: Templates and Generic Programming](#chapter-7-templates-and-generic-programming)
    - [Item 41: Understand implicit interfaces and compiletime polymorphism](#item-41-understand-implicit-interfaces-and-compiletime-polymorphism)
    - [Item 42: Understand the two meanings of typename](#item-42-understand-the-two-meanings-of-typename)
    - [Item 43: Know how to access names in templatized base classes](#item-43-know-how-to-access-names-in-templatized-base-classes)
    - [Item 44: Factor parameter-independent code out of templates](#item-44-factor-parameter-independent-code-out-of-templates)
    - [Item 45: Use member function templates to accept "all compatible types"](#item-45-use-member-function-templates-to-accept-all-compatible-types)
    - [Item 46: Define non-member functions inside templates when type conversions are desired](#item-46-define-non-member-functions-inside-templates-when-type-conversions-are-desired)

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

### Item 24: Declare non-member functions when type conversions should apply to all parameters

通常使用户自定义的类型支持隐式类型转换是不明智的, 但同其他规则一样, 也存在例外. 比如, 对于自定义的数值类型而言, 通常支持**隐式**类型转换是合理的.

比如下面的有理数类:

    class Rational {
    public:
        Rational(int numerator = 0, int denominator = 1);

        int numerator() const;
        int denominator() const;
    private:
        ...
    };

注意, `Rational` 的构造函数的声明未使用 `explicit` 关键字以支持隐式类型转换, 具体是由 `int` 类型转换为 `Rational`.

假设我们要针对 `Rational` 实现 `operator*`, 可选的方案有如下三种:

1. 作为成员函数实现

       class Rational {
       public:
           ...
           const Rational operator*(const Rational& rhs) const;
       };

2. 作为非成员函数实现

       class Rational {
           ...  // contains no operator*
       };

       const Rational operator*(const Rational& lhs, const Rational& rhs)
       {
           return Rational(lhs.numerator() * rhs.numerator(),
                           lhs.denominator() * rhs.denominator());
       }

3. 作为友元函数实现

我们要支持 mixed-mode operations, 且考虑乘法满足交换律, 我们要支持如下两种情况:

    Rational oneHalf(1, 2);

    result = oneHalf * 2;  // (1)
    result = 2 * oneHalf;  // (2)

考虑到只能针对函数的变量列表中的参数触发隐式类型转换, `this` 指针不在成员函数的变量列表中, 所以无法触发针对 `this` 指针的隐式类型转换. 所以方案 "1. 作为成员函数实现" 是不支 "情况 (2)" 的, 即, 表达式 `2 * oneHalf` 中的 `2` 不能隐式转换为 `Rational`.

方案 "2. 作为非成员函数实现" 与方案 "3. 作为友元函数实现" 均可满足 "情况 (1)" 与 "情况 (2)" 的要求. 但我们最终选择方案 "2. 作为非成员函数实现", 此处我们根据的原则是: "如果能不用友元函数, 那就别用".

这里还要澄清一点, 成员函数的对立面是非成员函数, 而不是友元函数. 太多 C++ 程序员认为, 对于一个与某一类型相关的函数, 若其不能作为该类型的成员函数实现, 就应该作为该类型的友元函数实现, 这种观点是有瑕疵的.

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

这是非法的, 因为 **C++ 不允许模板函数偏特化**.

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

### Item 30: Understand the ins and outs of inlining

内联函数的问题:

- On machines with limited memory, overzealous inlining can give rise to programs that are too big for the available space.

- Even with virtual memory, inline-induced code bloat can lead to additional paging, a reduced instruction cache hit rate, and the performance penalties that accompany these things.

成员函数与友元函数均为隐式声明内联函数.

对于显示声明的内联函数, `inline` 关键字置于函数定义之前, 且函数定义在头文件中.

模板函数不是默认内联的, 定义内联的模板函数需使用 `inline` 关键字.

虚函数是无视内联的, 因为要等到运行时才知道具体调用的函数.

大多数编译器支持设置诊断等级, 当内联失败时, 打印错误.

### Item 31: Minimize compilation dependencies between files

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

Public inheritance means "is-a".

Private inheritance means something entirely different (see Item 39), and protected inheritance is something whose meaning eludes me to this day.

### Item 33: Avoid hiding inherited names

C++'s name-hiding rules do just that: **hide names**. Whether the names correspond to the **same or different types** is immaterial.

注意: 以上论述同样适用于函数(函数签名可视为函数的类型).

...

The scope of a derived class is nested inside its base class's scope.

...

As you can see, this applies even though the functions in the base and derived classes take **different parameter types**, and it also applies regardless of whether the functions are **virtual or non-virtual**. In the same way that, at the beginning of this Item, the `double x` in the function `someFunc` hides the `int x` at global scope, here the function `mf3` in Derived hides a Base function named `mf3` that has a **different type**.

The rationale behind this behavior is that it prevents you from accidentally inheriting overloads from distant base classes when you create a new derived class in a library or application framework.

...

This means that if you inherit from a base class with overloaded functions and you want to redefine or override only some of them, you need to include a **`using` declaration** for each **name** you'd otherwise be hiding. If you don't, some of the names you'd like to inherit will be hidden.

...

Things to Remember:

- Names in derived classes hide names in base classes. Under public inheritance, this is never desirable. 

- To make hidden names visible again, employ using declarations or forwarding functions.

### Item 34: Differentiate between inheritance of interface and inheritance of implementation

Pure virtual functions must be redeclared in concrete derived classes, but they may also have implementations of their own.

对于基类提供默认实现的某一函数, 若某一派生类需要实现其特有版本, 为了防止该派生类的编写者忘记重写该函数. 可在基类中将该函数声明为纯虚函数, 并在基类中提供定义. 这样, 如果派生类的编写者忘记重写该函数, 则会导致编译报错(因为派生类中必须提供基类的纯虚函数的定义). 对于使用默认版本的情况, 在派生类的实现中调用基类版本即可.

### Item 35: Consider alternatives to virtual functions

#### The Template Method Pattern via the Non-Virtual Interface Idiom

This basic design - having clients call private virtual functions indirectly through public non-virtual member functions — is known as the **non-virtual interface (NVI) idiom**. It's a particular manifestation of the more general design pattern called **Template Method** (a pattern
that, unfortunately, has **nothing to do with C++ templates**). I call the non-virtual function (e.g., `healthValue`) the virtual function's wrapper.

**An advantage of the NVI idiom** is suggested by the **"do 'before' stuff"** and **"do 'after' stuff"** comments in the code. Those comments identify code segments guaranteed to be called before and after the virtual function that does the real work. This means that the wrapper ensures that before a virtual function is called, the proper context is set up, and after the call is over, the context is cleaned up. For example, the "before" stuff could include locking a mutex, making a log entry, verifying that class invariants and function preconditions are satisfied, etc. The "after" stuff could include unlocking a mutex, verifying function postconditions, reverifying class invariants, etc. There's not really any good way to do that if you let clients call virtual functions directly.

It may have crossed your mind that the NVI idiom involves **derived classes redefining private virtual functions** - **redefining functions they can't call**! There's no design contradiction here. Redefining a virtual function specifies **how** something is to be done. Calling a virtual function specifies **when** it will be done. These concerns are independent. The NVI idiom allows derived classes to redefine a virtual function, thus giving them control over **how** functionality is implemented, but the base class reserves for itself the right to say **when** the function will be called. It may seem odd at first, but **C++'s rule that derived classes may redefine private inherited virtual functions is perfectly sensible**.

#### The Strategy Pattern via Function Pointers

This approach is a simple application of another common design pattern, **Strategy**. Compared to approaches based on virtual functions in the `GameCharacter` hierarchy, it offers some interesting flexibility:

- Different instances of the same character type can have different health calculation functions.

- Health calculation functions for a particular character may be changed at runtime.

#### The Strategy Pattern via `tr1::function`

...

于上一条比, 只是把函数指针换成了 `tr1::function`

#### The "Classic" Strategy Pattern

This approach has the appeal of being quickly recognizable to people familiar with the "standard" Strategy pattern implementation, plus it offers the possibility that an existing health calculation algorithm can be tweaked by adding a derived class to the `HealthCalcFunc` hierarchy.

### Item 36: Never redefine an inherited non-virtual function

如果派生类重新定义了基类中的某个函数, 设为 `mf`, 则通过基类指针调用 `mf` 时, 调用的是基类版本, 通过派生类指针调用 `mf` 时, 调用的是派生类版本. 这是我们不希望看到的.

If reading this Item gives you a sense of déjà vu, it's probably because you've already read Item 7, which explains why destructors in polymorphic base classes should be virtual. If you violate that guideline (i.e., if you declare a non-virtual destructor in a polymorphic base class), you'll also be violating this guideline, because derived classes would invariably **redefine an inherited non-virtual function**: the base class's destructor. This would be true even for derived classes that declare no destructor, because, as Item 5 explains, the destructor is one of the member functions that compilers generate for you if you don't declare one yourself. In essence, Item 7 is nothing more than a special case of this Item, though it's important enough to merit calling out on its own.

### Item 37: Never redefine a function's inherited default parameter value

That being the case, the justification for this Item becomes quite straightforward: virtual functions are **dynamically bound**, but default parameter values are **statically bound**.

对于虚函数 `mf`, 若在基类与派生类中都定义了默认参数, 由于默认参数是静态绑定的, 则通过指针以默认参数调用 `mf` 时, 实际使用参数值只与指针类型有关, 与对象的实际类型无关.

可通过 NVI idiom 来避免需要定义虚函数的默认参数的场景. 即, 在基类中定义公有的非需函数并定义其默认参数, 使该非需函数调用私有的虚函数, 并传入默认参数值. 代码如下:

    class Shape {
    public:
        enum ShapeColor { Red, Green, Blue };
        void draw(ShapeColor color = Red) const
        {
            doDraw(color);
        }
        ...
    private:
        virtual void doDraw(ShapeColor color) const = 0;
    };

    class Rectangle: public Shape {
    public:
        ...
    private:
        virtual void doDraw(ShapeColor color) const;
        ...
    };

### Item 38: Model "has-a" or "is-implemented-in-terms-of" through composition

Composition means either "has-a" or "is-implemented-in-terms-of". That's because you are dealing with **two different domains** in your software. Some objects in your programs correspond to **things in the world** you are modeling, e.g., people, vehicles, video frames, etc. Such objects are part of the **application domain**. Other objects are purely **implementation artifacts**, e.g., buffers, mutexes, search trees, etc. These kinds of objects correspond to your software's **implementation domain**. When composition occurs between objects in the application domain, it expresses a **has-a relationship**. When it occurs in the implementation domain, it expresses an **is-implemented-in-terms-of relationship**.

### Item 39: Use private inheritance judiciously

Clearly, private inheritance doesn't mean is-a.

"Whoa!" you say. "Before we get to the meaning, let's cover the **behavior**. How does private inheritance behave?" Well, the first rule governing private inheritance you've just seen in action: in contrast to public inheritance, compilers will generally **not convert a derived class object** (such as `Student`) into a base class object (such as `Person`) if the inheritance relationship between the classes is private. That's why the call to eat fails for the object `s`. The second rule is that members inherited from a private base class **become private members of the derived class**, even if they were protected or public in the base class.

**Private inheritance means is-implemented-in-terms-of**. If you make a class `D` privately inherit from a class `B`, you do so because you are interested in taking advantage of some of the features available in class `B`, not because there is any conceptual relationship between objects of types `B` and `D`. As such, private inheritance is purely an implementation technique.

The fact that private inheritance means **is-implemented-in-terms-of** is a little disturbing, because Item 38 points out that **composition can mean the same thing**. How are you supposed to choose between them? The answer is simple: **use composition whenever you can**, and use private inheritance whenever you must. When must you? Primarily when protected members and/or virtual functions enter the picture, though there's also an edge case where space concerns can tip the scales toward private inheritance. We'll worry about the edge case later. After all, it's an edge case.

...

I remarked earlier that private inheritance is useful primarily **when a would-be derived class wants access to the protected parts of a would be base class or would like to redefine one or more of its virtual functions**, but the conceptual relationship between the classes is is-implemented-in-terms-of instead of is-a. However, I also said that there was an edge case involving space optimization that could nudge you to prefer private inheritance over composition.

The edge case is edgy indeed: it applies only when you're **dealing with a class that has no data** in it. Such classes have no non-static data members; no virtual functions (because the existence of such functions adds a `vptr` to each object — see Item 7); and no virtual base classes (because such base classes also incur a size overhead — see Item 40). Conceptually, objects of such empty classes should use no space, because there is no per-object data to be stored. However, there are technical reasons for C++ decreeing that **freestanding objects must have non-zero size**, so if you do this,

    class Empty {};

    class HoldsAnInt {
    private:
        int x;
        Empty e;
    };

you'll find that `sizeof(HoldsAnInt) > sizeof(int)`; an `Empty` data member requires memory. With most compilers, `sizeof(Empty)` is `1`, because C++'s edict against **zero-size freestanding objects** is typically satisfied by the silent insertion of a char into "empty" objects. However, alignment requirements (see Item 50) may cause compilers to add padding to classes like `HoldsAnInt`, so it's likely that `HoldsAnInt` objects wouldn't gain just the size of a `char`, they would actually enlarge enough to hold a second `int`. (On all the compilers I tested, that’s exactly what happened.)

But perhaps you've noticed that I've been careful to say that "freestanding" objects mustn't have zero size. This constraint **doesn't apply to base class parts of derived class objects**, because they're not freestanding. If you inherit from `Empty` instead of containing an object of that type,

    class HoldsAnInt: private Empty {
    private:
        int x;
    };

you're almost sure to find that `sizeof(HoldsAnInt) == sizeof(int)`. This is known as the **empty base optimization (EBO)**, and it's implemented by all the compilers I tested. If you're a library developer whose clients care about space, the EBO is worth knowing about. Also worth knowing is that the **EBO is generally viable only under single inheritance**. The rules governing C++ object layout generally mean that the **EBO can't be applied to derived classes that have more than one base**.

In practice, "empty" classes **aren't truly empty**. Though they never have non-static data members, they often **contain typedefs, enums, static data members, or non-virtual functions**. The STL has many technically empty classes that contain useful members (usually typedefs), including the base classes `unary_function` and `binary_function`, from which classes for user-defined function objects typically inherit. Thanks to widespread implementation of the EBO, such inheritance rarely increases the size of the inheriting classes.

### Item 40: Use multiple inheritance judiciously

When it comes to **multiple inheritance (MI)**, the C++ community largely breaks into two basic camps. One camp believes that if single inheritance (SI) is good, multiple inheritance must be better. The other camp argues that single inheritance is good, but multiple inheritance isn't worth the trouble. In this Item, our primary goal is to understand both perspectives on the MI question.

One of the first things to recognize is that when MI enters the designscape, it becomes possible to inherit the same name (e.g., function, typedef, etc.) from more than one base class. That **leads to new opportunities for ambiguity**.

...

Note that in this example, the call to `checkOut` is ambiguous, **even though only one of the two functions is accessible**. (`checkOut` is public in `BorrowableItem` but private in `ElectronicGadget`.) That's in accord with the C++ rules for resolving calls to overloaded functions: **before seeing whether a function is accessible, C++ first identifies the function that's the best match for the call**. It checks accessibility only after finding the best-match function. In this case, the name `checkOut` is **ambiguous during name lookup**, so neither function overload resolution nor best match determination takes place. The accessibility of `ElectronicGadget::checkOut` is therefore never examined. To resolve the ambiguity, you must specify which base class's function to call:

    mp.BorrowableItem::checkOut();

Multiple inheritance just means inheriting from more than one base class, but it is not uncommon for MI to be found in hierarchies that have higher-level base classes, too. That can lead to what is sometimes known as the **"deadly MI diamond"**:

    class File { ... };

    class InputFile: public File { ... };

    class OutputFile: public File { ... };

    class IOFile: public InputFile,
                  public OutputFile
    { ... };

Any time you have an inheritance hierarchy with **more than one path** between a base class and a derived class (such as between `File` and `IOFile` above, which has paths through both `InputFile` and `OutputFile`), you must confront the question of whether you want the data members in the base class to be replicated for each of the paths. For example, suppose that the `File` class has a data member, `fileName`. **How many copies of this field should `IOFile` have**? On the one hand, it **inherits a copy from each of its base classes**, so that suggests that `IOFile` should have two fileName data members. On the other hand, simple logic says that an `IOFile` object has only one file name, so the `fileName` field it **inherits through its two base classes should not be replicated**.

C++ takes no position on this debate. It happily **supports both** options, though its **default is to perform the replication**. If that's not what you want, you must make the class with the data (i.e., `File`) a **virtual base class**. To do that, you have all classes that immediately inherit from it use **virtual inheritance**:

    class File { ... };

    class InputFile: virtual public File { ... };

    class OutputFile: virtual public File { ... };

    class IOFile: public InputFile,
                  public OutputFile
    { ... };

The standard C++ library contains an MI hierarchy just like this one, except the classes are class templates, and the names are `basic_ios`, `basic_istream`, `basic_ostream`, and `basic_iostream` instead of `File`, `InputFile`, `OutputFile`, and `IOFile`.

**From the viewpoint of correct behavior, public inheritance should always be virtual**. If that were the only point of view, the rule would be simple: anytime you use public inheritance, use virtual public inheritance. Alas, **correctness is not the only perspective**. Avoiding the replication of inherited fields **requires some behind-the-scenes legerdemain** on the part of compilers, and the result is that objects created from classes using virtual inheritance are **generally larger than they would be** without virtual inheritance. Access to data members in virtual base classes is also **slower** than to those in non-virtual base classes. The details vary from compiler to compiler, but the basic thrust is clear: **virtual inheritance costs**.

It **costs in other ways**, too. The rules governing the initialization of virtual base classes are **more complicated** and less intuitive than are those for non-virtual bases. The responsibility for **initializing a virtual base is borne by the most derived class in the hierarchy**. Implications of this rule include (1) classes derived from virtual bases that require initialization must be aware of their virtual bases, no matter how far distant the bases are, and (2) when a new derived class is added to the hierarchy, it must assume initialization responsibilities for its virtual bases (both direct and indirect).

My **advice on virtual base classes** (i.e., on virtual inheritance) is simple. First, **don't use virtual bases unless you need to**. By default, use non-virtual inheritance. Second, if you must use virtual base classes, try to **avoid putting data in them**. That way you won't have to worry about oddities in the initialization (and, as it turns out, assignment) rules for such classes. It's worth noting that Interfaces in Java and .NET, which are in many ways comparable to virtual base classes in C++, are not allowed to contain any data.

...

One reasonable application of multiple inheritance: combine public inheritance of an interface with private inheritance of an implementation.

## Chapter 7: Templates and Generic Programming

Ultimately, it was discovered that the C++ template mechanism is itself **Turing-complete**: it can be used to compute any computable value. That led to template metaprogramming: the creation of programs that execute inside C++ compilers and that stop running when compilation is complete.

### Item 41: Understand implicit interfaces and compiletime polymorphism

The world of templates and generic programming is fundamentally different. In that world, **explicit interfaces** and **runtime polymorphism** continue to exist, but they're less important. Instead, **implicit interfaces** and **compile-time polymorphism** move to the fore.

...

An explicit interface typically consists of function signatures, i.e., function names, parameter types, **return types**, etc. The Widget class public interface, for example,

    class Widget {
    public:
        Widget();
        virtual ~Widget();
        virtual std::size_t size() const;
        virtual void normalize();
        void swap(Widget& other);
    };

consists of a constructor, a destructor, and the functions `size`, `normalize`, and `swap`, along with the parameter types, return types, and constnesses of these functions. (It also includes the compiler-generated copy constructor and copy assignment operator — see Item 5.) It could also include typedefs and, if you were so bold as to violate Item 22's advice to make data members private, data members, though in this case, it does not.

An **implicit interface** is quite different. It is not based on function signatures. Rather, **it consists of valid expressions**. Look again at the conditional at the beginning of the doProcessing template:

    template<typename T>
    void doProcessing(T& w)
    {
        if (w.size() > 10 && w != someNastyWidget) { ...

The implicit interface for `T` (`w`'s type) **appears to have** these constraints:

- It must offer a member function named `size` that returns an integral value.

- It must support an `operator!=` function that compares two objects of type `T`. (Here, we assume that `someNastyWidget` is of type `T`.)

Thanks to the possibility of operator overloading, **neither of these constraints need be satisfied**. Yes, `T` must support a `size` member function, though it's worth mentioning that the function might be inherited from a base class. But this member function **need not return an integral type**. It **need not even return a numeric type**. For that matter, it **need not even return a type for which `operator>` is defined**! All it needs to do is return an object of some type `X` such that there is an `operator>` that can be called with an object of type `X` and an `int` (because 10 is of type int). The `operator>` need not take a parameter of type `X`, because it could take a parameter of type `Y`, and that would be okay as long as there were an implicit conversion from objects of type `X` to objects of type `Y`!

Similarly, there is no requirement that `T` support `operator!=`, because it would be just as acceptable for `operator!=` to take one object of type `X` and one object of type `Y`. As long as `T` can be converted to `X` and `someNastyWidget`'s type can be converted to `Y`, the call to `operator!=` would be valid.

(As an aside, this analysis doesn't take into account the possibility that `operator&&` could be overloaded, thus changing the meaning of the above expression from a conjunction to something potentially quite different.)

...

The implicit interfaces imposed on a template's parameters are just as real as the explicit interfaces imposed on a class's objects, and both are checked during compilation. Just as you can't use an object in a way contradictory to the explicit interface its class offers (the code won't compile), **you can't try to use an object in a template unless that object supports the implicit interface the template requires** (again, the code won't compile).

### Item 42: Understand the two meanings of typename

Question: what is the difference between `class` and `typename` in the following template declarations?

    template<class T> class Widget;
    template<typename T> class Widget;

Answer: nothing. **When declaring a template type parameter**, `class` and `typename` mean exactly the same thing.

...

C++ doesn't always view `class` and `typename` as equivalent, however. Sometimes you must use `typename`.  To understand when, we have to talk about two kinds of names you can refer to in a template.

Suppose we have a template for a function that takes an STL-compatible container holding objects that can be assigned to `int`s. Further suppose that this function simply prints the value of its second element. It's a silly function implemented in a silly way, and as I've written it below, it **shouldn't even compile**, but please overlook those things — there's a method to my madness:

    template<typename C>
    void print2nd(const C& container)  // this is not valid C++
    {
        if (container.size() >= 2) {
            C::const_iterator iter(container.begin());
            ++iter;
            int value = *iter;
            std::cout << value;
        }
    }

I've highlighted the two local variables in this function, `iter` and `value`. The type of `iter` is `C::const_iterator`, a type that depends on the template parameter `C`. **Names in a template that are dependent on a template parameter are called dependent names**. When a dependent name is nested inside a class, I call it a **nested dependent name**. `C::const_iterator` is a nested dependent name. In fact, it's a nested dependent type name, i.e., a nested dependent name that refers to a type.

The other local variable in `print2nd`, `value`, has type `int`. `int` is a name that does not depend on any template parameter. Such names are known as **non-dependent names**, (I have no idea why they're not called independent names. If, like me, you find the term "non-dependent" an abomination, you have my sympathies, but "non-dependent" is the term for these kinds of names, so, like me, roll your eyes and resign yourself to it.)

Nested dependent names can lead to parsing difficulties. For example, suppose we made `print2nd` even sillier by starting it this way:

    template<typename C>
    void print2nd(const C& container)
    {
        C::const_iterator * x;
        ...
    }

This looks like we're declaring `x` as a local variable that's a pointer to a `C::const_iterator`. But it looks that way only because we "know" that `C::const_iterator` is a type. But **what if `C::const_iterator` weren't a type**? What if C had a static data member that happened to be named `const_iterator`, and what if `x` happened to be the name of a global variable? In that case, the code above wouldn't declare a local variable, it would be a multiplication of `C::const_iterator` by `x`! Sure, that sounds crazy, but it's possible, and **people who write C++ parsers have to worry about all possible inputs**, even the crazy ones.

**Until `C` is known, there's no way to know whether `C::const_iterator` is a type or isn't, and when the template `print2nd` is parsed, `C` isn't known**. C++ has a rule to resolve this ambiguity: if the parser encounters a nested dependent name in a template, it assumes that the name is not a type unless you tell it otherwise. **By default, nested dependent names are not types**. (There is an exception to this rule that I'll get to in a moment.)

With that in mind, look again at the beginning of `print2nd`:

    template<typename C>
    void print2nd(const C& container)
    {
        if (container.size() >= 2) {
            C::const_iterator iter(container.begin()); // this name is assumed to not be a type
            ...
Now it should be clear **why this isn't valid C++**. The declaration of `iter` makes sense only if `C::const_iterator` is a type, but we haven't told C++ that it is, and C++ assumes that it's not. To rectify the situation, **we have to tell C++ that `C::const_iterator` is a type**. We do that **by putting `typename` immediately in front of it**:

    template<typename C> // this is valid C++
    void print2nd(const C& container)
    {
        if (container.size() >= 2) {
            typename C::const_iterator iter(container.begin());
            ...
        }
    }

The general rule is simple: **anytime you refer to a nested dependent type name in a template, you must immediately precede it by the word `typename`**. (Again, I'll describe an **exception** shortly.) `typename` should be used to identify only nested dependent type names; other names shouldn't have it. For example, here's a function template that takes both a container and an iterator into that container:

    template<typename C>        // typename allowed (as is "class")
    void f(const C& container,  // typename not allowed
           typename C::iterator iter);  // typename required

`C` is not a nested dependent type name (it's not nested inside anything dependent on a template parameter), so it must not be preceded by `typename` when declaring container, but `C::iterator` is a nested dependent type name, so it's required to be preceded by `typename`.

The **exception** to the "`typename` must precede nested dependent type names" rule is that `typename` must not precede nested dependent type names **in a list of base classes** or **as a base class identifier in a member initialization list**. For example:

    template<typename T>
    class Derived: public Base<T>::Nested {  // base class list: typename not allowed
    public:
        explicit Derived(int x)
            : Base<T>::Nested(x)  // base class identifier in member initialization list: typename not allowed
        {
            typename Base<T>::Nested temp;
            ...
        } 
        ...
    };

Such inconsistency is irksome, but once you have a bit of experience under your belt, you'll barely notice it.

Let's look at one last `typename` example, because it's representative of something you're going to see in real code. Suppose we're writing a function template that takes an iterator, and we want to make a local copy, `temp`, of the object the iterator points to. We can do it like this:

    template<typename IterT>
    void workWithIterator(IterT iter)
    {
        typename std::iterator_traits<IterT>::value_type temp(*iter);
        ...
    }

Don't let the `std::iterator_traits<IterT>::value_type` startle you. That's just a use of a standard traits class (see Item 47), the C++ way of saying "**the type of thing pointed to by objects of type IterT**." The statement declares a local variable (`temp`) of the same type as what `IterT` objects point to, and it initializes `temp` with the object that `iter` points to. If `IterT` is `vector<int>::iterator`, `temp` is of type `int`. If `IterT` is `list<string>::iterator`, `temp` is of type `string`. Because `std::iterator_traits<IterT>::value_type` is a nested dependent type name (`value_type` is nested inside `iterator_traits<IterT>`, and `IterT` is a template parameter), we must precede it by `typename`.

If you think reading `std::iterator_traits<IterT>::value_type` is unpleasant, imagine what it's like to type it. If you're like most programmers, the thought of typing it more than once is ghastly, so you'll want to create a `typedef`. For traits member names like `value_type` (again, see Item 47 for information on traits), a common convention is for the `typedef` name to be the same as the traits member name, so such a local typedef is often defined like this:

    template<typename IterT>
    void workWithIterator(IterT iter)
    {
        typedef typename std::iterator_traits<IterT>::value_type value_type;
        value_type temp(*iter); ...
    }

Many programmers find the "typedef typename" juxtaposition initially jarring, but it's a logical fallout from the rules for referring to nested dependent type names. You'll get used to it fairly quickly. After all, you have strong motivation. How many times do you want to type `typename std::iterator_traits<IterT>::value_type`?

As a closing note, I should mention that enforcement of the rules surrounding `typename` **varies from compiler to compiler**. Some compilers accept code where `typename` is required but missing; some accept code where `typename` is present but not allowed; and a few (usually older ones) reject `typename` where it's present and required. This means that the interaction of `typename` and nested dependent type names can lead to some mild portability headaches.

Things to Remember:

- **When declaring template parameters**, `class` and `typename` are interchangeable.

- Use `typename` to identify **nested dependent type names**, except in base class lists or as a base class identifier in a member initialization list.

### Item 43: Know how to access names in templatized base classes

当基类为模板类, 在派生类中调用基类的函数时, 不能仅通过函数名调用, 否则会编译报错. 因为编译器在处理派生类定义时无法确定基类类型(因为模板类型未确定, 且考虑到模板特化可以定义与通用模板不同的实现), 所以编译器无法确定基类中是否实现了派生类中调用的函数.

上述在派生类中引用模板基类中的**函数**的情况同样适用于引用模板基类中的**成员变量**. 编译器拒绝为派生类查找可能继承自模板基类的名称(函数/变量...).

可通过三种方式解决上述问题:

1. `this->` + 名称

2. 使用 `using` 声明名称来自于模板基类

3. 通过类名显式引用

   该方法不推荐使用, 因为对于虚函数, 会失去动态绑定的行为

Fundamentally, the issue is whether compilers will diagnose invalid references to base class members sooner (when derived class template definitions are parsed) or later (when those templates are instantiated with specific template arguments). C++'s policy is to prefer early diagnoses, and that's why it **assumes it knows nothing about the contents of base classes** when those classes are instantiated from templates.

Things to Remember:

- In derived class templates, refer to names in base class templates via a "`this->`" prefix, via `using` declarations, or via an explicit base class qualification.

### Item 44: Factor parameter-independent code out of templates

This Item has discussed only bloat due to non-type template parameters, but type parameters can lead to bloat, too.

Things to Remember:

- Templates generate multiple classes and multiple functions, so any template code not dependent on a template parameter causes bloat.

- Bloat due to non-type template parameters can often be eliminated by replacing template parameters with function parameters or class data members.

- Bloat due to type parameters can be reduced by sharing implementations for instantiation types with identical binary representations

### Item 45: Use member function templates to accept "all compatible types"

**Iterators into STL containers are almost always smart pointers**; certainly you couldn't expect to move a built-in pointer from one node in a linked list to the next by using "`++`", yet that works for `list::iterators`.

...

与具有隐式转换关系的两种类型的指针相应的两种智能指针之间没有隐式转换关系. 因为这两种智能指针均为模板类实例化后产生的新类型, 编译器将其视为两种完全不同的类型, 二者间的转换关系需要定义.

两种类型间的转换可通过构造函数实现, 常规情况下, 对于类型 `A`, 每增加一种可转换至 `A` 的类型, 就需要在 `A` 中定义对应的构造函数. 这不得不产生重复性的工作, 且需要修改 `A` 代码. 对于智能指针模板类, 为了避免上述问题, 可使用模板类的成员函数模板, 更具体是构造函数模板(又称 generalized copy constructor).

    template<typename T>
        class SmartPtr {
        public:
            template<typename U>  // member template 
            SmartPtr(const SmartPtr<U>& other);
            ...
    };

注意, 构造函数模板声明中未使用 `explicit` 关键字, 以便支持隐式类型转换.

具体实现上依赖智能指针的 `get` 方法:

    template<typename T>
    class SmartPtr {
    public:
        template<typename U>
        SmartPtr(const SmartPtr<U>& other)
        : heldPtr(other.get()) { ... }

        T* get() const { return heldPtr; }
        ...
    private:
        T *heldPtr;
    };

注意, 以上实现自然地过滤了 `U*` 无法隐式转换为 `T*` 的情况, 这是我们希望的.

同样, 智能指针也应支持具有转换关系的指针的赋值, 以 `shared_ptr` 为例:

    template<class T> class shared_ptr {
    public:
        template<class Y>
        explicit shared_ptr(Y * p);

        template<class Y>
        shared_ptr(shared_ptr<Y> const& r);  // generalized copy constructor

        template<class Y>
        explicit shared_ptr(weak_ptr<Y> const& r);

        template<class Y>
        explicit shared_ptr(auto_ptr<Y>& r);

        template<class Y>
        shared_ptr& operator=(shared_ptr<Y> const& r);  // generalized copy assignment

        template<class Y>
        shared_ptr& operator=(auto_ptr<Y>& r);

        ...
    };

注意, 上面代码中的构造函数中, 只有 generalized copy constructor 没有使用 `explicit` 关键字, 使得除 `shared_ptr` 模板类型之外的类型均不支持隐式转换为 `shared_ptr` 模板类型.

注意, 上面代码中通过定义 generalized copy constructor 与 generalized copy assignment 并不能阻止编译器(在代码中有使用复制构造函数或赋值运算符时)生成默认的复制构造函数和赋值运算符. 为了阻止这一行为, 已使复制构造函数与赋值运算符遵循我们的需要, 我们需要对二者进行定义:

    template<class T> class shared_ptr {
    public:
        shared_ptr(shared_ptr const& r);  // copy constructor

        template<class Y>
        shared_ptr(shared_ptr<Y> const& r);  // generalized copy constructor

        shared_ptr& operator=(shared_ptr const& r);  // copy assignment

        template<class Y>
        shared_ptr& operator=(shared_ptr<Y> const& r);  // generalized copy assignment

        ...
    };

Things to Remember:

- Use member function templates to generate functions that accept all compatible types.

- If you declare member templates for generalized copy construction or generalized assignment, you’ll still need to declare the normal copy constructor and copy assignment operator, too.

### Item 46: Define non-member functions inside templates when type conversions are desired




