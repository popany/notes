# [Strategized Locking, Thread-safe Interface, and Scoped Locking](https://www.dre.vanderbilt.edu/~schmidt/PDF/locking-patterns.pdf)

- [Strategized Locking, Thread-safe Interface, and Scoped Locking](#strategized-locking-thread-safe-interface-and-scoped-locking)
  - [1 Introduction](#1-introduction)
  - [2 The Strategized Locking Pattern](#2-the-strategized-locking-pattern)

Patterns and Idioms for Simplifying Multi-threaded C++ Components

Douglas C. Schmidt  
schmidt@cs.wustl.edu  
Department of Computer Science  
Washington University  
St. Louis, MO 63130, USA

## 1 Introduction

Developing multi-threaded applications is hard since incorrect use of locks can cause subtle and pernicious errors. Likewise, developing multi-threaded reusable components is hard since it can be time-consuming to customize components to support new, more efficient locking strategies. This paper describes a pair of patterns, Strategized Locking and Thread-safe Interface, and a C++ idiom, Scoped Locking, that help developers avoid common problems when programming multi-threaded components and applications.

## 2 The Strategized Locking Pattern

