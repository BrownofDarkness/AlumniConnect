import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/detail/widgets/detail_section_card.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/profile/widgets/profile_location_row.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Écran "Modifier mon profil" : identité, parcours pro et localisation de
/// l'alumni connecté.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _prenomController;
  late final TextEditingController _nomController;
  late final TextEditingController _posteController;
  late final TextEditingController _entrepriseController;

  @override
  void initState() {
    super.initState();
    final Alumni me = ref.read(currentAlumniProvider);
    _prenomController = TextEditingController(text: me.prenom);
    _nomController = TextEditingController(text: me.nom);
    _posteController = TextEditingController(text: me.posteActuel);
    _entrepriseController = TextEditingController(text: me.entreprise);
  }

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _posteController.dispose();
    _entrepriseController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final Alumni me = ref.read(currentAlumniProvider);
    ref.read(currentAlumniProvider.notifier).update(
          me.copyWith(
            prenom: _prenomController.text.trim(),
            nom: _nomController.text.trim(),
            posteActuel: _posteController.text.trim(),
            entreprise: _entrepriseController.text.trim(),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour.')),
    );
    Navigator.of(context).pop();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature : bientôt disponible.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Alumni me = ref.watch(currentAlumniProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    backgroundImage: me.photoUrl != null ? NetworkImage(me.photoUrl!) : null,
                    child: me.photoUrl == null
                        ? Text(
                            me.initiales,
                            style: AppTextStyles.displayXL.copyWith(color: AppColors.primary),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => _showComingSoon('La modification de la photo'),
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cream, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const DetailSectionTitle(title: 'Identité'),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Prénom',
              controller: _prenomController,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.notEmpty(v, 'Le prénom est requis'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Nom',
              controller: _nomController,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.notEmpty(v, 'Le nom est requis'),
            ),
            const SizedBox(height: AppSpacing.xl),
            const DetailSectionTitle(title: 'Parcours pro'),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Poste actuel',
              controller: _posteController,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.notEmpty(v, 'Le poste actuel est requis'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Entreprise',
              controller: _entrepriseController,
              textInputAction: TextInputAction.done,
              validator: (v) => Validators.notEmpty(v, 'L\'entreprise est requise'),
            ),
            const SizedBox(height: AppSpacing.xl),
            const DetailSectionTitle(title: 'Localisation'),
            const SizedBox(height: AppSpacing.md),
            DetailSectionCard(
              child: ProfileLocationRow(
                localisation: me.localisationCourte,
                caption: 'Modifier ma position',
                onTap: () => _showComingSoon('La modification de la position'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
