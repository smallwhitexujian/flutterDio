import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/RxDioConstants.dart';

import 'RxDioConfig.dart';
import 'adapter/Method.dart';
import 'bean/BaseBean.dart';
import 'cacheUtils/CacheInterceptor.dart';

///单例模式
class NetworkManager {
  factory NetworkManager() => _getInstance();

  static NetworkManager get instance => _getInstance();
  static NetworkManager? _instance;
  late Dio _dio;
  BaseOptions? _options;

  ///默认的配置
  BaseOptions defaultOptions = BaseOptions(
    baseUrl: RxDioConfig.instance.getHost(),
    //连接超时
    connectTimeout: 10000,
    //接受超时
    receiveTimeout: 60000,
    responseType: ResponseType.plain,
    //发送消息超时
    sendTimeout: 10000,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "false",
      //该字段可选。它的值是一个布尔值，表示是否允许发送 Cookie。默认情况下，Cookie 不包括在 CORS 请求之中。设为 true，即表示服务器明确许可，Cookie 可以包含在请求中，一起发给服务器。
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS,GET"
    },
  );

  ///可以取消的token
  static List<CancelToken?> _cancelTokenList = [];

  NetworkManager._internal() {
    ///初始化
    _dio = Dio()
      ..options = _options ?? defaultOptions
      // //拦截器
      ..interceptors.add(CacheInterceptor());
    if (RxDioConfig.instance.getDebug()) {
      // 在isDebug模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // 设置代理抓包，调试用
        // client.findProxy = (uri) {
        //   return 'PROXY 192.168.50.154:8888';
        // };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  ///设置自定义的BaseOptions
  setBaseOptions(BaseOptions options) {
    _options = options;
  }

  ///获取dio
  Dio getDio() {
    return _dio;
  }

  static NetworkManager _getInstance() {
    if (_instance == null) {
      _instance = new NetworkManager._internal();
    }
    return _instance!;
  }

  void setAdapter(HttpClientAdapter adapter) {
    _dio.httpClientAdapter = adapter;
  }

  /// 创建全局的拦截器(默认拦截器)
  /// 判断拦截器是否已经加入，已经加入了就不会再次添加拦截器
  void setInterceptor(Interceptor? interceptor) {
    bool container = _dio.interceptors.contains(interceptor); //去重
    if (!container) {
      _dio.interceptors.add(interceptor!);
    }
  }

  /// 创建全局的拦截器(默认拦截器)
  void setInterceptors(Interceptors interceptors) {
    _dio.interceptors.addAll(interceptors);
  }

  ///dio 网络请求 网络请求每个请求配置的优先级最高,其次才是默认配置
  ///[url] 接口地址
  ///[params]参数地址
  ///[host]接口域名
  ///[options] 配置信息
  ///[cancelToken]接口取消token
  Future<T> request<T>(
    String url, {
    Map<String, dynamic>? params,
    String host = "",
    Method method = Method.Post,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    //对请求域名做切换
    if (url.contains("http://") || url.contains("https://")) {
      _dio.options.baseUrl = "";
    } else {
      if (host.isEmpty) {
        //域名为空的时候获取配置接口
        _dio.options.baseUrl = RxDioConfig.instance.getHost();
      } else {
        //域名有值则直接获取域名
        _dio.options.baseUrl = host;
      }
    }
    // 返回结果，String类型
    Response<String> response;
    try {
      ///添加cancelToken取消请求头
      cancelToken ??= CancelToken();
      _cancelTokenList.add(cancelToken);
      switch (method) {
        case Method.Post:
          response = await _dio.post(url,
              queryParameters: params,
              data: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case Method.Get:
          response = await _dio.get(url,
              queryParameters: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case Method.Delete:
          response = await _dio.delete(url,
              queryParameters: params,
              data: params,
              options: options,
              cancelToken: cancelToken);
          break;
        case Method.Put:
          response = await _dio.put(url,
              queryParameters: params,
              data: params,
              options: options,
              cancelToken: cancelToken);
          break;
      }
      //这里判断是网络状态，并不是业务状态
      if (response.statusCode == RxDioConstants.networkStatus) {
        Map<String, dynamic> data = json.decode(response.toString());
        //对象数据类型
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

  ///上传文件 formData post上传
  ///[url] 访问地址
  ///[fromFile] see FormData
  /// FormData.fromMap({'file': await MultipartFile.fromFile('filePath./text2.txt', filename: 'text2.txt')}
  /// FormData.fromMap({'files': [await MultipartFile.fromFile('filePath./text2.txt', filename: 'text2.txt')]}
  ///[onSendProgressCB] 上传进度条回调
  ///[options] dio请求设置可以设置请求头header等'Content-Type': 'multipart/form-data;BaseOptions
  ///[queryParameters] 请求参数，可以作用于带参数上传
  ///e.g await MultipartFile.fromFile(File(filePath), "file"),
  Future<T> upLoadFile<T>(String url, FormData formData,
      {Function(int send, int total)? onSendProgressCB,
      Options? options,
      Map<String, dynamic>? queryParameters}) async {
    var cancelToken = CancelToken();
    try {
      Response<String> response = await _dio.post(url,
          data: formData,
          onSendProgress: onSendProgressCB,
          options: options,
          cancelToken: cancelToken,
          queryParameters: queryParameters);
      if (response.statusCode == RxDioConstants.networkStatus) {
        Map<String, dynamic> data = json.decode(response.toString());
        //对象数据类型
        BaseBean bean = BaseBean<T>.fromJson(data);
        if (bean.isSuccess()) {
          /// 返回泛型Bean
          return await bean.data as T;
        } else {
          return await Future.error(bean.message);
        }
      }
    } on Exception catch (e) {
      return Future.error(e);
    } finally {
      cancelToken.cancel();
    }
    return Future.error(e);
  }

  ///下载文件，
  ///[url] 下载路径的地址
  ///[savePath] 保存路径的地址
  ///[onReceiveProgress] 下载进度回调
  Future<T> downloadFile<T>(String url, savePath,
      {Function(int progress, int total)? onReceiveProgress,
      Options? options,
      Map<String, dynamic>? queryParameters}) async {
    var cancelToken = CancelToken();
    try {
      Response<dynamic> response = await _dio.download(url, savePath,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
          options: options,
          queryParameters: queryParameters);
      return response.statusCode as T;
    } catch (e) {
      return Future.error(e);
    } finally {
      cancelToken.cancel();
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
