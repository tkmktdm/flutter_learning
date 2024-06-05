import 'package:riverpod/riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mydata.freezed.dart';

@freezed
class MyData with _$MyData {
  const factory MyData({@Default(0.5) double value}) = _MyData;
}

// Provider Notifier
class MyDataStateNotifier extends StateNotifier<MyData> {
  MyDataStateNotifier() : super(const MyData());

  // 値の書き換えは、 copyWithで別インスタンスにする
  changeState(newValue) {
    state = state.copyWith(value: newValue);
    print('value: ${state.value}, hashCode: ${state.hashCode}');
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class MyData extends StateNotifier<double> {
//   MyData() : super(0.5);
//   void changeState(state) => this.state = state;
// }

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
