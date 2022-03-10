import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/RxDioConfig.dart';

import 'DatabaseSql.dart';
import 'MD5Utils.dart';

///缓存管理类
class CacheManagers {
  static Future init() async {
    return await DatabaseSql.initDatabase();
  }

  //创建缓存的key
  static String getCacheKayFromPath(
      String? path, Map<String, dynamic>? params) {
    String cacheKey = "";
    if (path != null && path.length > 0) {
      cacheKey = path;
    } else {
      throw new Exception("path is not null!!!");
    }
    if (params != null && params.length > 0) {
      params.forEach((key, value) {
        cacheKey = cacheKey + key + value;
      });
    }
    cacheKey = MD5Utils.generateMD5(cacheKey);
    return cacheKey;
  }

  //获取缓存 查询单条数据 Stream
  static Stream<String> getCache(String? path, Map<String, dynamic>? params) {
    if (!RxDioConfig.intstance.getCahceState()) {
      throw Exception("GlobalConfig isUserCache need ture!!!");
    }

    var transformer = StreamTransformer<String, String>.fromHandlers(
        handleData: (data, sink) {
      sink.add(MD5Utils.decodeBase64(data.toString()));
    });
    return Stream.fromFuture(DatabaseSql.queryHttp(
            DatabaseSql.database, getCacheKayFromPath(path, params)))
        .asBroadcastStream()
        .transform(transformer);
  }

  //保存缓存
  static saveCache(
      String path, Map<String, dynamic>? params, String value) async {
    await DatabaseSql.queryHttp(
            DatabaseSql.database, getCacheKayFromPath(path, params))
        .then((sqData) async {
      if (sqData.isNotEmpty) {
        value = MD5Utils.encodeBase64(value);
        await DatabaseSql.updateHttp(
            DatabaseSql.database, getCacheKayFromPath(path, params), value);
      } else {
        if (value.isNotEmpty) {
          value = MD5Utils.encodeBase64(value);
          await DatabaseSql.insertHttp(
              DatabaseSql.database, getCacheKayFromPath(path, params), value);
        }
      }
    });
  }

  //清楚缓存数据,删除表
  static clearCache() async {
    await DatabaseSql.clearData(DatabaseSql.database)
        .then((value) => {DatabaseSql.initDatabase()});
  }

  static String path = "";
  static Map<String, dynamic>? map;
  //缓存拦截器
  static InterceptorsWrapper createCacheInterceptor() {
    InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      path = options.path;
      if (map != null && map!.isNotEmpty) {
        //没有param的时候是一个空的对象
        map = options.queryParameters;
      } else {
        map = null;
      }
      return handler.next(options);
    }, onError: (DioError e, ErrorInterceptorHandler handler) {
      return handler.next(e);
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      if (RxDioConfig.intstance.getCahceState()) {
        saveCache(path, map, response.data);
      }
      return handler.next(response);
    });
    return interceptorsWrapper;
  }
}
