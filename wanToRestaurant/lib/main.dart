// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// page
import 'test_page1.dart';
import 'test_page2.dart';
import 'test_page3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late PageController _pageController;

  int _selectedIndex = 0;

  // page
  final _pages = [
    TestPage1(),
    TestPage2(),
    TestPage3(),
  ];

  // play
  _forward() async {
    setState(() {
      _animationController.forward();
    });
  }

  // stop
  _stop() async {
    setState(() {
      _animationController.stop();
    });
  }

  // replay
  _reverse() async {
    setState(() {
      _animationController.reverse();
    });
  }

  // init
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = _animationController.drive(Tween(begin: 0.0, end: 2.0 * pi));
    _pageController = PageController(initialPage: _selectedIndex);
  }

  // destory
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _flag = false;
  _click() async {
    setState(() {
      _flag = !_flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _pages));
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Row(children: [
    //       Icon(Icons.create),
    //       Text("Title"),
    //     ]),
    //   ),
    //   body: Center(
    //     child: AnimatedBuilder(
    //       animation: _animation,
    //       builder: (context, _) {
    //         return Transform.rotate(
    //             angle: _animation.value, child: Icon(Icons.cached, size: 100));
    //       },
    //     ),
    //   ),
    //   floatingActionButton:
    //       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //     FloatingActionButton(
    //         onPressed: _forward, child: Icon(Icons.arrow_forward)),
    //     FloatingActionButton(onPressed: _stop, child: Icon(Icons.pause)),
    //     FloatingActionButton(
    //         onPressed: _reverse, child: Icon(Icons.arrow_back)),
    //   ]),
    //   drawer: const Drawer(
    //     child: Center(
    //       child: Text("Drawer"),
    //     ),
    //   ),
    //   endDrawer: const Drawer(
    //     child: Center(
    //       child: Text("endDrawer"),
    //     ),
    //   ),
    // );
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'firebase_options.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // DEBUGバーナー非表示
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//       print('helloworld');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//         actions: <Widget>[
//           // overflow menu
//           PopupMenuButton<Choice>(
//             onSelected: (Choice choice) {
//               // Selected Action
//             },
//             itemBuilder: (BuildContext context) {
//               return loginList.map((Choice choice) {
//                 return PopupMenuItem<Choice>(
//                   value: choice,
//                   child: Text(choice.title),
//                 );
//               }).toList();
//               // return choices.map((Choice choice) {
//               //   return PopupMenuItem<Choice>(
//               //     value: choice,
//               //     child: Text(choice.title),
//               //   );
//               // }).toList();
//             },
//           ),
//         ],
//         // actions: <Widget>[
//         //   IconButton(
//         //     icon: Icon(Icons.settings),
//         //     onPressed: () {
//         //       // Pressed Action
//         //     },
//         //   ),
//         //   IconButton(
//         //     icon: Icon(Icons.menu),
//         //     onPressed: () {
//         //       // Pressed Action
//         //     },
//         //   ),
//         // ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// class Choice {
//   const Choice({required this.title, required this.icon});
//   final String title;
//   final IconData icon;
// }

// const List<Choice> choices = const <Choice>[
//   const Choice(title: 'Settings', icon: Icons.settings),
//   const Choice(title: 'My Location', icon: Icons.my_location),
// ];

// const List<Choice> loginList = const <Choice>[
//   const Choice(title: 'SignIn', icon: Icons.settings),
//   const Choice(title: 'SignUp', icon: Icons.my_location),
// ];

// // const FirebaseSection {
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );
// // }

// // FirebaseAuth.instance
// //     .authStateChanges()
// //     .listen((User? user) {
// // if (user == null) {
// // print('User is currently signed out!');
// // } else {
// // print('User is signed in!');
// // }
// // });
