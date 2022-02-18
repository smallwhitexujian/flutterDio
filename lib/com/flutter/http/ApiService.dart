import 'dart:async';

import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';

import 'adapter/Method.dart';

class ApiService {
  Stream getResponse<T>(String url, Map<String, dynamic>? params, Method method,
          {String host = ""}) =>
      Stream.fromFuture(NetworkManager.instance
              .request<T>(url, params: params, method: method, host: host))
          .asBroadcastStream();

  Future<T> getFutureResponse<T>(
      String url, Map<String, dynamic>? params, Method method,
      {String host = ""}) {
    return NetworkManager.instance
        .request<T>(url, params: params, method: method, host: host);
  }
}
