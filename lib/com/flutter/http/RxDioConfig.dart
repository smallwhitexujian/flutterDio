import 'package:dio/dio.dart';
import 'package:flutter_dio_module/com/flutter/http/NetworkManager.dart';
import 'package:flutter_dio_module/com/flutter/http/interface/BaseApplication.dart';
import 'package:flutter_dio_module/com/flutter/http/utils/CacheManagers.dart';
import 'package:flutter_dio_module/generated/json/base/i_json_convert.dart';
import 'package:flutter_dio_module/generated/json/base/json_convert_content.dart';

class RxDioConfig extends BaseApplication {
  //是否是debug模式
  bool _isDebug = false;

  //是否使用缓存模型
  bool _isUserCache = true;

  String _baseUrl = "";

  IJsonConvert _iJsonConvert = JsonConvert(); //解析关键

  factory RxDioConfig() => _getIntstance();

  static RxDioConfig get intstance => _getIntstance();
  static RxDioConfig? _instance;

  RxDioConfig._create() {
    init();
  }

  static RxDioConfig _getIntstance() {
    if (_instance == null) {
      _instance = new RxDioConfig._create();
    }
    return _instance!;
  }

  void setJsonConvert(IJsonConvert jsonConvert) {
    this._iJsonConvert = jsonConvert;
  }

  IJsonConvert getJsonConvert() {
    return _iJsonConvert;
  }

  void setHost(String host) {
    this._baseUrl = host;
  }

  String getHost() {
    return _baseUrl;
  }

  void setDebugConfig(bool isDebug) {
    this._isDebug = isDebug;
  }

  bool getDebug() {
    return _isDebug;
  }

  void setUserCacheConfig(bool isUserCache) {
    this._isUserCache = isUserCache;
  }

  bool getCahceState() {
    return _isUserCache;
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
    if (_isUserCache) {
      CacheManagers.init(); //初始化缓存数据库
    }
  }

  //程序初始化入口
  initConfig(String baseUrl,
      {bool isDebug = false, bool isUserChache = true, jsonConvert}) {
    this._baseUrl = baseUrl;
    this._isDebug = isDebug;
    this._isUserCache = isUserChache;
    this._iJsonConvert = jsonConvert;
  }
}
