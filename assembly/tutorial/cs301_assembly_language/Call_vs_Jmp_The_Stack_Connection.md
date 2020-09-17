# [Call vs Jmp: The Stack Connection](https://www.cs.uaf.edu/2012/fall/cs301/lecture/09_24_call_and_ret.html)

- [Call vs Jmp: The Stack Connection](#call-vs-jmp-the-stack-connection)
  - [Call and Return](#call-and-return)
  - [Optimization: Tail Recursion](#optimization-tail-recursion)
  - [Why you care #1: Stack Space Usage](#why-you-care-1-stack-space-usage)
  - [Why you care #2: Buffer Overflow Attack](#why-you-care-2-buffer-overflow-attack)

It's surprisingly easy to define a function in assembly language: just make a label, and "call" it:

    mov edi,1000
    call myfunction
    add eax,7
    ret

    myfunction:
    mov eax,edi ; copy our first parameter into eax (to be returned)
    ret ; go back to foo

"call" and "ret" match one another, so myfunction's "ret" goes back to our first function.  If you use "jmp" instead of "call", "ret" will return all the way back out to main, so this code will return 1000:

    mov edi,1000
    jmp myfunction
    add eax,7 ; <- never executed!
    ret

    myfunction:
    mov eax,edi ; copy our first parameter into eax (to be returned)
    ret ; go back to main

In fact, the only difference between "jmp" and "call" is what happens at the following "ret"; so if you want "ret" to return to your function again, you can actually speed up your code by replacing "call" with "jmp".  This is a "[tail call](http://en.wikipedia.org/wiki/Tail_call)": it's a way to leave a function without ever coming back.

|||
|-|-|
|jmp somewhere|Start executing code at somewhere. That is, it sets register rip=somewhere.|
|call somewhere <br> comeback:|Save where to come back on the stack, and go somewhere. That is, it pushes comeback, then sets rip=somewhere.|

## Call and Return

OK, so far we've seen that the stack gets used in assembly language for:

- Temporary storage, like small arrays in the program.  You just "sub rsp, N" to allocate N bytes starting at rsp; as long as you be sure to "add rsp,N" to give those bytes back before your function returns.  One nice part about the stack is that once you move the stack pointer over an area, those bytes are YOURS until you give them back, unlike registers, which almost always get overwritten when you call another function.

- Saving preserved registers, usually just a "push" at the start of your function, and a "pop" at the end.

There's one more place the stack gets used, and that's to keep track of where "ret" should go when you return from a function.  This is very simple--**"ret" jumps back to the address on the top of the stack**.  **"call" pushes this return address before jumping into the new function**.

|||
|-|-|
|**Instruction**|**Equivalent Instruction Sequence**|
|call bar|push next_instruction <br> jmp bar <br> next_instruction:|
|ret|pop rdx    (rdx or some other scratch register; ret doesn't modify any registers) <br> jmp rdx|

For example, there's one subtle difference between these two pieces of code: in the first case, we go and come back; in the second case, we leave forever.

||||
|-|-|-|
||**Assembly**|**C/C++**|
|**Call**|call make_beef <br> mov eax,0xC0FFEE <br> ret <br> <br> make_beef: <br> &nbsp;&nbsp;&nbsp;&nbsp; mov eax,0xBEEF <br> &nbsp;&nbsp;&nbsp;&nbsp; ret <br> <br> Returns 0xC0FFEE, because we come back from "make_beef".|int make_beef(void); <br> int foo(void) { <br> &nbsp;&nbsp;&nbsp;&nbsp; make_beef(); <br> &nbsp;&nbsp;&nbsp;&nbsp; return 0xC0FFEE; <br> } <br> <br> int make_beef(void) { <br> &nbsp;&nbsp;&nbsp;&nbsp; return 0xBEEF; <br> } <br> <br> Also returns 0xC0FFEE, for the same reason.|
|**Jump**|jmp make_beef <br> mov eax,0xC0FFEE <br> ret <br> <br> make_beef: <br> &nbsp;&nbsp;&nbsp;&nbsp; mov eax,0xBEEF <br> &nbsp;&nbsp;&nbsp;&nbsp; ret <br> <br> Returns 0xBEEF, because we never come back from "make_beef".|int foo(void) { <br> &nbsp;&nbsp;&nbsp;&nbsp; goto make_beef; <br> &nbsp;&nbsp;&nbsp;&nbsp;return 0xC0FFEE; <br> make_beef: <br> &nbsp;&nbsp;&nbsp;&nbsp;return 0xBEEF; <br> } <br> <br> Again, "make_beef" never comes back, so we get 0xBEEF.|

It's easy to manually add code to jump back from "make_beef", like this:

    jmp make_beef
    come_back:
    mov eax,0xC0FFEE
    ret

    make_beef:
        mov eax,0xBEEF
        jmp come_back

But the "call" instruction allows "ret" to jump back to the right place automatically, by **pushing the return address on the stack**.  "ret" then **pops the return address and goes there**:

    push come_back ; - simulated "call" -
    jmp make_beef  ; -   continued  -
    come_back:     ; - end of simulated "call" -

    mov eax,0xC0FFEE
    ret

    make_beef:
        mov eax,0xBEEF
        pop rcx   ; - simulated "ret" -
        jmp rcx   ; - end of simulated "ret" -

There's a very weird hacky way to figure out what address your code is running from: call the next instruction, and then pop the return address that "call" pushed!

    call nextline
    nextline:
    pop rax ; rax will store the location in memory of nextline
    ret

This is only useful if your code doesn't know where in memory it will get loaded.  This is true for some shared libraries, where you see exactly the above instruction sequence!

## Optimization: Tail Recursion

Because calling functions takes some overhead (push return address, call function, do work, pop return address, return there), recursion is slower than iteration.  For example:

|||
|-|-|
|**C++ Plain Recursion**|**Assembly Plain Recursion**|
|int sum(int i) { <br> &nbsp;&nbsp;&nbsp;&nbsp; if (i==0) return 0; <br> &nbsp;&nbsp;&nbsp;&nbsp; else return sum(i-1)+i; <br> } <br> int foo(void) <br> { <br> &nbsp;&nbsp;&nbsp;&nbsp; return sum(10000000); <br> }|mov rdi,10000000 <br> call sum <br> ret <br> <br> ; sum function: computes sum of numbers from 0...i <br> ; one parameter: i, in rdi: number of recursions left <br> sum: <br> cmp   rdi,0 ; check if we're done <br> jle    base_case <br> push rdi <br> sub  rdi,0x1; i-1 <br> call sum ; recursion step <br> pop rdi <br> add rax,rdi ; partial + i <br> ret <br>  <br> base_case: ; no more iterations--return zero <br> mov   rax,0 <br> ret
|

Folks who love recursion have found an interesting optimization called "tail recursion", where you arrange for there to be *nothing* for the function to do after recursing, so there's no point in your children returning to you--you just "jmp" to them, not "call", because you don't want them to ever come back to you.  The base case is the only "ret".  Here's an example:

|||
|-|-|
|**C++ Tail Recursion**|**Assembly Tail Recursion**|
|int sum(int i,int partial) { <br> &nbsp;&nbsp;&nbsp;&nbsp; if (i==0) return partial; <br> &nbsp;&nbsp;&nbsp;&nbsp; else return sum(i-1,partial+i); <br> } <br> int foo(void) <br> { <br> &nbsp;&nbsp;&nbsp;&nbsp; return sum(10000000,0); <br> }|mov edi,1000000000 ; sum first argument <br> mov esi,0 ; partial result <br> call sum <br> ret <br>  <br> sum: <br> mov    eax,esi <br> cmp   edi,0 <br> je    base_case <br> lea    esi,[rax+rdi*1] ; funky esi=eax+edi <br> sub    edi,0x1 <br> jmp sum ; tail recursion step! <br> <br> base_case: <br> ret|

Tail recursion eliminates both the memory used on the stack for the return addresses, and the time taken for the call and return.  It can make recursion exactly as fast as iteration.  (Curiously, you can always transform an iteration into a recursion, and vice versa, although the code may get nasty.)

Sadly, my version of the gcc compiler doesn't seem to do the tail recursion optimization anymore on 64-bit machines, possibly due to the new stack alignment rules, although it used to this optimization reliably on 32-bit machines.

## Why you care #1: Stack Space Usage

Every time you call a nested function, the stack has to hold the address to return to.  This actually takes up a few bytes of stack space per call, so a deeply-recursive function can run out of space pretty quickly.  For example, this code runs out of stack space and exits (rather than crashing or printing the return value) for an input value as low as 10 million:

    int silly_recursive(int i) {
        if (i==0) return 0;
        else return i+silly_recursive(i-1);
    }

    int foo(void) {
        std::cout<<"Returns: "<<silly_recursive(read_input());
        return 2;
    }

The same computation works fine (aside from integer overflow) when written as an iteration, not a recursion, because iteration doesn't touch the stack:

    int silly_iterative(int n) {
        int sum=0;
        for (int i=0;i<=n;i++) sum+=i;
        return sum;
    }

    int foo(void) {
        std::cout<<"Returns: "<<silly_iterative(read_input());
        return 2;
    }

I've met truly dedicated recursion-centric mathematicians who described iteration as a 'degenerate form of recursion'.  He preferred writing his recursions in 'tail position', so the compiler itself could put the iterative jump in there.

Really, recursion and iteration are "equivalent" in the mathematical sense that you can transform each one into the other (with a lot of work).  Here's the recursion to iteration direction:

|||
|-|-|
|Here's the perfectly mathematical recursive form of factorial.|int f(int n) { <br> &nbsp;&nbsp;&nbsp;&nbsp; if (n==1) return 1; <br> &nbsp;&nbsp;&nbsp;&nbsp; else return f(n-1)*n; <br> }|
|Adding a variable to store the multiplications computed "so far" puts the recursive call in '[tail position](http://en.wikipedia.org/wiki/Tail_call)', where we could replace the call with a jmp (since we have nothing to do when the child returns).  This would save stack space at runtime, and be about 50% faster.  However, the compiler doesn't seem to do it on my 64-bit machine.|int f(int n,int sofar) { <br> &nbsp;&nbsp;&nbsp;&nbsp; if (n==1) return sofar; <br> &nbsp;&nbsp;&nbsp;&nbsp; else return f(n-1,sofar*n); <br> }|
|Since the compiler doesn't seem to do the call->jmp translation, do it ourselves with a hideous goto.  This looks more like assembly!|int f(int n,int sofar) { <br> &nbsp;&nbsp;&nbsp;&nbsp; start_of_f: <br> &nbsp;&nbsp;&nbsp;&nbsp; if (n==1) return sofar; <br> &nbsp;&nbsp;&nbsp;&nbsp; else { <br> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; sofar=sofar*n; <br> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; n=n-1; <br> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; goto start_of_f; <br> &nbsp;&nbsp;&nbsp;&nbsp; } <br> }|
|Instead of the circular "jmp", we can just do a cleaner while loop.|int f(int n,int sofar) { <br> &nbsp;&nbsp;&nbsp;&nbsp; while (n>1) { <br> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; sofar=sofar*n; <br> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; n=n-1; <br> &nbsp;&nbsp;&nbsp;&nbsp; } <br> &nbsp;&nbsp;&nbsp;&nbsp; return sofar; <br> }|
|Might as well make the loop count upwards--then we can get rid of the extra variable.  Our transition to iteration is now complete!|int f(int n) { <br> &nbsp;&nbsp;&nbsp;&nbsp; int sofar=1; <br> &nbsp;&nbsp;&nbsp;&nbsp; for (int i=1;i<=n;i++) { <br> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; sofar=sofar*i; <br> &nbsp;&nbsp;&nbsp;&nbsp; } <br> &nbsp;&nbsp;&nbsp;&nbsp; return sofar; <br> }|

You can also read this table bottom-to-top, which is the process to convert iteration into recursion.

## Why you care #2: Buffer Overflow Attack

Another place understanding call and return come in handy is in writing secure code.  Here's some insecure code:

    int happy_innocent_code(void) {
        char str[8];
        cin>>str;
        cout<<"I just read a string: "<<str<<"!  I'm a big boy!\n";
        return 0;
    }

    void evil_bad_code(void) {
        cout<<"Mwa ha ha ha...\n";
        cout<<"...er, I can't return.  Crashing.\n";
    }

    int foo(void) {
        //void *p=(void *)evil_bad_code; /* address of the bad code */
        //printf("evil code is at: '%4s'\n",(char *)&p);
        happy_innocent_code();
        cout<<"How nice!\n";
        return 0;
    }

The "cin>>str" line in happy_innocent_code, can overwrite happy's stack space with whatever's in the read-in string, if the read-in string is longer than 7 bytes.  So you can get a horrific crash if you just enter any long string, because the correct return address is overwritten with string data.

But it gets worse.  Note that we never explicitly call "evil_bad_code", but the commented-out code helped me craft the attack string "aaaabbbbccccDŒ#˜eeeeffff", where the funky binary bytes of that attack string get written into the part of the stack that should be storing happy's return address.  If we overwrite this with the address of evil code, happy will return directly to evil bad code, which then can do anything it likes.  Kaboom!

Be sure to use "std::string", not raw arrays of char, in all your input data!

There's a pretty informative writeup on this by the hacker Aleph One called "[smashing the stack for fun and profit](http://insecure.org/stf/smashstack.html)".  Luckily, most network-facing code nowadays (including NetRun itself) uses safe strings instead of char arrays, and isn't vulnerable to buffer overflow exploits like this.  Modern compilers, like gcc 4, automatically include protection against stack smashing (try the above on my 64-bit machine, which has this new compiler!).
