# nohup

- [nohup](#nohup)
  - [Why use "nohup &" rather than "exec &"](#why-use-nohup--rather-than-exec-)

## [Why use "nohup &" rather than "exec &"](https://unix.stackexchange.com/questions/137759/why-use-nohup-rather-than-exec)

What's better, a fish or a bicycle? `nohup` and `exec` do different things.

`exec` replaces the shell with another program. Using `exec` in a simple background job isn't useful: `exec myprogram; more stuff` replaces the shell with `myprogram` and so doesn't run `more stuff`, unlike `myprogram; more stuff` which runs `more stuff` when `myprogram` terminates; but `exec myprogram & more stuff` starts `myprogram` in the background and then runs `more stuff`, just like `myprogram & more stuff`.

`nohup` runs the specificed program with the `SIGHUP` signal ignored. When a terminal is closed, the kernel sends `SIGHUP` to the controlling process in that terminal (i.e. the shell). **The shell in turn sends `SIGHUP` to all the jobs running in the background**. Running a job with `nohup` prevents it from being killed in this way if the terminal dies (which happens e.g. if you were logged in remotely and the connection drops, or if you close your terminal emulator).

`nohup` also redirects the program's output to the file `nohup.out`. This avoids the program dying because it isn't able to write to its output or error output. Note that nohup doesn't redirect the input. To fully disconnect a program from the terminal where you launched it, use

    nohup myprogram </dev/null >myprogram.log 2>&1 &
