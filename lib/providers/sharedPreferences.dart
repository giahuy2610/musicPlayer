import 'package:shared_preferences/shared_preferences.dart';

// Obtain shared preferences.
class A {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
}

// Save an integer value to 'counter' key.
