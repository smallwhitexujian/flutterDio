import 'package:flutter_dio_module/generated/json/base/json_convert_content.dart';
import 'package:flutter_dio_module/com/app,data/config_bean_entity.dart';

ConfigBeanEntity $ConfigBeanEntityFromJson(Map<String, dynamic> json) {
	final ConfigBeanEntity configBeanEntity = ConfigBeanEntity();
	final String? main = jsonConvert.convert<String>(json['main']);
	if (main != null) {
		configBeanEntity.main = main;
	}
	final String? wsurl = jsonConvert.convert<String>(json['wsurl']);
	if (wsurl != null) {
		configBeanEntity.wsurl = wsurl;
	}
	final String? miniMain = jsonConvert.convert<String>(json['miniMain']);
	if (miniMain != null) {
		configBeanEntity.miniMain = miniMain;
	}
	final String? xStatic = jsonConvert.convert<String>(json['static']);
	if (xStatic != null) {
		configBeanEntity.xStatic = xStatic;
	}
	final String? workapi = jsonConvert.convert<String>(json['workapi']);
	if (workapi != null) {
		configBeanEntity.workapi = workapi;
	}
	final String? qyweb = jsonConvert.convert<String>(json['qyweb']);
	if (qyweb != null) {
		configBeanEntity.qyweb = qyweb;
	}
	final String? gurl = jsonConvert.convert<String>(json['gurl']);
	if (gurl != null) {
		configBeanEntity.gurl = gurl;
	}
	final String? tv = jsonConvert.convert<String>(json['tv']);
	if (tv != null) {
		configBeanEntity.tv = tv;
	}
	final String? socket = jsonConvert.convert<String>(json['socket']);
	if (socket != null) {
		configBeanEntity.socket = socket;
	}
	final String? qyimSdkAppId = jsonConvert.convert<String>(json['qyimSdkAppId']);
	if (qyimSdkAppId != null) {
		configBeanEntity.qyimSdkAppId = qyimSdkAppId;
	}
	final String? qyimAccountType = jsonConvert.convert<String>(json['qyimAccountType']);
	if (qyimAccountType != null) {
		configBeanEntity.qyimAccountType = qyimAccountType;
	}
	final String? qyimBigGroupID = jsonConvert.convert<String>(json['qyimBigGroupID']);
	if (qyimBigGroupID != null) {
		configBeanEntity.qyimBigGroupID = qyimBigGroupID;
	}
	final ConfigBeanZhichi? zhichi = jsonConvert.convert<ConfigBeanZhichi>(json['zhichi']);
	if (zhichi != null) {
		configBeanEntity.zhichi = zhichi;
	}
	return configBeanEntity;
}

Map<String, dynamic> $ConfigBeanEntityToJson(ConfigBeanEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
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

ConfigBeanZhichi $ConfigBeanZhichiFromJson(Map<String, dynamic> json) {
	final ConfigBeanZhichi configBeanZhichi = ConfigBeanZhichi();
	final String? sysNum = jsonConvert.convert<String>(json['sysNum']);
	if (sysNum != null) {
		configBeanZhichi.sysNum = sysNum;
	}
	final String? channelFlg = jsonConvert.convert<String>(json['channelFlg']);
	if (channelFlg != null) {
		configBeanZhichi.channelFlg = channelFlg;
	}
	final String? groupId = jsonConvert.convert<String>(json['groupId']);
	if (groupId != null) {
		configBeanZhichi.groupId = groupId;
	}
	final String? appKey = jsonConvert.convert<String>(json['appKey']);
	if (appKey != null) {
		configBeanZhichi.appKey = appKey;
	}
	return configBeanZhichi;
}

Map<String, dynamic> $ConfigBeanZhichiToJson(ConfigBeanZhichi entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['sysNum'] = entity.sysNum;
	data['channelFlg'] = entity.channelFlg;
	data['groupId'] = entity.groupId;
	data['appKey'] = entity.appKey;
	return data;
}