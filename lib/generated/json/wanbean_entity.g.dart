import 'package:flutter_dio_module/generated/json/base/json_convert_content.dart';
import 'package:flutter_dio_module/com/app,data/wanbean_entity.dart';

WanbeanEntity $WanbeanEntityFromJson(Map<String, dynamic> json) {
	final WanbeanEntity wanbeanEntity = WanbeanEntity();
	final int? curPage = jsonConvert.convert<int>(json['curPage']);
	if (curPage != null) {
		wanbeanEntity.curPage = curPage;
	}
	final List<WanbeanDatas>? datas = jsonConvert.convertListNotNull<WanbeanDatas>(json['datas']);
	if (datas != null) {
		wanbeanEntity.datas = datas;
	}
	final int? offset = jsonConvert.convert<int>(json['offset']);
	if (offset != null) {
		wanbeanEntity.offset = offset;
	}
	final bool? over = jsonConvert.convert<bool>(json['over']);
	if (over != null) {
		wanbeanEntity.over = over;
	}
	final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
	if (pageCount != null) {
		wanbeanEntity.pageCount = pageCount;
	}
	final int? size = jsonConvert.convert<int>(json['size']);
	if (size != null) {
		wanbeanEntity.size = size;
	}
	final int? total = jsonConvert.convert<int>(json['total']);
	if (total != null) {
		wanbeanEntity.total = total;
	}
	return wanbeanEntity;
}

Map<String, dynamic> $WanbeanEntityToJson(WanbeanEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['curPage'] = entity.curPage;
	data['datas'] =  entity.datas.map((v) => v.toJson()).toList();
	data['offset'] = entity.offset;
	data['over'] = entity.over;
	data['pageCount'] = entity.pageCount;
	data['size'] = entity.size;
	data['total'] = entity.total;
	return data;
}

WanbeanDatas $WanbeanDatasFromJson(Map<String, dynamic> json) {
	final WanbeanDatas wanbeanDatas = WanbeanDatas();
	final int? anonymous = jsonConvert.convert<int>(json['anonymous']);
	if (anonymous != null) {
		wanbeanDatas.anonymous = anonymous;
	}
	final int? appendForContent = jsonConvert.convert<int>(json['appendForContent']);
	if (appendForContent != null) {
		wanbeanDatas.appendForContent = appendForContent;
	}
	final int? articleId = jsonConvert.convert<int>(json['articleId']);
	if (articleId != null) {
		wanbeanDatas.articleId = articleId;
	}
	final bool? canEdit = jsonConvert.convert<bool>(json['canEdit']);
	if (canEdit != null) {
		wanbeanDatas.canEdit = canEdit;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		wanbeanDatas.content = content;
	}
	final String? contentMd = jsonConvert.convert<String>(json['contentMd']);
	if (contentMd != null) {
		wanbeanDatas.contentMd = contentMd;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		wanbeanDatas.id = id;
	}
	final String? niceDate = jsonConvert.convert<String>(json['niceDate']);
	if (niceDate != null) {
		wanbeanDatas.niceDate = niceDate;
	}
	final int? publishDate = jsonConvert.convert<int>(json['publishDate']);
	if (publishDate != null) {
		wanbeanDatas.publishDate = publishDate;
	}
	final int? replyCommentId = jsonConvert.convert<int>(json['replyCommentId']);
	if (replyCommentId != null) {
		wanbeanDatas.replyCommentId = replyCommentId;
	}
	final List<WanbeanDatasReplyComments>? replyComments = jsonConvert.convertListNotNull<WanbeanDatasReplyComments>(json['replyComments']);
	if (replyComments != null) {
		wanbeanDatas.replyComments = replyComments;
	}
	final int? rootCommentId = jsonConvert.convert<int>(json['rootCommentId']);
	if (rootCommentId != null) {
		wanbeanDatas.rootCommentId = rootCommentId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		wanbeanDatas.status = status;
	}
	final int? toUserId = jsonConvert.convert<int>(json['toUserId']);
	if (toUserId != null) {
		wanbeanDatas.toUserId = toUserId;
	}
	final String? toUserName = jsonConvert.convert<String>(json['toUserName']);
	if (toUserName != null) {
		wanbeanDatas.toUserName = toUserName;
	}
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		wanbeanDatas.userId = userId;
	}
	final String? userName = jsonConvert.convert<String>(json['userName']);
	if (userName != null) {
		wanbeanDatas.userName = userName;
	}
	final int? zan = jsonConvert.convert<int>(json['zan']);
	if (zan != null) {
		wanbeanDatas.zan = zan;
	}
	return wanbeanDatas;
}

