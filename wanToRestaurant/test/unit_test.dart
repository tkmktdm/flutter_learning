import "package:flutter_test/flutter_test.dart";

void main() {
  test("success", () {
    int ans = 10;
    expect(ans, 10);
  });
  // test("bad", () {
  //   int ans = 10;
  //   expect(ans, 19);
  // });
  test("skip", () {
    int ans = 10;
    expect(ans, 10);
  }, skip: "skip");
}
