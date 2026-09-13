import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/onboarding/widgets/map_preview.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';

class LocationManualStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  final bool fromGps;

  const LocationManualStep({
    super.key,
    required this.onContinue,
    required this.onBack,
    this.fromGps = false,
  });

  @override
  State<LocationManualStep> createState() => _LocationManualStepState();
}

class _LocationManualStepState extends State<LocationManualStep> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _adresse;
  late final TextEditingController _ville;
  late final TextEditingController _pays;

  @override
  void initState() {
    super.initState();
    _adresse = TextEditingController(text: widget.fromGps ? 'Bonapriso' : '');
    _ville = TextEditingController(text: widget.fromGps ? 'Douala' : '');
    _pays = TextEditingController(text: widget.fromGps ? 'Cameroun' : '');
  }

  @override
  void didUpdateWidget(covariant LocationManualStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fromGps != widget.fromGps) {
      _resyncFromSource();
    }
  }

  void _resyncFromSource() {
    if (widget.fromGps) {
      _adresse.text = 'Bonapriso';
      _ville.text = 'Douala';
      _pays.text = 'Cameroun';
    } else {
      _adresse.clear();
      _ville.clear();
      _pays.clear();
    }
  }

  @override
  void dispose() {
    _adresse.dispose();
    _ville.dispose();
    _pays.dispose();
    super.dispose();
  }

  void _handleContinue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onContinue();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final headline = widget.fromGps ? 'Confirme ta position' : 'Ton adresse';
    final subtitle = widget.fromGps
        ? 'Position détectée automatiquement. Modifie-la si besoin.'
        : 'Nous géolocaliserons ce point sur la carte de la communauté.';
    final ctaLabel = widget.fromGps ? 'Confirmer et continuer' : 'Enregistrer et continuer';

    return OnboardingStepShell(
      currentStep: 3,
      onBack: widget.onBack,
      bottomAction: AppButton.primary(
        label: ctaLabel,
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
                headline,
                style: AppTextStyles.title.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.body.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Adresse',
                controller: _adresse,
                hint: '12 rue de la République',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.notEmpty(v, 'L\'adresse est requise'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Ville',
                controller: _ville,
                hint: 'Douala',
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.notEmpty(v, 'La ville est requise'),
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Pays',
                controller: _pays,
                hint: 'Cameroun',
                textInputAction: TextInputAction.done,
                validator: (v) => Validators.notEmpty(v, 'Le pays est requis'),
              ),
              const SizedBox(height: 22),
              Text(
                'Aperçu de la position',
                style: AppTextStyles.labelCaps.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 10),
              const MapPreview(),
            ],
          ),
        ),
      ),
    );
  }
}
