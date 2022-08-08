import 'package:flutter/material.dart';
import '../providers/control.dart';

class PrimaryMode {}

class DarkMode {}

class DefaultValue {
  static var screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static var screenHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static var deviceLanguage = 'en';
  static Color backgroundColorDefault = Colors.lightBlueAccent;
  static Color backgroundColorDefaultDark = Colors.grey;
  static Color backgroundColorDiscoveryScreen = Colors.blue[100]!;
  static Color backgroundColorPlayer = Colors.white;
  static Color colorRangePlayer = Colors.black12;

  static var songCoverWidth = DefaultValue.screenWidth * 0.35;
  static var songCoverHeight = DefaultValue.screenWidth * 0.35;

  static var drawerWidth = DefaultValue.screenWidth * 0.7;
}
