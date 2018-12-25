import 'package:flutter/material.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/ToolUtils.dart';
import 'package:liguang_flutter/routes/ActressPage.dart';
import 'package:liguang_flutter/routes/MovieCategoryPage.dart';
import 'package:liguang_flutter/routes/MovieListFromWebPage.dart';
import 'package:liguang_flutter/routes/MovieListPage.dart';
import 'package:liguang_flutter/ui/CommonUI.dart';

class MovieHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHomePage>
    with TickerProviderStateMixin {
  var tabImages;

  int _contentIndex = 0;
  String baseUrl;

  TabController _movieTabController;

  var tabs = [
    Tab(text: "全部"),
    Tab(text: "已发布"),
    Tab(text: "热门"),
    Tab(text: "类别"),
    Tab(text: "演员"),
    Tab(text: "可播放"),
  ];

  @override
  void initState() {
    _movieTabController = TabController(vsync: this, length: 6);
    _movieTabController.addListener(() {
      setState(() {
        _contentIndex = _movieTabController.index;
      });
    });
    ToolUtils.getSp("baseUrl", Constants.MosaicUrl).then((value) {
      setState(() {
        this.baseUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (baseUrl == null) {
      return UITools.getDefaultLoading();
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: TabBar(
            isScrollable: true,
            tabs: tabs,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _movieTabController,
          ),
        ),
      ),
      body: new IndexedStack(
        children: <Widget>[
          MovieListFromWebPage(baseUrl, null),
          MovieListFromWebPage(baseUrl + 'released', null),
          MovieListFromWebPage(baseUrl + "popular", null),
          MovieCategoryPage(baseUrl + "genre"),
          ActressPage(baseUrl + 'actresses'),
          MovieListPage(baseUrl),
        ],
        index: _contentIndex,
      ),
    );
  }
}
