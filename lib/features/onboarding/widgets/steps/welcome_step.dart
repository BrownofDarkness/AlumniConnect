import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomeStep({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingStepShell(
      showBackButton: false,
      currentStep: null,
      bottomAction: AppButton.primary(
        label: 'Commencer',
        onPressed: onContinue,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 44, 28, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue\nsur AlumniConnect',
                style: AppTextStyles.displayXL.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Il te reste quelques informations à compléter avant de rejoindre la communauté.',
                style: AppTextStyles.bodyLg.copyWith(
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Ce que tu vas renseigner',
                style: AppTextStyles.labelCaps.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 18),
              const _StepPreviewItem(
                icon: LucideIcons.user,
                label: 'Ton identité et ton parcours',
              ),
              const SizedBox(height: 14),
              const _StepPreviewItem(
                icon: LucideIcons.atSign,
                label: 'Tes coordonnées',
              ),
              const SizedBox(height: 14),
              const _StepPreviewItem(
                icon: LucideIcons.mapPin,
                label: 'Ta localisation',
              ),
              const SizedBox(height: 14),
              const _StepPreviewItem(
                icon: LucideIcons.shieldCheck,
                label: 'Sécuriser ton compte',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepPreviewItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StepPreviewItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: scheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLg.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
