import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:interactive_map_demo/common/map_config.dart';
import 'package:interactive_map_demo/common/map_utilities.dart';
import 'package:interactive_map_demo/common/widgets/custom_map_tile_layers.dart';
import 'package:interactive_map_demo/deck_plan/deck_8_svg_polygon_provider.dart';
import 'package:interactive_map_demo/deck_plan/models/deck_polygon_data.dart';
import 'package:interactive_map_demo/deck_plan/models/ship_deck_data.dart';
import 'package:interactive_map_demo/interactive_map/interactive_map.dart';
import 'package:interactive_map_demo/itinerary/data/caribbean_cruise.dart'
    as itinerary_data;
import 'package:interactive_map_demo/itinerary/data/transatlantic_cruise.dart';
import 'package:interactive_map_demo/itinerary_map/data/caribbean_cruise.dart'
    as itinerary_map_data;
import 'package:interactive_map_demo/itinerary_map/data/transatlantic_cruise.dart'
    as itinerary_map_transatlantic;
import 'package:interactive_map_demo/itinerary_map/data/world_samples.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbtiles/mbtiles.dart';

import 'common/mbtiles/mbtiles_vector_tile_provider.dart';
import 'cruise_catalog/cruise_catalog.dart';
import 'cruise_catalog/data/expanded_ncl_catalog.dart';
import 'deck_plan/multi_deck_ship_map.dart';
import 'itinerary/cruise_itinerary_page.dart';
import 'itinerary_map/itinerary_map.dart';

enum FeatureTag {
  interactiveMap('Interactive map'),
  staticMap('Static map'),
  svgRendering('SVG rendering'),
  pngRendering('PNG rendering'),
  mapRendering('Map rendering'),
  comingSoon('Coming soon');

  const FeatureTag(this.label);

