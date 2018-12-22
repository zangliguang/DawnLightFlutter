import 'package:flutter/material.dart';

class UITools{
  static Container getDefaultLoading() {
    return new Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            image: new DecorationImage(
                image: new NetworkImage(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1545498091239&di=d2c93953fa17c8beb1890c9918f407e2&imgtype=0&src=http%3A%2F%2Fa.vpimg2.com%2Fupload%2Fmerchandise%2F104040%2FINSTY-Y9000-2.jpg'))),
        child: new Center(
          // CircularProgressIndicator是一个圆形的Loading进度条
          child: new CircularProgressIndicator(),
        ));
  }
}