import 'package:flutter_dio_module/generated/json/config_bean_entity.g.dart';

import 'package:flutter_dio_module/generated/json/base/json_field.dart';

//测试样例
@JsonSerializable()
class ConfigBeanEntity {

	ConfigBeanEntity();

	factory ConfigBeanEntity.fromJson(Map<String, dynamic> json) => $ConfigBeanEntityFromJson(json);

	Map<String, dynamic> toJson() => $ConfigBeanEntityToJson(this);

	String main="";
	String wsurl="";
	String miniMain="";
	@JSONField(name: "static")
	String xStatic="";
	String workapi="";
	String qyweb="";
	String gurl="";
	String tv="";
	String socket="";
	String qyimSdkAppId="";
	String qyimAccountType="";
	String qyimBigGroupID="";
	ConfigBeanZhichi? zhichi;
}

@JsonSerializable()
class ConfigBeanZhichi {

	ConfigBeanZhichi();

	factory ConfigBeanZhichi.fromJson(Map<String, dynamic> json) => $ConfigBeanZhichiFromJson(json);

	Map<String, dynamic> toJson() => $ConfigBeanZhichiToJson(this);

	String sysNum="";
	String channelFlg="";
	String groupId="";
	String appKey="";
}
