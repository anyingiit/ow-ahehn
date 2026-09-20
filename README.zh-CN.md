[English](README.md) · **简体中文**

> 英文版是规范版本。本页与 [README.md](README.md) 不一致时，以英文版为准。

<!-- translation-of: README.md sha256:4dcfdfb1a627206b -->

<!-- Source: Best-README-Template BLANK_README (Unlicense) — https://github.com/othneildrew/Best-README-Template -->
<a id="readme-top"></a>

# Ow Ahehn

一份 OverPy 源代码脚本，用于 Overwatch 自定义游戏中的一个猎杀名单模式；它需要先编译、再粘贴进工作坊（Workshop）房间里运行，而不是被构建、测试或作为普通软件运行。

[![License](https://img.shields.io/github/license/anyingiit/ow-ahehn)](LICENSE)

[报告问题](https://github.com/anyingiit/ow-ahehn/issues/new?template=bug_report.yml) · [提出需求](https://github.com/anyingiit/ow-ahehn/issues/new?template=feature_request.yml)

<details>
  <summary>目录</summary>
  <ol>
    <li><a href="#关于本项目">关于本项目</a></li>
    <li><a href="#开始使用">开始使用</a></li>
    <li><a href="#使用方法">使用方法</a></li>
    <li><a href="#贡献">贡献</a></li>
    <li><a href="#许可证">许可证</a></li>
    <li><a href="#联系方式">联系方式</a></li>
  </ol>
</details>

## 关于本项目

Ow-ahehn 中有两个 OverPy 源文件，都是给 Overwatch 工作坊（Workshop）自定义游戏用的：[`main.opy`](main.opy) 定义了一个"猎杀名单"模式（文件内部的规则名本身就是中文，"暗杀"即"assassination"之意），共有三种可配置玩法——无差别混战、英雄白名单、英雄黑名单——它会记录每名玩家的死亡原因，当名单上的玩家被另一名在名单上的玩家击杀时（并非扛过一次暗杀而幸存），死者会获得一次"力量"充能，之后可以同时按住三个键消耗这次充能，一次性击杀当前名单上的所有玩家（包括自己），游戏内 HUD 会显示当前名单、剩余充能数和各项快捷键；[`test.opy`](test.opy) 是另一个很小的独立脚本，只用来测试工作坊 `switch` 语句的行为，与上述模式没有关系。OverPy 是一种类 Python 语言，会被编译成 Overwatch 自身的工作坊规则格式，编译结果只能在 Overwatch 自定义游戏房间内运行，不是一个独立程序。

规划中的内容参见 [open issues](https://github.com/anyingiit/ow-ahehn/issues)。

## 开始使用

### 前置条件

- 一份 PC 版 Overwatch，并拥有创建或编辑自定义游戏及其工作坊设置的权限——编译后的规则也只能在这里运行。
- 一个 OverPy 编译器，用来把 [`main.opy`](main.opy) 或 [`test.opy`](test.opy) 转换成工作坊代码；本仓库并未附带编译器，其自身的提交历史（`0f812d7`）中提到源码最后一次迁移到了 "overpy5.0" 版本。

### 安装

本仓库没有需要安装的包，也没有构建步骤。克隆本仓库即可在本地获得这两个源文件的副本：

```sh
git clone https://github.com/anyingiit/ow-ahehn.git
cd ow-ahehn
```

要让任意一个文件在 Overwatch 中真正可用，需要先把它交给一个 OverPy 编译器（不包含在本仓库中）生成工作坊代码，然后打开 Overwatch，创建或编辑一局自定义游戏，进入其工作坊设置，把生成的代码粘贴进去。

## 使用方法

`main.opy` 和 `test.opy` 都不会在游戏之外单独运行。当 `main.opy` 编译出的工作坊代码被放进某局自定义游戏的设置中并开始游戏后，猎杀名单模式就会按脚本运行：`GameDefaultMode` 决定采用无差别混战、白名单还是黑名单玩法（默认随机选择，也可固定指定）；被列入名单的玩家在被另一名在名单上的玩家击杀时会获得一次"力量"充能，并可以通过同时按住互动键、主火键和副火键消耗一次充能，一次性击杀当前名单上的所有玩家（包括自己）；HUD 会持续向每名玩家展示当前名单、剩余充能数和快捷键。`test.opy` 与该模式无关——它只是一个用来检验工作坊 `switch` 语句行为的小脚本。

## 贡献

欢迎任何形式的贡献。参与前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何提交 issue 或 pull request，并阅读 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) 了解参与者应遵守的行为准则。

请不要在公开的 issue 或 pull request 中报告安全问题。请参阅 [SECURITY.md](SECURITY.md) 了解如何私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。

## 联系方式

项目地址：[https://github.com/anyingiit/ow-ahehn](https://github.com/anyingiit/ow-ahehn)

<p align="right">(<a href="#readme-top">回到顶部</a>)</p>
