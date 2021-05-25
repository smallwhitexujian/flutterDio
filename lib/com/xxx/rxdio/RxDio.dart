import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/xxx/rxdio/CallBack.dart';
import 'package:rxdart/rxdart.dart';

///Dart中一切皆对象，函数也是对象。每个对象都有自己的类型，函数的类型是Function，
///typedef就是给Function取个别名，如
typedef JsonTransformation<T> = T Function(String);

///Rx + dio 网络请求
class RxDio<T> {
  //设置网络请求模型
  late Method httpMethod;

  //请求接口地址
  late String url;

  //参数配置
  late Map<String, dynamic>? params;

  //设置缓存模型
  CacheMode cacheMode = CacheMode.NO_CACHE;

  //json解析
  JsonTransformation<T> jsonTransformation = (data) {
    return data as T;
  };

  void setRequestMethod(Method method) {
    this.httpMethod = method;
  }

  void setUrl(String url) {
    this.url = url;
  }

  void setParams(Map<String, dynamic>? params) {
    this.params = params;
  }

  void setCacheMode(CacheMode cacheMode) {
    this.cacheMode = cacheMode;
  }

  void setJsonTransFrom(JsonTransformation<T> jsonTransformation) {
    this.jsonTransformation = jsonTransformation;
  }


  RxDio() : super();

  void call(CallBack<T> callBack) {
    //创建创建数据流控制对象,
    // ignore: close_sinks
    StreamController<RequestData<T>> controller =
        new StreamController<RequestData<T>>();

    if (callBack == null) {
      throw Exception("callBack对象为null");
    }

    //使用观察这模式观察数据流
    Observable(controller.stream).listen((requestData) {
      switch (requestData.requestType) {
        case RequestType.NETWORK:
          //网络数据
          callBack.onNetFinish(requestData.data);
          break;
        case RequestType.CACHE:
          //缓存数据
          // callBack.onCacheFinish(requestData.data);
          break;
        case RequestType.UNKOWN:
          //其他来源
          // callBack.onUnkownFinish(requestData.data);
          break;
      }
    });

    //判断缓存模型没有缓存
    if ((cacheMode == CacheMode.NO_CACHE)) {
      Future future =
          NetworkManager.request(url, params: params, method: httpMethod);
      future.then((response) {
        controller.add(new RequestData(
            RequestType.NETWORK, jsonTransformation(response)));
      });
    }
  }
}
