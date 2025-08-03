import 'package:flutter/material.dart';

import '../models/cruise_itinerary.dart';

/// Norwegian Pearl 15-Night Transatlantic/Mediterranean Cruise Data
class TransatlanticCruiseData {
  // Port definitions specific to Transatlantic cruise (western Atlantic to Mediterranean system)
  static const PortData miamiFloridaTransatlantic = PortData(
    id: 'MIA',
    name: 'Miami',
    country: 'Florida, USA',
    coordinates: [145, 395], // Western Atlantic starting point
    portCode: 'MIA',
    description:
        'Gateway to the Caribbean and starting point for this epic transatlantic journey.',
  );

  static const PortData puntaDelgadaAzores = PortData(
    id: 'PDL',
    name: 'Ponta Delgada',
    country: 'Azores, Portugal',
    coordinates: [550, 300],
    portCode: 'PDL',
    description:
        'The largest city in the Azores archipelago, known for its volcanic landscapes and natural hot springs.',
  );

  static const PortData cadizSpain = PortData(
    id: 'CAD',
    name: 'Cadiz',
    country: 'Spain',
    coordinates: [685, 310],
    portCode: 'CAD',
    description:
        'One of the oldest continuously inhabited cities in Western Europe, famous for its historic old town.',
  );

  static const PortData motrilSpain = PortData(
    id: 'MOT',
    name: 'Motril',
    country: 'Spain',
    coordinates: [705, 310],
    portCode: 'MOT',
    description:
        'A coastal town in Granada province, gateway to the Costa Tropical and Alhambra.',
  );

  static const PortData ibizaSpain = PortData(
    id: 'IBZ',
    name: 'Ibiza',
    country: 'Spain',
    coordinates: [740, 290],
    portCode: 'IBZ',
    description:
        'Famous Balearic island known for its vibrant nightlife, beautiful beaches, and UNESCO World Heritage sites.',
  );

  static const PortData palmaMallorcaSpain = PortData(
    id: 'PMI',
    name: 'Palma de Mallorca',
    country: 'Spain',
    coordinates: [750, 290],
    portCode: 'PMI',
    description:
        'Capital of Mallorca, featuring the impressive La Seu Cathedral and charming old town.',
  );

  static const PortData barcelonaSpain = PortData(
    id: 'BCN',
    name: 'Barcelona',
    country: 'Spain',
    coordinates: [752, 270],
    portCode: 'BCN',
    description:
        'Cosmopolitan city famous for Gaudí architecture, vibrant culture, and Mediterranean cuisine.',
  );

  // Route coordinates for Norwegian Pearl 15-night Transatlantic cruise
  // Actual NCL itinerary: Miami → Ponta Delgada → Cadiz → Motril → Ibiza → Palma → Barcelona
  static const List<List<double>> transatlanticRoute = [
    [50, 400], // Miami (start) - Western side, lower
    [120, 350], // Northeast from Miami
    [200, 280], // Mid-Atlantic crossing
    [280, 250], // Approaching Europe
    [320, 280], // Ponta Delgada (Azores) - Mid-Atlantic island
    [380, 220], // Approaching Spanish coast
    [420, 240], // Cadiz - Southern Spain
    [450, 220], // Motril - Granada coast
    [580, 180], // Ibiza - Balearic Islands
    [600, 170], // Palma de Mallorca
    [620, 160], // Barcelona (end) - Eastern Mediterranean
  ];

  /// The complete Norwegian Pearl Transatlantic cruise itinerary
  static final CruiseItinerary norwegianPearlMediterranean = CruiseItinerary(
    cruiseId: 'PEARL15MIAPDLCADMOTIBZPMIBCN',
    shipName: 'Norwegian Pearl',
    cruiseName: '15-Night Transatlantic from Miami',
    duration: 15,
    embarkationPort: miamiFloridaTransatlantic,
    disembarkationPort: barcelonaSpain,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2025, 4, 26),
        dayType: ItineraryDayType.embarkation,
        port: miamiFloridaTransatlantic,
        departureTime: const TimeOfDay(hour: 17, minute: 0),
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2025, 4, 27),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2025, 4, 28),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2025, 4, 29),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2025, 4, 30),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2025, 5, 1),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2025, 5, 2),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2025, 5, 3),
        dayType: ItineraryDayType.port,
        port: puntaDelgadaAzores,
        arrivalTime: const TimeOfDay(hour: 8, minute: 0),
        departureTime: const TimeOfDay(hour: 17, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 9,
        date: DateTime(2025, 5, 4),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 10,
        date: DateTime(2025, 5, 5),
        dayType: ItineraryDayType.sea,
        isBookingAvailable: false,
      ),
      ItineraryDay(
        dayNumber: 11,
        date: DateTime(2025, 5, 6),
        dayType: ItineraryDayType.port,
        port: cadizSpain,
        arrivalTime: const TimeOfDay(hour: 7, minute: 0),
        departureTime: const TimeOfDay(hour: 16, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 12,
        date: DateTime(2025, 5, 7),
        dayType: ItineraryDayType.port,
        port: motrilSpain,
        arrivalTime: const TimeOfDay(hour: 8, minute: 0),
        departureTime: const TimeOfDay(hour: 17, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 13,
        date: DateTime(2025, 5, 8),
        dayType: ItineraryDayType.port,
        port: ibizaSpain,
        arrivalTime: const TimeOfDay(hour: 8, minute: 0),
        departureTime: const TimeOfDay(hour: 17, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 14,
        date: DateTime(2025, 5, 9),
        dayType: ItineraryDayType.port,
        port: palmaMallorcaSpain,
        arrivalTime: const TimeOfDay(hour: 7, minute: 0),
        departureTime: const TimeOfDay(hour: 16, minute: 0),
        isBookingAvailable: true,
      ),
      ItineraryDay(
        dayNumber: 15,
        date: DateTime(2025, 5, 10),
        dayType: ItineraryDayType.disembarkation,
        port: barcelonaSpain,
        arrivalTime: const TimeOfDay(hour: 7, minute: 0),
        isBookingAvailable: false,
      ),
    ],
    routeCoordinates: transatlanticRoute,
    mapImagePath: 'assets/images/norwegian_pearl_transatlantic_map.png',
    description:
        'Experience the ultimate transatlantic journey aboard Norwegian Pearl from Miami to the stunning Mediterranean',
    highlights: [
      'Cross the Atlantic Ocean',
      'Visit 5 Mediterranean destinations',
      'Explore historic Spanish coastal cities',
      'Experience vibrant island cultures',
      'Enjoy 6 relaxing sea days',
    ],
  );
}
