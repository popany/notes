# [Use a keytab](https://kb.iu.edu/d/aumh)

- [Use a keytab](#use-a-keytab)
  - [Introduction](#introduction)
  - [Create a keytab file](#create-a-keytab-file)
  - [Use a keytab to authenticate scripts](#use-a-keytab-to-authenticate-scripts)
  - [List the keys in a keytab file](#list-the-keys-in-a-keytab-file)
  - [Delete a key from a keytab file](#delete-a-key-from-a-keytab-file)
  - [Merge keytab files](#merge-keytab-files)
  - [Copy a keytab file to another computer](#copy-a-keytab-file-to-another-computer)

## Introduction

A keytab is a file containing pairs of Kerberos principals and **encrypted keys** (which are derived from the **Kerberos password**). You can use a keytab file to authenticate to various remote systems using Kerberos without entering a password. However, when you change your Kerberos password, you will need to recreate all your keytabs.

Keytab files are commonly used to allow scripts to automatically authenticate using Kerberos, without requiring human interaction or access to password stored in a plain-text file. The script is then able to use the acquired credentials to access files stored on a remote system.

|||
|-|-|
Important|Anyone with read permission on a keytab file can use all the keys in the file. To prevent misuse, restrict access permissions for any keytab files you create. For instructions, see [Manage file permissions on Unix-like systems](https://kb.iu.edu/d/abdb).
|||

## Create a keytab file

|||
|-|-|
Note|To use the instructions and examples on this page, you need access to a Kerberos client, on either your personal workstation or an IU [research supercomputer](https://kb.iu.edu/d/alde). When following the examples on this page, enter the commands exactly as they are shown. You may need to modify your path to include the location of ktutil (for example, `/usr/sbin` or `/usr/kerberos/sbin`).
|||

You can create keytab files on **any computer** that has a Kerberos client installed. Keytab files are **not bound** to the systems on which they were created; you can **create** a keytab file on one computer and **copy** it for use on other computers.

Following is an example of the keytab file creation process using MIT Kerberos:

    > ktutil
    ktutil:  addent -password -p username@ADS.IU.EDU -k 1 -e aes256-cts
    Password for username@ADS.IU.EDU: [enter your password]
    ktutil:  wkt username.keytab
    ktutil:  quit

Following is an example using Heimdal Kerberos:

    > ktutil -k username.keytab add -p username@ADS.IU.EDU -e arcfour-hmac-md5 -V 1

If the keytab created in Heimdal does not work, it is possible you will need an aes256-cts entry. In that case, you will need to find a computer with MIT Kerberos, and use that method instead.

|||
|-|-|
Note|For more about the ADS.IU.EDU Kerberos realm, see [Current Kerberos realm at IU](https://kb.iu.edu/d/alje).
|||

## Use a keytab to authenticate scripts

To execute a script so it has valid Kerberos credentials, use:

    > kinit username@ADS.IU.EDU -k -t mykeytab; myscript

Replace `username` with your `username`, `mykeytab` with the name of your keytab file, and myscript with the name of your script.

## List the keys in a keytab file

With MIT Kerberos, to list the contents of a keytab file, use `klist` (replace `mykeytab` with the name of your keytab file):

    > klist -k mykeytab

    version_number username@ADS.IU.EDU
    version_number username@ADS.IU.EDU

The output contains two columns listing version numbers and principal names. If multiple keys for a principal exist, the one with the highest version number will be used.

With Heimdal Kerberos, use `ktutil` instead:

    > ktutil -k mykeytab list
    mykeytab:

    Vno  Type         Prinicpal
    1    des3-cbc-md5 username@ADS.IU.EDU
    ...

## Delete a key from a keytab file

If you no longer need a keytab file, delete it immediately. If the keytab contains multiple keys, you can delete specific keys with the `ktutil` command. You can also use this procedure to remove old versions of a key. An example using MIT Kerberos follows:

    > ktutil
    ktutil: read_kt mykeytab
    ktutil: list

    ...
    slot# version# username@ADS.IU.EDU        version#
    ...

    ktutil: delent slot#

Replace `mykeytab` with the name of your keytab file, `username` with your username, and `version#` with the appropriate version number.

Verify that the version is gone, and then in `ktutil`, enter:

    quit

To do the same thing using Heimdal Kerberos, use:

    > ktutil -k mykeytab list

    ...
    version# type username@ADS.IU.EDU
    ...

    > ktutil -k mykeytab remove -V version# -e type username@ADS.IU.EDU

## Merge keytab files

If you have multiple keytab files that need to be in one place, you can merge the keys with the `ktutil` command.

To merge keytab files using MIT Kerberos, use:

    > ktutil
    ktutil: read_kt mykeytab-1
    ktutil: read_kt mykeytab-2
    ktutil: read_kt mykeytab-3
    ktutil: write_kt krb5.keytab
    ktutil: quit

Replace `mykeytab-(number)` with the name of each keytab file. The final merged keytab would be `krb5.keytab`.

To verify the merge, use:

    klist -k krb5.keytab

To do the same thing using Heimdal Kerberos, use:

    > ktutil copy mykeytab-1 krb5.keytab
    > ktutil copy mykeytab-2 krb5.keytab
    > ktutil copy mykeytab-3 krb5.keytab

Then, to verify the merge, use:

    ktutil -k krb5.keytab list

## Copy a keytab file to another computer

The keytab file is independent of the computer it's created on, its filename, and its location in the file system. Once it's created, you **can rename** it, move it to another location on the same computer, or move it to another Kerberos computer, and it will still function. The keytab file is a binary file, so be sure to transfer it in a way that does not corrupt it.

If possible, use [SCP](https://kb.iu.edu/d/agye) or another secure method to transfer the keytab between computers. If you have to use [FTP](https://kb.iu.edu/d/aerg), be sure to issue the bin command from your FTP client before transferring the file. This will set the transfer type to binary so the keytab file will not be corrupted.
