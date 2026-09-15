import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../core/utils/custom_exceptions.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String adress;

  LocationResult({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.adress,
  });
}

class LocationService {

  static final Geocoding _geocoding = Geocoding();

  /// Récupérer ma position GPS actuelle
  static Future<LocationResult> getCurrentLocation() async {
    // Vérifier si le service de localisation est activé
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException("Le service de localisation est désactivé.");
    }

    // Vérifier / demander la permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionException("Permission de localisation refusée.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionException(
        "Permission refusée définitivement. Ouvrez les paramètres de l'app.",
      );
    }

    // Récupérer la position
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    // Reverse geocoding : coordonnées -> ville/pays
    final placemarks = await _geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      throw LocationServiceException("Impossible de déterminer la ville/pays.");
    }

    final p = placemarks.first;
    return LocationResult(
      latitude: position.latitude,
      longitude: position.longitude,
      city: p.locality ?? p.subAdministrativeArea ?? '',
      country: p.country ?? '',
      adress: p.subLocality?? p.street??''
    );
  }

  /// Récupérer la position à partir d'une adresse saisie manuellement
  static Future<LocationResult> getLocationFromAddress({
    required String address,
    required String city,
    required String country,
  }) async {
    final fullAddress = '$address, $city, $country';
    final locations = await _geocoding.locationFromAddress(fullAddress);

    if (locations.isEmpty) {
      throw LocationServiceException("Adresse introuvable.");
    }

    final loc = locations.first;
    return LocationResult(
      latitude: loc.latitude,
      longitude: loc.longitude,
      city: city,
      country: country,
      adress: address,
    );
  }
}
