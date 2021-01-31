# [什么是传输层安全性（TLS）？](https://www.cloudflare.com/zh-cn/learning/ssl/transport-layer-security-tls/)

- [什么是传输层安全性（TLS）？](#什么是传输层安全性tls)
  - [什么是传输层安全性（TLS）？](#什么是传输层安全性tls-1)
  - [TLS 和 SSL 之间有什么区别？](#tls-和-ssl-之间有什么区别)
  - [TLS 和 HTTPS 有什么区别？](#tls-和-https-有什么区别)
  - [为什么应该使用 TLS？](#为什么应该使用-tls)
  - [TLS 如何工作？](#tls-如何工作)
  - [TLS 如何影响 Web 应用程序性能？](#tls-如何影响-web-应用程序性能)

## 什么是传输层安全性（TLS）？

传输层安全性（Transport Layer Security，TLS）是一种广泛采用的安全性协议，旨在促进 Internet 上通信的隐私和数据安全性。TLS 的主要用例是对 Web 应用程序和服务器之间的通信（例如，（例如，Web 浏览器加载网站）进行加密。TLS 还可以用于加密其他通信，如电子邮件、消息传递和 IP 语音（VOIP）等。在本文中，我们将重点介绍 TLS 在 [Web 应用程序安全](https://www.cloudflare.com/zh-cn/learning/security/what-is-web-application-security)中发挥的作用。

TLS 由互联网工程任务组（Internet Engineering Task Force, IETF）提出，该协议的第一个版本于 1999 年发布。最新版本是 TLS 1.3，发布于 2018 年。

## TLS 和 SSL 之间有什么区别？

Netscape 开发了名为安全套接字层（Secure Socket Layer，[SSL](https://www.cloudflare.com/zh-cn/learning/ssl/what-is-ssl)）的上一代加密协议，TLS 由此演变而来。TLS 1.0 版的开发实际上始于 SSL 3.1 版，但协议的名称在发布之前进行了更名，以表明它不再与 Netscape 关联。由于这个历史原因，TLS 和 SSL 这两个术语有时会互换使用。

## TLS 和 HTTPS 有什么区别？

[HTTPS](https://www.cloudflare.com/zh-cn/learning/ssl/what-is-https) 是在 [HTTP](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/hypertext-transfer-protocol-http) 协议基础上 TLS 加密的实现，所有网站以及某些其他 Web 服务都使用该协议。因此，任何使用 HTTPS 的网站都使用 TLS 加密。

## 为什么应该使用 TLS？

TLS 加密可以帮助保护 Web 应用程序免受攻击，如[数据泄露](https://www.cloudflare.com/zh-cn/learning/security/what-is-a-data-breach)和 [DDoS 攻击](https://www.cloudflare.com/zh-cn/learning/ddos/what-is-a-ddos-attack)等。此外，受 TLS 保护的 HTTPS 迅速成为网站的标准实践。例如，Google Chrome 浏览器正在打击非 HTTPS 网站，而且日常的 Internet 用户也开始更加警惕那些没有 HTTPS 挂锁图标的网站。

## TLS 如何工作？

TLS 可以在 [TCP](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/tcp-ip) 等传输层安全协议之上使用。TLS 包含三个主要组件：加密、身份验证和完整性。

- 加密：隐藏从第三方传输的数据。
- 身份验证：确保交换信息的各方是他们声称的身份。
- 完整性：验证数据是否并非伪造而来或未遭篡改过。

使用称为 TLS 握手的序列来启动 TLS 连接。TLS 握手为每个通信**会话**建立一个密码套件。密码套件是一组用于指定详细信息的算法，例如哪些共享加密密钥或会话密钥将用于某个特定会话。借助称为公钥加密的技术，TLS 能够通过未加密通道设置匹配的会话密钥。

握手还处理身份验证，通常包括服务器向客户端证明其身份。这是使用公钥完成的。公钥是使用单向加密的加密密钥，这意味着任何人都可以复原用私钥加密的数据以确保其真实性，但只有原始发送方才能使用私钥加密数据。

数据完成加密和验明身份后，使用消息身份验证码（MAC）进行签名。接收方然后可以验证 MAC 来确保数据的完整性。这有点像阿司匹林药瓶上的防篡改铝箔；消费者知道没人篡改过他们的药品，因为购买时铝箔完好无损。

## TLS 如何影响 Web 应用程序性能？

由于建立 TLS 连接涉及复杂的过程，因此必须消耗一些加载时间和计算资源。在传输任何数据之前，客户端和服务器必须来回通信几次，这将占用 Web 应用程序宝贵的几毫秒加载时间，以及客户端和服务器的一些内存。

幸运的是，已有技术可以帮助缓解 TLS 握手带来的延迟。一种是TLS 错误启动，它允许服务器和客户端在 TLS 握手完成之前开始传输数据。另一种加快 TLS 速度的技术是 TLS 会话恢复，它允许以前通信过的客户端和服务器使用简略的握手。

这些改进有助于使 TLS 成为一种非常快速的协议，不会明显影响加载时间。至于与 TLS 相关的计算成本，以当今的标准来看几乎可以忽略不计。例如，Google 在 2010 年将整个 Gmail 平台移至 HTTPS 时，不曾有启用任何其他硬件的需求。TLS 加密给其服务器造成的额外负载不足 1％。
