import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liguang_flutter/routes/MovieHomePage.dart';
import 'package:liguang_flutter/routes/SettingPage.dart';
import 'package:liguang_flutter/routes/SliverBar.dart';

class MyHomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomeRoute>
    with SingleTickerProviderStateMixin {
  int index = 0;
  var _pages = <Widget>[
    MovieHomePage(),
    SliverBarPage(),
    SettingPage(),
  ];

  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//      appBar: AppBar(
//        title: Text("DawnLight"),
//      ),
        body: _pages[this.index],
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
  }

  DefaultTabController _buildDefaultTabController() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: _pages[this.index],
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
  }

  _getBottomNavigationBar() => new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: this.index == 0
                  ? Icon(Icons.movie_filter)
                  : Icon(Icons.movie),
              title: Text("电影")),
          BottomNavigationBarItem(
              icon: this.index == 1
                  ? Icon(Icons.book)
                  : Icon(Icons.bookmark_border),
              title: Text("文字")),
          BottomNavigationBarItem(
              icon: this.index == 2
                  ? Icon(Icons.person)
                  : Icon(Icons.person_outline),
              title: Text("我")),
        ],
        currentIndex: this.index,
        onTap: (int position) {
          setState(() {
            this.index = position;
          });
        },
        type: BottomNavigationBarType.fixed,
        iconSize: 24.0,
      );
}
