# [Introduction to Python Async](https://www.educba.com/python-async)

- [Introduction to Python Async](#introduction-to-python-async)
  - [Examples of Python Async](#examples-of-python-async)
    - [Example #1](#example-1)
    - [Example #2](#example-2)
    - [Example #3](#example-3)
    - [Example #4](#example-4)

Python async is an asynchronous function or also known as coroutine in Python changes the behavior of the function call. Async in Python is a feature for many modern programming languages that allows functioning multiple operations without waiting time. This being a smart way to handle multiple network task or I/O tasks where the actual program's time is spent waiting for other tasks to finish. We shall look into async implementation in Python. Moving to async functions not only required knowledge on Syntax but also way of thinking for the logics need to be changed.

Syntax:

Asynchronous functions/ Coroutines uses `async` keyword OR `@asyncio.coroutine`.

Either function would work as a coroutine which returns **coroutine objects**. Calling either function would **not actually run**, but a coroutine object is returned.

In some cases, if needed to determine the function is a coroutine or not, `asyncio` has a method `asyncio.iscoroutinefunction(func)`. If user wants to determine the object returned from the function is a coroutine object, `asyncio` has a method `asyncio.iscoroutine(obj)`.

Defining `async def` makes a coroutine

Python Async provided **single-threaded concurrent** code by using coroutines, running network I/O, and other related I/O over sockets. Python async has an **event loop** that waits for another event to happen and acts on the event.

Async provides a set of Low Level and High-Level API's

- To create and maintain event loops providing asynchronous API's for handling OS signals, networking, running subprocesses, etc.

- Perform network I/O and distribute tasks in the mode of queues.

- Implement protocols using transport and synchronize concurrent code.

- Bridges call back based libraries and code with async or await

- Runs coroutines concurrently with full control of their execution.

## Examples of Python Async

Lets us discuss the examples of Python Async.

### Example #1

code:

    import queue

    def task(name, sample_queue):
        if sample_queue.empty():
            print(f'Task {name} has nothing to do')
        else:
            while not sample_queue.empty():
                cnt = sample_queue.get()
                total = 0
                for x in range(cnt):
                    print(f'Task {name} is running now')
                    total += 1

                print(f'Task {name} is running with a total of: {total}')

    def sample_async():
        sample_queue = queue.Queue()
        for work in [2, 5, 10, 15, 20]:
            sample_queue.put(work)

        tasks = [
            (task, 'Async1', sample_queue),
            (task, 'Async2', sample_queue),
            (task, 'Async3', sample_queue)
        ]

        for t, n, q in tasks:
            t(n, q)

    if __name__ == '__main__':
        sample_async()

output:

    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running with a total of: 2
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running with a total of: 5
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running with a total of: 10
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running with a total of: 15
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running now
    Task Async1 is running with a total of: 20
    Task Async2 has nothing to do
    Task Async3 has nothing to do

'task' in the above example accepts string and queue.

### Example #2

code:

    import asyncio
    import functools

    def event_handler(loop, stop=False):
        print('Calling event handler')
        if stop:
            print('Loop is being stopped')
            loop.stop()

    if __name__ == '__main__':
        loop = asyncio.get_event_loop()
        try:
            loop.call_soon(functools.partial(event_handler, loop))
            print('Loop is being started')

            loop.call_soon(functools.partial(event_handler, loop, stop=True))
            loop.run_forever()

        finally:
            print('Loop is being closed')
            loop.close()

output:

    Loop is being started
    Calling event handler
    Calling event handler
    Loop is being stopped
    Loop is being closed

### Example #3

code:

    import asyncio

    async def sample_task(task_seconds):
        print('Task takes {} seconds to complete'.format(task_seconds))
        await asyncio.sleep(task_seconds)
        return 'task has been completed'

    if __name__ == '__main__':
        sample_event = asyncio.get_event_loop()
        try:
            print('Creation of tasks started')
            task_object_loop = sample_event.create_task(sample_task(task_seconds=3))

            sample_event.run_until_complete(task_object_loop)
        finally:
            sample_event.close()
            print("Task status: {}".format(task_object_loop.result()))

output:

    Creation of tasks started
    Task takes 3 seconds to complete
    Task status: task has been completed

Python Async is a function used for concurrent programming for single code to be executed independently.

### Example #4

code:

    import asyncio

    @asyncio.coroutine
    def countdown(number, n):
        while n > 0:
            print('Counter of ', n, '({})'.format(number))
            yield from asyncio.sleep(1)
            n -= 1

    loop = asyncio.get_event_loop()

    tasks = [
        asyncio.ensure_future(countdown("First Count", 2)),
        asyncio.ensure_future(countdown("Second Count", 4))]
        
    loop.run_until_complete(asyncio.wait(tasks))
    loop.close()

output:

    Counter of  2 (First Count)
    Counter of  4 (Second Count)
    Counter of  1 (First Count)
    Counter of  3 (Second Count)
    Counter of  2 (Second Count)
    Counter of  1 (Second Count)

Event loop `countdown()` coroutine calls, executes until yield from, and `asyncio.sleep()` function. This returns `asyncio.future()` which is passed down to event loop and execution of the coroutine is paused. The future loop watches the future object until the other one is over. Once the second one is on, the event loop gets the paused countdown `coroutine()` which gave the event loop the future object, sends future objects to result back to the coroutine with `countdown()` starts running back.

Asyncio was added to the standard library to prevent looping. Running event loops provides few features like,

- Registering, execution, and canceling delayed calls i.e. Asynchronous functions.

- Creation of subprocesses and transports for communication between tasks.

- Creations of client and server transports for communication between tasks.

- Delegating function calls to thread pools.

Reason behind using async is to improve the throughput of the program by reducing idle time when performing I/O. Programs in this juggle are using an abstraction event loop. Resemble multi-threading but event loop generally lives in single thread.

With this we come to a conclusion on 'Python Async'. Async I/O being a language-agnostic model and to let coroutines communicate with each other. Asyncio, python function provides API to run and manage coroutines. API of asyncio was declared stable rather being provisional. In Python, async has evolved with minor changes in the versions. Using Python async tool, asynchronous programming is powerful. Practically defining, async is used for concurrent programming in which tasks assigned to CPU is released at the time of the waiting period. Based on users requirement, Python async achieves concurrency, code flow, architecture design, and data manipulation.

However, if a user tries to implement a program or a server that implements significant I/O operations, async makes a huge difference. If a user writes a program that calculates pi value to a decimal number, async won't help as it is a CPU bound without I/O, but if a program performs IO, file, or network access, using Python async would be easier.
