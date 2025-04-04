# Linux多线程服务端编程

- [Linux多线程服务端编程](#linux多线程服务端编程)
  - [第 1 章 线程安全的对象生命周期管理](#第-1-章-线程安全的对象生命周期管理)
    - [1.4 线程安全的 Observer 有多难](#14-线程安全的-observer-有多难)
    - [1.6 神器 shared_ptr/weak_ptr](#16-神器-shared_ptrweak_ptr)
    - [1.7 插曲: 系统地避免各种指针错误](#17-插曲-系统地避免各种指针错误)
    - [1.9 再论 shared_ptr 的线程安全](#19-再论-shared_ptr-的线程安全)
    - [1.10 shared_ptr 技术与陷阱](#110-shared_ptr-技术与陷阱)
      - [意外延长对象的生命期](#意外延长对象的生命期)
      - [函数参数](#函数参数)
      - [析构动作再创建时捕获](#析构动作再创建时捕获)
      - [析构所在的线程](#析构所在的线程)
      - [现成的 RAII handle](#现成的-raii-handle)
    - [1.11 对象池](#111-对象池)
      - [1.11.1 `enable_shared_from_this`](#1111-enable_shared_from_this)
      - [1.11.2 弱回调](#1112-弱回调)
  - [第 2 章 线程同步精要](#第-2-章-线程同步精要)
    - [2.6 借 `shared_ptr` 实现 copy-on-write](#26-借-shared_ptr-实现-copy-on-write)
  - [第 6 章 muduo 网络库简介](#第-6-章-muduo-网络库简介)
    - [6.3 目录结构](#63-目录结构)
      - [6.3.1 代码结构](#631-代码结构)
        - [公开接口](#公开接口)
        - [内部实现](#内部实现)
    - [6.4 使用教程](#64-使用教程)
      - [6.4.1 TCP 网络编程本质论](#641-tcp-网络编程本质论)
  - [第 7 章 muduo 编程实例](#第-7-章-muduo-编程实例)
    - [7.1 五个简单 TCP 示例](#71-五个简单-tcp-示例)
    - [7.2 文件传输](#72-文件传输)
    - [7.4 muduo `Buffer` 类的设计与使用](#74-muduo-buffer-类的设计与使用)
      - [7.4.2 为什么 non-blocking 网络编程中应用层 buffer 是必需的](#742-为什么-non-blocking-网络编程中应用层-buffer-是必需的)
    - [7.5 一种自动反射消息类型的 Protobuf 网络传输方案](#75-一种自动反射消息类型的-protobuf-网络传输方案)
      - [7.5.1 网络编程中使用 Protobuf 的两个先决条件](#751-网络编程中使用-protobuf-的两个先决条件)
      - [7.5.2 根据 type name 反射自动创建 `Message` 对象](#752-根据-type-name-反射自动创建-message-对象)
        - [原理简述](#原理简述)
        - [验证思路](#验证思路)
        - [根据 type name 自动创建 `Message` 的关键代码](#根据-type-name-自动创建-message-的关键代码)
        - [线程安全性](#线程安全性)
    - [7.10 用 timing wheel 踢掉空闲连接](#710-用-timing-wheel-踢掉空闲连接)
      - [7.10.1 timing wheel 原理](#7101-timing-wheel-原理)
  - [第 12 章 C++ 经验谈](#第-12-章-c-经验谈)
    - [12.2 不要重载全局 `::operator new()`](#122-不要重载全局-operator-new)

## 第 1 章 线程安全的对象生命周期管理

### 1.4 线程安全的 Observer 有多难

在面向对象程序设计中, 对象的关系主要有三种: composition, aggregation, association.

- composition (组合/复合)
  
  在多线程里不会遇到什么麻烦, 因为对象 `x` 的生命期由其唯一的拥有者 owner 控制, owner 析构的时候会把 `x` 也析构掉. 从形式上看, `x` 是 owner 的直接数据成员, 或者 `scoped_ptr` 成员, 抑或 owner 持有的容器元素.

- association (关联/联系)

  是一种很宽泛的关系, 它表示一个对象 `a` 用到了另一个对象 `b`, 调用了后者的成员函数. 从代码形式上看, `a` 持有 `b` 的指针(或引用), 但是 `b` 的生命期不由 `a` 单独控制.

- aggregation (聚合) 关系从形式上看与 association 相同, 除了 `a` 与 `b` 由逻辑上的整体与部分关系. 如果 `b` 是动态创建的并在整个程序结束前有可能被释放, 那么就会出现 1.1 谈到的竟态条件.

### 1.6 神器 shared_ptr/weak_ptr

- `shared_ptr` 控制对象的生命期. `shared_ptr` 是强引用(想象成用铁丝绑住堆上的对象), 只要有一个指向 `x` 对象的 `shared_ptr` 存在, 该 `x` 对象就不会析构. 当指向对象 `x` 的最后一个 `shared_ptr` 析构或 `reset()` 的时候, `x` 保证会被销毁.

- `weak_ptr` 不控制对象的生命期, 但是它知道对象是否还活着(想象成用棉线轻轻拴住堆上的对象). 如果对象还活着, 那么它可以提升(promote)为有效的 `shared_ptr`; 如果对象已经死了, 提升会失败, 返回一个空的 `shared_ptr`. "提升/`lock()`"行为是线程安全的.

- `shared_ptr`/`weak_ptr` 的"计数"在主流平台上是原子操作, 没有锁, 性能不俗.

- `shared_ptr`/`weak_ptr` 的线程安全级别与 `std::string` 和 STL 容器一样.

### 1.7 插曲: 系统地避免各种指针错误

还要注意, 如果这几种只能指针是对象 `x` 的数据成员, 而它的模板参数 `T` 是个 incomplete 类型, 那么 `x` 的析构函数不能是默认的或内联的, 必须在 .cpp 文件里边显式定义, 否则会有编译错或运行错(原因见 10.3.2).

### 1.9 再论 shared_ptr 的线程安全

要在多个线程中同时访问同一个 `shared_ptr`, 正确的做法是用 `mutex` 保护:

    MutexLock mutex;  // No need for ReaderWriterLock
    shared_ptr<Foo> globalPtr;

    // 我们的任务是把 globalPtr 安全地传给 doit()
    void doit(const shared_ptr<Foo>& pFoo);
    
    // 为了拷贝 globalPtr, 需要在读取它地时候加锁
    void read()
    {
        shared_ptr<Foo> localPtr;
        {
            MutexLocalGuard lock(mutex);
            localPtr = globalPtr;  // read globalPtr
        }
        // use localPtr since here, 读写 localPtr 也无需加锁
        doit(localPtr);
    }

    // 写入的时候也要加锁
    void write()
    {
        shared_ptr<Foo> newPtr(new Foo);  // 注意, 对象的创建在临界区之外
        {
            MutexLockGuard lock(mutex);
            globalPtr = newPtr;  // write to globalPtr
        }
        // use newPtr since here, 读写 newPtr 无须加锁
        doit(newPtr);
    }

注意到上面的 `read()` 和 `write()` 在临界区之外都没有再访问 `globalPtr`, 而是用了一个指向同一 `Foo` 对象的栈上 `shared_ptr` local copy. 下面会谈到, 只要有这样的 local copy 存在, `shared_ptr` 作为函数参数传递时不必复制, 用 reference to const 作为参数类型即可.

### 1.10 shared_ptr 技术与陷阱

#### 意外延长对象的生命期

#### 函数参数

#### 析构动作再创建时捕获

- 虚析构不再是必需的

- `shared_ptr<void>` 可以持有任何对象, 而且能安全地释放

- `shared_ptr` 对象可以安全地跨越模块边界, 比如 DLL 里返回, 而不会造成从模块 A 分配的内存在模块 B 里被释放这种错误.

- 二进制兼容性, 即便 `Foo` 对象的大小变了, 那么旧的客户代码仍然可以使用新的动态库, 而无需重新编译. 前提是 `Foo` 的头文件中不出现访问对象的成员的 `inline` 函数, 并且 `Foo` 对象由动态库中的 Factory 构造, 返回其 `shared_ptr`.

- 析构动作可以定制.

#### 析构所在的线程

#### 现成的 RAII handle

`shared_ptr` 是管理共享资源的利器, 需要注意避免循环引用, 通常的做法是 owner 持有指向 child 的 `shared_ptr`, child 持有指向 owner 的 `weak_ptr`.

### 1.11 对象池

#### 1.11.1 `enable_shared_from_this`

这是一个以其派生类为模板类型实参的基类模板, 继承它, `this` 指针就能变身为 `shared_ptr`.

注意一点, `shared_from_this()` 不能在构造函数里调用, 因为在构造 `StockFactory` 的时候, 它还没有被交给 `shared_ptr` 接管.

#### 1.11.2 弱回调

有时候我们需要"如果对象还活着, 就调用它的成员函数, 否则忽略之" 的语意, 就像 `Observable::notifyObservers()` 那样, 我称之为"弱回调". 这也是可以实现的, 利用 `weak_ptr`, 我们可以把 `weak_ptr` 绑到 `boost::function` 里, 这样对象的生命期就不会被延长. 然后在回调的时候先尝试提升为 `shared_ptr`, 如果提升成功, 说明接受回调的对象还健在, 那么久执行回调; 如果提升失败, 就不必劳神了.

## 第 2 章 线程同步精要

### 2.6 借 `shared_ptr` 实现 copy-on-write

    typedef std::vector<Foo> FooList;
    typedef boost::shared_ptr<FooList> FooListPtr;
    MutexLock mutex;
    FooListPtr g_foos;

    void traverse()
    {
        FooListPtr foos;
        {
            MutexLockGuard lock(mutex);
            foos = g_foos;
        }

        for (std::vector<Foo>::const_iterator it = foos->begin(); it != foos->end(); ++it) {
            it->doit();
        }
    }

    void post(const Foo& f)
    {
        MutexLockGuard lock(mutex);
        if (!g_foos.unique()) {
            g_foos.reset(new FooList(*g_foos));
        }
        f_foos->push_back(f);
    }

## 第 6 章 muduo 网络库简介

### 6.3 目录结构

#### 6.3.1 代码结构

##### 公开接口

- `Buffer` 仿 Netty `ChannelBuffer` 的 buffer class, 数据的读写通过 buffer 进行. 用户代码不需要调用 `read(2)`/`write(2)`, 只需要处理收到的数据和准备好要发送的数据.

- `InetAddress` 封装 IPv4 地址(end point), 注意, 它不能解析域名, 只认 IP 地址. 因为直接用 `gethostbyname(3)` 解析域名汇阻塞 IO 线程.

- `EventLoop` 事件循环(反应器 Reactor), 每个线程只能有一个 EventLoop 实体, 它负责 IO 和定时器事件的分派. 它用 `eventfd(2)` 来异步唤醒, 这有别与传统的用一堆 pipe(2) 的办法. 它用 TimerQueue 作为计时器管理, 用 Poller 作为 IO multiplexing.

- `EventLoopThread` 启动一个线程, 在其中允许 EventLoop::loop()

- `TcpConnection` 整个网络库的核心, 封装一次 TCP 连接, 注意它不能发起连接.

- `TcpClient` 用于编写网络客户端, 能发起连接, 并且有重试功能.

- `TcpServer` 用于编写网络服务器, 接受客户的连接.

这些类中, `TcpConnection` 的生命期依靠 `shared_ptr` 管理(即用户和库共同控制). `Buffer` 的生命期由 `TcpConnection` 控制. 其余类的生命期由用户控制. `Buffer` 和 `InetAddress` 具有值语义, 可以拷贝; 其他 class 都是对象语义, 不可以拷贝.

##### 内部实现

- `Channel` 是 selectable IO channel, 负责注册与响应 IO 事件, 注意它不拥有 file descriptor. 它是 `Acceptor`/`Connector`/`EventLoop`/`TimerQueue`/`TcpConnection` 的成员, 生命周期由后者控制.

- `Socket` 是一个 RAII handle, 封装一个 file descriptor, 并在析构时关闭 fd. 它是 Acceptor/TcpConnection 的成员, 生命期由后者控制. `EventLoop`/`TimerQueue` 也拥有 fd, 但是不封装为 `Socket` class.

- `SocketsOps` 封装各种 Sockets 系统调用.

- `Poller` 是 `PollPoller` 和 `EpollPoller` 的基类, 采用"电平触发"的语义. 它是 `EventLoop` 的成员, 生命期由后者控制.

- `PollPoller` 和 `EpollPoller` 封装 `poll(2)` 和 `epoll(4)` 两种 IO multiplexing 后端. `poll` 存在的价值是便于调试, 因为 `poll(2)` 调用是上下文无关的, 用 `strace(1)` 很容易知道库的行为是否正确.

- `Connector` 用于发起 TCP 连接, 它是 `TcpClient` 的成员, 生命期由后者控制.

- `Acceptor` 用于接收 TCP 连接, 它是 `TcpServer` 的成员, 生命期由后者控制.

- `TimerQueue` 用 `timerfd` 实现定时, 这有别于传统的设置 `poll`/`epoll_wait` 的等待时长的办法. `TimerQueue` 用 `std::map` 来管理 `Timer`, 常用操作的复杂度是 $O(log N)$, $N$ 为定时器数目. 它是 `EventLoop` 的成员, 生命期由后者控制.

- `EventLoopThreadPool` 用于创建 IO 线程池, 用于把 `TcpConnection` 分派到某个 `EventLoop` 线程上. 它是 `TcpServer` 的成员, 生命期由后者控制.

### 6.4 使用教程

#### 6.4.1 TCP 网络编程本质论

TCP 网络编程最本质的是处理三个半事件:

- 1 连接的建立, 包括服务端接受(accept)新连接和客户端成功发起(connect)连接. TCP 连接一旦建立, 客户端和服务端是平等的, 可以各自首发数据.

- 2 连接的断开, 包括主动断开(`close`, `shutdown`)和被动断开(`read(2)` 返回 0).

- 3 消息到达, 文件描述符可读. 这是最重要的一个事件, 对它的处理方式决定了网络编程的风格(阻塞还是非阻塞, 如何处理分包, 应用层的缓冲如何设计, 等等).

- 3.5 消息发送完毕, 这算半个. 对于低流量的服务, 可以不必关心这个事件; 另外, 这里的"发送完毕"是指将数据写入操作系统的缓冲区, 将由 TCP 协议栈负责数据的发送与重传, 不代表对方已经收到数据.

## 第 7 章 muduo 编程实例

### 7.1 五个简单 TCP 示例

注意 `TcpConnection` 对象表示"一次" TCP 连接, 连接断开之后不能重建. TcpClient 重试之后新建的连接会是另一个 `TcpConnection` 对象.

muduo 遵循 one loop per thread 模型, 多个服务端(`TcpServer`)和客户端(`TcpClient`)可以共享同一个 `EventLoop`, 也可以分配到多个 `EventLoop` 上以发挥多线程的好处.

### 7.2 文件传输

`TcpConnection::send()` 是线程安全、原子的. 多个线程可以同时调用 `send()`, 消息之间不会混叠或交织. 但是多个线程同时发送的消息的先后顺序是不确定的, muduo 只能保证每个消息本身的完整性. 另外, `send()` 在多线程下仍然是非阻塞的.

### 7.4 muduo `Buffer` 类的设计与使用

#### 7.4.2 为什么 non-blocking 网络编程中应用层 buffer 是必需的

对于应用程序而言, 它只管生成数据, 它不应该关心到底数据是一次性发送还是分成几次发送, 这些应该由网络库来操心, 程序只要调用 `TcpConnection::send()` 就行了, 网络库会负责到底. 网络库应该接管这剩余的 20kB 数据, 把它保存在该 TCP connection 的 output buffer 里, 然后注册 POLLOUT 事件, 一旦 socket 变得可写就立刻发送数据. 当然, 这第二次 `write()` 也不一定能完全写入 20kB, 如果还有剩余, 网络库应该继续关注 POLLOUT 事件; 如果写完了 20kB, 网络库应该停止关注 POLLOUT, 以免造成 busy loop. (muduo `EventLoop` 采用的是 epoll level trigger, 原因见下页.)

如果程序又写入了 50kB, 而这时候 output buffer 里还有待发送的 20kB 数据, 那么网络库不应该直接调用 `write()`, 而应该把这 50kB 数据 append 在那 20kB 数据之后, 等 socket 变得可写的时候再一并写入.

如果 output buffer 里还有待发送的数据, 而程序又想关闭连接(对程序而言, 调用 `TcpConnection::send()` 之后他就认为数据迟早会发出去), 那么这时候网络库不能立刻关闭连接, 而要等数据发送完毕, 见 p.191 "为什么 `TcpConnection::shutdown()` 没有直接关闭 TCP 连接"中的讲解.

muduo `EventLoop` 采用的是 `epoll(4)` level trigger, 而不是 edge trigger. 一是为了与传统的 `poll(2)` 兼容, 因为在文件描述符数目较少, 活动文件描述符比例较高时, `epoll(4)` 不见得比 `poll(2)` 更高效, 必要时可以在进程启动时切换 Poller. 二是 level trigger 编程更容易, 以往 `select(2)`/`poll(2)` 的经验都可以继续用, 不可能发生漏掉事件的 bug. 三是读写的时候不必等候出现 EAGAIN, 可以节省系统调用次数, 降低延迟.

### 7.5 一种自动反射消息类型的 Protobuf 网络传输方案

#### 7.5.1 网络编程中使用 Protobuf 的两个先决条件

在网络编程中使用 Protobuf 需要解决以下两个问题

1. 长度, Protobuf 打包的数据没有自带长度信息或终结符, 需要由应用程序自己在发送和接收的时候做正确的切分.

2. 类型, Protobuf 打包的数据没有自带类型信息, 需要由发送方吧类型信息传给接收方, 接收方创建具体的 Protobuf Message 对象, 再做反序列化.

#### 7.5.2 根据 type name 反射自动创建 `Message` 对象

Google Protobuf 本身具有很强的反射(reflection)功能, 可以根据 type name 创建具体类型的 `Message` 对象.

##### 原理简述

Protobuf `Message class` 采用了 Prototype pattern, `Message class` 定义了 `New()` 虚函数, 用以返回本对象的一份新实体, 类型与本对象的真是类型相同. 也就是说, 拿到 `Message*` 指针, 不用知道它的具体类型, 就能创建和其类型一样的具体 Message type 的对象.

每个具体 Message type 都有一个 default instance, 可以通过 `ConcreteMessage::default_instance()` 获得, 也可以通过 `MessageFactory::GetPrototype(const Descriptor)` 来获得. 所以现在问题转变为:

1. 如何拿到 `MessageFactory`

2. 如何拿到 `Descriptor*`

我们的英雄是 `DescriptorPool`, 它可以根据 type name 查到 `Descriptor*`, 只要找到合适的 `DescriptorPool` 再调用 `DescriptorPool::FindMessageTypeByName(const string& type_name)`即可.

##### 验证思路

proto 文件

    package muduo
    
    message Query {
      required int64 id = 1;
      required string questioner = 2;
      repeated string question = 3;
    }
    
    message Answer {
      required int64 id = 1;
      required string questioner = 2;
      required string answerer = 3;
      repeated string solution = 4;
    }
    
    message Empty {
      optional int32 id = 1;
    }

以下代码验证 `ConcreteMessage::default_instance()`/`ConcreteMessage::descriptor()`/`MessageFactory::GetPrototype()`/`DescriptorPool::FindMessageTypeByName()`之间的不变式(invariant), 注意其中的 `assert`:

    typedef muduo::Query T;

    std::string type_name = T::descriptor()->full_name();

    const Descriptor* descriptor = DescriptorPool::generated_pool()->FindMessageTypeByName(type_name);
    assert(descriptor == T::descriptor());

    const Message* prototype = MessageFactory::generated_factory()->GetPrototype(descriptor);
    assert(prototype == &T::default_instance());

    T* new_obj = dynamic_cast<T*>(prototype->New());
    assert(new_obj != NULL);
    assert(new_obj != prototype);
    assert(typeid(*new_obj) == typeid(T::default_instance()));

    delete new_obj;

##### 根据 type name 自动创建 `Message` 的关键代码

1. 用 `DescriptorPool::generated_pool()` 找到一个 `DescriptorPool` 对象, 它包括了程序编译的时候所链接的全部 Protobuf Message types.

2. 根据 type name 用 `DescriptorPool::FindMessageTypeByName()` 查找 `Descriptor`.

3. 再用 `MessageFactory::generated_factory()` 找到 `MessageFactory` 对象, 它能创建程序编译的时候所链接的全部 Protobuf Message types.

4. 然后, 用 `MessageFactory::GetPrototype()` 找到具体 `Message` type 的 default instance.

5. 最后, 用 prototype->New() 创建对象.

.

    Message* createMessage(const std::string& typeName)
    {
      Message* message = NULL;
      const Descriptor* descriptor = Descriptor::generated_pool()->FindMessageTypeByName(typeName);
      if (descriptor)
      {
        message = prototype->New();
      }
      return message;
    }

调用方式:

    Message* newQuery = createMessage("muduo.Query");
    assert(newQuery != NULL);
    assert(typeid(*newQuery) == typeid(muduo::Query::default_instance()));

##### 线程安全性

Google 的文档说, 我们用到的那几个 `MessageFactory` 和 DescriptorPool 都是线程安全的, `Message::New()` 也是线程安全的. 并且他们都是 const member function. 关键问题解决了, 那么剩下的工作就是设计一种包含长度和消息类型的 Protobuf 传输格式.

### 7.10 用 timing wheel 踢掉空闲连接

#### 7.10.1 timing wheel 原理

simple timing wheel 的基本结构是一个循环队列, 还有一个指向队尾的指针(tail), 这个指针每秒移动一格, 就像钟表上的时针, timing wheel 由此得名.

## 第 12 章 C++ 经验谈

### 12.2 不要重载全局 `::operator new()`

`::operator new()` 和 `::operator delete()` 是干什么的, 与通常用的 `new`/`delete` 表达式有何区别和联系, 参考侯捷的《池内春秋》



