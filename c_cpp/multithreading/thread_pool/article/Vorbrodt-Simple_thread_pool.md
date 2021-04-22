# [Simple thread pool](https://vorbrodt.blog/2019/02/12/simple-thread-pool/)

- [Simple thread pool](#simple-thread-pool)
  - [Usage example](#usage-example)
  - [pool.h](#poolh)

I know the topic of thread pools has been beaten to death on the internet, nevertheless I wanted to present to you my implementation which uses only standard C++ components 🙂

I will be using [queue](https://vorbrodt.blog/?p=572) and [semaphore](https://vorbrodt.blog/?p=495) classes discussed in my earlier posts.

Below you will find a simple thread pool implementation which can be parametrized by the number of worker threads and the blocking queue depth of work items. Each thread waits on a `blocking_queue::pop()` until a work item shows up. The threads pick up work items randomly off of the queue, execute them, then go back to `blocking_queue::pop()`. Destruction and cleanup of threads is done with `nullptr` sentinel pushed onto the queue. If a sentinel is popped off the queue the thread will push it back and break out of its work loop. This way all threads are waited on and allowed to finish all unprocessed work items during destruction of a `pool` instance.

Moreover, a work item can be any callable entity: lambda, functor, or a function pointer. Work item can accept any number of parameters thanks to [template parameter pack](https://en.cppreference.com/w/cpp/language/parameter_pack) of `pool::enqueue_work()`.

UPDATE:

Thank you reddit user [sumo952](https://www.reddit.com/user/sumo952) for bringing to my attention the [progschj/ThreadPool](https://github.com/progschj/ThreadPool). I have updated my implementation to support futures and the ability to retrieve work item’s result.

## Usage example

    #include <iostream>
    #include <mutex>
    #include <cstdlib>
    #include "pool.h"
    using namespace std;
    
    mutex cout_lock;
    #define trace(x) { scoped_lock<mutex> lock(cout_lock); cout << x << endl; }
    
    const int COUNT = thread::hardware_concurrency();
    const int WORK = 10'000'000;
    
    int main(int argc, char** argv)
    {
        srand((unsigned int)time(NULL));
    
        thread_pool pool;
    
        auto result = pool.enqueue_task([](int i) { return i; }, 0xFF);
        result.get();
    
        for(int i = 1; i <= COUNT; ++i)
            pool.enqueue_work([](int workerNumber) {
                int workOutput = 0;
                int work = WORK + (rand() % (WORK));
                trace("work item " << workerNumber << " starting " << work << " iterations...");
                for(int w = 0; w < work; ++w)
                    workOutput += rand();
                trace("work item " << workerNumber << " finished");
            }, i);
    
        return 1;
    }

## pool.h

    #pragma once
    
    #include <vector>
    #include <thread>
    #include <memory>
    #include <future>
    #include <functional>
    #include <type_traits>
    #include <cassert>
    #include "queue.h"
    
    class thread_pool
    {
    public:
        thread_pool(
            unsigned int queueDepth = std::thread::hardware_concurrency(),
            size_t threads = std::thread::hardware_concurrency())
        : m_workQueue(queueDepth)
        {
            assert(queueDepth != 0);
            assert(threads != 0);
            for(size_t i = 0; i < threads; ++i)
                m_threads.emplace_back(std::thread([this]() {
                    while(true)
                    {
                        auto workItem = m_workQueue.pop();
                        if(workItem == nullptr)
                        {
                            m_workQueue.push(nullptr);
                            break;
                        }
                        workItem();
                    }
                }));
        }
    
        ~thread_pool() noexcept
        {
            m_workQueue.push(nullptr);
            for(auto& thread : m_threads)
                thread.join();
        }
    
        using Proc = std::function<void(void)>;
    
        template<typename F, typename... Args>
        void enqueue_work(F&& f, Args&&... args) noexcept(std::is_nothrow_invocable<decltype(&blocking_queue<Proc>::push<Proc&&>)>::value)
        {
            m_workQueue.push([=]() { f(args...); });
        }
    
        template<typename F, typename... Args>
        auto enqueue_task(F&& f, Args&&... args) -> std::future<typename std::result_of<F(Args...)>::type>
        {
            using return_type = typename std::result_of<F(Args...)>::type;
            auto task = std::make_shared<std::packaged_task<return_type()>>(std::bind(std::forward<F>(f), std::forward<Args>(args)...));
            std::future<return_type> res = task->get_future();
            m_workQueue.push([task](){ (*task)(); });
            return res;
        }
    
    private:
        using ThreadPool = std::vector<std::thread>;
        ThreadPool m_threads;
        blocking_queue<Proc> m_workQueue;
    };
