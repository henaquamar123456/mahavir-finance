import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class InquiryStepper extends StatelessWidget {
  final int currentStep;
  final String dateText;

  const InquiryStepper({
    super.key,
    required this.currentStep,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Submitted', 'subtitle': dateText},
      {'title': 'Under Review', 'subtitle': 'Our team is reviewing\nyour details'},
      {'title': 'Offer Stage', 'subtitle': ''},
      {'title': 'Completed', 'subtitle': ''},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                final stepIndex = index ~/ 2;
                final isPassed = currentStep > stepIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isPassed ? AppColors.secondary : AppColors.border,
                  ),
                );
              } else {
                final stepIndex = index ~/ 2;
                final isCompleted = currentStep > stepIndex;
                final isCurrent = currentStep == stepIndex;

                return Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent ? AppColors.secondary : Colors.white,
                    border: Border.all(
                      color: isCompleted || isCurrent ? AppColors.secondary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : isCurrent
                        ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                        : Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.border,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps.map((s) {
              final title = s['title']!;
              final subtitle = s['subtitle']!;

              return Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}