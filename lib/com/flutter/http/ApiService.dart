import 'dart:async';
import 'dart:convert';

import 'package:flutter_dio_module/com/app,data/config_bean_entity.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:rxdart/rxdart.dart';

import '../../app,data/Constants.dart';
import 'RxDio.dart';
import 'adapter/CallBack.dart';
import 'adapter/Method.dart';
import 'bean/BaseBean.dart';

class ApiService {


  Observable post<T>(String url, Map<String, dynamic>? params, Method method) =>
      Observable.fromFuture(NetworkManager.request<T>(Constants.CONFIG,
              params: params, method: method)).asBroadcastStream();


   getConfig(String url, Method method,Map<String,dynamic>? params,CacheMode cacheMode,{CallBack<BaseBean<ConfigBeanEntity>>? callBack}){
    //RX dio模式请求网络
    RxDio<BaseBean<ConfigBeanEntity>>()
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

