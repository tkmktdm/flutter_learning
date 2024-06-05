// 以下のコマンドでuser.freezed.dartファイルを自動生成させる
// dart run build_runner build --delete-conflicting-outputs
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User(String name, int age) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
