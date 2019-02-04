import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liguang_flutter/Constants.dart';
import 'package:liguang_flutter/ToolUtils.dart';
import 'package:liguang_flutter/ui/widgets/common_switch.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingState();
  }
}

class _SettingState extends State<SettingPage> {
  bool mosaic = true;
  bool playDirectly = false;

  @override
  void initState() {
    ToolUtils.getSp("baseUrl", Constants.MosaicUrl).then((value) {
      setState(() {
        mosaic = value == Constants.MosaicUrl;
      });
    });

    ToolUtils.getBoolSp("PlayDirectly", false).then((value) {
      setState(() {
        playDirectly = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "影片设置",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.movie_filter,
                    ),
                    title: Text("Mosaic"),
                    trailing: CommonSwitch(
                      mosaic,
                      (val) {
                        ToolUtils.saveSp("baseUrl",
                            val ? Constants.MosaicUrl : Constants.NoMosaicUrl);
                      },
                    )),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.movie_filter,
                    ),
                    title: Text("Play Directly"),
                    trailing: CommonSwitch(
                      playDirectly,
                      (val) {
                        ToolUtils.saveBoolSp("PlayDirectly", val);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
