import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/models/alumni.dart';

/// Rayon (km) affiché/filtré sur la carte, indépendant du filtre de
/// proximité de l'annuaire (chip "Rayon" dédié à cet écran).
class MapRadiusNotifier extends Notifier<double> {
  @override
  double build() => 50;

  void setRadiusKm(double value) => state = value;
}

final NotifierProvider<MapRadiusNotifier, double> mapRadiusKmProvider =
    NotifierProvider<MapRadiusNotifier, double>(MapRadiusNotifier.new);

/// Id de l'alumni sélectionné (pin tapée), affiché dans la fiche flottante.
class SelectedAlumniNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String id) => state = state == id ? null : id;

  void clear() => state = null;
}

final NotifierProvider<SelectedAlumniNotifier, String?> selectedAlumniIdProvider =
    NotifierProvider<SelectedAlumniNotifier, String?>(SelectedAlumniNotifier.new);

/// Alumni affichés sur la carte : dataset filtré (recherche/promo/filière
/// partagé avec l'annuaire, [filteredAlumniProvider]) restreint au rayon
/// choisi sur cet écran, triés du plus proche au plus loin.
final Provider<List<Alumni>> nearbyAlumniProvider = Provider<List<Alumni>>((ref) {
  final List<Alumni> filtered = ref.watch(filteredAlumniProvider);
  final double radiusKm = ref.watch(mapRadiusKmProvider);
  final ({double lat, double lng}) refPos = ref.watch(referencePositionProvider);

  double distanceTo(Alumni a) => GeoUtils.distanceKm(
        lat1: refPos.lat,
        lon1: refPos.lng,
        lat2: a.latitude,
        lon2: a.longitude,
      );

  return filtered.where((a) => distanceTo(a) <= radiusKm).toList()
    ..sort((a, b) => distanceTo(a).compareTo(distanceTo(b)));
});

/// Alumni actuellement sélectionné (ou `null`), résolu depuis
/// [selectedAlumniIdProvider].
final Provider<Alumni?> selectedAlumniProvider = Provider<Alumni?>((ref) {
  final String? id = ref.watch(selectedAlumniIdProvider);
  if (id == null) return null;
  return ref.watch(alumniByIdProvider(id));
});

/// Centre de la carte = position de référence (mock en attendant le
/// branchement GPS temps réel, voir [referencePositionProvider]).
final Provider<LatLng> mapCenterProvider = Provider<LatLng>((ref) {
  final ({double lat, double lng}) refPos = ref.watch(referencePositionProvider);
  return LatLng(refPos.lat, refPos.lng);
});
