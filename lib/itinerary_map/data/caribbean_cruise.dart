import 'package:flutter/material.dart';

import '../models/cruise_itinerary.dart';

/// Norwegian Aqua 7-Day Caribbean Cruise Data
class CaribbeanCruiseData {
  /// The complete Norwegian Aqua Caribbean cruise itinerary
  static final CruiseItinerary norwegianAquaCaribbean = CruiseItinerary(
    cruiseId: 'AQU-7-CRB-MIA-59070',
    shipName: 'Norwegian Aqua',
    cruiseName: '7-Day Caribbean Cruise',
    duration: 7,
    embarkationPort: miamiFlorida,
    disembarkationPort: miamiFlorida,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2024, 11, 16),
        dayType: ItineraryDayType.embarkation,
        port: miamiFlorida,
        departureTime: const TimeOfDay(hour: 17, minute: 30),
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2024, 11, 17),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2024, 11, 18),
        dayType: ItineraryDayType.port,
        port: puertoPlata,
        arrivalTime: const TimeOfDay(hour: 7, minute: 0),
        departureTime: const TimeOfDay(hour: 16, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2024, 11, 19),
        dayType: ItineraryDayType.port,
        port: stThomas,
        arrivalTime: const TimeOfDay(hour: 10, minute: 0),
        departureTime: const TimeOfDay(hour: 19, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2024, 11, 20),
        dayType: ItineraryDayType.port,
        port: tortola,
        arrivalTime: const TimeOfDay(hour: 6, minute: 0),
        departureTime: const TimeOfDay(hour: 14, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2024, 11, 21),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2024, 11, 22),
        dayType: ItineraryDayType.port,
        port: greatStirrupCay,
        arrivalTime: const TimeOfDay(hour: 10, minute: 0),
        departureTime: const TimeOfDay(hour: 18, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2024, 11, 23),
        dayType: ItineraryDayType.disembarkation,
        port: miamiFlorida,
        arrivalTime: const TimeOfDay(hour: 7, minute: 0),
        isBookingAvailable: false,
      ),
    ],
    routeCoordinates: caribbeanRoute,
    mapImagePath: 'assets/images/caribbean_cruise_map.png',
    description:
        'Explore the beautiful Caribbean islands aboard the stunning Norwegian Aqua',
    highlights: [
      'Visit 4 tropical destinations',
      'Relax on pristine beaches',
      'Explore historic St. Thomas',
      'Experience local culture',
    ],
  );

  // Port definitions with latitude/longitude coordinates [lat, lng]
  static const PortData miamiFlorida = PortData(
    id: 'MIA',
    name: 'Miami',
    country: 'Florida, USA',
    coordinates: [25.7617, -80.1918], // Miami coordinates
    portCode: 'MIA',
    description:
        'Gateway to the Caribbean and starting point for this epic transatlantic journey.',
  );

  static const PortData puertoPlata = PortData(
    id: 'POP',
    name: 'Puerto Plata',
    country: 'Dominican Republic',
    coordinates: [19.7939, -70.6872], // Puerto Plata coordinates
    portCode: 'POP',
  );

  static const PortData stThomas = PortData(
    id: 'STT',
    name: 'St. Thomas',
    country: 'US Virgin Islands',
    coordinates: [18.3419, -64.9307], // St. Thomas coordinates
    portCode: 'STT',
  );

  static const PortData tortola = PortData(
    id: 'EIS',
    name: 'Tortola',
    country: 'British Virgin Islands',
    coordinates: [18.4312, -64.6200], // Tortola coordinates
    portCode: 'EIS',
  );

  static const PortData greatStirrupCay = PortData(
    id: 'GSC',
    name: 'Great Stirrup Cay',
    country: 'Bahamas',
    coordinates: [25.8167, -77.9167], // Great Stirrup Cay coordinates
    portCode: 'GSC',
  );

  // Route coordinates for drawing the path on map (latitude, longitude coordinates)
  static const List<List<double>> caribbeanRoute = [
    [25.7617, -80.1918], // Miami (start)
    [25.5000, -79.7500], // Leaving Miami
    [25.2500, -79.2500], // Southeast from Miami
    [25.0000, -78.7500], // Entering Bahamas waters
    [24.5000, -77.7500], // Through Bahamas
    [23.5000, -76.0000], // Eastern Bahamas
    [22.5000, -74.0000], // Deeper Caribbean
    [21.5000, -72.5000], // Approaching Dominican Republic
    [20.7500, -71.5000], // North Dominican coast
    [19.7939, -70.6872], // Puerto Plata (Dominican Republic)
    [19.2500, -68.5000], // Eastern Dominican Republic
    [18.7500, -66.7500], // Approaching Virgin Islands
    [18.5000, -65.5000], // Virgin Islands waters
    [18.3419, -64.9307], // St. Thomas (US Virgin Islands)
    [18.4312, -64.6200], // Tortola (British Virgin Islands)
    [19.0000, -65.0000], // Leaving Virgin Islands
    [20.0000, -66.0000], // Northern Caribbean
    [21.5000, -68.0000], // Mid Caribbean
    [23.0000, -71.0000], // Southern Bahamas
    [24.0000, -74.0000], // Central Bahamas
    [25.0000, -76.0000], // Northern Bahamas
    [25.8167, -77.9167], // Great Stirrup Cay (Bahamas)
    [25.7000, -78.5000], // Approaching Florida
    [25.7617, -80.1918], // Back to Miami (end)
  ];
}
