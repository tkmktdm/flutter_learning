import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyData extends StateNotifier<double> {
  MyData() : super(0.5);
  void changeState(state) => this.state = state;
}

// class MyData with ChangeNotifier {
//   double _value = 6.5;
//   // getter
//   double get value => _value;
//   // setter
//   set value(double value) {
//     _value = value;
//     // 通知
//     notifyListeners();
//   }
// }
