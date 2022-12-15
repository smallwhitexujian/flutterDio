import 'package:flutter_dio_module/lib_dio.dart';

abstract class CacheInterface {
  ///获取cacheKeyFromPath 根据请求地址和参数生成缓存key
  String getCacheKayFromPath(String? path, Map<String, dynamic>? params) {
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

  ///获取缓存
  ///@param path
  ///@param params 指定请求参数
  ///@return 返回Future对象，否则返回null
  Future<String?> getCache(String? path, Map<String, dynamic>? params) async {
    return null;
  }

  ///保存缓存，
  void saveCache(
      String path, Map<String, dynamic>? params, String value) async {}

  ///清楚缓存，默认返回false 操作成功返回true
  Future<bool?> clearCache() async {
    return false;
  }
}
