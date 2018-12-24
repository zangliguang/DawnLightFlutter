import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/entity/MoviePageInfo.dart';

main() {
  String url = "https://avmoo.xyz/cn";
  String url2 = "https://avmoo.xyz/cn/popular";
//  EntityTools.getContentFrom(url);
//  getGenreFrom(Constants.Genre);
  getActressFrom(Constants.Actress);
}

getActressFrom(String uri) async {
  List<SearchFactor> results = new List();
  try {
    var htmlForParse;

    htmlForParse = await http.read(uri);
    var document = parse(htmlForParse);
    print(document.body.getElementsByClassName("avatar-box text-center"));
    results = document.body
        .getElementsByClassName("avatar-box text-center")
        .map<SearchFactor>((element) {
      return new SearchFactor(element.querySelector('img').attributes['src'],
          element.querySelector('span').text, element.attributes['href']);
    }).toList();
  } catch (e) {
    print(e.toString());
  }
  return results;
}
