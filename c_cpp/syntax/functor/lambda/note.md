# Lambda

- [Lambda](#lambda)
  - [Lambda 表达式等价于一个匿名 functor](#lambda-表达式等价于一个匿名-functor)
  - [References](#references)

## Lambda 表达式等价于一个匿名 functor

    class Plus
    {
    public:
        Plus(const int data) : 
            data(data) {}

        int operator()(const int value) const
        {
            return value + data;
        }
    private:
        const int data;
    };

    int main ()
    {   
        Plus plusOne(1);
        assert(plusOne(2) == 3);

        auto plus = [data=1](const int value)
        {
            return value + data;
        };

        assert(plus(2) == 3);

        return 0;
    }

上述代码中 `plusOne` 与 `plus` 等价. 推测 lambda 表达式对应的匿名 functor 存在于栈上.

## References

[C++ Basics: Understanding Lambda](https://towardsdatascience.com/c-basics-understanding-lambda-7df00705fa48)
