import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auri_app/app/app.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.byType(App), findsOneWidget);
  });
}
