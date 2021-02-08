# Socket Programming

- [Socket Programming](#socket-programming)
  - [`write(2)`](#write2)
    - [How to prevent SIGPIPEs](#how-to-prevent-sigpipes)
  - [How to handle the Linux socket revents `POLLERR`, `POLLHUP` and `POLLNVAL`?](#how-to-handle-the-linux-socket-revents-pollerr-pollhup-and-pollnval)
    - [Anwser by jxh](#anwser-by-jxh)
    - [Answer by Gilles](#answer-by-gilles)
  - [change the size of the receive and the send buffer](#change-the-size-of-the-receive-and-the-send-buffer)
    - [ref - socket(7)](#ref---socket7)
    - [`shutdown` `SHUT_RD`/`SHUT_WR`](#shutdown-shut_rdshut_wr)
      - [Linux test result](#linux-test-result)

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

### [Anwser by jxh](https://stackoverflow.com/questions/24791625/how-to-handle-the-linux-socket-revents-pollerr-pollhup-and-pollnval/24791833#24791833)

A `POLLHUP` means the socket is no longer connected. In TCP, this means **`FIN` has been received and sent**.

A `POLLERR` means the socket got an asynchronous error. In TCP, this typically means a **`RST` has been received or sent**. If the file descriptor is not a socket, `POLLERR` might mean the device does not support polling.

For both of the conditions above, the socket file descriptor is still open, and has not yet been closed (but `shutdown()` may have already been called). A `close()` on the file descriptor will release resources that are still being reserved on behalf of the socket. In theory, it should be possible to reuse the socket immediately (e.g., with another `connect()` call).

A `POLLNVAL` means the socket file descriptor is not open. It would be an error to `close()` it.

### [Answer by Gilles](https://stackoverflow.com/questions/24791625/how-to-handle-the-linux-socket-revents-pollerr-pollhup-and-pollnval/25249958#25249958)

`POLLNVAL` means that the file descriptor value is invalid. It usually indicates an error in your program, but you can rely on `poll` returning `POLLNVAL` if you've closed a file descriptor and you haven't opened any file since then that might have reused the descriptor.

`POLLERR` is similar to error events from `select`. It indicates that a `read` or `write` call would return an error condition (e.g. I/O error). This does not include out-of-band data which `select` signals via its `errorfds` mask but `poll` signals via `POLLPRI`.

`POLLHUP` basically means that what's at the other end of the connection has closed its end of the connection. [POSIX](http://pubs.opengroup.org/onlinepubs/009695399/functions/poll.html) describes it as

> The device has been disconnected. This event and POLLOUT are mutually-exclusive; a stream can never be writable if a hangup has occurred.

This is clear enough for a terminal: the terminal has gone away (same event that generates a `SIGHUP`: the modem session has been terminated, the terminal emulator window has been closed, etc.). `POLLHUP` is never sent for a **regular file**. For **pipes and sockets**, it [depends on the operating system](http://www.greenend.org.uk/rjk/tech/poll.html). Linux sets `POLLHUP` when the program on the writing end of a pipe closes the pipe, and sets `POLLIN|POLLHUP` when the other end of a socket **closed the socket**, but `POLLIN` only for a **socket shutdown**. Recent *BSD set `POLLIN|POLLUP` when the writing end of a pipe closes the pipe, and the behavior for sockets is more variable.

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

### `shutdown` `SHUT_RD`/`SHUT_WR`

#### Linux test result

- After `shutdown` `SHUT_RD`

  - `read`

    - receive buffer is not empty
  
      - `read` function will read all data in the receive buffer with an end-of-file

    - receive buffer is empty

      - `read` function will read an end-of-file

  - peer `write`

    - the receive buffer can be written by the peer, even after `shutdown` was called

  - `select`

    - if the socket is watched for reading by `select`, the `select` function will return immediately and marks the socket as read for reading

  - `poll`

    - if `POLLIN` was set

      - report `POLLIN`

- After `shutdown` `SHUT_WR`

  - TCP

    - send `FIN`

  - `write`

    - signal `SIGPIPE`

    or

    - return `EPIPE`

  - `select`

    - local

      - if readfds and writefds and exceptfds were set

        - set writefds

    - peer

      - if readfds and writefds and exceptfds were set

        - set readfs and writefds

  - `poll`

    - local

      - if `POLLIN | POLLOUT` was set

        - report `POLLOUT`

    - peer

      - if `POLLIN | POLLOUT` was set

        - report `POLLIN | POLLOUT`

- After local and peer both `shutdown` `SHUT_WR`

  - `select`

    - if readfds and writefds and exceptfds were set

      - set readfs and writefds

  - `poll`

    - if `POLLIN | POLLOUT` was set

      - report `POLLIN | POLLOUT | POLLHUP`
