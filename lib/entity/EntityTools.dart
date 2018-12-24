import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/entity/MovieItemEntity.dart';
import 'package:liguang_flutter/entity/MoviePageInfo.dart';

class EntityTools {
  static Future<MovieInfo> getContentFrom(String uri) async {
    var htmlForParse;

    htmlForParse = await http.read(uri);
//  print(htmlForParse);
    var document = parse(htmlForParse);
    Element body = document.body;
    var headers = new List<SearchFactor>();
    var title = new SearchFactor("影片名", body.querySelector('h3').text, null);
    var cover = body.getElementsByClassName('bigImage')[0].attributes['href'];
    headers.add(title);

    var categoryElement = body.getElementsByClassName('col-md-3 info')[0];
    var headerElements =
        categoryElement.querySelectorAll("p:not([class*=header])");
    for (var i = 0; i < headerElements.length; i++) {
      if (headerElements[i].querySelector("span") != null &&
          headerElements[i].getElementsByClassName("genre").length == 0) {
        var split = headerElements[i].text.split(":");
        headers.add(new SearchFactor(split[0].trim(), split[1].trim(), null));
      }
    }
    var labels = categoryElement.querySelectorAll("p.header");
    var otherInfo = categoryElement.querySelectorAll("p");
    for (var i = 0; i < labels.length - 1; i++) {
      var alabel =
          otherInfo[otherInfo.indexOf(labels[i]) + 1].querySelector('a');
      headers.add(new SearchFactor(labels[i].text.replaceAll(":", "").trim(),
          alabel.text, alabel.attributes["href"]));
    }

    var genreElements = categoryElement.getElementsByClassName("genre");
    var genre = new List<SearchFactor>();
    for (Element element in genreElements) {
      genre.add(new SearchFactor("GENERE", element.querySelector("a").text,
          element.querySelector("a").attributes['href']));
    }
    var actresses = new List<SearchFactor>();
    var actressElements = body.getElementsByClassName("avatar-box");
    for (Element element in actressElements) {
      {
        actresses.add(new SearchFactor(
            element.querySelector("img").attributes['src'],
            element.querySelector("span").text,
            element.attributes["href"]));
      }
    }
    var sampleImages = new List<SearchFactor>();

    var imgBox = body.querySelector("#sample-waterfall");
    if (null != imgBox) {
      var imageElements = imgBox.querySelectorAll("a.sample-box");
      for (Element element in imageElements) {
        sampleImages.add(new SearchFactor(
            element.querySelector("img").attributes['src'],
            element.attributes['title'],
            element.attributes['href']));
      }
    }
//    print(headers);
//    print("cover：$cover");
//
//    print("genre：$genre");
//    print("actress：$actresses");
//    print("sampleImages：$sampleImages");
    return new MovieInfo(cover, headers, genre, actresses, sampleImages);
  }

  static Future<List<MovieItemEntity>> getMovieItemsFromWeb(String uri) async {
    var movies = new List<MovieItemEntity>();
    try {
      var htmlForParse;

      htmlForParse = await http.read(uri);
//  print(htmlForParse);
      var document = parse(htmlForParse);
      Element body = document.body;

      var querySelectorAll = body.querySelectorAll('div.item');

      for (Element element in querySelectorAll) {
        if (element.querySelectorAll("date").length == 0) {
          continue;
        }
        String title = element.querySelector('span').text;
        String detailUrl = element.querySelector('a').attributes['href'];
        String coverUrl = element.querySelector('img').attributes['src'];
        String licences = element.querySelectorAll("date")[0].text;

        String publicDate = element.querySelectorAll('date')[1].text;
        bool hot =
            element.getElementsByClassName('glyphicon glyphicon-fire').length >
                0;
        movies.add(new MovieItemEntity(
            title, detailUrl, coverUrl, licences, publicDate, hot));
      }
    } catch (e) {
      print(e.toString());
    }
    return movies;
  }

  static Future<List<List<SearchFactor>>> getGenreFrom() async {
    List<List<SearchFactor>> categories = new List();
    try {
      var htmlForParse;

      htmlForParse = await http.read(Constants.Genre);
//  print(htmlForParse);
      var document = parse(htmlForParse);
      Element body = document.body;

      List<String> mainCategory = body
          .getElementsByClassName("container-fluid pt-10")[0]
          .querySelectorAll('h4')
          .map<String>((element) => element.text)
          .toList();
      categories = body
          .getElementsByClassName("row genre-box")
          .map<List<SearchFactor>>((element) => element
              .querySelectorAll('a')
              .map<SearchFactor>((labels) => new SearchFactor(
                  "label", labels.text, labels.attributes['href']))
              .toList())
          .toList();
//      print(mainCategory);
//      print(categories[0]);
      for (var i = 0; i < categories.length; i++) {
        categories[i][0].factorLabel = mainCategory[i];
      }
    } catch (e) {
      print(e.toString());
    }
    return categories;
  }

  static Future<List<SearchFactor>> getActressFromWeb(String uri) async {
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
}
