import 'package:flutter/material.dart';
import 'features/boot/presentation/boot_screen.dart';
import 'shared/widgets/auri_ui.dart';

class AuriApp extends StatelessWidget {
  const AuriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AuriColors.voidBlack,
        colorScheme: const ColorScheme.dark(
          primary: AuriColors.accent,
          secondary: AuriColors.accentMuted,
          surface: AuriColors.surface,
          error: AuriColors.danger,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: auriPrimaryButtonStyle(),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: auriSecondaryButtonStyle(),
        ),
      ),
      home: const BootScreen(),
    );
  }
}
