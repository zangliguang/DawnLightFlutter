import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class SliverBarPage extends StatefulWidget {
  String headImgUri =
      "http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=cab5935272f0f736ccf34442623cd96c/aec379310a55b3198a15275849a98226cffc172a.jpg";

  var movieTitle;
  var movieVid;

  SliverBarPage({Key keys, this.headImgUri, this.movieTitle, this.movieVid})
      : super(key: keys);

  @override
  State<StatefulWidget> createState() {
    return new SliverBarPageState();
  }
}

class SliverBarPageState extends State<SliverBarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 210.0,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
                widget.movieTitle == null ? "movieTitle" : widget.movieTitle),
            background: Hero(
              tag: widget.movieVid == null ? "movieVid" : widget.movieVid,
              child: FadeInImage.memoryNetwork(
                image: widget.headImgUri == null
                    ? "http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=cab5935272f0f736ccf34442623cd96c/aec379310a55b3198a15275849a98226cffc172a.jpg"
                    : widget.headImgUri,
                fit: BoxFit.fill,
                placeholder: kTransparentImage,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => new ListTile(
                    title: new Card(
                      elevation: 5.0,
                      child: new Container(
                        alignment: Alignment.center,
                        margin: new EdgeInsets.all(10.0),
                        child: new Text("List $index"),
                      ),
                    ),
                  )),
        ),
      ]),
    );
  }
}
