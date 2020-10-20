# Q&A

- [Q&A](#qa)
  - [wsl2](#wsl2)
  - [Kubernetes](#kubernetes)
    - [Kubernetes is stuck on starting](#kubernetes-is-stuck-on-starting)
    - [escap Ip-guard](#escap-ip-guard)

## wsl2

[Connecting to WSL2 server via local network](https://stackoverflow.com/questions/61002681/connecting-to-wsl2-server-via-local-network)

## Kubernetes

### Kubernetes is stuck on starting

[Kubernetes is stuck on starting after enabling it on Docker for Windows 10](https://github.com/docker/for-win/issues/5442)

[AliyunContainerService/k8s-for-docker-desktop](https://github.com/AliyunContainerService/k8s-for-docker-desktop/)

[Docker for Windows stuck at “Kubernetes is Starting” after updating to version 2.1.1.0 Edge (or Stable)](https://stackoverflow.com/questions/57711639/docker-for-windows-stuck-at-kubernetes-is-starting-after-updating-to-version-2)

[Solving Kubectl “Error from server (InternalError): an error on the server (“”) has prevented the request from succeeding”](https://wesley.sh/solving-kubectl-error-from-server-internalerror-an-error-on-the-server-has-prevented-the-request-from-succeeding/)

[Unable to start kubernetes on docker desktop win 10 pro #3799](https://github.com/docker/for-win/issues/3799)

[Error from server (InternalError): an error on the server ("") has prevented the request from succeeding #71647](https://github.com/kubernetes/kubernetes/issues/71647)

### escap Ip-guard

file `hookapi_filterproc_external.reg`

    Windows Registry Editor Version 5.00

    [HKEY_LOCAL_MACHINE\SOFTWARE\TEC\Ocular.3\agent\config]
    "hookapi_filterproc_external"="cmd.exe;code.exe;powershell.exe;java.exe;wsl.exe;idea64.exe;ubuntu2004.exe;git-bash.exe;git.exe;wslhost.exe;com.docker.backend.exe;vpnkit-bridge.exe;vpnkit.exe;com.docker.wsl-distro-proxy.exe;com.docker.proxy.exe;docker.exe;Docker Desktop.exe;conhost.exe"
