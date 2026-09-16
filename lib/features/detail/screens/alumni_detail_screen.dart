import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/features/detail/widgets/contact_shortcut.dart';
import 'package:allumni_connect/features/detail/widgets/detail_header.dart';
import 'package:allumni_connect/features/detail/widgets/detail_section_card.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Fiche détaillée d'un alumni : identité, parcours, biographie,
/// coordonnées, localisation + raccourcis de contact.
///
/// Inspiré du rendu haute-fidélité (capture "Fiche Alumni") plutôt que du
/// wireframe basse-fidélité de la maquette UX/UI.
class AlumniDetailScreen extends ConsumerWidget {
  AlumniDetailScreen({super.key, required this.id});

  final String id;

  final GlobalKey _localisationKey = GlobalKey();

  Future<void> _launch(BuildContext context, Uri uri) async {
    final bool canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir cette action sur cet appareil.')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _scrollToLocalisation(BuildContext context) {
    final BuildContext? target = _localisationKey.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Alumni? alumni = ref.watch(alumniByIdProvider(id));

    if (alumni == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fiche Alumni')),
        body: Center(
          child: Text(
            'Cet alumni est introuvable.',
            style: AppTextStyles.body.copyWith(color: AppColors.muted),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Fiche Alumni')),
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          DetailHeader(alumni: alumni),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ContactShortcut(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email',
                    onTap: () => _launch(context, Uri(scheme: 'mailto', path: alumni.email)),
                  ),
                  ContactShortcut(
                    icon: Icons.call_outlined,
                    label: 'Appeler',
                    onTap: () => _launch(
                      context,
                      Uri(scheme: 'tel', path: alumni.telephone.replaceAll(' ', '')),
                    ),
                  ),
                  ContactShortcut(
                    icon: Icons.business_center_outlined,
                    label: 'LinkedIn',
                    onTap: () => _launch(context, Uri.parse(alumni.linkedinUrl)),
                  ),
                  ContactShortcut(
                    icon: Icons.map_outlined,
                    label: 'Carte',
                    onTap: () => _scrollToLocalisation(context),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailSectionCard(
                    title: 'Parcours académique & pro',
                    child: Column(
                      children: [
                        DetailInfoRow(
                          icon: Icons.menu_book_outlined,
                          label: 'Filière',
                          value: alumni.filiere,
                        ),
                        DetailInfoRow(
                          icon: Icons.work_outline_rounded,
                          label: 'Poste actuel',
                          value: alumni.posteActuel,
                        ),
                        DetailInfoRow(
                          icon: Icons.apartment_rounded,
                          label: 'Entreprise',
                          value: alumni.entreprise,
                        ),
                        DetailInfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Promotion',
                          value: alumni.promotionLabel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DetailSectionCard(
                    title: 'Biographie',
                    child: Text(
                      alumni.bio,
                      style: AppTextStyles.body.copyWith(color: AppColors.ink),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DetailSectionCard(
                    title: 'Coordonnées',
                    child: Column(
                      children: [
                        DetailInfoRow(
                          icon: Icons.mail_outline_rounded,
                          label: 'Email professionnel',
                          value: alumni.email,
                        ),
                        DetailInfoRow(
                          icon: Icons.call_outlined,
                          label: 'Téléphone',
                          value: alumni.telephone,
                        ),
                        DetailInfoRow(
                          icon: Icons.business_center_outlined,
                          label: 'LinkedIn',
                          value: alumni.linkedin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DetailSectionCard(
                    key: _localisationKey,
                    title: 'Localisation',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MapPreviewPlaceholder(),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 16, color: AppColors.muted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                alumni.localisationCourte,
                                style: AppTextStyles.bodySm.copyWith(color: AppColors.muted),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _launch(context, Uri.parse(alumni.mapsSearchUrl)),
                            icon: const Icon(Icons.directions_rounded, size: 18),
                            label: const Text('S\'y rendre'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Aperçu de carte statique.
///
/// TODO : remplacer par une vraie tuile de carte (google_maps_flutter ou
/// flutter_map) une fois le package retenu par l'équipe pour la feature
/// carte interactive.
class _MapPreviewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Center(
        child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 28),
      ),
    );
  }
}
