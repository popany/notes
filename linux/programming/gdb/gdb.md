# GDB

- [GDB](#gdb)
  - [Reference](#reference)
    - [Beej's Quick Guide to GDB](#beejs-quick-guide-to-gdb)
    - [GDB Command Reference](#gdb-command-reference)
    - [How to open a source file in GDB TUI](#how-to-open-a-source-file-in-gdb-tui)
    - [Step out of current function with GDB](#step-out-of-current-function-with-gdb)
  - [gdbserver](#gdbserver)
  - [Command](#command)
    - [Start `gdb`](#start-gdb)
      - [Start `gdb` with an executable program specified](#start-gdb-with-an-executable-program-specified)
      - [Start `gdb` with both an executable program and a core file specified](#start-gdb-with-both-an-executable-program-and-a-core-file-specified)
      - [Debug a running process](#debug-a-running-process)
      - [Pass arguments to executable](#pass-arguments-to-executable)
    - [Debugging Programs with Multiple Threads](#debugging-programs-with-multiple-threads)
      - [Inquire about existing threads](#inquire-about-existing-threads)
      - [Switch among threads](#switch-among-threads)
      - [Apply a command to a list of threads](#apply-a-command-to-a-list-of-threads)
        - [Get backtrace for all threads](#get-backtrace-for-all-threads)
    - [`info`](#info)
      - [`info source`](#info-source)
      - [`info sources`](#info-sources)
      - [`info program`](#info-program)
      - [`info breakpoints`](#info-breakpoints)
      - [`info functions`](#info-functions)
      - [`info threads`](#info-threads)
    - [`thread`](#thread)
      - [`thread <thread ID>`](#thread-thread-id)
    - [`list`](#list)
      - [`list FILE:LINENUM`](#list-filelinenum)
      - [`list LINENUM`](#list-linenum)
      - [`list FILE:FUNCTION`](#list-filefunction)
      - [`list FUNCTION`](#list-function)
    - [`break <location>`](#break-location)
    - [`delete`](#delete)
      - [`delete 1`](#delete-1)
    - [`step`](#step)
    - [`next`](#next)
    - [`continue`](#continue)
    - [`backtrace`](#backtrace)

## Reference

### [Beej's Quick Guide to GDB](https://beej.us/guide/bggdb/)

### [GDB Command Reference](https://visualgdb.com/gdbreference/commands/)

### [How to open a source file in GDB TUI](https://stackoverflow.com/questions/17342393/how-to-open-a-source-file-in-gdb-tui)

### [Step out of current function with GDB](https://stackoverflow.com/questions/24712690/step-out-of-current-function-with-gdb)

## gdbserver

## Command

### Start `gdb`

#### Start `gdb` with an executable program specified

    gdb program

#### Start `gdb` with both an executable program and a core file specified

    gdb program core

#### Debug a running process

    gdb program 1234

or

    gdb -p 1234

With option `-p` you can omit the program filename.

#### Pass arguments to executable

    gdb --args gcc -O2 -c foo.c

This will cause gdb to debug gcc, and to set gcc’s command-line arguments (see Arguments) to ‘`-O2 -c foo.c`’.

### [Debugging Programs with Multiple Threads](https://www-zeuthen.desy.de/unix/unixguide/infohtml/gdb/Threads.html)

#### Inquire about existing threads

    info threads [id]

#### Switch among threads

    thread <id>

#### Apply a command to a list of threads

    thread apply [threadno] [all] args

##### Get backtrace for all threads

    thread apply all bt

### `info`

#### `info source`

Information about the current source file

#### `info sources`

Source files in the program

#### `info program`

Execution status of the program

Example:

    (gdb) info program
    The program being debugged is not being run.

#### `info breakpoints`

Status of specified breakpoints (all user-settable breakpoints if no argument)

#### `info functions`

All function names

#### `info threads`

Display currently known threads

### `thread`

#### `thread <thread ID>`

switch between threads

### `list`

#### `list FILE:LINENUM`

Example:

    (gdb) list basic_string.h:1
    1       // Components for manipulating sequences of characters -*- C++ -*-
    2
    3       // Copyright (C) 1997-2018 Free Software Foundation, Inc.
    4       //
    5       // This file is part of the GNU ISO C++ Library.  This library is free
    6       // software; you can redistribute it and/or modify it under the
    7       // terms of the GNU General Public License as published by the
    8       // Free Software Foundation; either version 3, or (at your option)
    9       // any later version.
    10
    (gdb)

#### `list LINENUM`

list line in current file

Example:

    (gdb) list 1
    1       // Components for manipulating sequences of characters -*- C++ -*-
    2
    3       // Copyright (C) 1997-2018 Free Software Foundation, Inc.
    4       //
    5       // This file is part of the GNU ISO C++ Library.  This library is free
    6       // software; you can redistribute it and/or modify it under the
    7       // terms of the GNU General Public License as published by the
    8       // Free Software Foundation; either version 3, or (at your option)
    9       // any later version.
    10
    (gdb)

#### `list FILE:FUNCTION`

Example:

    (gdb) list basic_string.h:find
    2547
    2548      template<typename _Key, typename _Val, typename _KeyOfValue,
    2549               typename _Compare, typename _Alloc>
    2550        typename _Rb_tree<_Key, _Val, _KeyOfValue,
    2551                          _Compare, _Alloc>::const_iterator
    2552        _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
    2553        find(const _Key& __k) const
    2554        {
    2555          const_iterator __j = _M_lower_bound(_M_begin(), _M_end(), __k);
    2556          return (__j == end()
    (gdb)

#### `list FUNCTION`

Example:

    (gdb) list find
    2547
    2548      template<typename _Key, typename _Val, typename _KeyOfValue,
    2549               typename _Compare, typename _Alloc>
    2550        typename _Rb_tree<_Key, _Val, _KeyOfValue,
    2551                          _Compare, _Alloc>::const_iterator
    2552        _Rb_tree<_Key, _Val, _KeyOfValue, _Compare, _Alloc>::
    2553        find(const _Key& __k) const
    2554        {
    2555          const_iterator __j = _M_lower_bound(_M_begin(), _M_end(), __k);
    2556          return (__j == end()
    (gdb)

### `break <location>`

### `delete`

Delete some breakpoints or auto-display expressions

#### `delete 1`

Delete break point 1

### `step`

Continue running your program until control reaches a different source line, then stop it and return control to GDB. This command is abbreviated `s`

### `next`

Continue to the next source line in the current (innermost) stack frame. This is similar to step, but function calls that appear within the line of code are executed without stopping. Execution stops when control reaches a different line of code at the original stack level that was executing when you gave the next command. This command is abbreviated `n`.

### `continue`

Continue program being debugged, after signal or breakpoint

### `backtrace`

Print backtrace of all stack frames, or innermost COUNT frames
