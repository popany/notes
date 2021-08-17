# Connection Keep Alive

- [Connection Keep Alive](#connection-keep-alive)
  - [SQLNET.EXPIRE_TIME and ENABLE=BROKEN](#sqlnetexpire_time-and-enablebroken)
  - [`(ENABLE=BROKEN)` on the client](#enablebroken-on-the-client)
  - [SQLNET.EXPIRE_TIME on the server](#sqlnetexpire_time-on-the-server)

## [SQLNET.EXPIRE_TIME and ENABLE=BROKEN](https://blog.dbi-services.com/sqlnet-expire_time-and-enablebroken/)

Those parameters, `SQLNET.EXPIRE_TIME` in sqlnet.ora and `ENABLE=BROKEN` in a connection description exist for a long time but may have changed in behavior. They are both related to detecting dead TCP connections with keep-alive probes. The former from the server, and the latter from the client.

## `(ENABLE=BROKEN)` on the client

tnsnames.ora

    ORCLPDB1=
      (DESCRIPTION =
        (ENABLE=BROKEN)
        (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = ORCLPDB1)
        )
      )

## SQLNET.EXPIRE_TIME on the server

On the server side, we have seen that `SO_KEEPALIVE` is set - using the TCP defaults. But, there, it may be important to detect dead connections faster because a session may hold some locks. You can (and should) set a lower value in sqlnet.ora with `SQLNET.EXPIRE_TIME`. Before 12c this parameter was used to send TNS packets as keep-alive probes but now that `SO_KEEPALIVE` is set, this parameter will control the keep-alive idle time (using `TCP_KEEPIDL` instead of the default `/proc/sys/net/ipv4/tcp_keepalive_time`).

Here is the same as my first test (without the client `ENABLE=BROKER`) but after having set `SQLNET.EXPIRE_TIME=42` in `$ORACLE_HOME/network/admin/sqlnet.ora`.

Side note: I've got the "do we need to restart the listener?" question very often about changes in sqlnet.ora but the answer is clearly "no". This file is read for each new connection to the database. The listener forks the server (aka shadow) process and this one reads the sqlnet.ora, as we can see here when I "strace -f" the listener but the forked process is setting-up the socket.
