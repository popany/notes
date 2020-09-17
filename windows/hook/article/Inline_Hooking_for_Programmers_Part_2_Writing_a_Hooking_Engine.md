# [Inline Hooking for Programmers (Part 2: Writing a Hooking Engine)](https://www.malwaretech.com/2015/01/inline-hooking-for-programmers-part-2.html)

We’ll be writing a hooking engine using trampoline based hooks as explained in the previous article (we don’t handle relative instructions as they’re very rare, but we do use atomic write operations to prevent race conditions).

First things first, we need to define the proxy functions which we will redirect the hooked functions to, these must have the same calling convention, return type, and parameters as the functions we are going to hook with them. For this example we will simply have them print out the parameters before displaying the message box.

    int WINAPI NewMessageBoxA(HWND hWnd, LPCSTR lpText, LPCTSTR lpCaption, UINT uType)
    {
        printf("MessageBoxA called!ntitle: %sntext: %snn", lpCaption, lpText);
        return OldMessageBoxA(hWnd, lpText, lpCaption, uType);
        }
    
    int WINAPI NewMessageBoxW(HWND hWnd, LPWSTR lpText, LPCTSTR lpCaption, UINT uType)
    {
        printf("MessageBoxW called!ntitle: %wsntext: %wsnn", lpCaption, lpText);
        return OldMessageBoxW(hWnd, lpText, lpCaption, uType);
    }

`OldMessageBox` is simply a typedef that will point to 25 bytes of executable memory which the hooking function will store the trampoline into.

    typedef int (WINAPI *TdefOldMessageBoxA)(HWND hWnd, LPCSTR lpText, LPCTSTR lpCaption, UINT uType);
    typedef int (WINAPI *TdefOldMessageBoxW)(HWND hWnd, LPWSTR lpText, LPCTSTR lpCaption, UINT uType);
    TdefOldMessageBoxA OldMessageBoxA = (TdefOldMessageBoxA)VirtualAlloc(NULL, 25, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    TdefOldMessageBoxW OldMessageBoxW = (TdefOldMessageBoxW)VirtualAlloc(NULL, 25, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

Now for the hooking function, we will have the following parameters:

- name – The name of the function to hook.
- dll – The dll the target function resides in.
- proxy – a pointer to the proxy function (NewMessageBox).
- original – A pointer to 25 bytes of executable memory, where we will store the trampoline.
- length – A pointer to a variable which receives the number of bytes worth of instructions stored in the trampoline (remember we can only copy whole instructions).

hooking function

    BOOL HookFunction(CHAR *dll, CHAR *name, LPVOID proxy, LPVOID original, PDWORD length)
    {
    }

Inside the hooking function we will get the address of the target function, then use the “Hacker Dissasembler Engine (HDE32)” to dissasemble each instruction and get the length, until we have 5 or more bytes worth of whole instructions (hde32_disasm returns the length of the instruction pointed to by the first parameter).

    LPVOID FunctionAddress;
    DWORD TrampolineLength = 0;
    
    FunctionAddress = GetProcAddress(GetModuleHandleA(dll), name);
    if(!FunctionAddress)
        return FALSE;
    
    //disassemble length of each instruction, until we have 5 or more bytes worth
    while(TrampolineLength < 5)
    {
        LPVOID InstPointer = (LPVOID)((DWORD)FunctionAddress + TrampolineLength);
        TrampolineLength += hde32_disasm(InstPointer, &disam);
    }

To build the actual trampoline we first copy `TrampolineLength` of bytes from the target function to the **trampoline buffer** (passed to the function in the parameter `original`), then we append the copied bytes with a jump to n bytes into target function (n is TrampolineLength e.g. resume execution in the target function where the trampoline left off).

A relative jump is the distance from the end of the jump, that is: (destination – (source + 5)). The source of the jump will be the trampoline address + TrampolineLength and the destination will be the hooked function + TrampolineLength.

    DWORD src = ((DWORD)FunctionAddress + TrampolineLength); // destination
    DWORD dst = ((DWORD)original + TrampolineLength + 5); // source + 5
    BYTE jump[5] = {0xE9, 0x00, 0x00, 0x00, 0x00};

    //Store n bytes from the target function into trampoline
    memcpy(original, FunctionAddress, TrampolineLength);
 
    //Set the second byte of the jump (the offset), so the jump goes where we want.
    *(DWORD *)(jump+1) = src - dst;
 
    //Copy the jump to the end of the trampoline
    memcpy((LPVOID)((DWORD)original+TrampolineLength), jump, 5);

Before we can write the jump to the function, we need to make sure the memory is writable (it's usually not), we do this by setting the protection to PAGE_EXECUTE_READWRITE using `VirtualProtect`.

    //Make sure the function is writable
    DWORD OriginalProtection;
    if(!VirtualProtect(FunctionAddress, 8, PAGE_EXECUTE_READWRITE, &OriginalProtection))
    return FALSE;

To place the hook all we need to do is create a jump to jump from the target function to the proxy, then we can overwrite the first 5 bytes of the target with it. To avoid any risk of the function being called while we’re writing the jump, we must write all of it at once (atomically). Sadly atomic functions can only work with sizes of base 2 (2, 4, 8, 16, etc); our jump is 5 bytes and the closest size we can copy is 8, so we will have to make a custom function (SafeMemcpyPadded) that will pad the source buffer to 8 bytes with bytes from the destination, so that the last 3 bytes remain unchanged after the copy.

cmpxchg8b compares the 8 bytes held in edx:eax, with the destination, if they're equal it copies the 8 bytes held in ecx:ebx, we set edx:eax to the destination bytes so that the copy always happens.

    //Build and atomically write the hook
    *(DWORD *)(jump+1) = (DWORD)proxy - (DWORD)FunctionAddress - 5;
    SafeMemcpyPadded(FunctionAddress, Jump, 5);

    void SafeMemcpyPadded(LPVOID destination, LPVOID source, DWORD size)
    {
        BYTE SourceBuffer[8];

        if(size > 8)
            return;

        //Pad the source buffer with bytes from destination
        memcpy(SourceBuffer, destination, 8);
        memcpy(SourceBuffer, source, size);

        __asm 
        {
            lea esi, SourceBuffer;
            mov edi, destination;

            mov eax, [edi];
            mov edx, [edi+4];
            mov ebx, [esi];
            mov ecx, [esi+4];

            lock cmpxchg8b[edi];
        }
    }

All that’s left to do now is restore the page protection. flush the instruction cache, and set the “length” parameter to TrampolineLength.

    //Restore the original page protection
    VirtualProtect(FunctionAddress, 8, OriginalProtection, &OriginalProtection);

    //Clear CPU instruction cache
    FlushInstructionCache(GetCurrentProcess(), FunctionAddress, TrampolineLength);

    *length = TrampolineLength;
    return TRUE;

The hooking function can simply be called like so.

    DWORD length;
    HookFunction("user32.dll", "MessageBoxA", &NewMessageBoxA, OldMessageBoxA, &length);

Unhooking is done by copying “length” bytes to the hooked function from `OldMessageBox` (the trampoline).

You can see my full hooking engine, including example usage, on [GitHub](https://github.com/MalwareTech/BasicHook/).
