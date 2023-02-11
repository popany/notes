# VSCode

- [VSCode](#vscode)
  - [Remote-SSH](#remote-ssh)
  - [Practice](#practice)
    - [Avoid vscode change `~/.git-credentials` in container](#avoid-vscode-change-git-credentials-in-container)
  - [Extensions](#extensions)
    - [markdown](#markdown)
      - [PlantUML](#plantuml)
      - [Markdown Preview Mermaid Support](#markdown-preview-mermaid-support)
  - [Settings](#settings)
    - [Set Indent for Markdown](#set-indent-for-markdown)
    - [Disable default C++ intelliSenseEngine](#disable-default-c-intellisenseengine)
    - [Close Auto Format](#close-auto-format)
  - [Trubleshooting](#trubleshooting)
    - [ssh remote](#ssh-remote)
      - [ERROR: cannot verify update.code.visualstudio.com's certificate](#error-cannot-verify-updatecodevisualstudiocoms-certificate)

## Remote-SSH

[VSCode:Remote-SSH配置实录](https://blog.csdn.net/sixdaycoder/article/details/89947893)

[[SSH]客户端和服务器配置实录](https://blog.csdn.net/sixdaycoder/article/details/89850064)

## Practice

### Avoid vscode change `~/.git-credentials` in container

    git config --system --unset credential.helper

## Extensions

### markdown

#### [PlantUML](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)

#### [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)

[document](https://mermaid-js.github.io/mermaid/)

## Settings

### Set Indent for Markdown

- `F1`

- "Configure Language Specific Settings"

- Select Markdown

### Disable default C++ intelliSenseEngine

    "C_Cpp.intelliSenseEngine": "disabled",

### Close Auto Format

    "editor.formatOnSave": false

## Trubleshooting

### ssh remote

#### ERROR: cannot verify update.code.visualstudio.com's certificate

Add a line of :

    check-certificate=off

to your .wgetrc file under the user’s home directory (on the target system)

Note: It will disable the SSL certificate check for all wget commands you use, unless you change it to :

    check-certificate=on
