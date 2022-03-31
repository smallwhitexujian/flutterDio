
import 'package:flutter_dio_module/lib_dio.dart';

typedef NetCallbackFunction<T> = void Function(ResponseDates<T>?);

///回调
class CallBack<T> {
  NetCallbackFunction<T>? onNetFinish;

  CallBack({this.onNetFinish});
}
