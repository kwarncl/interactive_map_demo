import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:flutter_map/flutter_map.dart';
import 'package:interactive_map_demo/common/map_config.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

/// A utility class for map-related calculations and geographic computations.
///
/// This class provides static methods for common map operations such as:
/// * Calculating optimal zoom levels and center points for route display
/// * Geographic bounds analysis and coordinate processing
/// * Map view optimization for different types of journeys
///
/// ## Usage
/// ```dart
/// // Calculate optimal bounds for a cruise route
/// final bounds = MapUtilities.calculateMapBounds(
///   routeCoordinates: cruiseRoute,
///   initialZoom: 6.0,
///   minZoom: 4.0,
///   maxZoom: 15.0,
///   padding: 0.05,
/// );
/// ```
///
/// ## Design Principles
/// * **Performance**: All methods are optimized for O(n) time complexity
/// * **Accuracy**: Uses empirically tuned thresholds for real-world scenarios
/// * **Flexibility**: Configurable parameters for different use cases
/// * **Type Safety**: Returns strongly-typed records instead of dynamic maps
class MapUtilities {
  /// Convert `[latitude, longitude]` list to [LatLng].
  static LatLng toLatLng(List<double> coordinates) {
    return LatLng(coordinates[0], coordinates[1]);
  }

  /// Compute a list of unique "port days" from [days] using a provided
  /// identifier and an anchor-preference rule.
  ///
  /// - Items with `getPortIdOrNull(item) == null` are skipped (e.g., sea days)
  /// - If multiple items share the same port id, the one for which
  ///   [isAnchorDay] returns true (embarkation/disembarkation) is preferred
  ///   over a non-anchor.
  /// - If both are anchors or both are non-anchors, the first occurrence wins.
  static List<T> computeUniquePortDays<T>({
    required List<T> days,
    required String? Function(T) getPortIdOrNull,
    required bool Function(T) isAnchorDay,
  }) {
    final Map<String, T> idToDay = <String, T>{};
    for (final T day in days) {
      final String? id = getPortIdOrNull(day);
      if (id == null) continue;
      final T? existing = idToDay[id];
      if (existing == null) {
        idToDay[id] = day;
      } else {
        final bool existingIsAnchor = isAnchorDay(existing);
        final bool candidateIsAnchor = isAnchorDay(day);
        if (candidateIsAnchor && !existingIsAnchor) {
          idToDay[id] = day;
        }
      }
    }
    return idToDay.values.toList(growable: false);
  }

  /// Build `InteractionOptions` using simple boolean flags to avoid
  /// importing `flutter_map` types throughout feature code.
  static InteractionOptions buildInteractionOptions({
    required bool canDrag,
    required bool canRotate,
    required bool canPinch,
    bool enableMultiFingerGestureRace = false,
  }) {
    int flags = InteractiveFlag.all;
    if (!canDrag) flags &= ~InteractiveFlag.drag;
    if (!canRotate) flags &= ~InteractiveFlag.rotate;
    if (!canPinch) flags &= ~InteractiveFlag.pinchZoom;

    return InteractionOptions(
      flags: flags,
      enableMultiFingerGestureRace: enableMultiFingerGestureRace,
    );
  }

  /// Linearly interpolate between two [LatLng] points.
  ///
  /// [t] must be in the range 0..1, where 0 returns [start] and 1 returns [end].
  static LatLng interpolateLatLng(LatLng start, LatLng end, double t) {
    final double lat = start.latitude + (end.latitude - start.latitude) * t;
    final double lng = start.longitude + (end.longitude - start.longitude) * t;
    return LatLng(lat, lng);
  }

  // =============================
  // Itinerary day progress utils
  // =============================

  /// Count items that satisfy [hasPort].
  static int countPorts<T>(List<T> days, bool Function(T) hasPort) {
    int count = 0;
    for (final T day in days) {
      if (hasPort(day)) count++;
    }
    return count;
  }

