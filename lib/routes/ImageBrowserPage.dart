import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageBrowserPage extends StatelessWidget {
  List<String> images;
  int index;

  ImageBrowserPage(this.images, this.index);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
        length: images.length,
        initialIndex: index,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            TabBarView(
                children: images
                    .map<Widget>((url) => FadeInImage.memoryNetwork(
                        fit: BoxFit.contain,
                        placeholder: kTransparentImage,
                        image: url))
                    .toList()),
            TabPageSelector()
          ],
        ));
  }
}
