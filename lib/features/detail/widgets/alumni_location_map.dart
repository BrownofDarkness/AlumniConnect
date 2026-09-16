import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';

/// Aperçu carte (OpenStreetMap) centré sur la position de l'alumni.
///
/// Non interactif (aperçu uniquement) — le bouton "S'y rendre" ouvre
/// l'itinéraire réel dans l'application Maps de l'appareil.
class AlumniLocationMap extends StatelessWidget {
  const AlumniLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 140,
  });

  final double latitude;
  final double longitude;
  final double height;

  @override
  Widget build(BuildContext context) {
    final LatLng point = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 14,
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.allumni.allumni_connect',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 36,
                  height: 36,
                  alignment: Alignment.bottomCenter,
                  child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 36),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
