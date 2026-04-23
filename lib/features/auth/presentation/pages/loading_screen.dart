import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.cyan,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'CONNECTING TO ECHO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cyan,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Syncing progress data...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