  /// Compute normalized progress (0..1) for the given [dayIndex].
  /// Ports map to `portIndex/(numPorts-1)`. Sea days are spaced evenly between
  /// the surrounding ports; multiple consecutive sea days divide the segment.
  static double computeDayProgress<T>({
    required List<T> days,
    required int dayIndex,
    required bool Function(T) hasPort,
  }) {
    if (dayIndex < 0 || dayIndex >= days.length) return 0.0;

    final int totalPorts = countPorts(days, hasPort);
    if (totalPorts < 2) return 0.0;

    if (hasPort(days[dayIndex])) {
      // Port day
      int portIndex = 0;
      for (int i = 0; i <= dayIndex && i < days.length; i++) {
        if (hasPort(days[i])) {
          if (i == dayIndex) break;
          portIndex++;
        }
      }
      return portIndex / (totalPorts - 1);
    }

    // Sea day: locate surrounding ports and distribute evenly
    int previousPortDayIndex = -1;
    int nextPortDayIndex = -1;
    int previousPortIndex = -1;
    int nextPortIndex = -1;

    // Find previous port day index
    for (int i = dayIndex - 1; i >= 0; i--) {
      if (hasPort(days[i])) {
        previousPortDayIndex = i;
        break;
      }
    }

    // Map to previous port index
    int count = 0;
    for (int i = 0; i < days.length; i++) {
      if (hasPort(days[i])) {
        if (i == previousPortDayIndex) {
          previousPortIndex = count;
          break;
        }
        count++;
      }
    }

    // Find next port day index and its port index
    count = 0;
    for (int i = 0; i < days.length; i++) {
      if (hasPort(days[i])) {
        if (i > dayIndex) {
          nextPortDayIndex = i;
          nextPortIndex = count;
          break;
        }
        count++;
      }
    }

    if (previousPortDayIndex >= 0 &&
        nextPortDayIndex >= 0 &&
        previousPortIndex >= 0 &&
        nextPortIndex >= 0 &&
        nextPortIndex < totalPorts) {
      final int seaDaysCount = nextPortDayIndex - previousPortDayIndex - 1;
      if (seaDaysCount > 0) {
        final int seaDayPosition = dayIndex - previousPortDayIndex; // 1..N
        final double segmentProgress = seaDayPosition / (seaDaysCount + 1);
        final double prevProgress = previousPortIndex / (totalPorts - 1);
        final double nextProgress = nextPortIndex / (totalPorts - 1);
        return prevProgress + segmentProgress * (nextProgress - prevProgress);
      }
    }

    if (previousPortIndex >= 0 &&
        nextPortIndex >= 0 &&
        nextPortIndex < totalPorts) {
      return (previousPortIndex + 0.5) / (totalPorts - 1);
    }
    if (previousPortIndex >= 0) {
      return previousPortIndex / (totalPorts - 1);
    }
    return 0.0;
  }

  /// Compute precise sea-day chunk bounds (from,to) in normalized progress.
  static ({double from, double to}) computeSeaDayChunkProgress<T>({
    required List<T> days,
    required int seaDayIndex,
    required bool Function(T) hasPort,
  }) {
    final int totalPorts = countPorts(days, hasPort);
    if (totalPorts < 2) return (from: 0.0, to: 0.0);

    int previousPortDayIndex = -1;
    int nextPortDayIndex = -1;
    int previousPortIndex = -1;
    int nextPortIndex = -1;

    for (int i = seaDayIndex - 1; i >= 0; i--) {
      if (hasPort(days[i])) {
        previousPortDayIndex = i;
        break;
      }
    }

    int count = 0;
    for (int i = 0; i < days.length; i++) {
      if (hasPort(days[i])) {
        if (i == previousPortDayIndex) {
          previousPortIndex = count;
          break;
        }
        count++;
      }
    }

    count = 0;
    for (int i = 0; i < days.length; i++) {
      if (hasPort(days[i])) {
        if (i > seaDayIndex) {
          nextPortDayIndex = i;
          nextPortIndex = count;
          break;
        }
        count++;
      }
    }

    double from = 0.0;
    double to = 0.0;
    if (previousPortDayIndex >= 0 &&
        nextPortDayIndex >= 0 &&
        previousPortIndex >= 0 &&
        nextPortIndex >= 0 &&
        nextPortIndex < totalPorts) {
      final double prevProgress = previousPortIndex / (totalPorts - 1);
      final double nextProgress = nextPortIndex / (totalPorts - 1);
      final double segmentSpan = nextProgress - prevProgress;
      final int seaDaysCount = nextPortDayIndex - previousPortDayIndex - 1;
      if (seaDaysCount > 0) {
        final int chunkIndex =
            seaDayIndex - previousPortDayIndex - 1; // 0-based
        final double chunkSize = segmentSpan / (seaDaysCount + 1);
        from = prevProgress + (chunkSize * chunkIndex);
        to = prevProgress + (chunkSize * (chunkIndex + 1));
      }
    }

    return (from: from, to: to);
  }

