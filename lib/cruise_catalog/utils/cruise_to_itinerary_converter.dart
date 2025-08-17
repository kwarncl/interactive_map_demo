import 'package:flutter/material.dart';

import '../../itinerary_map/models/cruise_itinerary.dart';
import '../models/cruise_product.dart';
import '../models/cruise_route.dart';

/// Utility class to convert cruise catalog data to itinerary map format
class CruiseToItineraryConverter {
  /// Convert a CruiseProduct to CruiseItinerary for the itinerary map
  static CruiseItinerary convertToItinerary(CruiseProduct cruise) {
    // Extract duration in days from string like "7 days" or "12 nights"
    final durationMatch = RegExp(r'(\d+)').firstMatch(cruise.duration);
    final duration =
        durationMatch != null ? int.parse(durationMatch.group(1)!) : 7;

    // Convert waypoints to itinerary days
    final days = _convertWaypointsToDays(cruise.route.waypoints, duration);

    // Convert coordinates to the format expected by itinerary map
    final routeCoordinates =
        cruise.route.coordinates
            .map((latLng) => [latLng.latitude, latLng.longitude])
            .toList();

    return CruiseItinerary(
      cruiseId: cruise.productId,
      shipName: cruise.shipName,
      cruiseName: cruise.title,
      duration: duration,
      embarkationPort: _convertPortLocation(cruise.route.startPort),
      disembarkationPort: _convertPortLocation(cruise.route.endPort),
      days: days,
      routeCoordinates: routeCoordinates,
      mapImagePath: 'assets/images/world_map.jpg', // Default world map
      description: cruise.description ?? '',
      highlights: cruise.highlights,
    );
  }

  /// Convert PortLocation to PortData
  static PortData _convertPortLocation(PortLocation port) {
    return PortData(
      id: port.name.toLowerCase().replaceAll(' ', '_'),
      name: port.name,
      country: port.country ?? 'Unknown',
      coordinates: [port.latitude, port.longitude],
      description: port.description ?? '',
    );
  }

  /// Convert waypoints to itinerary days
  static List<ItineraryDay> _convertWaypointsToDays(
    List<PortLocation> waypoints,
    int totalDuration,
  ) {
    final days = <ItineraryDay>[];
    final now = DateTime.now();

    // Calculate days per port (including sea days)
    final portCount = waypoints.length;
    final seaDays = totalDuration - portCount;
    final seaDaysPerSegment =
        seaDays > 0 ? (seaDays / (portCount - 1)).ceil() : 0;

    int currentDay = 1;
    int seaDayCounter = 0;

    for (int i = 0; i < waypoints.length; i++) {
      final port = waypoints[i];
      final isFirst = i == 0;
      final isLast = i == waypoints.length - 1;

      // Add sea days before this port (except for first port)
      if (!isFirst && seaDaysPerSegment > 0) {
        for (
          int seaDay = 0;
          seaDay < seaDaysPerSegment && seaDayCounter < seaDays;
          seaDay++
        ) {
          days.add(
            ItineraryDay(
              dayNumber: currentDay++,
              date: now.add(Duration(days: currentDay - 1)),
              dayType: ItineraryDayType.sea,
            ),
          );
          seaDayCounter++;
        }
      }

      // Add port day
      final dayType =
          isFirst
              ? ItineraryDayType.embarkation
              : isLast
              ? ItineraryDayType.disembarkation
              : ItineraryDayType.port;

      days.add(
        ItineraryDay(
          dayNumber: currentDay++,
          date: now.add(Duration(days: currentDay - 1)),
          dayType: dayType,
          port: _convertPortLocation(port),
          arrivalTime: isFirst ? null : const TimeOfDay(hour: 8, minute: 0),
          departureTime: isLast ? null : const TimeOfDay(hour: 17, minute: 0),
          activities: _generateActivities(port),
        ),
      );
    }

    return days;
  }

  /// Generate sample activities for a port
  static List<String> _generateActivities(PortLocation port) {
    final activities = <String>[];

    // Add some sample activities based on port name
    if (port.name.toLowerCase().contains('beach') ||
        port.name.toLowerCase().contains('cay')) {
      activities.addAll(['Beach Day', 'Snorkeling', 'Water Sports']);
    } else if (port.name.toLowerCase().contains('miami')) {
      activities.addAll(['City Tour', 'Shopping', 'Beach Visit']);
    } else {
      activities.addAll(['Port Exploration', 'Local Cuisine', 'Cultural Tour']);
    }

    return activities;
  }
}
