import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';

/// Barre de recherche de l'annuaire, avec bouton filtre et badge de
/// filtres actifs.
class DirectorySearchBar extends StatelessWidget {
  const DirectorySearchBar({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
    this.activeFilterCount = 0,
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final int activeFilterCount;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: AppTextStyles.body.copyWith(color: scheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Rechercher une ville, promo, membre…',
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _FilterButton(
          onTap: onFilterTap,
          activeCount: activeFilterCount,
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap, required this.activeCount});

  final VoidCallback onTap;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final bool isActive = activeCount > 0;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: isActive ? scheme.primary : scheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isActive ? Colors.transparent : AppColors.divider,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(
                  Icons.tune_rounded,
                  color: isActive ? Colors.white : scheme.onSurface,
                  size: 22,
                ),
              ),
              if (isActive)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$activeCount',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
