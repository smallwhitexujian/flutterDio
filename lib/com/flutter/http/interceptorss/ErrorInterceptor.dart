// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';

class ErrorInterceptor extends Interceptor  {
  @override
  Future onError(DioError err) async{
    if (err.response != null && err.response.statusCode != 200) {
      Dio dio = NetworkManager.instance.dio; //获取应用的Dio对象进行锁定  防止后面请求还是未登录状态下请求
      dio.lock();
      print("\n ---------DioError Http---------");
      print(" ---------服务器错误${err.response!.statusCode}---------");
      print(" ---------服务器错误${err.request!.path}---------");
      dio.unlock();
    }
    return super.onError(err);
  }
}
