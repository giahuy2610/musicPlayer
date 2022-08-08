import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  String text;
  Widget switchBtn;

  SettingItem(this.text, this.switchBtn);

  @override
  Widget build(BuildContext context) {
    return Container(child: Row(children: [Text(this.text), this.switchBtn]));
  }
}
