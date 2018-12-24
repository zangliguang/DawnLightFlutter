import 'package:flutter/material.dart';
import 'package:liguang_flutter/entity/EntityTools.dart';
import 'package:liguang_flutter/entity/MoviePageInfo.dart';
import 'package:liguang_flutter/routes/MovieListFromWebPage.dart';
import 'package:liguang_flutter/ui/CommonUI.dart';

class MovieCategoryPage extends StatefulWidget {
  var pageUrl;

  MovieCategoryPage(this.pageUrl);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MovieGenreState();
  }
}

class _MovieGenreState extends State<MovieCategoryPage>
    with AutomaticKeepAliveClientMixin {
  List<List<SearchFactor>> categories;

  @override
  void initState() {
    EntityTools.getGenreFrom(widget.pageUrl).then((result) {
      if (mounted) {
        setState(() {
          categories = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories == null) {
      return UITools.getDefaultLoading();
    }
    return ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Card(
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      categories[index][0].factorLabel,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    new Divider(),
                    new Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 0.5, // gapr between lines
                      children: categories[index]
                          .map<Widget>((searchFactor) => ActionChip(
                                label: new Text(searchFactor.factorName),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (ctx) =>
                                              new MovieListFromWebPage(
                                                  searchFactor.factorUrl,
                                                  searchFactor.factorName)));
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
