import 'dart:math' as math;
import 'dart:async';

class Generator {
  // コンストラクタでint型のStreamを受け取る
  Generator(StreamController<int> intStream) {
    Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        int data = math.Random().nextInt(100);
        print('Generator create $data');
        intStream.sink.add(data);
      },
    );
  }
}

class Coordinator {
  // コンストラクタでint型のStreamとString型のStreamを受け取る
  Coordinator(
      StreamController<int> intStream, StreamController<String> stringStream) {
    // 流れてきたものをintからStringにする
    intStream.stream.listen((data) async {
      String newData = data.toString();
      print('Coordinator is change $data to $newData');
      stringStream.sink.add(newData);
    });
  }
}

class Consumer {
  Consumer(StreamController<String> stringStream) {
    // StreamをListenしてデータが来たらターミナルに表示
    stringStream.stream.listen((data) async {
      print('consumer ${data} !!');
    });
  }
}
