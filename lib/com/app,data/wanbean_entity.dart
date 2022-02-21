import 'dart:convert';
import 'package:flutter_dio_module/generated/json/base/json_field.dart';
import 'package:flutter_dio_module/generated/json/wanbean_entity.g.dart';

@JsonSerializable()
class WanbeanEntity {
  late int curPage;
  late List<WanbeanDatas> datas;
  late int offset;
  late bool over;
  late int pageCount;
  late int size;
  late int total;

  WanbeanEntity();

  factory WanbeanEntity.fromJson(Map<String, dynamic> json) =>
      $WanbeanEntityFromJson(json);

  Map<String, dynamic> toJson() => $WanbeanEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class WanbeanDatas {
  late int anonymous;
  late int appendForContent;
  late int articleId;
  late bool canEdit;
  late String content;
  late String contentMd;
  late int id;
  late String niceDate;
  late int publishDate;
  late int replyCommentId;
  late List<WanbeanDatasReplyComments> replyComments;
  late int rootCommentId;
  late int status;
  late int toUserId;
  late String toUserName;
  late int userId;
  late String userName;
  late int zan;

  WanbeanDatas();

  factory WanbeanDatas.fromJson(Map<String, dynamic> json) =>
      $WanbeanDatasFromJson(json);

  Map<String, dynamic> toJson() => $WanbeanDatasToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class WanbeanDatasReplyComments {
  late int anonymous;
  late int appendForContent;
  late int articleId;
  late bool canEdit;
  late String content;
  late String contentMd;
  late int id;
  late String niceDate;
  late int publishDate;
  late int replyCommentId;
  late List<dynamic> replyComments;
  late int rootCommentId;
  late int status;
  late int toUserId;
  late String toUserName;
  late int userId;
  late String userName;
  late int zan;

  WanbeanDatasReplyComments();

  factory WanbeanDatasReplyComments.fromJson(Map<String, dynamic> json) =>
      $WanbeanDatasReplyCommentsFromJson(json);

  Map<String, dynamic> toJson() => $WanbeanDatasReplyCommentsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
