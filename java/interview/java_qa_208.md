# [Java最新常见面试题 + 答案汇总](https://blog.csdn.net/fangchao2011/article/details/89203535)

- [Java最新常见面试题 + 答案汇总](#java最新常见面试题--答案汇总)
  - [基础模块（一）](#基础模块一)
    - [1.JDK 和 JRE 有什么区别？](#1jdk-和-jre-有什么区别)
    - [2. `==` 和 `equals` 的区别是什么？](#2--和-equals-的区别是什么)
    - [3. 两个对象的 `hashCode()` 相同，则 `equals()` 也一定为 `true`，对吗？](#3-两个对象的-hashcode-相同则-equals-也一定为-true对吗)
    - [4. `final` 在 java 中有什么作用？](#4-final-在-java-中有什么作用)
    - [5. java 中的 `Math.round(-1.5)` 等于多少？](#5-java-中的-mathround-15-等于多少)
    - [6. `String` 属于基础的数据类型吗？](#6-string-属于基础的数据类型吗)
    - [7. java 中操作字符串都有哪些类？它们之间有什么区别？](#7-java-中操作字符串都有哪些类它们之间有什么区别)
    - [8. `String str="i"` 与 `String str=new String(“i”)` 一样吗？](#8-string-stri-与-string-strnew-stringi-一样吗)
    - [9. 如何将字符串反转？](#9-如何将字符串反转)
    - [10. `String` 类的常用方法都有那些？](#10-string-类的常用方法都有那些)
    - [11. 抽象类必须要有抽象方法吗？](#11-抽象类必须要有抽象方法吗)
    - [12. 普通类和抽象类有哪些区别？](#12-普通类和抽象类有哪些区别)
    - [13. 抽象类能使用 `final` 修饰吗？](#13-抽象类能使用-final-修饰吗)
    - [14. 接口和抽象类有什么区别？](#14-接口和抽象类有什么区别)
    - [15. java 中 IO 流分为几种？](#15-java-中-io-流分为几种)
    - [16. BIO、NIO、AIO 有什么区别？](#16-bionioaio-有什么区别)
    - [17. Files 的常用方法都有哪些？](#17-files-的常用方法都有哪些)
  - [容器（二）](#容器二)
  - [多线程（三）](#多线程三)
  - [反射（四）](#反射四)
  - [对象拷贝（五）](#对象拷贝五)
  - [JavaWeb（六）](#javaweb六)
  - [异常（七）](#异常七)
  - [网络（八）](#网络八)
  - [设计模式（九）](#设计模式九)
  - [Spring/SpringMVC（十）](#springspringmvc十)
  - [Spring Boot / Spring Cloud（十一）](#spring-boot--spring-cloud十一)
  - [Hibernate（十二）](#hibernate十二)
  - [Mybatis（十三）](#mybatis十三)
  - [RabbitMQ（十四）](#rabbitmq十四)
  - [Kafka（十五）](#kafka十五)
  - [Zookeeper（十六）](#zookeeper十六)
  - [MySql（十七）](#mysql十七)
  - [Redis（十八）](#redis十八)
  - [JVM（十九）](#jvm十九)

## [基础模块（一）](https://blog.csdn.net/fangchao2011/article/details/89184058)

### 1.JDK 和 JRE 有什么区别？

- JDK：Java Development Kit 的简称，java 开发工具包，提供了 java 的开发环境和运行环境。
- JRE：Java Runtime Environment 的简称，java 运行环境，为 java 的运行提供了所需环境。

具体来说 JDK 其实包含了 JRE，同时还包含了编译 java 源码的编译器 javac，还包含了很多 java 程序调试和分析的工具。简单来说：如果你需要运行 java 程序，只需安装 JRE 就可以了，如果你需要编写 java 程序，需要安装 JDK

### 2. `==` 和 `equals` 的区别是什么？

- == 解读

  对于基本类型和引用类型 `==` 的作用效果是不同的，如下所示：

  - 基本类型: 比较的是值是否相同
  - 引用类型: 比较的是引用是否相同

- equals 解读

  `String` 和 `Integer` 等重写了 `equals` 方法，把它变成了值比较

### 3. 两个对象的 `hashCode()` 相同，则 `equals()` 也一定为 `true`，对吗？

不对，两个对象的 `hashCode()` 相同，`equals()` 不一定 `true`

`hashCode()` 相等即两个键值对的哈希值相等，然而哈希值相等，并不一定能得出键值对相等

### 4. `final` 在 java 中有什么作用？

- `final` 修饰的类叫最终类，该类不能被继承
- `final` 修饰的方法不能被重写
- `final` 修饰的变量叫常量，常量必须初始化，初始化之后值就不能被修改

### 5. java 中的 `Math.round(-1.5)` 等于多少？

等于 -1

### 6. `String` 属于基础的数据类型吗？

`String` 不属于基础类型，基础类型有 8 种：`byte`、`boolean`、`char`、`short`、`int`、`float`、`long`、`double`，而 `String` 属于对象

### 7. java 中操作字符串都有哪些类？它们之间有什么区别？

操作字符串的类有：`String`、`StringBuffer`、`StringBuilder`。

`String` 和 `StringBuffer`、`StringBuilder` 的区别在于 `String` 声明的是不可变的对象，每次操作都会生成新的 `String` 对象，然后将指针指向新的 `String` 对象，而 `StringBuffer`、`StringBuilder` 可以在原有对象的基础上进行操作，所以在经常改变字符串内容的情况下最好不要使用 `String`。

`StringBuffer` 和 `StringBuilder` 最大的区别在于，`StringBuffer` 是线程安全的，而 `StringBuilder` 是非线程安全的，但 `StringBuilder` 的性能却高于 `StringBuffer`，所以在单线程环境下推荐使用 `StringBuilder`，多线程环境下推荐使用 `StringBuffer`。

### 8. `String str="i"` 与 `String str=new String(“i”)` 一样吗？

不一样，因为内存的分配方式不一样。`String str="i"` 的方式，java 虚拟机会将其分配到常量池中；而 `String str=new String("i")` 则会被分到堆内存中。

### 9. 如何将字符串反转？

使用 `StringBuilder` 或者 `stringBuffer` 的 `reverse()` 方法

### 10. `String` 类的常用方法都有那些？

- `indexOf()`: 返回指定字符的索引
- `charAt()`: 返回指定索引处的字符
- `replace()`: 字符串替换
- `trim()`: 去除字符串两端空白
- `split()`: 分割字符串，返回一个分割后的字符串数组
- `getBytes()`: 返回字符串的 `byte` 类型数组
- `length()`: 返回字符串长度
- `toLowerCase()`: 将字符串转成小写字母
- `toUpperCase()`: 将字符串转成大写字符
- `substring()`: 截取字符串
- `equals()`: 字符串比较

### 11. 抽象类必须要有抽象方法吗？

不需要，抽象类不一定非要有抽象方法。

### 12. 普通类和抽象类有哪些区别？

- 普通类不能包含抽象方法，抽象类可以包含抽象方法
- 抽象类不能直接实例化，普通类可以直接实例化

### 13. 抽象类能使用 `final` 修饰吗？

不能，定义抽象类就是让其他类继承的，如果定义为 final 该类就不能被继承，这样彼此就会产生矛盾，所以 final 不能修饰抽象类

### 14. 接口和抽象类有什么区别？

- 实现: 抽象类的子类使用 `extends` 来继承；接口必须使用 `implements` 来实现接口
- 构造函数: 抽象类可以有构造函数；接口不能有
- `main` 方法: 抽象类可以有 `main` 方法，并且我们能运行它；接口不能有 `main` 方法。
- 实现数量: 类可以实现很多个接口；但是只能继承一个抽象类
- 访问修饰符: 接口中的方法默认使用 `public` 修饰；抽象类中的方法可以是任意访问修饰符

### 15. java 中 IO 流分为几种？

- 按功能来分：输入流（input）、输出流（output）

- 按类型来分：字节流和字符流

  字节流和字符流的区别是:
  
  - 字节流按 8 位传输以字节为单位输入输出数据
  - 字符流按 16 位传输以字符为单位输入输出数据

### 16. BIO、NIO、AIO 有什么区别？

- BIO：Block IO 同步阻塞式 IO，就是我们平常使用的传统 IO，它的特点是模式简单使用方便，并发处理能力低
- NIO：New IO 同步非阻塞 IO，是传统 IO 的升级，客户端和服务器端通过 Channel（通道）通讯，实现了多路复用
- AIO：Asynchronous IO 是 NIO 的升级，也叫 NIO2，实现了异步非堵塞 IO ，异步 IO 的操作基于事件和回调机制

### 17. Files 的常用方法都有哪些？

- `Files.exists()`: 检测文件路径是否存在
- `Files.createFile()`: 创建文件
- `Files.createDirectory()`: 创建文件夹
- `Files.delete()`: 删除一个文件或目录
- `Files.copy()`: 复制文件
- `Files.move()`: 移动文件
- `Files.size()`: 查看文件个数
- `Files.read()`: 读取文件
- `Files.write()`: 写入文件

## [容器（二）](https://blog.csdn.net/fangchao2011/article/details/89184615)



## [多线程（三）](https://blog.csdn.net/fangchao2011/article/details/89184943)



## [反射（四）](https://blog.csdn.net/fangchao2011/article/details/89185089)



## [对象拷贝（五）](https://blog.csdn.net/fangchao2011/article/details/89186117)



## [JavaWeb（六）](https://blog.csdn.net/fangchao2011/article/details/89185249)


## [异常（七）](https://blog.csdn.net/fangchao2011/article/details/89185762)



## [网络（八）](https://blog.csdn.net/fangchao2011/article/details/89185955)



## [设计模式（九）](https://blog.csdn.net/fangchao2011/article/details/89185365)


## [Spring/SpringMVC（十）](https://blog.csdn.net/fangchao2011/article/details/89186453)



## [Spring Boot / Spring Cloud（十一）](https://blog.csdn.net/fangchao2011/article/details/89186765)



## [Hibernate（十二）](https://blog.csdn.net/fangchao2011/article/details/89186882)



## [Mybatis（十三）](https://blog.csdn.net/fangchao2011/article/details/89187435)



## [RabbitMQ（十四）](https://blog.csdn.net/fangchao2011/article/details/89187503)



## [Kafka（十五）](https://blog.csdn.net/fangchao2011/article/details/89187544)



## [Zookeeper（十六）](https://blog.csdn.net/fangchao2011/article/details/89187599)




## [MySql（十七）](https://blog.csdn.net/fangchao2011/article/details/89187694)



## [Redis（十八）](https://blog.csdn.net/fangchao2011/article/details/89360306)


## [JVM（十九）](https://blog.csdn.net/fangchao2011/article/details/89360337)












