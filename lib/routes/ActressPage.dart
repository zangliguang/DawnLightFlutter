import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liguang_flutter/entity/EntityTools.dart';
import 'package:liguang_flutter/entity/MoviePageInfo.dart';
import 'package:liguang_flutter/routes/MovieListFromWebPage.dart';
import 'package:liguang_flutter/ui/CommonUI.dart';
import 'package:transparent_image/transparent_image.dart';

class ActressPage extends StatefulWidget {
  var pageUrl;

  ActressPage(this.pageUrl);

  @override
  State<StatefulWidget> createState() => _getActressState();
}

class _getActressState extends State<ActressPage>
    with AutomaticKeepAliveClientMixin {
  List<SearchFactor> actresses = new List();
  int page = 1;
  bool loadMore = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _loadActress(widget.pageUrl);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadActress(widget.pageUrl);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (actresses.length == 0) {
      return UITools.getDefaultLoading();
    }
    return GridView.count(
      crossAxisCount: 3,
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      children: actresses.map<Widget>((searchFactor) {
        return Card(
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeInImage.memoryNetwork(
                  image: searchFactor.factorLabel,
                  fit: BoxFit.fill,
                  width: 80.0,
                  height: 80.0,
                  placeholder: kTransparentImage,
                ),
                Text(
                  searchFactor.factorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (ctx) => new MovieListFromWebPage(
                      searchFactor.factorUrl, searchFactor.factorName)));
            },
          ),
        );
      }).toList(),
    );
  }

  void _loadActress(String url) {
    EntityTools.getActressFromWeb(url + "/page/" + page.toString())
        .then((result) {
      loadMore = result.length > 0;
      if (mounted) {
        setState(() {
          actresses.addAll(result);
          page = page + 1;
        });
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
