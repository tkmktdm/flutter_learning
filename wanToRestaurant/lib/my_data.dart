import 'package:flutter/foundation.dart';

class MyData with ChangeNotifier {
  double _value = 6.5;
  // getter
  double get value => _value;
  // setter
  set value(double value) {
    _value = value;
    // 通知
    notifyListeners();
  }
}
