import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:interactive_map_demo/common/map_config.dart';
import 'package:interactive_map_demo/common/map_utilities.dart';
import 'package:interactive_map_demo/itinerary_map/widgets/itinerary_map_bottom_sheet.dart';
import 'package:interactive_map_demo/itinerary_map/widgets/itinerary_map_markers.dart';
import 'package:interactive_map_demo/itinerary_map/widgets/itinerary_map_polylines.dart';
import 'package:interactive_map_demo/itinerary_map/widgets/itinerary_map_tile_layers.dart';
import 'package:latlong2/latlong.dart';

import 'itinerary_map_controller.dart';
import 'models/cruise_itinerary.dart';

/// Interactive itinerary map using Flutter Map with real world tiles
class ItineraryMap extends StatefulWidget {
  const ItineraryMap({
    super.key,
    required this.cruiseTitle,
    required this.itineraryDays,
    required this.selectedItineraryDay,
    required this.mapConfig,
    required this.routeCoordinates,
    this.controller,
  });

  final String cruiseTitle;
  final List<ItineraryDay> itineraryDays;
  final ItineraryDay selectedItineraryDay;
  final MapConfig mapConfig;
  final List<LatLng> routeCoordinates;
  final ItineraryMapController? controller;

  @override
  State<ItineraryMap> createState() => _ItineraryMapState();
}