  /// Calculates optimal map bounds (center and zoom) to display an entire route.
  ///
  /// This method analyzes a list of geographic coordinates to determine the best
  /// center point and zoom level that will show the entire route with appropriate
  /// padding. The calculation works for various map types including cruise routes,
  /// road trips, hiking trails, and other multi-point journeys.
  ///
  /// ## Algorithm
  /// 1. **Bounds Calculation**: Finds the minimum and maximum latitude/longitude
  ///    values across all route coordinates
  /// 2. **Center Calculation**: Determines the midpoint of the geographic bounds
  /// 3. **Zoom Calculation**: Uses the largest coordinate difference to determine
  ///    appropriate zoom level with fine-tuned thresholds for different scales
  /// 4. **Padding Application**: Adds configurable padding to ensure route isn't
  ///    cut off at map edges
  /// 5. **Zoom Bounds Enforcement**: Conditionally enforces min/max limits based
  ///    on [enforceBounds] parameter (default: true)
  ///
  /// ## Zoom Level Thresholds
  /// The method uses general thresholds for various map regions and scales.
  /// Each threshold respects the [minZoom] parameter when [enforceBounds] is true:
  /// - **> 50° difference**: Zoom 2.0 (global view)
  /// - **> 30° difference**: Zoom 3.0 (continental view)
  /// - **> 20° difference**: Zoom 4.0 (regional view)
  /// - **> 15° difference**: Zoom 4.5 (sub-regional view)
  /// - **> 10° difference**: Zoom 5.0 (local area view)
  /// - **> 7° difference**: Zoom 5.5 (city cluster view)
  /// - **> 5° difference**: Zoom 6.0 (city view)
  /// - **> 3**: Zoom 6.5 (neighborhood view)
  /// - **> 2**: Zoom 7.0 (street view)
  /// - **> 1**: Zoom 7.5 (building view)
  /// - **≤ 1**: Zoom 8.0 (detail view)
  ///
  /// **Note**: When [enforceBounds] is true, all calculated zoom levels are clamped
  /// to [minZoom, maxZoom] bounds. When false, zoom can exceed these bounds.
  ///
  /// ## Parameters
  /// * [routeCoordinates] - List of geographic coordinates representing the route
  /// * [initialZoom] - Default zoom level to use if route is empty
  /// * [minZoom] - Minimum allowed zoom level (prevents over-zooming)
  /// * [maxZoom] - Maximum allowed zoom level (prevents under-zooming)
  /// * [zoomAdjustment] - Additive zoom adjustment. Positive values zoom in,
  ///   negative values zoom out.
  /// * [enforceBounds] - Whether to enforce min/max zoom bounds (default: true)
  ///
  /// ## Returns
  /// A record containing:
  /// * [center] - The calculated center point (LatLng)
  /// * [zoom] - The calculated zoom level (double)
  static ({LatLng center, double zoom}) calculateMapBounds({
    required List<LatLng> routeCoordinates,
    required double initialZoom,
    required double minZoom,
    required double maxZoom,
    double zoomAdjustment = 0.0,
    bool enforceBounds = true,
  }) {
    // Handle empty routes: fallback to a safe default location with initial zoom
    if (routeCoordinates.isEmpty) {
      final LatLng center = const LatLng(0, 0);
      final double clamped =
          enforceBounds
              ? initialZoom.clamp(minZoom, maxZoom).toDouble()
              : initialZoom;
      return (center: center, zoom: clamped + zoomAdjustment);
    }

    // If there is a single point, center there with a detailed zoom
    if (routeCoordinates.length == 1) {
      final LatLng center = routeCoordinates.first;
      final double base = 8.0 + zoomAdjustment;
      final double zoom =
          enforceBounds ? base.clamp(minZoom, maxZoom).toDouble() : base;
      return (center: center, zoom: zoom);
    }

    // Find bounds
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;
    double minLngShift = double.infinity;
    double maxLngShift = -double.infinity;

    for (final LatLng c in routeCoordinates) {
      minLat = math.min(minLat, c.latitude);
      maxLat = math.max(maxLat, c.latitude);
      minLng = math.min(minLng, c.longitude);
      maxLng = math.max(maxLng, c.longitude);
      final double shifted = (c.longitude + 360.0) % 360.0;
      minLngShift = math.min(minLngShift, shifted);
      maxLngShift = math.max(maxLngShift, shifted);
    }

    final double spanNormal = maxLng - minLng;
    final double spanShifted = maxLngShift - minLngShift;
    late final double centerLng;
    if (spanShifted < spanNormal) {
      final double centerShift = (minLngShift + maxLngShift) / 2.0;
      centerLng = ((centerShift + 540.0) % 360.0) - 180.0;
    } else {
      centerLng = (minLng + maxLng) / 2.0;
    }

    final LatLng center = LatLng((minLat + maxLat) / 2, centerLng);

    final double latDiff = maxLat - minLat;
    final double lngDiff = math.min(spanNormal.abs(), spanShifted.abs());
    final maxDiff = math.max(latDiff, lngDiff);

    final baseZoom = switch (maxDiff) {
      > 50 => 2.0,
      > 30 => 3.0,
      > 20 => 4.0,
      > 15 => 4.5,
      > 10 => 5.0,
      > 7 => 5.5,
      > 5 => 6.0,
      > 3 => 6.5,
      > 2 => 7.0,
      > 1 => 7.5,
      _ => 8.0,
    };

    final double adjustedZoom = baseZoom + zoomAdjustment;

    if (enforceBounds) {
      final double clampedZoom =
          adjustedZoom.clamp(minZoom, maxZoom).toDouble();
      return (center: center, zoom: clampedZoom);
    }

    return (center: center, zoom: adjustedZoom);
  }

