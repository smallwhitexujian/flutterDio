import 'dart:async';

import '../RxDioConfig.dart';
import '../utils/DatabaseSql.dart';
import '../utils/MD5Utils.dart';
import 'CacheInterface.dart';

/// 数据库本地缓存sqlite
class CacheSQLImpL extends CacheInterface {
  DatabaseSql? databaseSql;

  CacheSQLImpL(DatabaseSql? databaseSql) {
    this.databaseSql = databaseSql;
  }

  @override
  Future<bool?> clearCache() async {
    return await databaseSql?.clearData(databaseSql?.database).then((value) {
      databaseSql?.initDatabase();
      return true;
    });
  }

  @override
  Future<String?> getCache(String? path, Map<String, dynamic>? params) async {
    if (RxDioConfig.instance.getCacheState()) {
      final databaseSql = this.databaseSql;
      if (databaseSql != null) {
        var data = await databaseSql.queryHttp(
            databaseSql.database, getCacheKayFromPath(path, params));
        data = MD5Utils.decodeBase64(data.toString());
        return data;
      }
    }
    return null;
  }

  @override
  void saveCache(
      String path, Map<String, dynamic>? params, String value) async {
    if (!RxDioConfig.instance.getCacheState()) {
      return null;
    }
    await databaseSql
        ?.queryHttp(databaseSql?.database, getCacheKayFromPath(path, params))
        .then((sqData) async {
      if (sqData != null) {
        if (sqData.isNotEmpty) {
          value = MD5Utils.encodeBase64(value);
          await databaseSql?.updateHttp(
              databaseSql?.database, getCacheKayFromPath(path, params), value);
        } else {
          if (value.isNotEmpty) {
            value = MD5Utils.encodeBase64(value);
            await databaseSql?.insertHttp(databaseSql?.database,
                getCacheKayFromPath(path, params), value);
          }
        }
      }
    });
  }
}
