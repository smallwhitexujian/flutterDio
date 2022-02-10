import 'dart:async';
import 'dart:convert';

import 'package:flutter_dio_module/com/flutter/http/ApiService.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/CallBack.dart';
import 'package:flutter_dio_module/com/flutter/http/bean/BaseBean.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/CacheManagers.dart';

///Dart中一切皆对象，函数也是对象。每个对象都有自己的类型，函数的类型是Function，
///typedef就是给Function取个别名，如
typedef JsonTransformation<T> = T Function(String?);

///Rx + dio 网络请求
class RxDio<T> {
  //设置网络请求模型
  Method httpMethod = Method.Post;

  //设置默认缓存
  bool isUserCache = true;

  //请求接口地址
  late String url;

  //参数配置
  late Map<String, dynamic>? params;

  //设置缓存模型
  CacheMode cacheMode = CacheMode.NO_CACHE;

  //json解析
  JsonTransformation<T> jsonTransformation = (data) {
    if (data == null) {
      throw Exception("data is not null");
    }
    return data as T;
  };

  //初始化缓存数据库
  void initDb() {
    CacheManagers.init();
  }

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

  //网络请求以及数据流程控制
  void call(CallBack<T>? callBack) {
    //创建创建数据流控制对象,
    // ignore: close_sinks
    StreamController<RequestData<T>> controller =
        new StreamController<RequestData<T>>();

    //判断缓存模型没有缓存
    switch (cacheMode) {
      case CacheMode.DEFAULT:
      case CacheMode.NO_CACHE:
        //默认没有缓存
        ApiService().getResponse<T>(url, params, httpMethod).listen((data) {
          controller.add(new RequestData(RequestType.NETWORK, data));
        });
        break;
      case CacheMode.REQUEST_FAILED_READ_CACHE:
        //先获取网络,在获取缓存
        ApiService().getResponse<T>(url, params, httpMethod).listen((data) {
          if (data.runtimeType == T) {
            controller.add(new RequestData(RequestType.NETWORK, data));
          } else {
            CacheManagers.getCache(url, params).listen((event) {
              if (event.isNotEmpty) {
                //存在缓存返回缓存
                Map<String, dynamic> jsonData = json.decode(event);
                BaseBean bean = BaseBean<T>.fromJson(jsonData);
                controller.add(new RequestData(RequestType.CACHE, bean.data));
              } else {
                //不存在缓存返回错误
                controller.add(RequestData(
                    RequestType.CACHE, jsonTransformation(null),
                    statusCode: 400));
              }
            });
          }
        });
        break;
      case CacheMode.FIRST_CACHE_THEN_REQUEST:
        //先获取缓存,在获取网络数据
        CacheManagers.getCache(url, params).listen((event) {
          if (event.isNotEmpty) {
            //存在缓存返回缓存
            Map<String, dynamic> jsonData = json.decode(event);
            BaseBean bean = BaseBean<T>.fromJson(jsonData);
            controller.add(new RequestData(RequestType.CACHE, bean.data));
          }
        });
        ApiService().getResponse<T>(url, params, httpMethod).listen((data) {
          controller.add(new RequestData(RequestType.NETWORK, data));
        });
        break;
    }

    //使用观察这模式观察数据流
    controller.stream.listen((requestData) {
      if (callBack != null) {
        callBack.onNetFinish!(requestData.data, requestData.requestType);
      }
    });
  }
}
