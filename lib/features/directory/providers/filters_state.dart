/// État immuable du panneau de filtres de l'annuaire.
///
/// `null` pour [country] / [city] / [promotion] signifie "tous" (aucun
/// filtre appliqué sur ce critère). [filieres] est un ensemble car la
/// spécialité est multi-sélectionnable, contrairement aux autres critères.
class FiltersState {
  final String query;
  final String? country;
  final String? city;
  final String? promotion;
  final Set<String> filieres;
  final bool proximityEnabled;
  final double radiusKm;

  const FiltersState({
    this.query = '',
    this.country,
    this.city,
    this.promotion,
    this.filieres = const <String>{},
    this.proximityEnabled = false,
    this.radiusKm = 50,
  });

  static const FiltersState initial = FiltersState();

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      country != null ||
      city != null ||
      promotion != null ||
      filieres.isNotEmpty ||
      proximityEnabled;

  /// Nombre de critères actifs, affiché en badge sur le bouton "Filtres".
  int get activeCount {
    int count = 0;
    if (country != null) count++;
    if (city != null) count++;
    if (promotion != null) count++;
    if (filieres.isNotEmpty) count++;
    if (proximityEnabled) count++;
    return count;
  }

  FiltersState copyWith({
    String? query,
    String? country,
    bool clearCountry = false,
    String? city,
    bool clearCity = false,
    String? promotion,
    bool clearPromotion = false,
    Set<String>? filieres,
    bool? proximityEnabled,
    double? radiusKm,
  }) {
    return FiltersState(
      query: query ?? this.query,
      country: clearCountry ? null : (country ?? this.country),
      city: clearCity ? null : (city ?? this.city),
      promotion: clearPromotion ? null : (promotion ?? this.promotion),
      filieres: filieres ?? this.filieres,
      proximityEnabled: proximityEnabled ?? this.proximityEnabled,
      radiusKm: radiusKm ?? this.radiusKm,
    );
  }
}
