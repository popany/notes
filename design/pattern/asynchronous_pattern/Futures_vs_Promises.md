# [Futures vs Promises](https://stackoverflow.com/questions/12620186/futures-vs-promises)

- [Futures vs Promises](#futures-vs-promises)

Future and Promise are the **two separate sides of an asynchronous operation**.

`std::promise` is used by the **"producer/writer"** of the asynchronous operation.

`std::future` is used by the **"consumer/reader"** of the asynchronous operation.

The reason it is separated into these two separate "interfaces" is to **hide the "write/set" functionality** from the "consumer/reader".

    auto promise = std::promise<std::string>();

    auto producer = std::thread([&]
    {
        promise.set_value("Hello World");
    });

    auto future = promise.get_future();

    auto consumer = std::thread([&]
    {
        std::cout << future.get();
    });

    producer.join();
    consumer.join();

One (incomplete) way to implement `std::async` using `std::promise` could be:

    template<typename F>
    auto async(F&& func) -> std::future<decltype(func())>
    {
        typedef decltype(func()) result_type;

        auto promise = std::promise<result_type>();
        auto future  = promise.get_future();

        std::thread(std::bind([=](std::promise<result_type>& promise)
        {
            try
            {
                promise.set_value(func()); // Note: Will not work with std::promise<void>. Needs some meta-template programming which is out of scope for this question.
            }
            catch(...)
            {
                promise.set_exception(std::current_exception());
            }
        }, std::move(promise))).detach();

        return std::move(future);
    }

Using `std::packaged_task` which is a helper (i.e. it basically does what we were doing above) around `std::promise` you could do the following which is more complete and possibly faster:

    template<typename F>
    auto async(F&& func) -> std::future<decltype(func())>
    {
        auto task   = std::packaged_task<decltype(func())()>(std::forward<F>(func));
        auto future = task.get_future();

        std::thread(std::move(task)).detach();

        return std::move(future);
    }

Note that this is slightly different from `std::async` where the returned `std::future` will when destructed actually block until the thread is finished.
