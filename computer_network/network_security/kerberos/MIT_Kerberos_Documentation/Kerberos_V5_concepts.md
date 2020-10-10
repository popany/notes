# [Kerberos V5 concepts](https://web.mit.edu/kerberos/krb5-latest/doc/basic/index.html)

- [Kerberos V5 concepts](#kerberos-v5-concepts)
  - [Credential cache](#credential-cache)
  - [keytab](#keytab)
    - [Default keytab](#default-keytab)
    - [Default client keytab](#default-client-keytab)
  - [replay cache](#replay-cache)
  - [stash file](#stash-file)
  - [Supported date and time formats](#supported-date-and-time-formats)

## [Credential cache](https://web.mit.edu/kerberos/krb5-latest/doc/basic/ccache_def.html)

## [keytab](https://web.mit.edu/kerberos/krb5-latest/doc/basic/keytab_def.html)

A keytab (short for “key table”) stores **long-term keys** for one or more principals. Keytabs are normally represented by files in a standard format, although in rare cases they can be represented in other ways. Keytabs are used most often to **allow server applications to accept authentications from clients**, but can also be used to **obtain initial credentials for client applications**.

Keytabs are named using the format type:value. Usually type is `FILE` and value is the absolute pathname of the file. The other possible value for type is `MEMORY`, which indicates a temporary keytab stored in the memory of the current process.

A keytab contains one or more entries, where each entry consists of a timestamp (indicating when the entry was written to the keytab), a principal name, a key version number, an encryption type, and the **encryption key** itself.

A keytab can be displayed using the [klist](https://web.mit.edu/kerberos/krb5-latest/doc/user/user_commands/klist.html#klist-1) command with the `-k` option. Keytabs can be created or appended to by extracting keys from the KDC database using the [kadmin](https://web.mit.edu/kerberos/krb5-latest/doc/admin/admin_commands/kadmin_local.html#kadmin-1) [ktadd](https://web.mit.edu/kerberos/krb5-latest/doc/admin/admin_commands/kadmin_local.html#ktadd) command. Keytabs can be manipulated using the [ktutil](https://web.mit.edu/kerberos/krb5-latest/doc/admin/admin_commands/ktutil.html#ktutil-1) and [k5srvutil](https://web.mit.edu/kerberos/krb5-latest/doc/admin/admin_commands/k5srvutil.html#k5srvutil-1) commands.

### Default keytab

The default keytab is used by server applications if the application does not request a specific keytab. The name of the default keytab is determined by the following, in decreasing order of preference:

1. The `KRB5_KTNAME` environment variable.

2. The `default_keytab_name` profile variable in [[libdefaults](https://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/krb5_conf.html#libdefaults)].

3. The hardcoded default, [DEFKTNAME](https://web.mit.edu/kerberos/krb5-latest/doc/mitK5defaults.html#paths).

### Default client keytab

The default client keytab is used, if it is present and readable, to automatically obtain initial credentials for GSSAPI client applications. The principal name of the first entry in the client keytab is used by default when obtaining initial credentials. The name of the default client keytab is determined by the following, in decreasing order of preference:

1. The `KRB5_CLIENT_KTNAME` environment variable.

2. The `default_client_keytab_name` profile variable in [[libdefaults](https://web.mit.edu/kerberos/krb5-latest/doc/admin/conf_files/krb5_conf.html#libdefaults)].

3. The hardcoded default, [DEFCKTNAME](https://web.mit.edu/kerberos/krb5-latest/doc/mitK5defaults.html#paths).

## [replay cache](https://web.mit.edu/kerberos/krb5-latest/doc/basic/rcache_def.html)

## [stash file](https://web.mit.edu/kerberos/krb5-latest/doc/basic/stash_file_def.html)

## [Supported date and time formats](https://web.mit.edu/kerberos/krb5-latest/doc/basic/date_format.html)
