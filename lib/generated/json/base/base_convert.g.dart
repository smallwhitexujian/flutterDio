import 'package:flutter_dio_module/com/flutter/http/bean/BaseBean.dart';

BaseConvert baseConvert = BaseConvert();

class BaseConvert {
  ///解析
  static BaseBean<T> $BaseResultFromJson<T>(
    Map<String, dynamic> json,
    T? Function(Object? json) fromJsonAsT,
  ) {
    if (json['data'] != null && json['data'] != 'null') {
      return BaseBean<T>(
        data: fromJsonAsT(json['data']),
        code: (json['code'] ?? json['errorCode']) as int,
        message: (json['message'] ?? json['errorMsg']) as String,
      );
    } else {
      return BaseBean<T>(
        code: (json['code'] ?? json['errorCode']) as int,
        message: (json['message'] ?? json['errorMsg']) as String,
      );
    }
  }

  ///加密
  static Map<String, dynamic> $BaseResultToJson<T>(
    BaseBean<T> instance,
    Object? Function(T? value) toJsonT,
  ) {
    if (instance.data != null) {
      return <String, dynamic>{
        'code': instance.code,
        'message': instance.message,
        'data': toJsonT(instance.data),
      };
    } else {
      return <String, dynamic>{
        'code': instance.code,
        'message': instance.message,
      };
    }
  }
}
