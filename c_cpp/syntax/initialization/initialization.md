# Initialization

- [Initialization](#initialization)
  - [C++11 Brace-Initialization](#c11-brace-initialization)
  - [Class Member Initialization](#class-member-initialization)
  - [Initializer Lists and Sequence Constructors](#initializer-lists-and-sequence-constructors)
  - [Reference](#reference)
    - [Get to Know the New C++11 Initialization Forms](#get-to-know-the-new-c11-initialization-forms)

## C++11 Brace-Initialization

    //C++11 brace-init
    int a{0};

    string s{"hello"};
    string s2{s}; //copy construction

    vector <string> vs{"alpha", "beta", "gamma"};

    map<string, string> stars
        { {"Superman", "+1 (212) 545-7890"},
          {"Batman", "+1 (212) 545-0987"} };

    double *pd= new double [3] {0.5, 1.2, 12.99};

    class C
    {
        int x[4];
    public:
        C(): x{0,1,2,3} {}
    };

An empty pair of braces indicates default initialization. Default initialization of POD types usually means initialization to **binary zeros**, whereas for non-POD types default initialization means default construction:

    //C++11: default initialization using {}
    int n{}; //zero initialization: n is initialized to 0
    int *p{}; //initialized to nullptr
    double d{}; //initialized to 0.0
    char s[12]{}; //all 12 chars are initialized to '\0'
    string s{}; //same as: string s;
    char *p=new char [5]{}; // all five chars are initialized to '\0'

## Class Member Initialization

    class C
    {
        string s("abc");
        double d=0;
        char * p {nullptr};
        int y[5] {1,2,3,4};
    public:
        C();
    };

Regardless of the initialization form used, the compiler conceptually transforms every **class member initializer** into a corresponding **mem-init**. Thus, `class C` above is semantically equivalent to the following class:

    class C2
    {
        string s;
        double d;
        char * p;
        int y[5];
    public:
        C() : s("abc"), d(0.0), p(nullptr), y{1,2,3,4} {}
    };

Bear in mind that if the same data member has both a class member initializer and a mem-init in the constructor, the latter takes precedence. In fact, you can take advantage of this behavior by specifying a default value for a member in the form of a class member initializer that will be used if the constructor doesn't have an explicit mem-init for that member. Otherwise, the constructor's mem-init will take effect, overriding the class member initializer. This technique is useful in classes that have multiple constructors.

## Initializer Lists and Sequence Constructors

An **initializer list** lets you use a sequence of values wherever an initializer can appear. For example, you can initialize a vector in C++11 like this:

    vector<int> vi {1,2,3,4,5,6};
    vector<double> vd {0.5, 1.33, 2.66};

C++11 furnishes every STL container with a new constructor type called a **sequence constructor**. A sequence constructor intercepts initializers in the form of `{x,y...}`. To make this machinery work, C++11 introduced another secret ingredient: an auxiliary class template called `std::initializer_list<T>`. When the compiler sees an **initializer list**, say `{0.5, 1.33, 2.66}`, it transforms the values in that list into an array of `T` with `n` elements (`n` is the number of values enclosed in braces) and uses that array to populate an implicitly generated `initializer_list<T>` object. The class template `initializer_list` has three member functions that access the array:

    template<class E> class initializer_list
    {
    //implementation (a pair of pointers or a pointer + length)
    public:
        constexpr initializer_list(const E*, const E*); // [first,last)
        constexpr initializer_list(const E*, int); // [first, first+length)
        constexpr int size() const; // no. of elements
        constexpr const T* begin() const; // first element
        constexpr const T* end() const; // one more than the last element
    };

To better understand how the compiler handles initializer lists of containers, let's dissect a concrete example. Suppose your code contains the following declaration of a vector:

    vector<double> vd {0.5, 1.33, 2.66};

The compiler detects the initializer list `{0.5, 1.33, 2.66}` and performs the following steps:

1. Detect the type of the values in the initializer list. In the case of `{0.5, 1.33, 2.66}`, the type is `double`.

2. Copy the values from the list into an array of three `double`s.

3. Construct an `initializer_list<double>` object that "wraps" the array created in the preceding step.

4. Pass the `initializer_list<double>` object by reference to `vd`'s **sequence constructor**. The constructor in turn allocates `n` elements in the `vector` object, initializing them with the values of the array.

## Reference

### [Get to Know the New C++11 Initialization Forms](https://www.informit.com/articles/article.aspx?p=1852519)
