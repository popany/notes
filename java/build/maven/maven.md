# maven

- [maven](#maven)
  - [command](#command)
    - [创建项目](#创建项目)
    - [idea](#idea)
      - [生成 idea 项目文件](#生成-idea-项目文件)
      - [清除 idea 项目文件](#清除-idea-项目文件)
    - [查看项目依赖](#查看项目依赖)
  - [整理](#整理)
    - [`<XXXmagement>` vs `<XXX>`](#xxxmagement-vs-xxx)
  - [Q & A](#q--a)
    - [Differences between dependencyManagement and dependencies in Maven](#differences-between-dependencymanagement-and-dependencies-in-maven)
      - [Pascal Thivent](#pascal-thivent)
      - [dcoder](#dcoder)
    - [What is pluginManagement in Maven's pom.xml?](#what-is-pluginmanagement-in-mavens-pomxml)
      - [Answers 1](#answers-1)
      - [Answer 2](#answer-2)

## command

### 创建项目

    mvn archetype:generate -DgroupId=com.companyname.bank -DartifactId=consumerBanking -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

### idea

#### 生成 idea 项目文件

    mvn idea:idea

#### 清除 idea 项目文件

    mvn idea:clean

### 查看项目依赖

    mvn dependency:tree

## 整理

### `<XXXmagement>` vs `<XXX>`

`<XXXmagement>` 用于指定子项目中引入的 `<XXX>` 的默认配置, 子项目可以覆盖这些配置.

## Q & A

### [Differences between dependencyManagement and dependencies in Maven](https://stackoverflow.com/questions/2619598/differences-between-dependencymanagement-and-dependencies-in-maven)

#### Pascal Thivent

[Dependency Management](http://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#Dependency_Management) allows to **consolidate and centralize the management of dependency versions** without adding dependencies which are inherited by all children. This is especially useful when you have **a set of projects** (i.e. more than one) that inherits a **common parent**.

Another extremely important use case of dependencyManagement is the control of versions of artifacts used in transitive dependencies. This is hard to explain without an example. Luckily, this is illustrated in the documentation.

#### dcoder

I'm fashionably late to this question, but I think it's worth a clearer response than the accepted one (which is correct, but doesn't emphasize the actual important part, which you need to deduce yourself).

In the parent POM, the main difference between the `<dependencies>` and `<dependencyManagement>` is this:

- Artifacts specified in the `<dependencies>` section will **ALWAYS be included** as a dependency of the child module(s).

- Artifacts specified in the `<dependencyManagement>` section, will only be included in the child module if they were also specified in the **`<dependencies>` section of the child module** itself. Why is it good you ask? Because you specify the version and/or scope in the parent, and you can leave them out when specifying the dependencies in the child POM. This can help you use unified versions for dependencies for child modules, without specifying the version in each child module.

### [What is pluginManagement in Maven's pom.xml?](https://stackoverflow.com/questions/10483180/what-is-pluginmanagement-in-mavens-pom-xml)

#### [Answers 1](https://stackoverflow.com/questions/10483180/what-is-pluginmanagement-in-mavens-pom-xml/10483284#10483284)

You still need to add

    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-dependency-plugin</artifactId>
        </plugin>
    </plugins>

in your build, because pluginManagement is only a way to share the same plugin configuration across all your project modules.

From [Maven documentation](http://maven.apache.org/pom.html#Plugin_Management):

> pluginManagement: is an element that is seen along side plugins. Plugin Management contains plugin elements in much the same way, except that rather than **configuring plugin information** for this particular project build, it is intended to configure **project builds that inherit from this one**. However, this **only configures plugins that are actually referenced** within the plugins element in the children. The children **have every right to override** pluginManagement definitions.

#### [Answer 2](https://stackoverflow.com/questions/10483180/what-is-pluginmanagement-in-mavens-pom-xml/10483432#10483432)

The difference between `<pluginManagement/>` and `<plugins/>` is that a `<plugin/>` under:

- `<pluginManagement/>` **defines the settings** for plugins that will be inherited by modules in your build. This is great for cases where you have a parent pom file.

- `<plugins/>` is a section for the **actual invocation** of the plugins. It may or may not be inherited from a `<pluginManagement/>`.

You don't need to have a `<pluginManagement/>` in your project, if it's not a parent POM. However, if it's a parent pom, then **in the child's pom**, you need to have a declaration like:

    <plugins>
        <plugin>
            <groupId>com.foo</groupId>
            <artifactId>bar-plugin</artifactId>
        </plugin>
    </plugins>

Notice how you aren't defining any configuration. You can inherit it from the parent, unless you need to further adjust your invocation as per the child project's needs.

For more specific information, you can check:

- The Maven pom.xml reference: [Plugins](https://maven.apache.org/pom.html#Plugins)

- The Maven pom.xml reference: [Plugin Management](https://maven.apache.org/pom.html#Plugin_Management)
