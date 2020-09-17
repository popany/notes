# [Can I access Windows Kernel system calls directly?](https://stackoverflow.com/questions/21594744/can-i-access-windows-kernel-system-calls-directly)

- [Can I access Windows Kernel system calls directly?](#can-i-access-windows-kernel-system-calls-directly)

What you want to do depends heavily on the architecture you're interested, but the thing to know is, that ntdll.dll is the user-mode trampoline for every syscall - i.e. the only one who actually makes syscalls at the end of the day is ntdll.

So, let's disassemble one of these methods in WinDbg, by opening up any old exe (I picked notepad). First, use x ntdll!* to find the symbols exported by ntdll:

    0:000> x ntdll!*
    00007ff9`ed1aec20 ntdll!RtlpMuiRegCreateLanguageList (void)
    00007ff9`ed1cf194 ntdll!EtwDeliverDataBlock (void)
    00007ff9`ed20fed0 ntdll!shortsort_s (void)
    00007ff9`ed22abbf ntdll!RtlUnicodeStringToOemString$fin$0 (void)
    00007ff9`ed1e9af0 ntdll!LdrpAllocateDataTableEntry (void)
    ...

So, let's pick one at random, NtReadFile looks neato. Let's disassemble it:

    0:000> uf ntdll!NtReadFile

    ntdll!NtReadFile:
    00007ff9`ed21abe0 4c8bd1          mov     r10,rcx
    00007ff9`ed21abe3 b805000000      mov     eax,5
    00007ff9`ed21abe8 0f05            syscall
    00007ff9`ed21abea c3              ret

Here, we see that we stuff away `rcx`, put the syscall number into `eax`, then call the `syscall` instruction. Every `syscall` has a number that is assigned arbitrarily by Windows (i.e. this number is a secret handshake between `ntdll` and the `kernel`, and changes whenever Microsoft wants)

None of these instructions are "magic", you could execute them in your app directly too (but there's no practical reason to do so, of course - just for funsies)
