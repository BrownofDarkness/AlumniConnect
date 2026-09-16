import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/features/directory/data/mock_alumni_repository.dart';
import 'package:allumni_connect/features/directory/providers/filters_state.dart';

/// Dataset alumni.
///
/// TODO : remplacer ce Provider par un StreamProvider branché sur
/// FirestoreService une fois le service implémenté. Le reste de l'UI
/// (filteredAlumniProvider, écrans) n'aura pas à changer.
final Provider<List<Alumni>> alumniListProvider = Provider<List<Alumni>>((ref) {
  return MockAlumniRepository.all;
});

/// Alumni actuellement connecté (mock), initialisé depuis
/// [MockAlumniRepository.currentAlumniId] tant que l'authentification n'est
/// pas branchée à un vrai profil. Modifiable via [update] (écran "Modifier
/// mon profil") tant qu'il n'y a pas de FirestoreService pour persister.
class CurrentAlumniNotifier extends Notifier<Alumni> {
  @override
  Alumni build() {
    return ref
        .watch(alumniListProvider)
        .firstWhere((a) => a.id == MockAlumniRepository.currentAlumniId);
  }

  void update(Alumni updated) => state = updated;
}

final NotifierProvider<CurrentAlumniNotifier, Alumni> currentAlumniProvider =
    NotifierProvider<CurrentAlumniNotifier, Alumni>(CurrentAlumniNotifier.new);

/// Position de référence de l'alumni connecté, utilisée par le filtre de
/// proximité géographique.
///
/// TODO : remplacer par la position réelle du profil (LocationService /
/// document Firestore de l'utilisateur connecté).
final Provider<({double lat, double lng})> referencePositionProvider =
    Provider<({double lat, double lng})>((ref) {
  final Alumni me = ref.watch(currentAlumniProvider);
  return (lat: me.latitude, lng: me.longitude);
});

/// Notifier gérant l'état du panneau de filtres.
class FiltersNotifier extends Notifier<FiltersState> {
  @override
  FiltersState build() => FiltersState.initial;

  void setQuery(String value) => state = state.copyWith(query: value);

  void setCountry(String? value) {
    if (value == null) {
      state = state.copyWith(clearCountry: true, clearCity: true);
    } else {
      state = state.copyWith(country: value, clearCity: true);
    }
  }

  void setCity(String? value) {
    state = value == null
        ? state.copyWith(clearCity: true)
        : state.copyWith(city: value);
  }

  void setPromotion(String? value) {
    state = value == null
        ? state.copyWith(clearPromotion: true)
        : state.copyWith(promotion: value);
  }

  void toggleFiliere(String filiere) {
    final Set<String> next = Set<String>.from(state.filieres);
    if (!next.remove(filiere)) {
      next.add(filiere);
    }
    state = state.copyWith(filieres: next);
  }

  void setProximityEnabled(bool value) =>
      state = state.copyWith(proximityEnabled: value);

  void setRadiusKm(double value) => state = state.copyWith(radiusKm: value);

  void reset() => state = FiltersState.initial;
}

final NotifierProvider<FiltersNotifier, FiltersState> filtersProvider =
    NotifierProvider<FiltersNotifier, FiltersState>(FiltersNotifier.new);

/// Liste alumni filtrée + triée en fonction de [filtersProvider].
///
/// Le tri par proximité (du plus proche au plus éloigné) ne s'applique
/// que lorsque le filtre de proximité est actif, conformément au parcours
/// utilisateur défini dans la documentation produit.
final Provider<List<Alumni>> filteredAlumniProvider = Provider<List<Alumni>>((ref) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  final FiltersState filters = ref.watch(filtersProvider);
  final ({double lat, double lng}) refPos = ref.watch(referencePositionProvider);

  Iterable<Alumni> result = all.where(
    (a) => a.profilComplet && a.id != MockAlumniRepository.currentAlumniId,
  );

  if (filters.query.trim().isNotEmpty) {
    final String q = filters.query.trim().toLowerCase();
    result = result.where((a) =>
        '${a.prenom} ${a.nom}'.toLowerCase().contains(q) ||
        a.entreprise.toLowerCase().contains(q) ||
        a.ville.toLowerCase().contains(q));
  }

  if (filters.country != null) {
    result = result.where((a) => a.pays == filters.country);
  }

  if (filters.city != null) {
    result = result.where((a) => a.ville == filters.city);
  }

  if (filters.promotion != null) {
    result = result.where((a) => a.promotion == filters.promotion);
  }

  if (filters.filieres.isNotEmpty) {
    result = result.where((a) => filters.filieres.contains(a.filiere));
  }

  List<Alumni> list = result.toList();

  if (filters.proximityEnabled) {
    list = list.where((a) {
      final double d = GeoUtils.distanceKm(
        lat1: refPos.lat,
        lon1: refPos.lng,
        lat2: a.latitude,
        lon2: a.longitude,
      );
      return d <= filters.radiusKm;
    }).toList()
      ..sort((a, b) {
        final double da = GeoUtils.distanceKm(
          lat1: refPos.lat,
          lon1: refPos.lng,
          lat2: a.latitude,
          lon2: a.longitude,
        );
        final double db = GeoUtils.distanceKm(
          lat1: refPos.lat,
          lon1: refPos.lng,
          lat2: b.latitude,
          lon2: b.longitude,
        );
        return da.compareTo(db);
      });
  } else {
    list.sort((a, b) => a.nom.compareTo(b.nom));
  }

  return list;
});

/// Distance (km) entre un alumni et la position de référence — utilisé pour
/// afficher "À 2.4 km" sur la fiche détaillée / la carte.
final distanceKmProvider =
    Provider.family<double, Alumni>((ref, alumni) {
  final ({double lat, double lng}) refPos = ref.watch(referencePositionProvider);
  return GeoUtils.distanceKm(
    lat1: refPos.lat,
    lon1: refPos.lng,
    lat2: alumni.latitude,
    lon2: alumni.longitude,
  );
});

/// Nombre d'alumni par ville (dataset complet, indépendant des filtres
/// actifs) — utilisé pour les compteurs à côté de chaque chip ville.
final Provider<Map<String, int>> cityCountsProvider =
    Provider<Map<String, int>>((ref) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  final Map<String, int> counts = <String, int>{};
  for (final Alumni a in all) {
    counts[a.ville] = (counts[a.ville] ?? 0) + 1;
  }
  return counts;
});

/// Liste des pays représentés dans la communauté, triée par nombre
/// d'alumni décroissant.
final Provider<List<String>> availableCountriesProvider =
    Provider<List<String>>((ref) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  final Map<String, int> counts = <String, int>{};
  for (final Alumni a in all) {
    counts[a.pays] = (counts[a.pays] ?? 0) + 1;
  }
  final List<String> countries = counts.keys.toList()
    ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
  return countries;
});

/// Villes disponibles pour un pays donné (ou toutes si `country` est null),
/// triées par nombre d'alumni décroissant.
final availableCitiesProvider =
    Provider.family<List<String>, String?>((ref, country) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  final Map<String, int> counts = <String, int>{};
  for (final Alumni a in all) {
    if (country != null && a.pays != country) continue;
    counts[a.ville] = (counts[a.ville] ?? 0) + 1;
  }
  final List<String> cities = counts.keys.toList()
    ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
  return cities;
});

/// Récupère un alumni par id dans le dataset courant (mock ou Firestore
/// plus tard) — utilisé par la fiche détaillée.
final alumniByIdProvider =
    Provider.family<Alumni?, String>((ref, id) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  for (final Alumni a in all) {
    if (a.id == id) return a;
  }
  return null;
});
