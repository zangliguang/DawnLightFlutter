import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liguang_flutter/entity/EntityTools.dart';
import 'package:liguang_flutter/entity/MovieItemEntity.dart';
import 'package:liguang_flutter/routes/MovieInfoPage.dart';
import 'package:liguang_flutter/ui/CommonUI.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieListFromWebPage extends StatefulWidget {
  var pageUrl;
  var title;

  MovieListFromWebPage(this.pageUrl, this.title);

  @override
  State<StatefulWidget> createState() => _MovieListFromWebState();
}

class _MovieListFromWebState extends State<MovieListFromWebPage>
    with AutomaticKeepAliveClientMixin {
  List<MovieItemEntity> movieItems = new List();
  int page = 1;
  bool loadMore = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    if (movieItems.length == 0) {
      _loadMovieList();
    }

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
      appBar: widget.title == null
          ? null
          : AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                IconButton(
                  tooltip: "Search",
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("点击了搜索")));
                  },
                )
              ],
            ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    if (movieItems.isEmpty) {
      return UITools.getDefaultLoading();
    } else {
      Widget listView = new ListView.builder(
        itemCount: movieItems.length,
        itemBuilder: (context, i) => _renderRow(i),
        controller: _scrollController,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void _loadMovieList() {
//    print(widget.pageUrl + "/page/" + page.toString());
    if (!loadMore) {
      return;
    }
    EntityTools.getMovieItemsFromWeb(
            widget.pageUrl + "/page/" + page.toString())
        .then((moviesResult) {
      loadMore = moviesResult.length > 0;
      if (mounted) {
        setState(() {
          this.movieItems.addAll(moviesResult);
          this.page = page + 1;
        });
      }
    });
  }

  Future<void> _pullToRefresh() async {
    setState(() {
      this.movieItems.clear();
      this.page = 1;
      this.loadMore = true;
    });
    _loadMovieList();
  }

  Widget _renderRow(int index) {
    var movie = movieItems[index];
    return Card(
        child: Container(
      padding: const EdgeInsets.all(8.0),
      child: new InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: movie.title,
                child: FadeInImage.memoryNetwork(
                  image: movie.coverUrl,
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
                      movie.title,
                      style: Theme.of(context).textTheme.body2,
                      maxLines: 1,
                    ),
                    Text('车牌:${movie.licences}'),
                    Text('年份:${movie.publicDate}'),
                    Opacity(
                      opacity: movie.hot ? 1.0 : 0.0,
                      child: Icon(Icons.star, size: 24.0, color: Colors.red),
                    ),
//              Icon(movie.hot ? Icons.star : Icons.star_border,
//                  size: 24.0, color: Colors.red),
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (ctx) => new MovieInfoPage(
                  movieVid: '"',
                  pageUrl: movie.detailUrl,
                  movieTitle: movie.title)));
        },
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
