# [The Definitive ANTLR 4 Reference](https://pragprog.com/titles/tpantlr2/the-definitive-antlr-4-reference/)

- [The Definitive ANTLR 4 Reference](#the-definitive-antlr-4-reference)
  - [CHAPTER 1 Meet ANTLR](#chapter-1-meet-antlr)
    - [1.1 Installing ANTLR](#11-installing-antlr)
  - [CHAPTER 2 The Big Picture](#chapter-2-the-big-picture)
    - [2.1 Let’s Get Meta!](#21-lets-get-meta)
    - [2.2 Implementing Parsers](#22-implementing-parsers)
  - [CHAPTER 3 A Starter ANTLR Project](#chapter-3-a-starter-antlr-project)
  - [CHAPTER 4 A Quick Tour](#chapter-4-a-quick-tour)
    - [4.1 Matching an Arithmetic Expression Language](#41-matching-an-arithmetic-expression-language)
    - [4.2 Building a Calculator Using a Visitor](#42-building-a-calculator-using-a-visitor)

## CHAPTER 1 Meet ANTLR

### 1.1 Installing ANTLR

In a nutshell, the ANTLR tool converts grammars into programs that recognize sentences in the language described by the grammar.

The [StringTemplate](https://www.stringtemplate.org/about.html) Engine.

Set the CLASSPATH5 environment variable

    $ export CLASSPATH=".:/usr/local/lib/antlr-4.0-complete.jar:$CLASSPATH"

Check to see that ANTLR is installed correctly

    $ java -jar /usr/local/lib/antlr-4.0-complete.jar # launch org.antlr.v4.Tool
    ANTLR Parser Generator Version 4.0
    -o ___ specify output directory where all output is generated
    -lib ___ specify location of .tokens files
    ...

    $ java org.antlr.v4.Tool # launch org.antlr.v4.Tool
    ANTLR Parser Generator Version 4.0
    -o ___ specify output directory where all output is generated
    -lib ___ specify location of .tokens files
    ...

Use alias antlr4

    $ alias antlr4='java -jar /usr/local/lib/antlr-4.0-complete.jar'

## CHAPTER 2 The Big Picture

### 2.1 Let’s Get Meta!

A language is a set of valid sentences, a sentence is made up of phrases, and a phrase is made up of subphrases and vocabulary symbols.

`Interpreter` - examples include calculators, configuration file readers, and Python interpreters.

`Translator` - Examples include Java to C# converters and compilers.

Programs that recognize languages are called parsers or syntax analyzers. Syntax refers to the rules governing language membership, and in this book we’re going to build ANTLR grammars to specify language syntax.

A grammar is just a set of rules, each one expressing the structure of a phrase.

The ANTLR tool translates grammars to parsers that look remarkably similar to what an experienced programmer might build by hand. (ANTLR is a program that writes other programs.) Grammars themselves follow the syntax of a language optimized for specifying other languages: ANTLR’s meta-language.

The process of grouping characters into words or symbols (tokens) is called **lexical analysis** or simply **tokenizing**. We call a program that tokenizes the input a **lexer**.

The lexer can group related tokens into token classes, or token types, such as INT (integers), ID (identifiers), FLOAT (floating-point numbers), and so on. The lexer groups vocabulary symbols into types when the parser cares only about the type, not the individual symbols.

**Tokens consist** of at least two pieces of information: the **token type** (identifying the lexical structure) and the **text** matched for that token by the lexer.

The second stage is the actual parser and feeds off of these tokens to recognize the **sentence structure**, in this case an assignment statement. By default, ANTLR-generated parsers build a data structure called a **parse tree** or **syntax tree** that records how the parser recognized the structure of the input sentence and its component phrases.

The **interior nodes** of the parse tree are **phrase names** that group and identify their children. The root node is the most abstract phrase name, in this case stat (short for “statement”). The **leaves** of a parse tree are always the **input tokens**. Sentences, linear sequences of symbols, are really just serializations of parse trees we humans grok natively in hardware. To get an idea across to someone, we have to conjure up the same parse tree in their heads using a word stream.

By producing a parse tree, a parser delivers a handy data structure to the rest of the application that contains complete information about how the parser grouped the symbols into phrases. Trees are easy to process in subsequent steps and are well understood by programmers. Better yet, the parser can generate parse trees automatically.

### 2.2 Implementing Parsers

The ANTLR tool generates **recursive-descent** parsers from grammar rules such as assign that we just saw. Recursive-descent parsers are really just a collection of **recursive methods, one per rule**. The **descent term** refers to the fact that parsing begins at the root of a parse tree and proceeds toward the leaves (tokens). The rule we invoke first, the start symbol, becomes the root of the parse tree. That would mean calling method `stat()` for the parse tree in the previous section. A more general term for this kind of parsing is **top-down** parsing; recursive-descent parsers are just one kind of top-down parser implementation.

To get an idea of what recursive-descent parsers look like, here’s the (slightly cleaned up) method that ANTLR generates for rule assign:

    // assign : ID '=' expr ';' ;
    void assign() { // method generated from rule assign
        match(ID); // compare ID to current input symbol then consume
        match('=');
        expr(); // match an expression by calling expr()
        match(';');
    }

The cool part about recursive-descent parsers is that the **call graph** traced out by invoking methods `stat()`, `assign()`, and `expr()` **mirrors** the **interior parse tree nodes**. (Take a quick peek back at the parse tree figure.) The calls to `match()` correspond to the parse tree leaves. To build a parse tree manually in a handbuilt parser, we’d insert “add new subtree root” operations at the start of each rule method and an “add new leaf node” operation to `match()`.

## CHAPTER 3 A Starter ANTLR Project

## CHAPTER 4 A Quick Tour

### 4.1 Matching an Arithmetic Expression Language

### 4.2 Building a Calculator Using a Visitor













