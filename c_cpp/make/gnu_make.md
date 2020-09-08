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
      - [4.4.1 Wildcard Examples](#441-wildcard-examples)
      - [4.4.2 Pitfalls of Using Wildcards](#442-pitfalls-of-using-wildcards)
      - [4.4.3 The Function wildcard](#443-the-function-wildcard)
    - [4.5 Searching Directories for Prerequisites](#45-searching-directories-for-prerequisites)
      - [4.5.1 VPATH: Search Path for All Prerequisites](#451-vpath-search-path-for-all-prerequisites)
      - [4.5.2 The vpath Directive](#452-the-vpath-directive)
      - [4.5.3 How Directory Searches are Performed](#453-how-directory-searches-are-performed)
      - [4.5.4 Writing Recipes with Directory Search](#454-writing-recipes-with-directory-search)
      - [4.5.5 Directory Search and Implicit Rules](#455-directory-search-and-implicit-rules)
      - [4.5.6 Directory Search for Link Libraries](#456-directory-search-for-link-libraries)
    - [4.6 Phony Targets](#46-phony-targets)
    - [4.7 Rules without Recipes or Prerequisites](#47-rules-without-recipes-or-prerequisites)
    - [4.8 Empty Target Files to Record Events](#48-empty-target-files-to-record-events)
    - [4.9 Special Built-in Target Names](#49-special-built-in-target-names)
    - [4.10 Multiple Targets in a Rule](#410-multiple-targets-in-a-rule)
      - [Rules with Independent Targets](#rules-with-independent-targets)
      - [Rules with Grouped Targets](#rules-with-grouped-targets)
    - [4.11 Multiple Rules for One Target](#411-multiple-rules-for-one-target)
    - [4.12 Static Pattern Rules](#412-static-pattern-rules)
      - [4.12.1 Syntax of Static Pattern Rules](#4121-syntax-of-static-pattern-rules)
      - [4.12.2 Static Pattern Rules versus Implicit Rules](#4122-static-pattern-rules-versus-implicit-rules)
    - [4.13 Double-Colon Rules](#413-double-colon-rules)
    - [4.14 Generating Prerequisites Automatically](#414-generating-prerequisites-automatically)
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

A single file name can specify many files using wildcard characters. The wildcard characters in make are '\*', '?' and '[…]', the same as in the Bourne shell. For example, *.c specifies a list of all the files (in the working directory) whose names end in '.c'.

The character `~` at the beginning of a file name also has special significance. If alone, or followed by a slash, it represents your home directory. For example ~/bin expands to /home/you/bin. If the `~` is followed by a word, the string represents the home directory of the user named by that word. For example ~john/bin expands to /home/john/bin. On systems which don’t have a home directory for each user (such as MS-DOS or MS-Windows), this functionality can be simulated by setting the environment variable HOME.

Wildcard expansion is performed by make automatically in targets and in prerequisites. In recipes, the shell is responsible for wildcard expansion. In other contexts, wildcard expansion happens only if you request it explicitly with the wildcard function.

The special significance of a wildcard character can be turned off by preceding it with a backslash. Thus, foo\*bar would refer to a specific file whose name consists of ‘foo’, an asterisk, and 'bar'.

#### 4.4.1 Wildcard Examples

Wildcards can be used in the recipe of a rule, where they are expanded by the shell. For example, here is a rule to delete all the object files:

    clean:
            rm -f *.o

Wildcards are also useful in the prerequisites of a rule. With the following rule in the makefile, 'make print' will print all the '.c' files that have changed since the last time you printed them:

    print: *.c
            lpr -p $?
            touch print

This rule uses print as an empty target file; see [Empty Target Files to Record Events](https://www.gnu.org/software/make/manual/html_node/Empty-Targets.html#Empty-Targets). (The automatic variable '$?' is used to print only those files that have changed; see [Automatic Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables).)

Wildcard expansion does not happen when you define a variable. Thus, if you write this:

    objects = *.o

then the value of the variable objects is the actual string '*.o'. However, if you use the value of objects in a target or prerequisite, wildcard expansion will take place there. If you use the value of objects in a recipe, the shell may perform wildcard expansion when the recipe runs. To set objects to the expansion, instead use:

    objects := $(wildcard *.o)

#### 4.4.2 Pitfalls of Using Wildcards

Now here is an example of a naive way of using wildcard expansion, that does not do what you would intend. Suppose you would like to say that the executable file foo is made from all the object files in the directory, and you write this:

    objects = *.o

    foo : $(objects)
            cc -o foo $(CFLAGS) $(objects)

The value of objects is the actual string '*.o'. Wildcard expansion happens in the rule for foo, so that each existing '.o' file becomes a prerequisite of foo and will be recompiled if necessary.

But what if you delete all the '.o' files? When a wildcard matches no files, it is left as it is, so then foo will depend on the oddly-named file \*.o. Since no such file is likely to exist, make will give you an error saying it cannot figure out how to make \*.o. This is not what you want!

Actually it is possible to obtain the desired result with wildcard expansion, but you need more sophisticated techniques, including the wildcard function and string substitution. See [The Function wildcard](https://www.gnu.org/software/make/manual/html_node/Wildcard-Pitfall.html).

Microsoft operating systems (MS-DOS and MS-Windows) use backslashes to separate directories in pathnames, like so:

    c:\foo\bar\baz.c

This is equivalent to the Unix-style c:/foo/bar/baz.c (the c: part is the so-called drive letter). When make runs on these systems, it supports backslashes as well as the Unix-style forward slashes in pathnames. However, this support does not include the wildcard expansion, where backslash is a quote character. Therefore, you must use Unix-style slashes in these cases.

#### 4.4.3 The Function wildcard

Wildcard expansion happens automatically in rules. But wildcard expansion does not normally take place when a variable is set, or inside the arguments of a function. If you want to do wildcard expansion in such places, you need to use the wildcard function, like this:

    $(wildcard pattern…)

This string, used anywhere in a makefile, is replaced by a space-separated list of names of existing files that match one of the given file name patterns. If no existing file name matches a pattern, then that pattern is omitted from the output of the wildcard function.

One use of the wildcard function is to get a list of all the C source files in a directory, like this:

    $(wildcard *.c)

We can change the list of C source files into a list of object files by replacing the '.c' suffix with '.o' in the result, like this:

    $(patsubst %.c,%.o,$(wildcard *.c))

Thus, a makefile to compile all C source files in the directory and then link them together could be written as follows:

    objects := $(patsubst %.c,%.o,$(wildcard *.c))

    foo : $(objects)
            cc -o foo $(objects)

(This takes advantage of the implicit rule for compiling C programs, so there is no need to write explicit rules for compiling the files. See [The Two Flavors of Variables](https://www.gnu.org/software/make/manual/html_node/Flavors.html#Flavors), for an explanation of ':=', which is a variant of '='.)

### 4.5 Searching Directories for Prerequisites

For large systems, it is often desirable to put sources in a separate directory from the binaries. The directory search features of make facilitate this by searching several directories automatically to find a prerequisite. When you redistribute the files among directories, you do not need to change the individual rules, just the search paths.

#### 4.5.1 VPATH: Search Path for All Prerequisites

The value of the make variable VPATH specifies a list of directories that make should search. Most often, the directories are expected to contain prerequisite files that are not in the current directory; however, make uses VPATH as a search list for both prerequisites and targets of rules.

In the VPATH variable, directory names are separated by colons or blanks. The order in which directories are listed is the order followed by make in its search. (On MS-DOS and MS-Windows, semi-colons are used as separators of directory names in VPATH, since the colon can be used in the pathname itself, after the drive letter.)

For example,

    VPATH = src:../headers

specifies a path containing two directories, src and ../headers, which make searches in that order.

With this value of VPATH, the following rule,

    foo.o : foo.c

is interpreted as if it were written like this:

    foo.o : src/foo.c

assuming the file foo.c does not exist in the current directory but is found in the directory src.

#### 4.5.2 The vpath Directive

Similar to the VPATH variable, but more selective, is the vpath directive (note lower case), which allows you to specify a search path for a particular class of file names: those that match a particular pattern. Thus you can supply certain search directories for one class of file names and other directories (or none) for other file names.

There are three forms of the vpath directive:

- `vpath pattern directories`

  Specify the search path directories for file names that match pattern.

  The search path, directories, is a list of directories to be searched, separated by colons (semi-colons on MS-DOS and MS-Windows) or blanks, just like the search path used in the VPATH variable.

- `vpath pattern`

  Clear out the search path associated with pattern.

- `vpath`

  Clear all search paths previously specified with vpath directives.

A vpath pattern is a string containing a '%' character. The string must match the file name of a prerequisite that is being searched for, the '%' character matching any sequence of zero or more characters (as in pattern rules; see [Defining and Redefining Pattern Rules](https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html#Pattern-Rules)). For example, %.h matches files that end in .h. (If there is no '%', the pattern must match the prerequisite exactly, which is not useful very often.)

'%' characters in a vpath directive’s pattern can be quoted with preceding backslashes ('\'). Backslashes that would otherwise quote '%' characters can be quoted with more backslashes. Backslashes that quote '%' characters or other backslashes are removed from the pattern before it is compared to file names. Backslashes that are not in danger of quoting '%' characters go unmolested.

When a prerequisite fails to exist in the current directory, if the pattern in a vpath directive matches the name of the prerequisite file, then the directories in that directive are searched just like (and before) the directories in the VPATH variable.

For example,

    vpath %.h ../headers

tells make to look for any prerequisite whose name ends in .h in the directory ../headers if the file is not found in the current directory.

If several vpath patterns match the prerequisite file’s name, then make processes each matching vpath directive one by one, searching all the directories mentioned in each directive. make handles multiple vpath directives in the order in which they appear in the makefile; multiple directives with the same pattern are independent of each other.

Thus,

    vpath %.c foo
    vpath %   blish
    vpath %.c bar

will look for a file ending in ‘.c’ in foo, then blish, then bar, while

    vpath %.c foo:bar
    vpath %   blish

will look for a file ending in ‘.c’ in foo, then bar, then blish.

#### 4.5.3 How Directory Searches are Performed

When a prerequisite is found through directory search, regardless of type (general or selective), the pathname located may not be the one that make actually provides you in the prerequisite list. Sometimes the path discovered through directory search is thrown away.

The algorithm make uses to decide whether to keep or abandon a path found via directory search is as follows:

1. If a target file does not exist at the path specified in the makefile, directory search is performed.

2. If the directory search is successful, that path is kept and this file is tentatively stored as the target.

3. All prerequisites of this target are examined using this same method.

4. After processing the prerequisites, the target may or may not need to be rebuilt:

   1. If the target does not need to be rebuilt, the path to the file found during directory search is used for any prerequisite lists which contain this target. In short, if make doesn’t need to rebuild the target then you use the path found via directory search.

   2. If the target does need to be rebuilt (is out-of-date), the pathname found during directory search is thrown away, and the target is rebuilt using the file name specified in the makefile. In short, if make must rebuild, then the target is rebuilt locally, not in the directory found via directory search.

This algorithm may seem complex, but in practice it is quite often exactly what you want.

Other versions of make use a simpler algorithm: if the file does not exist, and it is found via directory search, then that pathname is always used whether or not the target needs to be built. Thus, if the target is rebuilt it is created at the pathname discovered during directory search.

If, in fact, this is the behavior you want for some or all of your directories, you can use the GPATH variable to indicate this to make.

GPATH has the same syntax and format as VPATH (that is, a space- or colon-delimited list of pathnames). If an out-of-date target is found by directory search in a directory that also appears in GPATH, then that pathname is not thrown away. The target is rebuilt using the expanded path.

#### 4.5.4 Writing Recipes with Directory Search

When a prerequisite is found in another directory through directory search, this cannot change the recipe of the rule; they will execute as written. Therefore, you must write the recipe with care so that it will look for the prerequisite in the directory where make finds it.

This is done with the automatic variables such as '$^' (see [Automatic Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables)). For instance, the value of '$^' is a list of all the prerequisites of the rule, including the names of the directories in which they were found, and the value of '$@' is the target. Thus:

    foo.o : foo.c
            cc -c $(CFLAGS) $^ -o $@

(The variable CFLAGS exists so you can specify flags for C compilation by implicit rules; we use it here for consistency so it will affect all C compilations uniformly; see [Variables Used by Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html#Implicit-Variables).)

Often the prerequisites include header files as well, which you do not want to mention in the recipe. The automatic variable ‘$<’ is just the first prerequisite:

    VPATH = src:../headers
    foo.o : foo.c defs.h hack.h
            cc -c $(CFLAGS) $< -o $@

#### 4.5.5 Directory Search and Implicit Rules

The search through the directories specified in VPATH or with vpath also happens during consideration of implicit rules (see [Using Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules)).

For example, when a file foo.o has no explicit rule, make considers implicit rules, such as the built-in rule to compile foo.c if that file exists. If such a file is lacking in the current directory, the appropriate directories are searched for it. If foo.c exists (or is mentioned in the makefile) in any of the directories, the implicit rule for C compilation is applied.

The recipes of implicit rules normally use automatic variables as a matter of necessity; consequently they will use the file names found by directory search with no extra effort.

#### 4.5.6 Directory Search for Link Libraries

Directory search applies in a special way to libraries used with the linker. This special feature comes into play when you write a prerequisite whose name is of the form '-lname'. (You can tell something strange is going on here because the prerequisite is normally the name of a file, and the file name of a library generally looks like libname.a, not like '-lname'.)

When a prerequisite’s name has the form '-lname', make handles it specially by searching for the file libname.so, and, if it is not found, for the file libname.a in the current directory, in directories specified by matching vpath search paths and the VPATH search path, and then in the directories /lib, /usr/lib, and prefix/lib (normally /usr/local/lib, but MS-DOS/MS-Windows versions of make behave as if prefix is defined to be the root of the DJGPP installation tree).

For example, if there is a /usr/lib/libcurses.a library on your system (and no /usr/lib/libcurses.so file), then

    foo : foo.c -lcurses
            cc $^ -o $@

would cause the command 'cc foo.c /usr/lib/libcurses.a -o foo' to be executed when foo is older than foo.c or than /usr/lib/libcurses.a.

Although the default set of files to be searched for is libname.so and libname.a, this is customizable via the .LIBPATTERNS variable. Each word in the value of this variable is a pattern string. When a prerequisite like '-lname' is seen, make will replace the percent in each pattern in the list with name and perform the above directory searches using each library file name.

The default value for .LIBPATTERNS is 'lib%.so lib%.a', which provides the default behavior described above.

You can turn off link library expansion completely by setting this variable to an empty value.

### 4.6 Phony Targets

A phony target is one that is not really the name of a file; rather it is just a name for a recipe to be executed when you make an explicit request. There are two reasons to use a phony target: to avoid a conflict with a file of the same name, and to improve performance.

If you write a rule whose recipe will not create the target file, the recipe will be executed every time the target comes up for remaking. Here is an example:

    clean:
            rm *.o temp

Because the rm command does not create a file named clean, probably no such file will ever exist. Therefore, the rm command will be executed every time you say 'make clean'.

In this example, the clean target will not work properly if a file named clean is ever created in this directory. Since it has no prerequisites, clean would always be considered up to date and its recipe would not be executed. To avoid this problem you can explicitly declare the target to be phony by making it a prerequisite of the special target .PHONY (see [Special Built-in Target Names](https://www.gnu.org/software/make/manual/html_node/Special-Targets.html#Special-Targets)) as follows:

    .PHONY: clean
    clean:
            rm *.o temp

Once this is done, 'make clean' will run the recipe regardless of whether there is a file named clean.

Phony targets are also useful in conjunction with recursive invocations of make (see Recursive Use of make). In this situation the makefile will often contain a variable which lists a number of sub-directories to be built. A simplistic way to handle this is to define one rule with a recipe that loops over the sub-directories, like this:

    SUBDIRS = foo bar baz

    subdirs:
            for dir in $(SUBDIRS); do \
              $(MAKE) -C $$dir; \
            done

There are problems with this method, however. First, any error detected in a sub-make is ignored by this rule, so it will continue to build the rest of the directories even when one fails. This can be overcome by adding shell commands to note the error and exit, but then it will do so even if make is invoked with the -k option, which is unfortunate. Second, and perhaps more importantly, you cannot take advantage of make’s ability to build targets in parallel (see [Parallel Execution](https://www.gnu.org/software/make/manual/html_node/Parallel.html#Parallel)), since there is only one rule.

By declaring the sub-directories as .PHONY targets (you must do this as the sub-directory obviously always exists; otherwise it won’t be built) you can remove these problems:

    SUBDIRS = foo bar baz

    .PHONY: subdirs $(SUBDIRS)

    subdirs: $(SUBDIRS)

    $(SUBDIRS):
            $(MAKE) -C $@

    foo: baz

Here we've also declared that the foo sub-directory cannot be built until after the baz sub-directory is complete; this kind of relationship declaration is particularly important when attempting parallel builds.

The implicit rule search (see [Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules)) is skipped for .PHONY targets. This is why declaring a target as .PHONY is good for performance, even if you are not worried about the actual file existing.

A phony target should not be a prerequisite of a real target file; if it is, its recipe will be run every time make goes to update that file. As long as a phony target is never a prerequisite of a real target, the phony target recipe will be executed only when the phony target is a specified goal (see [Arguments to Specify the Goals](https://www.gnu.org/software/make/manual/html_node/Goals.html#Goals)).

Phony targets can have prerequisites. When one directory contains multiple programs, it is most convenient to describe all of the programs in one makefile ./Makefile. Since the target remade by default will be the first one in the makefile, it is common to make this a phony target named 'all' and give it, as prerequisites, all the individual programs. For example:

    all : prog1 prog2 prog3
    .PHONY : all

    prog1 : prog1.o utils.o
            cc -o prog1 prog1.o utils.o

    prog2 : prog2.o
            cc -o prog2 prog2.o

    prog3 : prog3.o sort.o utils.o
            cc -o prog3 prog3.o sort.o utils.o

Now you can say just 'make' to remake all three programs, or specify as arguments the ones to remake (as in 'make prog1 prog3'). Phoniness is not inherited: the prerequisites of a phony target are not themselves phony, unless explicitly declared to be so.

When one phony target is a prerequisite of another, it serves as a subroutine of the other. For example, here ‘make cleanall’ will delete the object files, the difference files, and the file program:

    .PHONY: cleanall cleanobj cleandiff

    cleanall : cleanobj cleandiff
            rm program

    cleanobj :
            rm *.o

    cleandiff :
            rm *.diff

### 4.7 Rules without Recipes or Prerequisites

If a rule has no prerequisites or recipe, and the target of the rule is a nonexistent file, then make imagines this target to have been updated whenever its rule is run. This implies that all targets depending on this one will always have their recipe run.

An example will illustrate this:

    clean: FORCE
            rm $(objects)
    FORCE:

Here the target 'FORCE' satisfies the special conditions, so the target clean that depends on it is forced to run its recipe. There is nothing special about the name 'FORCE', but that is one name commonly used this way.

As you can see, using 'FORCE' this way has the same results as using '.PHONY: clean'.

Using '.PHONY' is more explicit and more efficient. However, other versions of make do not support '.PHONY'; thus 'FORCE' appears in many makefiles. See Phony Targets.

### 4.8 Empty Target Files to Record Events

The empty target is a variant of the phony target; it is used to hold recipes for an action that you request explicitly from time to time. Unlike a phony target, this target file can really exist; but the file’s contents do not matter, and usually are empty.

The purpose of the empty target file is to record, with its last-modification time, when the rule's recipe was last executed. It does so because one of the commands in the recipe is a touch command to update the target file.

The empty target file should have some prerequisites (otherwise it doesn't make sense). When you ask to remake the empty target, the recipe is executed if any prerequisite is more recent than the target; in other words, if a prerequisite has changed since the last time you remade the target. Here is an example:

    print: foo.c bar.c
            lpr -p $?
            touch print

With this rule, 'make print' will execute the lpr command if either source file has changed since the last 'make print'. The automatic variable '$?' is used to print only those files that have changed (see [Automatic Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables)).

### [4.9 Special Built-in Target Names](https://www.gnu.org/software/make/manual/html_node/Special-Targets.html#Special-Targets)

### 4.10 Multiple Targets in a Rule

When an explicit rule has multiple targets they can be treated in one of two possible ways: as independent targets or as grouped targets. The manner in which they are treated is determined by the separator that appears after the list of targets.

#### Rules with Independent Targets

Rules that use the standard target separator, :, define independent targets. This is equivalent to writing the same rule once for each target, with duplicated prerequisites and recipes. Typically, the recipe would use automatic variables such as '$@' to specify which target is being built.

- You want just prerequisites, no recipe. For example:

      kbd.o command.o files.o: command.h

  gives an additional prerequisite to each of the three object files mentioned. It is equivalent to writing:

      kbd.o: command.h
      command.o: command.h
      files.o: command.h

- Similar recipes work for all the targets. The automatic variable '$@' can be used to substitute the particular target to be remade into the commands (see Automatic Variables). For example:

      bigoutput littleoutput : text.g
              generate text.g -$(subst output,,$@) > $@

  is equivalent to

      bigoutput : text.g
              generate text.g -big > bigoutput

      littleoutput : text.g
              generate text.g -little > littleoutput

  Here we assume the hypothetical program generate makes two types of output, one if given '-big' and one if given '-little'. See [Functions for String Substitution and Analysis](https://www.gnu.org/software/make/manual/html_node/Text-Functions.html#Text-Functions), for an explanation of the subst function.

Suppose you would like to vary the prerequisites according to the target, much as the variable '$@' allows you to vary the recipe. You cannot do this with multiple targets in an ordinary rule, but you can do it with a static pattern rule. See [Static Pattern Rules](https://www.gnu.org/software/make/manual/html_node/Static-Pattern.html#Static-Pattern).

#### Rules with Grouped Targets

If instead of independent targets you have a recipe that generates multiple files from a single invocation, you can express that relationship by declaring your rule to use grouped targets. A grouped target rule uses the separator &: (the '&' here is used to imply "all").

When make builds any one of the grouped targets, it understands that all the other targets in the group are also created as a result of the invocation of the recipe. Furthermore, if only some of the grouped targets are out of date or missing make will realize that running the recipe will update all of the targets.

As an example, this rule defines a grouped target:

    foo bar biz &: baz boz
            echo $^ > foo
            echo $^ > bar
            echo $^ > biz

During the execution of a grouped target's recipe, the automatic variable '$@' is set to the name of the particular target in the group which triggered the rule. Caution must be used if relying on this variable in the recipe of a grouped target rule.

Unlike independent targets, a grouped target rule must include a recipe. However, targets that are members of a grouped target may also appear in independent target rule definitions that do not have recipes.

Each target may have only one recipe associated with it. If a grouped target appears in either an independent target rule or in another grouped target rule with a recipe, you will get a warning and the latter recipe will replace the former recipe. Additionally the target will be removed from the previous group and appear only in the new group.

If you would like a target to appear in multiple groups, then you must use the double-colon grouped target separator, &:: when declaring all of the groups containing that target. Grouped double-colon targets are each considered independently, and each grouped double-colon rule's recipe is executed at most once, if at least one of its multiple targets requires updating.

### 4.11 Multiple Rules for One Target

One file can be the target of several rules. All the prerequisites mentioned in all the rules are merged into one list of prerequisites for the target. If the target is older than any prerequisite from any rule, the recipe is executed.

There can only be one recipe to be executed for a file. If more than one rule gives a recipe for the same file, make uses the last one given and prints an error message. (As a special case, if the file’s name begins with a dot, no error message is printed. This odd behavior is only for compatibility with other implementations of make… you should avoid using it). Occasionally it is useful to have the same target invoke multiple recipes which are defined in different parts of your makefile; you can use double-colon rules (see [Double-Colon](https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon)) for this.

An extra rule with just prerequisites can be used to give a few extra prerequisites to many files at once. For example, makefiles often have a variable, such as objects, containing a list of all the compiler output files in the system being made. An easy way to say that all of them must be recompiled if config.h changes is to write the following:

    objects = foo.o bar.o
    foo.o : defs.h
    bar.o : defs.h test.h
    $(objects) : config.h

This could be inserted or taken out without changing the rules that really specify how to make the object files, making it a convenient form to use if you wish to add the additional prerequisite intermittently.

Another wrinkle is that the additional prerequisites could be specified with a variable that you set with a command line argument to make (see [Overriding Variables]()). For example,

    extradeps=
    $(objects) : $(extradeps)

means that the command ‘make extradeps=foo.h’ will consider foo.h as a prerequisite of each object file, but plain ‘make’ will not.

### 4.12 Static Pattern Rules

Static pattern rules are rules which specify multiple targets and construct the prerequisite names for each target based on the target name. They are more general than ordinary rules with multiple targets because the targets do not have to have identical prerequisites. Their prerequisites must be analogous, but not necessarily identical.

#### 4.12.1 Syntax of Static Pattern Rules

Here is the syntax of a static pattern rule:

    targets …: target-pattern: prereq-patterns …
            recipe
            …

The targets list specifies the targets that the rule applies to. The targets can contain wildcard characters, just like the targets of ordinary rules (see [Using Wildcard Characters in File Names](https://www.gnu.org/software/make/manual/html_node/Wildcards.html#Wildcards)).

The target-pattern and prereq-patterns say how to compute the prerequisites of each target. Each target is matched against the target-pattern to extract a part of the target name, called the stem. This stem is substituted into each of the prereq-patterns to make the prerequisite names (one from each prereq-pattern).

Each pattern normally contains the character '%' just once. When the target-pattern matches a target, the '%' can match any part of the target name; this part is called the stem. The rest of the pattern must match exactly. For example, the target foo.o matches the pattern '%.o', with 'foo' as the stem. The targets foo.c and foo.out do not match that pattern.

The prerequisite names for each target are made by substituting the stem for the '%' in each prerequisite pattern. For example, if one prerequisite pattern is %.c, then substitution of the stem 'foo' gives the prerequisite name foo.c. It is legitimate to write a prerequisite pattern that does not contain '%'; then this prerequisite is the same for all targets.

'%' characters in pattern rules can be quoted with preceding backslashes ('\'). Backslashes that would otherwise quote '%' characters can be quoted with more backslashes. Backslashes that quote '%' characters or other backslashes are removed from the pattern before it is compared to file names or has a stem substituted into it. Backslashes that are not in danger of quoting '%' characters go unmolested. For example, the pattern the\%weird\\%pattern\\ has 'the%weird\' preceding the operative '%' character, and 'pattern\\' following it. The final two backslashes are left alone because they cannot affect any '%' character.

Here is an example, which compiles each of foo.o and bar.o from the corresponding .c file:

    objects = foo.o bar.o

    all: $(objects)

    $(objects): %.o: %.c
            $(CC) -c $(CFLAGS) $< -o $@

Here '$<' is the automatic variable that holds the name of the prerequisite and '$@' is the automatic variable that holds the name of the target; see [Automatic Variables](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables).

Each target specified must match the target pattern; a warning is issued for each target that does not. If you have a list of files, only some of which will match the pattern, you can use the filter function to remove non-matching file names (see [Functions for String Substitution and Analysis](https://www.gnu.org/software/make/manual/html_node/Text-Functions.html#Text-Functions)):

    files = foo.elc bar.o lose.o

    $(filter %.o,$(files)): %.o: %.c
            $(CC) -c $(CFLAGS) $< -o $@
    $(filter %.elc,$(files)): %.elc: %.el
            emacs -f batch-byte-compile $<

In this example the result of '\$(filter %.o,\$(files))' is bar.o lose.o, and the first static pattern rule causes each of these object files to be updated by compiling the corresponding C source file. The result of '\$(filter %.elc,\$(files))' is foo.elc, so that file is made from foo.el.

Another example shows how to use $* in static pattern rules:

    bigoutput littleoutput : %output : text.g
            generate text.g -$* > $@

When the generate command is run, $* will expand to the stem, either 'big' or 'little'.

#### 4.12.2 Static Pattern Rules versus Implicit Rules

A static pattern rule has much in common with an implicit rule defined as a pattern rule (see [Defining and Redefining Pattern Rules](https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html#Pattern-Rules)). Both have a pattern for the target and patterns for constructing the names of prerequisites. The difference is in how make decides when the rule applies.

An implicit rule can apply to any target that matches its pattern, but it does apply only when the target has no recipe otherwise specified, and only when the prerequisites can be found. If more than one implicit rule appears applicable, only one applies; the choice depends on the order of rules.

By contrast, a static pattern rule applies to the precise list of targets that you specify in the rule. It cannot apply to any other target and it invariably does apply to each of the targets specified. If two conflicting rules apply, and both have recipes, that’s an error.

The static pattern rule can be better than an implicit rule for these reasons:

- You may wish to override the usual implicit rule for a few files whose names cannot be categorized syntactically but can be given in an explicit list.

- If you cannot be sure of the precise contents of the directories you are using, you may not be sure which other irrelevant files might lead make to use the wrong implicit rule. The choice might depend on the order in which the implicit rule search is done. With static pattern rules, there is no uncertainty: each rule applies to precisely the targets specified.

### [4.13 Double-Colon Rules](https://www.gnu.org/software/make/manual/html_node/Double_002dColon.html#Double_002dColon)

Double-colon rules are explicit rules written with '::' instead of ':' after the target names. They are handled differently from ordinary rules when the same target appears in more than one rule. Pattern rules with double-colons have an entirely different meaning (see [Match-Anything Rules](https://www.gnu.org/software/make/manual/html_node/Match_002dAnything-Rules.html#Match_002dAnything-Rules)).

When a target appears in multiple rules, all the rules must be the same type: all ordinary, or all double-colon. If they are double-colon, each of them is independent of the others. Each double-colon rule's recipe is executed if the target is older than any prerequisites of that rule. If there are no prerequisites for that rule, its recipe is always executed (even if the target already exists). This can result in executing none, any, or all of the double-colon rules.

Double-colon rules with the same target are in fact completely separate from one another. Each double-colon rule is processed individually, just as rules with different targets are processed.

The double-colon rules for a target are executed in the order they appear in the makefile. However, the cases where double-colon rules really make sense are those where the order of executing the recipes would not matter.

Double-colon rules are somewhat obscure and not often very useful; they provide a mechanism for cases in which the method used to update a target differs depending on which prerequisite files caused the update, and such cases are rare.

Each double-colon rule should specify a recipe; if it does not, an implicit rule will be used if one applies. See [Using Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules).

### [4.14 Generating Prerequisites Automatically](https://www.gnu.org/software/make/manual/html_node/Automatic-Prerequisites.html)
























### [10 Using Implicit Rules](https://www.gnu.org/software/make/manual/html_node/Implicit-Rules.html#Implicit-Rules)























