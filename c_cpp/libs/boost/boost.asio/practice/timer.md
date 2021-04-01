# Timer

- [Timer](#timer)
  - [Reference](#reference)
    - [Tutorial](#tutorial)
      - [Timer.1 - Using a timer synchronously](#timer1---using-a-timer-synchronously)
      - [Timer.2 - Using a timer asynchronously](#timer2---using-a-timer-asynchronously)
      - [Timer.3 - Binding arguments to a handler](#timer3---binding-arguments-to-a-handler)
      - [Timer.4 - Using a member function as a handler](#timer4---using-a-member-function-as-a-handler)
      - [Timer.5 - Synchronising handlers in multithreaded programs](#timer5---synchronising-handlers-in-multithreaded-programs)

## Reference

### Tutorial

#### [Timer.1 - Using a timer synchronously](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/tutorial/tuttimer1.html)

#### [Timer.2 - Using a timer asynchronously](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/tutorial/tuttimer2.html)

#### [Timer.3 - Binding arguments to a handler](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/tutorial/tuttimer3.html)

Implement a Repeating Timer

    #include <iostream>
    #include <boost/asio.hpp>
    #include <boost/bind/bind.hpp>
    
    void print(const boost::system::error_code& /*e*/,
        boost::asio::steady_timer* t, int* count)
    {
        if (*count < 5)
        {
            std::cout << *count << std::endl;
            ++(*count);
    
            t->expires_at(t->expiry() + boost::asio::chrono::seconds(1));
            t->async_wait(boost::bind(print,
                boost::asio::placeholders::error, t, count));
        }
    }
    
    int main()
    {
        boost::asio::io_context io;
    
        int count = 0;
        boost::asio::steady_timer t(io, boost::asio::chrono::seconds(1));
        t.async_wait(boost::bind(print,
            boost::asio::placeholders::error, &t, &count));
    
        io.run();
    
        std::cout << "Final count is " << count << std::endl;
    
        return 0;
    }

#### [Timer.4 - Using a member function as a handler](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/tutorial/tuttimer4.html)

#### [Timer.5 - Synchronising handlers in multithreaded programs](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/tutorial/tuttimer5.html)

The [`strand`](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/reference/strand.html) class template is an executor adapter that guarantees that, for those handlers that are dispatched through it, an executing handler will be allowed to complete before the next one is started. This is guaranteed irrespective of the number of threads that are calling [`io_context::run()`](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/reference/io_context/run.html).

Each callback handler is "bound" to an `boost::asio::strand<boost::asio::io_context::executor_type>` object. The `boost::asio::bind_executor()` function **returns a new handler** that automatically dispatches its contained handler through the [`strand`](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/reference/strand.html) object. By binding the handlers to the same [`strand`](https://www.boost.org/doc/libs/1_73_0/doc/html/boost_asio/reference/strand.html), we are ensuring that they cannot execute concurrently.

|||
|-|-|
Comment| `strand` can make two handlers execute mutually exclusive. `strand` reduces the difficulty of multi-threading programming, by remove the mutex that protects the shared variables.
|||

    #include <iostream>
    #include <boost/asio.hpp>
    #include <boost/thread/thread.hpp>
    #include <boost/bind/bind.hpp>

    class printer
    {
    public:
        printer(boost::asio::io_context& io)
            : strand_(boost::asio::make_strand(io)),
            timer1_(io, boost::asio::chrono::seconds(1)),
            timer2_(io, boost::asio::chrono::seconds(1)),
            count_(0)
        {
            timer1_.async_wait(boost::asio::bind_executor(strand_,
                boost::bind(&printer::print1, this)));

            timer2_.async_wait(boost::asio::bind_executor(strand_,
                boost::bind(&printer::print2, this)));
        }

        ~printer()
        {
            std::cout << "Final count is " << count_ << std::endl;
        }

        void print1()
        {
            if (count_ < 10)
            {
                LOG_INFO("Timer 1: {}", count_);
                ++count_;
                std::this_thread::sleep_for(std::chrono::seconds(3));

                timer1_.expires_at(timer1_.expiry() + boost::asio::chrono::seconds(1));

                timer1_.async_wait(boost::asio::bind_executor(strand_,
                    boost::bind(&printer::print1, this)));
            }
        }

        void print2()
        {
            if (count_ < 10)
            {
                LOG_INFO("Timer 2: {}", count_);
                ++count_;

                timer2_.expires_at(timer2_.expiry() + boost::asio::chrono::seconds(1));

                timer2_.async_wait(boost::asio::bind_executor(strand_,
                    boost::bind(&printer::print2, this)));
            }
        }

    private:
        boost::asio::strand<boost::asio::io_context::executor_type> strand_;
        boost::asio::steady_timer timer1_;
        boost::asio::steady_timer timer2_;
        int count_;
    };

    int main()
    {
        InitLogger();
        boost::asio::io_context io;
        printer p(io);
        boost::thread t(boost::bind(&boost::asio::io_context::run, &io));
        io.run();
        t.join();

        return 0;
    }
