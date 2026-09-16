import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

enum PasswordStrength { none, weak, medium, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`\[\]\\;/]').hasMatch(password)) score++;
    if (score <= 1) return PasswordStrength.weak;
    if (score <= 2) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  int get _filledCount {
    switch (strength) {
      case PasswordStrength.none:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 2;
      case PasswordStrength.strong:
        return 3;
    }
  }

  Color get _color {
    switch (strength) {
      case PasswordStrength.none:
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return AppColors.amber;
      case PasswordStrength.strong:
        return AppColors.success;
    }
  }

  String get _label {
    switch (strength) {
      case PasswordStrength.none:
        return '—';
      case PasswordStrength.weak:
        return 'Faible';
      case PasswordStrength.medium:
        return 'Moyen';
      case PasswordStrength.strong:
        return 'Fort';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: List.generate(3, (index) {
            final filled = _filledCount > index;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: filled ? _color : AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Force du mot de passe : $_label',
          style: AppTextStyles.caption.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
