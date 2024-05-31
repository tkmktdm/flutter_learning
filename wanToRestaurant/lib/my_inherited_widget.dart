import 'package:flutter/material.dart';

class MyInheritedWidget extends InheritedWidget {
  int counter;
  final String message;
  MyInheritedWidget(
      {Key? key,
      required this.counter,
      required this.message,
      required Widget child})
      : super(key: key, child: child);

  static MyInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
          as MyInheritedWidget;
  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) =>
      oldWidget.counter != counter;
}
