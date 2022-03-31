import 'package:flutter_dio_module/com/app,data/Constants.dart';
import 'package:flutter_dio_module/com/flutter/http/RxDioConfig.dart';
import 'package:flutter_dio_module/generated/json/base/base_convert.g.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseBean<T> {
  T? data;
  int code = -1;
  String message = "";

  BaseBean({this.data, required this.code, required this.message});

  BaseBean.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] != 'null') {
      data =
          RxDioConfig.instance.getJsonConvert().fromJsonAsT<T>(json['data']);
    }
    code = json['code'] ?? json['errorCode'];
    message = json['message'] ?? json['errorMsg'];
  }

  factory BaseBean.fromJsonFactory(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      BaseConvert.$BaseResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJsonFun(Object Function(T? value) toJsonT) =>
      BaseConvert.$BaseResultToJson(this, toJsonT);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }

  //判断接口成功状态，一般情况是0或者200状态 根据业务判断
  bool isSuccess() {
    if (code == Constants.statusCode || code == 0) {
      return true;
    } else {
      return false;
    }
  }
}
