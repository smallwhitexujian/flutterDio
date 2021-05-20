import 'dart:collection';

import 'package:dio/dio.dart';

class ApiService {
  static HashMap<String, ApiProxy> api = new HashMap();
}

class ApiProxy {
  late Dio dio;

  ApiProxy(Dio dio) {
    this.dio = dio;
  }

}
