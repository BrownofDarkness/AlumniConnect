import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/directory/providers/filters_state.dart';
import 'package:allumni_connect/features/directory/widgets/alumni_card.dart';
import 'package:allumni_connect/features/directory/widgets/directory_search_bar.dart';
import 'package:allumni_connect/features/directory/widgets/filters_bottom_sheet.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/routing/routes.dart';

/// Écran principal de l'annuaire : recherche, filtres actifs en raccourci,
/// liste des cartes alumni (ou état vide).
class DirectoryScreen extends ConsumerWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Alumni> alumni = ref.watch(filteredAlumniProvider);
    final FiltersState filters = ref.watch(filtersProvider);
    final FiltersNotifier notifier = ref.read(filtersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Annuaire')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
              ),
              child: DirectorySearchBar(
                initialValue: filters.query,
                onChanged: notifier.setQuery,
                onFilterTap: () => FiltersBottomSheet.show(context),
                activeFilterCount: filters.activeCount,
              ),
            ),
            if (filters.hasActiveFilters)
              _ActiveFiltersRow(filters: filters, notifier: notifier),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: alumni.isEmpty
                  ? _EmptyState(onReset: notifier.reset)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl,
                      ),
                      itemCount: alumni.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final Alumni a = alumni[index];
                        final String? distanceLabel = filters.proximityEnabled
                            ? GeoUtils.format(ref.watch(distanceKmProvider(a)))
                            : null;
                        return AlumniCard(
                          alumni: a,
                          distanceLabel: distanceLabel,
                          onTap: () => context.pushNamed(
                            RouteName.alumniDetail,
                            pathParameters: {'id': a.id},
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  const _ActiveFiltersRow({required this.filters, required this.notifier});

  final FiltersState filters;
  final FiltersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = [];

    if (filters.proximityEnabled) {
      chips.add(_RemovableChip(
        label: 'Autour de moi · ${filters.radiusKm.round()} km',
        onRemove: () => notifier.setProximityEnabled(false),
      ));
    }
    if (filters.country != null) {
      chips.add(_RemovableChip(
        label: filters.country!,
        onRemove: () => notifier.setCountry(null),
      ));
    }
    if (filters.city != null) {
      chips.add(_RemovableChip(
        label: filters.city!,
        onRemove: () => notifier.setCity(null),
      ));
    }
    if (filters.promotion != null) {
      chips.add(_RemovableChip(
        label: 'Promo ${filters.promotion}',
        onRemove: () => notifier.setPromotion(null),
      ));
    }
    for (final f in filters.filieres) {
      chips.add(_RemovableChip(
        label: f,
        onRemove: () => notifier.toggleFiliere(f),
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: chips.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
          itemBuilder: (context, index) => chips[index],
        ),
      ),
    );
  }
}

class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.divider.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, color: AppColors.muted, size: 32),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Aucun résultat', style: AppTextStyles.title.copyWith(color: AppColors.ink)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aucun alumni ne correspond à votre recherche.\nEssayez d\'autres critères.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: onReset,
              child: const Text('Réinitialiser les filtres'),
            ),
          ],
        ),
      ),
    );
  }
}
