import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/detail/widgets/detail_section_card.dart';
import 'package:allumni_connect/features/profile/widgets/edit_bio_sheet.dart';
import 'package:allumni_connect/features/profile/widgets/profile_header.dart';
import 'package:allumni_connect/features/profile/widgets/profile_location_row.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/routing/routes.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AsyncValue<Alumni?> async = ref.watch(currentAlumniProvider);

    void goToEdit() => context.pushNamed(RouteName.editProfile);

    return Scaffold(
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'Impossible de charger ton profil.',
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ),
        data: (Alumni? me) {
          if (me == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
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
                    Text(me.bio, style: AppTextStyles.body.copyWith(color: scheme.onSurface)),
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
          );
        },
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
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
            border: Border.all(color: scheme.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_outlined, size: 16, color: scheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Modifier mon profil',
                style: AppTextStyles.bodySm.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(Icons.edit_outlined, size: 16, color: scheme.primary),
      ),
    );
  }
}
