# [Debugging With GDB](https://sourceware.org/gdb/onlinedocs/gdb/index.html)

- [Debugging With GDB](#debugging-with-gdb)
  - [Summary of GDB](#summary-of-gdb)
  - [1 A Sample GDB Session](#1-a-sample-gdb-session)
  - [2 Getting In and Out of GDB](#2-getting-in-and-out-of-gdb)
    - [2.1 Invoking GDB](#21-invoking-gdb)
      - [2.1.1 Choosing Files](#211-choosing-files)
      - [2.1.2 Choosing Modes](#212-choosing-modes)
      - [2.1.3 What GDB Does During Startup](#213-what-gdb-does-during-startup)
    - [2.2 Quitting GDB](#22-quitting-gdb)
    - [2.3 Shell Commands](#23-shell-commands)
    - [2.4 Logging Output](#24-logging-output)
  - [3 GDB Commands](#3-gdb-commands)
  - [9 Examining Source Files](#9-examining-source-files)
    - [9.1 Printing Source Lines](#91-printing-source-lines)
    - [9.2 Specifying a Location](#92-specifying-a-location)
    - [9.3 Editing Source Files](#93-editing-source-files)
    - [9.4 Searching Source Files](#94-searching-source-files)
    - [9.5 Specifying Source Directories](#95-specifying-source-directories)
    - [9.6 Source and Machine Code](#96-source-and-machine-code)
  - [11 Debugging Optimized Code](#11-debugging-optimized-code)
    - [11.1 Inline Functions](#111-inline-functions)
    - [11.2 Tail Call Frames](#112-tail-call-frames)
  - [20 Debugging Remote Programs](#20-debugging-remote-programs)
    - [20.1 Connecting to a Remote Target](#201-connecting-to-a-remote-target)
      - [Types of Remote Connections](#types-of-remote-connections)
      - [Host and Target Files](#host-and-target-files)
      - [Remote Connection Commands](#remote-connection-commands)
    - [20.2 Sending files to a remote system](#202-sending-files-to-a-remote-system)
    - [20.3 Using the gdbserver Program](#203-using-the-gdbserver-program)
      - [Running `gdbserver`](#running-gdbserver)
      - [Attaching to a Running Program](#attaching-to-a-running-program)
      - [Connecting to `gdbserver`](#connecting-to-gdbserver)
    - [20.4 Remote Configuration](#204-remote-configuration)
    - [20.5 Implementing a Remote Stub](#205-implementing-a-remote-stub)

## [Summary of GDB](https://sourceware.org/gdb/onlinedocs/gdb/Summary.html#Summary)

## [1 A Sample GDB Session](https://sourceware.org/gdb/onlinedocs/gdb/Sample-Session.html#Sample-Session)

## [2 Getting In and Out of GDB](https://sourceware.org/gdb/onlinedocs/gdb/Invocation.html#Invocation)

This chapter discusses how to **start GDB**, and how to **get out** of it. The essentials are: 

- type `gdb` to start GDB.
- type `quit` or `Ctrl-d` to exit.

### [2.1 Invoking GDB](https://sourceware.org/gdb/onlinedocs/gdb/Invoking-GDB.html#Invoking-GDB)

Invoke GDB by running the program gdb. Once started, GDB reads commands from the terminal until you tell it to exit.

The most usual way to start GDB is with one argument, specifying an executable program:

    gdb program

You can also start with both an executable program and a core file specified:

    gdb program core

You can, instead, specify a process ID as a second argument or use option -p, if you want to debug a running process:

    gdb program 1234
    gdb -p 1234

would attach GDB to process 1234. With option -p you can omit the program filename.

You can optionally have gdb pass any arguments after the executable file to the inferior using `--args`. This option stops option processing.

    gdb --args gcc -O2 -c foo.c

This will cause `gdb` to debug `gcc`, and to set gcc’s command-line arguments (see [Arguments](https://sourceware.org/gdb/onlinedocs/gdb/Arguments.html#Arguments)) to ‘`-O2 -c foo.c`’.

You can run gdb without printing the front material, which describes GDB’s non-warranty, by specifying `--silent` (or `-q/--quiet`):

    gdb --silent

You can further control how GDB starts up by using command-line options. GDB itself can remind you of the options available.

Type

    gdb -help

to display all available options and briefly describe their use (‘`gdb -h`’ is a shorter equivalent).

#### [2.1.1 Choosing Files](https://sourceware.org/gdb/onlinedocs/gdb/File-Options.html#File-Options)

When GDB starts, it reads any arguments other than options as specifying an executable file and core file (or process ID). This is the same as if the arguments were specified by the ‘`-se`’ and ‘`-c`’ (or ‘`-p`’) options respectively. (GDB reads the **first argument that does not have an associated option flag** as equivalent to the ‘`-se`’ option followed by that argument; and the **second argument that does not have an associated option flag**, if any, as equivalent to the ‘`-c`’/‘`-p`’ option followed by that argument.) If the **second argument begins with a decimal digit**, GDB will first attempt to attach to it as a process, and if that fails, attempt to open it as a corefile. If you have a corefile whose name begins with a digit, you can prevent GDB from treating it as a pid by prefixing it with `./`, e.g. `./12345`.

If GDB has not been configured to included core file support, such as for most embedded targets, then it will complain about a second argument and ignore it.

Many options have both long and short forms; both are shown in the following list. GDB also recognizes the long forms if you **truncate** them, so long as enough of the option is present to be unambiguous. (If you prefer, you can flag option arguments with ‘`--`’ rather than ‘`-`’, though we illustrate the more usual convention.)

`-symbols file`

`-s file`

Read symbol table from file file. 

`-exec file`

`-e file`

Use file file as the executable file to execute when appropriate, and for examining pure data in conjunction with a core dump.

`-se file`

Read symbol table from file file and use it as the executable file.

`-core file`

`-c file`

Use file file as a core dump to examine.

`-pid number`

`-p number`

Connect to process ID number, as with the attach command.

`-command file`

`-x file`

Execute commands from file `file`. The contents of this file is evaluated exactly as the source command would. See [Command files](https://sourceware.org/gdb/onlinedocs/gdb/Command-Files.html#Command-Files).

`-eval-command command`

`-ex command`

Execute a single GDB command.

This option may be used multiple times to call multiple commands. It may also be interleaved with ‘`-command`’ as required.

    gdb -ex 'target sim' -ex 'load' \
        -x setbreakpoints -ex 'run' a.out

`-init-command file`

`-ix file`

Execute commands from file `file` before loading the inferior (but after loading gdbinit files). See [Startup](https://sourceware.org/gdb/onlinedocs/gdb/Startup.html#Startup).

`-init-eval-command command`

`-iex command`

Execute a single GDB command before loading the inferior (but after loading gdbinit files). See [Startup](https://sourceware.org/gdb/onlinedocs/gdb/Startup.html#Startup).

`-directory directory`

`-d directory`

Add directory to the path to search for source and script files.

`-r`

`-readnow`

Read each symbol file’s entire symbol table immediately, rather than the default, which is to read it incrementally as it is needed. This makes startup slower, but makes future operations faster.

`--readnever`

Do not read each symbol file’s symbolic debug information. This makes startup faster but at the expense of not being able to perform symbolic debugging. DWARF unwind information is also not read, meaning backtraces may become incomplete or inaccurate. One use of this is when a user simply wants to do the following sequence: attach, dump core, detach. Loading the debugging information in this case is an unnecessary cause of delay.

#### [2.1.2 Choosing Modes](https://sourceware.org/gdb/onlinedocs/gdb/Mode-Options.html#Mode-Options)

You can run GDB in various alternative modes—for example, in batch mode or quiet mode.

#### [2.1.3 What GDB Does During Startup](https://sourceware.org/gdb/onlinedocs/gdb/Startup.html#Startup)

Here’s the description of what GDB does during session startup:

1. Sets up the command interpreter as specified by the command line (see [interpreter](https://sourceware.org/gdb/onlinedocs/gdb/Mode-Options.html#Mode-Options)).

2. Reads the system-wide init file (if `--with-system-gdbinit` was used when building GDB; see [System-wide configuration and settings](https://sourceware.org/gdb/onlinedocs/gdb/System_002dwide-configuration.html#System_002dwide-configuration)) and the files in the system-wide gdbinit directory (if `--with-system-gdbinit-dir` was used) and executes all the commands in those files. The files need to be named with a `.gdb` extension to be interpreted as GDB commands, or they can be written in a supported scripting language with an appropriate file extension.

3. Reads the init file (if any) in your home directory and executes all the commands in that file.

4. Executes commands and command files specified by the ‘`-iex`’ and ‘`-ix`’ options in their specified order. Usually you should use the ‘`-ex`’ and ‘`-x`’ options instead, but this way you can apply settings before GDB init files get executed and before inferior gets loaded.

5. Processes command line options and operands.

6. Reads and executes the commands from init file (if any) in the current working directory as long as ‘`set auto-load local-gdbinit`’ is set to ‘`on`’ (see [Init File in the Current Directory](https://sourceware.org/gdb/onlinedocs/gdb/Init-File-in-the-Current-Directory.html#Init-File-in-the-Current-Directory)). This is only done if the current directory is different from your home directory. Thus, you can have more than one init file, one generic in your home directory, and another, specific to the program you are debugging, in the directory where you invoke GDB.

7. If the command line specified a program to debug, or a process to attach to, or a core file, GDB loads any auto-loaded scripts provided for the program or for its loaded shared libraries. See [Auto-loading](https://sourceware.org/gdb/onlinedocs/gdb/Auto_002dloading.html#Auto_002dloading).

   If you wish to disable the auto-loading during startup, you must do something like the following:

       gdb -iex "set auto-load python-scripts off" myprogram

   Option ‘`-ex`’ does not work because the auto-loading is then turned off too late.

8. Executes commands and command files specified by the ‘`-ex`’ and ‘`-x`’ options in their specified order. See [Command Files](https://sourceware.org/gdb/onlinedocs/gdb/Command-Files.html#Command-Files), for more details about GDB command files.

9. Reads the command history recorded in the history file. See [Command History](https://sourceware.org/gdb/onlinedocs/gdb/Command-History.html#Command-History), for more details about the command history and the files where GDB records it.

Init files use the same syntax as `command files` (see [Command Files](https://sourceware.org/gdb/onlinedocs/gdb/Command-Files.html#Command-Files)) and are processed by GDB in the same way. The init file in your home directory can set options (such as ‘`set complaints`’) that affect subsequent processing of command line options and operands. Init files are not executed if you use the ‘`-nx`’ option (see [Choosing Modes](https://sourceware.org/gdb/onlinedocs/gdb/Mode-Options.html#Mode-Options)).

To display the list of init files loaded by gdb at startup, you can use `gdb --help`.

The GDB init files are normally called `.gdbinit`. The DJGPP port of GDB uses the name `gdb.ini`, due to the limitations of file names imposed by DOS filesystems. The Windows port of GDB uses the standard name, but if it finds a `gdb.ini` file in your home directory, it warns you about that and suggests to rename the file to the standard name.

### 2.2 Quitting GDB

`quit [expression]`
`q`

To exit GDB, use the `quit` command (abbreviated `q`), or type an end-of-file character (usually `Ctrl-d`). If you do not supply `expression`, GDB will terminate normally; otherwise it will terminate using the result of `expression` as the error code.

An interrupt (often `Ctrl-c`) does not exit from GDB, but rather terminates the action of any GDB command that is in progress and returns to GDB command level. It is safe to type the interrupt character at any time because GDB does not allow it to take effect **until a time when it is safe**.

If you have been using GDB to control an attached process or device, you can release it with the `detach` command (see [Debugging an Already-running Process](https://sourceware.org/gdb/onlinedocs/gdb/Attach.html#Attach)).

### 2.3 Shell Commands

If you need to execute occasional shell commands during your debugging session, there is no need to leave or suspend GDB; you can just use the shell command.

`shell command-string`

`!command-string`

Invoke a standard shell to execute command-string. Note that no space is needed between `!` and command-string. If it exists, the environment variable `SHELL` determines which shell to run. Otherwise GDB uses the default shell (`/bin/sh` on Unix systems, `COMMAND.COM` on MS-DOS, etc.).

The utility make is often needed in development environments. You do not have to use the shell command for this purpose in GDB:

`make make-args`

Execute the `make` program with the specified arguments. This is equivalent to ‘`shell make make-args`’.

`pipe [command] | shell_command`

`| [command] | shell_command`

`pipe -d delim command delim shell_command`

`| -d delim command delim shell_command`

Executes `command` and sends its output to `shell_command`. Note that no space is needed around `|`. If no `command` is provided, the last command executed is repeated.

The convenience variables `$_shell_exitcode` and `$_shell_exitsignal` can be used to examine the exit status of the last shell command launched by `shell`, `make`, `pipe` and `|`. See [Convenience Variables](https://sourceware.org/gdb/onlinedocs/gdb/Convenience-Vars.html#Convenience-Vars).

### 2.4 Logging Output

You may want to save the output of GDB commands to a file. There are several commands to control GDB’s logging.

`set logging on`

Enable logging.

`set logging off`

Disable logging.

`set logging file file`

Change the name of the current logfile. The default logfile is `gdb.txt`.

`set logging overwrite [on|off]`

By default, GDB will append to the logfile. Set overwrite if you want set logging on to overwrite the logfile instead.

`set logging redirect [on|off]`

By default, GDB output will go to both the terminal and the logfile. Set redirect if you want output to go only to the log file.

`set logging debugredirect [on|off]`

By default, GDB debug output will go to both the terminal and the logfile. Set debugredirect if you want debug output to go only to the log file.

`show logging`

Show the current values of the logging settings.

You can also redirect the output of a GDB command to a shell command. See [pipe](https://sourceware.org/gdb/onlinedocs/gdb/Shell-Commands.html#pipe).

## [3 GDB Commands](https://sourceware.org/gdb/onlinedocs/gdb/Commands.html#Commands)





































## [9 Examining Source Files](https://sourceware.org/gdb/onlinedocs/gdb/Source.html)

GDB can print parts of your program’s source, since the debugging information recorded in the program tells GDB what source files were used to build it.

### [9.1 Printing Source Lines](https://sourceware.org/gdb/onlinedocs/gdb/List.html)

To print lines from a source file, use the `list` command (abbreviated `l`).

### [9.2 Specifying a Location](https://sourceware.org/gdb/onlinedocs/gdb/Specify-Location.html)

### [9.3 Editing Source Files](https://sourceware.org/gdb/onlinedocs/gdb/Edit.html)

### [9.4 Searching Source Files](https://sourceware.org/gdb/onlinedocs/gdb/Search.html)

### [9.5 Specifying Source Directories](https://sourceware.org/gdb/onlinedocs/gdb/Source-Path.html)

Executable programs sometimes do not record the directories of the source files from which they were compiled, just the names. Even when they do, the directories could be moved between the compilation and your debugging session. GDB has a list of directories to search for source files; this is called the `source path`. Each time GDB wants a source file, it tries all the directories in the list, in the order they are present in the list, until it **finds a file with the desired name**.

The source path will always include two special entries ‘`$cdir`’ and ‘`$cwd`’, these refer to the compilation directory (if one is recorded) and the current working directory respectively. 

If a compilation directory is recorded in the debug information, and GDB has not found the source file after the first search using `source path`, then GDB will combine the compilation directory and the filename, and then search for the source file again using the `source path`.

Whenever you reset or rearrange the source path, GDB clears out any information it has cached about where source files are found and where each line is in the file.

When you start GDB, its source path includes only ‘`$cdir`’ and ‘`$cwd`’, in that order. To add other directories, use the `directory` command.

### [9.6 Source and Machine Code](https://sourceware.org/gdb/onlinedocs/gdb/Machine-Code.html)

## [11 Debugging Optimized Code](https://sourceware.org/gdb/onlinedocs/gdb/Optimized-Code.html)

Almost all compilers support optimization. With optimization disabled, the compiler generates assembly code that corresponds directly to your source code, in a simplistic way. As the compiler applies more powerful optimizations, the generated assembly code diverges from your original source code. With help from debugging information generated by the compiler, GDB can map from the running program back to constructs from your original source.

GDB is more accurate with optimization disabled. If you can recompile without optimization, it is easier to follow the progress of your program during debugging. But, there are many cases where you may need to debug an optimized version.

When you debug a program compiled with ‘`-g -O`’, remember that the optimizer has rearranged your code; the debugger shows you what is really there. Do not be too surprised when the execution path does not exactly match your source file! An extreme example: if you define a variable, but never use it, GDB never sees that variable—because the compiler optimizes it out of existence.

### [11.1 Inline Functions](https://sourceware.org/gdb/onlinedocs/gdb/Inline-Functions.html)

### [11.2 Tail Call Frames](https://sourceware.org/gdb/onlinedocs/gdb/Tail-Call-Frames.html)

## [20 Debugging Remote Programs](https://sourceware.org/gdb/onlinedocs/gdb/Remote-Debugging.html)

### [20.1 Connecting to a Remote Target](https://sourceware.org/gdb/onlinedocs/gdb/Connecting.html)

#### Types of Remote Connections

- With target remote mode
- With target extended-remote mode

#### Host and Target Files

GDB, running on the host, needs access to **symbol and debugging information** for your program running on the target. This requires access to an unstripped copy of your program, and possibly any associated symbol files.

If the remote program is stripped, or the target does not support remote program file access, start up GDB using the name of the local unstripped copy of your program as the first argument, or use the `file` command.

The symbol file and target libraries must **exactly match** the executable and libraries on the target, with one exception: the files on the host system should not be stripped, even if the files on the target system are. Mismatched or missing files will lead to confusing results during debugging. On GNU/Linux targets, mismatched or missing files may also prevent gdbserver from debugging multi-threaded programs.

#### Remote Connection Commands

Debug using a TCP connection to `port` on `host`

    target remote host:port
    target remote [host]:port
    target remote tcp:host:port
    target remote tcp:[host]:port
    target remote tcp4:host:port
    target remote tcp6:host:port
    target remote tcp6:[host]:port
    target extended-remote host:port
    target extended-remote [host]:port
    target extended-remote tcp:host:port
    target extended-remote tcp:[host]:port
    target extended-remote tcp4:host:port
    target extended-remote tcp6:host:port
    target extended-remote tcp6:[host]:port

If your remote target is actually running on the **same machine** as your debugger session (e.g. a simulator for your target running on the same host), you can omit the hostname. For example, to connect to port 1234 on your local machine:

    target remote :1234

Debug using UDP packets to `port` on `host`

    target remote udp:host:port
    target remote udp:[host]:port
    target remote udp4:host:port
    target remote udp6:[host]:port
    target extended-remote udp:host:port
    target extended-remote udp:host:port
    target extended-remote udp:[host]:port
    target extended-remote udp4:host:port
    target extended-remote udp6:host:port
    target extended-remote udp6:[host]:port

When you have finished debugging the remote program, you can use the `detach` command to **release it from GDB control**. Detaching from the target normally resumes its execution, but the results will depend on your particular remote stub. After the `detach` command in `target remote` mode, GDB is free to connect to another target. In `target extended-remote` mode, GDB is still connected to the target.

The `disconnect` command closes the connection to the target, and the target is generally not resumed. It will wait for GDB (this instance or another one) to connect and continue debugging. After the `disconnect` command, GDB is again free to connect to another target.

### [20.2 Sending files to a remote system](https://sourceware.org/gdb/onlinedocs/gdb/File-Transfer.html)

Some remote targets offer the ability to transfer files over the same connection used to communicate with GDB.

### [20.3 Using the gdbserver Program](https://sourceware.org/gdb/onlinedocs/gdb/Server.html)

`gdbserver` is a control program for Unix-like systems, which allows you to connect your program with a remote GDB via `target remote` or `target extended-remote`—but without linking in the usual debugging stub.

GDB and `gdbserver` communicate via either a serial line or a TCP connection, using the standard GDB remote serial protocol.

#### Running `gdbserver`

Run `gdbserver` on the target system. You need a copy of the program you want to debug, including any libraries it requires. `gdbserver` does not need your program’s symbol table, so you can **strip the program** if necessary to save space. **GDB on the host system does all the symbol handling**.

To use the server, you must tell it how to communicate with GDB; the name of your program; and the arguments for your program. The usual syntax is:

    target> gdbserver comm program [ args … ]

comm is either a device name (to use a serial line), or a TCP hostname and portnumber, or - or stdio to use stdin/stdout of gdbserver. For example:

    target> gdbserver host:2345 emacs foo.txt

You can choose any number you want for the port number as long as it does not conflict with any TCP ports already in use on the target system. You must use the same port number with the host GDB `target remote command`.

#### Attaching to a Running Program

On some targets, `gdbserver` can also attach to running programs. This is accomplished via the `--attach` argument. The syntax is:

    target> gdbserver --attach comm pid

#### Connecting to `gdbserver`

The basic procedure for connecting to the remote target is:

- Run GDB on the host system.
- Make sure you have the necessary symbol files. Load symbols for your application using the `file` command before you connect. Use `set sysroot` to locate target libraries (unless your GDB was compiled with the correct sysroot using `--with-sysroot`).
- Connect to your target. For TCP connections, you must start up `gdbserver` prior to using the `target` command. Otherwise you may get an error whose text depends on the host system, but which usually looks something like ‘`Connection refused`’. Don’t use the `load` command in GDB when using target remote mode, since the program is already on the target.

### [20.4 Remote Configuration](https://sourceware.org/gdb/onlinedocs/gdb/Remote-Configuration.html)

### [20.5 Implementing a Remote Stub](https://sourceware.org/gdb/onlinedocs/gdb/Remote-Stub.html)

The stub files provided with GDB implement the target side of the communication protocol, and the GDB side is implemented in the GDB source file `remote.c`. Normally, you can simply allow these subroutines to communicate, and ignore the details. (If you’re implementing your own stub file, you can still ignore the details: start with one of the existing stub files. `sparc-stub.c` is the best organized, and therefore the easiest to read.)
