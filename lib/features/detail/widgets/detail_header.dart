import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Bandeau supérieur de la fiche alumni : avatar, badge vérifié, nom,
/// promotion, poste · entreprise, localisation.
///
/// Inspiré du rendu haute-fidélité (capture "Fiche Alumni").
class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.alumni});

  final Alumni alumni;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xxxl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                backgroundImage:
                    alumni.photoUrl != null ? NetworkImage(alumni.photoUrl!) : null,
                child: alumni.photoUrl == null
                    ? Text(
                        alumni.initiales,
                        style: AppTextStyles.display.copyWith(color: Colors.white),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.success,
                    child: Icon(Icons.check_rounded, size: 13, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            alumni.nomComplet,
            style: AppTextStyles.title.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Text(
              alumni.promotionLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${alumni.posteActuel} · ${alumni.entreprise}',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.place_outlined, size: 14, color: Colors.white.withValues(alpha: 0.7)),
              const SizedBox(width: 2),
              Text(
                alumni.localisationCourte,
                style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
