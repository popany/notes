# go tutorial

- [go tutorial](#go-tutorial)
  - [Call your code from another module](#call-your-code-from-another-module)
  - [Tutorial: Getting started with multi-module workspaces](#tutorial-getting-started-with-multi-module-workspaces)

## [Call your code from another module](https://go.dev/doc/tutorial/call-module-code)

From the command prompt in the hello directory, run the following command:

    $ go mod edit -replace example.com/greetings=../greetings

The command specifies that `example.com/greetings` should be replaced with `../greetings` for the purpose of locating the dependency. After you run the command, the go.mod file in the hello directory should include a [`replace` directive](https://go.dev/doc/modules/gomod-ref#replace):

    module example.com/hello

    go 1.16

    replace example.com/greetings => ../greetings

## [Tutorial: Getting started with multi-module workspaces](https://go.dev/doc/tutorial/workspaces)

`go.work` can be used instead of adding `replace` directives to work across multiple modules.









