# [ExaNIC Bonding Extensions (exasock-bonding)](https://exablaze.com/docs/exanic/user-guide/bonding/)

- [ExaNIC Bonding Extensions (exasock-bonding)](#exanic-bonding-extensions-exasock-bonding)
  - [Exasock Bonding support extensions](#exasock-bonding-support-extensions)
  - [Known pitfalls](#known-pitfalls)

## Exasock Bonding support extensions

The exasock driver has been extended to support bonding, but only in the active-backup mode. Furthermore it's meant to manage only bonds containing Cisco Nexus SmartNIC (formerly ExaNIC) devices, so it will reject attempts to bind it to already-existing bonding interfaces which contain non-SmartNIC devices, or to add a non-SmartNIC device to a bond which is currently under its management. Finally, it isn't supported in combination with the ATE feature.

All configuration of bonding interfaces and other standard bonding configuration such as MII Monitor intervals, ARP Monitor intervals, primary slave configuration etc, are done as normal through /sys on the upstream Linux bonding driver.

A summary of the operation of this extension is that it wraps itself around the Linux bonding driver and enforces constraints which are required (such as SmartNIC device membership and rejecting bond modes other than active-backup), and then it exports information about each bonding interface it has wrapped, using a per-bond /dev file. Userspace software can then read this /dev metadata and use it to determine which link within the bonding interface is the active one.

...
