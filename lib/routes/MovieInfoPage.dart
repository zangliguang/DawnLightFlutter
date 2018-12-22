import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liguang_flutter/ToolUtils.dart';
import 'package:liguang_flutter/entity/EntityTools.dart';
import 'package:liguang_flutter/entity/MoviePageInfo.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MovieInfoPage extends StatefulWidget {
  var pageUrl;
  var movieTitle;
  var movieVid;

  MovieInfoPage({Key keys, this.pageUrl, this.movieTitle, this.movieVid})
      : super(key: keys);

  @override
  State<StatefulWidget> createState() {
    return new MovieInfoPageState();
  }
}

class MovieInfoPageState extends State<MovieInfoPage> {
  MovieInfo movieInfo;

  @override
  void initState() {
    _loadMovieInfo(widget.pageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (movieInfo == null) {
      return new Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              image: new DecorationImage(
                  image: new NetworkImage(
                      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1545498091239&di=d2c93953fa17c8beb1890c9918f407e2&imgtype=0&src=http%3A%2F%2Fa.vpimg2.com%2Fupload%2Fmerchandise%2F104040%2FINSTY-Y9000-2.jpg'))),
          child: new Center(
            // CircularProgressIndicator是一个圆形的Loading进度条
            child: new CircularProgressIndicator(),
          ));
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
              child: new InkWell(
                child: FadeInImage.memoryNetwork(
//                image: movieInfo.coverUrl,
                  image: movieInfo.coverUrl,
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                ),
                onTap: (){
                  FlutterWebviewPlugin().launch(ToolUtils.getPalyerUrl(widget.movieVid));
                },
              ),
            ),
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
                                    print("跳转到：" + searchFactor.factorUrl);
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
                                  print("应该跳转到：${searchFactor.factorUrl}");
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
                                print("跳转到：" + searchFactor.factorUrl);
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
                          .map<Widget>((searchFactor) =>
                              FadeInImage.memoryNetwork(
                                  fit: BoxFit.fill,
                                  placeholder: kTransparentImage,
                                  image: searchFactor.factorLabel))
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
      setState(() {
        movieInfo = movies;
        print("======================");
        print(movieInfo);
        print("======================");
      });
    });
  }
}
