import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/flutter/http/bean/BaseBean.dart';
import 'interceptorss/HttpLogInterceptor.dart';
import 'Constants.dart';

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
          baseUrl: Constants.BASE_URL,
          connectTimeout: 10000,
          receiveTimeout: 1000 * 60 * 60 * 24,
          responseType: ResponseType.plain,
          sendTimeout: 10000,
          headers: {"Content-Type": "application/json"})
      // //拦截器
      ..interceptors.add(HttpLogInterceptor());
    // ..interceptors.add(HttpLogInterceptor(GlobalConfig.isDebug))
    // ..interceptors.add(ErrorInterceptor());
  }

  static NetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkManager._internal();
    }
    return _instance!;
  }

  //flutter 重载并非重载而是可选参数或者参数默认值
  static Future<Response> request<T>(String url,
      {Method method = Method.Post,
      Map<String, dynamic>? params,
      Function(T? t)? onSuccess,
      Function(String error)? onError,
      Interceptor? interceptor}) async {
    // 创建全局的拦截器(默认拦截器)
    List<Interceptor> interceptors = List.empty();
    if (interceptor != null) {
      //将自定义拦截器加入
      interceptors.add(interceptor);
    }
    // 统一添加到拦截区中
    NetworkManager.instance.dio.interceptors.addAll(interceptors);
    // 发送请求
    Response response;
    try {
      switch (method) {
        case Method.Post:
          response = await NetworkManager.instance.dio
              .post(url, queryParameters: params);
          break;
        case Method.Get:
          response = await NetworkManager.instance.dio
              .get(url, queryParameters: params);
          break;
        case Method.Delete:
          response = await NetworkManager.instance.dio
              .delete(url, queryParameters: params);
          break;
        case Method.Put:
          response = await NetworkManager.instance.dio
              .put(url, queryParameters: params);
          break;
      }
      return response;
    } on DioError catch (error) {
      return Future.error(error);
    }
  }

  ///flutter 重载并非重载而是可选参数或者参数默认值
  ///默认{int code,T data,String message}
  static Future<T> requestBaseBeanData<T>(String url,
      {Method method = Method.Post,
      Map<String, dynamic>? params,
      Function(T? t)? onSuccess,
      Function(String error)? onError,
      Interceptor? interceptor}) async {
    // 创建全局的拦截器(默认拦截器)
    List<Interceptor> interceptors = List.empty();
    if (interceptor != null) {
      //将自定义拦截器加入
      interceptors.add(interceptor);
      NetworkManager.instance.dio.interceptors.addAll(interceptors);
    }
    // 统一添加到拦截区中
    // 发送请求
    Response response;
    try {
      switch (method) {
        case Method.Post:
          response = await NetworkManager.instance.dio
              .post(url, queryParameters: params);
          break;
        case Method.Get:
          response = await NetworkManager.instance.dio
              .get(url, queryParameters: params);
          break;
        case Method.Delete:
          response = await NetworkManager.instance.dio
              .delete(url, queryParameters: params);
          break;
        case Method.Put:
          response = await NetworkManager.instance.dio
              .put(url, queryParameters: params);
          break;
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.data.toString());
        BaseBean bean = BaseBean<T>.fromJson(data);
        if (bean.code == 200 && onSuccess != null) {
          /// 返回泛型Bean
          await onSuccess(bean.data);
        } else {
          if (onError != null) {
            await onError(bean.message);
          }
        }
        return await Future.value();
      } else {
        return await Future.error(
            "服务器错误${response.statusCode},message${response.statusMessage}");
      }
    } on DioError catch (error) {
      return await Future.error(error);
    }
  }
}
