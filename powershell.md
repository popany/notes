# PowerShell

- [PowerShell](#powershell)
  - [head/tail](#headtail)
  - [Sleep](#sleep)
  - [Print environment variable](#print-environment-variable)
  - [Path](#path)
    - [Create folder if not exists](#create-folder-if-not-exists)
    - [Get obsolute path](#get-obsolute-path)
    - [Recursive file search](#recursive-file-search)
  - [Loop through Files and Folders](#loop-through-files-and-folders)
    - [List Files](#list-files)
    - [Display the contents of child directories](#display-the-contents-of-child-directories)
    - [ForEach loop](#foreach-loop)
  - [Run .ps1 from cmd](#run-ps1-from-cmd)

## head/tail

    gc file-name | select -first 100
    gc file-name | select -last 100

## Sleep

Sleep 10s

    Start-Sleep –s 10

Sleep 1000ms

    Start-Sleep -m 1000

## Print environment variable

    $env:PATH

## Path

### Create folder if not exists

    if(!(Test-Path -Path $TARGETDIR ))
    {
        New-Item -ItemType directory -Path $TARGETDIR
    }

or
    New-Item -Force -ItemType directory -Path foo

### Get obsolute path

    (Get-Item $cur_dir).FullName

### Recursive file search

    Get-ChildItem -Path V:\Myfolder -Filter file_name -Recurse -ErrorAction SilentlyContinue -Force

## Loop through Files and Folders

### List Files

    Get-ChildItem -Path .

### Display the contents of child directories

    Get-ChildItem -Path . -Recurse

### ForEach loop

    Get-ChildItem -Path .|Foreach-Object {
        echo $_.FullName
    }

or

    foreach($file in Get-ChildItem .)
    {
        echo $file.FullName
    }

with `-Filter`

    Get-ChildItem -Path . -Recurse -Filter *.log|Foreach-Object {
        echo $_.FullName
    }

with `Where-Object`

    Get-ChildItem . -Recurse |
    Where-Object { $_.CreationTime -lt ($(Get-Date).AddDays(-10))} |
    ForEach-Object {
       $_.FullName
    }

## Run .ps1 from cmd

    powershell -file "C:\Program Files (x86)\DAUM\test.ps1"
