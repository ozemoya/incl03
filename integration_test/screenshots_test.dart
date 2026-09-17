import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:inclass_act03/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Capture elevated and pressed controls on phone', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('01-unpressed');
    final press = await tester.startGesture(
      tester.getCenter(find.text('SHUTTER')),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await binding.takeScreenshot('02-mid-press');
    await press.up();
    await tester.pumpAndSettle();
    expect(find.text('STATUS: PHOTO CAPTURE ACTIVATED'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
