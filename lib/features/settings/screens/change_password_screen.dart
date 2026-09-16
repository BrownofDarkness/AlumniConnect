import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/custom_exceptions.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirme ton mot de passe';
    if (v != _next.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  Future<void> _save() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    final auth = ref.read(authServiceProvider);
    try {
      await auth.reauthenticateWithPassword(_current.text);
      await auth.updatePassword(_next.text);
      if (!mounted) return;
      AppSnackBar.success(context, 'Mot de passe mis à jour.');
      Navigator.of(context).pop();
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppSnackBar.error(context, e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      AppSnackBar.error(context, 'Une erreur est survenue. Réessaie.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl,
          ),
          children: [
            Text(
              'Pour ta sécurité, saisis ton mot de passe actuel avant d\'en choisir un nouveau.',
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Mot de passe actuel',
              controller: _current,
              isPassword: true,
              textInputAction: TextInputAction.next,
              validator: Validators.loginPassword,
              enabled: !_submitting,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Nouveau mot de passe',
              controller: _next,
              isPassword: true,
              textInputAction: TextInputAction.next,
              validator: Validators.strongPassword,
              enabled: !_submitting,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Confirmer le nouveau mot de passe',
              controller: _confirm,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: _validateConfirm,
              enabled: !_submitting,
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: 'Mettre à jour',
              onPressed: _save,
              state: _submitting ? ButtonState.loading : ButtonState.enabled,
            ),
          ],
        ),
      ),
    );
  }
}
