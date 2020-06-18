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
  - [Check if string is in list of strings](#check-if-string-is-in-list-of-strings)
  - [Run .ps1 from cmd](#run-ps1-from-cmd)
  - [Gaining administrator privileges in PowerShell](#gaining-administrator-privileges-in-powershell)
  - [Understanding Booleans in PowerShell](#understanding-booleans-in-powershell)
  - [about_Logical_Operators](#about_logical_operators)
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

- Example 1

      git diff HEAD master --name-only| ForEach-Object { if ($_ -match "code/(ProjectNamePrefix.*?)/") {$matches[0] + $matches[1] + ".csproj"}} | Group-Object | Select -ExpandProperty Name

- Example 2

     "abc\def\ghi" -match "abc\\(.*?)\\(.*)" | % {$matches}

- Example 3

      $def = "abc\def\ghi" -match "abc\\(.*?)\\(.*)" | % {$matches[1]}

- [Example 4](https://social.technet.microsoft.com/Forums/scriptcenter/en-US/66107c99-67c4-40bc-b49a-f0134c4235b3/powershell-matches-collection)

      $ex=new-object System.Text.RegularExpressions.Regex("abc\\(.*?)\\(.*)", [System.Text.RegularExpressions.RegexOptions]::Singleline)
      $m=$ex.Matches('abc\def\ghi')
      $count = $m.count
      $def = $m.groups[1].value

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

## [Check if string is in list of strings](https://stackoverflow.com/questions/47096341/check-if-string-is-in-list-of-strings)

    $MachineList = "srv-a*", "srv-b*", "srv-c*", ...
    ...
    if ($MachineList | Where-Object {$Machine.Name -like $_}) {
        ...
    }

## Run .ps1 from cmd

    powershell -file "C:\Program Files (x86)\DAUM\test.ps1"

## [Gaining administrator privileges in PowerShell](https://serverfault.com/questions/11879/gaining-administrator-privileges-in-powershell)

    start-process powershell –verb runAs

## [Understanding Booleans in PowerShell](https://social.technet.microsoft.com/wiki/contents/articles/2286.understanding-booleans-in-powershell.aspx)

## [about_Logical_Operators](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logical_operators?view=powershell-7)

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
