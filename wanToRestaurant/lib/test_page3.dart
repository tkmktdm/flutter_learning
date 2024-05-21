import 'package:flutter/material.dart';

class TestPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test3"),
        ),
        body: Center(
            child: Container(
                color: Colors.blueAccent,
                child: const Text("戻る", style: TextStyle(fontSize: 80)))));
  }
}
