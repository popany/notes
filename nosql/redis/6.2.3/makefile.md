# Makefile

reference: [make manual](https://www.gnu.org/software/make/manual/make.html)

---

    cd src && $(MAKE) $@

`&&`

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
>   The file name of the target of the rule. If the target is an archive member, then '$@' is the name of the archive file. In a pattern rule that has multiple targets (see [Introduction to Pattern Rules](https://www.gnu.org/software/make/manual/make.html#Pattern-Intro)), '$@' is the name of whichever target caused the rule’s recipe to be run.

---






