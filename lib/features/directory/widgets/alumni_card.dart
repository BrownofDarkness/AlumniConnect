import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Carte alumni de l'annuaire : photo, nom, promotion, poste actuel, ville.
///
/// Conforme à la charte graphique : carte sobre, bordure légère, rayon 12px.
class AlumniCard extends StatelessWidget {
  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
    this.distanceLabel,
  });

  final Alumni alumni;
  final VoidCallback onTap;

  /// Ex. "2.4 km" — affiché uniquement quand le filtre de proximité est actif.
  final String? distanceLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              _Avatar(alumni: alumni),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alumni.nomComplet,
                      style: AppTextStyles.heading.copyWith(color: scheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alumni.posteActuel,
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _Pill(text: alumni.promotionLabel),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(Icons.place_outlined, size: 14, color: AppColors.muted),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            distanceLabel != null
                                ? '${alumni.ville} · à $distanceLabel'
                                : alumni.ville,
                            style: AppTextStyles.caption.copyWith(color: AppColors.muted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.alumni});

  final Alumni alumni;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      backgroundImage: alumni.photoUrl != null ? NetworkImage(alumni.photoUrl!) : null,
      child: alumni.photoUrl == null
          ? Text(
              alumni.initiales,
              style: AppTextStyles.heading.copyWith(color: AppColors.primary),
            )
          : null,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
