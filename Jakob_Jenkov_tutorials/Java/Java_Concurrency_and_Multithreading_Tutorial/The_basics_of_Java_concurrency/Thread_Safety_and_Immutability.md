# [Thread Safety and Immutability](http://tutorials.jenkov.com/java-concurrency/thread-safety-and-immutability.html)

- [Thread Safety and Immutability](#thread-safety-and-immutability)
  - [The Reference is not Thread Safe!](#the-reference-is-not-thread-safe)

[Race conditions](http://tutorials.jenkov.com/java-concurrency/race-conditions-and-critical-sections.html) occur only if multiple threads are accessing the same resource, and one or more of the threads write to the resource. **If multiple threads read the same resource [race conditions](http://tutorials.jenkov.com/java-concurrency/race-conditions-and-critical-sections.html) do not occur**.

We can make sure that objects shared between threads are never updated by any of the threads by making the shared objects immutable, and thereby thread safe. Here is an example:

    public class ImmutableValue{
        private int value = 0;

        public ImmutableValue(int value){
            this.value = value;
        }

        public int getValue(){
            return this.value;
        }
    }

Notice how the value for the `ImmutableValue` instance is passed in the constructor. Notice also how there is no setter method. Once an `ImmutableValue` instance is created you cannot change its value. It is **immutable**. You can read it however, using the `getValue()` method.

If you need to perform operations on the `ImmutableValue` instance you can do so by **returning a new** instance with the value resulting from the operation. Here is an example of an add operation:

    public class ImmutableValue{

        private int value = 0;

        public ImmutableValue(int value){
            this.value = value;
        }

        public int getValue(){
            return this.value;
        }
    
        public ImmutableValue add(int valueToAdd){
            return new ImmutableValue(this.value + valueToAdd);
        }
    }

Notice how the `add()` method returns a new `ImmutableValue` instance with the result of the add operation, rather than adding the value to itself.

## The Reference is not Thread Safe!

It is important to remember, that even if an object is immutable and thereby thread safe, the reference to this object may not be thread safe. Look at this example:

    public class Calculator{
        private ImmutableValue currentValue = null;

        public ImmutableValue getValue(){
            return currentValue;
        }

        public void setValue(ImmutableValue newValue){
            this.currentValue = newValue;
        }

        public void add(int newValue){
            this.currentValue = this.currentValue.add(newValue);
        }
    }

The `Calculator` class holds a reference to an `ImmutableValue` instance. Notice how it is possible to change that reference through both the `setValue()` and `add()` methods. Therefore, **even if the `Calculator` class uses an immutable object internally, it is not itself immutable, and therefore not thread safe**. In other words: The `ImmutableValue` class is thread safe, but the use of it is not. This is something to keep in mind when trying to achieve thread safety through immutability.

To make the `Calculator` class thread safe you could have declared the `getValue()`, `setValue()`, and `add()` methods synchronized. That would have done the trick.
