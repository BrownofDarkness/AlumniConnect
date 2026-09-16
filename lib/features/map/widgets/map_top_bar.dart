import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// En-tête de marque de l'écran Carte : logo, nom de l'app, raccourci
/// messages et avatar du profil connecté.
class MapTopBar extends StatelessWidget {
  const MapTopBar({
    super.key,
    required this.onMessagesTap,
    required this.onProfileTap,
    this.hasUnreadMessages = false,
    this.avatarUrl,
  });

  final VoidCallback onMessagesTap;
  final VoidCallback onProfileTap;
  final bool hasUnreadMessages;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      color: AppColors.white,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Image.asset(
              'assets/images/logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('AlumniConnect', style: AppTextStyles.heading.copyWith(color: AppColors.navy)),
          const SizedBox(width: 4),
          const Icon(Icons.verified_rounded, size: 16, color: AppColors.success),
          const Spacer(),
          _IconButtonWithBadge(
            icon: Icons.mail_outline_rounded,
            showBadge: hasUnreadMessages,
            onTap: onMessagesTap,
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: onProfileTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? const Icon(Icons.person_rounded, color: AppColors.primary, size: 20)
                      : null,
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
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

class _IconButtonWithBadge extends StatelessWidget {
  const _IconButtonWithBadge({
    required this.icon,
    required this.showBadge,
    required this.onTap,
  });

  final IconData icon;
  final bool showBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppColors.ink, size: 24),
            if (showBadge)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
