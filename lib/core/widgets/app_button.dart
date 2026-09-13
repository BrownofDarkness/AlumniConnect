import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

enum ButtonState { enabled, disabled, loading }

enum _Variant { primary, secondary, amber, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonState state;
  final _Variant _variant;

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.state = ButtonState.enabled,
  }) : _variant = _Variant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.state = ButtonState.enabled,
  }) : _variant = _Variant.secondary;

  const AppButton.amber({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.state = ButtonState.enabled,
  }) : _variant = _Variant.amber;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.state = ButtonState.enabled,
  }) : _variant = _Variant.ghost;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.state = ButtonState.enabled,
  }) : _variant = _Variant.danger;

  bool get _enabled => state == ButtonState.enabled;
  bool get _loading => state == ButtonState.loading;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(context);
    final bg = colors.background;
    final fg = colors.foreground;
    final effectiveBg = _enabled ? bg : bg.withValues(alpha: 0.5);
    final effectiveFg = _enabled ? fg : fg.withValues(alpha: 0.6);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: effectiveFg,
          disabledBackgroundColor: effectiveBg,
          disabledForegroundColor: effectiveFg,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: colors.border != null ? BorderSide(color: colors.border!, width: 1.5) : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: _loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveFg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: AppTextStyles.heading.copyWith(color: effectiveFg),
                  ),
                ],
              ),
      ),
    );
  }

  _ButtonColors _colorsFor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (_variant) {
      case _Variant.primary:
        return _ButtonColors(background: scheme.primary, foreground: scheme.onPrimary);
      case _Variant.secondary:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: scheme.primary,
          border: scheme.primary,
        );
      case _Variant.amber:
        return const _ButtonColors(background: AppColors.amber, foreground: AppColors.navy);
      case _Variant.ghost:
        return _ButtonColors(background: Colors.transparent, foreground: scheme.primary);
      case _Variant.danger:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: scheme.error,
          border: scheme.error,
        );
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;

  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}
