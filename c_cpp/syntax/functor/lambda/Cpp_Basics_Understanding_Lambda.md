# [C++ Basics: Understanding Lambda](https://towardsdatascience.com/c-basics-understanding-lambda-7df00705fa48)

- [C++ Basics: Understanding Lambda](#c-basics-understanding-lambda)
  - [Introduction](#introduction)
  - [Lambda Expressions](#lambda-expressions)
    - [Function Object or Functor](#function-object-or-functor)
    - [Lambdas vs. Functors](#lambdas-vs-functors)
    - [Callback Function](#callback-function)
    - [Capturing Variables to create/initialize member variables](#capturing-variables-to-createinitialize-member-variables)
    - [Some other details](#some-other-details)
      - [It can be converted to a raw function pointer if it doesn't capture](#it-can-be-converted-to-a-raw-function-pointer-if-it-doesnt-capture)
      - [By default the overloaded `operator()` is const](#by-default-the-overloaded-operator-is-const)
    - [Passing Lambdas as Arguments](#passing-lambdas-as-arguments)
      - [The STL way, with template](#the-stl-way-with-template)
      - [Use `std::function`](#use-stdfunction)
  - [Summary and References](#summary-and-references)

A convenient way to define a functor that can help us to simplify the code.

## Introduction

One of the new features introduced in Modern C++ starting from C++11 is Lambda Expression.

It is a convenient way to **define an anonymous function object or functor**. It is convenient because we can define it locally where we want to call it or pass it to a function as an argument.

Lambda is easy to read too because we can keep everything in the same place.

In this post, we'll look at what a lambda is, compare it with a function object (functor), and more importantly understand what it actually is and how to think about it when coding in C++.

## Lambda Expressions

This is how we define a lambda in C++:

    auto plus_one = [](const int value)
    {
        return value + 1;
    };

    assert(plus_one(2) == 3);

`plus_one` in this code is a functor under the hood. Let’s now first see what a functor is.

### Function Object or Functor

According to [Wikipedia](https://en.wikipedia.org/wiki/Function_object), A function object or usually referred to as a functor is a construct that allows an object to be called as if it were an ordinary function.

The keyword here is the "ordinary function". In C++ **we can overload `operator ()` to implement a functor**. Here is a functor that behaves the same as our lambda:

    struct PlusOne
    {
        int operator()(const int value) const
        {
            return value + 1;
        }
    };

    int main ()
    {   
        PlusOne plusOne;
        assert(plusOne(2) == 3);

        return 0;
    }

One example of the advantages of using a functor over an ordinary function is that it can access the internal member variables and functions of that object.

It will be clearer when we want to create functions "plus one", "plus two", etc. By using a functor we don't have to define multiple functions with unique names.

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

        Plus plusTwo(2);
        assert(plusTwo(2) == 4);

        return 0;
    }

As you can see, at the caller side it **looks like a call to an ordinary function**.

How does it look like at the machine level? Well, a functor is an object so it has member variables and member functions. The ordinary function is as follows:

    int plus_one(const int value)
    {
        return value + 1;
    }

whereas a functor is as follows:

    int PlusOne::operator()(const PlusOne* this, const int value)
    {
        return value + this->data;
    }

### Lambdas vs. Functors

If we already have a functor which in some scenarios is better than an ordinary function, why do we need lambda?

Lambda offers a simpler way to write a functor. **It is a syntactic sugar for an anonymous functor**. It reduces the boilerplate that we need to write in a functor.

To see how lambda simplifies a functor, we create a lambda for our `Plus` class above.

    auto plus = [data=1](const int value)
    {
        return value + data;
    };

    assert(plus(2) == 3);

We can remove a lot of boilerplate code from our functor above. We know that our functor looks like this:

    int PlusOne::operator()(const PlusOne* this, const int value)
    {
        return value + this->data;
    }

What about our lambda? By assuming we define our lambda inside our main function this is how it looks like:

    int main::lambda::operator()(const lambda* hidden, const int value)
    {
        return value + hidden->data;
    }

It's very much similar to our functor other than the name. So now we know that our lambda is just a functor, without a name and with a simplified form.

Another thing that you may notice is the hidden pointer's name isn't called `this` because the `this` keyword is used for the outer scope's object.

### Callback Function

Both functors and lambdas are often used for writing callback functions. They are very useful when we deal with STL algorithms. For example when we want to transform our data stored in a `std::vector`. With a functor we can write it as follows:

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
        Plus plus_one(1);
        std::vector<int> test_data = {1, 2, 3, 4};
    
        std::transform(test_data.begin(), test_data.end(), test_data.begin(), plus_one);
        return 0;
    }

After calling std::transform, we'll get `{2, 3, 4, 5}`. With lambda this is how we write it:

    int main ()
    {
        Plus plus_one(1);
        std::vector<int> test_data = {1, 2, 3, 4};
        
        std::transform(test_data.begin(), test_data.end(), test_data.begin(), [](const int value)
        {
            return value + 1;
        });

        return 0;
    }

We can see that it is much neater with a lambda where we can read the code without having to jump to another place to see what operation is done to transform our `test_data`.

### Capturing Variables to create/initialize member variables

We should think about a lambda as an object, to **create and initialize member variables** we use the capture '[]' mechanism. To create and initialize a variable we can simply write it in '[]':

    auto return_one = [value=1](){ return value; };

We can also make a copy of another object in the scope:

    void func()
    {
        int a = 1;
        // by value
        auto return_one = [value=a](){ return value; };
    }

    void func()
    {
        int a = 1;
        // by reference
        auto return_one = [&value=a](){ return value; };
    }

### Some other details

Some other things that are important to know about lambdas are:

#### It can be converted to a raw function pointer if it doesn't capture

    int Plus(const int a, int(*GetValue)())
    {
        return GetValue() + a;
    }

    int main ()
    {
        auto value_getter = [value=1]()
        {
            return value;
        };

        int res = Plus(1, value_getter);

        return 0;
    }

The code above **won't compile** because the lambda is not convertible to a function pointer according to the standard, the most obvious reason is that there is a hidden parameter in the `operator()`. But it is convertible if it doesn't capture, so the following compiles:

    int Plus(const int a, int(*GetValue)())
    {
        return GetValue() + a;
    }

    int main ()
    {
        auto value_getter = []()
        {
            return 1;
        };

        int res = Plus(1, value_getter);

        return 0;
    }

This is because there exists a [user-defined conversion function](https://en.cppreference.com/w/cpp/language/cast_operator) for capture-less lambdas.

    int(*GetValue)() = [](){return 1;}

#### By default the overloaded `operator()` is const

    int main ()
    {
        int a;

        auto test = [value=a]()
        {
            return value++;
        };

        int res = test();

        return 0;
    }

This code **won't compile** because we are trying to modify a member variable in a const function. Remember that it looks like this under the hood:

    int main::lambda::operator()(const lambda* hidden)
    {
        return hidden->value++;
    }

The hidden pointer points to a constant lambda object hence the error. To modify the captured variable, we **add a `mutable` keyword** as follows:

    int main ()
    {
        int a;

        auto test = [value=a]() mutable
        {
            return value++;
        };

        int res = test();

        return 0;
    }

### Passing Lambdas as Arguments

We have seen one way to pass a lambda as an argument above, via conversion to a raw function pointer. But that only works for capture-less lambdas.

There are two ways to pass lambdas as arguments of functions:

#### The STL way, with template

    template<typename T>
    int Plus(const int a, T fp)
    {
        return fp(a);
    }

    int main ()
    {
        auto plus_one = [value=1](const int x) -> int
        {
            return x + value;
        };

        int res = Plus(5, plus_one);
        assert(res==6);

        return 0;
    }

#### Use `std::function`

    int Plus(const int a, std::function<int(const int)> fp)
    {
        return fp(a);
    }

    int main ()
    {
        auto plus_one = [value=1](const int x) -> int
        {
            return x + value;
        };

        int res = Plus(5, plus_one);
        assert(res==6);

        return 0;
    }

## Summary and References

We have seen that lambda is just a convenient way to write a functor, therefore **we should always think about it as a functor** when coding in C++.

We should use lambdas where we can improve the readability of and simplify our code such as when writing callback functions.
