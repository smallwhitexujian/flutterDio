import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/bean/config_bean_entity.dart';
import 'package:rxdart/rxdart.dart';

import 'Constants.dart';
import 'adapter/Method.dart';

class ApiService {
  static HashMap<String, ApiProxy> api = new HashMap();

  Observable post<T>(String url, Map<String, dynamic>? params, Method method) =>
      Observable.fromFuture(NetworkManager.request<T>(Constants.CONFIG,
              params: params, method: method)).asBroadcastStream();
}

class ApiProxy {
  late Dio dio;

  ApiProxy(Dio dio) {
    this.dio = dio;
  }
}
