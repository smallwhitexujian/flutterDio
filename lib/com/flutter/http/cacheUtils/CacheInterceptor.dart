


import '../RxDioConfig.dart';
import 'CacheInterceptorInterface.dart';

class CacheInterceptor extends CacheInterceptorInterface{
  @override
  saveCache(String path, Map<String, dynamic>? params, String responseData) {
    RxDioConfig.instance.getCacheInterface()?.saveCache(path, params, responseData);
  }
}