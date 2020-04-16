# PowerShell

- [PowerShell](#powershell)
  - [head/tail](#headtail)
  - [Sleep](#sleep)
  - [Loop through Files and Folders](#loop-through-files-and-folders)
    - [List Files](#list-files)
    - [Display the contents of child directories](#display-the-contents-of-child-directories)
    - [ForEach loop](#foreach-loop)

## head/tail

    gc file-name | select -first 100
    gc file-name | select -last 100

## Sleep

Sleep 10s

    Start-Sleep –s 10

Sleep 1000ms

    Start-Sleep -m 1000

## Loop through Files and Folders

### List Files

    Get-ChildItem -Path .

### Display the contents of child directories

    Get-ChildItem -Path . –Recurse

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
