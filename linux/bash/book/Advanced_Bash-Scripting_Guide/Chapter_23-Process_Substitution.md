# [Chapter 23. Process Substitution](https://tldp.org/LDP/abs/html/process-sub.html)

- [Chapter 23. Process Substitution](#chapter-23-process-substitution)
  - [Template](#template)
    - [Caution](#caution)

Piping the `stdout` of a command into the `stdin` of another is a powerful technique. But, what if you need to **pipe the `stdout` of multiple commands**? This is where process substitution comes in.

Process substitution feeds the output of a process (or processes) into the `stdin` of another process.

## Template

Command list enclosed within parentheses

    >(command_list)

    <(command_list)

Process substitution uses `/dev/fd/<n>` files to send the results of the process(es) within parentheses to another process.

### Caution

There is no space between the the "<" or ">" and the parentheses. Space there would give an error message.

...
