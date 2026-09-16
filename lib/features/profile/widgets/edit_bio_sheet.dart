import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/widgets/app_button.dart';
import 'package:allumni_connect/core/widgets/app_text_field.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Panneau de modification scopé à la seule section "À propos" — ne touche
/// à aucun autre champ du profil (identité, parcours pro, localisation).
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final Alumni me = ref.read(currentAlumniProvider);
    ref.read(currentAlumniProvider.notifier).update(me.copyWith(bio: _controller.text.trim()));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
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
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Modifier « À propos »', style: AppTextStyles.title.copyWith(color: AppColors.navy)),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'À propos',
                controller: _controller,
                maxLines: 5,
                minLines: 3,
                isOptional: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(label: 'Enregistrer', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
