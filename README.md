# flutter_dio_module

基于Dio封装的网络请求,自带sqlite缓存,可设置缓存也可以不用缓存,使用builder模式网络请求,简单易用，实现了抽象解析json,对返回数据进行二次包装,可以对包装进行处理或者拦截修改.支持切换host，支持拦截器自定义,默认自带网络日志打印.默认支持Stream模式

## 版本已经发布

欢迎大家关注并提出问题,
[pub.flutter.io](https://pub.flutter-io.cn/packages/flutter_dio_module/score)

```dart
  flutter_dio_module: ^1.1.0
```

## 项目目录结构

```shell

|-- lib
|   |-- com
|   |   |-- app,data
|   |   |   |-- Constants.dart
|   |   |   '-- wanbean_entity.dart
|   |   '-- flutter
|   |       '-- http
|   |           |-- NetworkManager.dart
|   |           |-- RxDio.dart
|   |           |-- RxDioConfig.dart
|   |           |-- adapter
|   |           |   |-- CallBack.dart
|   |           |   |-- Method.dart
|   |           |   '-- ResponseDatas.dart
|   |           |-- bean
|   |           |   '-- BaseBean.dart
|   |           |-- interceptorss
|   |           |   '-- HttpLogInterceptor.dart
|   |           |-- interface
|   |           |   '-- BaseApplication.dart
|   |           '-- utils
|   |               |-- CacheManagers.dart
|   |               |-- DatabaseSql.dart
|   |               '-- MD5Utils.dart
```

lib 项目仓库总包
app,data 数据以及常量配置表
http 为插件源码仓库

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

使用方法 插件导入之后,json数据放入插件点击保存就可以了.<https://blog.csdn.net/yuzhiqiang_1993/article/details/88533166>

## 网络请求使用方法

### RxDio初始化

创建一个future来初始化项目中所需要的东西,

`GlobalConfig`中可以设置请求的host,是否打印日志,是否使用缓存,设置拦截器

```dart
class Global {
  static Future init() async {
    return GlobalConfig.intstance
      ..setDebugConfig(true)
      ..setHost("https://wanandroid.com/")
      ..setUserCacheConfig(true)
      ..setJsonConvert(jsonConvert);//次参数为必选项,用于解析使用,JsonConvert()需要继承IJsonConvert
  }
}

void main() => Global.init().then((e) => runApp(MyApp()));
```

### 设置JsonConvert()类

找到目录`'package:workspac/generated/json/base/json_convert.content.dart'`继承`IJsonConvert`

如果找不到`json_convert.content.dart`使用FlutterJsonBeanFactory插件导入一下即可

```dart
class JsonConvert extends IJsonConvert {
  T? convert<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return asT<T>(value);
  }
```

### RxDio模式解析

```dart
Stream<ResponseDatas<WanbeanEntity>> test() {
  var aaa = RxDio.instance;
  aaa.setUrl(Constants.config);
  aaa.setCacheMode(CacheMode.DEFAULT);
  aaa.setRequestMethod(Method.Get);
  aaa.setTransFrom<WanbeanEntity>((p0) {
    var a = p0 as WanbeanEntity;
    print("=======setTransFrom>" + a.datas.first.content);
    return p0;
  });
  return aaa.asStreams<WanbeanEntity>();
}

 ///设置刷新
 setState(() {
    test();
  });

  ///页面结束的时候取消请求
   @override
  void dispose() {
    RxDio.instance.cancelAll();
    super.dispose();
  }


Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Text(
      'You have pushed the button this many times:$_counter',
    ),
    StreamBuilder<ResponseDatas<WanbeanEntity>>(
      builder: ((context, snapshot) {
        return Text(
          '${snapshot.data?.data?.size}',
          style: Theme.of(context).textTheme.headline4,
        );
      }),
      stream: test(),
    ),
  ],
)
```

## [更新日志](https://gitee.com/xjdd/flutter-rx-dio/blob/master/CHANGELOG_cn.md)

## 摘录(感谢大佬)

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/docs/development/add-to-app).

网络库dio二次封装以及简单使用
<https://blog.csdn.net/jay100500/article/details/88386470>
<https://www.imooc.com/article/315143>
<https://www.jianshu.com/p/6398f9971a36>
<https://www.jianshu.com/p/dd0b0f3b6065>
