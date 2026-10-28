import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? logo;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (logo != null) ...[
          logo!,
          const SizedBox(height: 24),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}