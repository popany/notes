# Misc C++ Syntax

- [Misc C++ Syntax](#misc-c-syntax)

1. It's never legal to modify the return value of a function that returns a **built-in** type.

   This can not be compiled:

       int func()
       {
           return 0;
       }
      
       int main()
       {
           func() = 1;
      
           return 0;
       }

   This can be compiled:

       class A
       {
       public:
           A& operator=(const A& other)
           {
               return *this;
           }
       };
      
       A func()
       {
           return A();
       }
      
       int main()
       {
           A a;
           func() = a;
      
           return 0;
       }

2. const member function can modify static member

   This can be compiled:

       class A
        {
            static int a;
       
        public:
            A()
            {}
       
            void set(int a) const
            {
                this->a = a;
            }
       
            int get() const
            {
                return a;
            }
       
        };
       
        int A::a;

   This can not be compiled:

       class A
       {
           int a;
      
       public:
           A()
           {}
      
           void set(int a) const
           {
               this->a = a;
           }
      
           int get() const
           {
               return a;
           }
      
       };
