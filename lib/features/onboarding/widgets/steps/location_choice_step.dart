import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/features/onboarding/widgets/location_option_card.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';

class LocationChoiceStep extends StatelessWidget {
  final VoidCallback onChooseGps;
  final VoidCallback onChooseManual;
  final VoidCallback onBack;

  const LocationChoiceStep({
    super.key,
    required this.onChooseGps,
    required this.onChooseManual,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return OnboardingStepShell(
      currentStep: 3,
      onBack: onBack,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Où es-tu ?',
              style: AppTextStyles.title.copyWith(
                color: scheme.onSurface,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ta position permet à la communauté de se retrouver géographiquement.',
              style: AppTextStyles.body.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            _buildObligationBanner(context),
            const SizedBox(height: 24),
            LocationOptionCard(
              icon: LucideIcons.crosshair,
              title: 'Utiliser ma position actuelle',
              description: 'Nous captons ta position GPS une seule fois.',
              recommended: true,
              onTap: onChooseGps,
            ),
            const SizedBox(height: 12),
            LocationOptionCard(
              icon: LucideIcons.mapPin,
              title: 'Saisir mon adresse manuellement',
              description: 'Renseigne ton adresse et nous géolocaliserons le point.',
              onTap: onChooseManual,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObligationBanner(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.amber.withValues(alpha: 0.12)
        : AppColors.amberSoft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(
          left: BorderSide(color: AppColors.amber, width: 3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.triangleAlert,
            size: 20,
            color: AppColors.amber,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.body.copyWith(
                  color: scheme.onSurface,
                  fontSize: 13,
                ),
                children: [
                  const TextSpan(text: 'Le partage de ta localisation est '),
                  TextSpan(
                    text: 'obligatoire',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' pour rejoindre l\'annuaire.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
