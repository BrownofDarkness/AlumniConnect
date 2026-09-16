import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';
import 'package:allumni_connect/core/constants/app_spacing.dart';
import 'package:allumni_connect/core/theme/app_text_styles.dart';
import 'package:allumni_connect/core/utils/geo_utils.dart';
import 'package:allumni_connect/features/directory/providers/directory_providers.dart';
import 'package:allumni_connect/features/map/providers/map_providers.dart';
import 'package:allumni_connect/features/map/widgets/alumni_map_card.dart';
import 'package:allumni_connect/features/map/widgets/alumni_map_marker.dart';
import 'package:allumni_connect/features/map/widgets/map_filter_chips.dart';
import 'package:allumni_connect/features/map/widgets/map_floating_controls.dart';
import 'package:allumni_connect/features/map/widgets/selected_alumni_label.dart';
import 'package:allumni_connect/features/map/widgets/user_location_marker.dart';
import 'package:allumni_connect/models/alumni.dart';
import 'package:allumni_connect/routing/routes.dart';

/// Écran Carte : position des alumni à proximité + itinéraire, au-dessus
/// d'un fond OpenStreetMap (voir [MapController]/[FlutterMap]).
class MapViewScreen extends ConsumerStatefulWidget {
  const MapViewScreen({super.key});

  @override
  ConsumerState<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends ConsumerState<MapViewScreen> {
  final MapController _mapController = MapController();
  bool _useLightTiles = false;

  Future<void> _launch(Uri uri) async {
    final bool canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir cette action sur cet appareil.')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Recadre la caméra pour que ma position et tous les alumni à proximité
  /// (dans le rayon sélectionné) restent visibles à l'écran.
  void _fitToNearby(LatLng center, List<Alumni> nearby) {
    if (nearby.isEmpty) {
      _mapController.move(center, 13);
      return;
    }
    final LatLngBounds bounds = LatLngBounds.fromPoints([
      center,
      for (final Alumni a in nearby) LatLng(a.latitude, a.longitude),
    ]);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(48, 48, 88, 48),
        maxZoom: 16,
      ),
    );
  }

  void _showRadiusPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const _RadiusPickerSheet(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fitToNearby(ref.read(mapCenterProvider), ref.read(nearbyAlumniProvider));
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Alumni> nearby = ref.watch(nearbyAlumniProvider);
    final Alumni? selected = ref.watch(selectedAlumniProvider);
    final double radiusKm = ref.watch(mapRadiusKmProvider);
    final LatLng center = ref.watch(mapCenterProvider);

    ref.listen<List<Alumni>>(nearbyAlumniProvider, (previous, next) {
      _fitToNearby(ref.read(mapCenterProvider), next);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Carte')),
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            MapFilterChipsRow(
              radiusKm: radiusKm,
              onRadiusTap: _showRadiusPicker,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: 13,
                        onTap: (_, _) => ref.read(selectedAlumniIdProvider.notifier).clear(),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: _useLightTiles
                              ? 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png'
                              : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: _useLightTiles ? const ['a', 'b', 'c', 'd'] : const [],
                          userAgentPackageName: 'com.allumni.allumni_connect',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: center,
                              width: 100,
                              height: 76,
                              alignment: Alignment.topCenter,
                              child: const UserLocationMarker(),
                            ),
                            for (final Alumni a in nearby)
                              Marker(
                                point: LatLng(a.latitude, a.longitude),
                                width: AlumniMapMarker.size,
                                height: AlumniMapMarker.size,
                                alignment: Alignment.bottomCenter,
                                child: AlumniMapMarker(
                                  alumni: a,
                                  isSelected: selected?.id == a.id,
                                  onTap: () =>
                                      ref.read(selectedAlumniIdProvider.notifier).select(a.id),
                                ),
                              ),
                            if (selected != null)
                              Marker(
                                point: LatLng(selected.latitude, selected.longitude),
                                width: 140,
                                height: 32,
                                alignment: const Alignment(1.5, -2.6),
                                child: SelectedAlumniLabel(
                                  alumni: selected,
                                  onMailTap: () =>
                                      _launch(Uri(scheme: 'mailto', path: selected.email)),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.lg,
                    child: MapFloatingControls(
                      onListTap: () => context.goNamed(RouteName.directory),
                      onLayersTap: () => setState(() => _useLightTiles = !_useLightTiles),
                      onLocateTap: () => _fitToNearby(center, nearby),
                      activeCount: nearby.length,
                    ),
                  ),
                  if (selected != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AlumniMapCard(
                        alumni: selected,
                        distanceLabel: GeoUtils.format(ref.watch(distanceKmProvider(selected))),
                        onClose: () => ref.read(selectedAlumniIdProvider.notifier).clear(),
                        onItineraire: () => context.pushNamed(
                          RouteName.itinerary,
                          pathParameters: {'id': selected.id},
                        ),
                        onCall: () => _launch(
                          Uri(scheme: 'tel', path: selected.telephone.replaceAll(' ', '')),
                        ),
                        onProfile: () => context.pushNamed(
                          RouteName.alumniDetail,
                          pathParameters: {'id': selected.id},
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadiusPickerSheet extends ConsumerWidget {
  const _RadiusPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double radiusKm = ref.watch(mapRadiusKmProvider);
    final MapRadiusNotifier notifier = ref.read(mapRadiusKmProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Rayon de recherche', style: AppTextStyles.title.copyWith(color: AppColors.navy)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Affiche les alumni situés à moins de ${radiusKm.round()} km de votre position.',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.muted),
            ),
            Slider(
              value: radiusKm,
              min: 5,
              max: 200,
              divisions: 39,
              label: '${radiusKm.round()} km',
              onChanged: notifier.setRadiusKm,
            ),
          ],
        ),
      ),
    );
  }
}
