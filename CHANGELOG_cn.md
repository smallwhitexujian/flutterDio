# 变更日志

根据Dio封装网络情况库。[仓库地址](https://gitee.com/xjdd/flutter-rx-dio)

1. 简单封装dio,
2. 通过stream和future 实现数据流转以及监听
3. 通过抽象类实现json解析

## [English documents](/CHANGELOG.md)

## [1.0.0] - 2022-02-16

### 添加

1. 首版本，基于[dio](https://github.com/flutterchina/dio)网络请求框架,进行二次封装.
2. dio是一个强大的Dart Http请求库，支持Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时、自定义适配器等...
3. 通过Dart自带Steam或者future将dio网络请求部分进行二次包装,在结合sqlite将网络数据进行缓存起来方便读取,通过简单参数设定可以到网络数据

## [1.0.1] - 2022-02-18

### 升级

1. 优化网络请的时候可以动态修改host地址根据业务情况自行修改
2. `Transformations` 优化之前不能准确判断类型目前可以实现准确判断类型,`Transformations`使用具体如下:
3. RequestData调整,之前无法区分包装返回数据,导致`Transformations`会出现数据混乱的情况,调整后，增加error类型，增减数据来源`ResponseType`:ERROR,CACHE,UNKOWN,NETWORK分别从这个几个方面可以来源数据.
4. RxdioConfig配置初始化调整,默认开启缓存,默认关闭打印日志输出,增加拦截器配置
5. 调整网络缓存的逻辑，之前逻辑没有根据网络条件判断,目前增加网络条件判断.

- DEFAULT:默认走网络请求
- NO_CACHE:没有缓存直接网络请求
- REQUEST_FAILED_READ_CACHE:判断网络环境，先获取网络,当网络不行的时候在获取缓存.
- FIRST_CACHE_THEN_REQUEST:优先触发缓存数据同时在请求网络数据会触发刷新两次,如果缓存不存在直接触发网络数据.然后在网络拦截器里面进行拦截缓存到sqlite

```dart
..setTransFrom((streamData) {
  //TODO 这里StreamData返回是当前请求返回的对象,可以进行修改对象，返回一个修改后的对象
  return streamData;
})
```


## [1.0.2] - 2022-02-21

### RxDio 增加Stream返回结果模式

1. 优化网络请求返回模式,增加Stream模式
2. Callback后期不会在维护建议升级到Stream模式

```dart
RxDio<WanbeanEntity>()
  ..setUrl(Constants.config)
  ..setParams(null)
  ..setCacheMode(CacheMode.FIRST_CACHE_THEN_REQUEST)
  ..setRequestMethod(Method.Get)
  ..setTransFrom((p0) {
    print("======>" + p0?.datas[0].content);
    return p0;
})
..streams().listen((event) {
    print("asadsadasd--1-> ${event.responseType}");
    print("asadsadasd--1-> ${event.data.toString()}");
});
```

## [1.0.3]-2022-03-03

### Rxdio调整创建模式支持单例模式

1. RxDio支持单例模式,支持Stream,future返回数据格式
2. 增加CancelToken 参数设置 默认创建CancelToken。
3. 增加全部取消cancelAll(),指定取消cancel(),批量取消cancelList()
4. ApiService废弃
5. 修改部分文件名称

## [1.0.4]-2022-03-04

### Rxdio 优化

1. ApiService移除,优化RxDio类的网络请求直接从`NetworkManager.dart`直接获取.
2. 优化md文档说明.
