import 'package:flutter/material.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/routes/MovieListFromWebPage.dart';

class MovieHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHomePage> {
  @override
  Widget build(BuildContext context) {
    var tabs = [
      Tab(text: "影片"),
      Tab(text: "已发布"),
      Tab(text: "热门"),
      Tab(text: "类别"),
      Tab(text: "演员"),
    ];
    var children = <Widget>[
//              new MovieListPage(),
      new MovieListFromWebPage(Constants.AllPage, null),
      new MovieListFromWebPage(Constants.ReleasedPage, null),
      new MovieListFromWebPage(Constants.HotPage, null),
      Center(child: Icon(Icons.cloud, size: 64.0, color: Colors.green)),
      Center(child: Icon(Icons.cloud, size: 64.0, color: Colors.blue)),
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: SafeArea(
                child: TabBar(
                  isScrollable:true,
                  tabs: tabs,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
            body: TabBarView(children: children)));
  }
}
