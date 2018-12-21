import 'package:flutter/material.dart';
import 'package:liguang_flutter/routes/MovieListPage.dart';

class MovieHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MovieHomeState();
}

class _MovieHomeState extends State<MovieHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: SafeArea(
                child: TabBar(
                  tabs: [
                    Tab(text: "影片"),
                    Tab(text: "类别"),
                    Tab(text: "演员"),
                  ],
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
            body: TabBarView(children: <Widget>[
              new MovielistPage(),
              Center(child: Icon(Icons.cloud, size: 64.0, color: Colors.green)),
              Center(child: Icon(Icons.cloud, size: 64.0, color: Colors.blue)),
            ])));
  }
}
