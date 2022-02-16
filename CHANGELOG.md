# 变更日志
根据Dio封装网络情况库。[仓库地址](https://gitee.com/xjdd/flutter-rx-dio)
1.简单封装dio,
2.通过stream和future 实现数据流转以及监听
3.通过抽象类实现json解析

格式基于[Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
并且该项目遵循 [语义版本控制](https://semver.org/spec/v2.0.0.html)。

## [已发布]

## [1.0.0] - 2022-02-16
＃＃＃ 添加
- 首版本，基于[dio](https://github.com/flutterchina/dio)网络请求框架,进行二次封装.

  dio是一个强大的Dart Http请求库，支持Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时、自定义适配器等...
- 通过Dart自带Steam或者future将dio网络请求部分进行二次包装,在结合sqlite将网络数据进行缓存起来方便读取,通过简单参数设定可以到网络数据
