import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/ToolUtils.dart';
import 'package:liguang_flutter/entity/MoviePlayDirectly.dart';
import 'package:liguang_flutter/http/HttpUtil.dart';
import 'package:liguang_flutter/routes/MovieListFromWebPage.dart';
import 'package:liguang_flutter/routes/webview_flutter.dart';
import 'package:liguang_flutter/ui/CommonUI.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieListPlayDirectly extends StatefulWidget {
  var keyWord;
  bool loadMore = false;
  int page = 0;

  MovieListPlayDirectly(this.keyWord);

  @override
  State<StatefulWidget> createState() {
    return _MovieListPlayDirectlyState();
  }
}

class _MovieListPlayDirectlyState extends State<MovieListPlayDirectly> {
  List<MoviePlayDirectly> movieItems = new List();
  bool loadMore = true;
  ScrollController _scrollController = new ScrollController();
  bool showSearchView = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    _loadMovieList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMovieList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keyWord),
        actions: <Widget>[
          IconButton(
            tooltip: "Search",
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                showSearchView = !showSearchView;
              });
            },
          )
        ],
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    if (movieItems.isEmpty && loadMore) {
      return UITools.getDefaultLoading();
    } else {
      Widget listView = new ListView.builder(
        itemCount: movieItems.length,
        itemBuilder: (context, i) => _renderRow(i),
        controller: _scrollController,
      );

      var children2 = <Widget>[
        listView,
      ];
      if (showSearchView) {
        children2.add(Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "输入关键字",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            onSubmitted: (String val) {
              ToolUtils.getBoolSp("PlayDirectly", false).then((result) {
                if (result) {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (ctx) => new MovieListPlayDirectly(val)));
                } else {
                  ToolUtils.getSp("baseUrl", Constants.MosaicUrl)
                      .then((result) {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (ctx) => new MovieListFromWebPage(
                            result + "search/" + val, val)));
                  });
                }
                setState(() {
                  showSearchView = false;
                });
              });
            },
          ),
        ));
      }
      return Stack(
          alignment: AlignmentDirectional.topCenter, children: children2);
    }
  }

  void _loadMovieList() {
//    print(widget.pageUrl + "/page/" + page.toString());
    if (!loadMore) {
      return;
    }
    print("请求uri：" +
        "${Constants.SearchMovie}${widget.keyWord}" +
        "&page=" +
        "${widget.page}");
    HttpUtil.getInstance()
        .get("${Constants.SearchMovie}${widget.keyWord}" +
            "&page=" +
            "${widget.page}")
        .then((result) {
      var videos = result['response']['videos'];
      print(videos);
      List<MoviePlayDirectly> movieList =
          List<MoviePlayDirectly>.generate(videos.length, (index) {
        var obj = videos[index];
        return MoviePlayDirectly(obj['title'], obj['keyword'],
            (obj['duration']) * 1.0, obj['preview_url'], obj['vid']);
      });
      print(movieList);
      if (mounted) {
        setState(() {
          loadMore = videos.length == result['response']['limit'];
          print(movieList);
          movieItems..addAll(movieList);
        });
      }
    });
  }

  _renderRow(int index) {
    var movie = movieItems[index];
    return Card(
        child: Container(
      padding: const EdgeInsets.all(8.0),
      child: new InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInImage.memoryNetwork(
              image: movie.previewUrl,
              width: 80.0,
              height: 100.0,
              fit: BoxFit.fill,
              placeholder: kTransparentImage,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.body2,
                      maxLines: 1,
                    ),
                    Text(movie.keyword),
                    Text('时长:${(movie.duration / 60).toInt()}min'),
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () {
          if (Platform.isIOS) {
            ToolUtils.launchURL(ToolUtils.getPalyerUrl(movie.vid));
          } else {
//            FlutterWebviewPlugin().launch(ToolUtils.getPalyerUrl(movie.vid));

            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WebViewPlayer(movie.title,ToolUtils.getPalyerUrl(movie.vid))));
          }
        },
      ),
    ));
  }
}
