import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
  }) {
    int flags = InteractiveFlag.all;
    if (!canDrag) flags &= ~InteractiveFlag.drag;
    if (!canRotate) flags &= ~InteractiveFlag.rotate;
    if (!canPinch) flags &= ~InteractiveFlag.pinchZoom;

    return InteractionOptions(flags: flags);
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
  /// - **> 3° difference**: Zoom 6.5 (neighborhood view)
  /// - **> 2° difference**: Zoom 7.0 (street view)
  /// - **> 1° difference**: Zoom 7.5 (building view)
  /// - **≤ 1° difference**: Zoom 8.0 (detail view)
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
  ///   negative values zoom out. Default is 0.0 (use computed zoom). This
  ///   unifies the previous padding/zoomBias controls into one parameter.
  /// * [enforceBounds] - Whether to enforce min/max zoom bounds (default: true)
  ///
  /// ## Returns
  /// A record containing:
  /// * [center] - The calculated center point (LatLng) for optimal route display
  /// * [zoom] - The calculated zoom level (double) within the specified bounds
  ///
  /// ## Example
  /// ```dart
  /// // With bounds enforcement (default behavior)
  /// final bounds = MapUtilities.calculateMapBounds(
  ///   routeCoordinates: caribbeanRoute,
  ///   initialZoom: 6.0,
  ///   minZoom: 4.0,
  ///   maxZoom: 15.0,
  ///   padding: 0.05, // 5% padding
  ///   enforceBounds: true, // Default
  /// );
  ///
  /// // Without bounds enforcement (zoom can exceed min/max)
  /// final unconstrainedBounds = MapUtilities.calculateMapBounds(
  ///   routeCoordinates: caribbeanRoute,
  ///   initialZoom: 6.0,
  ///   minZoom: 4.0,
  ///   maxZoom: 15.0,
  ///   padding: 0.05,
  ///   enforceBounds: false, // Allows zoom to exceed bounds
  /// );
  ///
  /// // Use the calculated bounds
  /// mapController.animateTo(
  ///   dest: bounds.center,
  ///   zoom: bounds.zoom,
  /// );
  /// ```
  ///
  /// ## Performance
  /// Time complexity: O(n) where n is the number of route coordinates.
  /// Space complexity: O(1) - only stores min/max values during calculation.
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
      // Center at 0,0 as a neutral fallback. Callers can pass a domain-specific
      // default if needed before invoking this method.
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
      final double base = 8.0 + zoomAdjustment; // detailed view default
      final double zoom =
          enforceBounds ? base.clamp(minZoom, maxZoom).toDouble() : base;
      return (center: center, zoom: zoom);
    }

    // Find bounds of all route coordinates, antimeridian-aware for longitude
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    // Track longitudes in two spaces: normal [-180,180], and shifted [0,360)
    double minLng = double.infinity;
    double maxLng = -double.infinity;
    double minLngShift = double.infinity;
    double maxLngShift = -double.infinity;

    for (final LatLng c in routeCoordinates) {
      minLat = math.min(minLat, c.latitude);
      maxLat = math.max(maxLat, c.latitude);
      // Normal space
      minLng = math.min(minLng, c.longitude);
      maxLng = math.max(maxLng, c.longitude);
      // Shifted space to handle antimeridian-crossing clusters
      final double shifted = (c.longitude + 360.0) % 360.0;
      minLngShift = math.min(minLngShift, shifted);
      maxLngShift = math.max(maxLngShift, shifted);
    }

    // Decide which longitude span is smaller: normal vs shifted
    final double spanNormal = maxLng - minLng; // may be large across +180/-180
    final double spanShifted = maxLngShift - minLngShift; // handles wrap
    late final double centerLng;
    if (spanShifted < spanNormal) {
      // Use shifted space and map back to [-180,180]
      final double centerShift = (minLngShift + maxLngShift) / 2.0;
      centerLng = ((centerShift + 540.0) % 360.0) - 180.0;
    } else {
      centerLng = (minLng + maxLng) / 2.0;
    }

    // Calculate center
    final LatLng center = LatLng((minLat + maxLat) / 2, centerLng);

    // Calculate optimal zoom level
    final double latDiff = maxLat - minLat;
    final double lngDiff = math.min(spanNormal.abs(), spanShifted.abs());
    final maxDiff = math.max(latDiff, lngDiff);

    // Calculate zoom level based on coordinate difference
    // General thresholds for various map regions and scales
    final baseZoom = switch (maxDiff) {
      > 50 => 2.0, // Global view
      > 30 => 3.0, // Continental view
      > 20 => 4.0, // Regional view
      > 15 => 4.5, // Sub-regional view
      > 10 => 5.0, // Local area view
      > 7 => 5.5, // City cluster view
      > 5 => 6.0, // City view
      > 3 => 6.5, // Neighborhood view
      > 2 => 7.0, // Street view
      > 1 => 7.5, // Building view
      _ => 8.0, // Detail view
    };

    // Apply optional zoom adjustment (positive => zoom in, negative => out)
    final double adjustedZoom = baseZoom + zoomAdjustment;

    // Apply bounds enforcement if enabled
    if (enforceBounds) {
      final double clampedZoom =
          adjustedZoom.clamp(minZoom, maxZoom).toDouble();
      return (center: center, zoom: clampedZoom);
    }

    return (center: center, zoom: adjustedZoom);
  }

  /// Build a static polyline path along [ports] up to [progress] (0..1).
  ///
  /// Returns an empty list if there are fewer than 2 ports or progress <= 0.
  static List<LatLng> buildStaticRoutePath(
    List<LatLng> ports,
    double progress,
  ) {
    final RoutePathComputer computer = RoutePathComputer();
    final List<LatLng> buffer = computer.buildStaticInto(ports, progress);
    return List<LatLng>.from(buffer);
  }

  /// Build an animated polyline segment between [startProgress] and [endProgress].
  ///
  /// Returns an empty list if inputs are invalid or fewer than 2 ports.

  /// Build the full animated route given from/to progress and animation value.
  ///
  /// If the progress range is negligible, returns the static path up to
  /// [toProgress] or the first point when empty.
  static List<LatLng> buildAnimatedRouteCoordinates({
    required List<LatLng> ports,
    required double fromProgress,
    required double toProgress,
    required double animationT,
  }) {
    final RoutePathComputer computer = RoutePathComputer();
    final List<LatLng> buffer = computer.buildAnimatedInto(
      ports,
      fromProgress,
      toProgress,
      animationT,
    );
    return List<LatLng>.from(buffer);
  }

  /// Get geographic position along the route at normalized progress (0..1).
  /// Useful for centering/zooming on the currently selected day.
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
}

/// Efficient, reusable path builder that avoids per-frame allocations.
/// Keep one instance per map and reuse across animations.
class RoutePathComputer {
  final List<LatLng> _buffer = <LatLng>[];

  /// Return an internal reusable buffer containing the static path up to progress.
  List<LatLng> buildStaticInto(List<LatLng> ports, double progress) {
    _buffer.clear();
    if (ports.isEmpty) return _buffer; // keep empty; caller should gate
    if (progress <= 0) {
      // Ensure at least one point so polyline bounds never asserts
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

  /// Return an internal reusable buffer containing the animated route for the
  /// current frame. Forward returns static path to `cap`, reverse returns the
  /// shrinking path down to `cap`. Never allocates a new list per call.
  List<LatLng> buildAnimatedInto(
    List<LatLng> ports,
    double fromProgress,
    double toProgress,
    double animationT,
  ) {
    _buffer.clear();
    if (ports.isEmpty) return _buffer; // caller should avoid drawing
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
