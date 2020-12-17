# antrl tutorial

- [antrl tutorial](#antrl-tutorial)
  - [Getting started with ANTLR](#getting-started-with-antlr)
    - [Remarks](#remarks)
      - [Antlr Versions](#antlr-versions)
      - [Runtime Libraries and Code Generation Targets](#runtime-libraries-and-code-generation-targets)
    - [Hello world](#hello-world)
  - [ANTLR Targets/Language Runtimes Related Examples](#antlr-targetslanguage-runtimes-related-examples)

## [Getting started with ANTLR](https://riptutorial.com/antlr)

### Remarks

ANTLR (ANother Tool for Language Recognition) is a powerful parser generator for reading, processing, executing, or translating structured text or binary files. It's widely used to build languages, tools, and frameworks. From a grammar, ANTLR generates a parser that can build and walk parse trees.

#### Antlr Versions

Antlr is separated in two big parts, the **grammar** (grammar files) and the **generated code files**, which derive from the grammar based on target language. The antlr versions are in the format of V1.V2.V3 :

- V1: Change in V1 means that new syntax of features were introduced in grammar files
- V2: Change in V2 means that new features or major fixes were introduced in the generated files (e.g addition of new functions)
- V3: stands for bug fixes or minor improvements

#### Runtime Libraries and Code Generation Targets

The Antlr tool is written in Java, however it is able to generate parsers and lexers in various languages. To run the parser and lexer you will also need having the runtime library of antlr alongside with the parser and lexer code. The supported target language (and runtime libraries) are the following:

Java

C#

Python (2 and 3)

JavaScript

### Hello world

A simple hello world grammar can be found [here](https://gist.github.com/mattmcd/5425206):

    // define a grammar called Hello
    grammar Hello;
    r   : 'hello' ID;
    ID  : [a-z]+ ;
    WS  : [ \t\r\n]+ -> skip ;

To build this .g4 sample you can run the following command from your operating systems terminal/command-line:

    Java -jar antlr-4.5.3-complete.jar Hello.g4

    //OR if you have setup an alias or use the recommended batch file

    antlr4 Hello.g4

Building this example should result in the following output in the Hello.g4 file directory:

- Hello.tokens
- HelloBaseListener.java
- HelloLexer.java
- HelloLexer.tokens
- HelloListener.java
- HelloParser.java

When using these files in your own project be sure to include the ANTLR jar file. To compile all of these files using Java, in the same operating directory or by path run the following command:

    javac *.java

## [ANTLR Targets/Language Runtimes Related Examples](https://riptutorial.com/antlr/topic/3414/antlr-targets-language-runtimes)

...