import 'package:auri_journey_v1/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('boot sequence renders initial prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AuriApp());

    expect(find.text('AURI // BOOT SEQUENCE'), findsOneWidget);
    expect(find.text('MANUAL OVERRIDE REQUIRED'), findsOneWidget);
    expect(find.text('Press and hold to initialize the unit.'), findsOneWidget);
    expect(find.text('HOLD'), findsOneWidget);
  });
}
