import 'package:flutter/material.dart';
import 'my_inherited_widget.dart';
import 'package:provider/provider.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = Provider.of<int>(context);
    String message = Provider.of<String>(context)
    return Text("$message\nCount is $count",
        style: Theme.of(context).textTheme.bodyMedium);
    // int count = Provider.of<int>(context);
    // return Text(count.toString(),
    //     style: Theme.of(context).textTheme.bodyMedium);
  }
}
