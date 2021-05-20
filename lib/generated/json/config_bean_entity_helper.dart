import 'package:flutter_dio_module/com/flutter/http/bean/config_bean_entity.dart';

configBeanEntityFromJson(ConfigBeanEntity data, Map<String, dynamic> json) {
	if (json['main'] != null) {
		data.main = json['main'].toString();
	}
	if (json['wsurl'] != null) {
		data.wsurl = json['wsurl'].toString();
	}
	if (json['miniMain'] != null) {
		data.miniMain = json['miniMain'].toString();
	}
	if (json['static'] != null) {
		data.xStatic = json['static'].toString();
	}
	if (json['workapi'] != null) {
		data.workapi = json['workapi'].toString();
	}
	if (json['qyweb'] != null) {
		data.qyweb = json['qyweb'].toString();
	}
	if (json['gurl'] != null) {
		data.gurl = json['gurl'].toString();
	}
	if (json['tv'] != null) {
		data.tv = json['tv'].toString();
	}
	if (json['socket'] != null) {
		data.socket = json['socket'].toString();
	}
	if (json['qyimSdkAppId'] != null) {
		data.qyimSdkAppId = json['qyimSdkAppId'].toString();
	}
	if (json['qyimAccountType'] != null) {
		data.qyimAccountType = json['qyimAccountType'].toString();
	}
	if (json['qyimBigGroupID'] != null) {
		data.qyimBigGroupID = json['qyimBigGroupID'].toString();
	}
	if (json['zhichi'] != null) {
		data.zhichi = ConfigBeanZhichi().fromJson(json['zhichi']);
	}
	return data;
}

Map<String, dynamic> configBeanEntityToJson(ConfigBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['main'] = entity.main;
	data['wsurl'] = entity.wsurl;
	data['miniMain'] = entity.miniMain;
	data['static'] = entity.xStatic;
	data['workapi'] = entity.workapi;
	data['qyweb'] = entity.qyweb;
	data['gurl'] = entity.gurl;
	data['tv'] = entity.tv;
	data['socket'] = entity.socket;
	data['qyimSdkAppId'] = entity.qyimSdkAppId;
	data['qyimAccountType'] = entity.qyimAccountType;
	data['qyimBigGroupID'] = entity.qyimBigGroupID;
	data['zhichi'] = entity.zhichi?.toJson();
	return data;
}

configBeanZhichiFromJson(ConfigBeanZhichi data, Map<String, dynamic> json) {
	if (json['sysNum'] != null) {
		data.sysNum = json['sysNum'].toString();
	}
	if (json['channelFlg'] != null) {
		data.channelFlg = json['channelFlg'].toString();
	}
	if (json['groupId'] != null) {
		data.groupId = json['groupId'].toString();
	}
	if (json['appKey'] != null) {
		data.appKey = json['appKey'].toString();
	}
	return data;
}

Map<String, dynamic> configBeanZhichiToJson(ConfigBeanZhichi entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['sysNum'] = entity.sysNum;
	data['channelFlg'] = entity.channelFlg;
	data['groupId'] = entity.groupId;
	data['appKey'] = entity.appKey;
	return data;
}