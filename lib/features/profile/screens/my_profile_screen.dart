import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/features/detail/widgets/detail_section_card.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/profile/widgets/edit_bio_sheet.dart';
import 'package:allumni_connect/features/profile/widgets/profile_header.dart';
import 'package:allumni_connect/features/profile/widgets/profile_location_row.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/routing/routes.dart';

/// Écran "Mon profil" : identité, bio et localisation de l'alumni connecté,
/// avec raccourcis de modification.
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Alumni me = ref.watch(currentAlumniProvider);

    void goToEdit() => context.pushNamed(RouteName.editProfile);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ProfileHeader(
            alumni: me,
            onSettingsTap: () => context.goNamed(RouteName.settings),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(child: _EditProfileButton(onTap: goToEdit)),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailSectionTitle(
                  title: 'À propos',
                  trailing: _EditIconButton(
                    onTap: () => EditBioSheet.show(context, initialBio: me.bio),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(me.bio, style: AppTextStyles.body.copyWith(color: AppColors.ink)),
                const SizedBox(height: AppSpacing.xl),
                DetailSectionTitle(
                  title: 'Localisation',
                  trailing: _EditIconButton(onTap: goToEdit),
                ),
                const SizedBox(height: AppSpacing.lg),
                DetailSectionCard(
                  child: ProfileLocationRow(localisation: me.localisationCourte),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Modifier mon profil',
                style: AppTextStyles.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditIconButton extends StatelessWidget {
  const _EditIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
      ),
    );
  }
}
