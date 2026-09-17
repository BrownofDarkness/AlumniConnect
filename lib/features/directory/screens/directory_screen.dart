import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/core/utils/responsive.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/directory/providers/filters_state.dart';
import 'package:allumni_connect/features/directory/widgets/alumni_card.dart';
import 'package:allumni_connect/features/directory/widgets/directory_search_bar.dart';
import 'package:allumni_connect/features/directory/widgets/filters_bottom_sheet.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/routing/routes.dart';

class DirectoryScreen extends ConsumerWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Alumni>> streamState = ref.watch(alumniStreamProvider);
    final FiltersState filters = ref.watch(filtersProvider);
    final FiltersNotifier notifier = ref.read(filtersProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Annuaire')),
      body: SafeArea(
        child: streamState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _ErrorState(
            onRetry: () => ref.invalidate(alumniStreamProvider),
          ),
          data: (List<Alumni> _) => _buildLoaded(context, ref, filters, notifier),
        ),
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    WidgetRef ref,
    FiltersState filters,
    FiltersNotifier notifier,
  ) {
    final List<Alumni> alumni = ref.watch(filteredAlumniProvider);
    final List<Alumni> all = ref.watch(alumniListProvider);

    return Column(
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
              ? (all.isEmpty && !filters.hasActiveFilters
                  ? const _DirectoryEmptyState()
                  : _NoResultsState(onReset: notifier.reset))
              : _AlumniListView(
                  alumni: alumni,
                  filters: filters,
                  ref: ref,
                ),
        ),
      ],
    );
  }
}

class _AlumniListView extends StatelessWidget {
  const _AlumniListView({
    required this.alumni,
    required this.filters,
    required this.ref,
  });

  final List<Alumni> alumni;
  final FiltersState filters;
  final WidgetRef ref;

  void _openDetail(BuildContext context, Alumni a) {
    context.pushNamed(
      RouteName.alumniDetail,
      pathParameters: {'id': a.id},
    );
  }

  String? _distanceLabel(Alumni a) {
    if (!filters.proximityEnabled) return null;
    return GeoUtils.format(ref.watch(distanceKmProvider(a)));
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding = EdgeInsets.fromLTRB(
      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl,
    );

    if (context.isTablet) {
      return GridView.builder(
        padding: padding,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 360,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisExtent: 108,
        ),
        itemCount: alumni.length,
        itemBuilder: (context, index) {
          final Alumni a = alumni[index];
          return AlumniCard(
            alumni: a,
            distanceLabel: _distanceLabel(a),
            onTap: () => _openDetail(context, a),
          );
        },
      );
    }

    return ListView.separated(
      padding: padding,
      itemCount: alumni.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final Alumni a = alumni[index];
        return AlumniCard(
          alumni: a,
          distanceLabel: _distanceLabel(a),
          onTap: () => _openDetail(context, a),
        );
      },
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
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: scheme.onSurface)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
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
                color: scheme.outline.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_off_rounded, color: scheme.onSurfaceVariant, size: 32),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Aucun résultat', style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aucun alumni ne correspond à votre recherche.\nEssayez d\'autres critères.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
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

class _DirectoryEmptyState extends StatelessWidget {
  const _DirectoryEmptyState();

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
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
                color: scheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.groups_2_outlined, color: scheme.primary, size: 32),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text("L'annuaire est vide", style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              kDebugMode
                  ? 'Aucun alumni pour le moment.\nUtilise Réglages → Debug → « Peupler l\'annuaire » pour créer 19 profils de test.'
                  : "Aucun alumni pour le moment.\nInvite tes anciens camarades à rejoindre la communauté.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: scheme.error, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text('Impossible de charger l\'annuaire',
                style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Vérifie ta connexion internet.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
