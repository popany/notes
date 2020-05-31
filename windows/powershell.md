# PowerShell

- [PowerShell](#powershell)
  - [`rm -rf`](#rm--rf)
  - [delete empty files](#delete-empty-files)
  - [head/tail](#headtail)
  - [Select-String](#select-string)
  - [Run a string](#run-a-string)
  - [String replace](#string-replace)
  - [match](#match)
  - [Sleep](#sleep)
  - [Variables and Arrays](#variables-and-arrays)
    - [Array List](#array-list)
  - [Print environment variable](#print-environment-variable)
  - [Path](#path)
    - [Create folder if not exists](#create-folder-if-not-exists)
    - [Get obsolute path](#get-obsolute-path)
    - [Recursive file search](#recursive-file-search)
  - [Loop through Files and Folders](#loop-through-files-and-folders)
    - [List Files](#list-files)
    - [Display the contents of child directories](#display-the-contents-of-child-directories)
    - [ForEach loop](#foreach-loop)
  - [Count the files in a folder](#count-the-files-in-a-folder)
  - [Run .ps1 from cmd](#run-ps1-from-cmd)
  - [Gaining administrator privileges in PowerShell](#gaining-administrator-privileges-in-powershell)
  - [Environment Variable](#environment-variable)
    - [Use PowerShell to Set Environment Variables](#use-powershell-to-set-environment-variables)
      - [Set a locally scoped Environment Variable](#set-a-locally-scoped-environment-variable)
      - [Set an Environment Variable scoped to the User](#set-an-environment-variable-scoped-to-the-user)
      - [Set an Environment Variable scoped to the Machine](#set-an-environment-variable-scoped-to-the-machine)
    - [Reload the path in PowerShell](#reload-the-path-in-powershell)

## `rm -rf`

    rm C:\path\to\delete -r -fo

## delete empty files

    get-childItem "PathToFiles" | where {$_.length -eq 0} | remove-Item

## head/tail

    gc file-name | select -first 100
    gc file-name | select -last 100

## Select-String

    Select-String [-pattern] <string[]>

[select-string how to only return first match line in first file](https://stackoverflow.com/questions/25382056/select-string-how-to-only-return-first-match-line-in-first-file)

    $m = Select-String -Pattern get -Path *.ps1 -list -SimpleMatch | select-object -First 1
    $m.Line
    $m.Path

## Run a string

    $commandString = "ls"
    & $commandString

    $commandString = "help ls"
    iex $commandString

## String replace

    ("this is test").Replace(" ", "-") 

## match

    git diff HEAD master --name-only| ForEach-Object { if ($_ -match "code/(ProjectNamePrefix.*?)/") {$matches[0] + $matches[1] + ".csproj"}} | Group-Object | Select -ExpandProperty Name

## Sleep

Sleep 10s

    Start-Sleep -s 10

Sleep 1000ms

    Start-Sleep -m 1000

## [Variables and Arrays](https://blog.netwrix.com/2018/10/04/powershell-variables-and-arrays/)

### Array List

    $array1 = New-Object System.Collections.ArrayList
    $array1.Add("one")
    $array1.Add("two")
    $array1.Add("three")
    $array1.Remove("three")
    foreach($a in $array1)
    {
        Write-output $a
    }

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

## Count the files in a folder

    (Get-ChildItem | Measure-Object).Count

    (Get-ChildItem -Directory | Measure-Object).Count

    (Get-ChildItem -File | Measure-Object).Count

    (Get-ChildItem -Recurse | Measure-Object).Count

## Run .ps1 from cmd

    powershell -file "C:\Program Files (x86)\DAUM\test.ps1"

## [Gaining administrator privileges in PowerShell](https://serverfault.com/questions/11879/gaining-administrator-privileges-in-powershell)

    start-process powershell –verb runAs

## Environment Variable

### [Use PowerShell to Set Environment Variables](https://www.tachytelic.net/2019/03/powershell-environment-variables/)

#### Set a locally scoped Environment Variable

To create an environment variable that is local to your current PowerShell session, simply use:

    $env:SiteName = 'tachytelic.net'

#### Set an Environment Variable scoped to the User

To set an environment variable which will be available to all processes that your account runs, use the following:

    [System.Environment]::SetEnvironmentVariable('siteName','tachytelic.net',[System.EnvironmentVariableTarget]::User)

#### Set an Environment Variable scoped to the Machine

To create an environment variable visible to every process running on the machine:

    [System.Environment]::SetEnvironmentVariable('siteName','tachytelic.net',[System.EnvironmentVariableTarget]::Machine)

Note: This command will probably fail unless you run PowerShell as an administrator.

### [Reload the path in PowerShell](https://stackoverflow.com/questions/17794507/reload-the-path-in-powershell)

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
