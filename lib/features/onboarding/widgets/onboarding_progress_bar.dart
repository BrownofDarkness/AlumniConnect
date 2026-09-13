import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const OnboardingProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Étape $current sur $total',
          style: AppTextStyles.caption.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(total, (index) {
            final filled = index < current;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < total - 1 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: filled ? AppColors.amber : AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
