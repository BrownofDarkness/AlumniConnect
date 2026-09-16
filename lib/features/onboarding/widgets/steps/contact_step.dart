import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/onboarding/models/onboarding_data.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_step_shell.dart';

class ContactStep extends StatefulWidget {
  final void Function(ContactData) onContinue;
  final VoidCallback onBack;
  final String? personalEmail;

  const ContactStep({
    super.key,
    required this.onContinue,
    required this.onBack,
    this.personalEmail,
  });

  @override
  State<ContactStep> createState() => _ContactStepState();
}

class _ContactStepState extends State<ContactStep> with AutomaticKeepAliveClientMixin {
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _linkedin = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _linkedin.dispose();
    super.dispose();
  }

  void _usePersonalEmail() {
    final personal = widget.personalEmail;
    if (personal == null || personal.isEmpty) return;
    _email.text = personal;
    setState(() {});
  }

  void _handleContinue() {
    FocusScope.of(context).unfocus();
    widget.onContinue(ContactData(
      email: _email.text.trim(),
      telephone: _phone.text.trim(),
      linkedin: _linkedin.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OnboardingStepShell(
      currentStep: 2,
      onBack: widget.onBack,
      bottomAction: AppButton.primary(
        label: 'Continuer',
        onPressed: _handleContinue,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comment te contacter',
              style: AppTextStyles.title.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Facultatif — les autres alumni pourront te joindre via ces canaux si tu les renseignes.',
              style: AppTextStyles.body.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Email professionnel',
              controller: _email,
              hint: 'karim.diallo@airbnb.com',
              prefixIcon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            if (widget.personalEmail != null && widget.personalEmail!.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _usePersonalEmail,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Utiliser mon email de connexion',
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ] else
              const SizedBox(height: 16),
            AppTextField(
              label: 'Téléphone',
              controller: _phone,
              hint: '+237 6 12 34 56 78',
              prefixIcon: LucideIcons.phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Profil LinkedIn',
              controller: _linkedin,
              hint: 'linkedin.com/in/karim-diallo',
              prefixIcon: LucideIcons.link,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
