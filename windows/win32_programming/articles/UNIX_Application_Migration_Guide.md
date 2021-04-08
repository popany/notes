# [UNIX Application Migration Guide](https://docs.microsoft.com/en-us/previous-versions/ms811896(v=msdn.10))

- [UNIX Application Migration Guide)](#unix-application-migration-guide)
  - [Signals and Signal Handling?redirectedfrom=MSDN#signals-and-signal-handling)](#signals-and-signal-handling)
    - [Managing signals in Windows](#managing-signals-in-windows)

...

## [Signals and Signal Handling](https://docs.microsoft.com/en-us/previous-versions/ms811896(v=msdn.10)?redirectedfrom=MSDN#signals-and-signal-handling)

The UNIX operating system supports a wide range of signals. UNIX signals are software interrupts that catch or indicate different types of events. Windows on the other hand supports only a small set of signals that is restricted to exception events only. Consequently, converting UNIX code to Win32 requires the use of new techniques replacing the use of some UNIX signals.

The Windows signal implementation is limited to the following signals (Table 3):

Table 3. Windows signals

|Signal|Meaning|
|-|-|
SIGABRT|Abnormal termination
SIGFPE|Floating-point error
SIGILL|Illegal instruction
SIGINT|CTRL+C signal
SIGSEGV|Illegal storage access
SIGTERM|Termination request
|||

...

### Managing signals in Windows

    #include <windows.h>
    #include <signal.h>
    #include <stdio.h>

    void intrpt(int signum)
    {
        printf("I got signal %d\n", signum);
        (void) signal(SIGINT, SIG_DFL);
    }

    /*  main intercepts the SIGINT signal generated when Ctrl-C is input.
        Otherwise, sits in an infinite loop, printing a message once a second.
    */

    void main()
    {
        (void) signal(SIGINT, intrpt);

        while(1) {
            printf("Hello World!\n");
            Sleep(1000);
        }
    }



