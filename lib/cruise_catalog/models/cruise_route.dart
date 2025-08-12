import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// Represents a port location with name and coordinates
class PortLocation {
  const PortLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.description,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? description;

  LatLng get latLng => LatLng(latitude, longitude);

  @override
  String toString() => '$name ($country)';
}

/// Represents a cruise route with waypoints and visual styling
class CruiseRoute {
  const CruiseRoute({
    required this.routeId,
    required this.title,
    required this.waypoints,
    required this.routeColor,
    this.description,
    this.region,
    this.strokeWidth = 3.0,
  });

  final String routeId;
  final String title;
  final String? description;
  final String? region;
  final List<PortLocation> waypoints;
  final Color routeColor;
  final double strokeWidth;

  /// Get the starting port of the route
  PortLocation get startPort => waypoints.first;

  /// Get the ending port of the route (may be same as start for round trips)
  PortLocation get endPort => waypoints.last;

  /// Get all waypoint coordinates as LatLng list
  List<LatLng> get coordinates => waypoints.map((port) => port.latLng).toList();

  /// Check if this is a round trip (starts and ends at same port)
  bool get isRoundTrip => startPort.name == endPort.name;

  /// Get the geographic center of the route for map centering
  LatLng get centerPoint {
    final lats = waypoints.map((port) => port.latitude);
    final lngs = waypoints.map((port) => port.longitude);

    final centerLat = (lats.reduce((a, b) => a + b)) / waypoints.length;
    final centerLng = (lngs.reduce((a, b) => a + b)) / waypoints.length;

    return LatLng(centerLat, centerLng);
  }
}