  /// Build padded LatLng bounds around a set of coordinates.
  ///
  /// Padding is applied as a fraction of the span in each dimension with a
  /// minimum degree pad to ensure usable bounds for short routes.
  static LatLngBounds buildPaddedBounds(
    List<LatLng> coordinates, {
    double paddingFactor = 0.025,
    double minPadDegrees = 0.09,
  }) {
    if (coordinates.isEmpty) {
      return LatLngBounds(const LatLng(-85, -180), const LatLng(85, 180));
    }
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;
    for (final LatLng c in coordinates) {
      if (c.latitude < minLat) minLat = c.latitude;
      if (c.latitude > maxLat) maxLat = c.latitude;
      if (c.longitude < minLng) minLng = c.longitude;
      if (c.longitude > maxLng) maxLng = c.longitude;
    }
    final double latSpan = (maxLat - minLat).abs();
    final double lngSpan = (maxLng - minLng).abs();
    final double latPad = (latSpan * paddingFactor).clamp(minPadDegrees, 90.0);
    final double lngPad = (lngSpan * paddingFactor).clamp(minPadDegrees, 180.0);
    final LatLng southWest = LatLng(
      (minLat - latPad).clamp(-85.0, 85.0),
      (minLng - lngPad).clamp(-180.0, 180.0),
    );
    final LatLng northEast = LatLng(
      (maxLat + latPad).clamp(-85.0, 85.0),
      (maxLng + lngPad).clamp(-180.0, 180.0),
    );
    return LatLngBounds(southWest, northEast);
  }

