import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

enum SnackType { success, error, info }

class AppSnackBar extends StatelessWidget {
  final String message;
  final SnackType type;

  const AppSnackBar({
    super.key,
    required this.message,
    required this.type,
  });

  static void show(BuildContext context, SnackType type, String message) {
    showTopSnackBar(
      Overlay.of(context),
      AppSnackBar(message: message, type: type),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, SnackType.success, message);

  static void error(BuildContext context, String message) =>
      show(context, SnackType.error, message);

  static void info(BuildContext context, String message) =>
      show(context, SnackType.info, message);

  @override
  Widget build(BuildContext context) {
    final config = _configFor(type);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border(
          left: BorderSide(color: config.color, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(config.icon, color: config.color, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  _SnackConfig _configFor(SnackType type) {
    switch (type) {
      case SnackType.success:
        return const _SnackConfig(color: AppColors.success, icon: LucideIcons.circleCheck);
      case SnackType.error:
        return const _SnackConfig(color: AppColors.error, icon: LucideIcons.circleAlert);
      case SnackType.info:
        return const _SnackConfig(color: AppColors.primary, icon: LucideIcons.info);
    }
  }
}

class _SnackConfig {
  final Color color;
  final IconData icon;
  const _SnackConfig({required this.color, required this.icon});
}
