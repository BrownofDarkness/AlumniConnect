import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// Titre de section (label uppercase en bleu) affiché au-dessus d'une
/// [DetailSectionCard], en dehors de son cadre blanc. [trailing] permet
/// d'ajouter une action alignée à droite (ex : icône de modification).
class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final Text label = Text(
      title.toUpperCase(),
      style: AppTextStyles.labelCaps.copyWith(color: AppColors.primary),
    );

    if (trailing == null) return label;

    return Row(
      children: [
        Expanded(child: label),
        trailing!,
      ],
    );
  }
}

/// Carte de section blanche réutilisée dans la fiche alumni
/// (Parcours, Biographie, Coordonnées, Localisation).
class DetailSectionCard extends StatelessWidget {
  const DetailSectionCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }
}

/// Ligne icône + label + valeur, utilisée dans les cartes "Parcours" et
/// "Coordonnées".
class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.muted),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(color: AppColors.muted, fontSize: 10),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.body.copyWith(color: AppColors.ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
