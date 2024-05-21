import 'package:flutter/material.dart';
import 'test_page3.dart';

class TestPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test2"),
      ),
      body: Center(
        child: Container(
            color: Colors.greenAccent,
            child: const Text("進む", style: TextStyle(fontSize: 80))),
      ),
    );
  }
}
