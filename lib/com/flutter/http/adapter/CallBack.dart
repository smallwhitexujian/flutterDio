typedef NetCallbackFunction<T> = void Function(T, RequestType);

///回调
class CallBack<T> {
  NetCallbackFunction<T>? onNetFinish;

  CallBack({this.onNetFinish});
}

///构造一个请求数据模型，
class RequestData<T> {
  late RequestType requestType;
  late int? statusCode;
  late T data;

  //创建请求对象
  RequestData(RequestType requestType, T data, {int? statusCode}) {
    this.requestType = requestType;
    this.statusCode = statusCode;
    this.data = data;
  }
}

///请求的模式，是从网络，缓存还是其他类型返回数据
enum RequestType {
  NETWORK,
  CACHE,
  UNKOWN,
}

///缓存模型设置,设置缓存模型是属于哪一种
enum CacheMode {
  NO_CACHE, //没有缓存
  DEFAULT, //按照HTTP协议的默认缓存规则，例如有304响应头时缓存
  REQUEST_FAILED_READ_CACHE, //先请求网络，如果请求网络失败，则读取缓存，如果读取缓存失败，本次请求失败
  FIRST_CACHE_THEN_REQUEST, //先使用缓存，不管是否存在，仍然请求网络
}
