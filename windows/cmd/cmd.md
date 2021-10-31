# cmd

- [cmd](#cmd)
  - [timestamp](#timestamp)
  - [view all network shares](#view-all-network-shares)
  - [`7z`](#7z)
  - [`wmic`](#wmic)
  - [配置路由](#配置路由)
    - [查看路由](#查看路由)
    - [跟踪路由](#跟踪路由)
    - [删除路由](#删除路由)
    - [新增路由](#新增路由)
  - [Demos](#demos)
    - [`copy_file.bat`](#copy_filebat)
  - [HowTo](#howto)
    - [How to Open an Elevated Command Prompt](#how-to-open-an-elevated-command-prompt)
    - [Windows CMD Batch, START and output redirection](#windows-cmd-batch-start-and-output-redirection)

## timestamp

    echo %date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%

## view all network shares

    net share

## `7z`

- Compress directory

    7z a -r foo.zip foo

- Compress directory and delete files after compression

    7z a -r -sdel foo.zip foo

## `wmic`

[View command line arguments for a running app](https://www.addictivetips.com/windows-tips/command-line-arguments-for-an-app-on-windows-10/)

    wmic path Win32_Process where handle='22792' get Commandline /format:list

## 配置路由

### 查看路由

    route print

### 跟踪路由

    tracert 14.215.177.39

### 删除路由

    route delete 0.0.0.0

### 新增路由

    route -p add 14.215.0.0 mask 255.255.0.0 192.168.43.1

## Demos

### `copy_file.bat`

    @echo off
    set fromFilePath=%1
    set toFilePrefix=%2

    :loop
    copy %fromFilePath% "%toFilePrefix%-%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%-%time:~9,2%"
    timeout /T 10
    goto loop


## HowTo

### [How to Open an Elevated Command Prompt](https://www.lifewire.com/how-to-open-an-elevated-command-prompt-2618088)

### [Windows CMD Batch, START and output redirection](https://superuser.com/questions/338277/windows-cmd-batch-start-and-output-redirection)

    start call delay.bat ^1^> log.txt ^2^>^&^1
