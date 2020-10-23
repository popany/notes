# [Race Conditions and Critical Sections](http://tutorials.jenkov.com/java-concurrency/race-conditions-and-critical-sections.html)

- [Race Conditions and Critical Sections](#race-conditions-and-critical-sections)
  - [Critical Sections](#critical-sections)
  - [Race Conditions in Critical Sections](#race-conditions-in-critical-sections)
  - [Preventing Race Conditions](#preventing-race-conditions)
  - [Critical Section Throughput](#critical-section-throughput)

A race condition is a special condition that may occur inside a critical section. A **critical section** is a section of code that is executed by multiple threads and where the sequence of execution for the threads makes a difference in the result of the concurrent execution of the critical section.

When the result of multiple threads executing a critical section may differ depending on the sequence in which the threads execute, the critical section is said to contain a **race condition**. The term race condition stems from the metaphor that the threads are racing through the critical section, and that the result of that race impacts the result of executing the critical section.

This may all sound a bit complicated, so I will elaborate more on race conditions and critical sections in the following sections.

## Critical Sections

Running more than one thread inside the same application does not by itself cause problems. The problems arise when multiple threads access the same resources. For instance the same memory (variables, arrays, or objects), systems (databases, web services etc.) or files.

In fact, **problems only arise if one or more of the threads write to these resources**. It is safe to let multiple threads read the same resources, as long as the resources do not change.

Here is a critical section Java code example that may fail if executed by multiple threads simultaneously:

    public class Counter {
        protected long count = 0;
        public void add(long value){
            this.count = this.count + value;
        }
    }

Imagine if two threads, A and B, are executing the `add` method on the same instance of the `Counter` class. There is no way to know when the operating system switches between the two threads. The code in the `add()` method is not executed as a single atomic instruction by the Java virtual machine. Rather it is executed as **a set of smaller instructions**, similar to this:

- Read `this.count` from memory into register.
- Add value to register.
- Write register to memory.

Observe what happens with the following mixed execution of threads A and B:

        this.count = 0;

    A:  Reads this.count into a register (0)
    B:  Reads this.count into a register (0)
    B:  Adds value 2 to register
    B:  Writes register value (2) back to memory. this.count now equals 2
    A:  Adds value 3 to register
    A:  Writes register value (3) back to memory. this.count now equals 3

The two threads wanted to add the values 2 and 3 to the counter. Thus the value should have been 5 after the two threads complete execution. However, since the execution of the two threads is interleaved, the result ends up being different.

In the execution sequence example listed above, both threads read the value 0 from memory. Then they add their i ndividual values, 2 and 3, to the value, and write the result back to memory. Instead of 5, the value left in `this.count` will be the value written by the last thread to write its value. In the above case it is thread A, but it could as well have been thread B.

## Race Conditions in Critical Sections

The code in the `add()` method in the example earlier contains a critical section. When multiple threads execute this critical section, race conditions occur.

More formally, the situation where two threads compete for the same resource, where the sequence in which the resource is accessed is significant, is called **race conditions**. A code section that leads to race conditions is called a **critical section**.

## Preventing Race Conditions

To prevent race conditions from occurring you must make sure that the critical section is executed as an **atomic instruction**. That means that once a single thread is executing it, no other threads can execute it until the first thread has left the critical section.

Race conditions can be avoided by proper thread synchronization in critical sections. Thread synchronization can be achieved using a [**synchronized block** of Java code](http://tutorials.jenkov.com/java-concurrency/synchronized.html). Thread synchronization can also be achieved using other synchronization constructs like [**locks**](http://tutorials.jenkov.com/java-concurrency/locks.html) or atomic variables like [**java.util.concurrent.atomic.AtomicInteger**](http://tutorials.jenkov.com/java-util-concurrent/atomicinteger.html).

## Critical Section Throughput

For smaller critical sections making the whole critical section a synchronized block may work. But, for larger critical sections it may be beneficial to break the critical section into smaller critical sections, to allow multiple threads to execute each a smaller critical section. This may decrease contention on the shared resource, and thus increase throughput of the total critical section.

Here is a very simplified Java code example to show what I mean:

    public class TwoSums {
        
        private int sum1 = 0;
        private int sum2 = 0;
        
        public void add(int val1, int val2){
            synchronized(this){
                this.sum1 += val1;   
                this.sum2 += val2;
            }
        }
    }

Notice how the `add()` method adds values to two different sum member variables. To prevent race conditions the summing is executed inside a Java synchronized block. With this implementation only a single thread can ever execute the summing at the same time.

However, since the two sum variables are independent of each other, you could split their summing up into two separate synchronized blocks, like this:

    public class TwoSums {
        
        private int sum1 = 0;
        private int sum2 = 0;

        private Integer sum1Lock = new Integer(1);
        private Integer sum2Lock = new Integer(2);

        public void add(int val1, int val2){
            synchronized(this.sum1Lock){
                this.sum1 += val1;   
            }
            synchronized(this.sum2Lock){
                this.sum2 += val2;
            }
        }
    }

Now two threads can execute the `add()` method at the same time. One thread inside the first synchronized block, and another thread inside the second synchronized block. The two synchronized blocks are synchronized on different objects, so two different threads can execute the two blocks independently. This way threads will have to wait less for each other to execute the `add()` method.

This example is very simple, of course. In a real life shared resource the breaking down of critical sections may be a whole lot more complicated, and require more analysis of execution order possibilities.
