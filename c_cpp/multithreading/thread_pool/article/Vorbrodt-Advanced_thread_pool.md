# [Vorbrodt-Advanced_thread_pool](https://vorbrodt.blog/2019/02/27/advanced-thread-pool/)

- [Vorbrodt-Advanced_thread_pool](#vorbrodt-advanced_thread_pool)
  - [Benchmark program](#benchmark-program)
  - [thread_pool class](#thread_pool-class)

Below is my implementation of the thread pool described in [this talk](https://vorbrodt.blog/?p=830) and a benchmark comparing it against my [simple thread pool](https://vorbrodt.blog/?p=631) implementation. The advanced pool is 15x faster at scheduling and dispatching short random length work items on my 2018 MacBook Pro with i5 CPU and 4 logical cores. It uses a queue per worker thread and a work stealing dispatcher. It tries to enqueue the work items onto a queue that is not currently locked by a dispatch thread. It also tries to steal work from other unblocked queues. As always the complete implementation is available at [GitHub](https://github.com/mvorbrodt/blog).

## Benchmark program

    #include <iostream>
    #include <chrono>
    #include <cstdlib>
    #include "pool.h"
    using namespace std;
    using namespace chrono;
    
    const unsigned int COUNT = 10'000'000;
    const unsigned int REPS = 10;
    
    int main()
    {
        srand(0);
        auto start = high_resolution_clock::now();
        {
            simple_thread_pool tp;
            for(int i = 0; i < COUNT; ++i)
                tp.enqueue_work([i]() {
                    int x;
                    int reps = REPS + (REPS * (rand() % 5));
                    for(int n = 0; n < reps; ++n)
                        x = i + rand();
                });
        }
        auto end = high_resolution_clock::now();
        auto duration = duration_cast<milliseconds>(end - start);
        cout << "simple_thread_pool duration = " << duration.count() / 1000.f << " s" << endl;
    
        srand(0);
        start = high_resolution_clock::now();
        {
            thread_pool tp;
            for(int i = 0; i < COUNT; ++i)
                tp.enqueue_work([i]() {
                    int x;
                    int reps = REPS + (REPS * (rand() % 5));
                    for(int n = 0; n < reps; ++n)
                        x = i + rand();
                });
        }
        end = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(end - start);
        cout << "thread_pool duration = " << duration.count() / 1000.f << " s" << endl;
    }

## thread_pool class

    class thread_pool
    {
    public:
        thread_pool(unsigned int threads = std::thread::hardware_concurrency())
        : m_queues(threads), m_count(threads)
        {
            assert(threads != 0);
            auto worker = [&](unsigned int i)
            {
                while(true)
                {
                    Proc f;
                    for(unsigned int n = 0; n < m_count; ++n)
                        if(m_queues[(i + n) % m_count].try_pop(f)) break;
                    if(!f && !m_queues[i].pop(f)) break;
                    f();
                }
            };
            for(unsigned int i = 0; i < threads; ++i)
                m_threads.emplace_back(worker, i);
        }
    
        ~thread_pool() noexcept
        {
            for(auto& queue : m_queues)
                queue.done();
            for(auto& thread : m_threads)
                thread.join();
        }
    
        template<typename F, typename... Args>
        void enqueue_work(F&& f, Args&&... args)
        {
            auto work = [f,args...]() { f(args...); };
            unsigned int i = m_index++;
            for(unsigned int n = 0; n < m_count * K; ++n)
                if(m_queues[(i + n) % m_count].try_push(work)) return;
            m_queues[i % m_count].push(work);
        }
    
        template<typename F, typename... Args>
        auto enqueue_task(F&& f, Args&&... args) -> std::future<typename std::result_of<F(Args...)>::type>
        {
            using return_type = typename std::result_of<F(Args...)>::type;
            auto task = std::make_shared<std::packaged_task<return_type()>>(std::bind(std::forward<F>(f), std::forward<Args>(args)...));
            std::future<return_type> res = task->get_future();
    
            auto work = [task](){ (*task)(); };
            unsigned int i = m_index++;
            for(unsigned int n = 0; n < m_count * K; ++n)
                if(m_queues[(i + n) % m_count].try_push(work)) return res;
            m_queues[i % m_count].push(work);
    
            return res;
        }
    
    private:
        using Proc = std::function<void(void)>;
        using Queues = std::vector<simple_blocking_queue<Proc>>;
        Queues m_queues;
    
        using Threads = std::vector<std::thread>;
        Threads m_threads;
    
        const unsigned int m_count;
        std::atomic_uint m_index = 0;
    
        inline static const unsigned int K = 3;
    };
