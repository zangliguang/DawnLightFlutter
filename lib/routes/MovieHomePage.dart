import 'package:flutter/material.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/routes/ActressPage.dart';
import 'package:liguang_flutter/routes/MovieCategoryPage.dart';
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
      MovieListFromWebPage(Constants.BaseUrl, null),
      MovieListFromWebPage(Constants.ReleasedPage, null),
      MovieListFromWebPage(Constants.HotPage, null),
      MovieCategoryPage(),
      ActressPage(),
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: SafeArea(
                child: TabBar(
                  isScrollable: true,
                  tabs: tabs,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
            body: TabBarView(children: children)));
  }
}
