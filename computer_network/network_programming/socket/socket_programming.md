# Socket Programming

- [Socket Programming](#socket-programming)
  - [`write(2)`](#write2)
    - [How to prevent SIGPIPEs](#how-to-prevent-sigpipes)
  - [How to handle the Linux socket revents `POLLERR`, `POLLHUP` and `POLLNVAL`?](#how-to-handle-the-linux-socket-revents-pollerr-pollhup-and-pollnval)
  - [change the size of the receive and the send buffer](#change-the-size-of-the-receive-and-the-send-buffer)
    - [ref - socket(7)](#ref---socket7)

## [`write(2)`](https://man7.org/linux/man-pages/man2/write.2.html)

`write` to a pipe or socket whose reading end is closed can generate `SIGPIPE`, thus, the write return value is seen only if the program catches, blocks or ignores this signal.

### [How to prevent SIGPIPEs](https://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly)

You generally want to ignore the `SIGPIPE` and handle the error directly in your code. This is because signal handlers in C have many restrictions on what they can do.

The most portable way to do this is to set the `SIGPIPE` handler to `SIG_IGN`. This will prevent any socket or pipe write from causing a `SIGPIPE` signal.

To ignore the `SIGPIPE` signal, use the following code:

    signal(SIGPIPE, SIG_IGN);

If you're using the `send()` call, another option is to use the `MSG_NOSIGNAL` option, which will turn the `SIGPIPE` behavior off on a per call basis. Note that not all operating systems support the `MSG_NOSIGNAL` flag.

Lastly, you may also want to consider the `SO_SIGNOPIPE` socket flag that can be set with `setsockopt()` on some operating systems. This will prevent `SIGPIPE` from being caused by writes just to the sockets it is set on.

## [How to handle the Linux socket revents `POLLERR`, `POLLHUP` and `POLLNVAL`?](https://stackoverflow.com/questions/24791625/how-to-handle-the-linux-socket-revents-pollerr-pollhup-and-pollnval)

A `POLLHUP` means the socket is no longer connected. In TCP, this means **`FIN` has been received and sent**.

A `POLLERR` means the socket got an asynchronous error. In TCP, this typically means a **`RST` has been received or sent**. If the file descriptor is not a socket, `POLLERR` might mean the device does not support polling.

For both of the conditions above, the socket file descriptor is still open, and has not yet been closed (but `shutdown()` may have already been called). A `close()` on the file descriptor will release resources that are still being reserved on behalf of the socket. In theory, it should be possible to reuse the socket immediately (e.g., with another `connect()` call).

A `POLLNVAL` means the socket file descriptor is not open. It would be an error to `close()` it.

## change the size of the receive and the send buffer

    int buffersize = 64*1024;  // 64k
    setsockopt(socket, SOL_SOCKET, SO_SNDBUF, (char *) &buffersize, sizeof(buffersize));

    socklen_t buffersize_len = sizeof(buffersize); // in/out parameter
    getsockopt(socket, SOL_SOCKET, SO_SNDBUF, (char *) &buffersize, &buffersize_len);

### [ref - socket(7)](https://www.man7.org/linux/man-pages/man7/socket.7.html)

> - `SO_RCVBUF`
>
>   Sets or gets the maximum socket receive buffer in bytes. The kernel doubles this value (to allow space for bookkeeping overhead) when it is set using [`setsockopt(2)`](https://www.man7.org/linux/man-pages/man2/setsockopt.2.html), and this doubled value is returned by [`getsockopt(2)`](https://www.man7.org/linux/man-pages/man2/getsockopt.2.html). The default value is set by the `/proc/sys/net/core/rmem_default` file, and the maximum allowed value is set by the /proc/sys/net/core/rmem_max file.  The minimum (doubled) value for this option is 256.
>
> - `SO_SNDBUF`
>
>   Sets or gets the maximum socket send buffer in bytes. The kernel doubles this value (to allow space for bookkeeping overhead) when it is set using [`setsockopt(2)`](https://www.man7.org/linux/man-pages/man2/setsockopt.2.html), and this doubled value is returned by [`getsockopt(2)`](https://www.man7.org/linux/man-pages/man2/getsockopt.2.html). The default value is set by the `/proc/sys/net/core/wmem_default` file and the maximum allowed value is set by the `/proc/sys/net/core/wmem_max` file. The minimum (doubled) value for this option is 2048.
