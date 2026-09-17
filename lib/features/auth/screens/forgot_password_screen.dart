import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/custom_exceptions.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/routing/routes.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  ButtonState _state = ButtonState.enabled;
  String? _sentTo;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _state = ButtonState.loading);
    final String email = _email.text.trim();

    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() {
        _state = ButtonState.enabled;
        _sentTo = email;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _state = ButtonState.enabled);
      AppSnackBar.error(context, e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = ButtonState.enabled);
      AppSnackBar.error(context, 'Une erreur est survenue. Réessaie dans un instant.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(RouteName.login),
        ),
      ),
      body: SafeArea(
        child: _sentTo == null ? _buildForm() : _buildSuccess(),
      ),
    );
  }

  Widget _buildForm() {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isLoading = _state == ButtonState.loading;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mail_outline_rounded, color: scheme.primary, size: 32),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Mot de passe oublié',
              textAlign: TextAlign.center,
              style: AppTextStyles.display.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Renseigne ton adresse email. Nous t'enverrons un lien pour créer un nouveau mot de passe.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 40),
            AppTextField(
              label: 'Adresse email',
              hint: 'toi@exemple.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              onFieldSubmitted: (_) => _submit(),
              enabled: !isLoading,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: 'Envoyer le lien',
              onPressed: _submit,
              state: _state,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mail_outline_rounded, color: scheme.primary, size: 40),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFF059669),
                      child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Email envoyé',
            textAlign: TextAlign.center,
            style: AppTextStyles.display.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text.rich(
            TextSpan(
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
              children: [
                const TextSpan(text: 'Un lien de récupération a été envoyé à '),
                TextSpan(
                  text: _sentTo,
                  style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: '. Vérifie ta boîte de réception pour continuer.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton.primary(
            label: 'Retour à la connexion',
            onPressed: () => context.goNamed(RouteName.login),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => setState(() => _sentTo = null),
            child: const Text("Utiliser une autre adresse"),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
