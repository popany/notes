# java.util.concurrent

- [java.util.concurrent](#javautilconcurrent)
  - [CountDownLatch](#countdownlatch)
  - [CyclicBarrier](#cyclicbarrier)
  - [Semaphore](#semaphore)

## [CountDownLatch](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CountDownLatch.html)

A `CountDownLatch` is initialized with a given count. The [`await`](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CountDownLatch.html#await()) methods block until the current count reaches zero due to invocations of the [`countDown()`](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CountDownLatch.html#countDown()) method, after which all waiting threads are released and any subsequent invocations of [`await`](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CountDownLatch.html#await()) return immediately. This is a one-shot phenomenon -- the count cannot be reset. If you need a version that resets the count, consider using a [`CyclicBarrier`](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CyclicBarrier.html).

A useful property of a `CountDownLatch` is that it **doesn't require that threads calling `countDown`** wait for the count to reach zero **before proceeding**, it simply prevents any thread from proceeding past an await until all threads could pass.

## [CyclicBarrier](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/CyclicBarrier.html)

A synchronization aid that allows a set of threads to all wait for each other to reach a common barrier point. `CyclicBarrier`s are useful in programs involving a fixed sized party of threads that must occasionally wait for each other. The barrier is called cyclic because it can be re-used after the waiting threads are released.

## [Semaphore](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Semaphore.html)

A counting semaphore. Conceptually, a semaphore maintains a set of permits. Each [`acquire()`](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Semaphore.html#acquire()) blocks if necessary until a permit is available, and then takes it. Each [`release()`](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Semaphore.html#release()) adds a permit, potentially releasing a blocking acquirer. However, no actual permit objects are used; the `Semaphore` just keeps a count of the number available and acts accordingly.

Semaphores are often used to restrict the number of threads than can access some (physical or logical) resource.
