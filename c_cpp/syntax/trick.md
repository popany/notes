# Trick

- [Trick](#trick)

## [Call base virtual method by pointer to function from derived class](https://stackoverflow.com/a/48082503)

Virtual methods are designed to implement polymorphism and pointers to virtual methods supports their polymorphic behavior. But you given the possibility to call the base method by **explicitly calling `p->A::foo()`**.

So if you want to call base method by pointer, you should make it non-virtual (as @PasserBy mentioned in comments).

    Code example:

    struct A {
        virtual void foo() { std::cout << "A::foo()" << std::endl; }
        void bar() { std::cout << "A::bar()" << std::endl; }
        void callBase(void (A::*f)()) { (this->*f)(); }
    };

    struct B : A {
        virtual void foo() { std::cout << "B::foo()" << std::endl; }
        void bar() { std::cout << "B::bar()" << std::endl; }
    };

    int main()
    {
        A* p = new B();
        p->foo();
        p->bar();
        p->callBase(&A::foo);
        p->callBase(&A::bar);
        p->A::foo();
        p->A::bar();
    }
    Output:

    B::foo()
    A::bar()
    B::foo()
    A::bar()
    A::foo()
    A::bar()

## [Casting between void * and a pointer to member function](https://stackoverflow.com/a/7139664)

It is possible to convert pointer to member functions and attributes using unions:

    // helper union to cast pointer to member
    template<typename classT, typename memberT>
    union u_ptm_cast {
        memberT classT::*pmember;
        void *pvoid;
    };

To convert, put the source value into one member, and pull the target value out of the other.

While this method is practical, I have no idea if it's going to work in every case.
