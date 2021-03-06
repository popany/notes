# [How to add, modify, or delete registry subkeys and values by using a .reg file](https://support.microsoft.com/en-us/help/310516/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg)

- [How to add, modify, or delete registry subkeys and values by using a .reg file](#how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg-file)
  - [Notes](#notes)
  - [Summary](#summary)
    - [Syntax of .Reg Files](#syntax-of-reg-files)
    - [Adding Registry Subkeys or Adding and Changing Registry Values](#adding-registry-subkeys-or-adding-and-changing-registry-values)
    - [Deleting Registry Keys and Values](#deleting-registry-keys-and-values)
    - [Renaming Registry Keys and Values](#renaming-registry-keys-and-values)
    - [Distributing Registry Changes](#distributing-registry-changes)

## Notes

- This article is intended for advanced users, administrators, and IT Professionals.

- Importing Registration Entries (.reg) files is a feature of Regedit.exe and is not supported by Regedt32.exe. You can use Regedit.exe to make some changes to the registry on a Windows NT 4.0-based or Windows 2000-based computer, but some changes require Regedt32.exe. For example, you cannot add or change REG_EXPAND_SZ or REG_MULTI_SZ values with Regedit.exe on a Windows NT 4.0-based or Windows 2000-based computer. Regedt32.exe is the primary Registry Editor for Windows NT 4.0 and Windows 2000. If you must use Regedt32.exe, you cannot use Registration Entries (.reg) files to modify the registry. For more information about the differences between Regedit.exe and Regedt32.exe, click the following article number to view the article in the Microsoft Knowledge Base:
 
  - [141377](https://support.microsoft.com/help/141377) Differences between Regedit.exe and Regedt32.exe

## Summary

Important This section, method, or task contains steps that tell you how to modify the registry. However, serious problems might occur if you modify the registry incorrectly. Therefore, make sure that you follow these steps carefully. For added protection, back up the registry before you modify it. Then, you can restore the registry if a problem occurs. For more information about how to back up and restore the registry, click the following article number to view the article in the Microsoft Knowledge Base:

- [322756](https://support.microsoft.com/help/322756) How to back up and restore the registry in Windows

This step-by-step article describes how to add, modify, or delete registry subkeys and values by using a Registration Entries (.reg) file. Regedit.exe uses .reg files to import and export registry subkeys and values. You can use these .reg files to remotely distribute registry changes to several Windows-based computers. When you run a .reg file, the file contents merge into the local registry. Therefore, you must distribute .reg files with caution.

### Syntax of .Reg Files

A .reg file has the following syntax:

    RegistryEditorVersion
    Blank line
    [RegistryPath1]

    "DataItemName1"="DataType1:DataValue1"
    DataItemName2"="DataType2:DataValue2"
    Blank line
    [RegistryPath2]

    "DataItemName3"="DataType3:DataValue3"

where:

**RegistryEditorVersion** is either "Windows Registry Editor Version 5.00" for Windows 2000, Windows XP, and Windows Server 2003, or "REGEDIT4" for Windows 98 and Windows NT 4.0. The "REGEDIT4" header also works on Windows 2000-based, Windows XP-based, and Windows Server 2003-based computers.

**Blank line** is a blank line. This identifies the start of a new registry path. Each key or subkey is a new registry path. If you have several keys in your .reg file, blank lines can help you to examine and to troubleshoot the contents.

**RegistryPathx** is the path of the subkey that holds the first value you are importing. Enclose the path in square brackets, and separate each level of the hierarchy by a backslash. For example:

    [HKEY_LOCAL_ MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]

A .reg file can contain several registry paths. If the bottom of the hierarchy in the path statement does not exist in the registry, a new subkey is created. The contents of the registry files are sent to the registry in the order you enter them. Therefore, if you want to create a new subkey with another subkey below it, you must enter the lines in the correct order.

**DataItemNamex** is the name of the data item that you want to import. If a data item in your file does not exist in the registry, the .reg file adds it (with the value of the data item). If a data item does exist, the value in your .reg file overwrites the existing value. Quotation marks enclose the name of the data item. An equal sign (=) immediately follows the name of the data item.

**DataTypex** is the data type for the registry value and immediately follows the equal sign. For all the data types other than REG_SZ (a string value), a colon immediately follows the data type. If the data type is REG_SZ , do not include the data type value or colon. In this case, **Regedit.exe assumes REG_SZ** for the data type. The following table lists the typical registry data types:

|||
|-|-|
|Data Type|DataType in .reg|
|REG_BINARY|hexadecimal|
|REG_DWORD|dword|
|REG_EXPAND_SZ|hexadecimal(2)|
|REG_MULTI_SZ|hexadecimal(7)|

For more information about registry data types, click the following article number to view the article in the Microsoft Knowledge Base:

- [256986](https://support.microsoft.com/help/256986) Description of the Microsoft Windows registry

**DataValuex** immediately follows the colon (or the equal sign with REG_SZ) and must be in the appropriate format (for example, string or hexadecimal). Use hexadecimal format for binary data items.

Note You can enter several data item lines for the same registry path.

Note the registry file should contain a **blank line** at the **bottom of the file**.

### Adding Registry Subkeys or Adding and Changing Registry Values

To add a registry subkey or add or change a registry value, make the appropriate changes in the registry, and then export the appropriate subkey or subkeys. **Exported registry subkeys are automatically saved as .reg files**. To make changes to the registry and export your changes to a .reg file, follow these steps:

1. Click **Start**, click **Run**, type `regedit` in the **Open** box, and then click **OK**.

2. Locate and then click the subkey that holds the registry item or items that you want to change.

3. Click **File**, and then click **Export**.

   This step backs up the subkey before you make any changes. You can import this file back into the registry later if your changes cause a problem.

4. In the **File name** box, type a file name to use to save the .reg file with the original registry items, and then click Save.

   Note Use a file name that reminds you of the contents, such as a reference to the name of the subkey.

5. In the right pane, add or modify the registry items you want.

6. Repeat steps 3 and 4 to export the subkey again, but use a different file name for the .reg file. You can use this .reg file to make your registry changes on another computer.

7. Test your changes on the local computer. If they cause a problem, double-click the file that holds the backup of the original registry data to return the registry to its original state. If the changes work as expected, you can distribute the .reg you created in step 6 to other computers by using the methods in the "[Distributing Registry Changes](https://support.microsoft.com/en-us/help/310516/how-to-add-modify-or-delete-registry-subkeys-and-values-by-using-a-reg#2)" section of this article.

### Deleting Registry Keys and Values

To delete a registry key with a .reg file, put a hyphen (-) in front of the RegistryPath in the .reg file. For example, to delete the Test subkey from the following registry key:

    HKEY_LOCAL_MACHINE\Software

put a hyphen in front of the following registry key in the .reg file:

    HKEY_LOCAL_MACHINE\Software\Test

The following example has a .reg file that can perform this task.

    [-HKEY_LOCAL_MACHINE\Software\Test]

To delete a registry value with a .reg file, put a hyphen (-) after the equals sign following the DataItemName in the .reg file. For example, to delete the TestValue registry value from the following registry key:

    HKEY_LOCAL_MACHINE\Software\Test

put a hyphen after the "TestValue"= in the .reg file. The following example has a .reg file that can perform this task.

    HKEY_LOCAL_MACHINE\Software\Test
    "TestValue"=-

To create the .reg file, use Regedit.exe to export the registry key that you want to delete, and then use Notepad to edit the .reg file and insert the hyphen.

### Renaming Registry Keys and Values

To rename a key or value, delete the key or value, and then create a new key or value with the new name.

### Distributing Registry Changes

You can send a .reg file to users in an e-mail message, put a .reg file on a network share and direct users to the network share to run it, or you can add a command to the users' logon scripts to automatically import the .reg file when they log on. When users run the .reg file, they receive the following messages:

Are you sure you want to add the information in path of .reg file to the registry?

If the user clicks Yes, the user receives the following message:

Registry Editor
Information in path of .reg file has been successfully entered into the registry.

Regedit.exe supports a /s command-line switch to not display these messages. For example, to silently run the .reg file (with the /s switch) from a login script batch file, use the following syntax:

    regedit.exe /s path of .reg file

You can also use Group Policy or System Policy to distribute registry changes across your network. For additional information, visit the following Microsoft Web site:

    [Distributing Registry Changes](http://msdn2.microsoft.com/library/ms954395.aspx)

Note If the changes work, you can send the registration file to the appropriate users on the network.
