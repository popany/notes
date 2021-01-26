# windump

- [windump](#windump)
  - [references](#references)
    - [WinDump: The tcpdump tool for Windows](#windump-the-tcpdump-tool-for-windows)
    - [windump manual](#windump-manual)
    - [Using PowerShell to Find Connected Network Adapters](#using-powershell-to-find-connected-network-adapters)
    - [Check network adapter information](#check-network-adapter-information)
    - [Find IP and MAC addresses in Windows](#find-ip-and-mac-addresses-in-windows)
  - [Practice](#practice)
    - [Dump tcp package from host 172.23.75.51 and port 5555 to file test.pcap](#dump-tcp-package-from-host-172237551-and-port-5555-to-file-testpcap)
      - [Get interface Index to 172.23.75.51](#get-interface-index-to-172237551)

## references

### [WinDump: The tcpdump tool for Windows](https://searchenterprisedesktop.techtarget.com/tip/WinDump-The-tcpdump-tool-for-Windows)

### [windump manual](https://www.winpcap.org/windump/docs/manual.htm)

### [Using PowerShell to Find Connected Network Adapters](https://devblogs.microsoft.com/scripting/using-powershell-to-find-connected-network-adapters/)

### Check network adapter information

    wmic nic get Name, MACAddress, GUID, DeviceID

### Find IP and MAC addresses in Windows

    ipconfig /all

## Practice

### Dump tcp package from host 172.23.75.51 and port 5555 to file test.pcap

#### Get interface Index to 172.23.75.51

    Find-NetRoute -RemoteIPAddress "172.23.75.51" | Select-Object InterfaceIndex -Last 1


    windump -i 6 -w sz_binary_w.pcap src host 10.243.141.127 and src port 9129 and tcp
