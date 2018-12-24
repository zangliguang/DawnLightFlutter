import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/ToolUtils.dart';
import 'package:liguang_flutter/entity/EntityTools.dart';
import 'package:liguang_flutter/entity/MoviePageInfo.dart';
import 'package:liguang_flutter/http/HttpUtil.dart';
import 'package:liguang_flutter/routes/ImageBrowserPage.dart';
import 'package:liguang_flutter/routes/MovieListFromWebPage.dart';
import 'package:liguang_flutter/ui/CommonUI.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieInfoPage extends StatefulWidget {
  var pageUrl;
  var movieTitle;
  var movieVid;

  MovieInfoPage({Key keys, this.pageUrl, this.movieTitle, this.movieVid})
      : super(key: keys);

  @override
  State<StatefulWidget> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo movieInfo;

//  String movieVid="246958";
  String movieVid;

  @override
  void initState() {
    _loadMovieInfo(widget.pageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (movieInfo == null) {
      return UITools.getDefaultLoading();
    }
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 210.0,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              movieInfo.header[0].factorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            background: Hero(
                tag: widget.movieVid,
                child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        image: new DecorationImage(
                            image: new NetworkImage(movieInfo.coverUrl))),
                    child: movieVid == null
                        ? null
                        : new Center(
                            child: new InkWell(
                            child: new Icon(
                              Icons.play_circle_outline,
                              size: 100.0,
                              color: Colors.green,
                            ),
                            onTap: () {
                              if (Platform.isIOS) {
                                ToolUtils.launchURL(
                                    ToolUtils.getPalyerUrl(movieVid));
                              } else {
                                FlutterWebviewPlugin()
                                    .launch(ToolUtils.getPalyerUrl(movieVid));
                              }
                            },
                          )))),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(movieInfo.header
              .map<Widget>((searchFactor) => Padding(
//                    padding: new EdgeInsets.all(8.0),
                    padding: new EdgeInsets.only(
                        left: 18.0, top: 8.0, bottom: 8.0, right: 18.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          width: 70.0,
                          child: new Text(
                            searchFactor.factorLabel + ":",
                            softWrap: true,
                          ),
                        ),
                        new Container(
                          child: null == searchFactor.factorUrl
                              ? new Text(
                                  searchFactor.factorName,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                )
                              : new InkWell(
                                  child: new Text(
                                    searchFactor.factorName,
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: new TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (ctx) =>
                                                new MovieListFromWebPage(
                                                    searchFactor.factorUrl,
                                                    searchFactor.factorName)));
                                  },
                                ),
                        )
                      ],
                    ),
                  ))
              .toList()
                ..add(new Padding(
                  padding: new EdgeInsets.only(left: 18.0, right: 18.0),
                  child: new Text(
                    "类别:",
                    style: new TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ))
                ..addAll(<Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(left: 18.0, right: 18.0),
                    child: new Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 0.5, // gapr between lines
                      children: movieInfo.genre
                          .map<Widget>((searchFactor) => ActionChip(
                                label: new Text(searchFactor.factorName),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (ctx) =>
                                              new MovieListFromWebPage(
                                                  searchFactor.factorUrl,
                                                  searchFactor.factorName)));
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ])
                ..add(new Padding(
                  padding:
                      new EdgeInsets.only(left: 18.0, top: 8.0, right: 18.0),
                  child: new Text(
                    "演员:",
                    style: new TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ))
                ..addAll(<Widget>[
                  new Padding(
                    padding:
                        new EdgeInsets.only(left: 18.0, top: 8.0, right: 18.0),
                    child: new Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gapr between lines
                      children: movieInfo.actress
                          .map<Widget>((searchFactor) => InkWell(
                              child: new Column(
                                children: <Widget>[
                                  new FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: searchFactor.factorLabel),
                                  new Text(searchFactor.factorName)
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (ctx) =>
                                            new MovieListFromWebPage(
                                                searchFactor.factorUrl,
                                                searchFactor.factorName)));
                              }))
                          .toList(),
                    ),
                  ),
                ])
                ..add(new Padding(
                  padding:
                      new EdgeInsets.only(left: 18.0, top: 8.0, right: 18.0),
                  child: new Text(
                    "截图:",
                    style: new TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ))
                ..addAll(<Widget>[
                  new Padding(
                    padding:
                        new EdgeInsets.only(left: 18.0, top: 8.0, right: 18.0),
                    child: new Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gapr between lines
                      children: movieInfo.sampleImages
                          .map<Widget>((searchFactor) => InkWell(
                                child: FadeInImage.memoryNetwork(
                                    fit: BoxFit.fill,
                                    placeholder: kTransparentImage,
                                    image: searchFactor.factorLabel),
                                onTap: () {
                                  List<String> urls = new List();
                                  int initialIndex;
                                  for (var i = 0;
                                      i < movieInfo.sampleImages.length;
                                      i++) {
                                    var url =
                                        movieInfo.sampleImages[i].factorUrl;
                                    if (url == searchFactor.factorUrl) {
                                      initialIndex = i;
                                    }
                                    urls.add(url);
                                  }

                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (ctx) =>
                                              new ImageBrowserPage(
                                                urls,
                                                initialIndex,
                                              )));
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ])),
        ),
      ]),
    );
  }

  void _loadMovieInfo(url) {
    EntityTools.getContentFrom(url).then((movies) {
      if (mounted) {
        setState(() {
          movieInfo = movies;
        });
      }

      HttpUtil.getInstance()
          .get("${Constants.SearchMovie}${movieInfo.header[1].factorName}")
          .then((result) {
        print("请求vid：" + result.toString());
        if (mounted) {
          setState(() {
            movieVid = result['response']['videos'].length == 0
                ? null
                : result['response']['videos'][0]['vid'];
          });
        }
      });
    });
  }
}
