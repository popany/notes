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
  - [CentOS](#centos)
    - [Check CentOS version](#check-centos-version)
    - [sftp](#sftp)
      - [How to setup an SFTP server on CentOS 7](#how-to-setup-an-sftp-server-on-centos-7)
    - [firewall](#firewall)
      - [How to Configure Firewall in CentOS 7 and RHEL 7](#how-to-configure-firewall-in-centos-7-and-rhel-7)
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

## CentOS

### Check CentOS version

    cat /etc/centos-release

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

## [GNU Binary Utilities](https://sourceware.org/binutils/docs-2.34/binutils/index.html)

### readelf

### objcopy

## telnet

## curl

### download file

    curl -o localname.zip http://example.com/download/myfile.zip
