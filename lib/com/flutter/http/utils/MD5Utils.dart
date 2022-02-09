import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class MD5Utils {
  // md5 加密
  static String generateMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }

  /*
  * uri解密
  */
  static String decoderURL(String uri) {
    return Uri.decodeFull(uri);
  }

  /*
  * uri加密
  */
  static String encoderURL(String uri) {
    return Uri.encodeFull(uri);
  }
}
