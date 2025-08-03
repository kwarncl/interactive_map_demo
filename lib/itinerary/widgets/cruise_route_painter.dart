import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/cruise_itinerary.dart';

/// Custom painter for drawing the cruise route with progress indication
class CruiseRoutePainter extends CustomPainter {
  const CruiseRoutePainter({
    required this.itinerary,
    this.selectedDay,
    required this.imageSize,
    required this.routePositions,
    required this.animationProgress,
    this.fromDayProgress = 0.0,
    this.toDayProgress = 1.0,
  });

  final CruiseItinerary itinerary;
  final ItineraryDay? selectedDay;
  final Size imageSize;
  final List<Offset> routePositions;
  final double animationProgress;
  final double fromDayProgress;
  final double toDayProgress;

  @override
  void paint(Canvas canvas, Size size) {
    // Use the route positions passed from the main widget (port positions only)
    if (routePositions.length < 2) return;

    // Calculate progress based on selected day (convert to port index)
    final selectedDayIndex =
        selectedDay != null
            ? itinerary.days.indexOf(selectedDay!)
            : itinerary.days.length - 1;

    final selectedPortIndex = _getPortIndexForDay(selectedDayIndex);

    // Create the complete route path using port positions with smooth curves
    final routePath = Path();
    routePath.moveTo(routePositions[0].dx, routePositions[0].dy);

    _addCurvedPathSegments(
      routePath,
      routePositions,
      0,
      routePositions.length - 1,
    );

    // Draw the complete route background (gray)
    final backgroundPaint =
        Paint()
          ..color = Colors.grey.shade400
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, backgroundPaint);

    // Draw completed route (solid blue) - handle both port and sea days
    _drawCompletedRoute(
      canvas,
      selectedDayIndex,
      selectedPortIndex,
      animationProgress,
    );

    // Draw future route - handle both port and sea days
    _drawFutureRoute(canvas, selectedDayIndex, selectedPortIndex);

