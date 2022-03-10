import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/flutter/http/bean/BaseBean.dart';
import 'package:flutter_dio_module/com/flutter/http/RxDioConfig.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/CacheManagers.dart';
import 'interceptorss/HttpLogInterceptor.dart';

///单例模式
class NetworkManager {
  factory NetworkManager() => _getInstance();

  static NetworkManager get instance => _getInstance();
  static NetworkManager? _instance;
  late Dio dio;
  late BaseOptions options;
  static List<CancelToken?> _cancelTokenList = [];

  NetworkManager._internal() {
    ///初始化
    dio = Dio()
      ..options = BaseOptions(
          baseUrl: RxDioConfig.intstance.getHost(),
          connectTimeout: 10000,
          receiveTimeout: 1000 * 60 * 60 * 24,
          responseType: ResponseType.plain,
          sendTimeout: 10000,
          headers: {"Content-Type": "application/json"})
      // //拦截器
      ..interceptors.add(HttpLogInterceptor(RxDioConfig.intstance.getDebug()))
      ..interceptors.add(CacheManagers.createCacheInterceptor());
  }

  static NetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkManager._internal();
    }
    return _instance!;
  }

  // 创建全局的拦截器(默认拦截器)
  void setInterceptor(Interceptor? interceptor) {
    List<Interceptor> interceptors = [];
    bool isContainer = interceptors.contains(interceptor); //去重
    if (interceptor != null && !isContainer) {
      //将自定义拦截器加入
      interceptors.add(interceptor);
    }
    bool container = dio.interceptors.contains(interceptors); //去重
    if (!container) {
      dio.interceptors.addAll(interceptors);
    }
  }

// 创建全局的拦截器(默认拦截器)
  void setInterceptors(Interceptors interceptors) {
    // 统一添加到拦截区中
    bool isContainer = dio.interceptors.contains(interceptors); //去重
    if (!isContainer) {
      dio.interceptors.addAll(interceptors);
    }
  }

  //flutter 重载并非重载而是可选参数或者参数默认值
  Future<T> request<T>(
    String url, {
    Map<String, dynamic>? params,
    String host = "",
    Method method = Method.Post,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    //对请求域名做切换
    if (host.isEmpty) {
      //域名为空的时候获取配置接口
      dio.options.baseUrl = RxDioConfig.intstance.getHost();
    } else {
      //域名有值则直接获取域名
      dio.options.baseUrl = host;
    }
    // 返回结果，String类型
    Response<String> response;
    try {
      ///添加cancelToken取消请求头
      cancelToken ??= CancelToken();
      _cancelTokenList.add(cancelToken);
      switch (method) {
        case Method.Post:
          response = await dio.post(url,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case Method.Get:
          response = await dio.get(url,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case Method.Delete:
          response = await dio.delete(url,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case Method.Put:
          response = await dio.put(url,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken);
          break;
      }
      //这里判断是网络状态，并不是业务状态
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.toString());
        BaseBean bean = BaseBean<T>.fromJson(data);
        if (bean.isSuccess()) {
          /// 返回泛型Bean
          return await bean.data as T;
        } else {
          return await Future.error(bean.message);
        }
      } else {
        return await Future.error(
            "服务器错误${response.statusCode},message${response.statusMessage}");
      }
    } on DioError catch (error) {
      return await Future.error(error);
    } finally {
      ///请求完成移除cancelToken
      if (_cancelTokenList.contains(cancelToken)) {
        _cancelTokenList.remove(cancelToken);
      }
    }
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
    _cancelTokenList.forEach((cancelToken) {
      cancel(cancelToken);
    });
    _cancelTokenList.clear();
  }
}
