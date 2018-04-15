---
layout: post
title: 技术报告
subtitle: 使用CI和Codecov进行持续集成和代码覆盖率统计
author: 陈序
date: 2018-03-15 21:09:29 +0800
categories: 系统分析与设计
tag: [系统分析与设计, 技术报告, 持续集成]
---

# 持续集成
## 什么是CI
> In software engineering, continuous integration (CI) is the practice of merging all developer working copies to a shared mainline several times a day.[^1]
> 持续集成指的是，频繁地（一天多次）将代码集成到主干。持续集成的目的，就是让产品可以快速迭代，同时还能保持高质量。[^2]
常见的第三方持续集成服务有``Travis CI``, ``CirCleCI``等等，而``gitlab``还有自家的``gitlab-runner``。
``github``官方的一些推荐<del>（广告）</del>，可以参照一下[这个](https://github.com/marketplace/category/continuous-integration)。


## Travis CI
> Travis CI是在软件开发领域中的一个在线的，分布式的持续集成服务，用来构建及测试在GitHub托管的代码。[^3]
使用``Travis CI``，可以实现代码更新的时候自动触发测试，部署代码等等工作，简化项目管理和维护工作。

## 配置Travis CI
Travis CI的详细配置[官方文档](https://docs.travis-ci.com/)比较详尽，网上的博客也比较多，就不详细的介绍了。
### 1. 首先，要有一个仓库，我创建了如下的代码：
~~~
|
+-- main.py
+-- test.py
~~~

+ main.py

~~~python
#!/usr/bin/python

from test import *

def main():
    animals = []
    animals.append(Crow("Brown"))
    animals.append(Cat("John"))
    animals.append(Dog("Alice"))
    animals.append(Crow("HAHA"))
    animals.append(Cat("PAPA"))
    animals.append(Dog("LALA"))
    for a in animals:
        a.speek()

if __name__ == '__main__':
    main()
~~~

+ test.py

~~~python

class Animal(object):
    def __init__(self, name):
        self._name = name
    def speek(self):
        raise NotImplementedError("I can't speek")
    

class Crow(Animal):
    def speek(self):
        print(f"I'm a crow called {self._name}. Caw.")


class Cat(Animal):
    def speek(self):
        print(f"I'm a cat called {self._name}. Meow.")


class Dog(Animal):
    def speek(self):
        print(f"I'm a dog called {self._name}. Woof.")
~~~

### 2. 添加Travis的配置文件``.travis.yml``
~~~yml
language: python
notifications:
  email: false
sudo: false
python:
  - 3.6

install: true
script:
  - python main.py
~~~
简单解释一下：
``install``是执行前的安装，这里好像没有什么依赖，就不用了。
``script``是脚本的执行
``sudo: false``表示不使用sudo执行
``python: 3.6``表示使用``3.6``版本的``python``，这里的键是与语言相关的，比如language是nodejs的话，那么就是``node_js: 9.0``。因为代码中使用到了模板字符串，所以只能指定版本3.6以上。

### 3. 使用你的``github``注册``Travis CI``
这里鼠标点点点就好了，点一下头像那里的``profile``, ``Sync account``点一下，就可以看到你的项目列表了。点一下开关，OK。
这时候只要你的仓库发生了改动，就应该会触发``build``了。
如果顺利的话，就可以看到运行的结果了。
![](/img/post/2018-04-15/ci-result.png)

## CircleCI
这个部分是后来加的，好像``CircleCI``名气没有``Travis CI``大，<del>博客少了点（还真是惨）</del>。但是个人测试了一下，跟gitlab-runner比较相似，有job和step的概念，顿时好感度爆棚。这里也写一下。

## CircleCI 配置

### 1. 使用``github``注册
同样的鼠标点点点，不停地点，把自己的仓库加进去，这时候``CircleCI``就会告诉你如何操作。
![](/img/post/2018-04-15/circle-ci.png)

### 2. 添加配置文件
按照要求，创建``.circleci/config.yml``。
魔改了一波sample
~~~yml
version: 2
jobs:
  build:
    docker:
      - image: circleci/python:3.6.1
    working_directory: ~/repo

    steps:
      - checkout
      - run:
          name: install dependencies
          command: pip install --user codecov coverage

      - run:
          name: run tests
          command: python -m coverage run main.py
      - run:
          name: upload converage
          command: python -m codecov
          
~~~
![](/img/post/2018-04-15/circle-ci-result.png)
# 使用codecov进行代码覆盖率统计

## 什么是代码覆盖率
> 代码覆盖（英语：Code coverage）是软件测试中的一种度量，描述程式中源代码被测试的比例和程度，所得比例称为代码覆盖率[^3]

代码覆盖率往往用来衡量测试好坏的指标，一个好的测试，应当是尽可能的覆盖所有的功能代码。覆盖率越高并不能说明代码进行了更加充分的测试，但是能够一定程度上的反映测试内容的覆盖情况以及质量。如果代码覆盖率很低的话，那么测试的效果不会很理想。

## codecov
![](/img/post/2018-04-15/codecov.png)

``codecov``并不是代码覆盖率的工具，它只是负责数据的统计和直观反映，是一个框架服务。``codecov``支持很多工具和语言，比如C/C++, Bash, Python等等，这里有详细的[列表](https://docs.codecov.io/docs/supported-languages)

## 配置覆盖率统计工具
``codecov``对于python的支持可以参见[官方的github](https://github.com/codecov/example-python)，这里我们为了简单，使用了``coverage``。
1. 往.travis.yml添加统计用的脚本
~~~yml
script:
  - python -m coverage run main.py
~~~

2. 完成后上传至``codecov``
打开codecov的[官网](codecov.io)，同样点点点，用github登录，可以看到你的项目。关联到项目后，可以看到有一个``Repository Upload Token``，如果你的仓库要搞成私有的，那么上传的时候就会使用到这个``token``<del>（壕友乎？）</del>。

使用codecov-python进行上传，这里我们使用到了``Travis CI``的``Hook``
~~~yml
after_success:
  - python -m codecov
~~~

触发仓库更新，如果CI成功完成的话，那么就会将结果上传到codecov的官网。
![](/img/post/2018-04-15/codecov-result-line.png)
![](/img/post/2018-04-15/codecov-result-others.png)

# 给自己的README添加小图标
在Travis CI的项目主页上，点击小图标，就可以生成CI的图标了
![](/img/post/2018-04-15/ci-icon.png)
![](/img/post/2018-04-15/ci-icon2.png)
在codecov的项目Setting > Badge里面，就可以找到链接
![](/img/post/2018-04-15/codecov-icon.png)

效果如下：
![](/img/post/2018-04-15/readme.png)
美美哒～

---

[^1]: [Continuous_integration](https://en.wikipedia.org/wiki/Continuous_integration)
[^2]: [持续集成是什么？](http://www.ruanyifeng.com/blog/2015/09/continuous-integration.html)
[^3]: [代码覆盖率](https://zh.wikipedia.org/zh-cn/代码覆盖率)