# yield

- [yield](#yield)
  - [What does the “yield” keyword do?](#what-does-the-yield-keyword-do)
    - [Iterables](#iterables)
    - [Generators](#generators)
    - [Yield](#yield-1)
    - [Your code explained](#your-code-explained)
    - [Controlling a generator exhaustion](#controlling-a-generator-exhaustion)
    - [Itertools, your best friend](#itertools-your-best-friend)
    - [Understanding the inner mechanisms of iteration](#understanding-the-inner-mechanisms-of-iteration)
  - [Python | yield Keyword](#python--yield-keyword)
    - [Code #1 : Demonstrating yield working](#code-1--demonstrating-yield-working)
    - [Code #2:](#code-2)
    - [Advantages of yield](#advantages-of-yield)
    - [Disadvantages of yield](#disadvantages-of-yield)
    - [Practical Applications](#practical-applications)
  - [When to use yield instead of return in Python?](#when-to-use-yield-instead-of-return-in-python)
  - [How to Use Generators and yield in Python](#how-to-use-generators-and-yield-in-python)

## [What does the “yield” keyword do?](https://stackoverflow.com/questions/231767/what-does-the-yield-keyword-do)

To understand what `yield` does, you must understand what `generators` are. And before you can understand `generators`, you must understand `iterables`.

### Iterables

When you create a list, you can read its items one by one. Reading its items one by one is called iteration:

    >>> mylist = [1, 2, 3]
    >>> for i in mylist:
    ...    print(i)
    1
    2
    3

`mylist` is an `iterable`. When you use a list comprehension, you create a `list`, and so an `iterable`:

    >>> mylist = [x*x for x in range(3)]
    >>> for i in mylist:
    ...    print(i)
    0
    1
    4

Everything you can use "`for... in...`" on is an `iterable`; `lists`, `strings`, files...

These iterables are handy because you can read them as much as you wish, but you store all the values in memory and this is not always what you want when you have a lot of values.

### Generators

**`Generators` are `iterators`**, a kind of iterable you **can only iterate over once**. Generators do not store all the values in memory, they generate the values on the fly:

    >>> mygenerator = (x*x for x in range(3))
    >>> for i in mygenerator:
    ...    print(i)
    0
    1
    4

It is just the same except you used `()` instead of `[]`. BUT, you cannot perform `for i in mygenerator` a second time since generators **can only be used once**: they calculate 0, then forget about it and calculate 1, and end calculating 4, one by one.

### Yield

`yield` is a keyword that is **used like `return`**, except the function will **return a `generator`**.

    >>> def createGenerator():
    ...    mylist = range(3)
    ...    for i in mylist:
    ...        yield i*i
    ...
    >>> mygenerator = createGenerator() # create a generator
    >>> print(mygenerator) # mygenerator is an object!
    <generator object createGenerator at 0xb7555c34>
    >>> for i in mygenerator:
    ...     print(i)
    0
    1
    4

Here it's a useless example, but it's handy **when you know your function will return a huge set of values that you will only need to read once**.

To master `yield`, you must understand that **when you call the function, the code you have written in the function body does not run**. The function only returns the generator object, this is a bit tricky :-)

Then, your code will **continue from where it left off each time `for`** uses the generator.

Now the hard part:

The first time the `for` calls the generator object created from your function, it will run the code in your function from the beginning until it hits `yield`, then it'll **return the first value of the loop**. Then, each subsequent call will run another iteration of the loop you have written in the function and return the next value. This will **continue until the generator is considered empty**, which happens when the function runs without hitting `yield`. That can be because the loop has come to an end, or because you no longer satisfy an "`if/else`".

### Your code explained

Generator:

    # Here you create the method of the node object that will return the generator
    def _get_child_candidates(self, distance, min_dist, max_dist):

        # Here is the code that will be called each time you use the generator object:

        # If there is still a child of the node object on its left
        # AND if the distance is ok, return the next child
        if self._leftchild and distance - max_dist < self._median:
            yield self._leftchild

        # If there is still a child of the node object on its right
        # AND if the distance is ok, return the next child
        if self._rightchild and distance + max_dist >= self._median:
            yield self._rightchild

        # If the function arrives here, the generator will be considered empty
        # there is no more than two values: the left and the right children

Caller:

    # Create an empty list and a list with the current object reference
    result, candidates = list(), [self]

    # Loop on candidates (they contain only one element at the beginning)
    while candidates:

        # Get the last candidate and remove it from the list
        node = candidates.pop()

        # Get the distance between obj and the candidate
        distance = node._get_dist(obj)

        # If distance is ok, then you can fill the result
        if distance <= max_dist and distance >= min_dist:
            result.extend(node._values)

        # Add the children of the candidate in the candidate's list
        # so the loop will keep running until it will have looked
        # at all the children of the children of the children, etc. of the candidate
        candidates.extend(node._get_child_candidates(distance, min_dist, max_dist))

    return result

This code contains several smart parts:

- The loop iterates on a list, but the list expands while the loop is being iterated :-) It's a concise way to go through all these nested data even if it's a bit dangerous since you can end up with an infinite loop. In this case, `candidates.extend(node._get_child_candidates(distance, min_dist, max_dist))` exhaust all the values of the generator, but `while` keeps creating new generator objects which will produce different values from the previous ones since it's not applied on the same node.

- The `extend()` method is a list object method that expects an iterable and adds its values to the list.

Usually we pass a list to it:

    >>> a = [1, 2]
    >>> b = [3, 4]
    >>> a.extend(b)
    >>> print(a)
    [1, 2, 3, 4]

But in your code, it gets a generator, which is good because:

1. You don't need to read the values twice.
2. You may have a lot of children and you don't want them all stored in memory.

And it works because Python does not care if the argument of a method is a list or not. Python expects iterables so it will work with strings, lists, tuples, and generators! This is called duck typing and is one of the reasons why Python is so cool. But this is another story, for another question...

You can stop here, or read a little bit to see an advanced use of a generator:

### Controlling a generator exhaustion

    >>> class Bank(): # Let's create a bank, building ATMs
    ...    crisis = False
    ...    def create_atm(self):
    ...        while not self.crisis:
    ...            yield "$100"
    >>> hsbc = Bank() # When everything's ok the ATM gives you as much as you want
    >>> corner_street_atm = hsbc.create_atm()
    >>> print(corner_street_atm.next())
    $100
    >>> print(corner_street_atm.next())
    $100
    >>> print([corner_street_atm.next() for cash in range(5)])
    ['$100', '$100', '$100', '$100', '$100']
    >>> hsbc.crisis = True # Crisis is coming, no more money!
    >>> print(corner_street_atm.next())
    <type 'exceptions.StopIteration'>
    >>> wall_street_atm = hsbc.create_atm() # It's even true for new ATMs
    >>> print(wall_street_atm.next())
    <type 'exceptions.StopIteration'>
    >>> hsbc.crisis = False # The trouble is, even post-crisis the ATM remains empty
    >>> print(corner_street_atm.next())
    <type 'exceptions.StopIteration'>
    >>> brand_new_atm = hsbc.create_atm() # Build a new one to get back in business
    >>> for cash in brand_new_atm:
    ...    print cash
    $100
    $100
    $100
    $100
    $100
    $100
    $100
    $100
    $100
    ...

---
**Note**: For Python 3, use `print(corner_street_atm.__next__())` or `print(next(corner_street_atm))`

---

It can be useful for various things like controlling access to a resource.

### Itertools, your best friend

The itertools module contains special functions to manipulate iterables. Ever wish to duplicate a generator? Chain two generators? Group values in a nested list with a one-liner? `Map` / `Zip` without creating another list?

Then just `import itertools`.

An example? Let's see the possible orders of arrival for a four-horse race:

    >>> horses = [1, 2, 3, 4]
    >>> races = itertools.permutations(horses)
    >>> print(races)
    <itertools.permutations object at 0xb754f1dc>
    >>> print(list(itertools.permutations(horses)))
    [(1, 2, 3, 4),
    (1, 2, 4, 3),
    (1, 3, 2, 4),
    (1, 3, 4, 2),
    (1, 4, 2, 3),
    (1, 4, 3, 2),
    (2, 1, 3, 4),
    (2, 1, 4, 3),
    (2, 3, 1, 4),
    (2, 3, 4, 1),
    (2, 4, 1, 3),
    (2, 4, 3, 1),
    (3, 1, 2, 4),
    (3, 1, 4, 2),
    (3, 2, 1, 4),
    (3, 2, 4, 1),
    (3, 4, 1, 2),
    (3, 4, 2, 1),
    (4, 1, 2, 3),
    (4, 1, 3, 2),
    (4, 2, 1, 3),
    (4, 2, 3, 1),
    (4, 3, 1, 2),
    (4, 3, 2, 1)]

### Understanding the inner mechanisms of iteration

Iteration is a process implying iterables (implementing the `__iter__()` method) and iterators (implementing the `__next__()` method). Iterables are any objects you can get an iterator from. Iterators are objects that let you iterate on iterables.

There is more about it in this article about [how `for` loops work](http://effbot.org/zone/python-for-statement.htm).

## [Python | yield Keyword](https://www.geeksforgeeks.org/python-yield-keyword/)

`yield` is a keyword in Python that is used to return from a function **without destroying the states of its local variable** and when the function is called, the execution **starts from the last yield statement**. Any function that contains a `yield` keyword is **termed as `generator`**. Hence, **`yield` is what makes a `generator`**. `yield` keyword in Python is less known off but has a greater utility which one can think of.

### Code #1 : Demonstrating yield working

    # Python3 code to demonstrate  
    # yield keyword 
    
    # generator to print even numbers 
    def print_even(test_list) : 
        for i in test_list: 
            if i % 2 == 0: 
                yield i 
    
    # initializing list  
    test_list = [1, 4, 5, 6, 7] 
    
    # printing initial list 
    print ("The original list is : " +  str(test_list)) 
    
    # printing even numbers  
    print ("The even numbers in list are : ", end = " ") 
    for j in print_even(test_list): 
        print (j, end = " ") 

Output :

    The original list is : [1, 4, 5, 6, 7]
    The even numbers in list are :  4 6 

### Code #2:

    # A Python program to generate squares from 1  
    # to 100 using yield and therefore generator  
    
    # An infinite generator function that prints  
    # next square number. It starts with 1  
    def nextSquare():  
        i = 1;  
    
        # An Infinite loop to generate squares  
        while True:  
            yield i*i                  
            i += 1 # Next execution resumes  
                    # from this point      
    
    # Driver code  
    for num in nextSquare():  
        if num > 100:  
            break    
        print(num)  

Output:

    1
    4
    9
    16
    25
    36
    49
    64
    81
    100

### Advantages of yield

- Since it stores the local variable states, hence overhead of memory allocation is controlled.
- Since the old state is retained, flow doesn’t start from the beginnning and hence saves time.

### Disadvantages of yield

- Sometimes, the use of yield becomes erroneous is calling of function is not handled properly.
- The time and memory optimization has a cost of complexity of code and hence sometimes hard to understand logic behind it.

### Practical Applications

The possible practical application is that when handling the last amount of data and searching particulars from it, `yield` can be used as we don’t need to lookup again from start and hence would save time. There can possibly be many application of `yield` depending upon the use cases.
 
    # Python3 code to demonstrate yield keyword 
    
    # Checking number of occurrence of  
    # geeks in string  
    
    # generator to print even numbers 
    def print_even(test_string) : 
        for i in test_string: 
            if i == "geeks": 
                yield i 
    
    # initializing string 
    test_string = " The are many geeks around you, \ 
                geeks are known for teaching other geeks" 
    
    # printing even numbers using yield 
    count = 0
    print ("The number of geeks in string is : ", end = "" ) 
    test_string = test_string.split() 
    
    for j in print_even(test_string): 
        count = count + 1
    
    print (count) 

Output :

    The number of geeks in string is : 3

## [When to use yield instead of return in Python?](https://www.geeksforgeeks.org/use-yield-keyword-instead-return-keyword-python/)

The `yield` statement suspends function’s execution and sends a value back to the caller, but **retains enough state to enable function to resume** where it is left off. When resumed, the function continues execution **immediately after the last `yield`** run. This allows its code to **produce a series of values over time**, rather than computing them at once and sending them back like a list.

Let’s see with an example:

    # A Simple Python program to demonstrate working 
    # of yield 
    
    # A generator function that yields 1 for the first time, 
    # 2 second time and 3 third time 
    def simpleGeneratorFun(): 
        yield 1
        yield 2
        yield 3
    
    # Driver code to check above generator function 
    for value in simpleGeneratorFun():  
        print(value) 

Output:

    1
    2
    3

Return sends a specified value back to its caller whereas `yield` can produce a sequence of values. We should use yield when we want to iterate over a sequence, but don’t want to store the entire sequence in memory.

Yield are **used in Python generators**. A `generator` function is defined like a normal function, but whenever it needs to generate a value, it does so with the `yield` keyword rather than `return`. If the body of a `def` contains `yield`, the function automatically becomes a `generator` function.

    # A Python program to generate squares from 1 
    # to 100 using yield and therefore generator 
    
    # An infinite generator function that prints 
    # next square number. It starts with 1 
    def nextSquare(): 
        i = 1; 
    
        # An Infinite loop to generate squares  
        while True: 
            yield i*i                 
            i += 1  # Next execution resumes  
                    # from this point      
    
    # Driver code to test above generator  
    # function 
    for num in nextSquare(): 
        if num > 100: 
            break    
        print(num) 

Output:

    1
    4
    9
    16
    25
    36
    49
    64
    81
    100

## [How to Use Generators and yield in Python](https://realpython.com/introduction-to-python-generators/)
