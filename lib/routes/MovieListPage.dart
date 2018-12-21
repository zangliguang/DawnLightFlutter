import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liguang_flutter/constants.dart';
import 'package:liguang_flutter/http/HttpUtil.dart';
import 'package:liguang_flutter/routes/MovieDetailPage.dart';
import 'package:transparent_image/transparent_image.dart';

class MovielistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MovieListState();
}

class _MovieListState extends State<MovielistPage> {
  List listData;

  ScrollController _scrollController = new ScrollController();
  var curPage = 0;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMovieDate(false);
      }
    });
    _loadMovieDate(true);
  }

  void _loadMovieDate(bool isRefresh) {
    HttpUtil.getInstance()
        .get(
            "${Constants.BaseUrl}movie/?start=${isRefresh ? 0 : curPage}&pageSize=${Constants.DefaultPageSize}&mosaic=1")
        .then((result) {
      setState(() {
        print(result);
        if (isRefresh) {
          listData = result["data"];
        } else {
          listData.addAll(result["data"]);
        }
        print("数据个数：" + listData.length.toString());
        curPage = listData.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return new Center(
        // CircularProgressIndicator是一个圆形的Loading进度条
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, i) => renderRow(i),
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

  Widget renderRow(int index) {
    var movie = listData[index];
    return Card(
        child: Container(
      padding: const EdgeInsets.all(8.0),
      child: new InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: movie["Vid"],
                child: FadeInImage.memoryNetwork(
                  image: movie["Cover"],
                  width: 80.0,
                  height: 100.0,
                  fit: BoxFit.fill,
                  placeholder: kTransparentImage,
                )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie["MovieTitle"],
                      style: Theme.of(context).textTheme.body2,
                      maxLines: 1,
                    ),
                    Text('车牌:${movie["Licences"]}'),
                    Text('年份:${movie["PublicDate"]}'),
//                    Text(movie["Vid"]),
                    Icon(movie["Hot"] ? Icons.star : Icons.star_border,
                        size: 24.0, color: Colors.red),
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (ctx) => new MovieDetailPage(
                  movieVid: movie["Vid"],
                  headImgUri: movie["Cover"],
                  movieTitle: movie["MovieTitle"])));
        },
      ),
    ));
  }
}
