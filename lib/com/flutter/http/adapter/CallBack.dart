typedef NetCallbackFunction<T> = void Function(ResponseData<T>?);

///回调
class CallBack<T> {
  NetCallbackFunction<T>? onNetFinish;

  CallBack({this.onNetFinish});
}

///构造一个Response数据模型，
class ResponseData<T> {
  late ResponseType responseType;
  late int? statusCode;
  late String error;
  late T? data;

  //创建请求对象
  ResponseData(ResponseType responseType, T? data,
      {int? statusCode = 200, String error = ""}) {
    this.responseType = responseType;
    this.statusCode = statusCode;
    this.error = error;
    this.data = data;
  }
}

///请求的模式，是从网络，缓存还是其他类型返回数据
enum ResponseType { NETWORK, CACHE, UNKOWN, ERROR }

///缓存模型设置,设置缓存模型是属于哪一种
enum CacheMode {
  NO_CACHE, //没有缓存
  DEFAULT, //按照HTTP协议的默认缓存规则，例如有304响应头时缓存
  REQUEST_FAILED_READ_CACHE, //先请求网络，判断网络是否可以用，网络可用返回网络数据，网络不可用则返回缓存数据，如果缓存数据没有则返回错误
  FIRST_CACHE_THEN_REQUEST, //先使用缓存，不管是否存在，仍然请求网络
}
