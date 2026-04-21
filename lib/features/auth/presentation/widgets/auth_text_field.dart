import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
      ),
    );
  }
}
