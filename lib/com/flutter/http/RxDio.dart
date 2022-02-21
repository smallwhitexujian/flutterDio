import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_dio_module/com/app,data/Constants.dart';
import 'package:flutter_dio_module/com/flutter/http/ApiService.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/CallBack.dart';
import 'package:flutter_dio_module/com/flutter/http/bean/BaseBean.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/CacheManagers.dart';

///Dart中一切皆对象，函数也是对象。每个对象都有自己的类型，函数的类型是Function，
///typedef就是给Function取个别名，如
typedef Transformation<T> = T? Function(dynamic);

///Rx + dio 网络请求
class RxDio<T> {
  //设置网络请求模型
  Method httpMethod = Method.Post;

  //设置默认缓存
  bool isUserCache = true;

  //请求接口地址
  late String url;

  //请求域名
  String host = "";

  //参数配置
  late Map<String, dynamic>? params;

  //设置缓存模型
  CacheMode cacheMode = CacheMode.NO_CACHE;

  //json解析
  Transformation<T> transformation = (data) {
    if (data == null) {
      return null;
    }
    return data;
  };

  void setRequestMethod(Method method) {
    this.httpMethod = method;
  }

  void setUrl(String url) {
    this.url = url;
  }

  void setHost(String host) {
    this.host = host;
  }

  void setParams(Map<String, dynamic>? params) {
    this.params = params;
  }

  void setCacheMode(CacheMode cacheMode) {
    this.cacheMode = cacheMode;
  }

  //可以对数据流进行处理,比如包装一层或者修改其中数值等操作
  void setTransFrom(Transformation<T> transformation) {
    this.transformation = transformation;
  }

  RxDio() : super();

