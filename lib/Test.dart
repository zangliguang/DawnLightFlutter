import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:liguang_flutter/entity/MoviePageInfo.dart';
import 'package:liguang_flutter/entity/MoviePlayDirectly.dart';
import 'package:liguang_flutter/http/HttpUtil.dart';

main() {
  String url = "https://avmoo.xyz/cn";
  String url2 = "https://avmoo.xyz/cn/popular";
//  EntityTools.getContentFrom(url);
//  getGenreFrom(Constants.Genre);
//  getActressFrom(Constants.Actress);

  HttpUtil.getInstance()
      .get(
          "http://api.rekonquer.com/psvs/search.php?kw=%E6%B3%A2%E5%A4%9A%E9%87%8E%E7%BB%93%E8%A1%A3&page=0")
      .then((result) {

    var videos = result['response']['videos'];
    List<MoviePlayDirectly> movieList= List<MoviePlayDirectly>
        .generate(videos.length, (index){
      var obj= videos[index];
      return  MoviePlayDirectly(obj['title'],obj['keyword'],obj['duration']*1.0,obj['preview_url'],obj['vid']);
    });
//    List<MoviePlayDirectly> movieItems = new List();
//    movieItems.addAll(videos);
    print(movieList);
  });
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
