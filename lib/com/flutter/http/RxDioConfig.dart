import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/interface/BaseApplication.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/CacheManagers.dart';

class GlobalConfig extends BaseApplication {
  //是否是debug模式
  bool isDebug = false;

  //是否使用缓存模型
  bool isUserCache = true;

  String baseUrl = "";

  factory GlobalConfig() => _getIntstance();

  static GlobalConfig get intstance => _getIntstance();
  static GlobalConfig? _instance;

  GlobalConfig._create() {
    init();
  }

  static GlobalConfig _getIntstance() {
    if (_instance == null) {
      _instance = new GlobalConfig._create();
    }
    return _instance!;
  }

  void setHost(String host) {
    this.baseUrl = host;
  }

  void setDebugConfig(bool isDebug) {
    this.isDebug = isDebug;
  }

  void setUserCacheConfig(bool isUserCache) {
    this.isUserCache = isUserCache;
  }

  /*
   * @param interceptor 拦截器
   */
  void setInterceptor(Interceptor? interceptor) {
    NetworkManager.instance.setInterceptor(interceptor);
  }

  /*
   * @param interceptors 拦截器s
   */
  void setInterceptors(Interceptors interceptors) {
    NetworkManager.instance.setInterceptors(interceptors);
  }

  @override
  init() {
    if (isUserCache) {
      CacheManagers.init(); //初始化缓存数据库
    }
  }

  //程序初始化入口
  initConfig(String baseUrl, {bool isDebug = false, bool isUserChache = true}) {
    this.baseUrl = baseUrl;
    this.isDebug = isDebug;
    this.isUserCache = isUserChache;
  }
}
