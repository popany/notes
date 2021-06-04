# sshd

- [sshd](#sshd)
  - [Log](#log)
    - [Change LogLevel](#change-loglevel)
    - [Log File Path](#log-file-path)
    - [start sshd manually in debug mode](#start-sshd-manually-in-debug-mode)
  - [Change port number](#change-port-number)
  - [Hide OpenSSH Version Banner](#hide-openssh-version-banner)
    - [Problem](#problem)
    - [Removing the Banner](#removing-the-banner)
    - [Result](#result)

## Log

### Change LogLevel

reference: [sshd_config(5) - Linux man page](https://linux.die.net/man/5/sshd_config)

config file: /etc/ssh/sshd_config

- `LogLevel`

  Gives the verbosity level that is used when logging messages from [sshd(8)](https://linux.die.net/man/8/sshd). The possible values are: `QUIET`, `FATAL`, `ERROR`, `INFO`, `VERBOSE`, `DEBUG`, `DEBUG1`, `DEBUG2`, and `DEBUG3`. The default is `INFO`. `DEBUG` and `DEBUG1` are equivalent. `DEBUG2` and `DEBUG3` each specify higher levels of debugging output. Logging with a DEBUG level violates the privacy of users and is not recommended.

### Log File Path

- CentOS

  /var/log/secure configed in /etc/rsyslog.conf

  show logon history

      grep session /var/log/secure

### start sshd manually in debug mode

    /usr/sbin/sshd -ddd -E /tmp/sshd.log -p 22

## Change port number

reference [Changing SSH Port on CentOS/RHEL 7/8 & Fedora 33/32/31/30 With SELinux Enforcing](https://computingforgeeks.com/change-ssh-port-centos-rhel-fedora-with-selinux/)

- Centos

  - config file: /etc/ssh/sshd_config

        Port 55000

  - firewall

        firewall-cmd --zone=public --add-port=55000/tcp
        firewall-cmd --runtime-to-permanent

  - selinux

        semanage port -a -t ssh_port_t -p tcp 55000

    Confirm that the new port has been added to list of allowed ports for ssh

        semanage port -l | grep ssh

## [Hide OpenSSH Version Banner](http://kb.ictbanking.net/article.php?id=666)

Hiding the version information from OpenSSH is not supported by configuration.

### Problem

SSH Servers such as OpenSSH advertise information such as protocol support, build version and host operating system. For example:

    $ nc example.local 22
     SSH-2.0-OpenSSH_7.4p1 Raspbian-10+deb9u2

Would be attackers scan the internet and create large databases to search for servers running software with known vulnerabilities.

### Removing the Banner

Warning: Doing this while connected via SSH is risky as you can lock yourself out. If you are, set up a way to recover the original binary (i.e. set up another way to connect to the machine or a cron job to restore a copy of the original).

1. Check the current banner:

       $ echo "Hello" | nc localhost 22
       SSH-2.0-OpenSSH_7.4p1 Raspbian-10+deb9u2
       Protocol mismatch.

   In this case, the part of the banner we want to hide is "OpenSSH_7.4p1 Raspbian-10+deb9u2" which is broadcasting the versions of my SSH server and operating system. Hiding the protocol is a bit harder and not covered here.

   We can see this in the binary too:

       $ strings /usr/sbin/sshd | grep Rasp
       OpenSSH_7.4p1 Raspbian-10+deb9u2

2. Escalate to a root session:

       $ sudo su
       $

3. Install hexedit:

       # apt-get update && apt-get install hexedit

4. Back up your sshd binary and create an editable working copy (as root):

       # cp /usr/sbin/sshd /tmp/sshd.backup
       # cp /tmp/sshd.backup /tmp/sshd.new

5. Update the binary with hexedit:

       # hexedit /tmp/sshd.new

   Press `TAB` to switch from the HEX are to the ASCII area

   Use `CTRL+S` to bring up the search prompt and search for the text in your banner than you want to hide e.g. 'OpenSSH_7.4'. You should see something like:

       0007DA54   61 67 65 6E  74 00 00 00  4F 70 65 6E  agent...Open
       0007DA60   53 53 48 5F  37 2E 34 70  31 20 52 61  SSH_7.4p1 Ra
       0007DA6C   73 70 62 69  61 6E 2D 31  30 2B 64 65  spbian-10+de
       0007DA78   62 39 75 32  00 00 00 00  4F 70 65 6E  b9u2....Open

   Use the arrow keys to highlight the start of the string that you want to update and type your replacement. Be careful to stay within the bounds of the length of the original banner. You can also press TAB to switch back to the HEX area if you wanted to just null out the string setting each word to ’00’.

   Your change should look something like:

       0007DA54   61 67 65 6E  74 00 00 00  48 65 72 65  agent...Here
       0007DA60   20 62 65 20  64 72 61 67  6F 6E 73 2E   be dragons.
       0007DA6C   20 54 75 72  6E 20 42 61  63 6B 00 00   Turn Back..
       0007DA78   00 00 00 00  00 00 00 00  4F 70 65 6E  ........Open

   Save your changes with `CTRL+x` and a `Y`.

6. Check if there are any instances that we missed (we expect no output now):

       # strings /tmp/sshd.new | grep Rasp

7. Update sshd and restart the service for good measure:

       # rm /usr/sbin/sshd
       # cp /tmp/sshd.new /usr/sbin/sshd
       # systemctl restart ssh.service

8. Check that you can still SSH in (otherwise restore the backup or reinstall OpenSSH from your package manager!):

       # ssh user@localhost

This change will only be temporary as any time you update OpenSSH, the binary will be replaced.

### Result

The process above will result in something like the following:

    $ nc localhost 22
    SSH-2.0-Here be dragons. Turn Back

Where before this would be along the lines of:

    $ nc localhost 22 
    SSH-2.0-OpenSSH_7.4p1 Raspbian-10+deb9u2

Which makes the version you are running just a little bit more obscure and and also adds bit of fun.
