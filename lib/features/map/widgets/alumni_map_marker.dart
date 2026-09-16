import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Pin alumni affichée sur la carte : avatar cerclé + pointe, avec un badge
/// vérifié — même langage visuel que l'avatar de la fiche détaillée.
class AlumniMapMarker extends StatelessWidget {
  const AlumniMapMarker({
    super.key,
    required this.alumni,
    required this.isSelected,
    required this.onTap,
  });

  final Alumni alumni;
  final bool isSelected;
  final VoidCallback onTap;

  static const double size = 68;

  @override
  Widget build(BuildContext context) {
    final double radius = isSelected ? 26 : 21;
    final Color ringColor = isSelected ? AppColors.amber : AppColors.navy;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(color: ringColor, width: isSelected ? 3 : 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: radius,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  backgroundImage:
                      alumni.photoUrl != null ? NetworkImage(alumni.photoUrl!) : null,
                  child: alumni.photoUrl == null
                      ? Text(
                          alumni.initiales,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: radius * 0.55,
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.success,
                    child: Icon(Icons.check_rounded, size: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -4),
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(width: 10, height: 10, color: ringColor),
            ),
          ),
        ],
      ),
    );
  }
}
