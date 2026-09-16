import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Étiquette "Prénom N." affichée à côté de la pin sélectionnée sur la
/// carte, avec un raccourci mail.
class SelectedAlumniLabel extends StatelessWidget {
  const SelectedAlumniLabel({super.key, required this.alumni, required this.onMailTap});

  final Alumni alumni;
  final VoidCallback onMailTap;

  @override
  Widget build(BuildContext context) {
    final String shortName =
        '${alumni.prenom} ${alumni.nom.isNotEmpty ? '${alumni.nom[0]}.' : ''}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shortName,
            style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onMailTap,
            child: const Icon(Icons.mail_rounded, size: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
