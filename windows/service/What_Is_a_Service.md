# [What Is a Service?](https://www.lifewire.com/what-is-a-service-4107276)

- [What Is a Service?](#what-is-a-service)
  - [How Are Services Used?](#how-are-services-used)
  - [How Do I Control Windows Services?](#how-do-i-control-windows-services)
  - [How to See What Services Are Running on Your Computer](#how-to-see-what-services-are-running-on-your-computer)
  - [How to Enable and Disable Windows Services](#how-to-enable-and-disable-windows-services)
  - [How to Delete/Uninstall Windows Services](#how-to-deleteuninstall-windows-services)
  - [More Information on Windows Services](#more-information-on-windows-services)

A service is a small program that usually starts when the Windows operating system loads. You won't normally interact with services like you do with regular programs because they run in the background (you don't see them) and don't provide a normal user interface.

## How Are Services Used?

Services can be used by Windows to control many things like printing, sharing files, communicating with Bluetooth devices, checking for software updates, hosting a website, etc.

A service can even be installed by a 3rd party, non-Windows program, like as a file backup tool, disk encryption program, online backup utility, and more.

## How Do I Control Windows Services?

Since services don't open and display options and windows like you're probably used to seeing with a program, you must use a built-in Windows tool to manipulate them.

Services is a tool with a user interface that communicates with what's called Service Control Manager so that you can work with services in Windows.

Another tool, the command-line Service Control utility (**sc.exe**), is available as well but it's more complex to use and so is unnecessary for most people.

## How to See What Services Are Running on Your Computer

The easiest way to open Services is through the Services shortcut in Administrative Tools, which is accessible via Control Panel.

Another option is to run **services.msc** from a Command Prompt or the Run dialog box (Win key+R).

If you're running Windows 10, Windows 8, Windows 7, or Windows Vista, you can also see services in Task Manager.

Services that are actively running right now will say Running in the Status column. Look at the screenshot at the top of this page to see what we mean.

Though there are many more, here are some examples of services you might see running on your computer: Apple Mobile Device Service, Bluetooth Support Service, DHCP Client, DNS Client, HomeGroup Listener, Network Connections, Plug and Play, Print Spooler, Security Center, Task Scheduler, Windows Firewall, and WLAN AutoConfig.

Double-clicking (or tapping) on any service will open its properties, which is where you can see the purpose for the service and, for some services, what will happen if you stop it. For example, opening the properties for Apple Mobile Device Service explains that the service is used to communicate with Apple devices that you plug into your computer.

## How to Enable and Disable Windows Services

Some services may need to be restarted for troubleshooting purposes if the program they belong to or the task they perform isn't working as it should. Other services may need to be stopped completely if you're trying to reinstall the software but an attached service won't stop on its own, or if you suspect that the service is being used maliciously.

With Services open, you can right-click (or press-and-hold) any of the services for more options, which let you start, stop, pause, resume, or restart it. These options are pretty self-explanatory.

As we said above, some services may need to be stopped if they're interfering with a software install or uninstall. Say for example that you're uninstalling an antivirus program, but for some reason the service is not shutting down with the program, causing you to be unable to completely remove the program because part of it is still running.

This is one case where you'd want to open Services, find the appropriate service, and choose Stop so that you can continue with the normal uninstall process.

One instance where you may need to restart a Windows service is if you're trying to print something but everything keeps getting hung up in the print queue. The common fix for this problem is to go into Services and choose Restart for the Print Spooler service.

You don't want to completely shut it down because the service needs to run in order for you to print. Restarting the service shuts it down temporarily, and then starts it back up, which is just like a simple refresh to get things running normally again.

## How to Delete/Uninstall Windows Services 

Deleting a service may be the only option you have if a malicious program has installed a service that you can't seem to keep disabled.

Though the option can't be found in the services.msc program, it is possible to completely uninstall a service in Windows. This won't only shut the service down but will delete it from the computer, never to be seen again (unless of course it's installed again).

Uninstalling a Windows service can be done in both the Windows Registry and with the Service Control utility (sc.exe), similar to svchost.exe, via an [elevated Command Prompt](https://www.lifewire.com/how-to-open-an-elevated-command-prompt-2618088). You can read more about these two methods at [Stack Overflow](https://stackoverflow.com/questions/76074/how-can-i-delete-a-service-in-windows).

## More Information on Windows Services

Services are different than regular programs in that a regular piece of software will stop working if the user logs out of the computer. A service, however, is running with the Windows OS, sort of in its own environment, which means the user can be logged completely out of their account but still have certain services running in the background.

Though it may come off as a disadvantage to always have services running, it's actually very beneficial, like if you use remote access software. An always-on service installed by a program like TeamViewer enables you to remote into your computer even if you're not logged on locally.

There are other options within each service's properties window on top of what is described above that lets you customize how the service should start up (automatically, manually, delayed, or disabled) and what should automatically happen if the service suddenly fails and stops running.

A service can also be configured to run under the permissions of a particular user. This is beneficial in a scenario where a specific application needs to be used but the logged in user doesn't have proper rights to run it. You'll likely only see this in a scenario where there's a network administrator in control of the computers.

Some services can't be disabled through regular means because they may have been installed with a [driver](https://www.lifewire.com/what-is-a-device-driver-2625796) that prevents you from disabling it. If you think this is the case, you can try finding and disabling the driver in [Device Manager](https://www.lifewire.com/device-manager-2625860) or [booting into Safe Mode](https://www.lifewire.com/how-do-i-start-windows-in-safe-mode-2624480) and attempting to disable the service there (because most drivers don't load up in [Safe Mode](https://www.lifewire.com/safe-mode-2626018)).
