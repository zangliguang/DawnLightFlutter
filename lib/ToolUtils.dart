import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static Future<String> getMovieVid(String licences) async {}

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


//  static getReleasedPageUrl() {
//    return getSp("baseUrl",Constants.MosaicUrl);
//  }

  static saveSp(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getSp(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await prefs.getString(key);
    return result == null ? value : result;
  }
}
