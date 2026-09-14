import 'package:allumni_connect/models/alumni.dart';

/// Helpers d'affichage pour [Alumni].
///
/// Regroupés en extension pour ne pas modifier le modèle partagé.
extension AlumniX on Alumni {
  String get nomComplet => '$prenom $nom';

  String get initiales {
    final String p = prenom.isNotEmpty ? prenom[0] : '';
    final String n = nom.isNotEmpty ? nom[0] : '';
    return ('$p$n').toUpperCase();
  }

  String get promotionLabel => 'Promo $promotion';

  String get localisationCourte =>
      ville.isNotEmpty ? '$ville, $pays' : pays;

  /// Lien Google Maps universel à partir des coordonnées enregistrées.
  String get mapsSearchUrl =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  /// URL LinkedIn nettoyée (ajoute https:// si l'utilisateur a saisi
  /// uniquement le nom d'utilisateur ou une URL sans schéma).
  String get linkedinUrl {
    final String value = linkedin.trim();
    if (value.isEmpty) return value;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    if (value.startsWith('linkedin.com') || value.startsWith('www.linkedin.com')) {
      return 'https://$value';
    }
    return 'https://linkedin.com/in/$value';
  }
}
