# Install Kernel Source

- [Install Kernel Source](#install-kernel-source)
  - [Install Kernel Headers in CentOS 7](#install-kernel-headers-in-centos-7)
  - [Reference](#reference)

When you compile a custom kernel module such as a device driver on a CentOS system, you need to have kernel header files installed on the system, which include the C header files for the Linux kernel.

## Install Kernel Headers in CentOS 7

    yum upgrade

    reboot

    yum install kernel-devel

In addition, if you need header files for the Linux kernel for use by glibc, install the kernel-header package using following command

    yum install kernel-headers 

## Reference

[How to Install Kernel Headers in CentOS 7](https://www.tecmint.com/install-kernel-headers-in-centos-7/)

[Compile Linux Kernel on CentOS7](https://linuxhint.com/compile-linux-kernel-centos7/)

[How To: Install Kernel Source Code in CentOS/RedHat](https://www.unixtutorial.org/how-to-install-kernel-source-code-in-centos-redhat/)

[kernel-devel-$(uname -r) not available](https://forums.centos.org/viewtopic.php?t=54267)
