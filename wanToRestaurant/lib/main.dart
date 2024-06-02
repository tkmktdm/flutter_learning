import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 言語
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 独自
import 'business_logic.dart';
import 'my_inherited_widget.dart';
import 'my_widget.dart';
import 'my_data.dart';
import 'my_slider.dart';

// page
import 'test_page1.dart';
import 'test_page2.dart';
import 'test_page3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // ローカライゼーション設定
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // サポート言語
        supportedLocales: const [
          Locale('ja', ''),
          Locale('en', ''),
        ],
        debugShowCheckedModeBanner: false, // DEBUGバーナー非表示
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          "/test1": (BuildContext context) => TestPage1(),
          "/test2": (BuildContext context) => TestPage2(),
          "/test3": (BuildContext context) => TestPage3(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyData(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Consumer<MyData>(
              builder: (context, mydata, _) => Text(
                    // mydata.value.toStringAsFixed(2),
                    context.select(
                        (MyData mydata) => mydata.value.toStringAsFixed(2)),
                    style: const TextStyle(fontSize: 100),
                  )),
          const MySlider(),
        ]),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Provider<int>.value(
//         value: _counter,
//         child: const Center(
//           child: MyWidget(),
//           // child: Consumer<int>(
//           //     builder: (context, value, _) => Text(
//           //           "consume: $value",
//           //           style: Theme.of(context).textTheme.bodyMedium,
//           //         )),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: _incrementCounter,
//           tooltip: "Increment",
//           child: const Icon(Icons.add)),
//     );
//   }
// }
