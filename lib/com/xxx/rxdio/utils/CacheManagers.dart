import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/xxx/rxdio/utils/DatabaseSql.dart';
import 'package:flutter_dio_module/com/xxx/rxdio/utils/MD5Utils.dart';

///缓存管理类
class CacheManagers {
  static init() {
    DatabaseSql.initDatabase();
  }

  //创建缓存的key
  static String getCacheKayFromPath(
      String? path, Map<String, dynamic>? params) {
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
    cacheKey = MD5Utils.generate_MD5(cacheKey);
    return cacheKey;
  }

  //获取缓存
  static Future<List<Map<String, dynamic>>> getCache(String? path, Map<String, dynamic>? params) async {
    return DatabaseSql.queryHttp(DatabaseSql.database, getCacheKayFromPath(path, params));
  }

  //保存缓存
  static saveCache(String path, Map<String, dynamic>? params, String value) async {
    DatabaseSql.queryHttp(DatabaseSql.database, getCacheKayFromPath(path, params)).then((list) {
      if (list != null && list.length > 0) {
        DatabaseSql.updateHttp(DatabaseSql.database, getCacheKayFromPath(path, params), value);
      } else {
        DatabaseSql.insertHttp(DatabaseSql.database, getCacheKayFromPath(path, params), value);
      }
    });
  }

  //缓存拦截器
  static InterceptorsWrapper createCacheInterceptor(String path, Map<String, dynamic>? params) {
    InterceptorsWrapper interceptorsWrapper =
        InterceptorsWrapper(onRequest: (RequestOptions options) async {
      return options;
    }, onError: (DioError e) {
      return e;
    }, onResponse: (Response response) {
      saveCache(path, params, response.data);
      return response;
    });
    return interceptorsWrapper;
  }
}
