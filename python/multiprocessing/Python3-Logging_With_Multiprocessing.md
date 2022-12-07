# [Python3: Logging With Multiprocessing](https://fanchenbao.medium.com/python3-logging-with-multiprocessing-f51f460b8778)

- [Python3: Logging With Multiprocessing](#python3-logging-with-multiprocessing)
  - [Logging from main](#logging-from-main)
  - [Move main's logger configurer after listener](#move-mains-logger-configurer-after-listener)
  - [worker\_process Logger Configuration Commented Out](#worker_process-logger-configuration-commented-out)
  - [Propagate](#propagate)
  - [Can we explain the infinite logging problem?](#can-we-explain-the-infinite-logging-problem)
  - [Final thoughts and best practices](#final-thoughts-and-best-practices)

In Python3, logging into a single file from different multiprocessing. Process is not supported, because there is no way to "serialize access to a single file across multiple processes in Python". However, this [document](https://docs.python.org/3/howto/logging-cookbook.html#logging-to-a-single-file-from-multiple-processes) provides a brilliant solution to work around the limitation. Basically, we set up ONE logger in a listener process to handle log writing exclusively, while all other loggers log their messages to a queue that is processed by the listener process. However, the demo code in the document doesn't cover some of the nuances that I encountered when trying to make it work for my own project. Below, I will explain such nuances in an expanded and modified version of the demo code. This serves as a good reference for myself, and I hope it can also help others.

Vanilla version of modified demo code:

    import logging
    import logging.handlers
    import multiprocessing
    from time import sleep
    from random import random, randint
    
    
    # Almost the same as the demo code, but added `console_handler` to directly
    # read logging info from the console
    def listener_configurer():
        root = logging.getLogger()
        file_handler = logging.handlers.RotatingFileHandler('mptest.log', 'a', 300, 10)
        console_handler = logging.StreamHandler()
        formatter = logging.Formatter('%(asctime)s %(processName)-10s %(name)s %(levelname)-8s %(message)s')
        file_handler.setFormatter(formatter)
        console_handler.setFormatter(formatter)
        root.addHandler(file_handler)
        root.addHandler(console_handler)
        root.setLevel(logging.DEBUG)
    
    
    # Almost the same as the demo code, but made it into a forever loop. This is
    # more likely to happen in an app that does not have a clear end point, e.g.
    # a deployed IoT sensor. Another change is to show that if configurer is not
    # passed but directly visible by the process function, calling it directly has
    # the same effect.
    def listener_process(queue):
        listener_configurer()
        while True:
            while not queue.empty():
                record = queue.get()
                logger = logging.getLogger(record.name)
                logger.handle(record)  # No level or filter logic applied - just do it!
            sleep(1)
    
    
    # Same as demo code
    def worker_configurer(queue):
        h = logging.handlers.QueueHandler(queue)  # Just the one handler needed
        root = logging.getLogger()
        root.addHandler(h)
        # send all messages, for demo; no other level or filter logic applied.
        root.setLevel(logging.DEBUG)
    
    
    # Almost the same as demo code, except the logging is simplified, and configurer
    # is no longer passed as argument.
    def worker_process(queue):
        worker_configurer(queue)
        for i in range(3):
            sleep(random())
            innerlogger = logging.getLogger('worker')
            innerlogger.info(f'Logging a random number {randint(0, 10)}')
    
    
    def main():
        queue = multiprocessing.Queue(-1)
        listener = multiprocessing.Process(
            target=listener_process, args=(queue,))
        listener.start()
        workers = []
        for i in range(3):
            worker = multiprocessing.Process(target=worker_process, args=(queue,))
            workers.append(worker)
            worker.start()
        for w in workers:
            w.join()
    
    
    if __name__ == '__main__':
        main()

Running this code shall display something similar to this:

    2019-12-09 17:45:41,323 Process-2  worker INFO     Logging a random number 1
    2019-12-09 17:45:41,699 Process-4  worker INFO     Logging a random number 4
    2019-12-09 17:45:41,794 Process-3  worker INFO     Logging a random number 3
    2019-12-09 17:45:41,852 Process-3  worker INFO     Logging a random number 1
    2019-12-09 17:45:41,892 Process-2  worker INFO     Logging a random number 0
    2019-12-09 17:45:41,969 Process-4  worker INFO     Logging a random number 6
    2019-12-09 17:45:42,524 Process-2  worker INFO     Logging a random number 8
    2019-12-09 17:45:42,552 Process-4  worker INFO     Logging a random number 2
    2019-12-09 17:45:42,822 Process-3  worker INFO     Logging a random number 4

Since `listener_process` now runs a forever loop, the program won't terminate until you press ctrl-C .

This is the vanilla version of the expanded demo code. It does basically the same thing as the original demo code. There is one major difference: logger configurer function is not passed as argument to the functions `listener_process` and `worker_process`. This shows that as long as the configurer is visible to a function, you don't have to pass it as argument.

Now let's make some tweak to better understand how the logger works.

## Logging from main

What if I want both the `main` function and the `worker` process to log messages? Where and how should I configure a logger for `main` ? Since main also runs in a process (the MainProcess), maybe we can follow the example of `worker_process` :

    def main():
        queue = multiprocessing.Queue(-1)
        # set up main logger following example from work_process
        worker_configurer(queue)
        main_logger = logging.getLogger('main')
    
        listener = multiprocessing.Process(
            target=listener_process, args=(queue,))
        listener.start()
    
        main_logger.info('Logging from main')
        workers = []
        for i in range(3):
            worker = multiprocessing.Process(target=worker_process, args=(queue,))
            workers.append(worker)
            worker.start()
        for w in workers:
            w.join()
        main_logger.info('main function ends')

Replace vanilla version's `main` with this `main`, and run the code... pretty bad, isn't it. You end up with infinite logging. Why is that? Let's hold on to this question and see if further tweaks of main can resolve this problem.

## Move main's logger configurer after listener

In `main` above, placing `worker_configurer` above `listener` seems suspicious. Let's move main logger configuration after `listener`:

    def main():
        queue = multiprocessing.Queue(-1)
        listener = multiprocessing.Process(
            target=listener_process, args=(queue,))
        listener.start()
    
        # set up main logger after listener
        worker_configurer(queue)
        main_logger = logging.getLogger('main')
        main_logger.info('Logging from main')
        workers = []
        for i in range(3):
            worker = multiprocessing.Process(target=worker_process, args=(queue,))
            workers.append(worker)
            worker.start()
        for w in workers:
            w.join()
        main_logger.info('main function ends')

Running this `main` gives you something like this:

    2019-12-09 19:00:14,866 MainProcess main INFO     Logging from main
    2019-12-09 19:00:14,895 Process-4  worker INFO     Logging a random number 7
    2019-12-09 19:00:14,895 Process-4  worker INFO     Logging a random number 7
    2019-12-09 19:00:15,066 Process-2  worker INFO     Logging a random number 2
    2019-12-09 19:00:15,066 Process-2  worker INFO     Logging a random number 2
    2019-12-09 19:00:15,157 Process-3  worker INFO     Logging a random number 3
    2019-12-09 19:00:15,157 Process-3  worker INFO     Logging a random number 3
    2019-12-09 19:00:15,374 Process-4  worker INFO     Logging a random number 7
    2019-12-09 19:00:15,374 Process-4  worker INFO     Logging a random number 7
    2019-12-09 19:00:15,688 Process-4  worker INFO     Logging a random number 6
    2019-12-09 19:00:15,688 Process-4  worker INFO     Logging a random number 6
    2019-12-09 19:00:15,707 Process-2  worker INFO     Logging a random number 2
    2019-12-09 19:00:15,707 Process-2  worker INFO     Logging a random number 2
    2019-12-09 19:00:15,776 Process-3  worker INFO     Logging a random number 6
    2019-12-09 19:00:15,776 Process-3  worker INFO     Logging a random number 6
    2019-12-09 19:00:15,969 Process-2  worker INFO     Logging a random number 9
    2019-12-09 19:00:15,969 Process-2  worker INFO     Logging a random number 9
    2019-12-09 19:00:16,318 Process-3  worker INFO     Logging a random number 6
    2019-12-09 19:00:16,318 Process-3  worker INFO     Logging a random number 6
    2019-12-09 19:00:16,320 MainProcess main INFO     main function ends

No more infinite logging! We solved that problem. But if you look closely, now all the `worker_process` log their messages twice, yet the `main_logger` only logs once. This is strange. Given that none of the logging in the `worker_process` code is called twice, the problem must be with logger configuration. Since `main_logger` is working properly, maybe we should comment out logger configuration in `worker_process` and see what happens.

## worker_process Logger Configuration Commented Out

    # comment out logger configuration for worker process
    def worker_process(queue):
    #    worker_configurer(queue)
        for i in range(3):
            sleep(random())
            innerlogger = logging.getLogger('worker')
            innerlogger.info(f'Logging a random number {randint(0, 10)}')

Use the same `main` and the modified `worker_process`, running the program gives us this:

    2019-12-09 19:14:32,271 MainProcess main INFO     Logging from main
    2019-12-09 19:14:32,526 Process-3  worker INFO     Logging a random number 4
    2019-12-09 19:14:32,700 Process-3  worker INFO     Logging a random number 4
    2019-12-09 19:14:32,716 Process-3  worker INFO     Logging a random number 0
    2019-12-09 19:14:32,812 Process-2  worker INFO     Logging a random number 3
    2019-12-09 19:14:32,860 Process-4  worker INFO     Logging a random number 2
    2019-12-09 19:14:33,078 Process-4  worker INFO     Logging a random number 0
    2019-12-09 19:14:33,099 Process-4  worker INFO     Logging a random number 9
    2019-12-09 19:14:33,409 Process-2  worker INFO     Logging a random number 1
    2019-12-09 19:14:34,303 Process-2  worker INFO     Logging a random number 8
    2019-12-09 19:14:34,305 MainProcess main INFO     main function ends

It works! We have fixed the problem. Now we can log from both `main` and `worker_process`. But why does that fix work? It seems that by removing the logger configuration from `worker_process`, we have removed one copy of the log message. Since there is no logger configuration in `worker_process`, this suggests that innerLogger is using logger configuration from main. How is that possible?

## Propagate

It is possible because of propagation. `logger.propagate`, when set to `True` (`True` is default), dictates that when a logger logs a message, **it uses all handlers that it owns and all handlers its ancestors own** (an ancestor logger is any logger that is configured previously in the program). This means as long as a logger's ancestor owns a handler that this logger can use, there is no need for this logger to add its own handler. In other words, it is possible for a non-multiprocessing Python program to have only ONE root logger that owns handlers, while all the other loggers that don't own handlers propagate their messages to the root for handling.

Similarly, for logging with multiprocessing, we only need TWO logger to have handlers: one is in `listener` which owns handlers for output purpose; and other is in root of the program, owning `QueueHandler`. Propagation takes care of all the other non-handler loggers and makes sure their messages will all bubble up to the `QueueHandler` first, which will then be processed by the `listener`.

To further demonstrate propagation, we can comment out the logger configuration in `main`, and uncomment that in `worker_process`. Following the rule of propagation, `innerLogger` (no handler of its own) in `worker_process` looks upward and find a handler in the logger configuration in `worker_process`. Hence, `innerLogger` shall work normally. `main_logger` also doesn't have its own handler. But when it looks upward, there is no other handler. Without a handler, `main_logger` cannot log its message. Therefore, we shouldn't see its message printed out. Let's try this and see if our prediction holds:

    # logger configuration uncommented in worker_process
    def worker_process(queue):
        worker_configurer(queue)
        for i in range(3):
            sleep(random())
            innerlogger = logging.getLogger('worker')
            innerlogger.info(f'Logging a random number {randint(0, 10)}')
    
    
    # logger configuration commented out in main
    def main():
        queue = multiprocessing.Queue(-1)
        listener = multiprocessing.Process(
            target=listener_process, args=(queue,))
        listener.start()
    
        # worker_configurer(queue)
        main_logger = logging.getLogger('main')
        main_logger.info('Logging from main')
        workers = []
        for i in range(3):
            worker = multiprocessing.Process(target=worker_process, args=(queue,))
            workers.append(worker)
            worker.start()
        for w in workers:
            w.join()
        main_logger.info('main function ends')

Running the same program gives us something like this:

    2019-12-09 19:33:43,984 Process-2  worker INFO     Logging a random number 2
    2019-12-09 19:33:44,521 Process-3  worker INFO     Logging a random number 4
    2019-12-09 19:33:44,659 Process-2  worker INFO     Logging a random number 8
    2019-12-09 19:33:44,678 Process-4  worker INFO     Logging a random number 1
    2019-12-09 19:33:44,832 Process-4  worker INFO     Logging a random number 1
    2019-12-09 19:33:45,040 Process-4  worker INFO     Logging a random number 6
    2019-12-09 19:33:45,065 Process-2  worker INFO     Logging a random number 10
    2019-12-09 19:33:45,091 Process-3  worker INFO     Logging a random number 8
    2019-12-09 19:33:45,788 Process-3  worker INFO     Logging a random number 9

Indeed, logging from main is gone. Our prediction is correct.

## Can we explain the infinite logging problem?

Yes, we can, using `propagate`. In our example of infinite logging, we set up logger configuration in `main` before `listener`. What this does is that when `logger` in `listener_process` handles log message, it has two ancestors: one is defined inside `listener_process` that has `file_handler` and `console_handler`, and the other in main with `QueueHandler` attached. Since `propagate` dictates that a logger will use all its own and its ancestors' handlers, `logger` in `listener_process` has to use `file_handler`, `console_handler`, and `QueueHandler`. The first two outputs the message, and the last one puts the message back into the queue. As a result, the log message never truly leaves the queue and we have infinite logging.

## Final thoughts and best practices

As mentioned above, for non-multiprocessing program (including threading), generally speaking only one root logger configuration is needed. All other loggers' messages shall be handled by the root logger. For multiprocessing program, two logger configurations are needed, one for actual output in listener process and the other for passing log message to queue handler.

In real implementation, I think the functions in demo code should be refactored into their own modules, and a single module level logger be used for all logging within the module. My understanding of "best practices" for the final version of our demo code shall look like this:

listener.py

    import logging
    from logging import handlers
    from time import sleep
    
    
    def listener_configurer():
        root = logging.getLogger()
        file_handler = handlers.RotatingFileHandler('mptest.log', 'a', 300, 10)
        console_handler = logging.StreamHandler()
        formatter = logging.Formatter('%(asctime)s %(processName)-10s %(name)s %(levelname)-8s %(message)s')
        file_handler.setFormatter(formatter)
        console_handler.setFormatter(formatter)
        root.addHandler(file_handler)
        root.addHandler(console_handler)
        root.setLevel(logging.DEBUG)
    
    
    def listener_process(queue):
        listener_configurer()
        while True:
            while not queue.empty():
                record = queue.get()
                logger = logging.getLogger(record.name)
                logger.handle(record)
            sleep(1)

main.py

    import logging
    from logging import handlers
    import multiprocessing
    
    from listener import listener_process
    from worker import worker_process
    
    
    logger = logging.getLogger(__name__)  # use module name
    
    
    def root_configurer(queue):
        h = handlers.QueueHandler(queue)
        root = logging.getLogger()
        root.addHandler(h)
        root.setLevel(logging.DEBUG)
    
    
    def main():
        queue = multiprocessing.Queue(-1)
        listener = multiprocessing.Process(
            target=listener_process, args=(queue,))
        listener.start()
    
        root_configurer(queue)
    
        logger.info('Logging from main')
        workers = []
        for i in range(3):
            worker = multiprocessing.Process(target=worker_process, args=(queue,))
            workers.append(worker)
            worker.start()
        for w in workers:
            w.join()
        logger.info('main function ends')
    
    
    if __name__ == '__main__':
        main()

worker.py

    import logging
    from time import sleep
    from random import random, randint
    
    
    logger = logging.getLogger(__name__)  # use module name
    
    
    def worker_process(queue):
        for i in range(3):
            sleep(random())
            logger.info(f'Logging a random number {randint(0, 10)}')


Run `main.py` , you will get output like this:

    2019-12-09 20:10:27,588 MainProcess __main__ INFO     Logging from main
    2019-12-09 20:10:27,925 Process-2  worker INFO     Logging a random number 9
    2019-12-09 20:10:27,948 Process-4  worker INFO     Logging a random number 1
    2019-12-09 20:10:27,972 Process-3  worker INFO     Logging a random number 9
    2019-12-09 20:10:28,022 Process-4  worker INFO     Logging a random number 6
    2019-12-09 20:10:28,263 Process-2  worker INFO     Logging a random number 4
    2019-12-09 20:10:28,526 Process-3  worker INFO     Logging a random number 4
    2019-12-09 20:10:28,594 Process-4  worker INFO     Logging a random number 4
    2019-12-09 20:10:28,791 Process-3  worker INFO     Logging a random number 4
    2019-12-09 20:10:28,853 Process-2  worker INFO     Logging a random number 10
    2019-12-09 20:10:28,855 MainProcess __main__ INFO     main function ends

