import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/features/directory/data/mock_alumni_repository.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/directory/providers/filters_state.dart';

/// Panneau de filtres avancés de l'annuaire.
///
/// Regroupe tous les critères combinables (proximité, pays, ville,
/// promotion, filière) dans un seul écran, conformément au parcours
/// utilisateur ("un panneau unique regroupant tous les critères").
///
/// Inspiré du rendu haute-fidélité (captures) plutôt que du wireframe
/// basse-fidélité de la maquette UX/UI.
class FiltersBottomSheet extends ConsumerStatefulWidget {
  const FiltersBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FiltersBottomSheet(),
    );
  }

  @override
  ConsumerState<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends ConsumerState<FiltersBottomSheet> {
  final TextEditingController _citySearchController = TextEditingController();
  String _citySearch = '';

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final FiltersState filters = ref.watch(filtersProvider);
    final FiltersNotifier notifier = ref.read(filtersProvider.notifier);
    final List<String> countries = ref.watch(availableCountriesProvider);
    final List<String> cities = ref.watch(availableCitiesProvider(filters.country));
    final Map<String, int> cityCounts = ref.watch(cityCountsProvider);
    final int resultCount = ref.watch(filteredAlumniProvider).length;

    final List<String> filteredCities = _citySearch.isEmpty
        ? cities
        : cities
            .where((c) => c.toLowerCase().contains(_citySearch.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
                ),
                child: Row(
                  children: [
                    Icon(Icons.tune_rounded, color: scheme.onSurface),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Filtres de recherche',
                        style: AppTextStyles.title.copyWith(color: scheme.onSurface),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        notifier.reset();
                        _citySearchController.clear();
                        setState(() => _citySearch = '');
                      },
                      child: const Text('Tout effacer'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl,
                  ),
                  children: [
                    _ProximityCard(
                      enabled: filters.proximityEnabled,
                      radiusKm: filters.radiusKm,
                      onToggle: notifier.setProximityEnabled,
                      onRadiusChanged: notifier.setRadiusKm,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _SectionLabel(
                      icon: Icons.public_rounded,
                      title: 'Filtrer par Pays',
                      trailing: '${countries.length} pays représentés',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _ChoiceChipPill(
                            label: 'Tous les pays',
                            selected: filters.country == null,
                            onTap: () => notifier.setCountry(null),
                          ),
                          for (final c in countries) ...[
                            const SizedBox(width: AppSpacing.xs),
                            _ChoiceChipPill(
                              label: c,
                              selected: filters.country == c,
                              onTap: () => notifier.setCountry(
                                filters.country == c ? null : c,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _SectionLabel(
                      icon: Icons.location_city_rounded,
                      title: 'Filtrer par Ville',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _citySearchController,
                      onChanged: (v) => setState(() => _citySearch = v),
                      decoration: const InputDecoration(
                        hintText: 'Rechercher une ville…',
                        prefixIcon: Icon(Icons.search_rounded),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final city in filteredCities)
                          _ChoiceChipPill(
                            label: '$city · ${cityCounts[city] ?? 0}',
                            selected: filters.city == city,
                            onTap: () => notifier.setCity(
                              filters.city == city ? null : city,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _SectionLabel(
                      icon: Icons.school_outlined,
                      title: 'Promotion',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final promo in MockAlumniRepository.promotions)
                          _ChoiceChipPill(
                            label: promo,
                            selected: filters.promotion == promo,
                            onTap: () => notifier.setPromotion(
                              filters.promotion == promo ? null : promo,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const _SectionLabel(
                      icon: Icons.workspace_premium_outlined,
                      title: 'Spécialité & Filière',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final filiere in MockAlumniRepository.filieres)
                          _FiliereChip(
                            label: filiere,
                            selected: filters.filieres.contains(filiere),
                            onTap: () => notifier.toggleFiliere(filiere),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              _ApplyBar(resultCount: resultCount),
            ],
          ),
        );
      },
    );
  }
}

class _ProximityCard extends StatelessWidget {
  const _ProximityCard({
    required this.enabled,
    required this.radiusKm,
    required this.onToggle,
    required this.onRadiusChanged,
  });

  final bool enabled;
  final double radiusKm;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onRadiusChanged;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.near_me_rounded, color: AppColors.success, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proximité géographique',
                        style: AppTextStyles.heading.copyWith(color: scheme.onSurface)),
                    const SizedBox(height: 2),
                    Text(
                      'Localisation en temps réel pour alumni nomades ou en '
                      'déplacement professionnel.',
                      style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                activeThumbColor: AppColors.success,
                onChanged: onToggle,
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.adjust_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Rayon de détection',
                        style: AppTextStyles.bodySm.copyWith(color: scheme.onSurface)),
                  ],
                ),
                _ChoiceChipPill(label: '${radiusKm.round()} km', selected: true, onTap: () {}),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.success,
                thumbColor: AppColors.success,
                inactiveTrackColor: AppColors.success.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: radiusKm,
                min: 10,
                max: 200,
                divisions: 19,
                onChanged: onRadiusChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.onSurface),
        const SizedBox(width: AppSpacing.xs),
        Text(title, style: AppTextStyles.heading.copyWith(color: scheme.onSurface)),
        if (trailing != null) ...[
          const Spacer(),
          Text(trailing!, style: AppTextStyles.caption.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ],
    );
  }
}

class _ChoiceChipPill extends StatelessWidget {
  const _ChoiceChipPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primary : scheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(color: selected ? Colors.transparent : scheme.outline),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: selected ? scheme.onPrimary : scheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _FiliereChip extends StatelessWidget {
  const _FiliereChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (label) {
      case 'Mobile':
        return Icons.phone_iphone_rounded;
      case 'Data & IA':
        return Icons.query_stats_rounded;
      case 'Cloud & DevOps':
        return Icons.cloud_outlined;
      case 'Cybersécurité':
        return Icons.shield_outlined;
      default:
        return Icons.code_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? AppColors.success : scheme.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(color: selected ? Colors.transparent : scheme.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, size: 16, color: selected ? Colors.white : scheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.bodySm.copyWith(
                  color: selected ? Colors.white : scheme.onSurface,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplyBar extends StatelessWidget {
  const _ApplyBar({required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Appliquer les filtres ($resultCount résultat${resultCount > 1 ? 's' : ''})'),
        ),
      ),
    );
  }
}
