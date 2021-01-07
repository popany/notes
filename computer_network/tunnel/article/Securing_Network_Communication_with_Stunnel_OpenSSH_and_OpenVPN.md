# [Securing Network Communication with Stunnel, OpenSSH, and OpenVPN](https://www.infosecwriters.com/text_resources/pdf/securing_communication.pdf)

- [Securing Network Communication with Stunnel, OpenSSH, and OpenVPN](#securing-network-communication-with-stunnel-openssh-and-openvpn)
  - [Abstract](#abstract)
  - [Introduction](#introduction)
  - [Background](#background)

## Abstract

Networks are increasingly complex, support a wide variety of applications and network services, and handle converged data, voice, and video traffic across both wired and wireless networks using numerous platforms. As a result of HIPAA, Sarbanes-Oxley, and similar regulations, in addition to recent high-profile stories involving the compromise of personal information, maintaining the confidentiality and integrity of data in transit is of paramount importance. This article covers securing network communication, including legacy systems, using such Open Source tools as Stunnel, OpenSSH, and OpenVPN.

## Introduction

Among the more difficult tasks that must be confronted by IT shops is that of securing data in transit. What if you have an old, legacy application that has no support for encrypted communication? What if you don't have the time and/or
money to upgrade that old system to the latest version which does support
encrypted communication? Or what if you simply can't afford the downtime required 
for such an upgrade? Or what if your application has support for encrypted
communication, but as the administrator, you decide that their implementation does
not meet your minimum requirements? These are all issues that are addressed
relatively easily with Stunnel, OpenSSH, and OpenVPN.
Who needs this?
At the risk of overstating, almost everyone. If you are sending data in clear text
across your network, ask yourself this question: What happens if someone, right
now, is sniffing every packet I send across my network? How badly am I exposed? In
my experience, unless extreme security measures have already been taken, you
might be surprised. Or shocked. Or perhaps even horrified.
What if I'm on a switched network?
First, let's clarify switched and shared networks. Older (and cheaper) networking
gear, like hubs, is shared. Let's say we only have three nodes on our tiny network.
On a shared network, traffic that is destined for node A is also sent to nodes B and
C. These nodes, however, are smart enough to know that the traffic isn't addressed
to them, so they silently ignore it. This is a dream come true for our Black Hat. All it
takes is a simple packet sniffer like Ethereal or tcpdump or even Snort, and our Black
Hat can listen to every single packet on our network. By contrast, we have switched
networks. On a switched network, node A receives only traffic that is destined for
itself, as well as broadcast and multicast traffic. Node A, under normal
circumstances, can't see traffic destined for nodes B and C. This is an important step
in securing your network. In general, there is no need for a node to be able to see
network traffic that is destined for someone else. It also has the added benefit of
substantially decreasing the amount of unnecessary network traffic. So if you're on a
switched network, you're safe, right? Sadly, no. Tools like Ettercap make it all too
easy to sniff traffic on a switched network. So while a switched network is a big step
in the right direction, you still need additional weapons in your arsenal to protect
yourself and your network from the would-be Black Hat.
How secure is this?
There are two key issues that have to be considered in order to adequately answer
this question. First there is the matter of the level of encryption supported by the
tools. All three of these tools support strong encryption. In that regard, these tools
are quite secure. The second issue that has to be considered, however, is that of the
code itself. In general, the code for these tools is fast and secure. However, it is the
nature of things that vulnerabilities are discovered, even in otherwise good code.
That being the case, if you intend to use these tools (or any other security tools, for
that matter), it behooves you to stay on top of vulnerability advisories. If a
vulnerability is discovered in the version of one of the tools you are using, patch it.
Don't put it off. Doing so only invites trouble. Always plan for Murphy's Law. It is the
nature of Murphy's Law that it strikes when you least expect it. Though frustrating,
Murphy's Law is important because it keeps you honest. Plus, when something does
go wrong, it presents an opportunity to demonstrate that you have planned for these
contingencies. When it comes to network security, this is always a good trait.

## Background











TODO vpn xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
