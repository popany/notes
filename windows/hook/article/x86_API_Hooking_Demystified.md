# [x86 API Hooking Demystified](http://jbremer.org/x86-api-hooking-demystified/)

- [x86 API Hooking Demystified](#x86-api-hooking-demystified)
  - [Abstract](#abstract)
  - [Introduction](#introduction)
  - [Basic API Hooking](#basic-api-hooking)
  - [References](#references)
    - [1. Hooking - Wikipedia](#1-hooking---wikipedia)
    - [2. API Hooking Revealed - CodeProject](#2-api-hooking-revealed---codeproject)
    - [3. Instruction Pointer / Program Counter - Wikipedia](#3-instruction-pointer--program-counter---wikipedia)
    - [4. Rootkit Detector - GMER](#4-rootkit-detector---gmer)
    - [5. Thiscall Calling Convention - Nynaeve](#5-thiscall-calling-convention---nynaeve)
    - [6. Win32 Thread Information Block - Wikipedia](#6-win32-thread-information-block---wikipedia)

## Abstract

Today’s post presents several ways of API hooking under the x86 instruction set.

Throughout the following paragraphs we will introduce the reader to API hooking, what we can do with it, why API hooking is useful, the most basic form of API hooking. And, after presenting a simple API hooking method, we will cover some lesser known and used (if used at all) methods which might come in handy one day, as well as some other techniques to keep in mind when using any kind of hooking method.

Finally, we refer the reader to production code which will be used on a daily basis to analyze thousands of malware samples.

## Introduction

The following fragment is a brief explanation on Hooking, taken from Wikipedia[<sup>[1]</sup>](#1-hooking---wikipedia).

In computer programming, the term hooking covers a range of techniques used to alter or augment the behavior of an operating system, of applications, or of other software components by intercepting function calls or messages or events passed between software components. Code that handles such intercepted function calls, events or messages is called a "hook".

So, we’ve established that hooking allows us to alter the behaviour of existing software. Before we go further, following is a brief list of example uses of hooking.

- Profiling: How fast are certain function calls?
- Monitoring: Did we send the correct parameters to function X?
- ..?

A more comprehensive list of why one would want to hook functions can be found here [<sup>[1]</sup>](#1-hooking---wikipedia) [<sup>[2]</sup>](#2-api-hooking-revealed---codeproject).

With this list, it should be clear why API hooking is useful. That being said, it’s time to move on to API hooking itself.

A small note to the reader, this post does not cover breakpoints, IAT Hooking, etc. as that is an entire blogpost on its own.

## Basic API Hooking

The easiest way of hooking is by inserting a jump instruction. As you may or may not already know, the x86 instruction set has a variable length instruction size (that is, an instruction can have a length between one byte and 16 bytes, at max.) One particular instruction, the unconditional jump, is five bytes in length. One byte represents the opcode, the other four bytes represent a 32bit relative offset. (Note that there is also an unconditional jump instruction which takes an 8bit relative offset, but we will not use that instruction in this example.)

So, if we have two functions, function A and function B, how do we redirect execution from function A to function B? Well, obviously we will be using a jump instruction, so all there’s left to do is calculate the correct relative offset.

Assume that function A is located at address 0×401000 and that function B is located at address 0×401800. What we do next is, we determine the required relative offset. There is a difference of 0×800 bytes between the two functions, and we want to jump from function A to function B, so we don’t have to worry about negative offsets yet.

Now comes the tricky part, assume that we have already written our jump instruction at address 0×401000 (function A), and that the instruction is executed. What the CPU will do is the following; first it will add the length of the instruction to the Instruction Pointer [<sup>[3]</sup>](#3-instruction-pointer--program-counter---wikipedia) (or Program Counter), the length of the jump instruction is five bytes, as we’ve established earlier. After this, the relative offset is added (the four bytes, or 32bits value, located after the opcode) to the Instruction Pointer. In other words, the CPU calculates the new Instruction Pointer like the following.

    instruction_pointer = instruction_pointer + 5 + relative_offset;

Therefore, calculating the relative offset requires us to reverse the formula in the following way.

    relative_offset = function_B - function_A - 5;

We subtract five because that’s the length of the jump instruction which the CPU adds when executing this instruction, and function_A is subtracted from function_B because it’s a relative jump; the difference between the addresses of function_B and function_A is 0×800 bytes. (E.g. if we forget to subtract function_A, then the CPU will end up at the address 0×401800 + 0×401000 + 5, which is obviously not desired.)

In assembly, redirecting function A to function B will look roughly like the following.







## References

### 1. [Hooking - Wikipedia](http://en.wikipedia.org/wiki/Hooking)

### 2. [API Hooking Revealed - CodeProject](http://www.codeproject.com/Articles/2082/API-hooking-revealed)

### 3. [Instruction Pointer / Program Counter - Wikipedia](http://en.wikipedia.org/wiki/Program_counter)

### 4. [Rootkit Detector - GMER](http://www.gmer.net/)

### 5. [Thiscall Calling Convention - Nynaeve](http://www.nynaeve.net/?p=73)

### 6. [Win32 Thread Information Block - Wikipedia](http://en.wikipedia.org/wiki/Win32_Thread_Information_Block)
