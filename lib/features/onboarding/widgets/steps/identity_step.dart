import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/onboarding/models/onboarding_data.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';

class IdentityStep extends StatefulWidget {
  final void Function(IdentityData) onContinue;
  final VoidCallback onBack;

  const IdentityStep({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<IdentityStep> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _prenom = TextEditingController();
  final _nom = TextEditingController();
  final _promotion = TextEditingController();
  final _filiere = TextEditingController();
  final _poste = TextEditingController();
  final _entreprise = TextEditingController();
  final _bio = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _prenom.dispose();
    _nom.dispose();
    _promotion.dispose();
    _filiere.dispose();
    _poste.dispose();
    _entreprise.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _handleContinue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onContinue(IdentityData(
        prenom: _prenom.text.trim(),
        nom: _nom.text.trim(),
        promotion: _promotion.text.trim(),
        filiere: _filiere.text.trim(),
        posteActuel: _poste.text.trim(),
        entreprise: _entreprise.text.trim(),
        bio: _bio.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OnboardingStepShell(
      currentStep: 1,
      onBack: widget.onBack,
      bottomAction: AppButton.primary(
        label: 'Continuer',
        onPressed: _handleContinue,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ton identité',
                style: AppTextStyles.title.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ces informations apparaîtront sur ton profil.',
                style: AppTextStyles.body.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              _buildPhotoUpload(context),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Prénom',
                controller: _prenom,
                hint: 'Karim',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.notEmpty(v, 'Le prénom est requis'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nom',
                controller: _nom,
                hint: 'Diallo',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.notEmpty(v, 'Le nom est requis'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Promotion',
                controller: _promotion,
                hint: '2021',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.notEmpty(v, 'La promotion est requise'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Filière',
                isOptional: true,
                controller: _filiere,
                hint: 'Développement web',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Poste actuel',
                isOptional: true,
                controller: _poste,
                hint: 'Développeur backend',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Entreprise',
                isOptional: true,
                controller: _entreprise,
                hint: 'Airbnb',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Bio',
                isOptional: true,
                controller: _bio,
                hint: 'Quelques mots sur toi...',
                textInputAction: TextInputAction.done,
                maxLines: 4,
                minLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUpload(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: scheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: scheme.outline,
                width: 1.5,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(
              LucideIcons.camera,
              size: 26,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ajouter une photo',
            style: AppTextStyles.caption.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
