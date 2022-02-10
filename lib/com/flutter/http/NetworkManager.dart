import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/CallBack.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/Method.dart';
import 'package:flutter_dio_module/com/flutter/http/bean/BaseBean.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/CacheManagers.dart';
import 'interceptorss/HttpLogInterceptor.dart';
import '../../app,data/Constants.dart';

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
          baseUrl: Constants.baseUrl,
          connectTimeout: 10000,
          receiveTimeout: 1000 * 60 * 60 * 24,
          responseType: ResponseType.plain,
          sendTimeout: 10000,
          headers: {"Content-Type": "application/json"})
      // //拦截器
      ..interceptors.add(HttpLogInterceptor())
      ..interceptors.add(CacheManagers.createCacheInterceptor());
    // ..interceptors.add(HttpLogInterceptor(GlobalConfig.isDebug))
    // ..interceptors.add(ErrorInterceptor())
  }

  static NetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkManager._internal();
    }
    return _instance!;
  }

  //flutter 重载并非重载而是可选参数或者参数默认值
  Future<T> request<T>(String url,
      {Method method = Method.Post,
      CacheMode cacheMode = CacheMode.DEFAULT,
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
    print("自定义拦截器的长度" + interceptors.length.toString());
    // 返回结果，String类型
    Response<String> response;
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
      //这里判断是网络状态，并不是业务状态
      if (response.statusCode == 200) {
        print(response.toString());
        print(response.data.toString());
        Map<String, dynamic> data = json.decode(response.toString());
        BaseBean bean = BaseBean<T>.fromJson(data);
        if (bean.isSuccess() && onSuccess != null) {
          /// 返回泛型Bean
          await onSuccess(bean.data);
        } else {
          if (onError != null) {
            await onError(bean.message);
          }
        }
        return bean.data as T;
      } else {
        return await Future.error(
            "服务器错误${response.statusCode},message${response.statusMessage}");
      }
    } on DioError catch (error) {
      return Future.error(error);
    }
  }
}
