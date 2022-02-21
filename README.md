# flutter_dio_module

基于Dio封装的网络请求,自带sqlite缓存,可设置缓存也可以不用缓存,使用builder模式网络请求,简单易用，实现了抽象解析json,对返回数据进行二次包装,可以对包装进行处理或者拦截修改.支持切换host，支持拦截器自定义,默认自带网络日志打印.默认支持Stream模式

## 版本已经发布
[pub.flutter.io](https://pub.flutter-io.cn/packages/flutter_dio_module/score)
```dart
  flutter_dio_module: ^1.0.1
```

## 联系我
[项目地址](https://gitee.com/xjdd/flutter-rx-dio)可以在项目里面咨询提问题，也可以提交优化，
[邮箱]xj626361950@163.com

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

### RxDio初始化

创建一个future来初始化项目中所需要的东西,

`GlobalConfig`中可以设置请求的host,是否打印日志,是否使用缓存,设置拦截器

```dart
class Global {
  static Future init() async {
    return GlobalConfig.intstance
      ..setDebugConfig(false)
      ..setHost("https://wanandroid.com/")
      ..setUserCacheConfig(true);
  }
}

void main() => Global.init().then((e) => runApp(MyApp()));
```

### RxDio模式解析 

```dart
    @deprecated //即将过期 建议使用Stream版本
    //RXdio callback 模式请求网络
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
     ..call(CallBack(onNetFinish: (data) {
        print("asadsadasd---> ${data?.error}");
        print("asadsadasd---> ${data?.statusCode}");
        print("asadsadasd---> ${data?.responseType}");
        print("asadsadasd---> ${data?.data?.datas.first.content}");
      }));
```

```dart
    //RXdio Stream 模式请求网络
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
     ..streams().listen((event) {
        _counter = event.responseType.toString();
        print("asadsadasd--1-> ${event.responseType}");
        print("asadsadasd--1-> ${event.data.toString()}");
      });
```



## 摘录

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).

网络库dio二次封装以及简单使用
https://blog.csdn.net/jay100500/article/details/88386470
https://www.imooc.com/article/315143
https://www.jianshu.com/p/6398f9971a36
https://www.jianshu.com/p/dd0b0f3b6065
