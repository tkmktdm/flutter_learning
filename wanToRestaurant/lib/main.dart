import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// 言語
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 独自
import 'my_data.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const MyContents(),
    );
  }
}

class MyContents extends HookConsumerWidget {
  const MyContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useStateでスライダー値を管理
    final slidevalue = useState<double>(0.5);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          slidevalue.value.toStringAsFixed(2),
          style: const TextStyle(fontSize: 100),
        ),
        Slider(
            value: slidevalue.value,
            onChanged: (value) => slidevalue.value = value),
      ],
    );
  }
}

// import 'dart:async';
// import 'dart:core';
// import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart' as provider;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// // 言語
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // 独自
// // import 'business_logic.dart';
// // import 'my_inherited_widget.dart';
// // import 'my_widget.dart';
// // import 'my_slider.dart';
// import 'my_data.dart';

// // page
// import 'test_page1.dart';
// import 'test_page2.dart';
// import 'test_page3.dart';

// // 1-1 グローバル変数にProviderを定義する
// final _mydataProvider =
//     StateNotifierProvider<MyData, double>((ref) => MyData());

// void main() async {
//   // 1-2 ProviderScopeの設定
//   runApp(
//     const ProviderScope(child: MyApp()),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         // ローカライゼーション設定
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         // サポート言語
//         supportedLocales: const [
//           Locale('ja', ''),
//           Locale('en', ''),
//         ],
//         debugShowCheckedModeBanner: false, // DEBUGバーナー非表示
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const MyHomePage(title: 'Flutter Demo Home Page'),
//         routes: {
//           "/test1": (BuildContext context) => TestPage1(),
//           "/test2": (BuildContext context) => TestPage2(),
//           "/test3": (BuildContext context) => TestPage3(),
//         });
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: const MyContents(),
//     );
//   }
// }

// // HookConsumerWidgetを継承するために切り出し
// class MyContents extends HookConsumerWidget {
//   const MyContents({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     double slidevalue = ref.watch(_mydataProvider);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           slidevalue.toStringAsFixed(2),
//           style: const TextStyle(fontSize: 100),
//         ),
//         Slider(
//             value: slidevalue,
//             onChanged: (value) {
//               ref.read(_mydataProvider.notifier).changeState(value);
//             }),
//       ],
//     );
//   }
// }

// // // riverpodを使用する場合
// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           // 2-1. Text用にConsumerを使う
// //           Consumer(builder: (context, ref, child) {
// //             return Text(
// //               // 2-2. refを用いてstateの値を取り出す
// //               ref.watch(_mydataProvider).toStringAsFixed(2),
// //               style: const TextStyle(fontSize: 100),
// //             );
// //           }),
// //           // 3-1. Slider用にConsumerを使う
// //           Consumer(builder: (context, ref, child) {
// //             return Slider(
// //                 // 3-2. refを用いてstateの値を取り出す
// //                 value: ref.watch(_mydataProvider),
// //                 // 3-3. changeStateで状態を変える
// //                 onChanged: (value) =>
// //                     ref.read(_mydataProvider.notifier).changeState(value));
// //           }),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title)
// //       ),
// //       body: Column(mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         // 2-1 Text用にConsumerを使う
// //         Consumer(builder: (context, ref, child) {
// //           return Text(
// //             // 2-2. refを用いてstateの値を取り出す
// //             ref.watch(_mydataProvider).toStringAsFiexd(2),
// //           );
// //         }),
// //       ]),
// //       ),
// //     );
// //   }
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: Provider<int>.value(
// //         value: _counter,
// //         child: const Center(
// //           child: MyWidget(),
// //           // child: Consumer<int>(
// //           //     builder: (context, value, _) => Text(
// //           //           "consume: $value",
// //           //           style: Theme.of(context).textTheme.bodyMedium,
// //           //         )),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //           onPressed: _incrementCounter,
// //           tooltip: "Increment",
// //           child: const Icon(Icons.add)),
// //     );
// //   }
// // }
