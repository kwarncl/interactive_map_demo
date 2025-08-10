import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:interactive_map_demo/common/map_utilities.dart';
import 'package:latlong2/latlong.dart';

/// Renders the itinerary route using two overlaid polylines:
/// - Traveled path in theme primary color
/// - Upcoming/untraveled path in a subdued onSurface color
class ItineraryPolylineStyle {
  const ItineraryPolylineStyle({
    this.pendingAlpha = 0.1,
    this.strokeWidth = 4.0,
    this.strokeCap = StrokeCap.round,
    this.strokeJoin = StrokeJoin.round,
  });

  final double pendingAlpha;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
}

class ItineraryMapPolylines extends StatefulWidget {
  ItineraryMapPolylines({
    super.key,
    required this.ports,
    required this.fromProgress,
    required this.toProgress,
    required this.animationT,
    required this.pathComputer,
    this.style = const ItineraryPolylineStyle(),
  }) : assert(
         style.pendingAlpha >= 0.0 && style.pendingAlpha <= 1.0,
         'pendingAlpha must be within [0,1]',
       ),
       assert(style.strokeWidth > 0.0, 'strokeWidth must be > 0');

  final List<LatLng> ports;
  final double fromProgress;
  final double toProgress;
  final double animationT;
  final RoutePathComputer pathComputer;
  final ItineraryPolylineStyle style;

  @override
  State<ItineraryMapPolylines> createState() => _ItineraryMapPolylinesState();
}

class _ItineraryMapPolylinesState extends State<ItineraryMapPolylines> {
  final List<LatLng> _traveled = <LatLng>[];
  final List<LatLng> _upcoming = <LatLng>[];

  @override
  void initState() {
    super.initState();
    _recompute();
  }

  @override
  void didUpdateWidget(covariant ItineraryMapPolylines oldWidget) {
    super.didUpdateWidget(oldWidget);
    _recompute();
  }

  void _recompute() {
    _traveled.clear();
    _upcoming.clear();
    final List<LatLng> ports = widget.ports;
    if (ports.length < 2) return;

    final double cap = (widget.fromProgress +
            (widget.animationT * (widget.toProgress - widget.fromProgress)))
        .clamp(0.0, 1.0);

    // Copy computed traveled path into the reusable buffer
    _traveled.addAll(
      widget.pathComputer.buildAnimatedInto(
        ports,
        widget.fromProgress,
        widget.toProgress,
        widget.animationT,
      ),
    );

    switch (cap) {
      case <= 0.0:
        _upcoming.addAll(ports);
      case >= 1.0:
        _upcoming.add(ports.last);
      default:
        final int totalSegments = ports.length - 1;
        final double segProgress = cap * totalSegments;
        final int segIndex = segProgress.floor();
        final double localT = segProgress - segIndex;
        final LatLng split = MapUtilities.interpolateLatLng(
          ports[segIndex],
          ports[segIndex + 1],
          localT,
        );
        _upcoming.add(split);
        _upcoming.addAll(ports.skip(segIndex + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ports.length < 2) {
      return const SizedBox.shrink();
    }

    return PolylineLayer(
      polylines: <Polyline>[
        Polyline(
          points: _upcoming,
          strokeWidth: widget.style.strokeWidth,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: widget.style.pendingAlpha),
          strokeCap: widget.style.strokeCap,
          strokeJoin: widget.style.strokeJoin,
        ),
        Polyline(
          points:
              _traveled.isNotEmpty ? _traveled : <LatLng>[widget.ports.first],
          strokeWidth: widget.style.strokeWidth,
          color: Theme.of(context).colorScheme.primary,
          strokeCap: widget.style.strokeCap,
          strokeJoin: widget.style.strokeJoin,
        ),
      ],
    );
  }
}
