import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/directory/providers/filters_state.dart';
import 'package:allumni_connect/models/alumni.dart';

final StreamProvider<List<Alumni>> alumniStreamProvider =
    StreamProvider<List<Alumni>>((ref) {
  return ref.watch(alumniRepositoryProvider).watchAllAlumni();
});

final Provider<List<Alumni>> alumniListProvider = Provider<List<Alumni>>((ref) {
  return ref.watch(alumniStreamProvider).value ?? const <Alumni>[];
});

final Provider<({double lat, double lng})?> referencePositionProvider =
    Provider<({double lat, double lng})?>((ref) {
  final me = ref.watch(currentAlumniProvider).value;
  if (me == null) return null;
  return (lat: me.latitude, lng: me.longitude);
});

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

final Provider<List<Alumni>> filteredAlumniProvider = Provider<List<Alumni>>((ref) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  final FiltersState filters = ref.watch(filtersProvider);
  final ({double lat, double lng})? refPos = ref.watch(referencePositionProvider);
  final String? myUid = ref.watch(currentUserProvider)?.uid;

  Iterable<Alumni> result = all.where(
    (a) => a.profilComplet && a.id != myUid,
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

  if (filters.proximityEnabled && refPos != null) {
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

final distanceKmProvider =
    Provider.family<double, Alumni>((ref, alumni) {
  final ({double lat, double lng})? refPos = ref.watch(referencePositionProvider);
  if (refPos == null) return double.infinity;
  return GeoUtils.distanceKm(
    lat1: refPos.lat,
    lon1: refPos.lng,
    lat2: alumni.latitude,
    lon2: alumni.longitude,
  );
});

final Provider<Map<String, int>> cityCountsProvider =
    Provider<Map<String, int>>((ref) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  final Map<String, int> counts = <String, int>{};
  for (final Alumni a in all) {
    counts[a.ville] = (counts[a.ville] ?? 0) + 1;
  }
  return counts;
});

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

final alumniByIdProvider =
    Provider.family<Alumni?, String>((ref, id) {
  final List<Alumni> all = ref.watch(alumniListProvider);
  for (final Alumni a in all) {
    if (a.id == id) return a;
  }
  return null;
});
