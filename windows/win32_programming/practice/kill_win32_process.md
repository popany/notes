# Kill Win32 Process

- [Kill Win32 Process](#kill-win32-process)
  - [How does Windows kill a process, exactly?](#how-does-windows-kill-a-process-exactly)
  - [Win32 API analog of sending/catching SIGTERM](#win32-api-analog-of-sendingcatching-sigterm)
  - [`WM_CLOSE` message](#wm_close-message)

## [How does Windows kill a process, exactly?](https://serverfault.com/questions/151196/how-does-windows-kill-a-process-exactly)

"End Task" (and taskkill) appears to post a `WM_CLOSE` message to the program's windows. (The same is done when you click the × "Close" button.) If the program does not exit in some time, user gets prompted to end the program forcefully.

"Kill Process" and `taskkill /f` use `TerminateProcess()`.

## [Win32 API analog of sending/catching SIGTERM](https://stackoverflow.com/questions/1216788/win32-api-analog-of-sending-catching-sigterm)

MSDNs **Unix Code Migration Guide** has a chapter about [Win32 code conversion and signal handling](http://msdn.microsoft.com/en-us/library/ms811896.aspx#ucmgch09_topic3).

Although Microsoft has decided to archive this brilliant guide, it is very useful.

Three methods are described:

- Native signals
- Event objects
- Messages

## [`WM_CLOSE` message](https://docs.microsoft.com/en-us/windows/win32/winmsg/wm-close)
