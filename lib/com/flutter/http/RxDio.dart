import 'dart:async';

import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/CallBack.dart';
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
      case CacheMode.NO_CACHE:
        //默认没有缓存
        NetworkManager.request(url, params: params, method: httpMethod)
            .then((response) {
          controller.add(new RequestData(
              RequestType.NETWORK, jsonTransformation(response.data)));
        });
        break;
      case CacheMode.REQUEST_FAILED_READ_CACHE:
        //先获取网络,在获取缓存
        NetworkManager.request(url, params: params, method: httpMethod)
            .then((response) {
          if (response == 200) {
            controller.add(new RequestData(
                RequestType.NETWORK, jsonTransformation(response.data)));
          } else {
            CacheManagers.getCache(url, params).then((list) => {
                  if (list != null && list.length > 0)
                    {
                      controller.add(new RequestData(RequestType.CACHE,
                          jsonTransformation(list[0]['value'])))
                    }
                  else
                    {
                      controller.add(new RequestData(
                          RequestType.CACHE, jsonTransformation(null),
                          statusCode: 400))
                    }
                });
          }
        });
        break;
      case CacheMode.FIRST_CACHE_THEN_REQUEST:
        //先获取缓存,在获取网络数据
        CacheManagers.getCache(url, params).then((list) => {
              if (list != null && list.length > 0)
                {
                  controller.add(new RequestData(
                      RequestType.CACHE, jsonTransformation(list[0]['value'])))
                }
              else
                {
                  controller.add(new RequestData(
                      RequestType.CACHE, jsonTransformation(null),
                      statusCode: 400))
                }
            });
        NetworkManager.request(url, params: params, method: httpMethod)
            .then((response) {
          controller.add(new RequestData(
              RequestType.NETWORK, jsonTransformation(response.data)));
        });
        break;
      case CacheMode.DEFAULT:
        //默认没有缓存
        NetworkManager.request(url, params: params, method: httpMethod)
            .then((response) {
          controller.add(new RequestData(
              RequestType.NETWORK, jsonTransformation(response.data)));
        });
        break;
    }

    //使用观察这模式观察数据流
    controller.stream.listen((requestData) {
      switch (requestData.requestType) {
        case RequestType.NETWORK:
          //网络数据
          if (callBack != null) {
            callBack.onNetFinish!(requestData.data);
          }
          break;
        case RequestType.CACHE:
          //缓存数据
          if (callBack != null && callBack.onCacheFinish != null) {
            callBack.onCacheFinish!(requestData.data);
          }
          break;
        case RequestType.UNKOWN:
          //其他来源
          if (callBack != null && callBack.onUnkownFinish != null) {
            callBack.onUnkownFinish!(requestData.data);
          }
          break;
      }
    });
  }
}
