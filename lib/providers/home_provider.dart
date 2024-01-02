import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void onTap(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
