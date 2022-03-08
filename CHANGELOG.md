# change Log

Encapsulate the network condition library according to Dio. [warehouse address] (<https://gitee.com/xjdd/flutter-rx-dio>).

1. Simple package dio.
2. Data transfer and monitoring through stream and future.
3. Implement json parsing through abstract classes.

The format is based on [Keep a Changelog] (<https://keepachangelog.com/en/1.0.0/>).
And the project follows [semantic version Control] (<https://semver.org/spec/v2.0.0.html>).

## [中文文档](/CHANGELOG_cn.md)

## [1.0.9]-2022-03-08

1. 修改lib_dio.dart依赖
2. 修改BaseBean.dart

## [1.0.4]-2022-03-04

### Rxdio optimization

1. Remove ApiService, and obtain network requests for optimized RxDio directly from `NetworkManager.dart`.
2. Optimize the md documentation description.

## [1.0.3]-2022-03-03

### Rxdio adjustment creation mode supports singleton mode

 1. RxDio supports singleton mode and Stream,future return data format.
 2. Add CancelToken parameter setting to create CancelToken by default.
 3. Add all cancel cancelAll (), specify cancel cancel (), batch cancel cancelList ().
 4. ApiService discarded.
 5. Modify part of the file name.

## [1.0.2]-2022-02-21

### RxDio adds Stream to return result mode

 1. Optimize the return mode of network request and add Stream mode
 2. Callback will not upgrade to Stream mode in the later stage of maintenance.

## [1.0.1]-2022-02-18

### upgrade

 1. When you optimize the network, you can dynamically modify the host address and modify it according to the business situation.
 2. `Transformations` cannot accurately determine the type before optimization. Currently, you can accurately determine the type. The usage of `Transformations` is as follows
 3. RequestData adjustment. Previously, it is impossible to distinguish the returned data from packaging, resulting in data confusion in `Transformations`. After adjustment, add error type, add or decrease data source `ResponseType`: ERROR,CACHE,UNKOWN,NETWORK can source data from these aspects respectively.
 4. Adjust the logic of the network cache, the previous logic did not judge according to the network conditions, but now add the network condition judgment.
 5. RxdioConfig configuration initialization adjustment. Cache is enabled by default, print log output is turned off by default, and interceptor configuration is added.

- DEFAULT: network request by default.
- NO_CACHE: direct network requests are not cached.
- REQUEST_FAILED_READ_CACHE: judge the network environment, get the network first, and get the cache when the network fails.
- FIRST_CACHE_THEN_REQUEST: trigger cache data first while requesting network data will trigger refresh twice, if cache does not exist, directly trigger network data. Then intercept the cache to sqlite in the network interceptor.

```dart
..setTransFrom((streamData) {
  //TODO 这里StreamData返回是当前请求返回的对象,可以进行修改对象，返回一个修改后的对象
  return streamData;
})
```

## [1.0.0]-2022-02-16

### add

-the first version is based on [dio] (<https://github.com/flutterchina/dio>) network request framework) for secondary encapsulation.

Dio is a powerful Dart Http request library that supports Restful API, FormData, interceptor, request cancellation, Cookie management, file upload / download, timeout, custom adapters, etc.
-the dio network request part is re-packaged by Dart with Steam or future, and the network data is cached in combination with sqlite for easy reading. The network data can be accessed through simple parameter settings.