  //网络请求以及数据流程控制
  Stream<ResponseData<T>> streams() async* {
    //创建Stream监听,使用Controller的时候一定要close 否者会报错
    StreamController<ResponseData<T>> controller =
        new StreamController<ResponseData<T>>();
    //网络条件判断
    var connectivityResult = await (Connectivity().checkConnectivity());
    //判断缓存模型没有缓存
    switch (cacheMode) {
      case CacheMode.DEFAULT:
      case CacheMode.NO_CACHE:
        //默认没有缓存
        ApiService().getResponse<T>(url, params, httpMethod, host: host).listen(
            (data) {
          controller.add(new ResponseData(
              ResponseType.NETWORK, transformation(data as T)));
        }, onError: (error) {
          controller.add(new ResponseData(ResponseType.ERROR, null,
              error: error.toString(),
              statusCode: Constants.responseCodeNetworkError));
        });
        break;
      case CacheMode.REQUEST_FAILED_READ_CACHE:
        //先获取网络,当网络不存在的时候获取缓存数据
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          ApiService()
              .getResponse<T>(url, params, httpMethod, host: host)
              .listen((data) {
            if (data.runtimeType == T) {
              controller.add(new ResponseData(
                  ResponseType.NETWORK, transformation(data as T)));
            }
          }, onError: (error) {
            controller.add(new ResponseData(ResponseType.ERROR, null,
                error: error.toString(),
                statusCode: Constants.responseCodeNetworkError));
          });
        } else {
          CacheManagers.getCache(url, params).listen((event) {
            if (event.isNotEmpty) {
              //存在缓存返回缓存
              Map<String, dynamic> jsonData = json.decode(event);
              BaseBean bean = BaseBean<T>.fromJson(jsonData);
              controller.add(new ResponseData(
                  ResponseType.CACHE, transformation(bean.data)));
            } else {
              //不存在缓存返回错误
              controller.add(ResponseData(ResponseType.CACHE, null,
                  error: Constants.error_01,
                  statusCode: Constants.responseCodeNoCache));
            }
          });
        }
        break;
      case CacheMode.FIRST_CACHE_THEN_REQUEST:
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          //先获取缓存,在获取网络数据
          CacheManagers.getCache(url, params).listen((event) {
            if (event.isNotEmpty) {
              //存在缓存返回缓存
              Map<String, dynamic> jsonData = json.decode(event);
              BaseBean bean = BaseBean<T>.fromJson(jsonData);
              controller.add(new ResponseData(
                  ResponseType.CACHE, transformation(bean.data)));
            }
            ApiService()
                .getResponse<T>(url, params, httpMethod, host: host)
                .listen((data) {
              if (!controller.isClosed) {
                controller.add(new ResponseData(
                    ResponseType.NETWORK, transformation(data as T)));
              }
            }, onError: (error) {
              if (!controller.isClosed) {
                controller.add(new ResponseData(ResponseType.ERROR, null,
                    error: error.toString(),
                    statusCode: Constants.responseCodeNetworkError));
              }
            });
          });
        } else {
          //先获取缓存,在获取网络数据
          CacheManagers.getCache(url, params).listen((event) {
            if (event.isNotEmpty) {
              //存在缓存返回缓存
              Map<String, dynamic> jsonData = json.decode(event);
              BaseBean bean = BaseBean<T>.fromJson(jsonData);
              controller.add(new ResponseData(
                  ResponseType.CACHE, transformation(bean.data)));
            } else {
              //不存在缓存返回错误
              controller.add(ResponseData(ResponseType.CACHE, null,
                  statusCode: Constants.responseCodeNoCache,
                  error: Constants.error_01));
            }
          }, onError: (error) {
            controller.add(new ResponseData(ResponseType.ERROR, null,
                error: error.toString(),
                statusCode: Constants.responseCodeNetworkError));
          });
        }
        break;
    }

    yield* controller.stream;
    controller.close();
  }

  @deprecated //即将过期
  //网络请求以及数据流程控制
  void call(CallBack<T>? callBack) async {
    //创建Stream监听,使用Controller的时候一定要close 否者会报错
    StreamController<ResponseData<T>> controller =
        new StreamController<ResponseData<T>>();
    //网络条件判断
    var connectivityResult = await (Connectivity().checkConnectivity());
    //判断缓存模型没有缓存
    switch (cacheMode) {
      case CacheMode.DEFAULT:
      case CacheMode.NO_CACHE:
        //默认没有缓存
        ApiService().getResponse<T>(url, params, httpMethod, host: host).listen(
            (data) {
          controller.add(new ResponseData(
              ResponseType.NETWORK, transformation(data as T)));
        }, onError: (error) {
          controller.add(new ResponseData(ResponseType.ERROR, null,
              error: error.toString(),
              statusCode: Constants.responseCodeNetworkError));
        });
        break;
      case CacheMode.REQUEST_FAILED_READ_CACHE:
        //先获取网络,当网络不存在的时候获取缓存数据
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          ApiService()
              .getResponse<T>(url, params, httpMethod, host: host)
              .listen((data) {
            if (data.runtimeType == T) {
              controller.add(new ResponseData(
                  ResponseType.NETWORK, transformation(data as T)));
            }
          }, onError: (error) {
            controller.add(new ResponseData(ResponseType.ERROR, null,
                error: error.toString(),
                statusCode: Constants.responseCodeNetworkError));
          });
        } else {
          CacheManagers.getCache(url, params).listen((event) {
            if (event.isNotEmpty) {
              //存在缓存返回缓存
              Map<String, dynamic> jsonData = json.decode(event);
              BaseBean bean = BaseBean<T>.fromJson(jsonData);
              controller.add(new ResponseData(
                  ResponseType.CACHE, transformation(bean.data)));
            } else {
              //不存在缓存返回错误
              controller.add(ResponseData(ResponseType.CACHE, null,
                  error: Constants.error_01,
                  statusCode: Constants.responseCodeNoCache));
            }
          });
        }
        break;
      case CacheMode.FIRST_CACHE_THEN_REQUEST:
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          //先获取缓存,在获取网络数据
          CacheManagers.getCache(url, params).listen((event) {
            if (event.isNotEmpty) {
              //存在缓存返回缓存
              Map<String, dynamic> jsonData = json.decode(event);
              BaseBean bean = BaseBean<T>.fromJson(jsonData);
              controller.add(new ResponseData(
                  ResponseType.CACHE, transformation(bean.data)));
            }
            ApiService()
                .getResponse<T>(url, params, httpMethod, host: host)
                .listen((data) {
              if (!controller.isClosed) {
                controller.add(new ResponseData(
                    ResponseType.NETWORK, transformation(data as T)));
              } else {
                if (callBack != null) {
                  callBack.onNetFinish!(new ResponseData(
                      ResponseType.NETWORK, transformation(data as T)));
                }
              }
            }, onError: (error) {
              if (!controller.isClosed) {
                controller.add(new ResponseData(ResponseType.ERROR, null,
                    error: error.toString(),
                    statusCode: Constants.responseCodeNetworkError));
              } else {
                if (callBack != null) {
                  callBack.onNetFinish!(new ResponseData(
                      ResponseType.ERROR, null,
                      error: error.toString(),
                      statusCode: Constants.responseCodeNetworkError));
                }
              }
            });
          });
        } else {
          //先获取缓存,在获取网络数据
          CacheManagers.getCache(url, params).listen((event) {
            if (event.isNotEmpty) {
              //存在缓存返回缓存
              Map<String, dynamic> jsonData = json.decode(event);
              BaseBean bean = BaseBean<T>.fromJson(jsonData);
              controller.add(new ResponseData(
                  ResponseType.CACHE, transformation(bean.data)));
            } else {
              //不存在缓存返回错误
              controller.add(ResponseData(ResponseType.CACHE, null,
                  statusCode: Constants.responseCodeNoCache,
                  error: Constants.error_01));
            }
          }, onError: (error) {
            controller.add(new ResponseData(ResponseType.ERROR, null,
                error: error.toString(),
                statusCode: Constants.responseCodeNetworkError));
          });
        }
        break;
    }
    //使用观察这模式观察数据流
    controller.stream.listen((requestData) {
      if (callBack != null) {
        callBack.onNetFinish!(requestData);
      }
      controller.close(); //这一行表示关闭这个监听
    });
  }
}