Map<String, dynamic> $WanbeanDatasToJson(WanbeanDatas entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['anonymous'] = entity.anonymous;
	data['appendForContent'] = entity.appendForContent;
	data['articleId'] = entity.articleId;
	data['canEdit'] = entity.canEdit;
	data['content'] = entity.content;
	data['contentMd'] = entity.contentMd;
	data['id'] = entity.id;
	data['niceDate'] = entity.niceDate;
	data['publishDate'] = entity.publishDate;
	data['replyCommentId'] = entity.replyCommentId;
	data['replyComments'] =  entity.replyComments.map((v) => v.toJson()).toList();
	data['rootCommentId'] = entity.rootCommentId;
	data['status'] = entity.status;
	data['toUserId'] = entity.toUserId;
	data['toUserName'] = entity.toUserName;
	data['userId'] = entity.userId;
	data['userName'] = entity.userName;
	data['zan'] = entity.zan;
	return data;
}

WanbeanDatasReplyComments $WanbeanDatasReplyCommentsFromJson(Map<String, dynamic> json) {
	final WanbeanDatasReplyComments wanbeanDatasReplyComments = WanbeanDatasReplyComments();
	final int? anonymous = jsonConvert.convert<int>(json['anonymous']);
	if (anonymous != null) {
		wanbeanDatasReplyComments.anonymous = anonymous;
	}
	final int? appendForContent = jsonConvert.convert<int>(json['appendForContent']);
	if (appendForContent != null) {
		wanbeanDatasReplyComments.appendForContent = appendForContent;
	}
	final int? articleId = jsonConvert.convert<int>(json['articleId']);
	if (articleId != null) {
		wanbeanDatasReplyComments.articleId = articleId;
	}
	final bool? canEdit = jsonConvert.convert<bool>(json['canEdit']);
	if (canEdit != null) {
		wanbeanDatasReplyComments.canEdit = canEdit;
	}
	final String? content = jsonConvert.convert<String>(json['content']);
	if (content != null) {
		wanbeanDatasReplyComments.content = content;
	}
	final String? contentMd = jsonConvert.convert<String>(json['contentMd']);
	if (contentMd != null) {
		wanbeanDatasReplyComments.contentMd = contentMd;
	}
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		wanbeanDatasReplyComments.id = id;
	}
	final String? niceDate = jsonConvert.convert<String>(json['niceDate']);
	if (niceDate != null) {
		wanbeanDatasReplyComments.niceDate = niceDate;
	}
	final int? publishDate = jsonConvert.convert<int>(json['publishDate']);
	if (publishDate != null) {
		wanbeanDatasReplyComments.publishDate = publishDate;
	}
	final int? replyCommentId = jsonConvert.convert<int>(json['replyCommentId']);
	if (replyCommentId != null) {
		wanbeanDatasReplyComments.replyCommentId = replyCommentId;
	}
	final List<dynamic>? replyComments = jsonConvert.convertListNotNull<dynamic>(json['replyComments']);
	if (replyComments != null) {
		wanbeanDatasReplyComments.replyComments = replyComments;
	}
	final int? rootCommentId = jsonConvert.convert<int>(json['rootCommentId']);
	if (rootCommentId != null) {
		wanbeanDatasReplyComments.rootCommentId = rootCommentId;
	}
	final int? status = jsonConvert.convert<int>(json['status']);
	if (status != null) {
		wanbeanDatasReplyComments.status = status;
	}
	final int? toUserId = jsonConvert.convert<int>(json['toUserId']);
	if (toUserId != null) {
		wanbeanDatasReplyComments.toUserId = toUserId;
	}
	final String? toUserName = jsonConvert.convert<String>(json['toUserName']);
	if (toUserName != null) {
		wanbeanDatasReplyComments.toUserName = toUserName;
	}
	final int? userId = jsonConvert.convert<int>(json['userId']);
	if (userId != null) {
		wanbeanDatasReplyComments.userId = userId;
	}
	final String? userName = jsonConvert.convert<String>(json['userName']);
	if (userName != null) {
		wanbeanDatasReplyComments.userName = userName;
	}
	final int? zan = jsonConvert.convert<int>(json['zan']);
	if (zan != null) {
		wanbeanDatasReplyComments.zan = zan;
	}
	return wanbeanDatasReplyComments;
}

Map<String, dynamic> $WanbeanDatasReplyCommentsToJson(WanbeanDatasReplyComments entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['anonymous'] = entity.anonymous;
	data['appendForContent'] = entity.appendForContent;
	data['articleId'] = entity.articleId;
	data['canEdit'] = entity.canEdit;
	data['content'] = entity.content;
	data['contentMd'] = entity.contentMd;
	data['id'] = entity.id;
	data['niceDate'] = entity.niceDate;
	data['publishDate'] = entity.publishDate;
	data['replyCommentId'] = entity.replyCommentId;
	data['replyComments'] =  entity.replyComments;
	data['rootCommentId'] = entity.rootCommentId;
	data['status'] = entity.status;
	data['toUserId'] = entity.toUserId;
	data['toUserName'] = entity.toUserName;
	data['userId'] = entity.userId;
	data['userName'] = entity.userName;
	data['zan'] = entity.zan;
	return data;
}