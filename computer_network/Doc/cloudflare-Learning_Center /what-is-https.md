# [什么是 HTTPS？](https://www.cloudflare.com/zh-cn/learning/ssl/what-is-https/)

- [什么是 HTTPS？](#什么是-https)
  - [什么是 HTTPS？](#什么是-https-1)
  - [HTTPS 如何工作？](#https-如何工作)
  - [HTTPS 为什么很重要？如果网站没有 HTTPS，那会如何？](#https-为什么很重要如果网站没有-https那会如何)
  - [HTTPS 与 HTTP 有何不同？](#https-与-http-有何不同)

## 什么是 HTTPS？

超文本传输协议安全（HTTPS）是 [HTTP](https://www.cloudflare.com/zh-cn/learning/ddos/glossary/hypertext-transfer-protocol-http) 的安全版本，是用于在 Web 浏览器和网站之间发送数据的主要协议。HTTPS 是加密的，可以提高数据传输的安全性。当用户传输敏感数据（例如通过登录银行帐户、电子邮件服务或健康保险提供商）时，这一点尤其重要。

## HTTPS 如何工作？

HTTPS 使用加密协议对通信进行加密。该协议称为传输层安全性（TLS），但以前称为安全套接字层（SSL）。该协议通过使用所谓的非对称公钥基础架构来保护通信。这种类型的安全系统使用两个不同的密钥来加密两方之间的通信：

1. 私钥 - 此密钥由网站所有者控制，并且如读者所推测的那样，它是私有的。此密钥位于 Web 服务器上，用于解密通过公钥加密的信息。
2. 公钥 - 所有想要以安全方式与服务器交互的人都可以使用此密钥。用公钥加密的信息只能用私钥解密。

## HTTPS 为什么很重要？如果网站没有 HTTPS，那会如何？

HTTPS 阻止网站以任何在网络上窥探的人都能轻松查看的方式广播信息。通过常规 HTTP 发送信息时，信息会分解为数据包，使用免费软件即可轻松“嗅探”这些数据包。这使得通过不安全的媒介（例如公共 Wi-Fi）进行的通信极易受到拦截。实际上，所有通过 HTTP 进行的通信都是以纯文本形式进行的，因而能够为任何使用正确工具的人轻松访问，而且容易遭受[中间人攻击](https://www.cloudflare.com/zh-cn/learning/security/threats/man-in-the-middle-attack)。

使用 HTTPS 时，流量会经过加密，即使嗅探到数据包或以其他方式截取数据包，它们也会呈现为无意义的字符

## HTTPS 与 HTTP 有何不同？

从技术上来讲，HTTPS 并不是独立于 HTTP 的协议。它只是在 HTTP 协议的基础上使用 [TLS/SSL](https://www.cloudflare.com/zh-cn/learning/ssl/what-is-an-ssl-certificate) 加密。HTTPS 基于TLS/SSL 证书的传输而发生，该证书验证特定提供商就是他们声称的身份。

当用户连接网页时，该网页将通过其 SSL 证书发送，证书包含启动安全会话所需的公钥。然后，两台计算机（客户端和服务器）将经历一个称为 SSL/TLS 握手的过程，即用于建立安全连接的一系列来回通信。要更深入地了解加密和 SSL/TLS 握手，请阅读[了解 TLS 握手](https://www.cloudflare.com/zh-cn/learning/ssl/what-happens-in-a-tls-handshake)。





