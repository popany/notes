# GDB

- [GDB](#gdb)
  - [gdbserver](#gdbserver)
  - [Practice](#practice)
    - [Command](#command)
      - [Start `gdb`](#start-gdb)
        - [Start `gdb` with an executable program specified](#start-gdb-with-an-executable-program-specified)
        - [Start `gdb` with both an executable program and a core file specified](#start-gdb-with-both-an-executable-program-and-a-core-file-specified)
        - [Debug a running process](#debug-a-running-process)
        - [Pass arguments to executable](#pass-arguments-to-executable)

[Beej's Quick Guide to GDB](https://beej.us/guide/bggdb/)

[How to open a source file in GDB TUI](https://stackoverflow.com/questions/17342393/how-to-open-a-source-file-in-gdb-tui)

[Step out of current function with GDB](https://stackoverflow.com/questions/24712690/step-out-of-current-function-with-gdb)

## gdbserver

## Practice

### Command

#### Start `gdb`

##### Start `gdb` with an executable program specified

    gdb program

##### Start `gdb` with both an executable program and a core file specified

    gdb program core

##### Debug a running process

    gdb program 1234

or

    gdb -p 1234

With option `-p` you can omit the program filename.

##### Pass arguments to executable

    gdb --args gcc -O2 -c foo.c

This will cause gdb to debug gcc, and to set gcc’s command-line arguments (see Arguments) to ‘`-O2 -c foo.c`’.





