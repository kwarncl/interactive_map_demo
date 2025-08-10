import 'package:flutter/material.dart';
// MapConfig is a pure configuration object; no flutter_map types here.
import 'package:vector_map_tiles/vector_map_tiles.dart';

/// Map configuration used by all `flutter_map` screens.
///
/// Single source of truth for:
/// - Zoom bounds and initial zoom
/// - Interaction flags (drag/rotate/pinch)
/// - Tile server configuration (URL template + options)
/// - User-agent string
///
/// Example:
/// ```dart
/// const config = MapConfig(
///   minZoom: 3,
///   maxZoom: 16,
///   initialZoom: 5,
///   userAgentPackageName: 'com.example.app',
///   tileUrlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
///   additionalTileOptions: {'s': 'a,b,c'},
/// );
/// ```
class MapConfig {
  const MapConfig({
    this.minZoom = 3.0,
    this.maxZoom = 6.0,
    this.initialZoom = 4.5,
    this.defaultLocation = const MapConfigDefaultLocation(),
    this.allowDrag = true,
    this.allowRotate = true,
    this.allowPinch = true,
    required this.userAgentPackageName,
    required this.rasterTiles,
    this.vectorTiles,
  });

  /// Minimum allowed map zoom.
  final double minZoom;

  /// Maximum allowed map zoom.
  final double maxZoom;

  /// Initial zoom used when no day is selected.
  final double initialZoom;

  /// Fallback default location (lat/lng) for the map.
  final MapConfigDefaultLocation defaultLocation;

  /// Whether the map can be dragged (panned).
  final bool allowDrag;

  /// Whether the map can be rotated.
  final bool allowRotate;

  /// Whether the map can be pinched (zoomed).
  final bool allowPinch;

  /// User agent string forwarded by tile requests.
  final String userAgentPackageName;

  /// Single raster tiles configuration used as fallback when vector is absent.
  final RasterTilesConfig rasterTiles;

  /// Optional vector tiles configuration. When provided, screens may
  /// render vector tiles instead of raster, using the configured style.
  final VectorTilesConfig? vectorTiles;

  /// Duration for progressing route polylines between days.
  static const Duration routeProgress = Duration(milliseconds: 600);

  /// Duration when centering/zooming out to bounds.
  static const Duration centerToBounds = Duration(milliseconds: 700);

  /// Duration when centering/zooming to a focused coordinate.
  static const Duration centerToFocus = Duration(milliseconds: 600);

  /// Default curve used for camera transitions.
  static const Curve cameraCurve = Curves.easeInOut;

  /// Free raster provider options (cleaned up selection)
  static List<RasterTilesConfig> freeRasterLayers = [
    RasterTilesConfig(
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c', 'd'],
    ),
    RasterTilesConfig(
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c', 'd'],
    ),
    RasterTilesConfig(
      urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c', 'd'],
    ),
  ];
}

/// Configuration for vector tiles (style JSON + optional API key).
class VectorTilesConfig {
  const VectorTilesConfig({
    required this.styleUri,
    this.apiKey,
    this.providersOverride,
  });

  /// URL to a MapLibre/Mapbox style JSON (e.g., MapTiler style.json).
  final String styleUri;

  /// API key required by the style (if any). Some styles embed the key
  /// in the URI; in that case you can leave this null.
  final String? apiKey;

  /// Optional override for tile providers. When set, these providers will be
  /// used instead of the ones referenced by the style JSON. Useful for
  /// offline MBTiles/PMTiles or custom servers.
  final TileProviders? providersOverride;
}

/// Configuration for a raster tile layer to keep API uniform with vector.
class RasterTilesConfig {
  const RasterTilesConfig({
    required this.urlTemplate,
    this.subdomains = const <String>[],
    this.userAgentPackageName,
  });

  final String urlTemplate;
  final List<String> subdomains;
  final String? userAgentPackageName;
}

/// Default location coordinates (Miami, FL).
class MapConfigDefaultLocation {
  const MapConfigDefaultLocation({
    this.latitude = 25.7617,
    this.longitude = -80.1918,
  });

  /// Latitude component of the default location.
  final double latitude;

  /// Longitude component of the default location.
  final double longitude;
}
