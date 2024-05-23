import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

class _MyHomePageState extends State<MyHomePage> {
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  stt.SpeechToText speech = stt.SpeechToText();
  // 音声入力開始
  Future<void> _speak() async {
    bool available = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (available) {
      speech.listen(onResult: resultListener);
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  // 音声入力停止
  Future<void> _stop() async {
    speech.stop();
  }

  // リザルトリスナー
  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  // エラーリスナー
  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

// ステータスリスナー
  void statusListener(String status) {
    setState(() {
      lastStatus = status;
    });
  }

  // FlutterTts flutterTts = FlutterTts();
  // final String _speakText = "こんにちは";
  // // 読み上げ
  // Future<void> _speak() async {
  //   await flutterTts.setLanguage("ja-JP");
  //   await flutterTts.setSpeechRate(1.0);
  //   await flutterTts.setVolume(1.0);
  //   await flutterTts.setPitch(1.0);
  //   await flutterTts.speak(_speakText);
  // }
  // // 停止
  // Future<void> _stop() async {
  //   await flutterTts.stop();
  // }

  String _userAccelerometerValues = "";
  String _gyroscopeValues = "";

  String _latitude = "NoData";
  String _longitude = "NoData";
  String _altitude = "NoData";
  String _distanceInMeters = "NoData";
  String _bearing = "NoData";

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      // 北緯がプラス、 南緯がマイナス
      _latitude =
          "緯度: ${position.latitude.toStringAsFixed(2)}"; // 東経がプラス、 西経がマイナス
      _longitude = "経度: ${position.longitude.toStringAsFixed(2)}"; // 高度
      _altitude =
          "高度: ${position.altitude.toStringAsFixed(2)}"; // 距離を1000で割ってkmで返す(サンパウロとの距離) _distanceInMeters =
      " 距離 :${(Geolocator.distanceBetween(position.latitude, position.longitude, -23.61, -46.40) / 1000).toStringAsFixed(2)}";
      // 方位を返す(サンパウロとの方位) _bearing =
      "方位: ${(Geolocator.bearingBetween(position.latitude, position.longitude, -23.61, -46.40)).toStringAsFixed(2)}";
    });
  }

  XFile? _image;
  VideoPlayerController? _controller;
  final imagePicker = ImagePicker();

  Future getVideoFromCamera() async {
    XFile? pickedFile = await imagePicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _controller = VideoPlayerController.file(File(pickedFile.path));
      _controller!.initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
    }
  }

  Future getVideoFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _controller = VideoPlayerController.file(File(pickedFile.path));
      _controller!.initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            ' 変換文字 :$lastWords',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'ステータス : $lastStatus',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      )),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            onPressed: _speak, child: const Icon(Icons.play_arrow)),
        FloatingActionButton(onPressed: _stop, child: const Icon(Icons.stop)),
      ]),
      // body: Center(
      //     child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Text(_speakText, style: Theme.of(context).textTheme.headlineMedium),
      //   ],
      // )),
      // floatingActionButton:
      //     Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      //   FloatingActionButton(
      //       onPressed: _speak, child: const Icon(Icons.play_arrow)),
      //   FloatingActionButton(onPressed: _stop, child: const Icon(Icons.stop)),
      // ]),
      // body: Center(
      //     child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Text(_userAccelerometerValues,
      //         style: Theme.of(context).textTheme.headlineMedium),
      //     Text(_gyroscopeValues,
      //         style: Theme.of(context).textTheme.headlineMedium),
      //   ],
      // )),
      // body: Center(
      //     child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Text(_latitude, style: Theme.of(context).textTheme.headlineMedium),
      //     Text(_longitude, style: Theme.of(context).textTheme.headlineMedium),
      //     Text(_altitude, style: Theme.of(context).textTheme.headlineMedium),
      //     Text(_distanceInMeters,
      //         style: Theme.of(context).textTheme.headlineMedium),
      //     Text(_bearing, style: Theme.of(context).textTheme.headlineMedium),
      //   ],
      // )),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: getLocation, child: const Icon(Icons.location_on)),

      // body: Center(
      //     child: _image == null
      //         ? Text('select picture',
      //             style: Theme.of(context).textTheme.headlineLarge)
      //         : Image.file(File(_image!.path))),
      // floatingActionButton: (Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     FloatingActionButton(
      //         onPressed: getImageFromCamera,
      //         child: const Icon(Icons.photo_camera)),
      //     FloatingActionButton(
      //         onPressed: getImageFromGallery,
      //         child: const Icon(Icons.photo_album)),
      //   ],
      // )),
      // );
      // body: Center(
      //     child: _controller == null
      //         ? Text('select picture',
      //             style: Theme.of(context).textTheme.headlineLarge)
      //         : VideoPlayer(_controller!)),
      // floatingActionButton: (Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     FloatingActionButton(
      //         onPressed: getVideoFromCamera,
      //         child: const Icon(Icons.video_call)),
      //     FloatingActionButton(
      //         onPressed: getVideoFromGallery,
      //         child: const Icon(Icons.movie_creation)),
      //   ],
      // )),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   userAccelerometerEvents.listen(
  //     (UserAccelerometerEvent event) {
  //       setState(() {
  //         _userAccelerometerValues =
  //             " 加速度センサー\n${event.x}\n${event.y}\n${event.z}";
  //       });
  //     },
  //   );
  //   gyroscopeEvents.listen(
  //     (GyroscopeEvent event) {
  //       setState(() {
  //         _gyroscopeValues = "ジャイロセンサー\n${event.x}\n${event.y}\n${event.z}";
  //       });
  //     },
  //   );
  // }
}
