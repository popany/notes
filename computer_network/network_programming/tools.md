# tools

- [tools](#tools)
  - [`netstat`](#netstat)
    - [list listen port](#list-listen-port)

## `netstat`

### list listen port

    sudo netstat -tunlp

- `-t` - Show TCP ports.
- `-u` - Show UDP ports.
- `-n` - Show numerical addresses instead of resolving hosts.
- `-l` - Show only listening ports.
- `-p` - Show the PID and name of the listener’s process. This information is shown only if you run the command as root or sudo user.


