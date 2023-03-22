---
title: Hello, Hexo
date: 2022-09-01 11:57:00
---
Welcome to [Hexo](https://hexo.io/)! This is your very first post. Check [documentation](https://hexo.io/docs/) for more info. 

# Quick Start
## Create a new post

``` bash
$ hexo new "My New Post"
```

## shortcut

```bash
$ hexo clean && hexo g && hexo d && hexo s
```
<!--more-->
More info: [Writing](https://hexo.io/docs/writing.html)
More info: [Generating](https://hexo.io/docs/generating.html)
More info: [Deployment](https://hexo.io/docs/one-command-deployment.html)

## next主题样式
### 修改行间距
https://github.com/theme-next/hexo-theme-next/issues/1703

## 开启mathJax

## 部署到github.io页面
创建名为guaguastandup.github.io的空仓库，然后在hexo/_config.yml中设置：
```yml
deploy:
  type: git
  repository: git@github.com:guaguastandup/guaguastandup.github.io.git
  branch: main
```

## 插入图片
vscode: 插件paste image
- 配置路径，将图片路径设置在${currentFileDir}/${currentFileNameWithoutExt}中
- 快捷键：command + option + V

安装hexo-asset-image
执行`npm install https://github.com/CodeFalling/hexo-asset-image --save`