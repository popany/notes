# cmd

- [cmd](#cmd)
  - [timestamp](#timestamp)
  - [view all network shares](#view-all-network-shares)
  - [`7z`](#7z)
  - [Demos](#demos)
    - [`copy_file.bat`](#copy_filebat)

## timestamp

    echo %date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%

## view all network shares

    net share

## `7z`

- Compress directory

    7z a -r foo.zip foo

- Compress directory and delete files after compression

    7z a -r -sdel foo.zip foo

## Demos

### `copy_file.bat`

    @echo off
    set fromFilePath=%1
    set toFilePrefix=%2

    :loop
    copy %fromFilePath% "%toFilePrefix%-%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%-%time:~9,2%"
    timeout /T 10
    goto loop
