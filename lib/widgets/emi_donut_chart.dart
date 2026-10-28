import 'dart:math';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../utils/currency_formatter.dart';

class EmiDonutChart extends StatelessWidget {
  final double principalPercentage;
  final double interestPercentage;
  final double totalPayable;

  const EmiDonutChart({
    super.key,
    required this.principalPercentage,
    required this.interestPercentage,
    required this.totalPayable,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: CustomPaint(
        painter: _DonutChartPainter(
          principalPercentage: principalPercentage,
          interestPercentage: interestPercentage,
          principalColor: AppColors.secondary,
          interestColor: AppColors.primary,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                CurrencyFormatter.formatWhole(totalPayable),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double principalPercentage;
  final double interestPercentage;
  final Color principalColor;
  final Color interestColor;

  _DonutChartPainter({
    required this.principalPercentage,
    required this.interestPercentage,
    required this.principalColor,
    required this.interestColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 24.0;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final principalPaint = Paint()
      ..color = principalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final interestPaint = Paint()
      ..color = interestColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const startAngle = -pi / 2;
    final principalSweepAngle = (principalPercentage / 100) * 2 * pi;
    final interestSweepAngle = (interestPercentage / 100) * 2 * pi;

    // Draw Principal Arc (Green)
    canvas.drawArc(rect, startAngle, principalSweepAngle, false, principalPaint);

    // Draw Interest Arc (Navy)
    canvas.drawArc(rect, startAngle + principalSweepAngle, interestSweepAngle, false, interestPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.principalPercentage != principalPercentage ||
        oldDelegate.interestPercentage != interestPercentage;
  }
}