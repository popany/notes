# bash

- [bash](#bash)
  - [alias](#alias)
  - [prompt](#prompt)
  - [readelf](#readelf)
  - [objcopy](#objcopy)
  - [telnet](#telnet)

## alias

    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

## prompt

    git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    export PS1="[\u@\h \W]\$(git_branch)\$ "

## readelf

## objcopy

## telnet
