import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:provider/provider.dart';

// 言語
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 独自
import 'business_logic.dart';
import 'my_inherited_widget.dart';
import 'my_widget.dart';

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
  var intStream = StreamController<int>();
  var stringStream = StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    Generator(intStream);
    Coordinator(intStream, stringStream);
    Consumers(stringStream);
  }

  @override
  void dispose() {
    super.dispose();
    intStream.close();
    stringStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You have pushed the button this many times"),
            StreamBuilder<String>(
              stream: stringStream.stream,
              initialData: "",
              builder: (context, snapshot) {
                return Text('${snapshot.data}',
                    style: Theme.of(context).textTheme.bodyMedium);
              },
            ),
          ],
        ),
      ),
    );
  }
}
