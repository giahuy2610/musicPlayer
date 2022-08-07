import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/defaultValue.dart';
import '../../providers/control.dart';

class SettingItem extends StatelessWidget {
  String text;
  Widget switchBtn;

  SettingItem(this.text, this.switchBtn);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(this.text),
          this.switchBtn
        ]
      )
    );
  }
}