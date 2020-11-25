# [MYBATIS 教程](https://www.qikegu.com/docs/1868)

- [MYBATIS 教程](#mybatis-教程)
  - [MYBATIS教程 – 简介](#mybatis教程--简介)
  - [MYBATIS教程 – 环境搭建](#mybatis教程--环境搭建)
    - [创建数据库](#创建数据库)
    - [MyBatis Eclipse 项目](#mybatis-eclipse-项目)
    - [例子源码](#例子源码)
  - [MYBATIS教程 – 配置](#mybatis教程--配置)
    - [environments 标签](#environments-标签)
    - [transactionManager 标签](#transactionmanager-标签)
    - [dataSource 标签](#datasource-标签)
    - [typeAliases 标签](#typealiases-标签)
    - [mappers 标签](#mappers-标签)
    - [MySQL数据库配置](#mysql数据库配置)
    - [MybatisConfig.xml](#mybatisconfigxml)
  - [MYBATIS教程 – 映射文件](#mybatis教程--映射文件)
    - [映射语句](#映射语句)
      - [Insert](#insert)
      - [Update](#update)
      - [Delete](#delete)
      - [Select](#select)
      - [resultMaps](#resultmaps)
  - [MYBATIS教程 – 插入数据](#mybatis教程--插入数据)
    - [准备数据](#准备数据)
    - [UserMapper.xml映射文件](#usermapperxml映射文件)
    - [App.java](#appjava)
    - [运行](#运行)
  - [MYBATIS教程 – 读取数据](#mybatis教程--读取数据)
    - [准备数据](#准备数据-1)
    - [UserMapper.xml映射文件](#usermapperxml映射文件-1)
    - [App.java](#appjava-1)
    - [运行](#运行-1)
  - [MYBATIS教程 – 修改数据](#mybatis教程--修改数据)
    - [准备数据](#准备数据-2)
    - [UserMapper.xml映射文件](#usermapperxml映射文件-2)
    - [App.java](#appjava-2)
    - [运行](#运行-2)
  - [MYBATIS教程 – 删除数据](#mybatis教程--删除数据)
    - [准备数据](#准备数据-3)
    - [UserMapper.xml映射文件](#usermapperxml映射文件-3)
    - [App.java](#appjava-3)
    - [运行](#运行-3)
  - [MYBATIS教程 – 动态SQL](#mybatis教程--动态sql)
    - [if 语句](#if-语句)
    - [choose, when, otherwise语句](#choose-when-otherwise语句)
    - [where, set 语句](#where-set-语句)
    - [foreach语句](#foreach语句)
    - [动态sql例子](#动态sql例子)
      - [UserMapper.xml](#usermapperxml)
      - [App.Java](#appjava-4)
      - [运行](#运行-4)
  - [MYBATIS教程 – 注解方式](#mybatis教程--注解方式)
    - [准备数据](#准备数据-4)
    - [User 类](#user-类)
    - [UserMapper.java](#usermapperjava)
    - [修改MybatisConfig.xml中的mapper标签](#修改mybatisconfigxml中的mapper标签)
    - [App.java](#appjava-5)
    - [运行](#运行-5)
  - [MYBATIS教程 – 与Hibernate比较](#mybatis教程--与hibernate比较)
    - [MyBatis与Hibernate的区别](#mybatis与hibernate的区别)

## [MYBATIS教程 – 简介](https://www.qikegu.com/docs/1870)

MyBatis 是一款优秀的支持自定义 SQL 查询、存储过程和高级映射的**持久层框架**，消除了几乎所有的 JDBC 代码和参数的手动设置以及结果集的检索。

MyBatis 可以使用 XML 或注解进行配置和映射， MyBatis 通过将参数映射到配置的 SQL 形成最终执行的 SQL 语句，最后将执行 SQL 的结果映射成 Java 对象返回。

MyBatis 核心特性：

- 通过动态SQL与参数绑定，避免复杂的SQL语句拼接
- 结果集自动映射成 Java 对象返回

与其他的 ORM （对象关系映射）框架不同， MyBatis 并没有将 Java 对象与数据库表关联起来，而是**将 Java 方法与 SQL 语句关联**。 MyBatis 允许用户充分利用数据库的各种功能，例如存储过程、视图、各种复杂的查询以及某数据库的专有特性。如果要对遗留数据库、不规范的数 据库进行操作， 或者要完全控制 SQL 的执行， MyBatis 将会是一个不错的选择。

与 JDBC 相比， MyBatis 简化了相关代码， SQL 语句在一行代码中就能执行。 MyBatis 提供了一个**映射引擎**， 声明式地**将 SQL 语句的执行结果与对象树映射起来**。通过使用一种内建的类 XML 表达式语言， **SQL 语句可以被动态生成**。

MyBatis 支持**声明式数据缓存**（declarative data caching）。当一条 SQL 语句被标记为“可缓 存”后，首次执行它时从数据库获取的所有数据会被存储在高速缓存中，后面再执行这条语句 时就会从高速缓存中读取结果，而不是再次命中数据库。 MyBatis 提供了默认情况下基于 Java HashMap 的缓存实现，以及用于与 OSCache、 Ehcache、 Hazeleast 和 Memcached 连接的默认连接器，同时还提供了 API 供其他缓存实现使用。

MyBatis 的前身是 iBATIS， 是 Clinton Begin 在 2001 年发起的一个开源项目，最初侧重于密码软件的开发， 后来发展成为一款基于 Java 的持久层框架。 2004 年， Clinton 将 iBATIS 的名字和源码捐赠给了 Apache 软件基金会，接下来的 6 年中，开源软件世界发生了巨大的变化， 一切开发实践、基础设施、许可，甚至数据库技术都彻底改变了 。 2010年，核心开发团队决定离开 Apache 软件基金会，井且将 iBATIS 改名为 MyBatis。

MyBatis 官方 GitHub 地址为 <https://github.com/mybatis>，在官方 GitHub 中可以看到 MyBatis 的多个子项目 。

## [MYBATIS教程 – 环境搭建](https://www.qikegu.com/docs/2385)

本章介绍MyBatis开发环境的搭建。

### 创建数据库

由于要使用MyBatis访问数据库，我们先在mysql中创建数据库。

    CREATE DATABASE IF NOT EXISTS `qikegu_mybatis` 
    USE `qikegu_mybatis`;

    CREATE TABLE IF NOT EXISTS `user` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='用户表';

    INSERT INTO `user` (`id`, `name`) VALUES
        (1, 'user1'),
        (2, 'user2'),
        (3, 'user3'),
        (4, 'user4'),
        (5, 'user5');

### MyBatis Eclipse 项目

打开Eclipse，创建一个maven项目，由maven导入依赖的库：

- mybatis
- mysql-connector-java

pom.xml文件内容如下：

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>qikegu</groupId>
        <artifactId>mybatis</artifactId>
        <version>0.0.1-SNAPSHOT</version>

        <dependencies>
            <!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>8.0.15</version>
            </dependency>

            <!-- https://mvnrepository.com/artifact/org.mybatis/mybatis -->
            <dependency>
                <groupId>org.mybatis</groupId>
                <artifactId>mybatis</artifactId>
                <version>3.5.1</version>
            </dependency>

        </dependencies>

    </project>

### 例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 配置](https://www.qikegu.com/docs/2387)

本章讨论MyBatis的配置，MyBatis使用xml文件进行配置。配置的内容一般会包括数据库、映射文件路径等。

MyBatis配置文件的典型结构如下：

    <configuration>

        <typeAliases>
            <typeAlias alias = "类名" type = "类的全限定名"/>
        </typeAliases>

        <environments default = "环境默认名称">
            <environment id = "环境ID">
                <transactionManager type = "JDBC/MANAGED"/>  
                <dataSource type = "UNPOOLED/POOLED/JNDI">
                    <property name = "driver" value = "数据库驱动程序名"/>
                    <property name = "url" value = "数据库网址/url"/>
                    <property name = "username" value = "数据库用户名"/>
                    <property name = "password" value = "数据库密码"/>
                    </dataSource>        
            </environment>
        </environments>

        <mappers>
            <mapper resource = "映射文件路径"/>
        </mappers>

    </configuration>

下面让我们逐个讨论重要标签。

除了这些重要标签，还有其他标签可用，可参考MyBatis官方文档。

### environments 标签

environments 标签即环境标签，用于配置数据库，可配置多个环境连接多个数据库。environments 标签有2个子标签：

- transactionManager 标签
- dataSource 标签

### transactionManager 标签

transactionManager 标签即事务管理器标签，支持2类事务管理器：JDBC和MANAGED/托管。

- **JDBC** – 使用JDBC类型的事务管理器，由应用程序负责事务管理操作，如提交、回滚等，利用java.sql.Connection对象完成对事务的管理
- **MANAGED/托管** – 使用托管类型的事务管理器，由Java容器（tomcat, jetty）负责管理连接生命周期，应用程序本身不管理事务

### dataSource 标签

dataSource 标签即数据源标签，用于配置数据库的连接参数：数据库的驱动程序名、url、用户名和密码。

数据源标签有3中类型

- UNPOOLED – 不使用连接池，单个连接用完就关闭，不复用，性能较差，通常用于简单的应用
- POOLED – 使用连接池，数据库连接会被复用以提升性能
- JNDI – MyBatis将从JNDI数据源获取数据库连接

环境标签示例：

    <environments default = "development">
        <environment id = "development">
            <transactionManager type = "JDBC"/>         
            <dataSource type = "POOLED">
                <property name = "driver" value = "com.mysql.jdbc.Driver"/>
                <property name = "url" value = "jdbc:mysql://localhost:3306/qikegu_mybatis"/>
                <property name = "username" value = "root"/>
                <property name = "password" value = "password"/>
            </dataSource>            
        </environment>
    </environments>

### typeAliases 标签

如需在MyBatis映射文件中使用短的类名（如com.qikegu.demo.User的中User），可配置类型别名标签。

    <typeAliases>
        <typeAlias alias = "User" type = "com.qikegu.demo.User"/>
    </typeAliases>

配置好后，可在MyBatis映射文件中直接使用User。

### mappers 标签

MyBaits的映射文件包含了映射的SQL语句，使用MyBatis的主要工作就是在编写这些映射文件。mappers 标签用于配置映射文件的位置。

例如，映射文件名为User.xml，放在mapper目录下，可如下配置：

    <mappers>
        <mapper resource = "mapper/User.xml"/>
    </mappers>

mapper标签除了通过resource属性配置映射文件位置，还可通过其他方式配置：

- resource – 指向XML文件的类路径。
- url – 指向xml文件的完全限定路径。
- class – 可以使用映射接口代替xml文件，指向映射接口的类路径。
- name – 指向映射接口的包名。

本章示例使用resource属性。

### MySQL数据库配置

MySQL数据库的配置参数(驱动程序名、url、用户名和密码)，如下所示：

||||
|-|-|-|
序号|属性|属性值
1|driver|com.mysql.jdbc.Driver
2|url|jdbc:mysql://localhost:3306/qikegu_mybatis (假设数据库名为”qikegu_mybatis” )
3|username|root
4|password|password
||||

使用JDBC类型的事务管理器，所以必须在应用程序中手动执行事务操作，如提交、回滚等。

使用unpool类型的数据源，表示不使用连接池，建议在数据库操作完成后手动关闭连接。

### MybatisConfig.xml

MyBatis配置文件的实际例子：MyBatisConfig.xml。

下面是MyBatisConfig.xml的文件内容：

    <?xml version = "1.0" encoding = "UTF-8"?>

    <!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>

        <environments default = "development">
            <environment id = "development">
                <transactionManager type = "JDBC"/> 

                <dataSource type = "UNPOOLED">
                    <property name = "driver" value = "com.mysql.jdbc.Driver"/>
                    <property name = "url" value = "jdbc:mysql://localhost:3306/qikegu_mybatis"/>
                    <property name = "username" value = "root"/>
                    <property name = "password" value = "password"/>
                </dataSource>   

            </environment>
        </environments>

        <mappers>
            <mapper resource = "mapper/UserMapper.xml"/>
        </mappers>

    </configuration>

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 映射文件](https://www.qikegu.com/docs/2388)

本章讨论MyBatis的映射XML文件及增删改查等sql映射语句。

直接使用JDBC访问数据库，需要在程序中写sql语句，然后执行，如果是查询语句，必须遍历查询结果，把结果读取到对象中。

MyBatis的SQL语句写在映射文件中，不同的是，映射文件中的sql语句有很多强大功能，如动态sql可根据不同条件拼接sql语句，结果集映射功能只需配置好参数，MyBatis会直接把结果集读取到对象中，无需手动读取。MyBatis的映射文件是XML格式，实践中通常一个Java model类对应一个映射文件，如User类的对应映射文件是UserMapper.xml。

在[MYBATIS教程 – 环境搭建](https://www.qikegu.com/docs/2385)中，我们创建好了数据库，数据库中包含了一个用户表。

    CREATE DATABASE IF NOT EXISTS `qikegu_mybatis` 
    USE `qikegu_mybatis`;
    
    CREATE TABLE IF NOT EXISTS `user` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
      `name` varchar(50) NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='用户表';
    
    INSERT INTO `user` (`id`, `name`) VALUES
        (1, 'user1'),
        (2, 'user2'),
        (3, 'user3'),
        (4, 'user4'),
        (5, 'user5');

创建一个对应的Java类：User.java

    public class User {
        private long id;
        private String name;

        public User(String name) {
            super();
            this.name = name;
        }

        public long getId() {
            return id;
        }
        public void setId(long id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
    }

### 映射语句

映射语句是MyBatis映射文件中映射到sql的各种语句，如select、insert、update和delete等语句。

映射语句的特点：

- 所有的语句都有唯一的id。要执行这些语句，只需要将对应id传递给Java方法。(后面内容中会详细讨论)。
- 映射文件避免了Java代码中重复编写SQL语句。与JDBC相比，使用MyBatis中的映射文件减少了95%的代码量。
- 所有映射语句都包含在`<mapper>`标签下，该标签有“namespace”属性。如下所示：

       <mapper namespace = "User">
           // 映射语句与结果映射
       <mapper> 

#### Insert

MyBatis中，要将值插入表，必须配置insert映射语句。insert映射语句有各种参数，通常主要使用id及parameterType。

id是唯一标识符，用于标识insert语句。parameterType表示传递给映射语句的参数类名或别名。

insert映射语句示例：

    <insert id = "insert" parameterType = "User">
        INSERT INTO user (NAME) 
        VALUES (#{name});    
    </insert>

上面的传入的参数类型是User (class)。

在映射文件中配置好insert映射语句后，在Java代码中就可以根据映射语句的id执行该语句。如下所示：

    // 假设 session 是 SqlSession 实例
    session.insert("User.insert", user);

可以思考一下，比较使用MyBatis映射语句与Java代码中直接写sql语句的异同。

#### Update

Update映射语句用于更新数据库记录。

示例：

    <update id = "update" parameterType = "User">
        UPDATE user SET NAME = #{name} WHERE ID = #{id};
    </update>

在Java代码中就可以根据映射语句的id执行该语句。如下所示：

    // 假设 session 是 SqlSession 实例 
    session.update("User.update", user);

#### Delete

Delete映射语句用于删除现有记录。

示例：

    <delete id = "deleteById" parameterType = "long">
        DELETE from User WHERE ID = #{id};
    </delete>

在Java代码中就可以根据映射语句的id执行该语句。如下所示：

    // 假设 session 是 SqlSession 实例   
    session.delete("User.deleteById", 3);

#### Select

Select映射语句用于查询数据。

    <select id = "getAll" resultMap = "result">
        SELECT * FROM User; 
    </select>

在Java代码中就可以根据映射语句的id执行该语句，该方法以列表形式返回结果，如下所示：

    // 假设 session 是 SqlSession 实例  
    List<User> list = session.selectList("User.getAll");

#### resultMaps

resultMaps即结果映射，是MyBatis中最重要、最强大的标签，其作用是把select sql执行结果映射到Java对象。

下面是结果映射的例子，例子中将select查询的结果映射到User类

    <resultMap id = "result" type = "User">
       <result property = "id" column = "id"/>
       <result property = "name" column = "name"/>
    </resultMap>
    
    <select id = "getAll" resultMap = "result">
       SELECT * FROM User; 
    </select>
    
    <select id = "getById" parameterType = "long" resultMap = "result">
       SELECT * FROM User WHERE ID = #{id};
    </select>

如果property与column相同，column可省略。

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 插入数据](https://www.qikegu.com/docs/2389)

本章将详细介绍MyBatis的数据插入操作。

### 准备数据

我们已经在前面章节中创建了数据库，如没有数据，可参考前面章节[MYBATIS教程 – 环境搭建创建](https://www.qikegu.com/docs/2385)。

### UserMapper.xml映射文件

UserMapper.xml映射文件中将包含所有User相关sql映射语句。

UserMapper.xml中添加insert语句：

    <?xml version = "1.0" encoding = "UTF-8"?>

    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

    <mapper namespace = "User">

        <insert id = "insert" parameterType = "User">
            INSERT INTO User (name) VALUES (#{name});

            <selectKey keyProperty = "id" resultType = "long" order = "AFTER">
                select last_insert_id() as id
            </selectKey>   

        </insert>

    </mapper>

参数类型可以是任何类型，如int、float、double或任何类，本例中参数类型User，即在调用SqlSession类的insert方法时，将传入User类的对象。

如需获取插入记录的id，可以使用`<selectKey>`标签。

### App.java

应用程序main类文件。

App.java

    package com.qikegu.demo;

    import java.io.IOException;
    import java.io.Reader;

    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;

    public class App { 

        public static void main(String args[]) throws IOException{

            Reader reader = Resources.getResourceAsReader("MybatisConfig.xml");
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);       
            SqlSession session = sqlSessionFactory.openSession();

            // 创建用户对象
            User user = new User("newUser100"); 

            // 插入新用户到数据库     
            session.insert("User.insert", user);
            System.out.println("数据插入成功");
            session.commit();
            session.close();   
        }

    }

### 运行

运行查询，输出：

数据插入成功

查看数据库，可以看到新用户已经插入到数据库中：

|||
|-|-|
id|name
1|user1
2|user2
3|user3
4|user4
5|user5
6|newUser100
|||

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 读取数据](https://www.qikegu.com/docs/2400)

本章将详细介绍MyBatis的数据读取操作。

### 准备数据

我们已经在前面章节中创建了数据库，如没有数据，可参考前面章节[MYBATIS教程 – 环境搭建创建](https://www.qikegu.com/docs/2385)。

### UserMapper.xml映射文件

UserMapper.xml映射文件中将包含所有User相关sql映射语句。

在映射文件中添加Select语句，Select语句会返回结果，需要把结果映射到Java对象，所以添加了resultMap。Select语句与resultMap都用唯一ID标志，以便在Java代码中可以调用。

我们添加了2个select方法：

- getAll – 获取用户列表
- getById – 获取用户详情

.

    <?xml version = "1.0" encoding = "UTF-8"?>

    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

    <mapper namespace = "User">

        <resultMap id="result" type="User">
            <result property="id" column="id" />
            <result property="name" column="name" />
        </resultMap>

        <select id="getAll" resultMap="result">
            SELECT * FROM User;
        </select>

        <select id="getById" parameterType="long" resultMap="result">
            SELECT * FROM User WHERE ID = #{id};
        </select>

    </mapper>

参数类型可以是任何类型，如int、float、double或任何类，本例中参数类型User，即在调用SqlSession类的方法时，将传入User类的对象。

### App.java

应用程序main类文件。

App.java

    package com.qikegu.demo;

    import java.io.IOException;
    import java.io.Reader;

    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;

    public class App { 

        public static void main(String args[]) throws IOException{

            Reader reader = Resources.getResourceAsReader("MybatisConfig.xml");
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);       
            SqlSession session = sqlSessionFactory.openSession();

            System.out.println("------------ 读取用户列表 -----------");
            //select contact all contacts       
            List<User> userList = session.selectList("User.getAll");

            for(User u : userList ){         
                System.out.println(u.getId());
                System.out.println(u.getName()); 
            }  
            System.out.println("读取用户列表成功");    

            System.out.println("------------ 读取用户详情 -----------");
            //select a particular student  by  id   
            User user1 = (User) session.selectOne("User.getById", 2L); 

            //Print the student details
            System.out.println(user1.getId());
            System.out.println(user1.getName());

            System.out.println("读取用户详情成功");  

            session.commit();
            session.close();   
        }

    }

### 运行

运行输出：

    ------------ 读取用户列表 -----------
    1
    user1
    2
    user2
    3
    user3
    4
    user4
    5
    user5
    6
    newUser100
    8
    newUser100
    读取用户列表成功
    ------------ 读取用户详情 -----------
    2
    user2
    读取用户详情成功

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 修改数据](https://www.qikegu.com/docs/2402)

本章将详细介绍MyBatis的数据修改操作。

### 准备数据

我们已经在前面章节中创建了数据库，如没有数据，可参考前面章节[MYBATIS教程 – 环境搭建创建](https://www.qikegu.com/docs/2385)。

### UserMapper.xml映射文件

UserMapper.xml映射文件中将包含所有User相关sql映射语句。

首先读取一个用户信息，然后修改信息并保存，然后查询修改后的用户信息，确认是否修改成功。

在映射文件中添加Select语句与update语句。如下所示：

    <?xml version = "1.0" encoding = "UTF-8"?>

    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

    <mapper namespace = "User">

        <resultMap id="result" type="User">
            <result property="id" column="id" />
            <result property="name" column="name" />
        </resultMap>

        <select id="getById" parameterType="long" resultMap="result">
            SELECT * FROM User WHERE ID = #{id};
        </select>

        <update id="update" parameterType="User">
            UPDATE User SET name = #{name}
            WHERE ID = #{id};
        </update>

    </mapper>

参数类型可以是任何类型，如int、float、double或任何类，本例中参数类型User，即在调用SqlSession类的方法时，将传入User类的对象。

### App.java

应用程序main类文件。

App.java

    package com.qikegu.demo;

    import java.io.IOException;
    import java.io.Reader;

    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;

    public class App { 

        public static void main(String args[]) throws IOException{

            Reader reader = Resources.getResourceAsReader("MybatisConfig.xml");
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);       
            SqlSession session = sqlSessionFactory.openSession();

            System.out.println("------------ 读取用户详情 -----------");  
            User user1 = (User) session.selectOne("User.getById", 2L); 

            System.out.println(user1.getId());
            System.out.println(user1.getName());

            System.out.println("读取用户详情成功");  

            System.out.println("------------ 修改用户 -----------");
            user1.setName("userNameUpdated");
            session.update("User.update", user1);
            session.commit();

            // 查询修改后的用户详情
            User user2 = (User) session.selectOne("User.getById", 2L); 
            System.out.println(user2.getId());
            System.out.println(user2.getName());
            System.out.println("修改用户成功");

            session.commit();
            session.close();   
        }

    }

### 运行

运行输出：

    ------------ 读取用户详情 -----------
    2
    userNameUpdated
    读取用户详情成功
    ------------ 修改用户 -----------
    2
    userNameUpdated
    修改用户成功

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 删除数据](https://www.qikegu.com/docs/2404)

本章将详细介绍MyBatis的数据删除操作。

### 准备数据

我们已经在前面章节中创建了数据库，如没有数据，可参考前面章节[MYBATIS教程 – 环境搭建创建](https://www.qikegu.com/docs/2385)。

### UserMapper.xml映射文件

UserMapper.xml映射文件中将包含所有User相关sql映射语句。

在映射文件中添加delete语句，将删除指定用户信息。如下所示：

    <?xml version = "1.0" encoding = "UTF-8"?>

    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

    <mapper namespace = "User">

        <resultMap id="result" type="User">
            <result property="id" column="id" />
            <result property="name" column="name" />
        </resultMap>

        <delete id="deleteById" parameterType="long">
            DELETE from User WHERE id = #{id};
        </delete>

    </mapper>

参数类型可以是任何类型，如int、float、double或任何类，本例中参数类型long，在调用SqlSession类的方法时，将传入User对象的id。

### App.java

应用程序main类文件。

App.java

    package com.qikegu.demo;

    import java.io.IOException;
    import java.io.Reader;

    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;

    public class App { 

        public static void main(String args[]) throws IOException{

            Reader reader = Resources.getResourceAsReader("MybatisConfig.xml");
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);       
            SqlSession session = sqlSessionFactory.openSession();

            System.out.println("------------ 删除用户 -----------");
            session.delete("User.deleteById", 2L);
            System.out.println("删除用户成功");

            session.commit();
            session.close();   
        }

    }

### 运行

运行输出：

    ------------ 删除用户 -----------
    删除用户成功

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 动态SQL](https://www.qikegu.com/docs/2409)

动态SQL是MyBatis的一个强大特性。在编写sql语句时，尝尝需要根据不同条件拼接sql语句，动态sql帮助开发者非常轻松地实现各种条件下的sql拼接。

下面是MyBatis提供的基于OGNL的动态SQL表达式。

- if
- choose (when, otherwise)
- trim (where, set)
- foreach

### if 语句

动态SQL中一个常见做法是有条件包含where子句。

示例：

    <select id = "getByName" parameterType = "User" resultType = "User">
        SELECT * FROM User        
        <if test = "name != null">
            WHERE name LIKE #{name}
        </if> 
    </select>

此语句查询用户列表，如果提供了用户名称，则根据用户名(like 匹配)查询用户。

可以包含多个if条件，如下所示：

    <select id = "getByName" parameterType = "User" resultType = "User">

        SELECT * FROM User        
        <if test = "name != null">
            WHERE name LIKE #{name}
        </if>

        <if test = "id != null">
            AND id = #{id}
        </if> 
    </select>

### choose, when, otherwise语句 

MyBatis提供了一个`<choose>`标签，类似Java的switch语句，可以在多个选项中只选择一个生效。

下面的示例，如果name不为空，根据name查询用户，如为空，接着判断下一个条件：如果id不为空，根据id查询用户，如果都不满足进入otherwise分支。

    <select id = "getByNameOrId" parameterType = "User" resultType = "User">
        SELECT * FROM User
        <choose>
            <when test = "name != null">
                WHERE name LIKE #{name}
            </when> 

            <when test = "id != null">
                WHERE id = #{id}
            </when>

            <otherwise>
                WHERE 1 
            </otherwise>

        </choose>

    </select>

### where, set 语句

看前面的例子：

    <select id = "getByName" parameterType = "User" resultType = "User">

        SELECT * FROM User        
        <if test = "name != null">
            WHERE name LIKE #{name}
        </if>

        <if test = "id != null">
            AND id = #{id}
        </if> 
    </select>

如果前一个条件不满足，后面条件满足，生成的sql语句是错的，如下所示：

    SELECT * FROM User
    AND id = xxx

mybatis的`<where>`标签可解决此类问题：

    <select id = "getByName" parameterType = "User" resultType = "User">

        SELECT * FROM User
        <where>
            <if test = "name != null">
                name LIKE #{name}
            </if>

            <if test = "id != null">
                AND id = #{id}
            </if> 
        </where>
    </select>

`<where>`标签只在标签内至少有一个条件成立时才插入where，另外，如果内容以AND或OR开头，mybatis会自动去掉AND与OR。

类似`<where>`，动态更新时可以使用`<set>`，`<set>`标签可以用于动态包含需要更新的列。

示例：

    <update id="updateAuthorIfNecessary">
        update Author
            <set>
                <if test="username != null">username=#{username},</if>
                <if test="password != null">password=#{password},</if>
                <if test="email != null">email=#{email},</if>
                <if test="bio != null">bio=#{bio}</if>
            </set>
        where id=#{id}
    </update>

### foreach语句

foreach的主要作用是遍历一个集合构建in条件。例如，有一个用户List，可以通过foreach遍历List获取所有用户id作为in条件。

foreach标签的属性主要有item，index，collection，open，separator，close。

- item 表示遍历集合时的当前元素（如果集合是map，item是值）
- index 表示遍历集合时的当前元素索引（如果集合是map，item是键）
- open 表示该语句开始字符串
- separator 表示语句中元素之间的分隔符
- close 表示该语句结束字符串
- collection 表示集合的类型，任何可迭代对象（如 List、Set 等）、Map 对象或者数组对象传递给 foreach 作为集合参数

    <select id = "selectUserIn" resultType = "User" parameterType="java.util.List">
        SELECT *
        FROM User
        WHERE id in

        <foreach item = "item" index = "index" collection = "list" open = "(" separator = "," close = ")">
            #{item}
        </foreach>

    </select>

### 动态sql例子

#### UserMapper.xml

映射文件中添加如下代码：

    ...

    <select id="getByName" parameterType="User" resultMap="result">
        SELECT * FROM User

        <if test="name != null">
            WHERE name LIKE #{name}
        </if>

    </select>

    ...

#### App.Java

应用程序main类文件中添加如下代码：

    ...

    System.out.println("------------ 动态sql获取用户 -----------");
    User user3 = new User("user3");
    user3 = (User) session.selectOne("User.getByName", user3);
    System.out.println(user3.getId());
    System.out.println(user3.getName());
    System.out.println("动态sql获取用户成功");

    ....

#### 运行

输出：

    ------------ 动态sql获取用户 -----------
    3
    user3
    动态sql获取用户成功

例子源码

[mybatis-demo1](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo1)

## [MYBATIS教程 – 注解方式](https://www.qikegu.com/docs/2408)

前面章节介绍了使用xml方式编写sql映射语句，实现对数据库的增删改查操作。本章将介绍另外一种方式，使用Java注解编写sql映射语句。

### 准备数据

在[MYBATIS教程 – 环境搭建](https://www.qikegu.com/docs/2385)中，我们创建好了数据库，数据库中包含了一个用户表。

    CREATE DATABASE IF NOT EXISTS `qikegu_mybatis` 
    USE `qikegu_mybatis`;
    
    CREATE TABLE IF NOT EXISTS `user` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
      `name` varchar(50) NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='用户表';
    
    INSERT INTO `user` (`id`, `name`) VALUES
        (1, 'user1'),
        (2, 'user2'),
        (3, 'user3'),
        (4, 'user4'),
        (5, 'user5');

### User 类

创建一个对应的Java类：User.java

    public class User {
        private long id;
        private String name;

        public User(String name) {
            super();
            this.name = name;
        }

        public long getId() {
            return id;
        }
        public void setId(long id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
    }

### UserMapper.java

在前面章节中，使用xml方式编写sql映射语句，映射文件是UserMapper.xml，类似的，使用注解方式，映射文件可命名为UserMapper.java。

UserMapper是一个接口，我们通过给接口函数加注解编写sql映射语句。

可比较一下注解方式与xml方式编写sql映射语句的异同

UserMapper.java

    public interface UserMapper {

        final String getAll = "SELECT * FROM User"; 
        final String getById = "SELECT * FROM User WHERE id = #{id}";
        final String deleteById = "DELETE from User WHERE id = #{id}";
        final String insert = "INSERT INTO User (name) VALUES (#{name})";
        final String update = "UPDATE User SET name = #{name} WHERE id = #{id}";

        @Select(getAll)
        @Results(value = {
            @Result(property = "id", column = "id"),
            @Result(property = "name", column = "name")
        })
        List<User> getAll();

        @Select(getById)
        @Results(value = {
            @Result(property = "id", column = "ID"),
            @Result(property = "name", column = "NAME")
        })
        User getById(long id);

        @Update(update)
        void update(User user);

        @Delete(deleteById)
        void delete(long id);

        @Insert(insert)
        @Options(useGeneratedKeys = true, keyProperty = "id")
        void insert(User user);
    }

### 修改MybatisConfig.xml中的mapper标签

MybatisConfig.xml中的`<mapper>`指向映射文件位置，按如下修改：

    <mappers>
        <mapper class = "com.qikegu.demo.mapper.UserMapper"/>
    </mappers>

### App.java

应用程序main类文件。

    package com.qikegu.demo;

    import java.io.IOException;
    import java.io.Reader;
    import java.util.List;

    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;

    import com.qikegu.demo.mapper.UserMapper;

    public class App {

        public static void main(String args[]) throws IOException {

            Reader reader = Resources.getResourceAsReader("MybatisConfig.xml");
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
            SqlSession session = sqlSessionFactory.openSession();

            UserMapper mapper = session.getMapper(UserMapper.class); 

            System.out.println("------------ 数据插入 -----------");
            // 创建用户对象
            User user = new User("newUser100");

            // 插入新用户到数据库
            mapper.insert(user);
            session.commit();
            System.out.println("数据插入成功");

            System.out.println("------------ 读取用户列表 -----------");
            List<User> userList = mapper.getAll();

            for (User u : userList) {
                System.out.println(u.getId());
                System.out.println(u.getName());
            }

            System.out.println("读取用户列表成功");

            System.out.println("------------ 读取用户详情 -----------");
            User user1 = (User) mapper.getById(user.getId());

            System.out.println(user1.getId());
            System.out.println(user1.getName());

            System.out.println("读取用户详情成功");

            System.out.println("------------ 修改用户 -----------");
            user1.setName("userNameUpdated");
            mapper.update(user1);
            session.commit();

            // 查询修改后的用户详情
            User user2 = (User) mapper.getById(user.getId());

            System.out.println(user2.getId());
            System.out.println(user2.getName());
            System.out.println("修改用户成功");

            System.out.println("------------ 删除用户 -----------");
            mapper.delete(user.getId());
            System.out.println("删除用户成功");

            session.commit();
            session.close();
        }

    }

### 运行

运行结果：

    ------------ 数据插入 -----------
    数据插入成功
    ------------ 读取用户列表 -----------
    1
    user1
    2
    userNameUpdated
    3
    user3
    4
    user4
    5
    user5
    6
    newUser100
    8
    newUser100
    9
    newUser100
    10
    newUser100
    11
    newUser100
    12
    newUser100
    13
    newUser100
    14
    newUser100
    读取用户列表成功
    ------------ 读取用户详情 -----------
    14
    newUser100
    读取用户详情成功
    ------------ 修改用户 -----------
    14
    userNameUpdated
    修改用户成功
    ------------ 删除用户 -----------
    删除用户成功

例子源码

[mybatis-demo2](https://github.com/kevinhwu/qikegu-demo/tree/master/mybatis/mybatis-demo2)

## [MYBATIS教程 – 与Hibernate比较](https://www.qikegu.com/docs/2410)

MyBatis和Hibernate之间有很大的区别，Hibernate以Java对象为中心，是一种ORM，MyBatis以sql为中心，是加强版sql，两者适用场景不一样。

MyBatis的使用场景：

- 希望直接优化维护sql
- 系统由关系数据模型驱动
- 必须处理现有数据或复杂数据

通常web项目中使用Mybatis较多，如果环境是由对象模型驱动的，则使用Hibernate。

### MyBatis与Hibernate的区别

|||
|-|-|
MyBatis|Hibernate
简单，轻量级，利用第三方工具可自动生成sql|相对复杂，学习成本高，自动生成sql
灵活，开发速度快|可伸缩性强，具缓存功能
使用SQL, SQL可能依赖于数据库，但一般项目更换数据库的概率不大|使用独立于数据库的HQL，不依赖数据库
由结果集映射到Java对象，可做到与表结构无关|Hibernate将Java对象映射到数据库表
在MyBatis中使用存储过程非常容易|在Hibernate中使用存储过程有点困难

Hibernate和MyBatis都与SPRING框架兼容，从框架角度来看用哪个都不是问题。
