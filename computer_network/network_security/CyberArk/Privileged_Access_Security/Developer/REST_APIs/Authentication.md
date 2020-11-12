# [Authentication](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/REST%20Web%20Services%20API%20-%20Authentication.htm?tocpath=Developer%7CREST%20APIs%7CAuthentication%7C_____0)

- [Authentication](#authentication)
  - [Logon](#logon)
    - [CyberArk, LDAP, Radius, Windows](#cyberark-ldap-radius-windows)
    - [SAML logon](#saml-logon)
    - [PTA Authentication](#pta-authentication)
    - [Shared logon authentication](#shared-logon-authentication)

This section includes REST APIs for logging on or off from the Vault, using different authentication methods.

## [Logon](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/API-logon-LP.htm?TocPath=Developer%7CREST%20APIs%7CAuthentication%7CLogon%7C_____0)

This section includes REST APIs for logging on to the Vault, using different authentication methods.

### [CyberArk, LDAP, Radius, Windows](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/SDK/CyberArk%20Authentication%20-%20Logon_v10.htm?tocpath=Developer%7CREST%20APIs%7CAuthentication%7CLogon%7C_____1)

This method authenticates a user to the Vault and returns a token that can be used in subsequent web services calls. In addition, this method enables you to set a new password.

### [SAML logon](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/SDK/SAML_%20Authentication_%20Logon_newgen.htm?tocpath=Developer%7CREST%20APIs%7CAuthentication%7CLogon%7C_____2)

This method authenticates a user to the Vault using SAML authentication and returns a token that can be used in subsequent web services calls.

### PTA Authentication

This method enables a user to get a token upon Web application authentication. You can use this method to monitor the PTA system health, as shown in [Get PTA replication status](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/PTA_System_Health.htm).

### Shared logon authentication

This method authenticates to the Vault with a shared webservices user and returns a token that will be used in subsequent web services calls.

For details on shared logon authentication, see [Shared logon authentication](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/SDK/REST%20Web%20Services%20API%20-%20Shared%20Logon%20Authentication.htm).

This is supported for CyberArk authentication only.
