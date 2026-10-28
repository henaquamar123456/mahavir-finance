
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 36,
    this.strokeWidth = 3,
    this.color = AppColors.secondary,
    this.message,
    this.fullScreen = false,
  });

  final double size;
  final double strokeWidth;
  final Color color;
  final String? message;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final loader = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );

    if (fullScreen) {
      return ColoredBox(
        color: Colors.white,
        child: Center(
          child: loader,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: loader,
      ),
    );
  }
}
