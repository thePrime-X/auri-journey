import 'package:auri_app/app/app.dart';
import 'package:auri_app/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Test App')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [goRouterProvider.overrideWithValue(testRouter)],
        child: const App(),
      ),
    );

    await tester.pump();

    expect(find.byType(App), findsOneWidget);
    expect(find.text('Test App'), findsOneWidget);
  });
}
