# iterator

- [iterator](#iterator)

## [Is it necessary to pass iterator by const reference](https://stackoverflow.com/a/17334108)

1. First, to answer the question in the title, is it necessary to pass iterators by (const) reference: **No**. An iterator acts as a proxy for the data item in the container, regardless of whether or not the iterator itself is a copy of or a reference to another iterator. Also in the case when the iterator gets invalidated by some operation performed on the container, whether you maintain it by copy or reference will not make a difference.

2. Second, which of the two options is better.

   I'd pass the iterator by copy (i.e. your second option).

   The rule of thumb is: Pass by reference if you either want to modify the original variable passed to the function, or if the object you pass is large and copying it involves a major effort.

   Neither is the case here: Iterators are small, lightweight objects, and given that you suggested a const-reference, it is also clear that you don't want to make a modification to it that you want reflected in the variable passed to the function.

3. As a third option, I'd like you to consider adding `const` to your second option:

    void updateC(const unordered_map<string,int>::iterator iter)
    {
        iter->second = 100; 
    }

This ensures you won't accidentally re-assign `iter` inside the function, but still allows you to modify the original container item referred to by `iter`. It also may give the compiler the opportunity for certain optimizations (although in a simple situation like the one in your question, these optimizations might be applied anway).

