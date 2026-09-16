import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Résumé de l'itinéraire entre l'alumni connecté et l'alumni sélectionné :
/// avatars des deux extrémités et distance.
class ItineraryRouteCard extends StatelessWidget {
  const ItineraryRouteCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.distanceLabel,
  });

  final Alumni origin;
  final Alumni destination;
  final String distanceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
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
        children: [
          Row(
            children: [
              Expanded(
                child: _PersonBadge(label: 'Vous', name: origin.nomComplet, initiales: origin.initiales),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(Icons.more_horiz_rounded, color: AppColors.muted),
              ),
              Expanded(
                child: _PersonBadge(
                  label: destination.ville,
                  name: destination.nomComplet,
                  initiales: destination.initiales,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.social_distance_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '$distanceLabel à vol d\'oiseau',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonBadge extends StatelessWidget {
  const _PersonBadge({
    required this.label,
    required this.name,
    required this.initiales,
    this.alignEnd = false,
  });

  final String label;
  final String name;
  final String initiales;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelCaps.copyWith(color: AppColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: alignEnd ? TextDirection.rtl : TextDirection.ltr,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                initiales,
                style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                name,
                style: AppTextStyles.bodySm.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
