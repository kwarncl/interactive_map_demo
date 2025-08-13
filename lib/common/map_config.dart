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
    this.allowRotate = false,
    this.allowPinch = true,
    required this.userAgentPackageName,
    required this.tilesConfig,
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

  /// Required tiles configuration (raster or vector). Determines which
  /// rendering path is used by map widgets.
  final TilesConfig tilesConfig;

  /// Duration for progressing route polylines between days.
  static const Duration routeProgress = Duration(milliseconds: 600);

  /// Duration when centering/zooming out to bounds.
  static const Duration centerToBounds = Duration(milliseconds: 700);

  /// Duration when centering/zooming to a focused coordinate.
  static const Duration centerToFocus = Duration(milliseconds: 600);

  /// Default curve used for camera transitions.
  static const Curve cameraCurve = Curves.easeInOut;
}

/// Marker base class for raster or vector tile configuration.
abstract class TilesConfig {
  const TilesConfig();
}

/// Base type for vector tiles configuration (local or network style sources).
///
/// Consumers should rely on this base type; concrete variants are
/// [NetworkVectorTilesConfig] and [LocalVectorTilesConfig].
abstract class VectorTilesConfig extends TilesConfig {
  const VectorTilesConfig();

  /// URI or asset path to a MapLibre/Mapbox style JSON.
  String get styleUri;

  /// Optional API key (null for local styles).
  String? get apiKey;

  /// Optional override for tile providers. When set, these providers will be
  /// used instead of the ones referenced by the style JSON. Useful for
  /// offline MBTiles/PMTiles or custom servers.
  TileProviders? get providersOverride;
}

/// Vector tiles configuration using a remote style (http/https/mapbox).
class NetworkVectorTilesConfig extends VectorTilesConfig {
  const NetworkVectorTilesConfig({
    required this.styleUrl,
    required this.apiKeyValue,
    this.providers,
  });

  /// Remote style URL (e.g., MapTiler/Mapbox style.json).
  final String styleUrl;

  /// Required API key for the remote style.
  final String apiKeyValue;

  /// Optional provider overrides.
  final TileProviders? providers;

  @override
  String get styleUri => styleUrl;

  @override
  String? get apiKey => apiKeyValue;

  @override
  TileProviders? get providersOverride => providers;
}

/// Vector tiles configuration using a local style JSON (assets).
class LocalVectorTilesConfig extends VectorTilesConfig {
  const LocalVectorTilesConfig({required this.styleAssetPath, this.providers});

  /// Asset path to the local style JSON (e.g., assets/styles/style.json).
  final String styleAssetPath;

  /// Optional provider overrides (usually required for fully offline use).
  final TileProviders? providers;

  @override
  String get styleUri => styleAssetPath;

  @override
  String? get apiKey => null;

  @override
  TileProviders? get providersOverride => providers;
}

/// Configuration for a raster tile layer.
///
/// Covers the common properties required by `TileLayer` to render raster tiles
/// in flutter_map.
class RasterTilesConfig extends TilesConfig {
  const RasterTilesConfig({
    required this.urlTemplate,
    this.subdomains = const <String>[],
    this.additionalOptions = const <String, String>{},
  });

  final String urlTemplate;
  final List<String> subdomains;

  /// Additional URL template options (e.g. {s} subdomain replacements beyond
  /// the standard list, or API keys for servers that expect options instead of
  /// query params).
  final Map<String, String> additionalOptions;
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
