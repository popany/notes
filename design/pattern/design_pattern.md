# Design Pattern

- [Design Pattern](#design-pattern)
  - [整理](#整理)
    - [对比](#对比)
      - [模板模式(Template Pattern) v.s. 策略模式(Strategy Pattern)](#模板模式template-pattern-vs-策略模式strategy-pattern)

## 整理

### 对比

#### 模板模式(Template Pattern) v.s. 策略模式(Strategy Pattern)

- 模板模式基于继承

  - 使用派生类重写基类的部分方法, 从而实现部分修改基类中的算法

  - 应用于类级别

    - 是静态的

- 策略模式基于组合

  - 修改对象中的某些成员，从而改变对象的行为

  - 应用于对象基本

    - 支持动态修改对象行为