  final String label;
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Maps'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Text(
                'Explore different types of interactive maps and cruise experiences',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SectionHeader(
              title: 'Island Explorer',
              icon: Icons.beach_access,
              description:
                  'Explore Norwegian\'s private islands with interactive maps and activity locations',
            ),
            HorizontalCardList(
              cards: [
                _MapCard(
                  title: 'Great Stirrup Cay',
                  subtitle: 'Interactive island map with activity points',
                  icon: Icons.beach_access,
                  imageAsset: 'assets/images/map.jpg',
                  progressPercentage: 70,
                  features: [
                    FeatureTag.interactiveMap,
                    FeatureTag.pngRendering,
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const InteractiveMap(),
                      ),
                    );
                  },
                ),
                _MapCard(
                  title: 'Harvest Caye',
                  subtitle: 'Interactive island map with activity points',
                  icon: Icons.beach_access,
                  imageAsset: 'assets/images/map.jpg',
                  progressPercentage: 0,
                  features: [FeatureTag.comingSoon, FeatureTag.pngRendering],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming Soon - Harvest Caye Experience!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionHeader(
              title: 'Cruise Itineraries',
              icon: Icons.route,
              description:
                  'Day-by-day cruise schedules showing ports, routes, and journey details',
            ),
            HorizontalCardList(
              cards: [
                _MapCard(
                  title: '7-Day Caribbean Cruise',
                  subtitle: 'Day-by-day navigation with port information',
                  icon: Icons.route,
                  imageAsset: 'assets/images/caribbean_cruise_map.png',
                  progressPercentage: 90,
                  features: [FeatureTag.staticMap, FeatureTag.pngRendering],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => CruiseItineraryPage(
                              itinerary:
                                  itinerary_data
                                      .CaribbeanCruiseData
                                      .norwegianAquaCaribbean,
                            ),
                      ),
                    );
                  },
                ),
                _MapCard(
                  title: '7-Day Caribbean Cruise',
                  subtitle: 'Day-by-day navigation with port information',
                  icon: Icons.map,
                  imageAsset: 'assets/images/caribbean_cruise_map.png',
                  progressPercentage: 35,
                  features: [
                    FeatureTag.interactiveMap,
                    FeatureTag.mapRendering,
                  ],
                  previewRoute:
                      itinerary_map_data
                          .CaribbeanCruiseData
                          .norwegianAquaCaribbean
                          .routeCoordinates
                          .map((coord) => LatLng(coord[0], coord[1]))
                          .toList(),
                  onTap: () async {
                    final MapConfig offlineConfig =
                        await MapUtilities.buildOfflineVectorMapConfigFromAssets(
                          baseConfig: const MapConfig(
                            userAgentPackageName:
                                'com.example.interactive_map_demo',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => ItineraryMap(
                              cruiseTitle:
                                  itinerary_map_data
                                      .CaribbeanCruiseData
                                      .norwegianAquaCaribbean
                                      .cruiseName,
                              itineraryDays:
                                  itinerary_map_data
                                      .CaribbeanCruiseData
                                      .norwegianAquaCaribbean
                                      .days,
                              selectedItineraryDay:
                                  itinerary_map_data
                                      .CaribbeanCruiseData
                                      .norwegianAquaCaribbean
                                      .days
                                      .first,
                              mapConfig: offlineConfig,
                              routeCoordinates:
                                  itinerary_map_data
                                      .CaribbeanCruiseData
                                      .norwegianAquaCaribbean
                                      .routeCoordinates
                                      .map(
                                        (coord) => LatLng(coord[0], coord[1]),
                                      )
                                      .toList(),
                            ),
                      ),
                    );
                  },
                ),
                _MapCard(
                  title: '15-Day Transatlantic Cruise',
                  subtitle: 'Day-by-day navigation with port information',
                  icon: Icons.sailing,
                  imageAsset:
                      'assets/images/norwegian_pearl_transatlantic_map.png',
                  progressPercentage: 75,
                  features: [FeatureTag.staticMap, FeatureTag.pngRendering],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => CruiseItineraryPage(
                              itinerary:
                                  TransatlanticCruiseData
                                      .norwegianPearlMediterranean,
                            ),
                      ),
                    );
                  },
                ),
                _MapCard(
                  title: '15-Day Transatlantic Cruise',
                  subtitle: 'Day-by-day navigation with port information',
                  icon: Icons.sailing,
                  imageAsset:
                      'assets/images/norwegian_pearl_transatlantic_map.png',
                  progressPercentage: 75,
                  features: [
                    FeatureTag.interactiveMap,
                    FeatureTag.mapRendering,
                  ],
                  previewRoute:
                      itinerary_map_transatlantic
                          .TransatlanticCruiseData
                          .norwegianPearlMediterranean
                          .routeCoordinates
                          .map((c) => LatLng(c[0], c[1]))
                          .toList(),
                  onTap: () async {
                    final MapConfig offlineConfig =
                        await MapUtilities.buildOfflineVectorMapConfigFromAssets(
                          baseConfig: const MapConfig(
                            userAgentPackageName:
                                'com.example.interactive_map_demo',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => ItineraryMap(
                              cruiseTitle:
                                  itinerary_map_transatlantic
                                      .TransatlanticCruiseData
                                      .norwegianPearlMediterranean
                                      .cruiseName,
                              itineraryDays:
                                  itinerary_map_transatlantic
                                      .TransatlanticCruiseData
                                      .norwegianPearlMediterranean
                                      .days,
                              selectedItineraryDay:
                                  itinerary_map_transatlantic
                                      .TransatlanticCruiseData
                                      .norwegianPearlMediterranean
                                      .days
                                      .first,
                              mapConfig: offlineConfig,
                              routeCoordinates:
                                  itinerary_map_transatlantic
                                      .TransatlanticCruiseData
                                      .norwegianPearlMediterranean
                                      .routeCoordinates
                                      .map((c) => LatLng(c[0], c[1]))
                                      .toList(),
                            ),
                      ),
                    );
                  },
                ),
                ...[
                  WorldSampleItineraries.alaskaInsidePassage,
                  WorldSampleItineraries.mediterraneanGreekIsles,
                  WorldSampleItineraries.northernEuropeBaltic,
                  WorldSampleItineraries.australiaNewZealand,
                  WorldSampleItineraries.japanRoundtrip,
                ].map((cruise) {
                  return _MapCard(
                    title: cruise.cruiseName,
                    subtitle: cruise.description,
                    icon: Icons.sailing,
                    imageAsset: cruise.mapImagePath,
                    progressPercentage: 75,
                    features: [
                      FeatureTag.interactiveMap,
                      FeatureTag.mapRendering,
                    ],
                    previewRoute:
                        cruise.routeCoordinates
                            .map((c) => LatLng(c[0], c[1]))
                            .toList(),
                    onTap: () async {
                      final MapConfig offlineConfig =
                          await MapUtilities.buildOfflineVectorMapConfigFromAssets(
                            baseConfig: const MapConfig(
                              userAgentPackageName:
                                  'com.example.interactive_map_demo',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (context) => ItineraryMap(
                                cruiseTitle: cruise.cruiseName,
                                itineraryDays: cruise.days,
                                selectedItineraryDay: cruise.days.first,
                                mapConfig: offlineConfig,
                                routeCoordinates:
                                    cruise.routeCoordinates
                                        .map((c) => LatLng(c[0], c[1]))
                                        .toList(),
                              ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
            const SectionHeader(
              title: 'Ship & Deck Plans',
              icon: Icons.directions_boat,
              description:
                  'Interactive layouts of ship decks with room locations and facilities',
            ),
            HorizontalCardList(
              cards: [
                _MapCard(
                  title: 'Norwegian Aqua',
                  subtitle: 'Navigate between decks and explore venues',
                  icon: Icons.directions_boat,
                  imageAsset: 'assets/images/cruise-ship.svg',
                  progressPercentage: 10,
                  features: [FeatureTag.staticMap, FeatureTag.pngRendering],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => MultiDeckShipMap(
                              shipClass: NorwegianAquaPolygonProvider.shipClass,
                              decks: NorwegianAquaDecks.allDecks,
                              initialDeckIndex: 3,
                              polygonDataProvider:
                                  NorwegianAquaPolygonProvider(),
                            ),
                      ),
                    );
                  },
                ),
                _MapCard(
                  title: 'Norwegian Aqua',
                  subtitle: 'Navigate between decks and explore venues',
                  icon: Icons.map,
                  imageAsset: 'assets/images/deck-8.svg',
                  progressPercentage: 5,
                  features: [
                    FeatureTag.interactiveMap,
                    FeatureTag.svgRendering,
                  ],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => MultiDeckShipMap(
                              shipClass: Deck8SvgPolygonProvider.shipClass,
                              decks: [
                                ShipDeckInfo(
                                  deckNumber: 8,
                                  name: 'Deck 8 - Ocean Boulevard (SVG)',
                                  description:
                                      'Interactive SVG-based deck plan with 360° promenade featuring pools, dining, Ocean Walk, and outdoor spaces',
                                  imageUrl: 'assets/images/deck-8.svg',
                                  primaryColor: Colors.cyan.shade400,
                                  markers: [],
                                ),
                              ],
                              initialDeckIndex: 0,
                              polygonDataProvider: Deck8SvgPolygonProvider(),
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionHeader(
              title: 'Cruise Catalog',
              icon: Icons.public,
              description:
                  'Browse global cruise destinations and routes from around the world',
            ),
            HorizontalCardList(
              cards: [
                _MapCard(
                  title: 'NCL Cruise Catalog',
                  subtitle:
                      'Explore worldwide cruise destinations with interactive filtering',
                  icon: Icons.public,
                  imageAsset: 'assets/images/map.jpg',
                  progressPercentage: 70,
                  features: [
                    FeatureTag.interactiveMap,
                    FeatureTag.mapRendering,
                  ],
                  previewCenter: LatLng(25.7617, -80.1918),
                  previewZoom: 6.0,
                  onTap: () async {
                    final MapConfig offlineConfig =
                        await MapUtilities.buildOfflineVectorMapConfigFromAssets(
                          baseConfig: const MapConfig(
                            minZoom: 3.0,
                            maxZoom: 6.0,
                            initialZoom: 4.5,
                            allowRotate: false,
                            userAgentPackageName:
                                'com.example.interactive_map_demo',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder:
                            (context) => CruiseCatalog(
                              title: 'NCL Cruise Catalog',
                              cruises: ExpandedNCLCatalog.allCruises,
                              mapConfig: offlineConfig,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.icon,
    required this.description,
    super.key,
  });

  final String title;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  const HorizontalCardList({required this.cards, super.key});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Height for cards with images
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 320, // Fixed width for consistent card sizing
            margin: EdgeInsets.only(
              left: index == 0 ? 16.0 : 0,
              right: index == cards.length - 1 ? 16.0 : 0,
            ),
            child: cards[index],
          );
        },
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.features,
    this.imageAsset,
    this.progressPercentage,
    this.previewCenter,
    this.previewZoom,
    this.previewRoute,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final List<FeatureTag>? features;
  final String? imageAsset;
  final int? progressPercentage;
  final LatLng? previewCenter;
  final double? previewZoom;
  final List<LatLng>? previewRoute;

  Future<({LatLng center, double zoom})> _computePreviewCamera() async {
    if (previewCenter != null && previewZoom != null) {
      return (center: previewCenter!, zoom: previewZoom!);
    }
    final List<LatLng> route = previewRoute ?? const <LatLng>[];
    if (route.isNotEmpty) {
      // Focus on the first port (home port) for a cleaner preview.
      return (center: route.first, zoom: 6.5);
    }
    // Fallback to Miami if route is missing
    return (center: const LatLng(25.7617, -80.1918), zoom: 6.0);
  }

  Widget _buildPreviewContent() {
    if (features == null || features!.isEmpty) return const SizedBox.shrink();

    // Check for map rendering type
    if (features!.contains(FeatureTag.mapRendering)) {
      return Positioned(
        bottom: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map, size: 14, color: Colors.indigo.shade700),
              const SizedBox(width: 4),
              Text(
                'Map',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Check for SVG rendering
    if (features!.contains(FeatureTag.svgRendering)) {
      return Positioned(
        bottom: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.polyline, size: 14, color: Colors.indigo.shade700),
              const SizedBox(width: 4),
              Text(
                'SVG',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Check for PNG rendering (static map)
    if (features!.contains(FeatureTag.pngRendering)) {
      return Positioned(
        bottom: 8,
        right: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image, size: 14, color: Colors.teal.shade700),
              const SizedBox(width: 4),
              Text(
                'PNG',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMainImage(BuildContext context) {
    if (imageAsset == null) return const SizedBox.shrink();

    final String fileExtension = imageAsset!.toLowerCase();

    // Check for SVG files
    if (fileExtension.endsWith('.svg')) {
      return ScalableImageWidget.fromSISource(
        si: ScalableImageSource.fromSvg(
          DefaultAssetBundle.of(context),
          imageAsset!,
        ),
        fit: BoxFit.cover,
      );
    }

    // Check for Flutter Map rendering (only for features with mapRendering tag)
    if (features?.contains(FeatureTag.mapRendering) == true) {
      return ClipRect(
        child: SizedBox(
          width: double.infinity,
          height: 120,
          child: FutureBuilder<List<Object>>(
            future: Future.wait<Object>([
              _computePreviewCamera(),
              MapUtilities.buildOfflineVectorMapConfigFromAssets(
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
              ),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.length < 2) {
                return Container(color: Theme.of(context).colorScheme.surface);
              }

              final data = snapshot.data!;
              final camera = data[0] as ({LatLng center, double zoom});
              final mapConfig = data[1] as MapConfig;

              return FlutterMap(
                options: MapOptions(
                  initialCenter: camera.center,
                  initialZoom: camera.zoom,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [CustomMapTileLayers(mapConfig: mapConfig)],
              );
            },
          ),
        ),
      );
    }

    // Default: PNG/JPEG/other image formats
    return Image.asset(
      imageAsset!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 120,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageAsset != null)
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Render different image types based on features
                    _buildMainImage(context),
                    // Preview content based on feature type
                    _buildPreviewContent(),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    if (progressPercentage != null)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$progressPercentage%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  if (features != null) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children:
                          features!
                              .map(
                                (feature) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    feature.label,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
