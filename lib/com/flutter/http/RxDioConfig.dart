import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/RxDioConstants.dart';
import 'package:flutter_dio_module/com/flutter/http/cacheUtils/CacheSQLImpl.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/DatabaseSql.dart';
import 'package:flutter_dio_module/lib_dio.dart';

class RxDioConfig {
  //是否是debug模式
  bool _isDebug = false;

  //是否使用缓存模型
  bool _isUserCache = false;

  String _baseUrl = "";

  late IJsonConvert _iJsonConvert; //解析关键

  ///缓存实现
  CacheInterfaces? _cacheInterface;

  factory RxDioConfig() => _getInstance();

  static RxDioConfig get instance => _getInstance();
  static RxDioConfig? _instance;

  RxDioConfig._create();

  static RxDioConfig _getInstance() {
    _instance ??= RxDioConfig._create();
    return _instance!;
  }

  void setJsonConvert(IJsonConvert jsonConvert) {
    _iJsonConvert = jsonConvert;
  }

  IJsonConvert getJsonConvert() {
    return _iJsonConvert;
  }

  void setHost(String host) {
    _baseUrl = host;
  }

  String getHost() {
    return _baseUrl;
  }

  void setDebugConfig(bool isDebug) {
    _isDebug = isDebug;
  }

  bool getDebug() {
    return _isDebug;
  }

  void setUserCacheConfig(bool isUserCache) {
    _isUserCache = isUserCache;
  }

  bool getCacheState() {
    return _isUserCache;
  }

  void setNetworkStatus(int code) {
    RxDioConstants.networkStatus = code;
  }

  void setCacheImpl(CacheInterfaces cacheInterface) {
    _cacheInterface = cacheInterface;
  }

  CacheInterfaces? getCacheInterface() {
    _cacheInterface ??= CacheSQLImpL(DatabaseSql());
    return _cacheInterface;
  }

  ///[Interceptors] interceptors 拦截器
  void setInterceptor(Interceptor? interceptor) {
    NetworkManager.instance.setInterceptor(interceptor);
  }

  ///[Interceptors] interceptors 拦截器s
  void setInterceptors(Interceptors interceptors) {
    NetworkManager.instance.setInterceptors(interceptors);
  }

  ///[cacheInterceptor] 缓存拦截器，实现抽象类CacheInterceptorInterface类
  void setCacheInterceptor(CacheInterceptor cacheInterceptor) {
    setCacheInterceptor(cacheInterceptor);
  }
}
