# Makefile

- [Makefile](#makefile)
  - [reference: make manual](#reference-make-manual)
  - [`cd src && $(MAKE) $@`](#cd-src--make-)
  - [`release_hdr := $(shell sh -c './mkreleasehdr.sh')`](#release_hdr--shell-sh--c-mkreleasehdrsh)
  - [`OPTIMIZATION?=-O2`](#optimization-o2)
  - [`ifneq (,$(findstring clang,$(CC)))`](#ifneq-findstring-clangcc)
  - [`STD+=-Wno-c11-extensions`](#std-wno-c11-extensions)
  - [`OPT=$(OPTIMIZATION)`](#optoptimization)
  - [`CFLAGS+=-funwind-tables`](#cflags-funwind-tables)
  - [`-include .make-settings`](#-include-make-settings)
  - [`export CFLAGS LDFLAGS DEBUG DEBUG_FLAGS`](#export-cflags-ldflags-debug-debug_flags)
  - [`define MAKE_INSTALL`](#define-make_install)
  - [`ifndef V`](#ifndef-v)
  - [`all: $(REDIS_SERVER_NAME) $(REDIS_SENTINEL_NAME) $(REDIS_CLI_NAME) $(REDIS_BENCHMARK_NAME) $(REDIS_CHECK_RDB_NAME) $(REDIS_CHECK_AOF_NAME)`](#all-redis_server_name-redis_sentinel_name-redis_cli_name-redis_benchmark_name-redis_check_rdb_name-redis_check_aof_name)
  - [`%.o: %.c .make-prerequisites`](#o-c-make-prerequisites)
  - [`$(REDIS_CC) -MMD -o $@ -c $<`](#redis_cc--mmd--o---c-)
  - [`$(REDIS_LD) -o $@ $^ ../deps/hiredis/libhiredis.a ../deps/lua/src/liblua.a $(FINAL_LIBS)`](#redis_ld--o---depshiredislibhiredisa-depsluasrclibluaa-final_libs)
  - [`DEP = $(REDIS_SERVER_OBJ:%.o=%.d) $(REDIS_CLI_OBJ:%.o=%.d) $(REDIS_BENCHMARK_OBJ:%.o=%.d)`](#dep--redis_server_objod-redis_cli_objod-redis_benchmark_objod)

## reference: [make manual](https://www.gnu.org/software/make/manual/make.html)

## `cd src && $(MAKE) $@`

`&& $(MAKE)`

> 5.7 Recursive Use of make
>
> Recursive use of make means using make as a command in a makefile. This technique is useful when you want separate makefiles for various subsystems that compose a larger system. For example, suppose you have a sub-directory subdir which has its own makefile, and you would like the containing directory’s makefile to run make on the sub-directory. You can do it by writing this:
>
>     subsystem:
>             cd subdir && $(MAKE)

`$@`

> 10.5.3 Automatic Variables
>
> - `$@`
>
>   The file name of the target of the rule. If the target is an archive member, then '$@' is the name of the archive file. In a pattern rule that has multiple targets (see [Introduction to Pattern Rules](https://www.gnu.org/software/make/manual/make.html#Pattern-Intro)), '$@' is the name of whichever target caused the rule's recipe to be run.

## `release_hdr := $(shell sh -c './mkreleasehdr.sh')`

`:=`

> 6.5 Setting Variables
>
> ...
>
> Variables defined with '=' are recursively expanded variables. Variables defined with ':=' or '::=' are simply expanded variables; these definitions can contain variable references which will be expanded before the definition is made. See The Two Flavors of Variables.
>
> ...
>
> If the result of the execution could produce a $, and you don’t intend what follows that to be interpreted as a make variable or function reference, then you must replace every $ with $$ as part of the execution. Alternatively, you can set a simply expanded variable to the result of running a program using the shell function call. See The shell Function. For example:
>
>     hash := $(shell printf '\043')
>     var := $(shell find . -name "*.c")
>
> As with the shell function, the exit status of the just-invoked shell script is stored in the .SHELLSTATUS variable.

> 6.2 The Two Flavors of Variables
>
> There are two ways that a variable in GNU make can have a value; we call them the two flavors of variables. The two flavors are distinguished in how they are defined and in what they do when expanded.
>
> The first flavor of variable is a recursively expanded variable. Variables of this sort are defined by lines using ‘=’ (see Setting Variables) or by the define directive (see Defining Multi-Line Variables). The value you specify is installed verbatim; if it contains references to other variables, these references are expanded whenever this variable is substituted (in the course of expanding some other string). When this happens, it is called recursive expansion.
>
> ...
>
> Simply expanded variables are defined by lines using ':=' or '::=' (see Setting Variables). Both forms are equivalent in GNU make; however only the '::=' form is described by the POSIX standard (support for '::=' was added to the POSIX standard in 2012, so older versions of make won’t accept this form either).
>
> The value of a simply expanded variable is scanned once and for all, expanding any references to other variables and functions, when the variable is defined. The actual value of the simply expanded variable is the result of expanding the text that you write. It does not contain any references to other variables; it contains their values as of the time this variable was defined. Therefore,
>
>     x := foo
>     y := $(x) bar
>     x := later
>
> is equivalent to
>
>     y := foo bar
>     x := later
>
> When a simply expanded variable is referenced, its value is substituted verbatim.
>
> Here is a somewhat more complicated example, illustrating the use of ':=' in conjunction with the shell function. (See The shell Function.) This example also shows use of the variable MAKELEVEL, which is changed when it is passed down from level to level. (See Communicating Variables to a Sub-make, for information about MAKELEVEL.)
>
>     ifeq (0,${MAKELEVEL})
>     whoami    := $(shell whoami)
>     host-type := $(shell arch)
>     MAKE := ${MAKE} host-type=${host-type} whoami=${whoami}
>     endif

> 8.13 The shell Function
>
> The shell function is unlike any other function other than the wildcard function (see The Function wildcard) in that it communicates with the world outside of make.
>
> The shell function performs the same function that backquotes ('`') perform in most shells: it does command expansion. This means that it takes as an argument a shell command and evaluates to the output of the command. The only processing make does on the result is to convert each newline (or carriage-return / newline pair) to a single space. If there is a trailing (carriage-return and) newline it will simply be removed.
>
> The commands run by calls to the shell function are run when the function calls are expanded (see How make Reads a Makefile). Because this function involves spawning a new shell, you should carefully consider the performance implications of using the shell function within recursively expanded variables vs. simply expanded variables (see The Two Flavors of Variables).
>
> After the shell function or '!=' assignment operator is used, its exit status is placed in the .SHELLSTATUS variable.
>
> Here are some examples of the use of the shell function:
>
>     contents := $(shell cat foo)
>
> sets contents to the contents of the file foo, with a space (rather than a newline) separating each line.
>
>     files := $(shell echo *.c)
>
> sets files to the expansion of '*.c'. Unless make is using a very strange shell, this has the same result as '$(wildcard *.c)' (as long as at least one '.c' file exists).

## `OPTIMIZATION?=-O2`

`?=`

> 6.5 Setting Variables
>
> ...
>
> If you’d like a variable to be set to a value only if it’s not already set, then you can use the shorthand operator '?=' instead of '='. These two settings of the variable 'FOO' are identical (see The origin Function):
>
>     FOO ?= bar
>
> and
>
>     ifeq ($(origin FOO), undefined)
>     FOO = bar
>     endif

## `ifneq (,$(findstring clang,$(CC)))`

`ifneq`

> 7.2 Syntax of Conditionals
>
> ...
>
>     ifneq (arg1, arg2)
>     ifneq 'arg1' 'arg2'
>     ifneq "arg1" "arg2"
>     ifneq "arg1" 'arg2'
>     ifneq 'arg1' "arg2"
>
> Expand all variable references in arg1 and arg2 and compare them. If they are different, the text-if-true is effective; otherwise, the text-if-false, if any, is effective.

`findstring`

> 8.2 Functions for String Substitution and Analysis
>
> ...
>
>     $(findstring find,in)
>
> Searches in for an occurrence of find. If it occurs, the value is find; otherwise, the value is empty. You can use this function in a conditional to test for the presence of a specific substring in a given string. Thus, the two examples,
>
>     $(findstring a,a b c)
>     $(findstring a,b c)
>
> produce the values 'a' and '' (the empty string), respectively. See Testing Flags, for a practical application of findstring.

## `STD+=-Wno-c11-extensions`

`+=`

> 6.6 Appending More Text to Variables
>
> Often it is useful to add more text to the value of a variable already defined. You do this with a line containing '+=', like this:
>
>     objects += another.o
>
> This takes the value of the variable objects, and adds the text 'another.o' to it (preceded by a single space, if it has a value already). Thus:
>
>     objects = main.o foo.o bar.o utils.o
>     objects += another.o
>
sets objects to 'main.o foo.o bar.o utils.o another.o'.

## `OPT=$(OPTIMIZATION)`

`$`

> 6.1 Basics of Variable References
>
> To substitute a variable's value, write a dollar sign followed by the name of the variable in parentheses or braces: either '$(foo)' or '${foo}' is a valid reference to the variable foo. This special significance of '$' is why you must write '$$' to have the effect of a single dollar sign in a file name or recipe.

## `CFLAGS+=-funwind-tables`

`-funwind-tables`

[3.17 Options for Code Generation Conventions](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html)

>     -funwind-tables
>
> Similar to -fexceptions, except that it just generates any needed static data, but does not affect the generated code in any other way. You normally do not need to enable this option; instead, a language processor that needs this handling enables it on your behalf.

## `-include .make-settings`

`-include`

> The include directive tells make to suspend reading the current makefile and read one or more other makefiles before continuing. The directive is a line in the makefile that looks like this:
>
>     include filenames…
>
> filenames can contain shell file name patterns. If filenames is empty, nothing is included and no error is printed.
>
> ...
>
> If you want make to simply ignore a makefile which does not exist or cannot be remade, with no error message, use the -include directive instead of include, like this:
>
>     -include filenames…
>
> This acts like include in every way except that there is no error (not even a warning) if any of the filenames (or any prerequisites of any of the filenames) do not exist or cannot be remade.
>
> For compatibility with some other make implementations, sinclude is another name for -include.

## `export CFLAGS LDFLAGS DEBUG DEBUG_FLAGS`

`export`

> 5.7.2 Communicating Variables to a Sub-make
>
> Variable values of the top-level make can be passed to the sub-make through the environment by explicit request. These variables are defined in the sub-make as defaults, but they do not override variables defined in the makefile used by the sub-make unless you use the '-e' switch (see Summary of Options).
>
> ...
>
> If you want to export specific variables to a sub-make, use the export directive, like this:
>
>     export variable …
>

## `define MAKE_INSTALL`

`define`

> 6.8 Defining Multi-Line Variables
>
> Another way to set the value of a variable is to use the define directive. This directive has an unusual syntax which allows newline characters to be included in the value, which is convenient for defining both canned sequences of commands (see Defining Canned Recipes), and also sections of makefile syntax to use with eval (see Eval Function).

## `ifndef V`

`ifndef`

> 7.2 Syntax of Conditionals
>
> ...
>
>     ifndef variable-name
>
> If the variable variable-name has an empty value, the text-if-true is effective; otherwise, the text-if-false, if any, is effective. The rules for expansion and testing of variable-name are identical to the ifdef directive.

## `all: $(REDIS_SERVER_NAME) $(REDIS_SENTINEL_NAME) $(REDIS_CLI_NAME) $(REDIS_BENCHMARK_NAME) $(REDIS_CHECK_RDB_NAME) $(REDIS_CHECK_AOF_NAME)`

## `%.o: %.c .make-prerequisites`

## `$(REDIS_CC) -MMD -o $@ -c $<`

> 10.5.3 Automatic Variables
>
>     `$<`
>
> The name of the first prerequisite. If the target got its recipe from an implicit rule, this will be the first prerequisite added by the implicit rule (see Implicit Rules).

## `$(REDIS_LD) -o $@ $^ ../deps/hiredis/libhiredis.a ../deps/lua/src/liblua.a $(FINAL_LIBS)`

`$^`

> 10.5.3 Automatic Variables
>
>     $^
>
> The names of all the prerequisites, with spaces between them. For prerequisites which are archive members, only the named member is used (see Archives). A target has only one prerequisite on each other file it depends on, no matter how many times each file is listed as a prerequisite. So if you list a prerequisite more than once for a target, the value of $^ contains just one copy of the name. This list does not contain any of the order-only prerequisites; for those see the ‘$|’ variable, below.

## `DEP = $(REDIS_SERVER_OBJ:%.o=%.d) $(REDIS_CLI_OBJ:%.o=%.d) $(REDIS_BENCHMARK_OBJ:%.o=%.d)`

`$`

> 6.3.1 Substitution References
>
> A substitution reference substitutes the value of a variable with alterations that you specify. It has the form '$(var:a=b)' (or '${var:a=b}') and its meaning is to take the value of the variable var, replace every a at the end of a word with b in that value, and substitute the resulting string.
>
> When we say "at the end of a word", we mean that a must appear either followed by whitespace or at the end of the value in order to be replaced; other occurrences of a in the value are unaltered. For example:
>
>     foo := a.o b.o l.a c.o
>     bar := $(foo:.o=.c)
>
> sets 'bar' to 'a.c b.c l.a c.c'. See Setting Variables.
>
> A substitution reference is shorthand for the patsubst expansion function (see Functions for String Substitution and Analysis): '$(var:a=b)' is equivalent to '$(patsubst %a,%b,var)'. We provide substitution references as well as patsubst for compatibility with other implementations of make.
>
> Another type of substitution reference lets you use the full power of the patsubst function. It has the same form '$(var:a=b)' described above, except that now a must contain a single '%' character. This case is equivalent to '$(patsubst a,b,$(var))'. See Functions for String Substitution and Analysis, for a description of the patsubst function.
>
> For example:
>
>     foo := a.o b.o l.a c.o
>     bar := $(foo:%.o=%.c)
>
> sets 'bar' to 'a.c b.c l.a c.c'.


