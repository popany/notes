# Arthas

- [Arthas](#arthas)
  - [Arthas 用户文档](#arthas-用户文档)
  - [Command](#command)
    - [`thread`](#thread)
    - [`watch`](#watch)
      - [观察方法返回值](#观察方法返回值)
      - [观察方法参数](#观察方法参数)

## [Arthas 用户文档](https://arthas.aliyun.com/doc/)

## Command

### `thread`

### `watch`

#### 观察方法返回值

    watch class-pattern method-pattern "{params,returnObj}" -s

#### 观察方法参数

    watch class-pattern method-pattern "{params,returnObj}" -x 2 -b
