# bash

- [bash](#bash)
  - [Bash scripting cheatsheet](#bash-scripting-cheatsheet)
    - [Special variables](#special-variables)
  - [alias](#alias)
  - [prompt](#prompt)
  - [basic](#basic)
    - [Bash variable default value](#bash-variable-default-value)
    - [`set`](#set)
      - [`set -e -x -u`](#set--e--x--u)
    - [list file](#list-file)
      - [list full-path recursively](#list-full-path-recursively)
    - [`find`](#find)
    - [`cp`](#cp)
      - [copying a file without changing date stamp](#copying-a-file-without-changing-date-stamp)
    - [check the exit status](#check-the-exit-status)
    - [User](#user)
      - [List all users](#list-all-users)
    - [`tail`](#tail)
    - [`head`](#head)
    - [`icov`](#icov)
    - [`sed`](#sed)
      - [Use sed to extract substring](#use-sed-to-extract-substring)
      - [Replace "\r\n" with "\n"](#replace-rn-with-n)
    - [`grep`](#grep)
    - [`ps`](#ps)
    - [`nohup`](#nohup)
    - [`pwdx`](#pwdx)
    - [`tar`](#tar)
    - [`zip`](#zip)
    - [`unzip`](#unzip)
    - [Count lines of code](#count-lines-of-code)
    - [`top`](#top)
      - [Batch mode](#batch-mode)
      - [Interactive command](#interactive-command)
    - [`kill`](#kill)
      - [Create core dump](#create-core-dump)
  - [`jq`](#jq)
  - [CentOS](#centos)
    - [Check CentOS version](#check-centos-version)
    - [`yum`](#yum)
    - [`rpm`](#rpm)
    - [sftp](#sftp)
      - [How to setup an SFTP server on CentOS 7](#how-to-setup-an-sftp-server-on-centos-7)
    - [firewall](#firewall)
      - [How to Configure Firewall in CentOS 7 and RHEL 7](#how-to-configure-firewall-in-centos-7-and-rhel-7)
      - [How to Configure and Manage the Firewall on CentOS 8](#how-to-configure-and-manage-the-firewall-on-centos-8)
      - [Opening a source port](#opening-a-source-port)
    - [set core dump file location](#set-core-dump-file-location)
    - [Increase swap memory](#increase-swap-memory)
  - [Ubuntu](#ubuntu)
    - [Check Ubuntu version](#check-ubuntu-version)
    - [firewall](#firewall-1)
      - [Allow the TCP port 8080](#allow-the-tcp-port-8080)
      - [Block the UDP port 4444](#block-the-udp-port-4444)
  - [GNU Binary Utilities](#gnu-binary-utilities)
    - [readelf](#readelf)
    - [objcopy](#objcopy)
  - [telnet](#telnet)
  - [curl](#curl)
    - [download file](#download-file)
  - [`ssh`](#ssh)
    - [`ssh-keygen`](#ssh-keygen)
    - [`ssh-copy-id`](#ssh-copy-id)
    - [ssh dynamic port forwarding](#ssh-dynamic-port-forwarding)
    - [Map localhost:6103 to foo-host localhost:6103](#map-localhost6103-to-foo-host-localhost6103)
  - [network](#network)
    - [`nc`](#nc)
    - [`ss`](#ss)
      - [Query tcp buffer sizes for a certain socket](#query-tcp-buffer-sizes-for-a-certain-socket)
      - [USAGE EXAMPLES](#usage-examples)

## [Bash scripting cheatsheet](https://devhints.io/bash)

### Special variables

Exit status of last task:

    $?

PID of last background task:

    $!

PID of shell:

    $$

Filename of the shell script:

    $0

## alias

    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

## prompt

    git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    export PS1="[\u@\h \W]\$(git_branch)\$ "

## basic

### [Bash variable default value](https://stackoverflow.com/questions/2013547/assigning-default-values-to-shell-variables-with-a-single-command-in-bash/2013589#2013589)

Very close to what you posted, actually.

To get the assigned value, or `default` if it's missing:

    FOO="${VARIABLE:-default}"  # If variable not set or null, use default.

Or to assign `default` to `VARIABLE` at the same time:

    FOO="${VARIABLE:=default}"  # If variable not set or null, set it to default.

### `set`

#### `set -e -x -u`

    -e  Exit immediately if a command exits with a non-zero status.

    -x  Print commands and their arguments as they are executed.

    -u  Treat unset variables as an error when substituting.

    Using + rather than - causes these flags to be turned off.    

### list file

#### [list full-path recursively](https://stackoverflow.com/questions/1767384/ls-command-how-can-i-get-a-recursive-full-path-listing-one-line-per-file)

    find . -type f

### `find`

List file or directory recursively

    find .

    find . -type f

    find . -type d

Execute command

    find . -name '<filename>' -exec cat {} \;

Loop over directories

    find . -maxdepth 1 -mindepth 1 -type d -printf '%f\n'

Exclude file name

    find / -maxdepth 1 -mindepth 1 -type d ! -name 'mnt' -printf '%f\n'

    find / -maxdepth 1 -mindepth 1 -type d ! -name 'mnt' -exec du -h -d0 {} \;

### `cp`

#### [copying a file without changing date stamp](https://www.unix.com/shell-programming-and-scripting/95917-copying-file-without-changing-date-stamp.html)

    cp -p

### [check the exit status](https://stackoverflow.com/questions/26675681/how-to-check-the-exit-status-using-an-if-statement)

    (($? != 0)) && { printf '%s\n' "Command exited with non-zero"; exit 1; }

### User

#### List all users

    cat /etc/passwd

### `tail`

Output the last 5 lines

    tail -n 5

Output starting with the 5th

    tail -n +5

### `head`

Print the first 5 lines

    head -n 5

Print all but the last 5 lines

    head -n -5

### `icov`

Convert encoding from gbk to utf8

    iconv -f GBK -t UTF-8 file_name

List all known coded character sets

    iconv -l

### [`sed`](https://www.computerhope.com/unix/used.htm)

#### [Use sed to extract substring](https://stackoverflow.com/questions/16675179/how-to-use-sed-to-extract-substring)

    sed 's/[^"]*"\([^"]*\).*/\1/'

- `s` - tells sed to substitute
- `/` - start of regex string to search for
- `[^"]*` - any character that is not `"`, any number of times.
- `"` - just a `"`.
- `([^"]*)` - anything inside `()` will be saved for reference to use later. The `\` are there so the brackets are not considered as characters to search for. `[^"]*` means the same as above.
- `.*` - any character, any number of times.
- `/` - end of the search regex, and start of the substitute string.
- `\1` - reference to that string we found in the brackets above.
- `/` end of the substitute string.

#### Replace "\r\n" with "\n"

    sed 's/\r$//'

### `grep`

Count lines for matched words

    grep -c 'word' /path/to/file

Print file name with output lines

    grep -H 'word' /path/to/file

List only the names of matching files

    grep -l 'primary' *.c

### `ps`

Get environment variables of running process

    ps eww <pid>

### `nohup`

The [nohup](https://www.computerhope.com/unix/unohup.htm) command executes another command, and instructs the system to continue running it even if the session is disconnected

### `pwdx`

Find current working directory of a process

    pwdx <PID>

### `tar`

Create archive.tar from files foo and bar.

    tar -cf archive.tar foo bar  

List all files in archive.tar verbosely.

    tar -tvf archive.tar

Extract all files from archive.tar.

    tar -xf archive.tar

Extract to a directory

    tar -xf archive.tar -C /path/to/directory

### `zip`

    zip -q -r foo.zip ./foo

### `unzip`

    unzip -l foo.zip

    unzip -d foo foo.zip

    unzip -O CP936 foo.zip

### Count lines of code

    find ./src -name '*.c'|xargs wc -l

### `top`

#### Batch mode

    top -Eg -b -n1

#### Interactive command

- `I`

  toggle Irix/Solaris modes

  In Solaris mode, a task's cpu usage will be divided by the total number of CPUs

- `c`

  Display the command line

### `kill`

#### Create core dump

    ulimit -c unlimited
    kill -3 <pid>

## `jq`

    docker inspect zookeeper|jq '.[].NetworkSettings.Networks.kafka.IPAddress'

    docker manifest inspect -v library/tomcat:latest | jq .[].Platform

## CentOS

### Check CentOS version

    cat /etc/centos-release

### `yum`

List installed packages:

    yum list installed

### `rpm`

    rpm -qa

List installed packages

### sftp

#### [How to setup an SFTP server on CentOS](https://www.howtoforge.com/tutorial/how-to-setup-an-sftp-server-on-centos/) 7

add user

    mkdir -p /data/sftp
    chmod 701 /data

    groupadd sftpusers

    useradd -g sftpusers -d /upload -s /sbin/nologin mysftpuser

chage password

    passwd mysftpuser

chown

    mkdir -p /data/mysftpuser/upload
    chown -R root:sftpusers /data/mysftpuser
    chown -R mysftpuser:sftpusers /data/mysftpuser/upload

modify `/etc/ssh/sshd_config`

Add the following lines at the end of the file.

    Match Group sftpusers
    ChrootDirectory /data/%u
    ForceCommand internal-sftp

restart `sshd`

    service sshd restart

### firewall

#### [How to Configure Firewall in CentOS 7 and RHEL 7](https://www.looklinux.com/how-to-configure-firewall-in-centos-7-and-rhel-7/)

#### [How to Configure and Manage the Firewall on CentOS 8](https://linuxize.com/post/how-to-configure-and-manage-firewall-on-centos-8/)

#### Opening a source port

    firewall-cmd --zone=public --add-port=8080/tcp
    firewall-cmd --runtime-to-permanent

### set core dump file location

[How to enable core dump for Applications on CentOS/RHEL](https://www.thegeekdiary.com/how-to-enable-core-dump-for-applications-on-centos-rhel/)

1. Enable core file creation

   - temporarily

         # ulimit -S -c unlimited > /dev/null 2>&1

   - permanently

     Edit `/etc/security/limits.conf`

         # vi /etc/security/limits.conf
         * soft core unlimited

     The '`*`' is used to enable coredump size to unlimited to all users

2. Add the path of the core dump and file format of the core file

   By default, the core file will be generated in the working directory of the running process

       # vi /etc/sysctl.conf
       kernel.core_pattern = /var/crash/core.%e.%p.%h.%t

   `/var/crash` is the path and `core.%e.%p.%h.%t` is the file format, where:

   `%e` – executable filename

   `%p` – PID of dumped process

   `%t` – time of dump (seconds since 0:00h, 1 Jan 1970)

   `%h` – hostname (same as ’nodename’ returned by uname(2))

3. Make sure processes have the correct permission for the configured directory (e.g. `/var/carsh/`)

       # vi /etc/sysctl.conf
       fs.suid_dumpable = 2

   `0` – (default): traditional behaviour. Any process which has changed privilege levels or is execute only will not be dumped.

   `1` – (debug): all processes dump core when possible. The core dump is owned by the current user and no security is applied. This is intended for system debugging situations only.

   `2` – (suidsafe): any binary which normally not be dumped is dumped readable by root only. This allows the end-user to remove such a dump but not access it directly. For security reasons, core dumps in this mode will not overwrite one another or other files. This mode is appropriate when administrators are attempting to debug problems in a normal environment.

   Load the settings using the sysctl command below after modifying `/etc/sysctl.conf`

       # sysctl -p

4. To collect core dumps from unsigned packages, set `OpenGPGCheck = no` in `/etc/abrt/abrt-action-save-package-data.conf`. To collect core dumps from unpackaged software, set `ProcessUnpackaged = yes` in `/etc/abrt/abrt-action-save-package-data.conf`

5. Restart the abrtd daemon – as root – for the new settings to take effect

       # service abrtd restart
       # service abrt-ccpp restart

   In CentOS/RHEL 7:

       # systemctl start abrtd.service
       # systemctl start abrt-ccpp.service

### [Increase swap memory](https://www.vembu.com/blog/increase-swap-memory-centos-7/)

    dd if=/dev/zero of=/root/vembuswap bs=1M count=1024
    chmod 600 /root/vembuswap
    mkswap /root/vembuswap
    swapon /root/vembuswap
    echo "/root/vembuswap swap swap defaults 0 0" >> /etc/fstab

    # verify
    swapon -s
    free -m

## Ubuntu

### Check Ubuntu version

    lsb_release -a

    cat /etc/issue

    # Ubuntu 16.04 or newer
    cat /etc/os-release

### firewall

#### Allow the TCP port 8080

    ufw allow 8080/tcp

#### Block the UDP port 4444

    ufw deny 4444/udp

## [GNU Binary Utilities](https://sourceware.org/binutils/docs-2.34/binutils/index.html)

### readelf

### objcopy

## telnet

## curl

### download file

    curl -o localname.zip http://example.com/download/myfile.zip

## `ssh`

### `ssh-keygen`

    ssh-keygen -t rsa -C "your.email@example.com" -b 4096

    ssh-keygen -t rsa -C "your.email@example.com" -b 4096 -f ~/.ssh/id_rsa

### `ssh-copy-id`

Installs an [SSH key](https://www.ssh.com/ssh/key/) on a server as an authorized key

    ssh-copy-id -i ~/.ssh/id_rsa user@host

### ssh dynamic port forwarding

    ssh -D local_port username@server.com

    ssh -i ~/.ssh/id_rsa -D local_port username@server.com

### Map localhost:6103 to foo-host localhost:6103

    ssh -L localhost:6103:localhost:6103 root@foo-host

## network

### `nc`

CLIENT/SERVER MODEL

- client/server model

   server

      nc -l 1234

   client

      nc 127.0.0.1 1234

### `ss`

#### Query tcp buffer sizes for a certain socket

    ss -ntmp

[ref](https://access.redhat.com/discussions/3624151)

> The `-m` switch of ss gives socket memory info.
>
>     # ss -ntmp
>     State      Recv-Q Send-Q Local Address:Port  Peer Address:Port
>     ESTAB      0      0      10.xx.xx.xxx:22     10.yy.yy.yyy:12345  users:(("sshd",pid=1442,fd=3))
>              skmem:(r0,rb369280,t0,tb87040,f4096,w0,o0,bl0,d92)
>
> Here we can see this socket has Receive Buffer 369280 bytes, and Transmit Buffer 87040 bytes.
>
> Keep in mind the kernel will double any socket buffer allocation for overhead. So a process asks for 256 KiB buffer with `setsockopt(SO_RCVBUF)` then it will get 512 KiB buffer space. This is described on man 7 tcp.

    ss -ntmp dst 127.0.0.1:10000

#### [USAGE EXAMPLES](https://www.man7.org/linux/man-pages/man8/ss.8.html#USAGE_EXAMPLES)

- `ss -t -a`

  Display all TCP sockets.

- `ss -t -a -Z`

  Display all TCP sockets with process SELinux security contexts.

- `ss -u -a`

  Display all UDP sockets.

- `ss -o state established '( dport = :ssh or sport = :ssh )'`

  Display all established ssh connections.

- `ss -x src /tmp/.X11-unix/*`

  Find all local processes connected to X server.

- `ss -o state fin-wait-1 '( sport = :http or sport = :https )' dst 193.233.7/24`

  List all the tcp sockets in state FIN-WAIT-1 for our apache to network 193.233.7/24 and look at their timers.

- `ss -a -A 'all,!tcp'`

  List sockets in all states from all socket tables but TCP.
