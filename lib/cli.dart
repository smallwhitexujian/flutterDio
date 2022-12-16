// import 'package:shelf/shelf_io.dart' as shelf_io;
// import 'package:shelf_proxy/shelf_proxy.dart';

// shelf_proxy: ^1.0.2 导报
//
// void main(List<String> arguments) async {
//   /// 绑定本地端口localhost，61815，转发到真正的服务器中
//   final server = await shelf_io.serve(
//     //设置代理的目标host
//     proxyHandler('https://wanandroid.com/'),
//     'localhost',//代理的地址
//     61815,//代理的端口
//   );
//   //设置请求头允许跨域
//   server.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
//   server.defaultResponseHeaders.add('Access-Control-Allow-Credentials', true);
//   print('Proxying at http://${server.address.host}:${server.port}');
// }