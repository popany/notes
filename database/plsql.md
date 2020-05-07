# plsql

- [plsql](#plsql)
  - [状态查询](#%e7%8a%b6%e6%80%81%e6%9f%a5%e8%af%a2)
    - [查询锁表](#%e6%9f%a5%e8%af%a2%e9%94%81%e8%a1%a8)
  - [存储过程](#%e5%ad%98%e5%82%a8%e8%bf%87%e7%a8%8b)
    - [参考](#%e5%8f%82%e8%80%83)
    - [创建存储过程](#%e5%88%9b%e5%bb%ba%e5%ad%98%e5%82%a8%e8%bf%87%e7%a8%8b)
    - [调试存储过程](#%e8%b0%83%e8%af%95%e5%ad%98%e5%82%a8%e8%bf%87%e7%a8%8b)

## 状态查询

### 查询锁表

    SELECT object_name, machine, s.sid, s.serial#
    FROM gv$locked_object l, dba_objects o, gv$session s
    WHERE l.object_id　= o.object_id
    AND l.session_id = s.sid;

## 存储过程

### 参考

[PL/Sql 中创建、调试、调用存储过程](https://www.cnblogs.com/arxive/p/5959594.html)

### 创建存储过程

### 调试存储过程

