import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Fiche flottante en bas de la carte pour l'alumni sélectionné : identité,
/// distance, raccourcis (filière/entreprise) et actions (itinéraire, appel,
/// profil).
class AlumniMapCard extends StatelessWidget {
  const AlumniMapCard({
    super.key,
    required this.alumni,
    required this.distanceLabel,
    required this.onClose,
    required this.onItineraire,
    required this.onCall,
    required this.onProfile,
  });

  final Alumni alumni;
  final String distanceLabel;
  final VoidCallback onClose;
  final VoidCallback onItineraire;
  final VoidCallback onCall;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    backgroundImage:
                        alumni.photoUrl != null ? NetworkImage(alumni.photoUrl!) : null,
                    child: alumni.photoUrl == null
                        ? Text(
                            alumni.initiales,
                            style: AppTextStyles.heading.copyWith(color: AppColors.primary),
                          )
                        : null,
                  ),
                  const Positioned(
                    bottom: -2,
                    right: -2,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.success,
                      child: Icon(Icons.check_rounded, size: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            alumni.nomComplet,
                            style: AppTextStyles.heading.copyWith(color: AppColors.ink),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            "P'${alumni.promotion.length >= 2 ? alumni.promotion.substring(2) : alumni.promotion}",
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${alumni.posteActuel} @ ${alumni.entreprise}',
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 14, color: AppColors.muted),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            'À $distanceLabel · ${alumni.ville}, ${alumni.adresse}',
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
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, size: 18, color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _InfoChip(icon: Icons.school_outlined, label: 'Filière', value: alumni.filiere),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _InfoChip(
                  icon: Icons.apartment_rounded,
                  label: 'Entreprise',
                  value: alumni.entreprise,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: onItineraire,
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('Itinéraire'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SquareIconButton(icon: Icons.call_outlined, onTap: onCall),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: onProfile,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    backgroundColor: AppColors.cream,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Profil'),
                      Icon(Icons.chevron_right_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.muted)),
                Text(
                  value,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: SizedBox(width: 52, height: 52, child: Icon(icon, color: AppColors.primary)),
      ),
    );
  }
}
