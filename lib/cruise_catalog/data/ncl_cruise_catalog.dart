import 'package:flutter/material.dart';

import '../models/cruise_product.dart';
import '../models/cruise_route.dart';

/// Sample NCL cruise catalog data for demonstration
class NCLCruiseCatalog {
  /// Caribbean Paradise Loop - Norwegian Epic
  static final norwegianEpicCaribbean = CruiseProduct(
    productId: 'epic-caribbean-001',
    title: '7-Day Caribbean Paradise',
    shipName: 'Norwegian Epic',
    shipClass: 'Epic Class',
    capacity: 4100,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'caribbean-loop-001',
      title: 'Eastern Caribbean Loop',
      description: 'Discover the best of the Eastern Caribbean',
      region: 'Caribbean',
      routeColor: Colors.orange,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to the Caribbean',
        ),
        PortLocation(
          name: 'Great Stirrup Cay',
          latitude: 25.8267,
          longitude: -77.9167,
          country: 'Bahamas',
          description: 'NCL\'s private island paradise',
        ),
        PortLocation(
          name: 'St. Thomas',
          latitude: 18.3419,
          longitude: -64.9307,
          country: 'USVI',
          description: 'Duty-free shopping paradise',
        ),
        PortLocation(
          name: 'San Juan',
          latitude: 18.4655,
          longitude: -66.1057,
          country: 'Puerto Rico',
          description: 'Historic Spanish colonial city',
        ),
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Return to Miami',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(
      DateTime(2024, 3, 10),
      26,
    ), // Weekly departures
    description:
        'Experience the ultimate Caribbean getaway aboard the innovative Norwegian Epic. Visit our private island paradise, shop duty-free in St. Thomas, and explore historic San Juan.',
    highlights: [
      'NCL\'s Private Island',
      'Duty-Free Shopping',
      'Historic San Juan',
      'Aqua Park & Water Slides',
      'Broadway-Style Shows',
    ],
    bookingUrl: 'ncl://book/epic-caribbean-001',
    imageUrl: 'assets/images/norwegian-epic.jpg',
  );

  /// Mediterranean Highlights - Norwegian Dawn
  static final norwegianDawnMediterranean = CruiseProduct(
    productId: 'dawn-mediterranean-001',
    title: '12-Day Mediterranean Highlights',
    shipName: 'Norwegian Dawn',
    shipClass: 'Dawn Class',
    capacity: 2340,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'mediterranean-highlights-001',
      title: 'Western Mediterranean Circuit',
      description: 'Explore the cultural treasures of the Mediterranean',
      region: 'Mediterranean',
      routeColor: Colors.blue,
      waypoints: [
        PortLocation(
          name: 'Barcelona',
          latitude: 41.3851,
          longitude: 2.1734,
          country: 'Spain',
          description: 'Gaudí\'s architectural masterpiece',
        ),
        PortLocation(
          name: 'Marseille',
          latitude: 43.2965,
          longitude: 5.3698,
          country: 'France',
          description: 'Gateway to Provence',
        ),
        PortLocation(
          name: 'Genoa',
          latitude: 44.4056,
          longitude: 8.9463,
          country: 'Italy',
          description: 'Birthplace of Christopher Columbus',
        ),
        PortLocation(
          name: 'Rome (Civitavecchia)',
          latitude: 42.0943,
          longitude: 11.7903,
          country: 'Italy',
          description: 'The Eternal City',
        ),
        PortLocation(
          name: 'Naples',
          latitude: 40.8518,
          longitude: 14.2681,
          country: 'Italy',
          description: 'Gateway to Pompeii',
        ),
        PortLocation(
          name: 'Palma de Mallorca',
          latitude: 39.5696,
          longitude: 2.6502,
          country: 'Spain',
          description: 'Balearic Islands gem',
        ),
        PortLocation(
          name: 'Barcelona',
          latitude: 41.3851,
          longitude: 2.1734,
          country: 'Spain',
          description: 'Return to Barcelona',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1599, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(
      DateTime(2024, 4, 15),
      18,
    ), // Every 2 weeks
    description:
        'Immerse yourself in Mediterranean culture aboard Norwegian Dawn. Explore ancient Rome, marvel at Gaudí\'s Barcelona, and discover the French Riviera.',
    highlights: [
      'Ancient Rome & Vatican',
      'Gaudí\'s Barcelona',
      'French Riviera',
      'Pompeii & Mt. Vesuvius',
      'Balearic Islands',
    ],
    bookingUrl: 'ncl://book/dawn-mediterranean-001',
    imageUrl: 'assets/images/norwegian-dawn.jpg',
  );

  /// Alaska Glacier Bay - Norwegian Bliss
  static final norwegianBlissAlaska = CruiseProduct(
    productId: 'bliss-alaska-001',
    title: '7-Day Alaska Glacier Bay',
    shipName: 'Norwegian Bliss',
    shipClass: 'Breakaway Plus Class',
    capacity: 4004,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'alaska-glacier-001',
      title: 'Inside Passage & Glacier Bay',
      description: 'Experience Alaska\'s stunning glaciers and wildlife',
      region: 'Alaska',
      routeColor: Colors.teal,
      waypoints: [
        PortLocation(
          name: 'Seattle',
          latitude: 47.6062,
          longitude: -122.3321,
          country: 'USA',
          description: 'Emerald City departure',
        ),
        PortLocation(
          name: 'Juneau',
          latitude: 58.3019,
          longitude: -134.4197,
          country: 'USA',
          description: 'Alaska\'s capital city',
        ),
        PortLocation(
          name: 'Skagway',
          latitude: 59.4600,
          longitude: -135.3150,
          country: 'USA',
          description: 'Gold Rush history',
        ),
        PortLocation(
          name: 'Glacier Bay',
          latitude: 58.6650,
          longitude: -136.9006,
          country: 'USA',
          description: 'UNESCO World Heritage Site',
        ),
        PortLocation(
          name: 'Ketchikan',
          latitude: 55.3422,
          longitude: -131.6461,
          country: 'USA',
          description: 'Salmon capital of the world',
        ),
        PortLocation(
          name: 'Seattle',
          latitude: 47.6062,
          longitude: -122.3321,
          country: 'USA',
          description: 'Return to Seattle',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(
      DateTime(2024, 5, 12),
      20,
    ), // Summer season
    description:
        'Witness the majesty of Alaska aboard the spectacular Norwegian Bliss. Cruise through Glacier Bay National Park and discover frontier towns rich in Gold Rush history.',
    highlights: [
      'Glacier Bay National Park',
      'Wildlife Viewing',
      'Gold Rush History',
      'Scenic Cruising',
      'Go-Kart Track at Sea',
    ],
    bookingUrl: 'ncl://book/bliss-alaska-001',
    imageUrl: 'assets/images/norwegian-bliss.jpg',
  );

  /// Hawaii Island Hopper - Norwegian Spirit
  static final norwegianSpiritHawaii = CruiseProduct(
    productId: 'spirit-hawaii-001',
    title: '7-Day Hawaii Island Hopper',
    shipName: 'Norwegian Spirit',
    shipClass: 'Spirit Class',
    capacity: 1966,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'hawaii-islands-001',
      title: 'Hawaiian Islands Circuit',
      description: 'Discover all four major Hawaiian islands',
      region: 'Hawaii',
      routeColor: Colors.green,
      waypoints: [
        PortLocation(
          name: 'Honolulu',
          latitude: 21.3099,
          longitude: -157.8581,
          country: 'USA',
          description: 'Pearl Harbor & Waikiki Beach',
        ),
        PortLocation(
          name: 'Kahului (Maui)',
          latitude: 20.8947,
          longitude: -156.4700,
          country: 'USA',
          description: 'Road to Hana & Haleakala',
        ),
        PortLocation(
          name: 'Hilo (Big Island)',
          latitude: 19.7297,
          longitude: -155.0900,
          country: 'USA',
          description: 'Volcanoes National Park',
        ),
        PortLocation(
          name: 'Kona (Big Island)',
          latitude: 19.6400,
          longitude: -155.9969,
          country: 'USA',
          description: 'Coffee farms & snorkeling',
        ),
        PortLocation(
          name: 'Nawiliwili (Kauai)',
          latitude: 21.9544,
          longitude: -159.3561,
          country: 'USA',
          description: 'Garden Island paradise',
        ),
        PortLocation(
          name: 'Honolulu',
          latitude: 21.3099,
          longitude: -157.8581,
          country: 'USA',
          description: 'Return to Honolulu',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1199, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(
      DateTime(2024, 2, 18),
      30,
    ), // Year-round
    description:
        'Experience the Aloha Spirit as you island-hop through Hawaii aboard Norwegian Spirit. Visit active volcanoes, pristine beaches, and lush tropical landscapes.',
    highlights: [
      'Four Hawaiian Islands',
      'Volcanoes National Park',
      'Pearl Harbor Memorial',
      'Snorkeling Adventures',
      'Authentic Luau Shows',
    ],
    bookingUrl: 'ncl://book/spirit-hawaii-001',
    imageUrl: 'assets/images/norwegian-spirit.jpg',
  );

  /// Transatlantic Journey - Norwegian Gem
  static final norwegianGemTransatlantic = CruiseProduct(
    productId: 'gem-transatlantic-001',
    title: '15-Day Transatlantic Journey',
    shipName: 'Norwegian Gem',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '15 days',
    route: const CruiseRoute(
      routeId: 'transatlantic-crossing-001',
      title: 'New York to Southampton',
      description: 'Classic ocean crossing with elegant sea days',
      region: 'Transatlantic',
      routeColor: Colors.purple,
      waypoints: [
        PortLocation(
          name: 'New York',
          latitude: 40.7128,
          longitude: -74.0060,
          country: 'USA',
          description: 'The Big Apple departure',
        ),
        PortLocation(
          name: 'Halifax',
          latitude: 44.6488,
          longitude: -63.5752,
          country: 'Canada',
          description: 'Maritime charm',
        ),
        PortLocation(
          name: 'Reykjavik',
          latitude: 64.1466,
          longitude: -21.9426,
          country: 'Iceland',
          description: 'Land of fire and ice',
        ),
        PortLocation(
          name: 'Southampton',
          latitude: 50.9097,
          longitude: -1.4044,
          country: 'UK',
          description: 'Gateway to London',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 999, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(
      DateTime(2024, 4, 28),
      8,
    ), // Spring/Fall crossings
    description:
        'Embark on a classic Transatlantic voyage aboard Norwegian Gem. Enjoy refined sea days, visit mystical Iceland, and arrive in historic Southampton.',
    highlights: [
      'Classic Ocean Crossing',
      'Iceland\'s Natural Wonders',
      'Elegant Sea Days',
      'Maritime History',
      'Gateway to Europe',
    ],
    bookingUrl: 'ncl://book/gem-transatlantic-001',
    imageUrl: 'assets/images/norwegian-gem.jpg',
  );

  /// All cruise products in the catalog
  static final List<CruiseProduct> allCruises = [
    norwegianEpicCaribbean,
    norwegianDawnMediterranean,
    norwegianBlissAlaska,
    norwegianSpiritHawaii,
    norwegianGemTransatlantic,
  ];

  /// Get cruises by category
  static List<CruiseProduct> getCruisesByCategory(String categoryId) {
    return allCruises.where((cruise) {
      return cruise.route.region?.toLowerCase() == categoryId.toLowerCase();
    }).toList();
  }

  /// Get a specific cruise by product ID
  static CruiseProduct? getCruiseById(String productId) {
    try {
      return allCruises.firstWhere((cruise) => cruise.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Helper method to generate departure dates
  static List<DateTime> _generateDepartureDates(DateTime startDate, int count) {
    final dates = <DateTime>[];
    var currentDate = startDate;

    for (int i = 0; i < count; i++) {
      dates.add(currentDate);
      currentDate = currentDate.add(
        const Duration(days: 7),
      ); // Weekly departures
    }

    return dates;
  }
}
