import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// Ligne "Ville, Pays" affichée dans la carte Localisation du profil, avec
/// un repère de position et une légende (ex : "Position enregistrée" en
/// lecture seule, "Modifier ma position" en édition).
class ProfileLocationRow extends StatelessWidget {
  const ProfileLocationRow({
    super.key,
    required this.localisation,
    this.caption = 'Position enregistrée',
    this.onTap,
  });

  final String localisation;
  final String caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget row = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.amberSoft,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const Icon(Icons.place_rounded, color: AppColors.amber, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localisation,
                style: AppTextStyles.body.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600),
              ),
              Text(
                caption,
                style: AppTextStyles.caption.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
        if (onTap != null)
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
      ],
    );

    if (onTap == null) return row;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: row,
    );
  }
}
