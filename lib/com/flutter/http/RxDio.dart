import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dio_module/lib_dio.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';

///Dart中一切皆对象，函数也是对象。每个对象都有自己的类型，函数的类型是Function，
///typedef就是给Function取个别名，如
typedef Transformation<T> = T Function(dynamic);

///Rx + dio 网络请求
class RxDio {
  //设置网络请求模型
  Method _httpMethod = Method.Post;

  //设置默认缓存
  bool isUserCache = true;

  //请求接口地址
  String _url = "";

  //请求域名
  String _host = "";

  ///dio 相关配置选项
  Options? _options;

  //参数配置
  Map<String, dynamic>? _params;

  //设置缓存模型
  CacheMode _cacheMode = CacheMode.NO_CACHE;

  //取消缓存
  CancelToken? _cancelToken;

  //json解析
  Transformation _transformation = (data) {
    if (data == null) {
      return null;
    }
    return data;
  };

  void setRequestMethod(Method method) {
    this._httpMethod = method;
  }

  void setUrl(String url) {
    this._url = url;
  }

  void setHost(String host) {
    this._host = host;
  }

  void setParams(Map<String, dynamic>? params) {
    this._params = params;
  }

  void setHttpOptions(Options? options) {
    this._options = options;
  }

  void setCacheMode(CacheMode cacheMode) {
    this._cacheMode = cacheMode;
  }

  //可以对数据流进行处理,比如包装一层或者修改其中数值等操作
  setTransFrom<T>(Transformation<T> transformation) {
    this._transformation = transformation;
  }

  ///这里是单例
  factory RxDio.create() => _getInstance();

  static RxDio get instance => _getInstance();
  static RxDio? _instance;

  static RxDio _getInstance() {
    if (_instance == null) {
      _instance = new RxDio._internal();
    }
    return _instance!;
  }

  ///内部实现类
  RxDio._internal();

  ///实例类
  RxDio();

  //网络请求以及数据流程控制
  Stream<ResponseDates<T>> asStreams<T>() async* {
    //创建Stream监听,使用Controller的时候一定要close 否者会报错
    StreamController<ResponseDates<T>> controller =
        new StreamController<ResponseDates<T>>();
    try {
      if (!RxDioConfig.instance.getCacheState()) {
        _cacheMode = CacheMode.DEFAULT;
      }
      //网络条件判断
      var connectivityResult = await (Connectivity().checkConnectivity());
      //判断缓存模型没有缓存
      switch (_cacheMode) {
        case CacheMode.DEFAULT:
        case CacheMode.NO_CACHE:
          //默认没有缓存
          NetworkManager.instance
              .request<T>(_url,
                  params: _params,
                  method: _httpMethod,
                  host: _host,
                  options: _options,
                  cancelToken: _cancelToken)
              .then((data) {
            controller.add(new ResponseDates<T>(
                ResponseTypes.NETWORK, _transformation(data)));
          }, onError: (error) {
            controller.add(new ResponseDates(ResponseTypes.ERROR, null,
                error: error.toString(),
                statusCode: Constants.responseCodeNetworkError));
          });
          break;
        case CacheMode.REQUEST_FAILED_READ_CACHE:
          //先获取网络,当网络不存在的时候获取缓存数据
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            NetworkManager.instance
                .request<T>(_url,
                    params: _params,
                    method: _httpMethod,
                    host: _host,
                    options: _options,
                    cancelToken: _cancelToken ??= CancelToken())
                .then((data) {
              if (data.runtimeType == T) {
                controller.add(new ResponseDates(
                    ResponseTypes.NETWORK, _transformation(data)));
              }
            }, onError: (error) {
              controller.add(new ResponseDates(ResponseTypes.ERROR, null,
                  error: error.toString(),
                  statusCode: Constants.responseCodeNetworkError));
            });
          } else {
            var cacheData = await RxDioConfig.instance
                .getCacheInterface()
                ?.getCache(_url, _params);
            if (cacheData != null) {
              if (cacheData.isNotEmpty) {
                //存在缓存返回缓存
                Map<String, dynamic> jsonData = json.decode(cacheData);
                BaseBean bean = BaseBean<T>.fromJson(jsonData);
                controller.add(new ResponseDates(
                    ResponseTypes.CACHE, _transformation(bean.data)));
              } else {
                //不存在缓存返回错误
                controller.add(ResponseDates(ResponseTypes.CACHE, null,
                    error: Constants.error_01,
                    statusCode: Constants.responseCodeNoCache));
              }
            }
          }
          break;
        case CacheMode.FIRST_CACHE_THEN_REQUEST:
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            //先获取缓存,在获取网络数据
            var cacheData = await RxDioConfig.instance
                .getCacheInterface()
                ?.getCache(_url, _params);
            if (cacheData != null) {
              if (cacheData.isNotEmpty) {
                //存在缓存返回缓存
                Map<String, dynamic> jsonData = json.decode(cacheData);
                BaseBean bean = BaseBean<T>.fromJson(jsonData);
                controller.add(new ResponseDates(
                    ResponseTypes.CACHE, _transformation(bean.data)));
              }
              NetworkManager.instance
                  .request<T>(_url,
                      params: _params,
                      method: _httpMethod,
                      host: _host,
                      options: _options,
                      cancelToken: _cancelToken)
                  .then((data) {
                if (!controller.isClosed) {
                  controller.add(new ResponseDates(
                      ResponseTypes.NETWORK, _transformation(data)));
                }
              }, onError: (error) {
                if (!controller.isClosed) {
                  controller.add(new ResponseDates(ResponseTypes.ERROR, null,
                      error: error.toString(),
                      statusCode: Constants.responseCodeNetworkError));
                }
              });
            } else {
              //不存在缓存返回错误
              if (!controller.isClosed) {
                controller.add(ResponseDates(ResponseTypes.CACHE, null,
                    statusCode: Constants.responseCodeNoCache,
                    error: Constants.error_01));
              }
            }
            break;
          }
      }
      yield* controller.stream;
      controller.close();
    } on Exception catch (e) {
      print("Exception : $e \n");
    } finally {
      if (_cancelToken != null && _cancelToken!.isCancelled) {
        _cancelToken?.cancel();
      }
    }
  }

  //网络请求以及数据流程控制
  Future<ResponseDates<T>> asFuture<T>() async {
    return await asStreams<T>().first;
  }

  //生命周期结束
  void dispose() {
    RxDio.instance.cancelAll();
  }

  ///取消指定的请求
  void cancel(CancelToken? cancelToken) {
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  ///取消指定的请求
  void cancelList(List<CancelToken>? cancelTokenList) {
    cancelTokenList?.forEach((cancelToken) {
      cancel(cancelToken);
    });
  }

  ///取消所有请求
  void cancelAll() {
    NetworkManager.instance.cancelAll();
  }
}
