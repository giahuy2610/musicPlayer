import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/defaultValue.dart';
import '../../providers/control.dart';
import './settingItem.dart';

class Setting extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
        body: Container(
      width: DefaultValue.screenWidth,
      height: DefaultValue.screenHeight * 0.75,
      color: Colors.brown,
      child: ListView(children: [
        SettingItem(
          'Enable dark mode',
          Switch(
              value: context.watch<Control>().isDarkMode_,
              onChanged: (value) {
                context.read<Control>().changeDarkMode(value);
              }),
        ),
        SettingItem(
          'Enable dark mode',
          Switch(
              value: context.watch<Control>().isDarkMode_,
              onChanged: (value) {
                context.read<Control>().changeDarkMode(value);
              }),
        ),
        SettingItem(
          'Enable dark mode',
          Switch(
              value: context.watch<Control>().isDarkMode_,
              onChanged: (value) {
                context.read<Control>().changeDarkMode(value);
              }),
        )
      ]),
    ));
  }
}
