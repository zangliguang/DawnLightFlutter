import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:liguang_flutter/entity/MovieItemEntity.dart';

main() {
  String url = "https://avmoo.xyz/cn";
  String url2 = "https://avmoo.xyz/cn/popular";
//  EntityTools.getContentFrom(url);
  getMoviesFrom("https://avmoo.xyz/cn/series/org/page/2");
}

getMoviesFrom(String uri) async {
  var movies = new List<MovieItemEntity>();
  try {
    var htmlForParse;

    htmlForParse = await http.read(uri);
//  print(htmlForParse);
    var document = parse(htmlForParse);
    Element body = document.body;

    var querySelectorAll = body.querySelectorAll('div.item');
    for (Element element in querySelectorAll) {
      String title = element.querySelector('span').text;
      String detailUrl = element.querySelector('a').attributes['href'];
      String coverUrl = element.querySelector('img').attributes['src'];
      String licences = element.querySelectorAll('date')[0].text;
      String publicDate = element.querySelectorAll('date')[1].text;
      bool hot =
          element.getElementsByClassName('glyphicon glyphicon-fire').length > 0;
      movies.add(new MovieItemEntity(
          title, detailUrl, coverUrl, licences, publicDate, hot));
    }
//    print(movies);
  } catch (e) {
//    print(e.toString());
  }
  print(movies.length);
  return movies;
}
