import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommonSwitch extends StatelessWidget {
  final  bool defValue;
  final  onChanged;

  CommonSwitch(this.defValue, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.android
        ? Switch(
            value: defValue,
            onChanged: onChanged,
          )
        : CupertinoSwitch(
            value: defValue,
            onChanged: onChanged,
          );
  }
}
