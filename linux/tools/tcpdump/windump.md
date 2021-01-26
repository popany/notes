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
      - [Get guid of nic that can route to 172.23.75.51](#get-guid-of-nic-that-can-route-to-172237551)
      - [Get interface number corresponds to the guid](#get-interface-number-corresponds-to-the-guid)
      - [Call windump](#call-windump)

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

#### Get guid of nic that can route to 172.23.75.51

    set nic_guid $(wmic nic get MacAddress,GUID | FindStr $(Get-WmiObject win32_networkadapterconfiguration | Where IPAddress -Contains $(Find-NetRoute -RemoteIPAddress "172.23.75.51" | Select IPAddress -First 1 | Select -ExpandProperty IPAddress) | Select MacAddress -First 1 |Select -ExpandProperty MacAddress)|%{($_ -split "\s+")[0].trim("{}")})

#### Get interface number corresponds to the guid

    set interface_number $(windump -D | FindStr $nic_guid | %{($_ -split "\.")[0]})

#### Call windump

    windump -i $interface_number -s 0 -w test.pcap src host 172.23.75.51 and src port 5555 and tcp

- `-s 0`
  
  Setting **snaplen** to 0 means use the required length to catch whole packets
