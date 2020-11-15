# [What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html)

- [What Every Computer Scientist Should Know About Floating-Point Arithmetic](#what-every-computer-scientist-should-know-about-floating-point-arithmetic)
  - [Abstract](#abstract)
  - [Introduction](#introduction)
  - [Rounding Error](#rounding-error)
  - [Floating-point Formats](#floating-point-formats)

|||
|-|-|
Note|This appendix is an edited reprint of the paper What Every Computer Scientist Should Know About Floating-Point Arithmetic, by David Goldberg, published in the March, 1991 issue of Computing Surveys. Copyright 1991, Association for Computing Machinery, Inc., reprinted by permission.
|||

## Abstract

Floating-point arithmetic is considered an esoteric subject by many people. This is rather surprising because floating-point is ubiquitous in computer systems. Almost every language has a floating-point datatype; computers from PCs to supercomputers have floating-point accelerators; most compilers will be called upon to compile floating-point algorithms from time to time; and virtually every operating system must respond to floating-point exceptions such as overflow. This paper presents a tutorial on those aspects of floating-point that have a direct impact on designers of computer systems. It begins with background on **floating-point representation** and **rounding error**, continues with a discussion of the **IEEE floating-point standard**, and concludes with numerous examples of how computer builders can **better support** floating-point.

Categories and Subject Descriptors: (Primary) C.0 [Computer Systems Organization]: General -- instruction set design; D.3.4 [Programming Languages]: Processors -- compilers, optimization; G.1.0 [Numerical Analysis]: General -- computer arithmetic, error analysis, numerical algorithms (Secondary)

D.2.1 [Software Engineering]: Requirements/Specifications -- languages; D.3.4 Programming Languages]: Formal Definitions and Theory -- semantics; D.4.1 Operating Systems]: Process Management -- synchronization.

General Terms: Algorithms, Design, Languages

Additional Key Words and Phrases: Denormalized number, exception, floating-point, floating-point standard, gradual underflow, guard digit, NaN, overflow, relative error, rounding error, rounding mode, ulp, underflow.

## Introduction

Builders of computer systems often need information about floating-point arithmetic. There are, however, remarkably few sources of detailed information about it. One of the few books on the subject, Floating-Point Computation by Pat Sterbenz, is long out of print. This paper is a tutorial on those aspects of floating-point arithmetic (floating-point hereafter) that have a direct connection to systems building. It consists of three loosely connected parts. The first section, Rounding Error, discusses the implications of using different rounding strategies for the basic operations of addition, subtraction, multiplication and division. It also contains background information on the two methods of measuring rounding error, ulps and relative error. The second part discusses the IEEE floating-point standard, which is becoming rapidly accepted by commercial hardware manufacturers. Included in the IEEE standard is the rounding method for basic operations. The discussion of the standard draws on the material in the section Rounding Error. The third part discusses the connections between floating-point and the design of various aspects of computer systems. Topics include instruction set design, optimizing compilers and exception handling.

I have tried to avoid making statements about floating-point without also giving reasons why the statements are true, especially since the justifications involve nothing more complicated than elementary calculus. Those explanations that are not central to the main argument have been grouped into a section called "The Details," so that they can be skipped if desired. In particular, the proofs of many of the theorems appear in this section. The end of each proof is marked with the z symbol. When a proof is not included, the z appears immediately following the statement of the theorem.

## Rounding Error

Squeezing infinitely many real numbers into a finite number of bits requires an approximate representation. Although there are infinitely many integers, in most programs the result of integer computations can be stored in 32 bits. In contrast, given any fixed number of bits, most calculations with real numbers will produce quantities that cannot be exactly represented using that many bits. Therefore the result of a floating-point calculation must often be **rounded in order to fit back into its finite representation**. This **rounding error is the characteristic feature of floating-point computation**. The section Relative Error and Ulps describes how it is measured.

Since most floating-point calculations have rounding error anyway, does it matter if the basic arithmetic operations introduce a little bit more rounding error than necessary? That question is a main theme throughout this section. The section Guard Digits discusses guard digits, a means of reducing the error when subtracting two nearby numbers. Guard digits were considered sufficiently important by IBM that in 1968 it added a guard digit to the double precision format in the System/360 architecture (single precision already had a guard digit), and retrofitted all existing machines in the field. Two examples are given to illustrate the utility of guard digits.

The IEEE standard goes further than just requiring the use of a guard digit. It gives an algorithm for addition, subtraction, multiplication, division and square root, and requires that implementations produce the same result as that algorithm. Thus, when a program is moved from one machine to another, the results of the basic operations will be the same in every bit if both machines support the IEEE standard. This greatly simplifies the porting of programs. Other uses of this precise specification are given in Exactly Rounded Operations.

## Floating-point Formats

Several different representations of real numbers have been proposed, but by far the most widely used is the floating-point representation. Floating-point representations have a base $\beta$ (which is always assumed to be even) and a precision p. If $\beta = 10$ and $p = 3$, then the number $0.1$ is represented as $1.00 × 10^{-1}$. If $\beta = 2$ and $p = 24$, then the decimal number $0.1$ cannot be represented exactly, but is approximately $1.10011001100110011001101 × 2^{-4}$.

In general, a floating-point number will be represented as $± d.dd... d × \beta^{e}$, where $d.dd... d$ is called the significand and has $p$ digits. More precisely $± d_{0} . d_{1} d_{2} ... d_{p-1} × \beta^{e}$ represents the number

$$± (d_{0} + d_{1} \beta^{-1} + ... + d_{p-1} \beta^{-(p-1)}) \beta^{e}, (0 \leq d_{i} < \beta_{i})$$



TODO AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA