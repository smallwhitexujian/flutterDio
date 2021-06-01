import 'package:flutter_dio_module/generated/json/base/json_convert_content.dart';
import 'package:flutter_dio_module/generated/json/base/json_field.dart';

//测试样例
class ConfigBeanEntity with JsonConvert<ConfigBeanEntity> {
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

class ConfigBeanZhichi with JsonConvert<ConfigBeanZhichi> {
	String sysNum="";
	String channelFlg="";
	String groupId="";
	String appKey="";
}
