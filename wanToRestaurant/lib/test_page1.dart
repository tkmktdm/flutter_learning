import 'package:flutter/material.dart';

class TestPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("test1")),
        body: Center(
            child: Container(
                color: Colors.redAccent,
                child: Text("test1", style: TextStyle(fontSize: 80)))));
  }
}
