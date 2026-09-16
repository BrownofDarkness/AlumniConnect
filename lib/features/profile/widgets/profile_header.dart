import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Bandeau supérieur de "Mon profil" : dégradé court (primary → navy) avec
/// le bouton réglages, avatar chevauchant le bas du dégradé, puis nom,
/// promotion et poste affichés sur le fond crème en dessous.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.alumni,
    required this.onSettingsTap,
  });

  final Alumni alumni;
  final VoidCallback onSettingsTap;

  static const double _avatarRadius = 40;
  static const double _overlap = _avatarRadius + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.navy],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSpacing.radiusXl)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, _overlap),
              child: Align(
                alignment: Alignment.topRight,
                child: _SettingsButton(onTap: onSettingsTap),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -_overlap),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: _avatarRadius,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  backgroundImage:
                      alumni.photoUrl != null ? NetworkImage(alumni.photoUrl!) : null,
                  child: alumni.photoUrl == null
                      ? Text(
                          alumni.initiales,
                          style: AppTextStyles.display.copyWith(color: AppColors.primary),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                alumni.nomComplet,
                style: AppTextStyles.title.copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: 2),
              Text(
                'Promotion ${alumni.promotion}',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${alumni.posteActuel} chez ${alumni.entreprise}',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.settings_outlined, color: Colors.white, size: 18),
      ),
    );
  }
}
