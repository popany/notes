# use gdb

- [use gdb](#use-gdb)
  - [wait for gdb to attach](#wait-for-gdb-to-attach)

## [wait for gdb to attach](https://stackoverflow.com/a/30578041)

At least with LLDB making the process send `SIGSTOP` to itself should do the trick. Debugger continue command will then issue the `SIGCONT`. This should work with GDB too. Alternatively try `SIGINT` instead of `SIGSTOP`.

Include header

    #include <signal.h>
    #include <csignal> // or C++ style alternative

then

    raise(SIGSTOP)
