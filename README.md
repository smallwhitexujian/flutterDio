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

## 网络请求使用方法

### RxDio模式解析

```java
    //RX dio模式请求网络
    RxDio<BaseBean<ConfigBeanEntity>>()
      ..setUrl(Constants.CONFIG)
      ..setRequestMethod(Method.Get)
      ..setParams(null)
      ..setCacheMode(CacheMode.REQUEST_FAILED_READ_CACHE)
      ..setJsonTransFrom((data) {
        if (data != null) {
          Map<String, dynamic> map = json.decode(data);
          return BaseBean<ConfigBeanEntity>.fromJson(map);
        }
        return BaseBean<ConfigBeanEntity>.fromJson(new Map());
      })
      ..call(new CallBack(onNetFinish: (data) {
        print("网络请求返回数据：" + data.data!.gurl);
      },
      onCacheFinish: (data){
        print("缓存数据返回：" + data.data!.gurl);
      }));
```

### 观察者模式

```java
//创建观察者对象
class ApiService {
  Observable post<T>(String url, Map<String, dynamic>? params, Method method) =>
      Observable.fromFuture(NetworkManager.request<T>(Constants.CONFIG,
              params: params, method: method)).asBroadcastStream();
}
//观察着模式
ApiService().post(Constants.CONFIG, Map(), Method.Get).listen((event) {
  var data = event as Response;
  Map<String, dynamic> map = json.decode(data.data);
  BaseBean configBeanEntity = BaseBean<ConfigBeanEntity>.fromJson(map);
  print("观察者模式： " + data.toString());
  print("观察者模式 " + (configBeanEntity.data as ConfigBeanEntity).gurl);
});

```

### 泛型解析

```
NetworkManager.requestBaseBeanData<ConfigBeanEntity>(Constants.CONFIG, onSuccess: (datas) {
  print("泛型解析类：" + datas!.wsurl);
},  method: Method.Get);
```
