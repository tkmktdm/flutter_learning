import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// page
import 'test_page1.dart';
import 'test_page2.dart';
import 'test_page3.dart';

// 通知インスタンスの生成
final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
// バックグラウンドでメッセージを受け取った時のイベント
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  flnp.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher')));
  if (notification == null) {
    return;
  }
  // 通知
  flnp.show(
    notification.hashCode,
    "${notification.title}: バックグラウンド",
    notification.body,
    const NotificationDetails(
        android: AndroidNotificationDetails(
      'channel_id',
      'channel_name',
    )),
  );
}

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // 別コンポーネントのgoogle_mobile_adsを読み込む（広告表示）
  // MobileAds.instance.initialize();
  // カウンターアプリの場合 _MyHomePageStateクラスに以下を追記すると偶数の時に広告バナーが出る
  // if (_counter % 2 != 0) AdBanner(size: AdSize.largeBanner),
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

class _MyHomePageState extends State<MyHomePage> {
  // String _token = '';
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;
  String _installId = '';

  @override
  void initState() {
    super.initState();

    // update_eventをトリガーする
    fiam.triggerEvent('update_event');
    FirebaseMessaging.instance.getToken().then((String? token) {
      // token xxx:yyy のxxxの部分がインストールID
      String installId = token!.split(':')[0];
      setState(() {
        _installId = installId;
      });
      print(installId);
    });

    // // アプリ初期化時に画面にトークン表示
    // _firebaseMessaging.getToken().then((String? token) {
    //   setState(() {
    //     _token = token!;
    //   });
    //   print(token);
    // });
    // // フォアグラウンドでメッセージを受け取った時のイベント
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   flnp.initialize(const InitializationSettings(
    //       android: AndroidInitializationSettings('@mipmap/ic_launcher')));
    //   if (notification == null) {
    //     return;
    //   }
    //   // 通知
    //   flnp.show(
    //     notification.hashCode,
    //     "${notification.title}: フォアグラウンド ",
    //     notification.body,
    //     const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         'channel_id',
    //         'channel_name',
    //       ),
    //     ),
    //   );
    // });
  }

  Image? _img;
  Text? _text;
  // download
  Future<void> _download() async {
    // file download
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef =
        storage.ref().child('DL').child('flutter_dev_logo.png');
    String imageUrl = await imageRef.getDownloadURL();
    Reference textRef = storage.ref('DL/hello.txt');
    var data = await textRef.getData();

    // 画面に反映
    setState(() {
      _img = Image.network(imageUrl);
      _text = Text(ascii.decode(data!));
    });

    // 画像ファイルをローカルに保存
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File("${appDocDir.path}/download-logo.png");
    try {
      await imageRef.writeToFile(downloadToFile);
    } catch (e) {
      print(e);
    }
  }

  // upload処理
  void _upload() async {
    // image_pickerで画像選択
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) return;
    File file = File(pickerFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref('UL/upload-pic.png').putFile(file);
      setState(() {
        _img = null;
        _text = const Text("UploadDone");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ダウンロードしたイメージとテキストを表示
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    FirebaseCrashlytics.instance.log('ExceptionLog');
                    throw Exception("MyException");
                  },
                  child: const Text("Throw Error"),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseCrashlytics.instance.log('CrashLog');
                    FirebaseCrashlytics.instance.crash();
                  },
                  child: const Text("Crash"),
                ),
                Text(_installId),
                // Text(_token),
                if (_img != null) _img!,
                if (_text != null) _text!,
              ]),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: _download,
              child: const Icon(Icons.download_outlined),
            ),
            FloatingActionButton(
              onPressed: _upload,
              child: const Icon(Icons.upload_outlined),
            ),
          ],
        ));
  }
}


// class _MyHomePageState extends State<MyHomePage> {
//   // Googleアカウントの表示名
//   String _displayName = "";
//   static final googleLogin = GoogleSignIn(scopes: [
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ]);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text("Hello $_displayName", style: const TextStyle(fontSize: 50)),
//         TextButton(
//           onPressed: () async {
//             // Google認証
//             GoogleSignInAccount? signinAccount = await googleLogin.signIn();
//             if (signinAccount == null) return;
//             GoogleSignInAuthentication auth =
//                 await signinAccount.authentication;
//             final OAuthCredential credential = GoogleAuthProvider.credential(
//               idToken: auth.idToken,
//               accessToken: auth.accessToken,
//             );
//             User? user =
//                 (await FirebaseAuth.instance.signInWithCredential(credential))
//                     .user;
//             if (user != null) {
//               setState(() {
//                 // 画面を更新
//                 _displayName = user.displayName!;
//               });
//             }
//           },
//           child: const Text(
//             'login',
//             style: TextStyle(fontSize: 50),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             // detail
//             // データの取得
//             FirebaseFirestore.instance
//                 .doc('flutterDataCollection/flutterDataDocument')
//                 .get()
//                 .then((ref) {
//               print(ref.get('mydata'));
//             });
//             // FirebaseFirestore.instance
//             //     .collection('flutterDataCollection')
//             //     .doc('flutterDataDocument')
//             //     .get()
//             //     .then((ref) {
//             //   print(ref.get('mydata'));
//             // });
//             // データの追加・更新
//             FirebaseFirestore.instance
//                 .doc('flutterDataCollection/flutterDataDocument')
//                 .set({'mydata': 'hello world'});
//             // // 新しいドキュメントにデータの追加
//             // FirebaseFirestore.instance
//             //     .collection('flutterDataCollection')
//             //     .add({'data1': 'xyz'});
//             // // 削除
//             // FirebaseFirestore.instance
//             //     .doc('flutterDataCollection/5AEae9RIahHeJfhkfJWx')
//             //     .delete();
//           },
//           child: const Text(
//             '実行',
//             style: TextStyle(fontSize: 50),
//           ),
//         )
//       ]),
//     ));
//   }
// }



// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   // google Login
//   String _displayName = '';
//   static final googleLogin = GoogleSignIn(scopes: [
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ]);

//   // email & password Login
//   String _email = '';
//   String _password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(children: [
//           Icon(Icons.create),
//           Text("Title"),
//         ]),
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text("Hello $_displayName", style: const TextStyle(fontSize: 50)),
//             TextButton(
//                 onPressed: () async {
//                   // googleLogin
//                   GoogleSignInAccount? signinAccount =
//                       await googleLogin.signIn();
//                   if (signinAccount == null) return;
//                   GoogleSignInAuthentication auth =
//                       await signinAccount.authentication;
//                   final OAuthCredential credential =
//                       GoogleAuthProvider.credential(
//                     idToken: auth.idToken,
//                     accessToken: auth.accessToken,
//                   );
//                   User? user = (await FirebaseAuth.instance
//                           .signInWithCredential(credential))
//                       .user;
//                   if (user != null) {
//                     setState(() {
//                       // 画面更新
//                       _displayName = user.displayName!;
//                     });
//                   }
//                 },
//                 child: const Text(
//                   'login',
//                   style: TextStyle(fontSize: 50),
//                 )),
//           ]),

//           // child: Column(
//           //     mainAxisAlignment: MainAxisAlignment.center,
//           //     children: <Widget>[
//           //       Text("Hello $_displayName",
//           //           style: const TextStyle(fontSize: 50)),
//           //       TextButton(
//           //           onPressed: () async {
//           //             // googleLogin
//           //             GoogleSignInAccount? signinAccount =
//           //                 await googleLogin.signIn();
//           //             if (signinAccount == null) return;
//           //             GoogleSignInAuthentication auth =
//           //                 await signinAccount.authentication;
//           //             final OAuthCredential credential =
//           //                 GoogleAuthProvider.credential(
//           //               idToken: auth.idToken,
//           //               accessToken: auth.accessToken,
//           //             );
//           //             User? user = (await FirebaseAuth.instance
//           //                     .signInWithCredential(credential))
//           //                 .user;
//           //             if (user != null) {
//           //               setState(() {
//           //                 // 画面更新
//           //                 _displayName = user.displayName!;
//           //               });
//           //             }
//           //           },
//           //           child: const Text(
//           //             'login',
//           //             style: TextStyle(fontSize: 50),
//           //           )),

//           //       // // input
//           //       // TextFormField(
//           //       //   decoration: const InputDecoration(labelText: 'email'),
//           //       //   onChanged: (String value) {
//           //       //     setState(() {
//           //       //       _email = value;
//           //       //     });
//           //       //   },
//           //       // ),
//           //       // TextFormField(
//           //       //   decoration: const InputDecoration(labelText: 'password'),
//           //       //   obscureText: true,
//           //       //   onChanged: (String value) {
//           //       //     setState(() {
//           //       //       _password = value;
//           //       //     });
//           //       //   },
//           //       // ),
//           //       // // button
//           //       // ElevatedButton(
//           //       //     child: const Text("register"),
//           //       //     onPressed: () async {
//           //       //       try {
//           //       //         final User? user = (await FirebaseAuth.instance
//           //       //                 .createUserWithEmailAndPassword(
//           //       //                     email: _email, password: _password))
//           //       //             .user;
//           //       //         if (user != null) {
//           //       //           print('user register ${user.email}, ${user.uid}');
//           //       //         }
//           //       //       } catch (e) {
//           //       //         print(e);
//           //       //       }
//           //       //     }),
//           //       // ElevatedButton(
//           //       //     child: const Text("login"),
//           //       //     onPressed: () async {
//           //       //       try {
//           //       //         final User? user = (await FirebaseAuth.instance
//           //       //                 .signInWithEmailAndPassword(
//           //       //                     email: _email, password: _password))
//           //       //             .user;
//           //       //         if (user != null) {
//           //       //           print('user login ${user.email}, ${user.uid}');
//           //       //         }
//           //       //       } catch (e) {
//           //       //         print(e);
//           //       //       }
//           //       //     }),
//           //       // ElevatedButton(
//           //       //     child: const Text("reset password"),
//           //       //     onPressed: () async {
//           //       //       try {
//           //       //         await FirebaseAuth.instance
//           //       //             .sendPasswordResetEmail(email: _email);
//           //       //         print('send email');
//           //       //       } catch (e) {
//           //       //         print(e);
//           //       //       }
//           //       //     }),
//           //     ]),
//         ),
//       ),
//     );
//   }
// }
