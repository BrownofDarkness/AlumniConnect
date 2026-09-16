import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/itinerary/widgets/itinerary_route_card.dart';
import 'package:allumni_connect/features/map/widgets/alumni_map_marker.dart';
import 'package:allumni_connect/features/map/widgets/user_location_marker.dart';
import 'package:allumni_connect/models/alumni.dart';

class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key, required this.destinationId});

  final String destinationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Alumni? origin = ref.watch(currentAlumniProvider).value;
    final Alumni? destination = ref.watch(alumniByIdProvider(destinationId));

    if (origin == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Itinéraire')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (destination == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Itinéraire')),
        body: Center(
          child: Text(
            'Cet alumni est introuvable.',
            style: AppTextStyles.body.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final LatLng originPoint = LatLng(origin.latitude, origin.longitude);
    final LatLng destinationPoint = LatLng(destination.latitude, destination.longitude);
    final double distanceKm = GeoUtils.distanceKm(
      lat1: origin.latitude,
      lon1: origin.longitude,
      lat2: destination.latitude,
      lon2: destination.longitude,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Itinéraire')),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: LatLngBounds.fromPoints([originPoint, destinationPoint]),
                  padding: const EdgeInsets.fromLTRB(48, 48, 48, 190),
                  maxZoom: 15,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.allumni.allumni_connect',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [originPoint, destinationPoint],
                      strokeWidth: 3,
                      color: AppColors.primary,
                      pattern: StrokePattern.dashed(segments: const [12, 8]),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: originPoint,
                      width: 100,
                      height: 76,
                      alignment: Alignment.topCenter,
                      child: const UserLocationMarker(),
                    ),
                    Marker(
                      point: destinationPoint,
                      width: AlumniMapMarker.size,
                      height: AlumniMapMarker.size,
                      alignment: Alignment.bottomCenter,
                      child: AlumniMapMarker(
                        alumni: destination,
                        isSelected: true,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ItineraryRouteCard(
              origin: origin,
              destination: destination,
              distanceLabel: GeoUtils.format(distanceKm),
            ),
          ),
        ],
      ),
    );
  }
}
