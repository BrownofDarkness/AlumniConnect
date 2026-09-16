import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/alumni_x.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/detail/widgets/detail_section_card.dart';
import 'package:allumni_connect/features/profile/widgets/profile_location_row.dart';
import 'package:allumni_connect/models/alumni.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenom = TextEditingController();
  final _nom = TextEditingController();
  final _poste = TextEditingController();
  final _entreprise = TextEditingController();
  bool _seeded = false;
  bool _saving = false;

  @override
  void dispose() {
    _prenom.dispose();
    _nom.dispose();
    _poste.dispose();
    _entreprise.dispose();
    super.dispose();
  }

  void _seed(Alumni me) {
    if (_seeded) return;
    _prenom.text = me.prenom;
    _nom.text = me.nom;
    _poste.text = me.posteActuel;
    _entreprise.text = me.entreprise;
    _seeded = true;
  }

  Future<void> _save(Alumni me) async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    try {
      await ref.read(alumniRepositoryProvider).updateFields(me.id, {
        'prenom': _prenom.text.trim(),
        'nom': _nom.text.trim(),
        'posteActuel': _poste.text.trim(),
        'entreprise': _entreprise.text.trim(),
      });
      if (!mounted) return;
      AppSnackBar.success(context, 'Profil mis à jour.');
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppSnackBar.error(context, 'Impossible d\'enregistrer. Réessaie.');
    }
  }

  void _showComingSoon(String feature) {
    AppSnackBar.info(context, '$feature : bientôt disponible.');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AsyncValue<Alumni?> async = ref.watch(currentAlumniProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Modifier mon profil')),
        body: Center(
          child: Text(
            'Impossible de charger ton profil.',
            style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ),
      data: (Alumni? me) {
        if (me == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        _seed(me);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Modifier mon profil'),
            actions: [
              TextButton(
                onPressed: _saving ? null : () => _save(me),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enregistrer'),
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
                        backgroundColor: scheme.primary.withValues(alpha: 0.15),
                        backgroundImage: me.photoUrl != null ? NetworkImage(me.photoUrl!) : null,
                        child: me.photoUrl == null
                            ? Text(
                                me.initiales,
                                style: AppTextStyles.displayXL.copyWith(color: scheme.primary),
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
                              color: scheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: scheme.surface, width: 2),
                            ),
                            child: Icon(Icons.camera_alt_rounded, color: scheme.onPrimary, size: 16),
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
                  controller: _prenom,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.notEmpty(v, 'Le prénom est requis'),
                  enabled: !_saving,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Nom',
                  controller: _nom,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.notEmpty(v, 'Le nom est requis'),
                  enabled: !_saving,
                ),
                const SizedBox(height: AppSpacing.xl),
                const DetailSectionTitle(title: 'Parcours pro'),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Poste actuel',
                  controller: _poste,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.notEmpty(v, 'Le poste actuel est requis'),
                  enabled: !_saving,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Entreprise',
                  controller: _entreprise,
                  textInputAction: TextInputAction.done,
                  validator: (v) => Validators.notEmpty(v, 'L\'entreprise est requise'),
                  enabled: !_saving,
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
      },
    );
  }
}
