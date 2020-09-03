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
    - [3.1 Command Syntax](#31-command-syntax)
    - [3.2 Command Settings](#32-command-settings)
    - [3.3 Command Completion](#33-command-completion)
    - [3.4 Command options](#34-command-options)
    - [3.5 Getting Help](#35-getting-help)
  - [4 Running Programs Under GDB](#4-running-programs-under-gdb)
    - [4.1 Compiling for Debugging](#41-compiling-for-debugging)
    - [4.2 Starting your Program](#42-starting-your-program)
    - [4.3 Your Program’s Arguments](#43-your-programs-arguments)
    - [4.4 Your Program’s Environment](#44-your-programs-environment)
    - [4.5 Your Program’s Working Directory](#45-your-programs-working-directory)
    - [4.6 Your Program’s Input and Output](#46-your-programs-input-and-output)
    - [4.7 Debugging an Already-running Process](#47-debugging-an-already-running-process)
    - [4.8 Killing the Child Process](#48-killing-the-child-process)
    - [4.9 Debugging Multiple Inferiors and Programs](#49-debugging-multiple-inferiors-and-programs)
    - [4.10 Debugging Programs with Multiple Threads](#410-debugging-programs-with-multiple-threads)
    - [[4.11 Debugging Forks]](#411-debugging-forks)
    - [4.12 Setting a Bookmark to Return to Later](#412-setting-a-bookmark-to-return-to-later)
      - [4.12.1 A Non-obvious Benefit of Using Checkpoints](#4121-a-non-obvious-benefit-of-using-checkpoints)
  - [5 Stopping and Continuing](#5-stopping-and-continuing)
    - [5.1 Breakpoints, Watchpoints, and Catchpoints](#51-breakpoints-watchpoints-and-catchpoints)
      - [5.1.1 Setting Breakpoints](#511-setting-breakpoints)
      - [5.1.2 Setting Watchpoints](#512-setting-watchpoints)
      - [5.1.3 Setting Catchpoints](#513-setting-catchpoints)
      - [5.1.4 Deleting Breakpoints](#514-deleting-breakpoints)
      - [5.1.5 Disabling Breakpoints](#515-disabling-breakpoints)
      - [5.1.6 Break Conditions](#516-break-conditions)
      - [5.1.7 Breakpoint Command Lists](#517-breakpoint-command-lists)
      - [5.1.8 Dynamic Printf](#518-dynamic-printf)
      - [5.1.9 How to save breakpoints to a file](#519-how-to-save-breakpoints-to-a-file)
      - [5.1.10 Static Probe Points](#5110-static-probe-points)
      - [5.1.11 “Cannot insert breakpoints”](#5111-cannot-insert-breakpoints)
      - [5.1.12 “Breakpoint address adjusted...”](#5112-breakpoint-address-adjusted)
    - [5.2 Continuing and Stepping](#52-continuing-and-stepping)
    - [5.3 Skipping Over Functions and Files](#53-skipping-over-functions-and-files)
    - [5.4 Signals](#54-signals)
    - [5.5 Stopping and Starting Multi-thread Programs](#55-stopping-and-starting-multi-thread-programs)
      - [5.5.1 All-Stop Mode](#551-all-stop-mode)
      - [5.5.2 Non-Stop Mode](#552-non-stop-mode)
      - [5.5.3 Background Execution](#553-background-execution)
      - [5.5.4 Thread-Specific Breakpoints](#554-thread-specific-breakpoints)
      - [5.5.5 Interrupted System Calls](#555-interrupted-system-calls)
      - [5.5.6 Observer Mode](#556-observer-mode)
  - [6 Running programs backward](#6-running-programs-backward)
  - [7 Recording Inferior’s Execution and Replaying It](#7-recording-inferiors-execution-and-replaying-it)
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

You can abbreviate a GDB command to the first few letters of the command name, if that abbreviation is unambiguous; and you can repeat certain GDB commands by typing just RET. You can also use the TAB key to get GDB to fill out the rest of a word in a command (or to show you the alternatives available, if there is more than one possibility).

### [3.1 Command Syntax](https://sourceware.org/gdb/onlinedocs/gdb/Command-Syntax.html#Command-Syntax)

A GDB command is a single line of input. There is no limit on how long it can be. It starts with a command name, which is followed by arguments whose meaning depends on the command name.

GDB command names may always be truncated if that abbreviation is unambiguous. Other possible command abbreviations are listed in the documentation for individual commands. In some cases, even ambiguous abbreviations are allowed; for example, `s` is specially defined as equivalent to step even though there are other commands whose names start with s. **You can test abbreviations by using them as arguments to the help command**.

A blank line as input to GDB (typing just RET) means to repeat the previous command. Certain commands (for example, run) will not repeat this way; these are commands whose unintentional repetition might cause trouble and which you are unlikely to want to repeat. User-defined commands can disable this feature; see [dont-repeat](https://sourceware.org/gdb/onlinedocs/gdb/Command-Syntax.html#Command-Syntax).

The `list` and `x` commands, when you repeat them with RET, construct new arguments rather than repeating exactly as typed. This permits easy scanning of source or memory.

GDB can also use RET in another way: to partition lengthy output, in a way similar to the common utility more (see [Screen Size](https://sourceware.org/gdb/onlinedocs/gdb/Command-Syntax.html#Command-Syntax)). Since it is easy to press one RET too many in this situation, GDB disables command repetition after any command that generates this sort of display.

Any text from a # to the end of the line is a comment; it does nothing. This is useful mainly in command files (see [Command Files](https://sourceware.org/gdb/onlinedocs/gdb/Command-Files.html#Command-Files)).

The `Ctrl-o` binding is useful for repeating a complex sequence of commands. This command accepts the current line, like RET, and then fetches the next line relative to the current line from the history for editing. 

### [3.2 Command Settings](https://sourceware.org/gdb/onlinedocs/gdb/Command-Settings.html#Command-Settings)

Many commands change their behavior according to command-specific variables or settings. These settings can be changed with the `set` subcommands. For example, the `print` command (see [Examining Data](https://sourceware.org/gdb/onlinedocs/gdb/Data.html#Data)) prints arrays differently depending on settings changeable with the commands `set print elements NUMBER-OF-ELEMENTS` and `set print array-indexes`, among others.

You can change these settings to your preference in the gdbinit files loaded at GDB startup. See [Startup](https://sourceware.org/gdb/onlinedocs/gdb/Startup.html#Startup).

The settings can also be changed interactively during the debugging session. For example, to change the limit of array elements to print, you can do the following:

    (GDB) set print elements 10
    (GDB) print some_array
    $1 = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90...}

The above set print elements 10 command changes the number of elements to print from the default of 200 to 10. If you only intend this limit of 10 to be used for printing some_array, then you must restore the limit back to 200, with set print elements 200.

Some commands allow overriding settings with command options. For example, the `print` command supports a number of options that allow overriding relevant global print settings as set by `set print` subcommands. See [print options](https://sourceware.org/gdb/onlinedocs/gdb/Data.html#print-options). The example above could be rewritten as:

    (GDB) print -elements 10 -- some_array
    $1 = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90...}

Alternatively, you can use the `with` command to change a setting temporarily, for the duration of a command invocation.

    with setting [value] [-- command]
    w setting [value] [-- command]

To change several settings for the same command, you can nest `with` commands. For example, `with language ada -- with print elements 10` temporarily changes the language to Ada and sets a limit of 10 elements to print for arrays and strings.

### [3.3 Command Completion](https://sourceware.org/gdb/onlinedocs/gdb/Completion.html#Completion)

GDB can fill in the rest of a word in a command for you, if there is only one possibility; it can also show you what the valid possibilities are for the next word in a command, at any time. This works for GDB commands, GDB subcommands, command options, and the names of symbols in your program.

### [3.4 Command options](https://sourceware.org/gdb/onlinedocs/gdb/Command-Options.html#Command-Options)

Some commands accept options starting with a leading dash. For example, print -pretty. Similarly to command names, you can abbreviate a GDB option to the first few letters of the option name, if that abbreviation is unambiguous, and you can also use the TAB key to get GDB to fill out the rest of a word in an option (or to show you the alternatives available, if there is more than one possibility).

Some commands take raw input as argument. For example, the print command processes arbitrary expressions in any of the languages supported by GDB. With such commands, because raw input may start with a leading dash that would be confused with an option or any of its abbreviations, e.g. print -p (short for print -pretty or printing negative p?), if you specify any command option, then you must use a double-dash (--) delimiter to indicate the end of options.

### [3.5 Getting Help](https://sourceware.org/gdb/onlinedocs/gdb/Help.html#Help)

You can always ask GDB itself for information on its commands, using the command `help`.

In addition to help, you can use the GDB commands info and show to inquire about the state of your program, or the state of GDB itself. Each command supports many topics of inquiry; this manual introduces each of them in the appropriate context. The listings under info and under show in the Command, Variable, and Function Index point to all the sub-commands. See [Command and Variable Index](https://sourceware.org/gdb/onlinedocs/gdb/Command-and-Variable-Index.html#Command-and-Variable-Index).

## [4 Running Programs Under GDB](https://sourceware.org/gdb/onlinedocs/gdb/Running.html#Running)

When you run a program under GDB, you must first **generate debugging information** when you compile it.

### [4.1 Compiling for Debugging](https://sourceware.org/gdb/onlinedocs/gdb/Compilation.html#Compilation)

In order to debug a program effectively, you need to generate debugging information when you compile it. This debugging information is stored in the object file; it describes the data type of each variable or function and the correspondence between source line numbers and addresses in the executable code.

To request debugging information, specify the ‘`-g`’ option when you run the compiler.

Programs that are to be shipped to your customers are compiled with optimizations, using the ‘`-O`’ compiler option. However, some compilers are unable to handle the ‘`-g`’ and ‘`-O`’ options together. Using those compilers, you cannot generate optimized executables containing debugging information.

GCC, the GNU C/C++ compiler, supports ‘`-g`’ with or without ‘`-O`’, making it possible to **debug optimized code**. We recommend that you **always use ‘`-g`’ whenever you compile a program**. You may think your program is correct, but there is no sense in pushing your luck. For more information, see [Optimized Code](https://sourceware.org/gdb/onlinedocs/gdb/Optimized-Code.html#Optimized-Code).

### [4.2 Starting your Program](https://sourceware.org/gdb/onlinedocs/gdb/Starting.html#Starting)

`run`
`r`

Use the run command to start your program under GDB. You must first specify the program name with an argument to GDB (see [Getting In and Out of GDB](https://sourceware.org/gdb/onlinedocs/gdb/Invocation.html#Invocation)), or by using the `file` or `exec-file` command (see [Commands to Specify Files](https://sourceware.org/gdb/onlinedocs/gdb/Files.html#Files)).

If you are running your program in an execution environment that supports processes, run creates an inferior process and makes that process run your program. In some environments without processes, run jumps to the start of your program. Other targets, like ‘remote’, are always running. If you get an error message like this one:

The "remote" target does not support "run".
Try "help target" or "continue".

then use `continue` to run your program. You may need load first (see [load](https://sourceware.org/gdb/onlinedocs/gdb/Target-Commands.html#load)).

The execution of a program is affected by certain information it receives from its superior. GDB provides ways to specify this information, which you must do before starting your program. (You can change it after starting your program, but such changes **only affect your program the next time** you start it.) This information may be divided into four categories:

- The `arguments`.

   Specify the arguments to give your program as the arguments of the run command. If a shell is available on your target, the shell is used to pass the arguments, so that you may use normal conventions (such as wildcard expansion or variable substitution) in describing the arguments. In Unix systems, you can control which shell is used with the `SHELL` environment variable. If you do not define `SHELL`, GDB uses the default shell (`/bin/sh`). You can disable use of any shell with the `set startup-with-shell` command (see below for details).

- The `environment`.

   Your program normally inherits its environment from GDB, but you can use the GDB commands **set** environment and **unset** environment to change parts of the environment that affect your program. See [Your Program’s Environment](https://sourceware.org/gdb/onlinedocs/gdb/Environment.html#Environment).

- The `working directory`.

   You can set your program’s working directory with the command `set cwd`. If you do not set any working directory with this command, your program will inherit **GDB’s working directory if native debugging**, or the **remote server’s working directory** if remote debugging. See [Your Program’s Working Directory](https://sourceware.org/gdb/onlinedocs/gdb/Working-Directory.html#Working-Directory).

- The `standard input and output`.

   Your program normally uses the same device for standard input and standard output as GDB is using. You can redirect input and output in the run command line, or you can use the `tty` command to set a different device for your program. See [Your Program’s Input and Output](https://sourceware.org/gdb/onlinedocs/gdb/Input_002fOutput.html#Input_002fOutput).

   Warning: While input and output redirection work, you cannot use pipes to pass the output of the program you are debugging to another program; if you attempt this, GDB is likely to wind up debugging the wrong program.

When you issue the run command, your program begins to execute immediately. See [Stopping and Continuing](https://sourceware.org/gdb/onlinedocs/gdb/Stopping.html#Stopping), for discussion of how to arrange for your program to stop. Once your program has stopped, you may call functions in your program, using the print or call commands. See [Examining Data](https://sourceware.org/gdb/onlinedocs/gdb/Data.html#Data).

If the modification time of your symbol file has changed since the last time GDB read its symbols, GDB discards its symbol table, and reads it again. When it does this, GDB tries to retain your current breakpoints.

### [4.3 Your Program’s Arguments](https://sourceware.org/gdb/onlinedocs/gdb/Arguments.html#Arguments)

`run` with no arguments uses the same arguments used by the previous `run`, or those set by the `set args` command.

- `set args`

   Specify the arguments to be used the next time your program is run. If `set args` has no arguments, `run` executes your program with no arguments. Once you have run your program with arguments, using `set args` before the next `run` is the only way to run it again without arguments.

- `show args`

   Show the arguments to give your program when it is started.

### [4.4 Your Program’s Environment](https://sourceware.org/gdb/onlinedocs/gdb/Environment.html#Environment)

- `path directory`

- `show paths`

- `show environment [varname]`

- `set environment varname [=value]`

- `unset environment varname`

### [4.5 Your Program’s Working Directory](https://sourceware.org/gdb/onlinedocs/gdb/Working-Directory.html#Working-Directory)

- `set cwd [directory]`

- `show cwd`

- `cd [directory]`

- `pwd`

It is generally impossible to find the current working directory of the process being debugged (since a program can change its directory during its run). If you work on a system where GDB supports the info proc command (see [Process Information](https://sourceware.org/gdb/onlinedocs/gdb/Process-Information.html#Process-Information)), you can use the info proc command to find out the current working directory of the debuggee.

### [4.6 Your Program’s Input and Output](https://sourceware.org/gdb/onlinedocs/gdb/Input_002fOutput.html#Input_002fOutput)

- `info terminal`

- `run > outfile`

- `tty /dev/ttyb`

- `set inferior-tty [ tty ]`

- `show inferior-tty`

### [4.7 Debugging an Already-running Process](https://sourceware.org/gdb/onlinedocs/gdb/Attach.html#Attach)

- `attach process-id`

- `detach`

### [4.8 Killing the Child Process](https://sourceware.org/gdb/onlinedocs/gdb/Kill-Process.html#Kill-Process)

- `kill`

  Kill the child process in which your program is running under GDB.

### [4.9 Debugging Multiple Inferiors and Programs](https://sourceware.org/gdb/onlinedocs/gdb/Inferiors-and-Programs.html#Inferiors-and-Programs)

GDB lets you run and **debug multiple programs** in a single session. In addition, GDB on some systems may let you run several programs simultaneously (otherwise you have to exit from one before starting another). In the most general case, you can have multiple threads of execution in each of multiple processes, launched from multiple executables.

GDB represents the state of each program execution with an object called an **`inferior`**. An inferior typically corresponds to a process, but is more general and applies also to targets that do not have processes. Inferiors may be created before a process runs, and may be retained after a process exits. Inferiors have unique identifiers that are different from process ids. Usually each inferior will also have its own distinct address space, although some embedded targets may have several inferiors running in different parts of a single address space. Each inferior may in turn have multiple threads running in it.

- `info inferiors`

  Print a list of all inferiors currently being managed by GDB. By default all inferiors are printed, but the argument id… – a space separated list of inferior numbers – can be used to limit the display to just the requested inferiors.

- inferior infno

  Make inferior number infno the current inferior. The argument infno is the inferior number assigned by GDB, as shown in the first field of the ‘info inferiors’ display.

You can get multiple executables into a debugging session via the `add-inferior` and `clone-inferior` commands. On some systems GDB can add inferiors to the debug session automatically by following calls to `fork` and `exec`. To remove inferiors from the debugging session use the `remove-inferiors` command.

### [4.10 Debugging Programs with Multiple Threads](https://sourceware.org/gdb/onlinedocs/gdb/Threads.html#Threads)

In some operating systems, such as GNU/Linux and Solaris, a single program may have more than one thread of execution. The precise semantics of threads differ from one operating system to another, but in general the threads of a single program are akin to multiple processes—except that they share one address space (that is, they can all examine and modify the same variables). On the other hand, each thread has its own registers and execution stack, and perhaps private memory.

- automatic notification of new threads

- ‘`thread thread-id`’, a command to switch among threads

- ‘`info threads`’, a command to inquire about existing threads

- ‘`thread apply [thread-id-list | all] args`’, a command to apply a command to a list of threads

- thread-specific breakpoints

- ‘`set print thread-events`’, which controls printing of messages on thread start and exit.

- ‘`set libthread-db-search-path path`’, which lets the user specify which `libthread_db` to use if the default choice isn’t compatible with the program.

The GDB thread debugging facility allows you to observe all threads while your program runs—but whenever GDB takes control, one thread in particular is always the focus of debugging. This thread is called the `current thread`. Debugging commands show program information from the perspective of the current thread.

For debugging purposes, GDB associates its own thread number —always a single integer—with each thread of an inferior. This number is unique between all threads of an inferior, but not unique between threads of different inferiors.

You can refer to a given thread in an inferior using the qualified inferior-num.thread-num syntax, also known as qualified thread ID, with inferior-num being the inferior number and thread-num being the thread number of the given inferior. For example, thread 2.3 refers to thread number 3 of inferior 2. If you omit inferior-num (e.g., thread 3), then GDB infers you’re referring to a thread of the current inferior.

### [4.11 Debugging Forks]

On most systems, GDB has no special support for debugging programs which create additional processes using the fork function. When a program forks, GDB will continue to debug the parent process and the child process will run unimpeded. If you have set a breakpoint in any code which the child then executes, the child will get a SIGTRAP signal which (unless it catches the signal) will cause it to terminate.

However, if you want to debug the child process there is a workaround which isn’t too painful. Put a call to sleep in the code which the child process executes after the fork. It may be useful to sleep only if a certain environment variable is set, or a certain file exists, so that the delay need not occur when you don’t want to run GDB on the child. While the child is sleeping, use the ps program to get its process ID. Then tell GDB (a new invocation of GDB if you are also debugging the parent process) to attach to the child process (see Attach). From that point on you can debug the child process just like any other process which you attached to.

On some systems, GDB provides support for debugging programs that create additional processes using the fork or vfork functions. On GNU/Linux platforms, this feature is supported with kernel version 2.5.46 and later.

### [4.12 Setting a Bookmark to Return to Later](https://sourceware.org/gdb/onlinedocs/gdb/Checkpoint_002fRestart.html#Checkpoint_002fRestart)

On certain operating systems, GDB is able to save a snapshot of a program’s state, called a checkpoint, and come back to it later.

Returning to a checkpoint effectively undoes everything that has happened in the program since the checkpoint was saved. This includes changes in memory, registers, and even (within some limits) system state. Effectively, it is like going back in time to the moment when the checkpoint was saved.

To use the checkpoint/restart method of debugging:

- `checkpoint`

- `info checkpoints`

- `restart checkpoint-id`

- `delete checkpoint checkpoint-id`

#### 4.12.1 A Non-obvious Benefit of Using Checkpoints

On some systems such as GNU/Linux, address space randomization is performed on new processes for security reasons. This makes it difficult or impossible to set a breakpoint, or watchpoint, on an absolute address if you have to restart the program, since the absolute location of a symbol will change from one execution to the next.

A checkpoint, however, is an identical copy of a process. Therefore if you create a checkpoint at (eg.) the start of main, and simply return to that checkpoint instead of restarting the process, you can avoid the effects of address randomization and your symbols will all stay in the same place.

## [5 Stopping and Continuing](https://sourceware.org/gdb/onlinedocs/gdb/Stopping.html#Stopping)

The principal purposes of using a debugger are so that you can stop your program before it terminates; or so that, if your program runs into trouble, you can investigate and find out why.

Inside GDB, your program may stop for any of several reasons, such as a signal, a breakpoint, or reaching a new line after a GDB command such as step. You may then examine and change variables, set new breakpoints or remove old ones, and then continue execution. Usually, the messages shown by GDB provide ample explanation of the status of your program—but you can also explicitly request this information at any time.

`info program`

Display information about the status of your program: whether it is running or not, what process it is, and why it stopped.

### [5.1 Breakpoints, Watchpoints, and Catchpoints](https://sourceware.org/gdb/onlinedocs/gdb/Breakpoints.html#Breakpoints)

A breakpoint makes your program stop whenever a certain point in the program is reached. For each breakpoint, you can add conditions to control in finer detail whether your program stops. You can set breakpoints with the break command and its variants (see [Setting Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Set-Breaks.html#Set-Breaks)), to specify the place where your program should stop by line number, function name or exact address in the program.

On some systems, you can set breakpoints in shared libraries before the executable is run.

A **watchpoint** is a special breakpoint that stops your program when the value of an expression changes. The expression may be a value of a variable, or it could involve values of one or more variables combined by operators, such as ‘a + b’. This is sometimes called **data breakpoints**. You must use a different command to set watchpoints (see [Setting Watchpoints](https://sourceware.org/gdb/onlinedocs/gdb/Set-Watchpoints.html#Set-Watchpoints)), but aside from that, you can manage a watchpoint like any other breakpoint: you enable, disable, and delete both breakpoints and watchpoints using the same commands.

You can arrange to have values from your program displayed automatically whenever GDB stops at a breakpoint. See [Automatic Display](https://sourceware.org/gdb/onlinedocs/gdb/Auto-Display.html#Auto-Display).

A catchpoint is another special breakpoint that stops your program when a certain kind of event occurs, such as the throwing of a C++ exception or the loading of a library. As with watchpoints, you use a different command to set a catchpoint (see [Setting Catchpoints](https://sourceware.org/gdb/onlinedocs/gdb/Set-Catchpoints.html#Set-Catchpoints)), but aside from that, you can manage a catchpoint like any other breakpoint. (To stop when your program receives a signal, use the handle command; see [Signals](https://sourceware.org/gdb/onlinedocs/gdb/Signals.html#Signals).)

GDB assigns a **number** to each breakpoint, watchpoint, or catchpoint when you create it; these numbers are successive integers starting with one. In many of the commands for controlling various features of breakpoints you use the breakpoint number to say which breakpoint you want to change. Each breakpoint may be enabled or disabled; if disabled, it has no effect on your program until you enable it again.

Some GDB commands accept a space-separated list of breakpoints on which to operate. A list element can be either a single breakpoint number, like ‘5’, or a range of such numbers, like ‘5-7’. When a breakpoint list is given to a command, all breakpoints in that list are operated on.

#### [5.1.1 Setting Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Set-Breaks.html#Set-Breaks)

Breakpoints are set with the break command (abbreviated b). The debugger convenience variable ‘$bpnum’ records the number of the breakpoint you’ve set most recently; see [Convenience Variables](https://sourceware.org/gdb/onlinedocs/gdb/Convenience-Vars.html#Convenience-Vars), for a discussion of what you can do with convenience variables.

- break location

  Set a breakpoint at the given location, which can specify a **function name**, a **line number**, or an **address of an instruction**. (See [Specify Location](https://sourceware.org/gdb/onlinedocs/gdb/Specify-Location.html#Specify-Location), for a list of all the possible ways to specify a location.) The breakpoint will stop your program just before it executes any of the code in the specified location.

  When using source languages that permit overloading of symbols, such as C++, a function name may refer to more than one possible place to break. See [Ambiguous Expressions](https://sourceware.org/gdb/onlinedocs/gdb/Ambiguous-Expressions.html#Ambiguous-Expressions), for a discussion of that situation.

  It is also possible to insert a breakpoint that will stop the program only if a specific thread (see [Thread-Specific Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Thread_002dSpecific-Breakpoints.html#Thread_002dSpecific-Breakpoints)) or a specific task (see [Ada Tasks](https://sourceware.org/gdb/onlinedocs/gdb/Ada-Tasks.html#Ada-Tasks)) hits that breakpoint.

- `break`

  When called without any arguments, break sets a breakpoint at the next instruction to be executed in the selected stack frame (see Examining the Stack). In any selected frame but the innermost, this makes your program stop as soon as control returns to that frame. This is similar to the effect of a finish command in the frame inside the selected frame—except that finish does not leave an active breakpoint. If you use break without an argument in the innermost frame, GDB stops the next time it reaches the current location; this may be useful inside loops.

  GDB normally ignores breakpoints when it resumes execution, until at least one instruction has been executed. If it did not do this, you would be unable to proceed past a breakpoint without first disabling the breakpoint. This rule applies whether or not the breakpoint already existed when your program stopped.

- `break … if cond`

  Set a breakpoint with condition cond; evaluate the expression cond each time the breakpoint is reached, and stop only if the value is nonzero—that is, if cond evaluates as true. ‘…’ stands for one of the possible arguments described above (or no argument) specifying where to break. See [Break Conditions](https://sourceware.org/gdb/onlinedocs/gdb/Conditions.html#Conditions), for more information on breakpoint conditions.

- `tbreak args`

  Set a breakpoint enabled only for one stop. The args are the same as for the break command, and the breakpoint is set in the same way, but the breakpoint is automatically deleted after the first time your program stops there. See [Disabling Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Disabling.html#Disabling).

- `hbreak args`

  Set a hardware-assisted breakpoint. The args are the same as for the break command and the breakpoint is set in the same way, but the breakpoint requires hardware support and some target hardware may not have this support.

- `thbreak args`

  Set a hardware-assisted breakpoint enabled only for one stop.

- `rbreak regex`

  Set breakpoints on all functions matching the regular expression regex. This command sets an unconditional breakpoint on all matches, printing a list of all breakpoints it set. Once these breakpoints are set, they are treated just like the breakpoints set with the break command. You can delete them, disable them, or make them conditional the same way as any other breakpoint.

- `rbreak file:regex`

  If rbreak is called with a filename qualification, it limits the search for functions matching the given regular expression to the specified file.

- `info breakpoints [list…]`  
  `info break [list…]`

  Print a table of all breakpoints, watchpoints, and catchpoints set and not deleted. Optional argument n means print information only about the specified breakpoint(s) (or watchpoint(s) or catchpoint(s)). For each breakpoint, following columns are printed: 

It’s quite common to have a **breakpoint inside a shared library**. Shared libraries can be loaded and unloaded explicitly, and possibly repeatedly, as the program is executed. To support this use case, GDB **updates breakpoint locations** whenever any shared library is loaded or unloaded. Typically, you would set a breakpoint in a shared library at the beginning of your debugging session, when the library is not loaded, and when the symbols from the library are not available. When you try to set breakpoint, GDB will ask you if you want to set a so called **pending breakpoint**—breakpoint whose address is not yet resolved.

After the program is run, whenever a new shared library is loaded, GDB reevaluates all the breakpoints. When a newly loaded shared library contains the symbol or line referred to by some pending breakpoint, that breakpoint is resolved and becomes an ordinary breakpoint. When a library is unloaded, all breakpoints that refer to its symbols or source lines become pending again.

This logic works for breakpoints with multiple locations, too. For example, if you have a breakpoint in a C++ template function, and a newly loaded shared library has an instantiation of that template, a new location is added to the list of locations for the breakpoint.

Except for having unresolved address, pending breakpoints do not differ from regular breakpoints. You can set conditions or commands, enable and disable them and perform other breakpoint operations.

#### [5.1.2 Setting Watchpoints](https://sourceware.org/gdb/onlinedocs/gdb/Set-Watchpoints.html#Set-Watchpoints)

You can use a watchpoint to stop execution whenever the value of an expression changes, without having to predict a particular place where this may happen. (This is sometimes called a data breakpoint.) The expression may be as simple as the value of a single variable, or as complex as many variables combined by operators. Examples include:

- A reference to the value of a single variable.

- An address cast to an appropriate data type. For example, ‘`*(int *)0x12345678`’ will watch a 4-byte region at the specified address (assuming an int occupies 4 bytes).

- An arbitrarily complex expression, such as ‘`a*b + c/d`’. The expression can use any operators valid in the program’s native language (see [Languages](https://sourceware.org/gdb/onlinedocs/gdb/Languages.html#Languages)).

#### [5.1.3 Setting Catchpoints](https://sourceware.org/gdb/onlinedocs/gdb/Set-Catchpoints.html#Set-Catchpoints)

You can use catchpoints to cause the debugger to stop for certain kinds of program events, such as C++ exceptions or the loading of a shared library. Use the catch command to set a catchpoint.

#### [5.1.4 Deleting Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Delete-Breaks.html#Delete-Breaks)

- `clear`

- `clear location`

- `delete [breakpoints] [list…]`

#### [5.1.5 Disabling Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Disabling.html#Disabling)

- `disable [breakpoints] [list…]`

- `enable [breakpoints] [list…]`

- `enable [breakpoints] once list…`

- `enable [breakpoints] count count list…`

- `enable [breakpoints] delete list…`

#### [5.1.6 Break Conditions](https://sourceware.org/gdb/onlinedocs/gdb/Conditions.html#Conditions)

You can give any breakpoint (or watchpoint or catchpoint) a series of commands to execute when your program stops due to that breakpoint. For example, you might want to print the values of certain expressions, or enable other breakpoints.

#### [5.1.7 Breakpoint Command Lists](https://sourceware.org/gdb/onlinedocs/gdb/Break-Commands.html#Break-Commands)

You can give any breakpoint (or watchpoint or catchpoint) a series of commands to execute when your program stops due to that breakpoint.

#### [5.1.8 Dynamic Printf](https://sourceware.org/gdb/onlinedocs/gdb/Dynamic-Printf.html#Dynamic-Printf)

The dynamic printf command dprintf combines a breakpoint with formatted printing of your program’s data to give you the effect of inserting printf calls into your program on-the-fly, without having to recompile it.

#### [5.1.9 How to save breakpoints to a file](https://sourceware.org/gdb/onlinedocs/gdb/Save-Breakpoints.html#Save-Breakpoints)

To save breakpoint definitions to a file use the save breakpoints command.

#### [5.1.10 Static Probe Points](https://sourceware.org/gdb/onlinedocs/gdb/Static-Probe-Points.html#Static-Probe-Points)

GDB supports SDT probes in the code. SDT stands for Statically Defined Tracing, and the probes are designed to have a tiny runtime code and data footprint, and no dynamic relocations.

Currently, the following types of probes are supported on ELF-compatible systems:

- [SystemTap](http://sourceware.org/systemtap/) SDT probes. SystemTap probes are usable from assembly, C and C++ languages.

- [DTrace](http://oss.oracle.com/projects/DTrace) USDT probes. DTrace probes are usable from C and C++ languages.

#### [5.1.11 “Cannot insert breakpoints”](https://sourceware.org/gdb/onlinedocs/gdb/Error-in-Breakpoints.html#Error-in-Breakpoints)

If you request too many active hardware-assisted breakpoints and watchpoints, you will see this error message:

Stopped; cannot insert breakpoints.  
You may have requested too many hardware breakpoints and watchpoints.

This message is printed when you attempt to resume the program, since only then GDB knows exactly how many hardware breakpoints and watchpoints it needs to insert.

When this message is printed, you need to disable or remove some of the hardware-assisted breakpoints and watchpoints, and then continue.

#### [5.1.12 “Breakpoint address adjusted...”](https://sourceware.org/gdb/onlinedocs/gdb/Breakpoint_002drelated-Warnings.html#Breakpoint_002drelated-Warnings)

Some processor architectures place constraints on the addresses at which breakpoints may be placed. For architectures thus constrained, GDB will attempt to adjust the breakpoint’s address to comply with the constraints dictated by the architecture.

### [5.2 Continuing and Stepping](https://sourceware.org/gdb/onlinedocs/gdb/Continuing-and-Stepping.html#Continuing-and-Stepping)

**Continuing** means resuming program execution until your program completes normally. In contrast, **stepping** means executing just one more “step” of your program, where “step” may mean either one line of source code, or one machine instruction (depending on what particular command you use). Either when continuing or when stepping, your program may stop even sooner, due to a breakpoint or a signal. (If it stops due to a signal, you may want to use handle, or use ‘signal 0’ to resume execution (see [Signals](https://sourceware.org/gdb/onlinedocs/gdb/Signals.html#Signals)), or you may step into the signal’s handler (see [stepping and signal handlers](https://sourceware.org/gdb/onlinedocs/gdb/Signals.html#stepping-and-signal-handlers)).)

- `continue [ignore-count]`  
  `c [ignore-count]`  
  `fg [ignore-count]`

  Resume program execution, at the address where your program last stopped; any breakpoints set at that address are bypassed. The optional argument ignore-count allows you to specify a further number of times to ignore a breakpoint at this location; its effect is like that of ignore (see [Break Conditions](https://sourceware.org/gdb/onlinedocs/gdb/Conditions.html#Conditions)).

  The argument ignore-count is meaningful only when your program stopped due to a breakpoint. At other times, the argument to continue is ignored.

  The synonyms c and fg (for foreground, as the debugged program is deemed to be the foreground program) are provided purely for convenience, and have exactly the same behavior as continue.

To resume execution at a different place, you can use return (see [Returning from a Function](https://sourceware.org/gdb/onlinedocs/gdb/Returning.html#Returning)) to go back to the calling function; or jump (see [Continuing at a Different Address](https://sourceware.org/gdb/onlinedocs/gdb/Jumping.html#Jumping)) to go to an arbitrary location in your program.

A typical technique for using stepping is to set a breakpoint (see [Breakpoints; Watchpoints; and Catchpoints](https://sourceware.org/gdb/onlinedocs/gdb/Breakpoints.html#Breakpoints)) at the beginning of the function or the section of your program where a problem is believed to lie, run your program until it stops at that breakpoint, and then step through the suspect area, examining the variables that are interesting, until you see the problem happen.

- `step`

  Continue running your program until control reaches a different source line, then stop it and return control to GDB. This command is abbreviated `s`.

  Warning: If you use the step command while control is within a function that was compiled without debugging information, execution proceeds until control reaches a function that does have debugging information. Likewise, it will not step into a function which is compiled without debugging information. To step through functions without debugging information, use the `stepi` command, described below.

  The step command only stops at the first instruction of a source line. This prevents the multiple stops that could otherwise occur in switch statements, for loops, etc. step continues to stop if a function that has debugging information is called within the line. In other words, step steps inside any functions called within the line.

  Also, the step command only enters a function if there is line number information for the function. Otherwise it acts like the next command. This avoids problems when using cc -gl on MIPS machines. Previously, step entered subroutines if there was any debugging information about the routine.

- `step count`

  Continue running as in step, but do so count times. If a breakpoint is reached, or a signal not related to stepping occurs before count steps, stepping stops right away.

- `next [count]`

- `set step-mode`  
  `set step-mode on`

- `set step-mode off`

- `show step-mode`

- `finish`

- `set print finish [on|off]`
  `show print finish`

- `until`  
  `u`

- `until location`  
  `u location`

- `advance location`

- `stepi`  
  `stepi arg`  
  `si`

- `nexti`  
  `nexti arg`  
  `ni`

- `set range-stepping`  
  `show range-stepping`

### [5.3 Skipping Over Functions and Files](https://sourceware.org/gdb/onlinedocs/gdb/Skipping-Over-Functions-and-Files.html#Skipping-Over-Functions-and-Files)

The program you are debugging may contain some functions which are uninteresting to debug. The skip command lets you tell GDB to skip a function, all functions in a file or a particular function in a particular file when stepping.

### [5.4 Signals](https://sourceware.org/gdb/onlinedocs/gdb/Signals.html#Signals)

GDB has the ability to detect any occurrence of a signal in your program. You can tell GDB in advance what to do for each kind of signal.

Normally, GDB is set up to let the non-erroneous signals like SIGALRM be silently passed to your program (so as not to interfere with their role in the program’s functioning) but to stop your program immediately whenever an error signal happens. You can change these settings with the handle command.

### [5.5 Stopping and Starting Multi-thread Programs](https://sourceware.org/gdb/onlinedocs/gdb/Thread-Stops.html#Thread-Stops)

GDB supports debugging programs with multiple threads (see [Debugging Programs with Multiple Threads](https://sourceware.org/gdb/onlinedocs/gdb/Thread-Stops.html#Thread-Stops)). There are two modes of controlling execution of your program within the debugger. In the default mode, referred to as all-stop mode, when any thread in your program stops (for example, at a breakpoint or while being stepped), all other threads in the program are also stopped by GDB. On some targets, GDB also supports non-stop mode, in which other threads can continue to run freely while you examine the stopped thread in the debugger.

#### [5.5.1 All-Stop Mode](https://sourceware.org/gdb/onlinedocs/gdb/All_002dStop-Mode.html#All_002dStop-Mode)

In all-stop mode, whenever your program stops under GDB for any reason, all threads of execution stop, not just the current thread. This allows you to examine the overall state of the program, including switching between threads, without worrying that things may change underfoot.

Conversely, whenever you restart the program, all threads start executing. This is true even when single-stepping with commands like step or next.

In particular, GDB cannot single-step all threads in lockstep. Since thread scheduling is up to your debugging target’s operating system (not controlled by GDB), other threads may execute more than one statement while the current thread completes a single step. Moreover, in general other threads stop in the middle of a statement, rather than at a clean statement boundary, when the program stops.

You might even find your program stopped in another thread after continuing or even single-stepping. This happens whenever some other thread runs into a breakpoint, a signal, or an exception before the first thread completes whatever you requested.

Whenever GDB stops your program, due to a breakpoint or a signal, it automatically selects the thread where that breakpoint or signal happened. GDB alerts you to the context switch with a message such as ‘[Switching to Thread n]’ to identify the thread.

On some OSes, you can modify GDB’s default behavior by locking the OS scheduler to allow only a single thread to run.

#### [5.5.2 Non-Stop Mode](https://sourceware.org/gdb/onlinedocs/gdb/Non_002dStop-Mode.html#Non_002dStop-Mode)

For some multi-threaded targets, GDB supports an optional mode of operation in which you can examine stopped program threads in the debugger while other threads continue to execute freely. This minimizes intrusion when debugging live systems, such as programs where some threads have real-time constraints or must continue to respond to external events. This is referred to as non-stop mode.

#### [5.5.3 Background Execution](https://sourceware.org/gdb/onlinedocs/gdb/Background-Execution.html#Background-Execution)

GDB’s execution commands have two variants: the normal foreground (synchronous) behavior, and a background (asynchronous) behavior. In foreground execution, GDB waits for the program to report that some thread has stopped before prompting for another command. In background execution, GDB immediately gives a command prompt so that you can issue other commands while your program runs.

If the target doesn’t support async mode, GDB issues an error message if you attempt to use the background execution commands.

To specify background execution, add a & to the command. For example, the background form of the continue command is continue&, or just c&.

You can interrupt your program while it is running in the background by using the interrupt command.

`interrupt`  
`interrupt -a`

Suspend execution of the running program. In all-stop mode, interrupt stops the whole process, but in non-stop mode, it stops only the current thread. To stop the whole program in non-stop mode, use interrupt -a.

#### [5.5.4 Thread-Specific Breakpoints](https://sourceware.org/gdb/onlinedocs/gdb/Thread_002dSpecific-Breakpoints.html#Thread_002dSpecific-Breakpoints)

When your program has multiple threads (see [Debugging Programs with Multiple Threads](https://sourceware.org/gdb/onlinedocs/gdb/Thread_002dSpecific-Breakpoints.html#Thread_002dSpecific-Breakpoints)), you can choose whether to set breakpoints on all threads, or on a particular thread.

#### [5.5.5 Interrupted System Calls](https://sourceware.org/gdb/onlinedocs/gdb/Interrupted-System-Calls.html#Interrupted-System-Calls)

There is an unfortunate side effect when using GDB to debug multi-threaded programs. If one thread stops for a breakpoint, or for some other reason, and another thread is blocked in a system call, then the system call may return prematurely. This is a consequence of the interaction between multiple threads and the signals that GDB uses to implement breakpoints and other events that stop execution.

To handle this problem, your program should check the return value of each system call and react appropriately. This is good programming style anyways.

#### [5.5.6 Observer Mode](https://sourceware.org/gdb/onlinedocs/gdb/Observer-Mode.html#Observer-Mode)

If you want to build on non-stop mode and observe program behavior without any chance of disruption by GDB, you can set variables to disable all of the debugger’s attempts to modify state, whether by writing memory, inserting breakpoints, etc. These operate at a low level, intercepting operations from all commands.

When all of these are set to off, then GDB is said to be observer mode. As a convenience, the variable observer can be set to disable these, plus enable non-stop mode.

## [6 Running programs backward](https://sourceware.org/gdb/onlinedocs/gdb/Reverse-Execution.html#Reverse-Execution)

When you are debugging a program, it is not unusual to realize that you have gone too far, and some event of interest has already happened. If the target environment supports it, GDB can allow you to “rewind” the program by running it backward.

A target environment that supports reverse execution should be able to “undo” the changes in machine state that have taken place as the program was executing normally. Variables, registers etc. should revert to their previous values. Obviously this requires a great deal of sophistication on the part of the target environment; not all target environments can support reverse execution.

## [7 Recording Inferior’s Execution and Replaying It](https://sourceware.org/gdb/onlinedocs/gdb/Process-Record-and-Replay.html#Process-Record-and-Replay)

On some platforms, GDB provides a special process record and replay target that can record a log of the process execution, and replay it later with both forward and reverse execution commands.

When this target is in use, if the execution log includes the record for the next instruction, GDB will debug in replay mode. In the replay mode, the inferior does not really execute code instructions. Instead, all the events that normally happen during code execution are taken from the execution log. While code is not really executed in replay mode, the values of registers (including the program counter register) and the memory of the inferior are still changed as they normally would. Their contents are taken from the execution log.

## [9 Examining Source Files](https://sourceware.org/gdb/onlinedocs/gdb/Source.html)

GDB can print parts of your program’s source, since the debugging information recorded in the program tells GDB what source files were used to build it.

### [9.1 Printing Source Lines](https://sourceware.org/gdb/onlinedocs/gdb/List.html)

To print lines from a source file, use the `list` command (abbreviated `l`).

- `list <linenum>`

  Print lines centered around line number linenum in the current source file

- `list <function>`

   Print lines centered around the beginning of function function

### [9.2 Specifying a Location](https://sourceware.org/gdb/onlinedocs/gdb/Specify-Location.html)

A linespec is a colon-separated list of source location parameters such as file name, function name, etc. Here are all the different ways of specifying a linespec:

- linenum
  
   Specifies the line number linenum of the current source file

- -offset / +offset
  
   Specifies the line offset lines before or after the current line

- filename:linenum

   Specifies the line linenum in the source file filename. If filename is a relative file name, then it will match any source file name with the same trailing components

- function

   Specifies the line that begins the body of the function function

- filename:function

   Specifies the line that begins the body of the function function in the file filename. You only need the file name with a function name to avoid ambiguity when there are identically named functions in different source files

### [9.3 Editing Source Files](https://sourceware.org/gdb/onlinedocs/gdb/Edit.html)

### [9.4 Searching Source Files](https://sourceware.org/gdb/onlinedocs/gdb/Search.html)

There are two commands for searching through the **current source file** for a regular expression.

- `forward-search <regexp>` / `search <regexp>`

   The command 'forward-search regexp' checks each line, starting with the one following the last line listed, for a match for regexp. It lists the line that is found. You can use the synonym ‘search regexp’ or abbreviate the command name as fo

- `reverse-search <regexp>`

   The command ‘reverse-search regexp’ checks each line, starting with the one before the last line listed and going backward, for a match for regexp. It lists the line that is found. You can abbreviate this command as rev

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