class _ItineraryMapState extends State<ItineraryMap>
    with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  late final AnimationController _routeProgressController;
  late final RoutePathComputer _pathComputer;

  double _routeAnimationProgress = 1.0;
  double _fromDayProgress = 0.0;
  double _toDayProgress = 1.0;
  late ItineraryDay _selectedDay;

  // Cached map bounds
  late final ({LatLng center, double zoom}) _mapBounds;
  late final LatLngBounds _routeBounds;
  late final List<LatLng> ports;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _routeProgressController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pathComputer = RoutePathComputer();

    // Set up route progress animation listener
    _routeProgressController.addListener(() {
      setState(() {
        _routeAnimationProgress = _routeProgressController.value;
      });
    });

    // Start idle at first port progress to avoid initial jump
    _routeProgressController.value = 0.0;
    if (widget.itineraryDays.isNotEmpty &&
        widget.itineraryDays.first.port != null) {
      _toDayProgress = 0.0; // first port is always progress 0
    } else {
      _toDayProgress = 0.0;
    }

    // Initialize selection from the provided selected day if present in list
    if (widget.itineraryDays.isNotEmpty) {
      final int idx = widget.itineraryDays.indexOf(widget.selectedItineraryDay);
      _selectedDay =
          idx != -1 ? widget.selectedItineraryDay : widget.itineraryDays.first;
    }

    _mapBounds = MapUtilities.calculateMapBounds(
      routeCoordinates: widget.routeCoordinates,
      initialZoom: widget.mapConfig.initialZoom,
      minZoom: widget.mapConfig.minZoom,
      maxZoom: widget.mapConfig.maxZoom,
      zoomAdjustment: 0.5,
    );
    _routeBounds = MapUtilities.buildPaddedBounds(widget.routeCoordinates);
    ports =
        widget.itineraryDays
            .where((day) => day.port != null)
            .map((day) => MapUtilities.toLatLng(day.port!.coordinates))
            .toList();

    // Center the map on the initial day (selected or first) at the max zoom
    // to allow immediate navigation between days without manual zooming.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerToDay(widget.selectedItineraryDay, animate: false);
    });

    // Bind controller if provided
    widget.controller?.bind(
      selectDay: _onPortSelected,
      centerToProgress: (double progress, {bool animate = true}) {
        _centerToProgress(progress, animate: animate);
      },
      centerToBounds: ({bool animate = true}) {
        _centerToBounds(animate: animate);
      },
    );
  }

  @override
  void dispose() {
    widget.controller?.unbind();
    _mapController.dispose();
    _routeProgressController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ItineraryMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.unbind();
      widget.controller?.bind(
        selectDay: _onPortSelected,
        centerToProgress: (double progress, {bool animate = true}) {
          _centerToProgress(progress, animate: animate);
        },
        centerToBounds: ({bool animate = true}) {
          _centerToBounds(animate: animate);
        },
      );
    }

    // No vector error state here; tile widget owns it
  }

  void _onPortSelected(ItineraryDay day) {
    final ItineraryDay? previousSelectedDay = _selectedDay;
    setState(() {
      _selectedDay = day;
    });

    // Note: We avoid an early center-to-port animation here to prevent
    // double animateTo calls (which could cause jitter). We will center
    // precisely on the day's progress below with a single animateTo.

    // Center/zoom based on the selected day (last day shows full route)
    _centerToDay(day);

    // Animate route progress using previous selection for better continuity
    _animateRouteProgress(day, previousSelectedDay);
  }

  void _animateRouteProgress(
    ItineraryDay selectedDay,
    ItineraryDay? previousSelectedDay,
  ) {
    final selectedDayIndex = widget.itineraryDays.indexOf(selectedDay);
    if (selectedDayIndex == -1) return;

    // If we have no route, nothing to animate
    if (ports.isEmpty) return;

    if (ports.length <= 1) {
      _fromDayProgress = _toDayProgress;
      _toDayProgress = 1.0;
      _routeProgressController.animateTo(1.0);
      return;
    }

    if (selectedDay.port == null) {
      // Sea day: animate from current overall progress to the sea-day progress
      // This ensures when navigating from a next port back to a sea day, we
      // only animate the portion from that port down to the sea-day position.
      final double prev = _toDayProgress;
      final double seaProgress = MapUtilities.computeDayProgress<ItineraryDay>(
        days: widget.itineraryDays,
        dayIndex: widget.itineraryDays.indexOf(selectedDay),
        hasPort: (day) => day.port != null,
      );
      _fromDayProgress = prev.clamp(0.0, 1.0);
      _toDayProgress = seaProgress.clamp(0.0, 1.0);
    } else {
      // Port day: animate to port progress as usual
      final targetProgress = MapUtilities.computeDayProgress<ItineraryDay>(
        days: widget.itineraryDays,
        dayIndex: widget.itineraryDays.indexOf(selectedDay),
        hasPort: (day) => day.port != null,
      );
      // If coming from an immediately preceding sea day, ensure the start
      // of this animation matches the end of that sea-day chunk to avoid
      // visual resets.
      if (previousSelectedDay != null && previousSelectedDay.port == null) {
        final int prevIndex = widget.itineraryDays.indexOf(previousSelectedDay);
        if (prevIndex >= 0) {
          final chunk = MapUtilities.computeSeaDayChunkProgress<ItineraryDay>(
            days: widget.itineraryDays,
            seaDayIndex: prevIndex,
            hasPort: (day) => day.port != null,
          );
          _fromDayProgress = chunk.to.clamp(0.0, 1.0);
        } else {
          _fromDayProgress = _toDayProgress;
        }
      } else {
        _fromDayProgress = _toDayProgress;
      }
      _toDayProgress = targetProgress.clamp(0.0, 1.0);
    }

    // Animate to new progress (always from 0 → 1 to respect direction by from/to)
    _routeProgressController
      ..reset()
      ..forward();
  }

  /// Center and zoom according to the selected [day].
  /// - For the last day: zoom out to show the entire route bounds.
  /// - Otherwise: center to the day's progress along the route at max zoom.
  void _centerToDay(ItineraryDay day, {bool animate = true}) {
    if (widget.itineraryDays.isEmpty || ports.isEmpty) return;
    final bool isLastDay =
        widget.itineraryDays.indexOf(day) == widget.itineraryDays.length - 1;
    if (isLastDay) {
      if (animate) {
        _mapController.animateTo(
          dest: _mapBounds.center,
          zoom: _mapBounds.zoom,
          duration: MapConfig.centerToBounds,
          curve: MapConfig.cameraCurve,
        );
      } else {
        _mapController.mapController.move(_mapBounds.center, _mapBounds.zoom);
      }
      return;
    }

    final int dayIndex = widget.itineraryDays.indexOf(day);
    final double dayProgress = MapUtilities.computeDayProgress<ItineraryDay>(
      days: widget.itineraryDays,
      dayIndex: dayIndex,
      hasPort: (d) => d.port != null,
    );
    final LatLng focus = MapUtilities.positionAtProgress(ports, dayProgress);
    if (animate) {
      _mapController.animateTo(
        dest: focus,
        zoom: widget.mapConfig.maxZoom,
        duration: MapConfig.centerToFocus,
        curve: MapConfig.cameraCurve,
      );
    } else {
      _mapController.mapController.move(focus, widget.mapConfig.maxZoom);
    }
  }

  void _centerToProgress(double progress, {bool animate = true}) {
    if (ports.isEmpty) return;
    final LatLng focus = MapUtilities.positionAtProgress(ports, progress);
    if (animate) {
      _mapController.animateTo(
        dest: focus,
        zoom: widget.mapConfig.maxZoom,
        duration: MapConfig.centerToFocus,
        curve: MapConfig.cameraCurve,
      );
    } else {
      _mapController.mapController.move(focus, widget.mapConfig.maxZoom);
    }
  }

  void _centerToBounds({bool animate = true}) {
    if (animate) {
      _mapController.animateTo(
        dest: _mapBounds.center,
        zoom: _mapBounds.zoom,
        duration: MapConfig.centerToBounds,
        curve: MapConfig.cameraCurve,
      );
    } else {
      _mapController.mapController.move(_mapBounds.center, _mapBounds.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.cruiseTitle),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController.mapController,
            options: MapOptions(
              initialCenter: _mapBounds.center,
              initialZoom: _mapBounds.zoom,
              minZoom: _mapBounds.zoom,
              maxZoom: widget.mapConfig.maxZoom,
              cameraConstraint: CameraConstraint.containCenter(
                bounds: _routeBounds,
              ),
              interactionOptions: MapUtilities.buildInteractionOptions(
                canDrag: false,
                canRotate: false,
                canPinch: false,
              ),
            ),
            children: [
              ItineraryMapTileLayers(mapConfig: widget.mapConfig),
              if (ports.isNotEmpty)
                ItineraryMapPolylines(
                  ports: ports,
                  fromProgress: _fromDayProgress,
                  toProgress: _toDayProgress,
                  animationT: _routeAnimationProgress,
                  pathComputer: _pathComputer,
                ),
              ItineraryMapMarkers(
                itineraryDays: widget.itineraryDays,
                onDaySelected: _onPortSelected,
                selectedItineraryDay: _selectedDay,
                uniquePortDays:
                    MapUtilities.computeUniquePortDays<ItineraryDay>(
                      days: widget.itineraryDays,
                      getPortIdOrNull: (ItineraryDay d) => d.port?.id,
                      isAnchorDay:
                          (ItineraryDay d) =>
                              d.dayType == ItineraryDayType.embarkation ||
                              d.dayType == ItineraryDayType.disembarkation,
                    ),
              ),
            ],
          ),
          ItineraryMapBottomSheet(
            day: _selectedDay,
            cruiseTitle: widget.cruiseTitle,
            itineraryDays: widget.itineraryDays,
            selectedItineraryDay: _selectedDay,
            onDaySelected: _onPortSelected,
            onHeightChanged: (height) {},
          ),
        ],
      ),
    );
  }
}
