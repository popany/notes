# GO

- [GO](#go)
  - [Hello World](#hello-world)
  - [Managing dependencies](#managing-dependencies)
  - [Golang tutorial series](#golang-tutorial-series)
  - [Goroutines](#goroutines)
  - [opensource](#opensource)

## Hello World

- create go.mod

      go mod init example/hello

- add new modules to go.mod

      go mod tidy

- Exported name

  In Go, a function whose name starts with a capital letter can be called by a function not in the same package. This is known in Go as an exported name. 

- declaring and initializing a variable

      message := fmt.Sprintf("Hi, %v. Welcome!", name)

  or

      var message string
      message = fmt.Sprintf("Hi, %v. Welcome!", name)

- main package

  In Go, code executed as an application must be in a main package

- go test

  Ending a file's name with _test.go tells the go test command that this file contains test functions.

- go install

  Discover the install path:

      $ go list -f '{{.Target}}'

  Change the install target by setting the `GOBIN` variable using the `go env` command:

      $ go env -w GOBIN=/path/to/your/bin

## [Managing dependencies](https://go.dev/doc/modules/managing-dependencies)


## [Golang tutorial series](https://golangbot.com/learn-golang-series/)


## Goroutines

https://golangbot.com/goroutines/

https://gobyexample.com/goroutines

https://www.programiz.com/golang/goroutines

https://www.golinuxcloud.com/goroutines-golang/

https://medium.com/@manus.can/golang-tutorial-goroutines-and-channels-c2cd491f77ab

https://zetcode.com/golang/goroutine/

## opensource

[7 GitHub projects to make you a better Go Developer](https://dev.to/ankit01oss/7-github-projects-to-make-you-a-better-go-developer-2nmh)

