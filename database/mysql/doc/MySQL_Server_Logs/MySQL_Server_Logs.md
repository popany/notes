# [MySQL Server Logs](https://dev.mysql.com/doc/refman/8.0/en/server-logs.html)

- [MySQL Server Logs](#mysql-server-logs)
  - [5.4.1 Selecting General Query Log and Slow Query Log Output Destinations](#541-selecting-general-query-log-and-slow-query-log-output-destinations)
  - [5.4.4 The Binary Log](#544-the-binary-log)
  - [5.4.5 The Slow Query Log](#545-the-slow-query-log)
  - [5.4.6 Server Log Maintenance](#546-server-log-maintenance)

## [5.4.1 Selecting General Query Log and Slow Query Log Output Destinations](https://dev.mysql.com/doc/refman/8.0/en/log-destinations.html)

- set logging destination

      SET GLOBAL log_output = 'NONE';
      SET GLOBAL log_output = 'TABLE';
      SET GLOBAL log_output = 'FILE';
      SET GLOBAL log_output = 'TABLE,FILE';

- enable/disable general query log

      SET GLOBAL general_log = 'ON';
      SET GLOBAL general_log = 'OFF';

- show general log file path
  
      show global variables LIKE 'general_log_file'

## [5.4.4 The Binary Log](https://dev.mysql.com/doc/refman/8.0/en/binary-log.html)

## [5.4.5 The Slow Query Log](https://dev.mysql.com/doc/refman/8.0/en/slow-query-log.html)

## [5.4.6 Server Log Maintenance](https://dev.mysql.com/doc/refman/8.0/en/log-file-maintenance.html)
