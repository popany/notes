# [Using all 3 pipes of a child process asynchronously](https://riptutorial.com/boost/example/32459/using-all-3-pipes-of-a-child-process-asynchronously-)

- [Using all 3 pipes of a child process asynchronously](#using-all-3-pipes-of-a-child-process-asynchronously)
  - [Example](#example)

## Example

    #include <vector>
    #include <string>
    #include <boost/process.hpp>
    #include <boost/asio.hpp>
    #include <boost/process/windows.hpp>

    int Run(
        const std::string& exeName,         ///< could also be UTF-16 for Windows
        const std::string& args,            ///< could also be UTF-16 for Windows
        const std::string& input,           ///< [in] data for stdin
        std::string& output,                ///< [out] data from stdout
        std::string& error                  ///< [out] data from stderr
    )
    {
        using namespace boost;

        asio::io_service ios;

        // stdout setup
        //
        std::vector<char> vOut(128 << 10);           // that worked well for my decoding app.
        auto outBuffer{ asio::buffer(vOut) };
        process::async_pipe pipeOut(ios);

        std::function<void(const system::error_code & ec, std::size_t n)> onStdOut;
        onStdOut = [&](const system::error_code & ec, size_t n)
        {
            output.reserve(output.size() + n);
            output.insert(output.end(), vOut.begin(), vOut.begin() + n);
            if (!ec)
            {
                asio::async_read(pipeOut, outBuffer, onStdOut);
            }
        };

        // stderr setup
        //
        std::vector<char> vErr(128 << 10);
        auto errBuffer{ asio::buffer(vErr) };
        process::async_pipe pipeErr(ios);

        std::function<void(const system::error_code & ec, std::size_t n)> onStdErr;
        onStdErr = [&](const system::error_code & ec, size_t n)
        {
            error.reserve(error.size() + n);
            error.insert(error.end(), vErr.begin(), vErr.begin() + n);
            if (!ec)
            {
                asio::async_read(pipeErr, errBuffer, onStdErr);
            }
        };

        // stdin setup
        //
        auto inBuffer{ asio::buffer(input) };
        process::async_pipe pipeIn(ios);

        process::child c(
            exeName + " " + args,                   // exeName must be full path
            process::std_out > pipeOut, 
            process::std_err > pipeErr, 
            process::std_in < pipeIn
        );

        asio::async_write(pipeIn, inBuffer, 
            [&](const system::error_code & ec, std::size_t n) 
            {
                pipeIn.async_close();                     //  tells the child we have no more data
            });

        asio::async_read(pipeOut, outBuffer, onStdOut);
        asio::async_read(pipeErr, errBuffer, onStdErr);

        ios.run();
        c.wait();
        return c.exit_code();                            // return the process' exit code.
    }
