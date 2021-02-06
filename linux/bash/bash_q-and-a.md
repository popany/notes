# Bash Q&A

- [Bash Q&A](#bash-qa)
  - [Variable as command; `eval` vs `bash -c`](#variable-as-command-eval-vs-bash--c)

## [Variable as command; `eval` vs `bash -c`](https://unix.stackexchange.com/questions/124590/variable-as-command-eval-vs-bash-c)

`eval "$1"` executes the command in the current script. It can **set and use** shell variables from the current script, **set** environment variables for the current script, **set and use** functions from the current script, **set** the current directory, umask, limits and other attributes for the current script, and so on. `bash -c "$1"` executes the command in a completely separate script, which **inherits** environment variables, file descriptors and other process environment (but does **not transmit any change back**) but does **not inherit internal shell settings** (shell variables, functions, options, traps, etc.).

There is another way, `(eval "$1")`, which executes the command in a subshell: it **inherits everything from the calling script** but does **not transmit any change back**.

For example, assuming that the variable `dir` isn't exported and `$1` is `cd "$foo"; ls`, then:

- `cd /starting/directory; foo=/somewhere/else; eval "$1"; pwd` lists the content of `/somewhere/else` and prints `/somewhere/else`.

- `cd /starting/directory; foo=/somewhere/else; (eval "$1"); pwd` lists the content of `/somewhere/else` and prints `/starting/directory`.

- `cd /starting/directory; foo=/somewhere/else; bash -c "$1"; pwd` lists the content of `/starting/directory` (because `cd ""` doesn't change the current directory) and prints `/starting/directory`.
