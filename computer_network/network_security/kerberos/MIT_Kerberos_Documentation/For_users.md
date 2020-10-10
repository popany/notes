# [For users](https://web.mit.edu/kerberos/krb5-latest/doc/user/index.html)

- [For users](#for-users)
  - [Password management](#password-management)
    - [Changing your password](#changing-your-password)
    - [Granting access to your account](#granting-access-to-your-account)
  - [Ticket management](#ticket-management)
    - [Kerberos ticket properties](#kerberos-ticket-properties)
    - [Obtaining tickets with kinit](#obtaining-tickets-with-kinit)
      - [Note](#note)
    - [Viewing tickets with klist](#viewing-tickets-with-klist)
    - [Destroying tickets with kdestroy](#destroying-tickets-with-kdestroy)
  - [User config files](#user-config-files)
    - [kerberos](#kerberos)
      - [DESCRIPTION](#description)
      - [ENVIRONMENT VARIABLES](#environment-variables)
    - [.k5login](#k5login)
      - [DESCRIPTION](#description-1)
      - [EXAMPLES](#examples)
    - [.k5identity](#k5identity)
      - [DESCRIPTION](#description-2)
      - [EXAMPLE](#example)
  - [User commands](#user-commands)

## [Password management](https://web.mit.edu/kerberos/krb5-latest/doc/user/pwd_mgmt.html)

Your password is the only way Kerberos has of verifying your identity. If someone finds out your password, that person can masquerade as you—send email that comes from you, read, edit, or delete your files, or log into other hosts as you—and no one will be able to tell the difference. For this reason, it is important that you choose a good password, and keep it secret. If you need to give access to your account to someone else, you can do so through Kerberos (see [Granting access to your account](#granting-access-to-your-account)). You should never tell your password to anyone, including your system administrator, for any reason. You should change your password frequently, particularly any time you think someone may have found out what it is.

### Changing your password

To change your Kerberos password, use the [`kpasswd`](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kpasswd.html#kpasswd-1) command. It will ask you for your old password (to prevent someone else from walking up to your computer when you’re not there and changing your password), and then prompt you for the new one twice. (The reason you have to type it twice is to make sure you have typed it correctly.) For example, user david would do the following:

    shell% kpasswd
    Password for david:    <- Type your old password.
    Enter new password:    <- Type your new password.
    Enter it again:  <- Type the new password again.
    Password changed.
    shell%

If david typed the incorrect old password, he would get the following message:

    shell% kpasswd
    Password for david:  <- Type the incorrect old password.
    kpasswd: Password incorrect while getting initial ticket
    shell%

If you make a mistake and don’t type the new password the same way twice, kpasswd will ask you to try again:

    shell% kpasswd
    Password for david:  <- Type the old password.
    Enter new password:  <- Type the new password.
    Enter it again: <- Type a different new password.
    kpasswd: Password mismatch while reading password
    shell%

Once you change your password, it **takes some time** for the change to propagate through the system. Depending on how your system is set up, this might be anywhere from a few minutes to an hour or more. If you need to get new Kerberos tickets shortly after changing your password, try the new password. If the new password doesn’t work, try again using the old one.

### Granting access to your account

If you need to give someone access to log into your account, you can do so through Kerberos, without telling the person your password. Simply create a file called `.k5login` in your home directory. This file should contain the Kerberos principal of each person to whom you wish to give access. Each principal must be on a separate line. Here is a sample .k5login file:

    jennifer@ATHENA.MIT.EDU
    david@EXAMPLE.COM

This file would allow the users jennifer and david to use your user ID, provided that they had Kerberos tickets in their respective realms. If you will be logging into other hosts across a network, you will want to include your own Kerberos principal in your .k5login file on each of these hosts.

Using a .k5login file is much safer than giving out your password, because:

- You can take access away any time simply by removing the principal from your .k5login file.

- Although the user has full access to your account on one particular host (or set of hosts if your .k5login file is shared, e.g., over NFS), that user does not inherit your network privileges.

- Kerberos keeps a log of who obtains tickets, so a system administrator could find out, if necessary, who was capable of using your user ID at a particular time.

One common application is to have a .k5login file in root’s home directory, giving root access to that machine to the Kerberos principals listed. This allows system administrators to allow users to become root locally, or to log in remotely as root, without their having to give out the root password, and without anyone having to type the root password over the network.

## [Ticket management](https://web.mit.edu/kerberos/krb5-latest/doc/user/tkt_mgmt.html)

On many systems, Kerberos is built into the login program, and you get tickets **automatically** when you log in. Other programs, such as ssh, can forward copies of your tickets to a remote host. Most of these programs also automatically destroy your tickets when they exit. However, MIT recommends that you explicitly destroy your Kerberos tickets when you are through with them, just to be sure. One way to help ensure that this happens is to add the [kdestroy](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kdestroy.html#kdestroy-1) command to your .logout file. Additionally, if you are going to be away from your machine and are concerned about an intruder using your permissions, it is safest to either destroy all copies of your tickets, or use a screensaver that locks the screen.

### Kerberos ticket properties

There are various properties that Kerberos tickets can have:

If a ticket is **forwardable**, then the KDC can issue a new ticket (with a different network address, if necessary) based on the forwardable ticket. This allows for authentication forwarding without requiring a password to be typed in again. For example, if a user with a forwardable TGT logs into a remote system, the KDC could issue a new TGT for that user with the network address of the remote system, allowing authentication on that host to work as though the user were logged in locally.

When the KDC creates a new ticket based on a forwardable ticket, it sets the **forwarded** flag on that new ticket. Any tickets that are created based on a ticket with the forwarded flag set will also have their forwarded flags set.

A **proxiable** ticket is similar to a forwardable ticket in that it allows a service to take on the identity of the client. Unlike a forwardable ticket, however, a proxiable ticket is only **issued for specific services**. In other words, a ticket-granting ticket cannot be issued based on a ticket that is proxiable but not forwardable.

A **proxy** ticket is one that was issued based on a proxiable ticket.

A **postdated** ticket is issued with the invalid flag set. After the starting time listed on the ticket, it can be presented to the KDC to obtain valid tickets.

Ticket-granting tickets with the **postdateable** flag set can be used to obtain postdated service tickets.

**Renewable** tickets can be used to obtain new session keys without the user entering their password again. A renewable ticket has two expiration times. The first is the time at which this particular ticket expires. The second is the latest possible expiration time for any ticket issued based on this renewable ticket.

A ticket with the **initial flag** set was issued based on the authentication protocol, and not on a ticket-granting ticket. Application servers that wish to ensure that the user’s key has been recently presented for verification could specify that this flag must be set to accept the ticket.

An **invalid** ticket must be rejected by application servers. Postdated tickets are usually issued with this flag set, and must be validated by the KDC before they can be used.

A **preauthenticated** ticket is one that was only issued after the client requesting the ticket had authenticated itself to the KDC.

The **hardware authentication** flag is set on a ticket which required the use of hardware for authentication. The hardware is expected to be possessed only by the client which requested the tickets.

If a ticket has the **transit policy** checked flag set, then the KDC that issued this ticket implements the transited-realm check policy and checked the transited-realms list on the ticket. The transited-realms list contains a list of all intermediate realms between the realm of the KDC that issued the first ticket and that of the one that issued the current ticket. If this flag is not set, then the application server must check the transited realms itself or else reject the ticket.

The **okay as delegate** flag indicates that the server specified in the ticket is suitable as a delegate as determined by the policy of that realm. Some client applications may use this flag to decide whether to forward tickets to a remote host, although many applications do not honor it.

An **anonymous** ticket is one in which the named principal is a generic principal for that realm; it does not actually specify the individual that will be using the ticket. This ticket is meant only to securely distribute a session key.

### Obtaining tickets with kinit

If your site has integrated Kerberos V5 with the login system, you will get Kerberos tickets automatically when you log in. Otherwise, you may need to explicitly obtain your Kerberos tickets, using the [kinit](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kinit.html#kinit-1) program. Similarly, if your Kerberos tickets expire, use the kinit program to obtain new ones.

To use the kinit program, simply type `kinit` and then type your password at the prompt. For example, Jennifer (whose username is `jennifer`) works for Bleep, Inc. (a fictitious company with the domain name mit.edu and the Kerberos realm ATHENA.MIT.EDU). She would type:

    shell% kinit
    Password for jennifer@ATHENA.MIT.EDU: <-- [Type jennifer's password here.]
    shell%

If you type your password incorrectly, kinit will give you the following error message:

    shell% kinit
    Password for jennifer@ATHENA.MIT.EDU: <-- [Type the wrong password here.]
    kinit: Password incorrect
    shell%

and you won’t get Kerberos tickets.

By default, kinit assumes you want tickets for your own username in your default realm. Suppose Jennifer’s friend David is visiting, and he wants to borrow a window to check his mail. David needs to get tickets for himself in his own realm, EXAMPLE.COM. He would type:

    shell% kinit david@EXAMPLE.COM
    Password for david@EXAMPLE.COM: <-- [Type david's password here.]
    shell%

David would then have tickets which he could use to log onto his own machine. Note that he typed his password locally on Jennifer’s machine, but it never went over the network. Kerberos on the **local host** performed the authentication to the KDC in the other realm.

If you want to be able to forward your tickets to another host, you need to request forwardable tickets. You do this by specifying the `-f` option:

    shell% kinit -f
    Password for jennifer@ATHENA.MIT.EDU: <-- [Type your password here.]
    shell%

Note that kinit does not tell you that it obtained forwardable tickets; you can verify this using the [klist](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/klist.html#klist-1) command (see [Viewing tickets with klist](#viewing-tickets-with-klist)).

Normally, your tickets are good for your system’s default ticket lifetime, which is ten hours on many systems. You can specify a different ticket lifetime with the `-l` option. Add the letter `s` to the value for seconds, `m` for minutes, `h` for hours, or `d` for days. For example, to obtain forwardable tickets for `david@EXAMPLE.COM` that would be good for three hours, you would type:

    shell% kinit -f -l 3h david@EXAMPLE.COM
    Password for david@EXAMPLE.COM: <-- [Type david's password here.]
    shell%

#### Note

You cannot mix units; specifying a lifetime of 3h30m would result in an error. Note also that most systems specify a maximum ticket lifetime. If you request a longer ticket lifetime, it will be automatically truncated to the maximum lifetime.

### Viewing tickets with klist

The [klist](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/klist.html#klist-1) command shows your tickets. When you first obtain tickets, you will have only the ticket-granting ticket. The listing would look like this:

    shell% klist
    Ticket cache: /tmp/krb5cc_ttypa
    Default principal: jennifer@ATHENA.MIT.EDU

    Valid starting     Expires            Service principal
    06/07/04 19:49:21  06/08/04 05:49:19  krbtgt/ATHENA.MIT.EDU@ATHENA.MIT.EDU
    shell%

The ticket cache is the location of your ticket file. In the above example, this file is named `/tmp/krb5cc_ttypa`. The default principal is your Kerberos principal.

The “valid starting” and “expires” fields describe the period of time during which the ticket is valid. The “service principal” describes each ticket. The ticket-granting ticket has a first component `krbtgt`, and a second component which is the realm name.

Now, if `jennifer` connected to the machine `daffodil.mit.edu`, and then typed “klist” again, she would have gotten the following result:

    shell% klist
    Ticket cache: /tmp/krb5cc_ttypa
    Default principal: jennifer@ATHENA.MIT.EDU

    Valid starting     Expires            Service principal
    06/07/04 19:49:21  06/08/04 05:49:19  krbtgt/ATHENA.MIT.EDU@ATHENA.MIT.EDU
    06/07/04 20:22:30  06/08/04 05:49:19  host/daffodil.mit.edu@ATHENA.MIT.EDU
    shell%

Here’s what happened: when `jennifer` used ssh to connect to the host `daffodil.mit.edu`, the ssh program presented her ticket-granting ticket to the KDC and requested a host ticket for the host `daffodil.mit.edu`. The KDC sent the host ticket, which ssh then presented to the host `daffodil.mit.edu`, and she was allowed to log in without typing her password.

Suppose your Kerberos tickets allow you to log into a host in another domain, such as `trillium.example.com`, which is also in another Kerberos realm, `EXAMPLE.COM`. If you ssh to this host, you will receive a ticket-granting ticket for the realm `EXAMPLE.COM`, plus the new host ticket for `trillium.example.com`. klist will now show:

    shell% klist
    Ticket cache: /tmp/krb5cc_ttypa
    Default principal: jennifer@ATHENA.MIT.EDU

    Valid starting     Expires            Service principal
    06/07/04 19:49:21  06/08/04 05:49:19  krbtgt/ATHENA.MIT.EDU@ATHENA.MIT.EDU
    06/07/04 20:22:30  06/08/04 05:49:19  host/daffodil.mit.edu@ATHENA.MIT.EDU
    06/07/04 20:24:18  06/08/04 05:49:19  krbtgt/EXAMPLE.COM@ATHENA.MIT.EDU
    06/07/04 20:24:18  06/08/04 05:49:19  host/trillium.example.com@EXAMPLE.COM
    shell%

Depending on your host’s and realm’s configuration, you may also see a ticket with the service principal `host/trillium.example.com@`. If so, this means that your host did not know what realm `trillium.example.com` is in, so it asked the `ATHENA.MIT.EDU` KDC for a referral. The next time you connect to `trillium.example.com`, the odd-looking entry will be used to avoid needing to ask for a referral again.

You can use the -f option to view the flags that apply to your tickets. The flags are:

|||
|-|-|
F|Forwardable
f|forwarded
P|Proxiable
p|proxy
D|postDateable
d|postdated
R|Renewable
I|Initial
i|invalid
H|Hardware authenticated
A|preAuthenticated
T|Transit policy checked
O|Okay as delegate
a|anonymous
|||

Here is a sample listing. In this example, the user jennifer obtained her initial tickets (`I`), which are forwardable (`F`) and postdated (`d`) but not yet validated (`i`):

    shell% klist -f
    Ticket cache: /tmp/krb5cc_320
    Default principal: jennifer@ATHENA.MIT.EDU

    Valid starting      Expires             Service principal
    31/07/05 19:06:25  31/07/05 19:16:25  krbtgt/ATHENA.MIT.EDU@ATHENA.MIT.EDU
            Flags: FdiI
    shell%

In the following example, the user david’s tickets were forwarded (`f`) to this host from another host. The tickets are reforwardable (`F`):

    shell% klist -f
    Ticket cache: /tmp/krb5cc_p11795
    Default principal: david@EXAMPLE.COM

    Valid starting     Expires            Service principal
    07/31/05 11:52:29  07/31/05 21:11:23  krbtgt/EXAMPLE.COM@EXAMPLE.COM
            Flags: Ff
    07/31/05 12:03:48  07/31/05 21:11:23  host/trillium.example.com@EXAMPLE.COM
            Flags: Ff
    shell%

### Destroying tickets with kdestroy

Your Kerberos tickets are proof that you are indeed yourself, and tickets could be stolen if someone gains access to a computer where they are stored. If this happens, the person who has them can masquerade as you until they expire. For this reason, you should destroy your Kerberos tickets when you are away from your computer.

Destroying your tickets is easy. Simply type kdestroy:

    shell% kdestroy
    shell%

If [kdestroy](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kdestroy.html#kdestroy-1) fails to destroy your tickets, it will beep and give an error message. For example, if kdestroy can’t find any tickets to destroy, it will give the following message:

    shell% kdestroy
    kdestroy: No credentials cache file found while destroying cache
    shell%

## [User config files](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_config/index.html)

The following files in your home directory can be used to control the behavior of Kerberos as it applies to your account (unless they have been disabled by your host’s configuration):

### [kerberos](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_config/kerberos.html)

#### DESCRIPTION

The Kerberos system authenticates individual users in a network environment. After authenticating yourself to Kerberos, you can use **Kerberos-enabled programs** without having to present passwords or certificates to those programs.

If you receive the following response from [kinit](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kinit.html#kinit-1):

kinit: Client not found in Kerberos database while getting initial credentials

you haven’t been registered as a Kerberos user. See your system administrator.

A Kerberos name usually contains three parts. The first is the **primary**, which is usually a user’s or service’s name. The second is the **instance**, which in the case of a user is usually null. Some users may have privileged instances, however, such as `root` or `admin`. In the case of a service, the instance is the fully qualified name of the machine on which it runs; i.e. there can be an ssh service running on the machine ABC (ssh/ABC@REALM), which is different from the ssh service running on the machine XYZ (ssh/XYZ@REALM). The third part of a Kerberos name is the **realm**. The realm corresponds to the Kerberos service providing authentication for the principal. Realms are conventionally all-uppercase, and often match the end of hostnames in the realm (for instance, host01.example.com might be in realm EXAMPLE.COM).

When writing a Kerberos name, the principal name is separated from the instance (if not null) by a slash, and the realm (if not the local realm) follows, preceded by an “@” sign. The following are examples of valid Kerberos names:

    david
    jennifer/admin
    joeuser@BLEEP.COM
    cbrown/root@FUBAR.ORG

When you authenticate yourself with Kerberos you get an initial Kerberos **ticket**. (A Kerberos ticket is an encrypted protocol message that provides authentication.) Kerberos uses this ticket for network utilities such as ssh. The ticket transactions are done transparently, so you don’t have to worry about their management.

Note, however, that tickets expire. Administrators may configure more privileged tickets, such as those with service or instance of `root` or `admin`, to expire in a few minutes, while tickets that carry more ordinary privileges may be good for several hours or a day. If your login session extends beyond the time limit, you will have to re-authenticate yourself to Kerberos to get new tickets using the [kinit](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kinit.html#kinit-1) command.

Some tickets are **renewable** beyond their initial lifetime. This means that `kinit -R` can **extend their lifetime** without requiring you to re-authenticate.

If you wish to delete your local tickets, use the [kdestroy](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/kdestroy.html#kdestroy-1) command.

Kerberos tickets can be forwarded. In order to forward tickets, you must request **forwardable** tickets when you kinit. Once you have forwardable tickets, most Kerberos programs have a command line option to forward them to the remote host. This can be useful for, e.g., running kinit on your local machine and then sshing into another to do work. Note that this should not be done on untrusted machines since they will then have your tickets.

#### ENVIRONMENT VARIABLES

### [.k5login](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_config/k5login.html)

#### DESCRIPTION

The .k5login file, which resides in a user’s home directory, contains a list of the Kerberos principals. Anyone with valid tickets for a principal in the file is allowed host access with the UID of the user in whose home directory the file resides. One common use is to place a .k5login file in root’s home directory, thereby granting system administrators remote root access to the host via Kerberos.

#### EXAMPLES

Suppose the user `alice` had a .k5login file in her home directory containing just the following line:

    bob@FOOBAR.ORG

This would allow `bob` to use **Kerberos network applications**, such as ssh(1), to access `alice`’s account, using `bob`’s Kerberos tickets. In a default configuration (with **k5login_authoritative** set to true in [krb5.conf](https://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/krb5_conf.html#krb5-conf-5)), this .k5login file would not let `alice` use those network applications to access her account, since she is not listed! With no .k5login file, or with **k5login_authoritative** set to false, a default rule would permit the principal `alice` in the machine’s default realm to access the `alice` account.

Let us further suppose that `alice` is a system administrator. Alice and the other system administrators would have their principals in root’s .k5login file on each host:

    alice@BLEEP.COM

    joeadmin/root@BLEEP.COM

This would allow either system administrator to log in to these hosts using their Kerberos tickets instead of having to type the root password. Note that because `bob` retains the Kerberos tickets for his own principal, `bob@FOOBAR.ORG`, he would not have any of the privileges that require `alice`’s tickets, such as root access to any of the site’s hosts, or the ability to change `alice`’s password.

### [.k5identity](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_config/k5identity.html)

#### DESCRIPTION

The .k5identity file, which resides in a user’s home directory, contains a list of rules for selecting a client principals based on the server being accessed. These rules are used to choose a **credential cache** within the cache collection when possible.

Blank lines and lines beginning with # are ignored. Each line has the form:

    principal field=value …

If the server principal meets all of the field constraints, then principal is chosen as the client principal. The following **fields** are recognized:

- realm

  If the realm of the server principal is known, it is matched against value, which may be a pattern using shell wildcards. For host-based server principals, the realm will generally only be known if there is a [domain_realm] section in krb5.conf with a mapping for the hostname.

- service

  If the server principal is a host-based principal, its service component is matched against value, which may be a pattern using shell wildcards.

- host

  If the server principal is a host-based principal, its hostname component is converted to lower case and matched against value, which may be a pattern using shell wildcards.

If the server principal matches the constraints of multiple lines in the .k5identity file, the principal from the first matching line is used. If no line matches, credentials will be selected some other way, such as the realm heuristic or the current primary cache.

#### EXAMPLE

The following example .k5identity file selects the client principal `alice@KRBTEST.COM` if the server principal is within that realm, the principal `alice/root@EXAMPLE.COM` if the server host is within a servers subdomain, and the principal `alice/mail@EXAMPLE.COM` when accessing the IMAP service on `mail.example.com`:

alice@KRBTEST.COM       realm=KRBTEST.COM
alice/root@EXAMPLE.COM  host=*.servers.example.com
alice/mail@EXAMPLE.COM  host=mail.example.com service=imap

## [User commands](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/index.html)