    // Sea day dots removed - routes now flow smoothly between ports only
  }

  /// Draw the completed route with animated progress
  void _drawCompletedRoute(
    Canvas canvas,
    int selectedDayIndex,
    int selectedPortIndex,
    double routeAnimationProgress,
  ) {
    if (routePositions.length < 2) return;

    // If no animation is needed (same progress or no change), draw static route
    if ((fromDayProgress - toDayProgress).abs() < 0.001) {
      if (toDayProgress > 0) {
        _drawStaticRoutePath(canvas, toDayProgress);
      }
      return;
    }

    // Determine if we're moving forward or backward
    final isForwardAnimation = toDayProgress > fromDayProgress;

    if (isForwardAnimation) {
      // Forward animation: day 3 -> day 4 (fill the path)
      final progressRange = toDayProgress - fromDayProgress;
      final animatedProgress =
          fromDayProgress + (routeAnimationProgress * progressRange);

      // Draw static completed route up to the starting point
      if (fromDayProgress > 0) {
        _drawStaticRoutePath(canvas, fromDayProgress);
      }

      // Draw animated route from starting point to current progress
      if (animatedProgress > fromDayProgress) {
        _drawAnimatedRouteSegment(canvas, fromDayProgress, animatedProgress);
      }
    } else {
      // Reverse animation: day 4 -> day 3 (unfill the path)
      final progressRange = fromDayProgress - toDayProgress;
      final animatedProgress =
          fromDayProgress - (routeAnimationProgress * progressRange);

      // Draw static completed route up to the target (final lower) point
      if (toDayProgress > 0) {
        _drawStaticRoutePath(canvas, toDayProgress);
      }

      // Draw the shrinking animated route from target to current progress
      if (animatedProgress > toDayProgress) {
        _drawAnimatedRouteSegment(canvas, toDayProgress, animatedProgress);
      }
    }
  }

  /// Draw static completed route up to a specific progress point
  void _drawStaticRoutePath(Canvas canvas, double progress) {
    if (progress <= 0) return;

    final totalSegments = routePositions.length - 1;
    final segmentProgress = progress * totalSegments;
    final completedSegments = segmentProgress.floor();
    final partialProgress = segmentProgress - completedSegments;

    final completedPaint =
        Paint()
          ..color = const Color(0xFF1E40AF) // Royal blue
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Draw completed segments
    if (completedSegments > 0) {
      final completedPath = Path();
      completedPath.moveTo(routePositions[0].dx, routePositions[0].dy);

      _addCurvedPathSegments(
        completedPath,
        routePositions,
        0,
        completedSegments,
      );

      canvas.drawPath(completedPath, completedPaint);
    }

    // Draw partial segment
    if (partialProgress > 0 && completedSegments < totalSegments) {
      _drawPartialSegment(
        canvas,
        completedSegments,
        completedSegments + 1,
        partialProgress,
        false, // Not future segment
      );
    }
  }

  /// Draw animated route segment between two progress points
  void _drawAnimatedRouteSegment(
    Canvas canvas,
    double startProgress,
    double endProgress,
  ) {
    if (startProgress >= endProgress || endProgress <= 0) return;

    final totalSegments = routePositions.length - 1;
    final startSegmentProgress = startProgress * totalSegments;
    final endSegmentProgress = endProgress * totalSegments;

    final startSegment = startSegmentProgress.floor();
    final endSegment = endSegmentProgress.floor();
    final startPartial = startSegmentProgress - startSegment;
    final endPartial = endSegmentProgress - endSegment;

    final completedPaint =
        Paint()
          ..color = const Color(0xFF1E40AF) // Royal blue
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // If animation spans multiple complete segments
    if (endSegment > startSegment) {
      // Draw the first partial segment (from startPartial to end of segment)
      if (startPartial < 1.0) {
        _drawPartialSegmentRange(
          canvas,
          startSegment,
          startSegment + 1,
          startPartial,
          1.0,
        );
      }

      // Draw complete segments in between
      if (endSegment > startSegment + 1) {
        final middlePath = Path();
        final startPoint = routePositions[startSegment + 1];
        middlePath.moveTo(startPoint.dx, startPoint.dy);

        _addCurvedPathSegments(
          middlePath,
          routePositions,
          startSegment + 1,
          endSegment,
        );

        canvas.drawPath(middlePath, completedPaint);
      }

      // Draw the final partial segment (from start to endPartial)
      if (endPartial > 0.0 && endSegment < totalSegments) {
        _drawPartialSegmentRange(
          canvas,
          endSegment,
          endSegment + 1,
          0.0,
          endPartial,
        );
      }
    } else {
      // Animation is within a single segment
      _drawPartialSegmentRange(
        canvas,
        startSegment,
        startSegment + 1,
        startPartial,
        endPartial,
      );
    }
  }

  /// Draw a portion of a segment between two progress points within the segment
  void _drawPartialSegmentRange(
    Canvas canvas,
    int fromPortIndex,
    int toPortIndex,
    double startProgress,
    double endProgress,
  ) {
    if (fromPortIndex >= routePositions.length ||
        toPortIndex >= routePositions.length ||
        startProgress >= endProgress)
      return;

    final startPoint = routePositions[fromPortIndex];
    final endPoint = routePositions[toPortIndex];

    // Calculate control point for the curve
    final controlPoint = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
      startPoint.dy +
          (endPoint.dy - startPoint.dy) * 0.5 +
          _getCurveOffset(startPoint, endPoint),
    );

    // Create the full curved path
    final fullPath = Path();
    fullPath.moveTo(startPoint.dx, startPoint.dy);
    fullPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Extract the specific portion we want
    final pathMetrics = fullPath.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final startLength = pathMetric.length * startProgress;
      final endLength = pathMetric.length * endProgress;
      final partialPath = pathMetric.extractPath(startLength, endLength);

      final progressPaint =
          Paint()
            ..color = const Color(0xFF1E40AF) // Royal blue
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawPath(partialPath, progressPaint);
      break; // Only process the first metric
    }
  }

  /// Draw a partial segment between two ports to show sea day progress
  void _drawPartialSegment(
    Canvas canvas,
    int fromPortIndex,
    int toPortIndex,
    double progress, [
    bool isFuture = false,
  ]) {
    if (fromPortIndex >= routePositions.length ||
        toPortIndex >= routePositions.length)
      return;

    final startPoint = routePositions[fromPortIndex];
    final endPoint = routePositions[toPortIndex];

    // Calculate control point for the curve (same logic as _addCurvedPathSegments)
    final controlPoint = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.5,
      startPoint.dy +
          (endPoint.dy - startPoint.dy) * 0.5 +
          _getCurveOffset(startPoint, endPoint),
    );

    // Create the full curved path
    final fullPath = Path();
    fullPath.moveTo(startPoint.dx, startPoint.dy);
    fullPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Extract partial path
    final pathMetrics = fullPath.computeMetrics();
    for (final pathMetric in pathMetrics) {
      Path partialPath;

      if (isFuture) {
        // For future segment, draw from progress point to end
        final startLength = pathMetric.length * progress;
        partialPath = pathMetric.extractPath(startLength, pathMetric.length);
      } else {
        // For completed segment, draw from start to progress point
        final partialLength = pathMetric.length * progress;
        partialPath = pathMetric.extractPath(0.0, partialLength);
      }

      final progressPaint =
          Paint()
            ..color =
                isFuture
                    ? Colors
                        .grey
                        .shade400 // Gray for future
                    : const Color(0xFF1E40AF) // Royal blue for completed
            ..strokeWidth = isFuture ? 2.0 : 4.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawPath(partialPath, progressPaint);
      break; // Only process the first metric
    }
  }

  /// Draw the future route with special handling for sea days
  void _drawFutureRoute(
    Canvas canvas,
    int selectedDayIndex,
    int selectedPortIndex,
  ) {
    // Calculate the actual progress to avoid overlapping with completed route
    final currentProgress = toDayProgress;
    final totalSegments = routePositions.length - 1;
    final currentSegmentIndex = (currentProgress * totalSegments).floor();

    // Only draw future route beyond the current progress
    if (currentSegmentIndex >= totalSegments) return;

    final startPortIndex = currentSegmentIndex + 1;
    if (startPortIndex >= routePositions.length) return;

    // Draw future route from the next port onwards
    final futurePath = Path();
    futurePath.moveTo(
      routePositions[startPortIndex].dx,
      routePositions[startPortIndex].dy,
    );

    _addCurvedPathSegments(
      futurePath,
      routePositions,
      startPortIndex,
      routePositions.length - 1,
    );

    final futurePaint =
        Paint()
          ..color = Colors.grey.shade400
          ..strokeWidth =
              2.0 // Thinner than completed route
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawPath(futurePath, futurePaint);
  }

  /// Convert day index to port index (since route positions only contain ports)
  int _getPortIndexForDay(int dayIndex) {
    int portIndex = 0;
    for (int i = 0; i <= dayIndex && i < itinerary.days.length; i++) {
      if (itinerary.days[i].port != null) {
        if (i == dayIndex) return portIndex;
        portIndex++;
      }
    }
    // If the selected day is a sea day, return the last port index
    return math.max(0, portIndex - 1);
  }

  /// Adds smooth curved segments between route points using quadratic Bézier curves
  void _addCurvedPathSegments(
    Path path,
    List<Offset> positions,
    int startIndex,
    int endIndex,
  ) {
    if (startIndex >= endIndex || positions.length < 2) return;

    for (int i = startIndex + 1; i <= endIndex && i < positions.length; i++) {
      final currentPoint = positions[i - 1];
      final nextPoint = positions[i];

      // Calculate control point for smooth curve
      final controlPoint = Offset(
        currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.5,
        currentPoint.dy +
            (nextPoint.dy - currentPoint.dy) * 0.5 +
            _getCurveOffset(currentPoint, nextPoint),
      );

      // Add quadratic Bézier curve to the path
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        nextPoint.dx,
        nextPoint.dy,
      );
    }
  }

  /// Calculates a gentle curve offset based on the distance and direction between points
  double _getCurveOffset(Offset start, Offset end) {
    final distance = (end - start).distance;
    final perpendicular = math.sin(
      math.atan2(end.dy - start.dy, end.dx - start.dx) + math.pi / 2,
    );

    // Create gentle curves - larger distances get more pronounced curves
    final curveIntensity = math.min(distance * 0.15, 40.0);
    return perpendicular * curveIntensity;
  }

  @override
  bool shouldRepaint(covariant CruiseRoutePainter oldDelegate) {
    return oldDelegate.selectedDay != selectedDay ||
        oldDelegate.itinerary != itinerary ||
        oldDelegate.routePositions != routePositions ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.fromDayProgress != fromDayProgress ||
        oldDelegate.toDayProgress != toDayProgress;
  }
}