  /// Get geographic position along the route at normalized progress (0..1).
  static LatLng positionAtProgress(List<LatLng> ports, double progress) {
    if (ports.isEmpty) {
      return const LatLng(0, 0);
    }
    if (ports.length == 1) {
      return ports.first;
    }
    final double clamped = progress.clamp(0.0, 1.0);
    final int totalSegments = ports.length - 1;
    final double segProgress = clamped * totalSegments;
    int segIndex = segProgress.floor();
    if (segIndex >= totalSegments) segIndex = totalSegments - 1;
    final double t = segProgress - segIndex;
    final LatLng start = ports[segIndex];
    final LatLng end = ports[segIndex + 1];
    return interpolateLatLng(start, end, t);
  }

  // ======================
  // Offline MBTiles (vector)
  // ======================

  /// Ensure a MBTiles file is available from assets.
  ///
  /// This method copies the MBTiles file from assets to the application's
  /// internal storage if it's not already present.
  static Future<String> ensureMbtilesAvailableFromAssets({
    required String assetPath,
  }) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String fileName = path.basename(assetPath);
    final String filePath = path.join(appDocumentsDir.path, fileName);

    if (await File(filePath).exists()) {
      return filePath;
    }

    final ByteData data = await rootBundle.load(assetPath);
    await File(filePath).writeAsBytes(data.buffer.asUint8List());
    return filePath;
  }

  /// Build a [TileProviders] object from a single [VectorTileProvider].
  static TileProviders createTileProviders({
    required VectorTileProvider provider,
    required String sourceName,
  }) {
    return TileProviders(<String, VectorTileProvider>{sourceName: provider});
  }

  /// Build a [MapConfig] for offline vector maps using a local style and providers.
  static MapConfig buildOfflineVectorMapConfig({
    required String userAgentPackageName,
    required String styleAssetPath,
    required TileProviders providers,
    required double minZoom,
    required double maxZoom,
    required double initialZoom,
    required bool canDrag,
    required bool canRotate,
    required bool canPinch,
  }) {
    return MapConfig(
      minZoom: minZoom,
      maxZoom: maxZoom,
      initialZoom: initialZoom,
      userAgentPackageName: userAgentPackageName,
      allowDrag: canDrag,
      allowRotate: canRotate,
      allowPinch: canPinch,
      tilesConfig: LocalVectorTilesConfig(
        styleAssetPath: styleAssetPath,
        providers: providers,
      ),
    );
  }

  static Future<MapConfig> buildOfflineVectorMapConfigFromAssets({
    required MapConfig baseConfig,
    required String styleAssetPath,
    required String mbtilesAssetPath,
    required VectorTileProvider Function(String mbtilesPath) createProvider,
    required String sourceName,
  }) async {
    final String mbtilesPath = await ensureMbtilesAvailableFromAssets(
      assetPath: mbtilesAssetPath,
    );
    final VectorTileProvider provider = createProvider(mbtilesPath);
    final TileProviders providers = createTileProviders(
      provider: provider,
      sourceName: sourceName,
    );
    return MapConfig(
      minZoom: baseConfig.minZoom,
      maxZoom: baseConfig.maxZoom,
      initialZoom: baseConfig.initialZoom,
      defaultLocation: baseConfig.defaultLocation,
      allowDrag: baseConfig.allowDrag,
      allowRotate: baseConfig.allowRotate,
      allowPinch: baseConfig.allowPinch,
      userAgentPackageName: baseConfig.userAgentPackageName,
      tilesConfig: LocalVectorTilesConfig(
        styleAssetPath: styleAssetPath,
        providers: providers,
      ),
    );
  }

  /// Read a vector style JSON from assets and construct a [Style] using
  /// the provided [TileProviders]. This avoids network fetching for styles.
  static Future<Style> readVectorStyleFromAssets({
    required String styleAssetPath,
    required TileProviders providers,
    Logger? logger,
  }) async {
    final String styleText = await rootBundle.loadString(styleAssetPath);
    final Map<String, dynamic> style =
        jsonDecode(styleText) as Map<String, dynamic>;

    final String? name = style['name'] as String?;
    final Theme theme = ThemeReader(
      logger: logger ?? const Logger.noop(),
    ).read(style);

    // Resolve sprites locally if present
    SpriteStyle? sprites;
    final Object? spriteField = style['sprite'];
    if (spriteField is String && spriteField.trim().isNotEmpty) {
      // Expect a base path without extension, e.g. assets/styles/sprites/sprite
      final String base = spriteField.replaceFirst(RegExp(r'^asset://'), '');
      final String jsonPath = '$base.json';
      final String pngPath = '$base.png';
      try {
        final String spritesJsonText = await rootBundle.loadString(jsonPath);
        final Map<String, dynamic> spritesJson =
            jsonDecode(spritesJsonText) as Map<String, dynamic>;
        final SpriteIndex index = SpriteIndexReader(
          logger: logger ?? const Logger.noop(),
        ).read(spritesJson);
        sprites = SpriteStyle(
          atlasProvider: () async {
            final ByteData data = await rootBundle.load(pngPath);
            return data.buffer.asUint8List(
              data.offsetInBytes,
              data.lengthInBytes,
            );
          },
          index: index,
        );
      } catch (_) {
        // Leave sprites null if any asset missing
      }
    }

    // Optional center/zoom from style
    LatLng? centerPoint;
    double? zoom;
    final Object? center = style['center'];
    if (center is List && center.length == 2) {
      centerPoint = LatLng(
        (center[1] as num).toDouble(),
        (center[0] as num).toDouble(),
      );
    }
    final Object? zoomObj = style['zoom'];
    if (zoomObj is num) {
      zoom = zoomObj.toDouble();
      if (zoom < 2) {
        zoom = null;
        centerPoint = null;
      }
    }

    return Style(
      name: name,
      theme: theme,
      providers: providers,
      sprites: sprites,
      center: centerPoint,
      zoom: zoom,
    );
  }
}

