import 'dart:math' as math;

/// Utilitaires géographiques — calcul de distance entre deux points.
///
/// Utilisé par le filtre de proximité géographique (recherche par rayon).
class GeoUtils {
  GeoUtils._();

  static const double _earthRadiusKm = 6371.0;

  /// Distance en kilomètres entre deux points (formule de Haversine).
  static double distanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  static double _degToRad(double deg) => deg * (math.pi / 180);

  /// Formatte une distance pour l'affichage ("2.4 km", "850 m").
  static String format(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
}
