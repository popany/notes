# makefile syntax

- [makefile syntax](#makefile-syntax)
  - [Practice](#practice)

## Practice

- `all:;@:`

  - [What is a semicolon in a makefile prerequisites list?](https://stackoverflow.com/questions/58038712/what-is-a-semicolon-in-a-makefile-prerequisites-list)

    As explained in [4.2 Rule Syntax](https://www.gnu.org/software/make/manual/html_node/Rule-Syntax.html#Rule-Syntax):

    In general, a rule looks like this:

        targets : prerequisites
                recipe
                …
    or like this:

        targets : prerequisites ; recipe
                recipe
                …

    The recipe lines start with a tab character (or the first character in the value of the `.RECIPEPREFIX` variable; see [Special Variables](https://www.gnu.org/software/make/manual/html_node/Special-Variables.html#Special-Variables)). **The first recipe line** may appear on the line after the prerequisites, with a tab character, or **may appear on the same line, with a semicolon**. Either way, the effect is the same.

  - [What does `@:` (at symbol colon) mean in a Makefile?](https://stackoverflow.com/questions/8610799/what-does-at-symbol-colon-mean-in-a-makefile)

    It means "don't echo this command on the output." So this rule is saying "execute the shell command `:` and don't echo the output.

    Of course the shell command `:` is a no-op, so this is saying "do nothing, and don't tell."