/// Efficient, reusable path builder that avoids per-frame allocations.
class RoutePathComputer {
  final List<LatLng> _buffer = <LatLng>[];

  List<LatLng> buildStaticInto(List<LatLng> ports, double progress) {
    _buffer.clear();
    if (ports.isEmpty) return _buffer;
    if (progress <= 0) {
      _buffer.add(ports.first);
      return _buffer;
    }
    if (ports.length < 2) {
      _buffer.addAll(ports);
      return _buffer;
    }

    final int totalSegments = ports.length - 1;
    final double segmentProgress = progress.clamp(0.0, 1.0) * totalSegments;
    final int completedSegments = segmentProgress.floor();
    final double partialProgress = segmentProgress - completedSegments;

    if (completedSegments > 0) {
      _buffer.addAll(ports.take(completedSegments + 1));
    }
    if (partialProgress > 0 && completedSegments < totalSegments) {
      final LatLng start = ports[completedSegments];
      final LatLng end = ports[completedSegments + 1];
      if (completedSegments == 0 && _buffer.isEmpty) {
        _buffer.add(start);
      }
      _buffer.add(MapUtilities.interpolateLatLng(start, end, partialProgress));
    }
    return _buffer;
  }

  List<LatLng> buildAnimatedInto(
    List<LatLng> ports,
    double fromProgress,
    double toProgress,
    double animationT,
  ) {
    _buffer.clear();
    if (ports.isEmpty) return _buffer;
    if (ports.length < 2) return _buffer..add(ports.first);

    if ((fromProgress - toProgress).abs() < 0.001) {
      return buildStaticInto(ports, toProgress);
    }

    final bool isForward = toProgress > fromProgress;
    if (isForward) {
      final double cap = math.min(
        fromProgress + (animationT * (toProgress - fromProgress)),
        toProgress,
      );
      return buildStaticInto(ports, cap);
    } else {
      final double cap = math.max(
        fromProgress - (animationT * (fromProgress - toProgress)),
        toProgress,
      );
      return buildStaticInto(ports, cap);
    }
  }
}
