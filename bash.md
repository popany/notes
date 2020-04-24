# bash

- [bash](#bash)
  - [Bash scripting cheatsheet](#bash-scripting-cheatsheet)
    - [Special variables](#special-variables)
  - [alias](#alias)
  - [prompt](#prompt)
  - [basic](#basic)
    - [list file](#list-file)
      - [list full-path recursively](#list-full-path-recursively)
    - [cp](#cp)
      - [copying a file without changing date stamp](#copying-a-file-without-changing-date-stamp)
    - [check the exit status](#check-the-exit-status)
    - [User](#user)
      - [List all users](#list-all-users)
    - [`tail`](#tail)
    - [`head`](#head)
    - [`icov`](#icov)
    - [`sed`](#sed)
      - [Use sed to extract substring](#use-sed-to-extract-substring)
      - [Replace "\r\n" with "\n"](#replace-%22rn%22-with-%22n%22)
    - [`grep`](#grep)
    - [`tar`](#tar)
  - [CentOS](#centos)
    - [Check CentOS version](#check-centos-version)
    - [`yum`](#yum)
    - [`rpm`](#rpm)
    - [sftp](#sftp)
      - [How to setup an SFTP server on CentOS 7](#how-to-setup-an-sftp-server-on-centos-7)
    - [firewall](#firewall)
      - [How to Configure Firewall in CentOS 7 and RHEL 7](#how-to-configure-firewall-in-centos-7-and-rhel-7)
  - [Ubuntu](#ubuntu)
    - [Check Ubuntu version](#check-ubuntu-version)
  - [GNU Binary Utilities](#gnu-binary-utilities)
    - [readelf](#readelf)
    - [objcopy](#objcopy)
  - [telnet](#telnet)
  - [curl](#curl)
    - [download file](#download-file)

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

### list file

#### [list full-path recursively](https://stackoverflow.com/questions/1767384/ls-command-how-can-i-get-a-recursive-full-path-listing-one-line-per-file)

    find . -type f

### cp

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

### `tar`

Create archive.tar from files foo and bar.

    tar -cf archive.tar foo bar  

List all files in archive.tar verbosely.

    tar -tvf archive.tar

Extract all files from archive.tar.

    tar -xf archive.tar

Extract to a directory

    tar -xf archive.tar -C /path/to/directory

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

## Ubuntu

### Check Ubuntu version

    lsb_release -a

    cat /etc/issue

    # Ubuntu 16.04 or newer
    cat /etc/os-release

## [GNU Binary Utilities](https://sourceware.org/binutils/docs-2.34/binutils/index.html)

### readelf

### objcopy

## telnet

## curl

### download file

    curl -o localname.zip http://example.com/download/myfile.zip
