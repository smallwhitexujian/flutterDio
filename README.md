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

```dart
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

## 网络请求使用方法

### RxDio模式解析 

```dart
    //RX dio模式请求网络
    RxDio<WanbeanEntity>() //泛型解析
      ..setUrl(Constants.config) //请求地址
      ..setParams(null)//params map
      ..setCacheMode(CacheMode.REQUEST_FAILED_READ_CACHE)//缓存模型
      ..setRequestMethod(Method.Get)//请求方式
      ..setTransFrom((p0) {//数据拦截过滤处理，如果有Transformer则先执行Transformer后在执行callBack。
        //只有当结果正常的时候返回正常结果，如果结果错误或者null的时候这里不会触发
          print("======>" + p0.datas[0].content);
          return p0;
      })
      //call返回 transformer后的对象,如果不处理则直接返回完整对象
      ..call(CallBack(onNetFinish: (data, type) {//返回data， type 对于缓存模型   
        print("asadsadasd---> ${}"+ ss.);
      }));
```

### 观察者模式 泛型解析

```dart
//Stream支持,默认多订阅模式 Stream.asBroadcastStream()可以将一个单订阅模式的 Stream 转换成一个多订阅模式的 Stream isBroadcast 属性可以判断当前 Stream 所处的模式
//assert(stream.isBroadcast == false);
//stream.first.then(print);
//stream.last.then(print);// Bad state: Stream already has subscriber.

 ApiService()
        .getResponse<WanbeanEntity>(Constants.config, null, Method.Get)
        .listen((data) {
      print("Stream 流结果： " + data.datas.toString());
    });


//Future 方式
    ApiService()
        .getFutureResponse<WanbeanEntity>(Constants.config, null, Method.Get)
        .then((value) => {print("Future 结果： " + value.toString())});
```
