# Socket Programming

- [Socket Programming](#socket-programming)
  - [`write(2)`](#write2)
    - [How to prevent SIGPIPEs](#how-to-prevent-sigpipes)

## [`write(2)`](https://man7.org/linux/man-pages/man2/write.2.html)

`write` to a pipe or socket whose reading end is closed can generate `SIGPIPE`, thus, the write return value is seen only if the program catches, blocks or ignores this signal.

### [How to prevent SIGPIPEs](https://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly)

You generally want to ignore the `SIGPIPE` and handle the error directly in your code. This is because signal handlers in C have many restrictions on what they can do.

The most portable way to do this is to set the `SIGPIPE` handler to `SIG_IGN`. This will prevent any socket or pipe write from causing a `SIGPIPE` signal.

To ignore the `SIGPIPE` signal, use the following code:

    signal(SIGPIPE, SIG_IGN);

If you're using the `send()` call, another option is to use the `MSG_NOSIGNAL` option, which will turn the `SIGPIPE` behavior off on a per call basis. Note that not all operating systems support the `MSG_NOSIGNAL` flag.

Lastly, you may also want to consider the `SO_SIGNOPIPE` socket flag that can be set with `setsockopt()` on some operating systems. This will prevent `SIGPIPE` from being caused by writes just to the sockets it is set on.
