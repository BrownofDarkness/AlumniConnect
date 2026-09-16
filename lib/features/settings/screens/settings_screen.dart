import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/providers/theme_mode_provider.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/dev/dev_seeder.dart';
import 'package:allumni_connect/routing/routes.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ThemeMode themeMode =
        ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(RouteName.myProfile),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        children: [
          _GroupLabel(label: 'Apparence'),
          _SettingsGroup(children: [
            _SettingsRow(
              label: 'Thème',
              trailing: _ThemeSegmented(
                mode: themeMode,
                onChanged: (m) => ref.read(themeModeProvider.notifier).set(m),
              ),
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _GroupLabel(label: 'Sécurité'),
          _SettingsGroup(children: [
            _NavRow(
              label: 'Changer le mot de passe',
              onTap: () => context.pushNamed(RouteName.changePassword),
            ),
            _NavRow(
              label: 'Sessions actives',
              onTap: () => AppSnackBar.info(context, 'Bientôt disponible.'),
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _GroupLabel(label: 'Visibilité'),
          _SettingsGroup(children: [
            _ToggleRow(
              label: 'Profil visible dans l\'annuaire',
              description: 'Les autres alumni peuvent me trouver',
              value: true,
              onChanged: (_) => AppSnackBar.info(context, 'Bientôt disponible.'),
            ),
            _ToggleRow(
              label: 'Position visible sur la carte',
              description: 'Mon point apparaît sur la carte publique',
              value: true,
              onChanged: (_) => AppSnackBar.info(context, 'Bientôt disponible.'),
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _GroupLabel(label: 'Communauté'),
          _SettingsGroup(children: [
            _NavRow(
              label: "À propos d'AlumniConnect",
              onTap: () => AppSnackBar.info(context, 'Bientôt disponible.'),
            ),
            _NavRow(
              label: "Conditions d'utilisation",
              onTap: () => AppSnackBar.info(context, 'Bientôt disponible.'),
            ),
          ]),
          if (kDebugMode) ...[
            _GroupLabel(label: 'Debug'),
            _SettingsGroup(children: [
              _SeedRow(onTap: () => _confirmSeed(context, ref)),
            ]),
          ],
          const SizedBox(height: AppSpacing.xl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: OutlinedButton(
              onPressed: () => _confirmSignOut(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.6), width: 1.5),
              ),
              child: const Text('Se déconnecter'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              'Version 1.0 · Groupe 11',
              style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _confirmSeed(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Peupler l'annuaire"),
        content: const Text(
          "Crée 19 profils de test dans Firestore (alum_001 à alum_019). "
          "Les profils déjà présents seront ignorés.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Lancer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    final NavigatorState rootNavigator = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final report =
          await DevSeeder(ref.read(alumniRepositoryProvider)).run();
      rootNavigator.pop();
      if (!context.mounted) return;
      final String msg;
      if (report.created == 0) {
        msg = 'Rien à faire, ${report.total} profils déjà présents.';
      } else if (report.skipped == 0) {
        msg = '${report.created} profils créés.';
      } else {
        msg = '${report.created} ajoutés · ${report.skipped} déjà présents.';
      }
      AppSnackBar.success(context, msg);
    } catch (_) {
      rootNavigator.pop();
      if (!context.mounted) return;
      AppSnackBar.error(
        context,
        "Impossible de peupler l'annuaire. Vérifie les règles Firestore.",
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Tu devras te reconnecter avec ton email et mot de passe.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authServiceProvider).signOut();
    }
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelCaps.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<Widget> rows = [];
    for (int i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) {
        rows.add(Divider(height: 1, color: scheme.outline));
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(children: rows),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.trailing, this.description});
  final String label;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body.copyWith(color: scheme.onSurface)),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          trailing,
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyles.body.copyWith(color: scheme.onSurface)),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsRow(
      label: label,
      description: description,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _SeedRow extends StatelessWidget {
  const _SeedRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(Icons.storage_rounded, size: 20, color: scheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Peupler l'annuaire de test",
                    style: AppTextStyles.body.copyWith(color: scheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '19 profils · idempotent',
                    style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ThemeSegmented extends StatelessWidget {
  const _ThemeSegmented({required this.mode, required this.onChanged});
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.light, label: Text('Clair')),
        ButtonSegment(value: ThemeMode.dark, label: Text('Sombre')),
        ButtonSegment(value: ThemeMode.system, label: Text('Auto')),
      ],
      selected: {mode},
      onSelectionChanged: (Set<ThemeMode> s) => onChanged(s.first),
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(AppTextStyles.caption),
      ),
    );
  }
}
