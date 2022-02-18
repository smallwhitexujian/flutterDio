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

  NetworkManager._internal() {
    ///初始化
    dio = Dio()
      ..options = BaseOptions(
          baseUrl: GlobalConfig.intstance.baseUrl,
          connectTimeout: 10000,
          receiveTimeout: 1000 * 60 * 60 * 24,
          responseType: ResponseType.plain,
          sendTimeout: 10000,
          headers: {"Content-Type": "application/json"})
      // //拦截器
      ..interceptors.add(HttpLogInterceptor(GlobalConfig.intstance.isDebug))
      ..interceptors.add(CacheManagers.createCacheInterceptor());
  }

  static NetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkManager._internal();
    }
    return _instance!;
  }

  // 创建全局的拦截器(默认拦截器)
  void setInterceptors(Interceptor? interceptor) {
    List<Interceptor> interceptors = List.empty();
    if (interceptor != null) {
      //将自定义拦截器加入
      interceptors.add(interceptor);
    }
    // 统一添加到拦截区中
    dio.interceptors.addAll(interceptors);
  }

  //flutter 重载并非重载而是可选参数或者参数默认值
  Future<T> request<T>(String url,
      {String host = "",
      Method method = Method.Post,
      Map<String, dynamic>? params}) async {
    //对请求域名做切换
    if (host.isEmpty) {
      //域名为空的时候获取配置接口
      dio.options.baseUrl = GlobalConfig.intstance.baseUrl;
    } else {
      //域名有值则直接获取域名
      dio.options.baseUrl = host;
    }
    // 返回结果，String类型
    Response<String> response;
    try {
      switch (method) {
        case Method.Post:
          response = await dio.post(url, queryParameters: params);
          break;
        case Method.Get:
          response = await dio.get(url, queryParameters: params);
          break;
        case Method.Delete:
          response = await dio.delete(url, queryParameters: params);
          break;
        case Method.Put:
          response = await dio.put(url, queryParameters: params);
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
    }
  }
}
