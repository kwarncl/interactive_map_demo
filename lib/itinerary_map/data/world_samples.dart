import 'package:flutter/material.dart';

import '../models/cruise_itinerary.dart';

/// A collection of diverse sample itineraries around the world (map-focused)
/// built for the `ItineraryMap` experience.
class WorldSampleItineraries {
  // =====================
  // Alaska (Seattle RT)
  // =====================
  static const PortData seattle = PortData(
    id: 'SEA',
    name: 'Seattle',
    country: 'USA',
    coordinates: [47.6062, -122.3321],
    portCode: 'SEA',
  );
  static const PortData ketchikan = PortData(
    id: 'KTN',
    name: 'Ketchikan',
    country: 'USA',
    coordinates: [55.3422, -131.6461],
    portCode: 'KTN',
  );
  static const PortData juneau = PortData(
    id: 'JNU',
    name: 'Juneau',
    country: 'USA',
    coordinates: [58.3019, -134.4197],
    portCode: 'JNU',
  );
  static const PortData skagway = PortData(
    id: 'SGY',
    name: 'Skagway',
    country: 'USA',
    coordinates: [59.4583, -135.3139],
    portCode: 'SGY',
  );
  static const PortData victoria = PortData(
    id: 'YYJ',
    name: 'Victoria',
    country: 'Canada',
    coordinates: [48.4284, -123.3656],
    portCode: 'YYJ',
  );

