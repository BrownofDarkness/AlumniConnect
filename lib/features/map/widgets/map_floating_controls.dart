import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// Colonne d'actions flottantes à droite de la carte : vue liste, style de
/// carte, recentrage sur ma position + compteur d'alumni affichés.
class MapFloatingControls extends StatelessWidget {
  const MapFloatingControls({
    super.key,
    required this.onListTap,
    required this.onLayersTap,
    required this.onLocateTap,
    required this.activeCount,
  });

  final VoidCallback onListTap;
  final VoidCallback onLayersTap;
  final VoidCallback onLocateTap;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundButton(icon: Icons.format_list_bulleted_rounded, onTap: onListTap),
        const SizedBox(height: AppSpacing.sm),
        _RoundButton(icon: Icons.layers_outlined, onTap: onLayersTap),
        const SizedBox(height: AppSpacing.sm),
        _RoundButton(icon: Icons.my_location_rounded, onTap: onLocateTap),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              Text(
                '$activeCount',
                style: AppTextStyles.heading.copyWith(color: AppColors.primary),
              ),
              Text(
                'ACTIFS',
                style: AppTextStyles.labelCaps.copyWith(color: AppColors.primary, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.ink, size: 20),
        ),
      ),
    );
  }
}
