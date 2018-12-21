import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liguang_flutter/constants.dart';
import 'package:liguang_flutter/http/HttpUtil.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieDetailPage extends StatefulWidget {
  String headImgUri =
      "http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=cab5935272f0f736ccf34442623cd96c/aec379310a55b3198a15275849a98226cffc172a.jpg";

  var movieTitle;
  var movieVid;

  MovieDetailPage({Key keys, this.headImgUri, this.movieTitle, this.movieVid})
      : super(key: keys);

  @override
  State<StatefulWidget> createState() {
    return new MovieDetailPageState();
  }
}

class MovieDetailPageState extends State<MovieDetailPage> {
  var movieInfo;

  @override
  void initState() {
    _loadMovieInfo(widget.movieTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 210.0,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              widget.movieTitle,
              maxLines: 1,
            ),
            background: Hero(
              tag: widget.movieVid,
              child: FadeInImage.memoryNetwork(
                image: widget.headImgUri,
//                image: movieInfo == null
//                    ? widget.headImgUri
//                    : movieInfo["preview_url"],
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(movieInfo == null
              ? <Widget>[
                  new Center(
                    heightFactor: 10.0,
                    // CircularProgressIndicator是一个圆形的Loading进度条
                    child: new CircularProgressIndicator(),
                  ),
                ]
              : <Widget>[
                  new Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gapr between lines
                    children: movieInfo["keyword"]
                        .split(' ')
                        .map<Widget>((keyword) => ActionChip(
                              label: new Text(keyword),
                              onPressed: () {
                                print(
                                    "If you stand for nothing, Burr, what’ll you fall for?");
                              },
                            ))
                        .toList(),
                  ),
                  Text('时长:${movieInfo["duration"] ~/ 60}分钟'),
                  Text('时长:${movieInfo["duration"] ~/ 60}分钟'),
                  Text('时长:${movieInfo["duration"] ~/ 60}分钟'),

                ]),
        ),
      ]),
    );
  }

  void _loadMovieInfo(movieTitle) {
    HttpUtil.getInstance()
        .get(Constants.SearchMovie + movieTitle)
        .then((result) {
      setState(() {
        movieInfo = result['response']["videos"][0];
      });
    });
  }
}
