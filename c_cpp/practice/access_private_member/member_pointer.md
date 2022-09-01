# member pointer

- [member pointer](#member-pointer)
  - [demo](#demo)

## demo

    #include <iostream>
    
    class A {
    public:
        int v{0};
    };
    
    int A::* test1() {
        std::cout << "111111" << std::endl;
        return &A::v;
    }
    
    double A::* test2() {
        std::cout << "222222" << std::endl;
        return (double A::* )&A::v;
    }
    
    int main() {
        A a;
        a.*test1();
        a.*test2();
    
        std::cout << "v: " << a.v << std::endl;
        auto pv = test1();
        a.*pv =  2;
        std::cout << "v: " << a.v << std::endl;
    
        return 0;
    }

output:

    111111
    222222
    v: 0
    111111
    v: 2

note:

`int A::*` is member pointer type to `int` member of `A`.
