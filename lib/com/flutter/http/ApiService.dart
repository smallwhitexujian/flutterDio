import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:rxdart/rxdart.dart';

import '../../app,data/Constants.dart';
import 'adapter/Method.dart';

class ApiService {
  Observable post<T>(String url, Map<String, dynamic>? params, Method method) =>
      Observable.fromFuture(NetworkManager.request<T>(Constants.CONFIG,
              params: params, method: method)).asBroadcastStream();
}

