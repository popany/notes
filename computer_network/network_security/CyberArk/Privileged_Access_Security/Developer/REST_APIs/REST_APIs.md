# [REST APIs](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/Implementing%20Privileged%20Account%20Security%20Web%20Services%20.htm?tocpath=Developer%7CREST%20APIs%7C_____0)

- [REST APIs](#rest-apis)
  - [Overview](#overview)
  - [SDK Supported Platforms](#sdk-supported-platforms)
  - [The PAS SDK](#the-pas-sdk)
  - [API commands](#api-commands)
  - [Return Codes](#return-codes)
  - [Troubleshooting](#troubleshooting)

This section includes CyberArks's REST API commands, how to use them, and samples for typical implementations.

## Overview

Use REST APIs to create, list, modify and delete entities in the PAS solution from within programs and scripts.

You can automate tasks that are usually performed manually using the UI, and to incorporate them into system and account-provisioning scripts.

REST APIs are part of the PVWA installation, and can be used immediately without any additional configuration. Make sure your CyberArk license enables you to use the CyberArk PAS SDK. For more information, contact your CyberArk support representative.

## SDK Supported Platforms

The PAS SDK is a RESTful API that can be invoked by any RESTful client for various programming and scripting environments, including Java, C#, Perl, PHP, Python and Ruby.

## The PAS SDK

The PAS SDK enables you to perform activities on PAS objects via a REST Web Service interface. Each PAS object has its own URL path in the PVWA website that can be accessed using the relevant HTTPS request verb.

Every HTTPS request must contain an HTTPS header field named Authorization that contains the value of a **session token** received from the Logon method.

REST APIs can be accessed with any tool or language that enables you to create HTTPS requests and handle HTTPS responses. For more information, refer to the C# and Java examples in [Usage examples](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/Usage%20Examples.htm).

## API commands

Try out our API commands in swagger (/PasswordVault/swagger).

|||
|-|-|
Note|For every REST API call except for Logon, the request must include an HTTPS header field named Authorization, containing the value of a session token received from the **Logon** activity.
|||

## [Return Codes](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/Implementing%20Privileged%20Account%20Security%20Web%20Services%20.htm?TocPath=Developer%7CREST%20APIs%7C_____0#ReturnCodes)

## [Troubleshooting](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/Latest/en/Content/WebServices/Implementing%20Privileged%20Account%20Security%20Web%20Services%20.htm?TocPath=Developer%7CREST%20APIs%7C_____0#Troubleshooting)
