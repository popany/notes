# access private

- [access private](#access-private)
  - [github](#github)
  - [案例](#案例)

## github

[martong/access_private](https://github.com/martong/access_private)

## 案例

    #include <iostream>
    
    class Foo {
    public:
        int x;
    };
    
    class B {
    public:
        B() {
            f.x = 0;
        }
    
        void print() {
            std::cout << "f.x: " << f.x << std::endl;
        }
    
    private:
        Foo f;
    };
    
    template <typename PtrType, PtrType PtrValue, typename TagType>
    struct private_access {
        friend PtrType get(TagType) { return PtrValue; }
    };
    
    struct PrivateAccessTag {};
    template
    struct private_access<decltype(&B::f), &B::f, PrivateAccessTag>;
    
    using Alias_PrivateAccessTag = Foo;
    using PtrType_PrivateAccessTag = Alias_PrivateAccessTag B::*;
    PtrType_PrivateAccessTag get(PrivateAccessTag);
    
    Foo& Bf(B &t) {
        return t.*get(PrivateAccessTag{});
    }
    
    int main(int argc, char* argv[])
    {
        B b;
        b.print();
        auto& f = Bf(b);
        f.x = 1;
        b.print();
    
        return 0;
    }
    
output:

    f.x: 0
    f.x: 1

note:

1. `PtrType_PrivateAccessTag` is member pointer type.
2. `PtrType_PrivateAccessTag get(PrivateAccessTag);` declare a function return member pointer type of `B`.
3. 
       template
       struct private_access<decltype(&B::f), &B::f, PrivateAccessTag>;

   Specialize the template that define the function `PtrType_PrivateAccessTag get(PrivateAccessTag)`.

4.
       Foo& Bf(B &t) {
           return t.*get(PrivateAccessTag{});
       }

   `get` returns a member pointer, `t.*` access the member pointer. above function can be also write as:

       Foo& Bf(B &t) {
           auto p = get(PrivateAccessTag{});
           return t.*p;
       }
