import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// Rangée de filtres rapides flottant au-dessus de la carte (rayon de
/// recherche + raccourci vers le panneau de filtres complet).
class MapFilterChipsRow extends StatelessWidget {
  const MapFilterChipsRow({
    super.key,
    required this.radiusKm,
    required this.onRadiusTap,
    required this.promotionLabel,
    required this.onPromotionTap,
  });

  final double radiusKm;
  final VoidCallback onRadiusTap;
  final String promotionLabel;
  final VoidCallback onPromotionTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          _FilterChip(
            icon: Icons.navigation_rounded,
            label: 'Rayon : ${radiusKm.round()} km',
            selected: true,
            trailing: Icons.keyboard_arrow_down_rounded,
            onTap: onRadiusTap,
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            icon: Icons.workspace_premium_outlined,
            label: promotionLabel,
            selected: false,
            onTap: onPromotionTap,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final IconData? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.navy : AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: selected ? Colors.white : AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.bodySm.copyWith(
                  color: selected ? Colors.white : AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 2),
                Icon(trailing, size: 18, color: selected ? Colors.white : AppColors.muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
