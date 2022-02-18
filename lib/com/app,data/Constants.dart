class Constants {
  static final String config = "wenda/comments/14500/json";
  //错误常量
  static final String error_01 = "缓存不存在";

  //默认200为成功
  static final int statusCode = 200;

  static final int statusCode_10000 = 10000;
  static final int statusCode_20000 = 20000;
  static final int statusCode_30000 = 30000;
  //没有缓存
  static final int responseCodeNoCache = statusCode_10000 + 1;
  static final int responseCodeNetworkError = statusCode_10000 + 2;
}
