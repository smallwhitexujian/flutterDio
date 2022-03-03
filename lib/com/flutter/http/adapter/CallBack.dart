import 'ResponseDatas.dart';

typedef NetCallbackFunction<T> = void Function(ResponseDatas<T>?);

///回调
class CallBack<T> {
  NetCallbackFunction<T>? onNetFinish;

  CallBack({this.onNetFinish});
}
