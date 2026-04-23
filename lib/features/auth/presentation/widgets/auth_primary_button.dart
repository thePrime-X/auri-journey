import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool purpleMode;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.purpleMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: purpleMode
                ? [AppColors.purple, AppColors.purple2]
                : [AppColors.cyan, AppColors.cyan2],
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
