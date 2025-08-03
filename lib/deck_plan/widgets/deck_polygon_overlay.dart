import 'package:flutter/material.dart';

import '../models/deck_polygon_data.dart';

/// A widget that renders a clickable polygon overlay with borders and fills on deck plans
class DeckPolygonOverlay extends StatelessWidget {
  const DeckPolygonOverlay({
    required this.area,
    required this.imageSize,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final DeckPolygonArea area;
  final Size imageSize;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Convert normalized coordinates to absolute pixels
    final List<Offset> absolutePolygon =
        area.polygon
            .map(
              (point) => Offset(
                point.dx * imageSize.width,
                point.dy * imageSize.height,
              ),
            )
            .toList();

    // Calculate bounding box for positioning
    double minX = absolutePolygon.first.dx;
    double maxX = absolutePolygon.first.dx;
    double minY = absolutePolygon.first.dy;
    double maxY = absolutePolygon.first.dy;

    for (final point in absolutePolygon) {
      minX = minX < point.dx ? minX : point.dx;
      maxX = maxX > point.dx ? maxX : point.dx;
      minY = minY < point.dy ? minY : point.dy;
      maxY = maxY > point.dy ? maxY : point.dy;
    }

    final double width = maxX - minX;
    final double height = maxY - minY;

    // Adjust polygon points relative to the bounding box
    final List<Offset> relativePolygon =
        absolutePolygon
            .map((point) => Offset(point.dx - minX, point.dy - minY))
            .toList();

    return Positioned(
      left: minX,
      top: minY,
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () {
          // Only trigger if the tap is actually within the polygon
          onTap();
        },
        child: CustomPaint(
          size: Size(width, height),
          painter: _PolygonPainter(
            polygon: relativePolygon,
            color: area.color,
            isSelected: isSelected,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for rendering the polygon overlay
class _PolygonPainter extends CustomPainter {
  const _PolygonPainter({
    required this.polygon,
    required this.color,
    required this.isSelected,
  });

  final List<Offset> polygon;
  final Color color;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    if (polygon.length < 3) return;

    final Path polygonPath = Path();
    polygonPath.moveTo(polygon.first.dx, polygon.first.dy);
    for (int i = 1; i < polygon.length; i++) {
      polygonPath.lineTo(polygon[i].dx, polygon[i].dy);
    }
    polygonPath.close();

    // Fill overlay - always visible with low transparency for normal state
    final Paint fillPaint = Paint()..style = PaintingStyle.fill;

    if (isSelected) {
      // Higher opacity when selected but still transparent
      fillPaint.color = color.withValues(alpha: 0.25);
    } else {
      // Very low opacity for normal state
      fillPaint.color = color.withValues(alpha: 0.08);
    }

    canvas.drawPath(polygonPath, fillPaint);

    // Solid border - always visible with 1px thickness
    final Paint borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    if (isSelected) {
      // Full color border when selected
      borderPaint.color = color;
    } else {
      // Semi-transparent border for normal state
      borderPaint.color = color.withValues(alpha: 0.7);
    }

    canvas.drawPath(polygonPath, borderPaint);

    // Always render a completely transparent overlay for hit testing
    // This ensures the entire polygon area is clickable
    final Paint hitTestPaint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill;

    canvas.drawPath(polygonPath, hitTestPaint);
  }

  @override
  bool shouldRepaint(covariant _PolygonPainter oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.color != color ||
        oldDelegate.polygon != polygon;
  }

  @override
  bool hitTest(Offset position) {
    // Use point-in-polygon algorithm for precise hit testing
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      final Offset pi = polygon[i];
      final Offset pj = polygon[j];

      if (((pi.dy > position.dy) != (pj.dy > position.dy)) &&
          (position.dx <
              (pj.dx - pi.dx) * (position.dy - pi.dy) / (pj.dy - pi.dy) +
                  pi.dx)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }
}
