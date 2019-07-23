import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:liguang_flutter/ToolUtils.dart';
import 'package:liguang_flutter/constants.dart';
import 'package:liguang_flutter/data/database_helper.dart';
import 'package:liguang_flutter/routes/webview_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieListPage extends StatefulWidget {
  String baseUrl;

  MovieListPage(this.baseUrl);

  @override
  State<StatefulWidget> createState() => _MovieListState();
}

class _MovieListState extends State<MovieListPage> {
  List listData = new List();
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  ScrollController _scrollController = new ScrollController();
  var curPage = 0;
  var tableName = 'mosaic_movie';
  Database db;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    db.close();
  }

  @override
  void initState() {
    tableName = widget.baseUrl == Constants.MosaicUrl
        ? 'mosaic_movie'
        : 'no_mosaic_movie';
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMovieDate(false);
      }
    });
    _loadMovieDate(true);
  }

  Future _loadMovieDate(bool isRefresh) async {
    db = await DatabaseHelper().db;
    var sql =
        "SELECT * FROM $tableName order by publish_date desc limit ${Constants.DefaultPageSize} offset ${isRefresh ? 0 : curPage}";
    print(sql);
    List<Map<String, dynamic>> list = await db.rawQuery(sql);
//    print(list.length);

    setState(() {
      if (isRefresh) {
        listData.clear();
      }
//      print(list);
//      print(listData);
      listData..addAll(list);
      curPage = listData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listData.isEmpty) {
      return new Center(
        // CircularProgressIndicator是一个圆形的Loading进度条
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, i) => _renderRow(i),
        controller: _scrollController,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Future<Null> _pullToRefresh() async {
    _loadMovieDate(true);
//    getNewsList(false);
    return null;
  }

  Widget _renderRow(int index) {
    var movie = listData[index];
    return Card(
        child: Container(
      padding: const EdgeInsets.all(8.0),
      child: new InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInImage.memoryNetwork(
              image: movie["cover"],
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
                      movie["movie_title"],
                      style: Theme.of(context).textTheme.body2,
                      maxLines: 1,
                    ),
                    Text('车牌:${movie["licences"]}'),
                    Text('年份:${movie["publish_date"]}'),
//                    Text(movie["Vid"]),
                    Icon(movie["hot"] == 1 ? Icons.star : Icons.star_border,
                        size: 24.0, color: Colors.red),
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () {
          if (Platform.isIOS) {
            ToolUtils.launchURL(ToolUtils.getPalyerUrl(movie["vid"]));
          } else {
//            FlutterWebviewPlugin().launch(ToolUtils.getPalyerUrl(movie["vid"]));
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WebViewPlayer(movie["licences"],ToolUtils.getPalyerUrl(movie["vid"]))));
          }
        },
      ),
    ));
  }
}
