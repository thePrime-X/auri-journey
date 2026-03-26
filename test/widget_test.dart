import 'package:flutter_test/flutter_test.dart';
import 'package:auri_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('App loads successfully'), findsOneWidget);
    expect(find.text('Firebase is connected ✅'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
