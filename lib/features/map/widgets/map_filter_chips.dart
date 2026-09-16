import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// Rangée de filtres rapides flottant au-dessus de la carte (rayon de
/// recherche).
///
/// Même habillage que les chips de filtres actifs de l'Annuaire
/// ([DirectoryScreen] · `_RemovableChip`) : pastille primary/8%, texte
/// caption, sans élévation.
class MapFilterChipsRow extends StatelessWidget {
  const MapFilterChipsRow({
    super.key,
    required this.radiusKm,
    required this.onRadiusTap,
  });

  final double radiusKm;
  final VoidCallback onRadiusTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _FilterChip(
          icon: Icons.navigation_rounded,
          label: 'Rayon : ${radiusKm.round()} km',
          trailing: Icons.keyboard_arrow_down_rounded,
          onTap: onRadiusTap,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final IconData? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: scheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.bodySm.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 4),
                Icon(trailing, size: 18, color: scheme.primary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
