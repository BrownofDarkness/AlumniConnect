import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';
import 'package:allumni_connect/features/onboarding/widgets/password_strength_indicator.dart';

class SecurityStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const SecurityStep({
    super.key,
    required this.onContinue,
    required this.onSkip,
    required this.onBack,
  });

  @override
  State<SecurityStep> createState() => _SecurityStepState();
}

class _SecurityStepState extends State<SecurityStep> with AutomaticKeepAliveClientMixin {
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  PasswordStrength _strength = PasswordStrength.none;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _newPassword.addListener(_updateStrength);
  }

  @override
  void dispose() {
    _newPassword.removeListener(_updateStrength);
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _updateStrength() {
    setState(() {
      _strength = PasswordStrengthIndicator.evaluate(_newPassword.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final scheme = Theme.of(context).colorScheme;

    return OnboardingStepShell(
      currentStep: 4,
      onBack: widget.onBack,
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.primary(
            label: 'Enregistrer',
            onPressed: widget.onContinue,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: widget.onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: AppColors.muted,
            ),
            child: Text(
              'Plus tard',
              style: AppTextStyles.body.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 4, 28, 20),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.shieldCheck,
                size: 28,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sécurise ton compte',
              style: AppTextStyles.title.copyWith(
                color: scheme.onSurface,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ton mot de passe actuel a été généré automatiquement. Tu peux le remplacer par un mot de passe personnel.',
              style: AppTextStyles.body.copyWith(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Nouveau mot de passe',
              controller: _newPassword,
              hint: '••••••••',
              isPassword: true,
              textInputAction: TextInputAction.next,
            ),
            PasswordStrengthIndicator(strength: _strength),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Confirmer le mot de passe',
              controller: _confirmPassword,
              hint: '••••••••',
              isPassword: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.info,
                  size: 14,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Au moins 8 caractères, dont une majuscule et un chiffre.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
