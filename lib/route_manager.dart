import 'package:flutter/widgets.dart';
import 'routes//home.dart';

Map<String, WidgetBuilder> getRouteTable() {
  Map<String, WidgetBuilder> routingTable = <String, WidgetBuilder>{
  Navigator.defaultRouteName:(context)=>MyHomeRoute()
  };
  return routingTable;
}
