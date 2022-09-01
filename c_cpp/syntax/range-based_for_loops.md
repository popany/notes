# range-based for loops

- [range-based for loops](#range-based-for-loops)
  - [C++11 range-based for loops](#c11-range-based-for-loops)
  - [C++ 11: Range based for loop and `std::for_each()` function](#c-11-range-based-for-loop-and-stdfor_each-function)
  - [practice](#practice)

## [C++11 range-based for loops](https://www.cprogramming.com/c++11/c++11-ranged-for-loop.html)

    #include <iostream>
     
    using namespace std;
     
    // forward-declaration to allow use in Iter
    class IntVector;
     
    class Iter
    {
        public:
        Iter (const IntVector* p_vec, int pos)
            : _pos( pos )
            , _p_vec( p_vec )
        { }
     
        // these three methods form the basis of an iterator for use with
        // a range-based for loop
        bool
        operator!= (const Iter& other) const
        {
            return _pos != other._pos;
        }
     
        // this method must be defined after the definition of IntVector
        // since it needs to use it
        int operator* () const;
     
        const Iter& operator++ ()
        {
            ++_pos;
            // although not strictly necessary for a range-based for loop
            // following the normal convention of returning a value from
            // operator++ is a good idea.
            return *this;
        }
     
        private:
        int _pos;
        const IntVector *_p_vec;
    };
     
    class IntVector
    {
        public:
        IntVector ()
        {
        }
     
        int get (int col) const
        {
            return _data[ col ];
        }
        Iter begin () const
        {
            return Iter( this, 0 );
        }
     
        Iter end () const
        {
            return Iter( this, 100 );
        }
     
        void set (int index, int val)
        {
            _data[ index ] = val;
        }
     
        private:
       int _data[ 100 ];
    };
     
    int
    Iter::operator* () const
    {
         return _p_vec->get( _pos );
    }
     
    // sample usage of the range-based for loop on IntVector
    int main()
    {
        IntVector v;
        for ( int i = 0; i < 100; i++ )
        {
            v.set( i , i );
        }
        for ( int i : v ) { cout << i << endl; }
    }

## [C++ 11: Range based for loop and `std::for_each()` function](https://www.go4expert.com/articles/cpp-11-range-based-loop-stdforeach-t34604/)

    #include<iostream>
    
    #include<memory>
    #include<algorithm>
    
    using namespace std;
    
    template<class T>
    class MyItr
    {
    private:
        int index;
        T* theArray;
    public:
        MyItr(T* arr, int pos) :theArray{ arr }, index{ pos }
        {
            cout << endl << "Iterator Constructor is called" << endl;
        }
        
        T& operator *() const
        {
            cout << endl << "* operator is called" << endl;
            return theArray[index];
        }
        
        const MyItr& operator++() // Prefix incrementor
        {
            cout <<endl<< "Prefix increment operator is called" << endl;
            ++index;
            return *this;
        }
        const MyItr& operator+(int pos) // + opearator
        {
            cout << endl << "+ operator is called" << endl;
            index+=pos;
            return *this;
        }
        const MyItr& operator-(int pos) // - operator
        {
            cout << endl << "- operator is called" << endl;
            index -= pos;
            return *this;
        }
        
        bool operator !=(const MyItr& other) const
        {
            cout << endl << "!= operator is called" << endl;
            return index != other.index;
        }
    };
    
    template<class T>
    class MyArray
    {
    
    public:
        
        MyArray(int csize) :size{ csize } // All elements is set to zero
        {
            pArr = unique_ptr<int>(new T[size]);
        }
        
        MyItr<T> begin()
        {
            cout << endl << "Creating begin iterator" << endl;
            return MyItr<T>(pArr.get(), 0);
        }
        
        MyItr<T> end()
        {
            cout << endl << "Creating end iterator" << endl;
            return MyItr<int>(pArr.get(), size);
        }
        
    
    private:
        const int size = 5; //Size of the array
        unique_ptr<T> pArr;
    
    };
    
    struct Sum {
        Sum() :sum{ 0 } {}
        void operator()(int i) { cout << i << " ";sum += i; }
        int sum;
    };
    
    int main() 
    {
        //vector<int>::const_iterator itr;
        MyArray<int> arr(10);
        int i{ 1 };
        // replace each number with it's aquare number
        for (int& item : arr)
        {
            item = i*i;
            ++i;
        }
        //Find the sum of a range 
        Sum s =
        ...
    
    }

## practice

    #include <iostream>
    #include <vector>

    template <typename T>
    class VectorView {
    public:
        VectorView(typename std::vector<T>::iterator begin, typename std::vector<T>::iterator end):
            begin_{begin},
            end_{end}
        {}

        typename std::vector<T>::iterator begin() {
            return begin_;
        }
        typename std::vector<T>::iterator end() {
            return end_;
        }

    private:
        typename std::vector<T>::iterator begin_;
        typename std::vector<T>::iterator end_;
    };

    int main(int argc, char* argv[])
    {
        std::vector<int> v{1, 2, 3, 4, 5};
        std::cout << "--------------------------" << std::endl;
        for (auto e : v) {
            std::cout << e << std::endl;
        }
        std::cout << "--------------------------" << std::endl;
        VectorView<int> vv{v.begin() + 1, v.end() - 1};
        for (auto e : vv) {
            std::cout << e << std::endl;
        }

        return 0;
    }
