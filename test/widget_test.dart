import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:incl03/main.dart';

import 'experiments/shared_state.dart' as shared;
import 'experiments/reversed_shadows.dart' as reversed;

void main() {
  Future<void> capture(WidgetTester tester, String name) async {
    final boundary = tester.firstRenderObject(
      find.byType(RepaintBoundary),
    ) as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File('submission/screenshots/$name.png')
        .writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  }

  testWidgets(
    'Local presses, callback order, cancellation, threshold and recharge',
    (tester) async {
      await tester.pumpWidget(const TactileDeckApp());
      await tester.pumpAndSettle();
      final press = await tester.startGesture(
        tester.getCenter(find.text('SHUTTER')),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.widget<Icon>(find.byIcon(Icons.camera_alt)).size, 40);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.center_focus_strong)).size,
        46,
      );
      await press.up();
      await tester.pumpAndSettle();
      expect(find.text('STATUS: PHOTO CAPTURE ACTIVATED'), findsOneWidget);
      final cancel = await tester.startGesture(
        tester.getCenter(find.text('FOCUS')),
      );
      await tester.pump(const Duration(milliseconds: 150));
      await cancel.cancel();
      await tester.pumpAndSettle();
      expect(find.text('STATUS: PHOTO CAPTURE ACTIVATED'), findsOneWidget);
      tester.widget<Slider>(find.byType(Slider)).onChanged!(80);
      await tester.pumpAndSettle();
      expect(find.text('POWER IN NORMAL RANGE'), findsOneWidget);
      tester.widget<Slider>(find.byType(Slider)).onChanged!(81);
      await tester.pumpAndSettle();
      expect(find.text('HIGH POWER — above 80%'), findsOneWidget);
      await tester.ensureVisible(find.text('RECHARGE'));
      await tester.longPress(find.text('RECHARGE'));
      await tester.pumpAndSettle();
      expect(find.text('STATUS: BATTERY RECHARGED'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    },
  );
  testWidgets('Q1 shared state experiment', (tester) async {
    await tester.pumpWidget(const shared.TactileDeckApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('SHUTTER'));
    await tester.pumpAndSettle();
    final press = await tester.startGesture(
      tester.getCenter(find.text('FOCUS')),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.widget<Icon>(find.byIcon(Icons.camera_alt)).size, 40);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.center_focus_strong)).size,
      40,
    );

    debugPrint(
      'Q1: holding FOCUS also shrank untouched SHUTTER to 40; shared-state bug reproduced.',
    );
    await press.up();
    await tester.pumpAndSettle();
  });
  testWidgets('Q3 reverse light direction experiment', (tester) async {
    await tester.pumpWidget(const TactileDeckApp());
    await tester.tap(find.byTooltip('Toggle Theme'));
    await tester.pumpAndSettle();

    await tester.runAsync(() => capture(tester, 'evidence-normal-shadows'));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const reversed.TactileDeckApp());
    await tester.tap(find.byTooltip('Toggle Theme'));
    await tester.pumpAndSettle();

    await tester.runAsync(() => capture(tester, 'evidence-reversed-shadows'));
    debugPrint(
      'Q3: dark offset (-8,8), light offset (8,-8); production source unchanged.',
    );
  });
}
