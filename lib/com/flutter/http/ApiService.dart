import 'dart:async';
import 'dart:convert';

import 'package:flutter_dio_module/com/app,data/config_bean_entity.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';

import '../../app,data/Constants.dart';
import 'RxDio.dart';
import 'adapter/CallBack.dart';
import 'adapter/Method.dart';
import 'bean/BaseBean.dart';

class ApiService {
  Stream post<T>(String url, Map<String, dynamic>? params, Method method) =>
      Stream.fromFuture(NetworkManager.request<T>(Constants.config,
              params: params, method: method))
          .asBroadcastStream();

  getResponse<T>(String url, Method method, Map<String, dynamic>? params,
      CacheMode cacheMode,
      {CallBack<BaseBean<T>>? callBack}) {
    //RX dio模式请求网络
    print("url ${url}\n," +
        "method ${method}\n," +
        "params ${params}\n," +
        "cacheMode ${cacheMode}\n,");
    RxDio<BaseBean<dynamic>>()
      ..setUrl(url)
      ..setRequestMethod(method)
      ..setParams(params)
      ..setCacheMode(cacheMode)
      ..setJsonTransFrom((data) {
        //数据解析
        if (data != null) {
          Map<String, dynamic> map = json.decode(data);
          return BaseBean<ConfigBeanEntity>.fromJson(map);
        }
        return BaseBean<ConfigBeanEntity>.fromJson(new Map());
      })
      ..call(callBack);
    // ..call(new CallBack(onNetFinish: (data) {
    //   if (data.data != null) {
    //     Observable.just(data.data);
    //   }
    // }, onCacheFinish: (data) {
    //   if (data.data != null) {
    //     Observable.just(data.data);
    //   }
    // }))
  }
}
