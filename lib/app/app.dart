import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Auri's Journey",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
