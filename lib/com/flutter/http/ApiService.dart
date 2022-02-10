import 'dart:async';

import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';

import 'adapter/Method.dart';

class ApiService {
  Stream getResponse<T>(
          String url, Map<String, dynamic>? params, Method method) =>
      Stream.fromFuture(NetworkManager.instance
              .request<T>(url, params: params, method: method))
          .asBroadcastStream();

  Future<T> getFutureResponse<T>(
      String url, Map<String, dynamic>? params, Method method) {
    return NetworkManager.instance
        .request<T>(url, params: params, method: method);
  }
}
