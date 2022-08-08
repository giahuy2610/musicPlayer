import 'package:flutter/material.dart';

class Loader {
  static final Loader appLoader = Loader();
  ValueNotifier<bool> loaderShowingNotifier = ValueNotifier(false);
  ValueNotifier<String> loaderTextNotifier = ValueNotifier('error message');

  void showLoader() {
    print('huy test show search');
    loaderShowingNotifier.value = true;
  }

  void hideLoader() {
    loaderShowingNotifier.value = false;
  }
}
