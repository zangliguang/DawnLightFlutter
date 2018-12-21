import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class ToolUtils {
  static getPalyerUrl(String vid) {
    int time = (new DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    String originStr = "$vid$time" + "Brynhildr";
    var content = new Utf8Encoder().convert(originStr);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    String encode = hex.encode(digest.bytes);
    String url =
        "http://api.rekonquer.com/psvs/mp4.php?vid=$vid&ts=$time&sign=$encode";

    return url;
  }
}
