import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomPolylineLayer extends StatelessWidget {
  const CustomPolylineLayer({
    super.key,
    required this.points,
    required this.color,
    this.strokeWidth = 2.0,
    this.borderStrokeWidth = 0.0,
  });

  final List<LatLng> points;
  final Color color;
  final double strokeWidth;
  final double borderStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          strokeWidth: strokeWidth,
          color: color,
          borderStrokeWidth: borderStrokeWidth,
          borderColor: Colors.white.withValues(alpha: 0.6),
        ),
      ],
    );
  }
}
