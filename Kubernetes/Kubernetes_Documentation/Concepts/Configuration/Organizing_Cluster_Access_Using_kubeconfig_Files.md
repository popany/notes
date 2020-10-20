# [Organizing Cluster Access Using kubeconfig Files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)

- [Organizing Cluster Access Using kubeconfig Files](#organizing-cluster-access-using-kubeconfig-files)
  - [Supporting multiple clusters, users, and authentication mechanisms](#supporting-multiple-clusters-users-and-authentication-mechanisms)
  - [Context](#context)
  - [The KUBECONFIG environment variable](#the-kubeconfig-environment-variable)
  - [Merging kubeconfig files](#merging-kubeconfig-files)
  - [File references](#file-references)

Use kubeconfig files to organize information about **clusters**, **users**, **namespaces**, and **authentication mechanisms**. The kubectl command-line tool uses kubeconfig files to find the information it needs to choose a cluster and communicate with the API server of a cluster.

|||
|-|-|
Note|A file that is used to configure access to clusters is called a kubeconfig file. This is a generic way of referring to configuration files. It does not mean that there is a file named kubeconfig.
|||

By default, `kubectl` looks for a file named `config` in the `$HOME/.kube` directory. You can specify other kubeconfig files by setting the `KUBECONFIG` environment variable or by setting the [`--kubeconfig`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl/) flag.

For step-by-step instructions on creating and specifying kubeconfig files, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters).

## Supporting multiple clusters, users, and authentication mechanisms

Suppose you have several clusters, and your users and components authenticate in a variety of ways. For example:

- A running kubelet might authenticate using certificates.
- A user might authenticate using tokens.
- Administrators might have sets of certificates that they provide to individual users.

With kubeconfig files, you can organize your clusters, users, and namespaces. You can also define contexts to quickly and easily switch between clusters and namespaces.

## Context

A context element in a kubeconfig file is used to group access parameters under a convenient name. Each context has three parameters: **cluster**, **namespace**, and **user**. By default, the `kubectl` command-line tool uses parameters from the current context to communicate with the cluster.

To choose the current context:

    kubectl config use-context

## The KUBECONFIG environment variable 

The `KUBECONFIG` environment variable holds a list of kubeconfig files. For Linux and Mac, the list is colon-delimited. For Windows, the list is semicolon-delimited. The `KUBECONFIG` environment variable is not required. If the `KUBECONFIG` environment variable doesn't exist, `kubectl` uses the default kubeconfig file, `$HOME/.kube/config`.

If the `KUBECONFIG` environment variable does exist, `kubectl` uses an effective configuration that is the result of **merging** the files listed in the `KUBECONFIG` environment variable.

## Merging kubeconfig files

...

## File references

File and path references in a kubeconfig file are relative to the location of the kubeconfig file. File references on the command line are relative to the current working directory. In `$HOME/.kube/config`, relative paths are stored relatively, and absolute paths are stored absolutely.
