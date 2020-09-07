# [GNU make](https://www.gnu.org/software/make/manual/html_node/index.html)

- [GNU make](#gnu-make)
  - [1 Overview of make](#1-overview-of-make)
  - [2 An Introduction to Makefiles](#2-an-introduction-to-makefiles)
    - [2.1 What a Rule Looks Like](#21-what-a-rule-looks-like)
    - [2.2 A Simple Makefile](#22-a-simple-makefile)
    - [2.3 How `make` Processes a Makefile](#23-how-make-processes-a-makefile)
    - [2.4 Variables Make Makefiles Simpler](#24-variables-make-makefiles-simpler)
    - [2.5 Letting make Deduce the Recipes](#25-letting-make-deduce-the-recipes)
    - [2.6 Another Style of Makefile](#26-another-style-of-makefile)
    - [2.7 Rules for Cleaning the Directory](#27-rules-for-cleaning-the-directory)
  - [3 Writing Makefiles](#3-writing-makefiles)
    - [3.1 What Makefiles Contain](#31-what-makefiles-contain)
      - [3.1.1 Splitting Long Lines](#311-splitting-long-lines)
        - [Splitting Without Adding Whitespace](#splitting-without-adding-whitespace)
    - [3.2 What Name to Give Your Makefile](#32-what-name-to-give-your-makefile)
    - [3.3 Including Other Makefiles](#33-including-other-makefiles)
    - [3.4 The Variable MAKEFILES](#34-the-variable-makefiles)
    - [3.5 How Makefiles Are Remade](#35-how-makefiles-are-remade)
    - [3.6 Overriding Part of Another Makefile](#36-overriding-part-of-another-makefile)
    - [3.7 How make Reads a Makefile](#37-how-make-reads-a-makefile)
      - [Variable Assignment](#variable-assignment)
      - [Conditional Directives](#conditional-directives)
      - [Rule Definition](#rule-definition)
    - [3.8 How Makefiles Are Parsed](#38-how-makefiles-are-parsed)
    - [3.9 Secondary Expansion](#39-secondary-expansion)
  - [4 Writing Rules](#4-writing-rules)
    - [4.1 Rule Example](#41-rule-example)
    - [4.2 Rule Syntax](#42-rule-syntax)
    - [4.3 Types of Prerequisites](#43-types-of-prerequisites)
    - [4.4 Using Wildcard Characters in File Names](#44-using-wildcard-characters-in-file-names)
    - [10 Using Implicit Rules](#10-using-implicit-rules)

## [1 Overview of make](https://www.gnu.org/software/make/manual/html_node/Overview.html#Overview)

## [2 An Introduction to Makefiles](https://www.gnu.org/software/make/manual/html_node/Introduction.html#Introduction)

### 2.1 What a Rule Looks Like

A simple makefile consists of “rules” with the following shape:

    target … : prerequisites …
            recipe
            …
            …

### 2.2 A Simple Makefile

### 2.3 How `make` Processes a Makefile

By default, make starts with the first target (not targets whose names start with '.'). This is called the default goal.

make reads the makefile in the current directory and begins by processing the first rule.

### 2.4 Variables Make Makefiles Simpler

It is standard practice for every makefile to have a variable named objects, OBJECTS, objs, OBJS, obj, or OBJ which is a list of all object file names. We would define such a variable objects with a line like this in the makefile:

    objects = main.o kbd.o command.o display.o \
            insert.o search.o files.o utils.o

Then, each place we want to put a list of the object file names, we can substitute the variable’s value by writing '$(objects)' (see [How to Use Variables](https://www.gnu.org/software/make/manual/html_node/Using-Variables.html#Using-Variables)).

### 2.5 Letting make Deduce the Recipes

It is not necessary to spell out the recipes for compiling the individual C source files, because make can figure them out: it has an implicit rule for updating a '.o' file from a correspondingly named '.c' file using a 'cc -c' command. For example, it will use the recipe 'cc -c main.c -o main.o' to compile main.c into main.o. We can therefore omit the recipes from the rules for the object files. See [Using Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules).

When a '.c' file is used automatically in this way, it is also automatically added to the list of prerequisites. We can therefore omit the '.c' files from the prerequisites, provided we omit the recipe.

### 2.6 Another Style of Makefile

### 2.7 Rules for Cleaning the Directory

## [3 Writing Makefiles](https://www.gnu.org/software/make/manual/html_node/Makefiles.html#Makefiles)

### 3.1 What Makefiles Contain

Makefiles contain five kinds of things: explicit rules, implicit rules, variable definitions, directives, and comments.

- An explicit rule says when and how to remake one or more files, called the rule’s targets. It lists the other files that the targets depend on, called the prerequisites of the target, and may also give a recipe to use to create or update the targets. See [Writing Rules](https://www.gnu.org/software/make/manual/html_node/Rules.html#Rules).

- An implicit rule says when and how to remake a class of files based on their names. It describes how a target may depend on a file with a name similar to the target and gives a recipe to create or update such a target. See [Using Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules).

- A variable definition is a line that specifies a text string value for a variable that can be substituted into the text later. The simple makefile example shows a variable definition for objects as a list of all object files (see [Variables Make Makefiles Simpler](https://www.gnu.org/software/make/manual/html_node/Variables-Simplify.html#Variables-Simplify)).

- A directive is an instruction for make to do something special while reading the makefile. These include:

  - Reading another makefile (see [Including Other Makefiles](https://www.gnu.org/software/make/manual/html_node/Include.html#Include)).

  - Deciding (based on the values of variables) whether to use or ignore a part of the makefile (see [Conditional Parts of Makefiles](https://www.gnu.org/software/make/manual/html_node/Conditionals.html#Conditionals)).

  - Defining a variable from a verbatim string containing multiple lines (see [Defining Multi-Line Variables](https://www.gnu.org/software/make/manual/html_node/Multi_002dLine.html#Multi_002dLine)).

  - '#' in a line of a makefile starts a comment. It and the rest of the line are ignored, except that a trailing backslash not escaped by another backslash will continue the comment across multiple lines. A line containing just a comment (with perhaps spaces before it) is effectively blank, and is ignored. If you want a literal #, escape it with a backslash (e.g., \#). Comments may appear on any line in the makefile, although they are treated specially in certain situations.

    You cannot use comments within variable references or function calls: any instance of # will be treated literally (rather than as the start of a comment) inside a variable reference or function call.

    Comments within a recipe are passed to the shell, just as with any other recipe text. The shell decides how to interpret it: whether or not this is a comment is up to the shell.

    Within a define directive, comments are not ignored during the definition of the variable, but rather kept intact in the value of the variable. When the variable is expanded they will either be treated as make comments or as recipe text, depending on the context in which the variable is evaluated.

#### 3.1.1 Splitting Long Lines

Makefiles use a "line-based" syntax in which the newline character is special and marks the end of a statement. GNU make has no limit on the length of a statement line, up to the amount of memory in your computer.

The way in which backslash/newline combinations are handled depends on whether the statement is a recipe line or a non-recipe line. Handling of backslash/newline in a recipe line is discussed later (see [Splitting Recipe Lines](https://www.gnu.org/software/make/manual/html_node/Splitting-Recipe-Lines.html#Splitting-Recipe-Lines)).

Outside of recipe lines, backslash/newlines are converted into a single space character. Once that is done, all whitespace around the backslash/newline is condensed into a single space: this includes all whitespace preceding the backslash, all whitespace at the beginning of the line after the backslash/newline, and any consecutive backslash/newline combinations.

##### Splitting Without Adding Whitespace

If you need to split a line but do not want any whitespace added, you can utilize a subtle trick: replace your backslash/newline pairs with the three characters dollar sign/backslash/newline:

    var := one$\
        word

After make removes the backslash/newline and condenses the following line into a single space, this is equivalent to:

    var := one$ word

Then make will perform variable expansion. The variable reference '$ ' refers to a variable with the one-character name " " (space) which does not exist, and so expands to the empty string, giving a final assignment which is the equivalent of:

    var := oneword

### 3.2 What Name to Give Your Makefile

By default, when make looks for the makefile, it tries the following names, in order: GNUmakefile, makefile and Makefile.

### 3.3 Including Other Makefiles

The include directive tells make to suspend reading the current makefile and read one or more other makefiles before continuing. The directive is a line in the makefile that looks like this:

    include filenames…

filenames can contain shell file name patterns. If filenames is empty, nothing is included and no error is printed.

If the file names contain any variable or function references, they are expanded.

For example, if you have three .mk files, a.mk, b.mk, and c.mk, and $(bar) expands to bish bash, then the following expression

    include foo *.mk $(bar)

is equivalent to

    include foo a.mk b.mk c.mk bish bash

Another such occasion is when you want to generate prerequisites from source files automatically; the prerequisites can be put in a file that is included by the main makefile. This practice is generally cleaner than that of somehow appending the prerequisites to the end of the main makefile as has been traditionally done with other versions of make. See [Automatic Prerequisites](https://www.gnu.org/software/make/manual/html_node/Automatic-Prerequisites.html#Automatic-Prerequisites).

If the specified name does not start with a slash, and the file is not found in the current directory, several other directories are searched. First, any directories you have specified with the '-I' or '--include-dir' option are searched (see Summary of Options). Then the following directories (if they exist) are searched, in this order: prefix/include (normally /usr/local/include 1) /usr/gnu/include, /usr/local/include, /usr/include.

### 3.4 The Variable MAKEFILES

If the environment variable MAKEFILES is defined, make considers its value as a list of names (separated by whitespace) of additional makefiles to be read before the others.

### 3.5 How Makefiles Are Remade

Sometimes makefiles can be remade from other files, such as RCS or SCCS files. If a makefile can be remade from other files, you probably want make to get an up-to-date version of the makefile to read in.

### 3.6 Overriding Part of Another Makefile

### 3.7 How make Reads a Makefile

GNU make does its work in two distinct phases. During the first phase it reads all the makefiles, included makefiles, etc. and internalizes all the variables and their values and implicit and explicit rules, and builds a dependency graph of all the targets and their prerequisites. During the second phase, make uses this internalized data to determine which targets need to be updated and run the recipes necessary to update them.

We say that expansion is **immediate** if it happens during the first phase: make will expand that part of the construct as the makefile is parsed. We say that expansion is deferred if it is not immediate. Expansion of a **deferred** construct part is delayed until the expansion is used: either when it is referenced in an immediate context, or when it is needed during the second phase.

#### Variable Assignment

Variable definitions are parsed as follows:

    immediate = deferred
    immediate ?= deferred
    immediate := immediate
    immediate ::= immediate
    immediate += deferred or immediate
    immediate != immediate

    define immediate
      deferred
    endef

    define immediate =
      deferred
    endef

    define immediate ?=
      deferred
    endef

    define immediate :=
      immediate
    endef

    define immediate ::=
      immediate
    endef

    define immediate +=
      deferred or immediate
    endef

    define immediate !=
      immediate
    endef

#### Conditional Directives

Conditional directives are parsed immediately. This means, for example, that automatic variables cannot be used in conditional directives, as automatic variables are not set until the recipe for that rule is invoked. If you need to use automatic variables in a conditional directive you must move the condition into the recipe and use shell conditional syntax instead.

#### Rule Definition

A rule is always expanded the same way, regardless of the form:

    immediate : immediate ; deferred
            deferred

That is, the target and prerequisite sections are expanded immediately, and the recipe used to build the target is always deferred. This is true for explicit rules, pattern rules, suffix rules, static pattern rules, and simple prerequisite definitions.

### 3.8 How Makefiles Are Parsed

GNU make parses makefiles line-by-line. Parsing proceeds using the following steps:

1. Read in a full logical line, including backslash-escaped lines

2. Remove comments

3. If the line begins with the recipe prefix character and we are in a rule context, add the line to the current recipe and read the next line (see [Recipe Syntax](https://www.gnu.org/software/make/manual/html_node/Recipe-Syntax.html#Recipe-Syntax)).

4. Expand elements of the line which appear in an immediate expansion context (see [How make Reads a Makefile](https://www.gnu.org/software/make/manual/html_node/Reading-Makefiles.html#Reading-Makefiles)).

5. Scan the line for a separator character, such as ':' or '=', to determine whether the line is a macro assignment or a rule (see [Recipe Syntax](https://www.gnu.org/software/make/manual/html_node/Recipe-Syntax.html#Recipe-Syntax)).

6. Internalize the resulting operation and read the next line.

### 3.9 Secondary Expansion

## [4 Writing Rules](https://www.gnu.org/software/make/manual/html_node/Rules.html#Rules)

The order of rules is not significant, except for determining the default goal: the target for make to consider, if you do not otherwise specify one. The default goal is the target of the first rule in the first makefile. If the first rule has multiple targets, only the first target is taken as the default. There are two exceptions: a target starting with a period is not a default unless it contains one or more slashes, '/', as well; and, a target that defines a pattern rule has no effect on the default goal. (See [Defining and Redefining Pattern Rules](https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html#Pattern-Rules).)

Therefore, we usually write the makefile so that the first rule is the one for compiling the entire program or all the programs described by the makefile (often with a target called ‘all’). See [Arguments to Specify the Goals](https://www.gnu.org/software/make/manual/html_node/Goals.html#Goals).

### 4.1 Rule Example

    foo.o : foo.c defs.h       # module for twiddling the frobs
            cc -c -g foo.c

This rule says two things:

- How to decide whether foo.o is out of date: it is out of date if it does not exist, or if either foo.c or defs.h is more recent than it.

- How to update the file foo.o: by running cc as stated. The recipe does not explicitly mention defs.h, but we presume that foo.c includes it, and that is why defs.h was added to the prerequisites.

### 4.2 Rule Syntax

In general, a rule looks like this:

    targets : prerequisites
            recipe
            …

or like this:

    targets : prerequisites ; recipe
            recipe
            …

The targets are file names, separated by spaces. Wildcard characters may be used (see [Using Wildcard Characters in File Names](https://www.gnu.org/software/make/manual/html_node/Wildcards.html#Wildcards)) and a name of the form a(m) represents member m in archive file a (see [Archive Members as Targets](https://www.gnu.org/software/make/manual/html_node/Archive-Members.html#Archive-Members)). Usually there is only one target per rule, but occasionally there is a reason to have more (see [Multiple Targets in a Rule](https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html#Multiple-Targets)).

The recipe lines start with a tab character (or the first character in the value of the .RECIPEPREFIX variable; see [Special Variables](https://www.gnu.org/software/make/manual/html_node/Special-Variables.html#Special-Variables)). The first recipe line may appear on the line after the prerequisites, with a tab character, or may appear on the same line, with a semicolon. Either way, the effect is the same. There are other differences in the syntax of recipes. See [Writing Recipes in Rules](https://www.gnu.org/software/make/manual/html_node/Recipes.html#Recipes).

Because dollar signs are used to start make variable references, if you really want a dollar sign in a target or prerequisite you must write two of them, '$$' (see [How to Use Variables](https://www.gnu.org/software/make/manual/html_node/Using-Variables.html#Using-Variables)). If you have enabled secondary expansion (see [Secondary Expansion](https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html#Secondary-Expansion)) and you want a literal dollar sign in the prerequisites list, you must actually write four dollar signs ('$$$$').

The criterion for being out of date is specified in terms of the prerequisites, which consist of file names separated by spaces. (Wildcards and archive members (see [Archives](https://www.gnu.org/software/make/manual/html_node/Archives.html#Archives)) are allowed here too.) A target is out of date if it does not exist or if it is older than any of the prerequisites (by comparison of last-modification times). The idea is that the contents of the target file are computed based on information in the prerequisites, so if any of the prerequisites changes, the contents of the existing target file are no longer necessarily valid.

How to update is specified by a recipe. This is one or more lines to be executed by the shell (normally ‘sh’), but with some extra features (see [Writing Recipes in Rules](https://www.gnu.org/software/make/manual/html_node/Recipes.html#Recipes)).

### 4.3 Types of Prerequisites

There are actually two different types of prerequisites understood by GNU make: normal prerequisites such as described in the previous section, and order-only prerequisites. A normal prerequisite makes two statements: first, it imposes an order in which recipes will be invoked: the recipes for all prerequisites of a target will be completed before the recipe for the target is run. Second, it imposes a dependency relationship: if any prerequisite is newer than the target, then the target is considered out-of-date and must be rebuilt.

Normally, this is exactly what you want: if a target’s prerequisite is updated, then the target should also be updated.

Occasionally, however, you have a situation where you want to impose a specific ordering on the rules to be invoked without forcing the target to be updated if one of those rules is executed. In that case, you want to define order-only prerequisites. Order-only prerequisites can be specified by placing a pipe symbol (|) in the prerequisites list: any prerequisites to the left of the pipe symbol are normal; any prerequisites to the right are order-only:

    targets : normal-prerequisites | order-only-prerequisites

The normal prerequisites section may of course be empty. Also, you may still declare multiple lines of prerequisites for the same target: they are appended appropriately (normal prerequisites are appended to the list of normal prerequisites; order-only prerequisites are appended to the list of order-only prerequisites). Note that if you declare the same file to be both a normal and an order-only prerequisite, the normal prerequisite takes precedence (since they have a strict superset of the behavior of an order-only prerequisite).

Consider an example where your targets are to be placed in a separate directory, and that directory might not exist before make is run. In this situation, you want the directory to be created before any targets are placed into it but, because the timestamps on directories change whenever a file is added, removed, or renamed, we certainly don’t want to rebuild all the targets whenever the directory’s timestamp changes. One way to manage this is with order-only prerequisites: make the directory an order-only prerequisite on all the targets:

    OBJDIR := objdir
    OBJS := $(addprefix $(OBJDIR)/,foo.o bar.o baz.o)

    $(OBJDIR)/%.o : %.c
            $(COMPILE.c) $(OUTPUT_OPTION) $<

    all: $(OBJS)

    $(OBJS): | $(OBJDIR)

    $(OBJDIR):
            mkdir $(OBJDIR)

Now the rule to create the objdir directory will be run, if needed, before any '.o' is built, but no '.o' will be built because the objdir directory timestamp changed.

### 4.4 Using Wildcard Characters in File Names









### [10 Using Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules)























