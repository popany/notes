# [Inline Hooking for Programmers (Part 1: Introduction)](https://www.malwaretech.com/2015/01/inline-hooking-for-programmers-part-1.html)

## Inline Hooking

### What is it

Inline hooking is a method of intercepting calls to target functions,which is mainly used by antiviruses, sandboxes, and malware. The general idea is to redirect a function to our own, so that we can perform processing before and/or after the function does its; this could include: checking parameters, shimming, logging, spoofing returned data, and filtering calls. Rootkits tend to use hooks to modify data returned from system calls in order to hide their presence, whilst security software uses them to prevent/monitor potentially malicious operations.

The hooks are placed by **directly modifying code within the target function** (inline modification), usually by overwriting the first few bytes with a jump; this allows execution to be redirected before the function does any processing. Most hooking engines use a 32-bit relative jump (opcode 0xE9), which takes up 5 bytes of space.

### Problems we face

- Might need to call the original function which we’ve overwritten with a jump.
- Race conditions.
- Calling convention mismatches.
- Infinite recursion.

### How it works

We will be using a **trampoline based hook**, which allows us to intercept functions, whilst still being able to call  the originals (without unhooking them first).

this hook is made up of 3 parts:

1. The Hook – A 5 byte relative jump which is written to the target function in order to hook it, the jump will jump from the hooked function to our code.

2. The Proxy – This is our specified function (or code) which the hook placed on the target function will jump to.

3. The Trampoline – Used to bypass the hook so we can call a hooked function normally.

### Why Trampoline

Let’s say we want to hook `MessageBoxA`, print out the parameters from within the proxy function, then display the message box: In order to display the message box, we need to call MessageBoxA (which redirects to our proxy function, which in turn calls MessageBoxA). Obviously calling MessageBoxA from within our proxy function will just cause infinite recursion and the program with eventually crash due to a stack overflow.

We could simply unhook MessageBoxA from within the proxy function, call it, then re hooking it; but if multiple threads are calling MessageBoxA at the same time, this would cause a race condition and possibly crash the program.

Instead, what we can do is store the first 5 bytes of MessageBoxA (these are overwritten by our hook), then when we need to call the non hooked MessageBoxA, we can execute the stored first 5 bytes, followed by a jump 5 bytes into MessageBoxA (directly after the hook).

#### Before Hook

                          # MessageBoxA (not hooked)
    call MessageBoxA ---> mov edi, edi
                          push ebp
                          mov ebp, esp
                          push 0
                          push [ebp+10]
                          push [ebp+0C]
                          push [ebp+08]
                          call MessageBoxExA
                          pop ebp
                          retn 10

#### After Hook

                             # Tramploline
    call OldMessageBoxA ---> mov edi, edi
                             push ebp                # MessageBoxA (hooked)
                             mov ebp, esp            jump NewMessageBoxA
                             jump MessageBoxA+5 ---> push 0
                                                     push [ebp+10]
                                                     push [ebp+0C]
                                                     push [ebp+08]
                                                     call MessageBoxExA
                                                     pop ebp
                                                     retn 10

As long as the first 5 bytes aren’t relative instructions, they can be executed anywhere (because it’s very rare for functions to use relative instructions so early on, so we don’t really need to handle this). A problem we do need to handle is if the first 5 bytes of the function don’t make up n whole instructions).

In the example, the first 5 bytes of the function make up exactly 3 instructions (mov edi, edi; push ebp; mov ebp, esp), however, if for example, the first instruction was 10 bytes long and we only stored 5 bytes: the trampoline would be trying to execute half an instruction and the program would explode. To get around this, we must use a disassemble to get the length of each instruction, so we can make sure only to copy whole instructions. The best case scenario is the first n instructions add up to exactly 5 bytes, the worst case is if the first instruction is 4 bytes and the second is 16 (the maximum length of an x86 instruction), we must store 20 bytes (4 + 16), meaning our trampoline must be 25 bytes in size (space for up to 20 bytes worth of instructions and a 5 byte jump back to the hooked function). It’s important to note that the return jump must jump to the hooked function n bytes in, where n is however many instructions we stored in the trampoline.