  static final CruiseItinerary alaskaInsidePassage = CruiseItinerary(
    cruiseId: 'ALASKA-SEA-RT-7D',
    shipName: 'Norwegian Encore',
    cruiseName: '7-Day Alaska: Seattle Roundtrip',
    duration: 7,
    embarkationPort: seattle,
    disembarkationPort: seattle,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2025, 6, 1),
        dayType: ItineraryDayType.embarkation,
        port: seattle,
        departureTime: const TimeOfDay(hour: 17, minute: 0),
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2025, 6, 2),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2025, 6, 3),
        dayType: ItineraryDayType.port,
        port: ketchikan,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2025, 6, 4),
        dayType: ItineraryDayType.port,
        port: juneau,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2025, 6, 5),
        dayType: ItineraryDayType.port,
        port: skagway,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2025, 6, 6),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2025, 6, 7),
        dayType: ItineraryDayType.port,
        port: victoria,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2025, 6, 8),
        dayType: ItineraryDayType.disembarkation,
        port: seattle,
      ),
    ],
    routeCoordinates: [
      [47.6062, -122.3321], // Seattle
      [50.5, -128.0],
      [53.0, -130.0],
      [55.3422, -131.6461], // Ketchikan
      [57.0, -133.0],
      [58.3019, -134.4197], // Juneau
      [59.0, -134.8],
      [59.4583, -135.3139], // Skagway
      [57.0, -134.0],
      [54.0, -131.0],
      [50.0, -128.0],
      [48.4284, -123.3656], // Victoria
      [47.6062, -122.3321], // Seattle
    ],
    mapImagePath: 'assets/images/map.jpg',
    description: 'Iconic Inside Passage with glaciers and frontier towns',
    highlights: [
      'Ketchikan, Juneau, Skagway',
      'Glacier views and Inside Passage sailing',
      'Victoria, British Columbia',
    ],
  );

  // ==================================
  // Mediterranean (Barcelona → Athens)
  // ==================================
  static const PortData barcelona = PortData(
    id: 'BCN',
    name: 'Barcelona',
    country: 'Spain',
    coordinates: [41.3851, 2.1734],
    portCode: 'BCN',
  );
  static const PortData marseille = PortData(
    id: 'MRS',
    name: 'Marseille',
    country: 'France',
    coordinates: [43.2965, 5.3698],
    portCode: 'MRS',
  );
  static const PortData livorno = PortData(
    id: 'LIV',
    name: 'Livorno (Florence/Pisa)',
    country: 'Italy',
    coordinates: [43.5485, 10.3106],
    portCode: 'LIV',
  );
  static const PortData civitavecchia = PortData(
    id: 'CIV',
    name: 'Civitavecchia (Rome)',
    country: 'Italy',
    coordinates: [42.0930, 11.7920],
    portCode: 'CIV',
  );
  static const PortData naples = PortData(
    id: 'NAP',
    name: 'Naples',
    country: 'Italy',
    coordinates: [40.8518, 14.2681],
    portCode: 'NAP',
  );
  static const PortData santorini = PortData(
    id: 'JTR',
    name: 'Santorini',
    country: 'Greece',
    coordinates: [36.3932, 25.4615],
    portCode: 'JTR',
  );
  static const PortData piraeus = PortData(
    id: 'PIR',
    name: 'Athens (Piraeus)',
    country: 'Greece',
    coordinates: [37.9420, 23.6460],
    portCode: 'PIR',
  );

  static final CruiseItinerary mediterraneanGreekIsles = CruiseItinerary(
    cruiseId: 'MED-BCN-ATH-10D',
    shipName: 'Norwegian Epic',
    cruiseName: '10-Day Mediterranean: Barcelona to Athens',
    duration: 10,
    embarkationPort: barcelona,
    disembarkationPort: piraeus,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2025, 5, 10),
        dayType: ItineraryDayType.embarkation,
        port: barcelona,
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2025, 5, 11),
        dayType: ItineraryDayType.port,
        port: marseille,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2025, 5, 12),
        dayType: ItineraryDayType.port,
        port: livorno,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2025, 5, 13),
        dayType: ItineraryDayType.port,
        port: civitavecchia,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2025, 5, 14),
        dayType: ItineraryDayType.port,
        port: naples,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2025, 5, 15),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2025, 5, 16),
        dayType: ItineraryDayType.port,
        port: santorini,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2025, 5, 17),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 9,
        date: DateTime(2025, 5, 18),
        dayType: ItineraryDayType.port,
        port: piraeus,
      ),
      ItineraryDay(
        dayNumber: 10,
        date: DateTime(2025, 5, 19),
        dayType: ItineraryDayType.disembarkation,
        port: piraeus,
      ),
    ],
    routeCoordinates: [
      [41.3851, 2.1734], // Barcelona
      [42.5, 4.0],
      [43.2965, 5.3698], // Marseille
      [43.5485, 10.3106], // Livorno
      [42.0930, 11.7920], // Civitavecchia
      [40.8518, 14.2681], // Naples
      [37.0, 17.0],
      [36.3932, 25.4615], // Santorini
      [37.9420, 23.6460], // Athens (Piraeus)
    ],
    mapImagePath: 'assets/images/map.jpg',
    description: 'Western to Eastern Mediterranean highlights',
    highlights: ['Barcelona, Marseille, Rome, Naples, Santorini, Athens'],
  );

  // =====================================
  // Northern Europe (Copenhagen → Stockholm)
  // =====================================
  static const PortData copenhagen = PortData(
    id: 'CPH',
    name: 'Copenhagen',
    country: 'Denmark',
    coordinates: [55.6761, 12.5683],
    portCode: 'CPH',
  );
  static const PortData oslo = PortData(
    id: 'OSL',
    name: 'Oslo',
    country: 'Norway',
    coordinates: [59.9139, 10.7522],
    portCode: 'OSL',
  );
  static const PortData warnemunde = PortData(
    id: 'WAR',
    name: 'Warnemünde (Berlin)',
    country: 'Germany',
    coordinates: [54.1760, 12.0906],
    portCode: 'WAR',
  );
  static const PortData tallinn = PortData(
    id: 'TLL',
    name: 'Tallinn',
    country: 'Estonia',
    coordinates: [59.4370, 24.7536],
    portCode: 'TLL',
  );
  static const PortData helsinki = PortData(
    id: 'HEL',
    name: 'Helsinki',
    country: 'Finland',
    coordinates: [60.1699, 24.9384],
    portCode: 'HEL',
  );
  static const PortData stockholm = PortData(
    id: 'STO',
    name: 'Stockholm',
    country: 'Sweden',
    coordinates: [59.3293, 18.0686],
    portCode: 'STO',
  );

  static final CruiseItinerary northernEuropeBaltic = CruiseItinerary(
    cruiseId: 'NE-BALTIC-9D',
    shipName: 'Norwegian Dawn',
    cruiseName: '9-Day Northern Europe: Copenhagen to Stockholm',
    duration: 9,
    embarkationPort: copenhagen,
    disembarkationPort: stockholm,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2025, 6, 20),
        dayType: ItineraryDayType.embarkation,
        port: copenhagen,
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2025, 6, 21),
        dayType: ItineraryDayType.port,
        port: oslo,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2025, 6, 22),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2025, 6, 23),
        dayType: ItineraryDayType.port,
        port: warnemunde,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2025, 6, 24),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2025, 6, 25),
        dayType: ItineraryDayType.port,
        port: tallinn,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2025, 6, 26),
        dayType: ItineraryDayType.port,
        port: helsinki,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2025, 6, 27),
        dayType: ItineraryDayType.port,
        port: stockholm,
      ),
      ItineraryDay(
        dayNumber: 9,
        date: DateTime(2025, 6, 28),
        dayType: ItineraryDayType.disembarkation,
        port: stockholm,
      ),
    ],
    routeCoordinates: [
      [55.6761, 12.5683], // Copenhagen
      [59.9139, 10.7522], // Oslo
      [56.0, 12.0],
      [54.1760, 12.0906], // Warnemünde
      [58.0, 20.0],
      [59.4370, 24.7536], // Tallinn
      [60.1699, 24.9384], // Helsinki
      [59.3293, 18.0686], // Stockholm
    ],
    mapImagePath: 'assets/images/map.jpg',
    description: 'Scandinavia and Baltic capitals',
    highlights: ['Copenhagen, Oslo, Tallinn, Helsinki, Stockholm'],
  );

  // =====================================
  // Australia & New Zealand (Sydney → Auckland)
  // =====================================
  static const PortData sydney = PortData(
    id: 'SYD',
    name: 'Sydney',
    country: 'Australia',
    coordinates: [-33.8688, 151.2093],
    portCode: 'SYD',
  );
  static const PortData melbourne = PortData(
    id: 'MEL',
    name: 'Melbourne',
    country: 'Australia',
    coordinates: [-37.8136, 144.9631],
    portCode: 'MEL',
  );
  static const PortData hobart = PortData(
    id: 'HBA',
    name: 'Hobart',
    country: 'Australia',
    coordinates: [-42.8821, 147.3272],
    portCode: 'HBA',
  );
  static const PortData wellington = PortData(
    id: 'WLG',
    name: 'Wellington',
    country: 'New Zealand',
    coordinates: [-41.2866, 174.7756],
    portCode: 'WLG',
  );
  static const PortData auckland = PortData(
    id: 'AKL',
    name: 'Auckland',
    country: 'New Zealand',
    coordinates: [-36.8485, 174.7633],
    portCode: 'AKL',
  );

  static final CruiseItinerary australiaNewZealand = CruiseItinerary(
    cruiseId: 'ANZ-SYD-AKL-12D',
    shipName: 'Norwegian Spirit',
    cruiseName: '12-Day Australia & New Zealand: Sydney to Auckland',
    duration: 12,
    embarkationPort: sydney,
    disembarkationPort: auckland,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2025, 1, 10),
        dayType: ItineraryDayType.embarkation,
        port: sydney,
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2025, 1, 11),
        dayType: ItineraryDayType.port,
        port: melbourne,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2025, 1, 12),
        dayType: ItineraryDayType.port,
        port: hobart,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2025, 1, 13),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2025, 1, 14),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2025, 1, 15),
        dayType: ItineraryDayType.port,
        port: wellington,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2025, 1, 16),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2025, 1, 17),
        dayType: ItineraryDayType.port,
        port: auckland,
      ),
      ItineraryDay(
        dayNumber: 9,
        date: DateTime(2025, 1, 18),
        dayType: ItineraryDayType.disembarkation,
        port: auckland,
      ),
      // Keep simple to remain map-focused
    ],
    routeCoordinates: [
      [-33.8688, 151.2093], // Sydney
      [-38.0, 148.0],
      [-37.8136, 144.9631], // Melbourne
      [-42.8821, 147.3272], // Hobart
      [-45.0, 160.0],
      [-43.0, 170.0],
      [-41.2866, 174.7756], // Wellington
      [-36.8485, 174.7633], // Auckland
    ],
    mapImagePath: 'assets/images/map.jpg',
    description: 'Iconic sights across Australia and New Zealand',
    highlights: ['Sydney Opera House, Melbourne, Wellington, Auckland'],
  );

  // ======================
  // Japan (Yokohama RT)
  // ======================
  static const PortData yokohama = PortData(
    id: 'YOK',
    name: 'Yokohama (Tokyo)',
    country: 'Japan',
    coordinates: [35.4437, 139.6380],
    portCode: 'YOK',
  );
  static const PortData shimizu = PortData(
    id: 'SMZ',
    name: 'Shimizu (Mt. Fuji)',
    country: 'Japan',
    coordinates: [35.0153, 138.4895],
    portCode: 'SMZ',
  );
  static const PortData kobe = PortData(
    id: 'UKB',
    name: 'Kobe (Kyoto)',
    country: 'Japan',
    coordinates: [34.6901, 135.1955],
    portCode: 'UKB',
  );
  static const PortData hiroshima = PortData(
    id: 'HIJ',
    name: 'Hiroshima',
    country: 'Japan',
    coordinates: [34.3853, 132.4553],
    portCode: 'HIJ',
  );
  static const PortData fukuoka = PortData(
    id: 'FUK',
    name: 'Fukuoka',
    country: 'Japan',
    coordinates: [33.5902, 130.4017],
    portCode: 'FUK',
  );

  static final CruiseItinerary japanRoundtrip = CruiseItinerary(
    cruiseId: 'JPN-YOK-RT-9D',
    shipName: 'Norwegian Sun',
    cruiseName: '9-Day Japan: Yokohama Roundtrip',
    duration: 9,
    embarkationPort: yokohama,
    disembarkationPort: yokohama,
    days: [
      ItineraryDay(
        dayNumber: 1,
        date: DateTime(2025, 3, 10),
        dayType: ItineraryDayType.embarkation,
        port: yokohama,
      ),
      ItineraryDay(
        dayNumber: 2,
        date: DateTime(2025, 3, 11),
        dayType: ItineraryDayType.port,
        port: shimizu,
      ),
      ItineraryDay(
        dayNumber: 3,
        date: DateTime(2025, 3, 12),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 4,
        date: DateTime(2025, 3, 13),
        dayType: ItineraryDayType.port,
        port: kobe,
      ),
      ItineraryDay(
        dayNumber: 5,
        date: DateTime(2025, 3, 14),
        dayType: ItineraryDayType.port,
        port: hiroshima,
      ),
      ItineraryDay(
        dayNumber: 6,
        date: DateTime(2025, 3, 15),
        dayType: ItineraryDayType.port,
        port: fukuoka,
      ),
      ItineraryDay(
        dayNumber: 7,
        date: DateTime(2025, 3, 16),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 8,
        date: DateTime(2025, 3, 17),
        dayType: ItineraryDayType.sea,
      ),
      ItineraryDay(
        dayNumber: 9,
        date: DateTime(2025, 3, 18),
        dayType: ItineraryDayType.disembarkation,
        port: yokohama,
      ),
    ],
    routeCoordinates: [
      [35.4437, 139.6380], // Yokohama
      [35.0153, 138.4895], // Shimizu
      [34.6901, 135.1955], // Kobe
      [34.3853, 132.4553], // Hiroshima
      [33.5902, 130.4017], // Fukuoka
      [34.5, 134.0],
      [35.0, 136.0],
      [35.4437, 139.6380], // Return Yokohama
    ],
    mapImagePath: 'assets/images/map.jpg',
    description: 'Best of Honshu & Kyushu with Mt. Fuji views',
    highlights: ['Tokyo, Mt. Fuji, Kobe, Hiroshima, Fukuoka'],
  );
}
