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

  // Port definitions with image pixel coordinates [x, y] based on map image
  static const PortData miamiFlorida = PortData(
    id: 'MIA',
    name: 'Miami',
    country: 'Florida, USA',
    coordinates: [145, 180], // Western Atlantic starting point
    portCode: 'MIA',
    description:
        'Gateway to the Caribbean and starting point for this epic transatlantic journey.',
  );

  static const PortData puertoPlata = PortData(
    id: 'POP',
    name: 'Puerto Plata',
    country: 'Dominican Republic',
    coordinates: [510, 425], // Based on typical Caribbean map positioning
    portCode: 'POP',
  );

  static const PortData stThomas = PortData(
    id: 'STT',
    name: 'St. Thomas',
    country: 'US Virgin Islands',
    coordinates: [740, 490], // Eastern Caribbean position
    portCode: 'STT',
  );

  static const PortData tortola = PortData(
    id: 'EIS',
    name: 'Tortola',
    country: 'British Virgin Islands',
    coordinates: [760, 485], // Eastern Caribbean position
    portCode: 'EIS',
  );

  static const PortData greatStirrupCay = PortData(
    id: 'GSC',
    name: 'Great Stirrup Cay',
    country: 'Bahamas',
    coordinates: [235, 175], // Top-left corner as requested
    portCode: 'GSC',
  );

  // Route coordinates for drawing the path on map (image pixel coordinates [x, y])
  static const List<List<double>> caribbeanRoute = [
    [0, 0], // Miami (start)
    [200, 200], // Southeast from Miami
    [350, 280], // Towards Caribbean
    [480, 340], // Approach Dominican Republic
    [660, 360], // Puerto Plata (Dominican Republic)
    [580, 320], // Between islands
    [504, 304], // St. Thomas (US Virgin Islands)
    [480, 288], // Tortola (British Virgin Islands)
    [600, 450], // North towards Bahamas
    [750, 550], // Approach Bahamas
    [816, 600], // Great Stirrup Cay (Bahamas)
    [0, 0], // Back to Miami (end)
  ];
}
