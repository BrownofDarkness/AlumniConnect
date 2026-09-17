import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/custom_exceptions.dart';
import 'package:allumni_connect/core/utils/validators.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/routing/routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  ButtonState _submitState = ButtonState.enabled;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitState = ButtonState.loading);

    try {
      await ref.read(authServiceProvider).signInWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
          );
      // Sur succès, le router redirect s'occupe de la navigation
      // (onboarding si profilComplet=false, directory sinon).
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _submitState = ButtonState.enabled);
      AppSnackBar.error(context, e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitState = ButtonState.enabled);
      AppSnackBar.error(context, 'Une erreur est survenue. Réessaie dans un instant.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _submitState == ButtonState.loading;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          _brandLockup(),
                          const SizedBox(height: 68),
                          _headline(),
                          const SizedBox(height: 44),
                          _form(isLoading),
                          const SizedBox(height: 40),
                          AppButton.primary(
                            label: 'Se connecter',
                            onPressed: _submit,
                            state: _submitState,
                          ),
                          const Spacer(),
                          _footerNote(),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _brandLockup() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/logo.png',
            width: 34,
            height: 34,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'AlumniConnect',
          style: AppTextStyles.heading.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _headline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bon retour',
          style: AppTextStyles.display.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Connecte-toi à ton compte pour rejoindre la communauté.',
          style: AppTextStyles.bodyLg.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _form(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'Adresse email',
          hint: 'toi@exemple.com',
          controller: _emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
          onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
          enabled: !isLoading,
        ),
        const SizedBox(height: 18),
        AppTextField(
          label: 'Mot de passe',
          hint: '••••••••',
          controller: _passwordController,
          focusNode: _passwordFocus,
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: Validators.loginPassword,
          onFieldSubmitted: (_) => _submit(),
          enabled: !isLoading,
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading ? null : () => context.goNamed(RouteName.forgotPassword),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Mot de passe oublié ?',
              style: AppTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerNote() {
    return Center(
      child: Text(
        "L'inscription se fait uniquement sur invitation.",
        style: AppTextStyles.body.copyWith(color: AppColors.muted),
        textAlign: TextAlign.center,
      ),
    );
  }
}
