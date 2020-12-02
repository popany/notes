# pthread

- [pthread](#pthread)
  - [Api](#api)
    - [pthread_cond_signal(3)](#pthread_cond_signal3)
      - [Multiple Awakenings by Condition Signal](#multiple-awakenings-by-condition-signal)
  - [Practice](#practice)
    - [Calling pthread_cond_signal without locking mutex](#calling-pthread_cond_signal-without-locking-mutex)

## Api

### [pthread_cond_signal(3)](https://linux.die.net/man/3/pthread_cond_signal)

#### Multiple Awakenings by Condition Signal

On a multi-processor, it may be impossible for an implementation of `pthread_cond_signal()` to avoid the **unblocking of more than one thread** blocked on a condition variable. For example, consider the following partial implementation of `pthread_cond_wait()` and `pthread_cond_signal()`, executed by two threads in the order given. One thread is trying to wait on the condition variable, another is concurrently executing `pthread_cond_signal()`, while a third thread is already waiting.

    pthread_cond_wait(mutex, cond):
        value = cond->value; /* 1 */
        pthread_mutex_unlock(mutex); /* 2 */               <- [thread 1] trying to wait on the condition variable
        pthread_mutex_lock(cond->mutex); /* 10 */
        if (value == cond->value) { /* 11 */               <- [thread 1] "spurious wakeup" for value != cond-> value
            me->next_cond = cond->waiter;
            cond->waiter = me;
            pthread_mutex_unlock(cond->mutex);
            unable_to_run(me);
        } else
            pthread_mutex_unlock(cond->mutex); /* 12 */
        pthread_mutex_lock(mutex); /* 13 */

    pthread_cond_signal(cond):
        pthread_mutex_lock(cond->mutex); /* 3 */           <- [thread 2] executing pthread_cond_signal()
        cond->value++; /* 4 */
        if (cond->waiter) { /* 5 */
            sleeper = cond->waiter; /* 6 */
            cond->waiter = sleeper->next_cond; /* 7 */
            able_to_run(sleeper); /* 8 */                  <- [thread 2] wake [thread 3] that already waiting up 
        }
        pthread_mutex_unlock(cond->mutex); /* 9 */

The effect is that more than one thread can return from its call to `pthread_cond_wait()` or `pthread_cond_timedwait()` as a result of one call to `pthread_cond_signal()`. This effect is called "spurious wakeup". Note that the situation is self-correcting in that the number of threads that are so awakened is finite; for example, the next thread to call `pthread_cond_wait()` after the sequence of events above blocks.

While this problem could be resolved, the loss of efficiency for a fringe condition that occurs only rarely is unacceptable, especially given that one has to check the predicate associated with a condition variable anyway. Correcting this problem would unnecessarily reduce the degree of concurrency in this basic building block for all higher-level synchronization operations.

An added benefit of allowing spurious wakeups is that applications are forced to code a predicate-testing-loop around the condition wait. This also makes the application tolerate superfluous condition broadcasts or signals on the same condition variable that may be coded in some other part of the application. The resulting applications are thus more robust. Therefore, IEEE Std 1003.1-2001 explicitly documents that spurious wakeups may occur.

## Practice

### [Calling pthread_cond_signal without locking mutex]()

If you do not lock the mutex in the codepath that changes the condition and signals, you can lose wakeups. Consider this pair of processes:

Process A:

    pthread_mutex_lock(&mutex);
    while (condition == FALSE)
        pthread_cond_wait(&cond, &mutex);
    pthread_mutex_unlock(&mutex);

Process B (incorrect):

    condition = TRUE;
    pthread_cond_signal(&cond);

Then consider this possible interleaving of instructions, where condition starts out as FALSE:

    Process A                             Process B

    pthread_mutex_lock(&mutex);
    while (condition == FALSE)

                                          condition = TRUE;
                                          pthread_cond_signal(&cond);

    pthread_cond_wait(&cond, &mutex);

The condition is now TRUE, but Process A is stuck waiting on the condition variable - it missed the wakeup signal. If we alter Process B to lock the mutex:

Process B (correct):

    pthread_mutex_lock(&mutex);
    condition = TRUE;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);

...then the above cannot occur; the wakeup will never be missed.

(Note that **you can actually move the `pthread_cond_signal()` itself after the `pthread_mutex_unlock()`**, but this can result in **less optimal scheduling** of threads, and you've necessarily locked the mutex already in this code path due to changing the condition itself).
