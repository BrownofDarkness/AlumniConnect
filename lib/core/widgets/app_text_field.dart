import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool enabled;
  final bool isOptional;
  final IconData? prefixIcon;
  final int? maxLines;
  final int? minLines;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.enabled = true,
    this.isOptional = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.bodyLg,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 18, color: AppColors.muted)
                : null,
            suffixIcon: widget.isPassword ? _buildVisibilityToggle() : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    final labelText = Text(
      widget.label,
      style: AppTextStyles.caption.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );

    if (!widget.isOptional) return labelText;

    return Row(
      children: [
        labelText,
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'OPTIONNEL',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.muted,
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      onPressed: widget.enabled ? () => setState(() => _obscure = !_obscure) : null,
      icon: Icon(
        _obscure ? LucideIcons.eye : LucideIcons.eyeOff,
        size: 20,
        color: AppColors.muted,
      ),
      tooltip: _obscure ? 'Afficher le mot de passe' : 'Masquer le mot de passe',
    );
  }
}
