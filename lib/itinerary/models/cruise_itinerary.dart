import 'package:flutter/material.dart';

/// Represents a complete cruise itinerary
class CruiseItinerary {
  const CruiseItinerary({
    required this.cruiseId,
    required this.shipName,
    required this.cruiseName,
    required this.duration,
    required this.embarkationPort,
    required this.disembarkationPort,
    required this.days,
    required this.routeCoordinates,
    required this.mapImagePath,
    this.description = '',
    this.highlights = const [],
  });

  /// Unique identifier for the cruise
  final String cruiseId;

  /// Name of the ship
  final String shipName;

  /// Marketing name of the cruise
  final String cruiseName;

  /// Duration in days
  final int duration;

  /// Starting port
  final PortData embarkationPort;

  /// Ending port (often same as embarkation)
  final PortData disembarkationPort;

  /// List of all days in the itinerary
  final List<ItineraryDay> days;

  /// Coordinates for drawing the route on map
  final List<List<double>> routeCoordinates;

  /// Path to the map image asset
  final String mapImagePath;

  /// Optional description
  final String description;

  /// Cruise highlights
  final List<String> highlights;
}

/// Represents a port of call in a cruise itinerary
class PortData {
  const PortData({
    required this.id,
    required this.name,
    required this.country,
    required this.coordinates,
    this.description = '',
    this.timeZone = 'UTC',
    this.portCode = '',
  });

  /// Unique identifier for the port
  final String id;

  /// Display name of the port (e.g., "St. Thomas")
  final String name;

  /// Country or territory (e.g., "US Virgin Islands")
  final String country;

  /// Geographic coordinates [latitude, longitude]
  final List<double> coordinates;

  /// Optional description of the port
  final String description;

  /// Time zone identifier (e.g., "America/New_York")
  final String timeZone;

  /// Port code if available (e.g., "STT")
  final String portCode;

  /// Get the full display name including country
  String get fullName => '$name, $country';
}

/// Represents a day in the cruise itinerary
class ItineraryDay {
  const ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.dayType,
    this.port,
    this.arrivalTime,
    this.departureTime,
    this.activities = const [],
    this.isBookingAvailable = false,
    this.bookedCount = 0,
  });

  /// Day number in the cruise (1, 2, 3, etc.)
  final int dayNumber;

  /// Date of this day
  final DateTime date;

  /// Type of day (port, sea, embarkation, disembarkation)
  final ItineraryDayType dayType;

  /// Port information (null for sea days)
  final PortData? port;

  /// Arrival time at port (null for sea days and embarkation)
  final TimeOfDay? arrivalTime;

  /// Departure time from port (null for sea days and disembarkation)
  final TimeOfDay? departureTime;

  /// Available activities/excursions
  final List<String> activities;

  /// Whether booking is available for this port
  final bool isBookingAvailable;

  /// Number of booked excursions
  final int bookedCount;

  /// Get day of week name
  String get dayOfWeek {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  /// Get formatted date string
  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  /// Format time for display
  String formatTime(TimeOfDay? time) {
    if (time == null) return '---';
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour < 12 ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  /// Get arrival time formatted
  String get formattedArrivalTime => formatTime(arrivalTime);

  /// Get departure time formatted
  String get formattedDepartureTime => formatTime(departureTime);
}

/// Types of days in an itinerary
enum ItineraryDayType { embarkation, port, sea, disembarkation }

/// Extension to get display names for day types
extension ItineraryDayTypeExtension on ItineraryDayType {
  String get displayName {
    switch (this) {
      case ItineraryDayType.embarkation:
        return 'Embarkation';
      case ItineraryDayType.port:
        return 'Port Call';
      case ItineraryDayType.sea:
        return 'At Sea';
      case ItineraryDayType.disembarkation:
        return 'Disembarkation';
    }
  }
}
