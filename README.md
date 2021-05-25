# flutter_dio_module

A new Flutter module.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).


网络库dio二次封装以及简单使用
https://blog.csdn.net/jay100500/article/details/88386470
https://www.imooc.com/article/315143
https://www.jianshu.com/p/6398f9971a36
https://www.jianshu.com/p/dd0b0f3b6065

## Json解析
解析方式有别于android解析,对序列化和反序列化进行解析.

1.解析JSON and serialization 这种方式处理起来比较麻烦需要手动敲字段获取数据.
2.可以通过三方网站实现bean类的实现[documentation](https://javiercbk.github.io/json_to_dart/).

使用方法
```java
 /*先将字符串转成json*/
    Map<String, dynamic> json = jsonDecode(jsonData);
    /*将Json转成实体类*/
    NewsBean newsBean=NewsBean.fromJson(news);
    /*取值*/
    String sats = newsBean.result.stat;
```

3.比较方便一点AS导入插件FlutterJsonBeanFactory通过插件直接去生成对应bean不需要手动更改推荐此方案.

使用方法 插件导入之后,json数据放入插件点击保存就可以了.

https://blog.csdn.net/yuzhiqiang_1993/article/details/88533166