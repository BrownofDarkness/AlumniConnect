import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_snackbar.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';

class EditBioSheet extends ConsumerStatefulWidget {
  const EditBioSheet({super.key, required this.initialBio});

  final String initialBio;

  static Future<void> show(BuildContext context, {required String initialBio}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditBioSheet(initialBio: initialBio),
    );
  }

  @override
  ConsumerState<EditBioSheet> createState() => _EditBioSheetState();
}

class _EditBioSheetState extends ConsumerState<EditBioSheet> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialBio);
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final me = ref.read(currentAlumniProvider).value;
    if (me == null) return;

    FocusScope.of(context).unfocus();
    setState(() => _saving = true);

    try {
      await ref.read(alumniRepositoryProvider).updateFields(me.id, {
        'bio': _controller.text.trim(),
      });
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppSnackBar.error(context, 'Impossible d\'enregistrer. Réessaie.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Modifier « À propos »', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'À propos',
                controller: _controller,
                maxLines: 5,
                minLines: 3,
                isOptional: true,
                enabled: !_saving,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: 'Enregistrer',
                onPressed: _save,
                state: _saving ? ButtonState.loading : ButtonState.enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
