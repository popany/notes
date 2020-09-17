# [What Is Svchost.exe?](https://www.lifewire.com/scvhost-exe-4174462)

- [What Is Svchost.exe?](#what-is-svchostexe)
  - [Which Software Use Svchost.exe?](#which-software-use-svchostexe)
  - [Is Svchost.exe a Virus?](#is-svchostexe-a-virus)
  - [How to Shut Down an Svchost.exe Service](#how-to-shut-down-an-svchostexe-service)
  - [How to Remove an Svchost.exe Virus](#how-to-remove-an-svchostexe-virus)

The svchost.exe (Service Host) file is an important system process provided by Microsoft in Windows operating systems. Under normal circumstances, the svchost file is not a virus but a critical component for a number of Windows [services](https://www.lifewire.com/what-is-a-service-4107276).

The purpose for svchost.exe is to, as the name would imply, host services. Windows uses svchost.exe to group together services that need access to the same DLLs so that they can run in one process, helping to reduce their demand for system resources.

Because Windows uses the Service Host process for so many tasks, it’s common to see increased RAM usage of svchost.exe in Task Manager. You'll also see many different instances of svchost.exe running in Task Manager because Windows groups similar services together, such as network related services.

Given that svchost.exe is such a critical component in Windows, you shouldn't delete it or quarantine it unless you’ve verified that the svchost.exe file you’re dealing with is unnecessary or malicious. There can be only two folders where the real svchost.exe is stored, making it easy to spot a fake.

## Which Software Use Svchost.exe?

The svchost.exe process starts when Windows starts, and then checks the [HKLM hive](https://www.lifewire.com/hkey-local-machine-2625902) of the [registry](https://www.lifewire.com/windows-registry-2625992) (under SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost) for services it should load into memory.

A few examples of Windows services that use svchost.exe include:

- Windows Update
- Background Tasks Infrastructure Service
- Plug and Play
- World Wide Web Publishing Service
- Bluetooth Support Service
- Windows Firewall
- Task Scheduler
- DHCP Client
- Windows Audio
- Superfetch
- Network Connections
- Remote Procedure Call (RPC)

## Is Svchost.exe a Virus?

Not usually, but it doesn’t hurt to check, especially if you have no idea why svchost.exe is taking up all the memory on your computer.

The first step in identifying whether svchost.exe is a virus is determining which services each svchost.exe instance is hosting. Since you probably have multiple svchost.exe instances running in Task Manager, you have to dive a little deeper to see what each process is actually doing before deciding whether to delete the svchost process or disable the service running inside.

Once you know what services are running within svchost.exe, you can see if they’re real and necessary or if malware is pretending to be svchost.exe.

If you have Windows 10 or Windows 8, you can “open” each svchost.exe file from Task Manager.

Another option is to use the tasklist command in Command Prompt to spit out a list of all the services used by all the svchost.exe instances.

## How to Shut Down an Svchost.exe Service

What most people probably want to do with the svchost process is delete or disable a service running inside svchost.exe because it’s using too much memory. However, even if you want to delete svchost.exe because it’s a virus, follow these instructions anyway because it'll be helpful for the service to be disabled before trying to delete it.

## How to Remove an Svchost.exe Virus

You can’t delete the real svchost.exe file from your computer because it’s too integral and important of a process, but you can remove fake ones. If you have an svchost.exe file that’s located anywhere but in the %SystemRoot%\System32\ or %SystemRoot%\SysWOW64\ folder, it’s 100 percent safe to delete.






