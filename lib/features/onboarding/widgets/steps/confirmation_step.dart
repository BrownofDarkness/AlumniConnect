import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/features/onboarding/widgets/avatar_stack.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';

class ConfirmationStep extends StatelessWidget {
  final VoidCallback onFinish;
  final bool submitting;

  const ConfirmationStep({
    super.key,
    required this.onFinish,
    this.submitting = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return OnboardingStepShell(
      showBackButton: false,
      currentStep: null,
      bottomAction: AppButton.primary(
        label: 'Découvrir l\'annuaire',
        onPressed: onFinish,
        state: submitting ? ButtonState.loading : ButtonState.enabled,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppColors.amber,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.10),
                    spreadRadius: 8,
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.35),
                    offset: const Offset(0, 12),
                    blurRadius: 32,
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.check,
                size: 46,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ton profil\nest complet',
              style: AppTextStyles.displayXL.copyWith(
                color: scheme.onSurface,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.muted),
                children: [
                  const TextSpan(text: 'Bienvenue dans la communauté '),
                  TextSpan(
                    text: 'AlumniConnect',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: '. Découvre les 128 alumni déjà présents.'),
                ],
              ),
            ),
            const SizedBox(height: 34),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarStack(
                  gradients: AvatarStack.sampleGradients.sublist(0, 3),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amina, Yassine, Fatou',
                      style: AppTextStyles.caption.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'et 125 autres',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
