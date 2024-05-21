import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wantorestaurant_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding();

  group('tap', () {
    testWidgets('tap', (tester) async {
      app.main();

      // 描画が終わるまで待つ
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      final Finder fab = find.byTooltip('Increment');
      await tester.tap(fab);
      // 描画が終わるまで待つ
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });
  });
}
