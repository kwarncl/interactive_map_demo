import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';

import '../../common/map_config.dart';
import '../../common/map_utilities.dart';
import '../../common/mbtiles/mbtiles_vector_tile_provider.dart';
import '../../itinerary_map/itinerary_map.dart';
import '../models/cruise_product.dart';
import '../utils/cruise_to_itinerary_converter.dart';

/// Preview widget for cruise itinerary that opens full screen map
class CruiseItineraryPreview extends StatelessWidget {
  const CruiseItineraryPreview({super.key, required this.cruise});

  final CruiseProduct cruise;

  LatLng _getHomePortLocation() {
    final List<LatLng> route = cruise.route.coordinates;
    if (route.isNotEmpty) {
      return route.first;
    }
    // Fallback to Miami if route is missing
    return const LatLng(25.7617, -80.1918);
  }

  void _openItineraryMap(BuildContext context) async {
    final itinerary = CruiseToItineraryConverter.convertToItinerary(cruise);

    // Build offline vector map config like the itinerary_map feature
    final MapConfig offlineConfig =
        await MapUtilities.buildOfflineVectorMapConfigFromAssets(
          baseConfig: const MapConfig(
            userAgentPackageName: 'com.example.interactive_map_demo',
            tilesConfig: LocalVectorTilesConfig(
              styleAssetPath: 'assets/styles/style.json',
            ),
          ),
          styleAssetPath: 'assets/styles/style.json',
          mbtilesAssetPath: 'assets/tiles/planet_map.mbtiles',
          createProvider:
              (path) => MbTilesVectorTileProvider(
                mbtiles: MbTiles(mbtilesPath: path),
              ),
          sourceName: 'openmaptiles',
        );

    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (context) => ItineraryMap(
              cruiseTitle: cruise.title,
              itineraryDays: itinerary.days,
              selectedItineraryDay: itinerary.days.first,
              mapConfig: offlineConfig,
              routeCoordinates:
                  itinerary.routeCoordinates
                      .map((coord) => LatLng(coord[0], coord[1]))
                      .toList(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _openItineraryMap(context),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Map background
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: _getHomePortLocation(),
                        initialZoom: 6.5,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName:
                              'com.example.interactive_map_demo',
                        ),
                      ],
                    ),
                  ),
                  // Gradient overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Itinerary Map title at bottom left
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      'Itinerary Map',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Map icon at bottom-right
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.map, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
