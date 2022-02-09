import 'dart:async';

import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/adapter/CallBack.dart';

import 'adapter/Method.dart';

class ApiService {
  Stream getResponse<T>(String url, Map<String, dynamic>? params, Method method,
          {CacheMode cacheMode = CacheMode.DEFAULT}) =>
      Stream.fromFuture(NetworkManager.request<T>(url,
              params: params, method: method, cacheMode: cacheMode))
          .asBroadcastStream();

  Future<T> getFutureResponse<T>(
      String url, Map<String, dynamic>? params, Method method,
      {CacheMode cacheMode = CacheMode.DEFAULT}) {
    return NetworkManager.request<T>(url,
        params: params, method: method, cacheMode: cacheMode);
  }
}
