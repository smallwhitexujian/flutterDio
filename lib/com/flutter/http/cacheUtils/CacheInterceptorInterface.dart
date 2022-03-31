import 'package:dio/dio.dart';
import 'package:flutter_dio_module/lib_dio.dart';

abstract class CacheInterceptorInterface implements InterceptorsWrapper {
  String path = "";
  Map<String, dynamic>? map;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    path = options.path;
    if (map != null && map!.isNotEmpty) {
      //没有param的时候是一个空的对象
      map = options.queryParameters;
    } else {
      map = null;
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (RxDioConfig.instance.getCacheState()) {
      saveCache(path, map, response.data);
    }
    return handler.next(response);
  }

  saveCache(String path, Map<String, dynamic>? params, String responseData);
}
