import 'package:flutter/material.dart';

import '../models/cruise_product.dart';
import '../models/cruise_route.dart';

/// Expanded NCL cruise catalog with more realistic cruise offerings
/// This data is separated from implementation to allow easy swapping with real API data
class ExpandedNCLCatalog {
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
    departureDates: _generateDepartureDates(DateTime(2024, 3, 10), 26),
    description:
        'Experience the ultimate Caribbean getaway aboard the innovative Norwegian Epic.',
    highlights: [
      'NCL\'s Private Island',
      'Duty-Free Shopping',
      'Historic San Juan',
      'Aqua Park & Water Slides',
      'Broadway-Style Shows',
    ],
    bookingUrl: 'ncl://book/epic-caribbean-001',
    imageUrl: 'assets/images/norwegian-epic.jpg',
    zoomTier: CruiseZoomTier.essential, // Popular Caribbean route
  );

  /// Western Caribbean - Norwegian Breakaway
  static final norwegianBreakawayWestCaribbean = CruiseProduct(
    productId: 'breakaway-west-caribbean-001',
    title: '7-Day Western Caribbean',
    shipName: 'Norwegian Breakaway',
    shipClass: 'Breakaway Class',
    capacity: 3963,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'west-caribbean-001',
      title: 'Western Caribbean Adventure',
      description: 'Explore Mayan ruins and pristine beaches',
      region: 'Caribbean',
      routeColor: Colors.deepOrange,
      waypoints: [
        PortLocation(
          name: 'New York',
          latitude: 40.7128,
          longitude: -74.0060,
          country: 'USA',
          description: 'The Big Apple departure',
        ),
        PortLocation(
          name: 'Port Canaveral',
          latitude: 28.4158,
          longitude: -80.5994,
          country: 'USA',
          description: 'Gateway to Orlando',
        ),
        PortLocation(
          name: 'Costa Maya',
          latitude: 18.7373,
          longitude: -87.7084,
          country: 'Mexico',
          description: 'Ancient Mayan treasures',
        ),
        PortLocation(
          name: 'Harvest Caye',
          latitude: 16.0971,
          longitude: -88.2034,
          country: 'Belize',
          description: 'NCL\'s private island',
        ),
        PortLocation(
          name: 'Cozumel',
          latitude: 20.4230,
          longitude: -86.9223,
          country: 'Mexico',
          description: 'World-class diving',
        ),
        PortLocation(
          name: 'New York',
          latitude: 40.7128,
          longitude: -74.0060,
          country: 'USA',
          description: 'Return to New York',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1049, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 1, 14), 24),
    description:
        'Discover ancient Mayan ruins and pristine Caribbean beaches aboard Norwegian Breakaway.',
    highlights: [
      'Mayan Ruins & Culture',
      'World-Class Diving',
      'Private Island Access',
      'Broadway Theater',
      'Waterfront Promenade',
    ],
    bookingUrl: 'ncl://book/breakaway-west-caribbean-001',
    imageUrl: 'assets/images/norwegian-breakaway.jpg',
    zoomTier: CruiseZoomTier.essential, // Popular Caribbean route
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
    departureDates: _generateDepartureDates(DateTime(2024, 4, 15), 18),
    description:
        'Immerse yourself in Mediterranean culture aboard Norwegian Dawn.',
    highlights: [
      'Ancient Rome & Vatican',
      'Gaudí\'s Barcelona',
      'French Riviera',
      'Pompeii & Mt. Vesuvius',
      'Balearic Islands',
    ],
    bookingUrl: 'ncl://book/dawn-mediterranean-001',
    imageUrl: 'assets/images/norwegian-dawn.jpg',
    zoomTier: CruiseZoomTier.essential, // Popular Mediterranean route
  );

  /// Greek Isles - Norwegian Star
  static final norwegianStarGreekIsles = CruiseProduct(
    productId: 'star-greek-isles-001',
    title: '10-Day Greek Isles',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'greek-isles-001',
      title: 'Aegean Islands Explorer',
      description: 'Discover ancient Greece and stunning islands',
      region: 'Mediterranean',
      routeColor: Colors.lightBlue,
      waypoints: [
        PortLocation(
          name: 'Venice',
          latitude: 45.4408,
          longitude: 12.3155,
          country: 'Italy',
          description: 'City of canals',
        ),
        PortLocation(
          name: 'Dubrovnik',
          latitude: 42.6507,
          longitude: 18.0944,
          country: 'Croatia',
          description: 'Pearl of the Adriatic',
        ),
        PortLocation(
          name: 'Santorini',
          latitude: 36.3932,
          longitude: 25.4615,
          country: 'Greece',
          description: 'Iconic blue-domed churches',
        ),
        PortLocation(
          name: 'Mykonos',
          latitude: 37.4467,
          longitude: 25.3289,
          country: 'Greece',
          description: 'Windmills and white houses',
        ),
        PortLocation(
          name: 'Athens (Piraeus)',
          latitude: 37.9755,
          longitude: 23.7348,
          country: 'Greece',
          description: 'Cradle of civilization',
        ),
        PortLocation(
          name: 'Corfu',
          latitude: 39.6243,
          longitude: 19.9217,
          country: 'Greece',
          description: 'Emerald island paradise',
        ),
        PortLocation(
          name: 'Venice',
          latitude: 45.4408,
          longitude: 12.3155,
          country: 'Italy',
          description: 'Return to Venice',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1799, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 5, 8), 15),
    description:
        'Sail through the Aegean Sea and discover the magic of the Greek Islands.',
    highlights: [
      'Iconic Santorini Sunsets',
      'Ancient Athens & Acropolis',
      'Mykonos Nightlife',
      'Venetian Architecture',
      'Croatian Coastlines',
    ],
    bookingUrl: 'ncl://book/star-greek-isles-001',
    imageUrl: 'assets/images/norwegian-star.jpg',
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
    departureDates: _generateDepartureDates(DateTime(2024, 5, 12), 20),
    description:
        'Witness the majesty of Alaska aboard the spectacular Norwegian Bliss.',
    highlights: [
      'Glacier Bay National Park',
      'Wildlife Viewing',
      'Gold Rush History',
      'Scenic Cruising',
      'Go-Kart Track at Sea',
    ],
    bookingUrl: 'ncl://book/bliss-alaska-001',
    imageUrl: 'assets/images/norwegian-bliss.jpg',
    zoomTier: CruiseZoomTier.medium, // Scenic Alaska route
  );

  /// Alaska Denali - Norwegian Sun
  static final norwegianSunAlaskaDenali = CruiseProduct(
    productId: 'sun-alaska-denali-001',
    title: '12-Day Alaska & Denali',
    shipName: 'Norwegian Sun',
    shipClass: 'Sun Class',
    capacity: 1936,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'alaska-denali-001',
      title: 'Alaska Cruise + Denali Explorer',
      description: 'Combine cruising with land adventures',
      region: 'Alaska',
      routeColor: Colors.cyan,
      waypoints: [
        PortLocation(
          name: 'Vancouver',
          latitude: 49.2827,
          longitude: -123.1207,
          country: 'Canada',
          description: 'Beautiful British Columbia',
        ),
        PortLocation(
          name: 'Ketchikan',
          latitude: 55.3422,
          longitude: -131.6461,
          country: 'USA',
          description: 'Totem pole capital',
        ),
        PortLocation(
          name: 'Juneau',
          latitude: 58.3019,
          longitude: -134.4197,
          country: 'USA',
          description: 'Mendenhall Glacier',
        ),
        PortLocation(
          name: 'Skagway',
          latitude: 59.4600,
          longitude: -135.3150,
          country: 'USA',
          description: 'White Pass Railway',
        ),
        PortLocation(
          name: 'Seward',
          latitude: 60.1042,
          longitude: -149.4437,
          country: 'USA',
          description: 'Gateway to Denali',
        ),
        PortLocation(
          name: 'Denali National Park',
          latitude: 63.1148,
          longitude: -151.1926,
          country: 'USA',
          description: 'North America\'s highest peak',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2199, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 6, 2), 12),
    description:
        'The ultimate Alaska adventure combining scenic cruising with Denali National Park.',
    highlights: [
      'Denali National Park',
      'Mount McKinley Views',
      'White Pass Railway',
      'Glacier Helicopter Tours',
      'Wildlife Expeditions',
    ],
    bookingUrl: 'ncl://book/sun-alaska-denali-001',
    imageUrl: 'assets/images/norwegian-sun.jpg',
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
    departureDates: _generateDepartureDates(DateTime(2024, 2, 18), 30),
    description:
        'Experience the Aloha Spirit as you island-hop through Hawaii.',
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
    departureDates: _generateDepartureDates(DateTime(2024, 4, 28), 8),
    description:
        'Embark on a classic Transatlantic voyage aboard Norwegian Gem.',
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

  /// Norwegian Fjords - Norwegian Star
  static final norwegianStarNorwegianFjords = CruiseProduct(
    productId: 'star-norwegian-fjords-001',
    title: '14-Day Norwegian Fjords',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '14 days',
    route: const CruiseRoute(
      routeId: 'norwegian-fjords-001',
      title: 'Spectacular Fjords & Northern Lights',
      description: 'Dramatic landscapes and natural wonders',
      region: 'Northern Europe',
      routeColor: Colors.indigo,
      waypoints: [
        PortLocation(
          name: 'Copenhagen',
          latitude: 55.6761,
          longitude: 12.5683,
          country: 'Denmark',
          description: 'Scandinavian capital',
        ),
        PortLocation(
          name: 'Bergen',
          latitude: 60.3913,
          longitude: 5.3221,
          country: 'Norway',
          description: 'Gateway to the fjords',
        ),
        PortLocation(
          name: 'Geiranger',
          latitude: 62.1014,
          longitude: 7.2066,
          country: 'Norway',
          description: 'UNESCO World Heritage fjord',
        ),
        PortLocation(
          name: 'Flam',
          latitude: 60.8633,
          longitude: 7.2069,
          country: 'Norway',
          description: 'Dramatic mountain railways',
        ),
        PortLocation(
          name: 'Stavanger',
          latitude: 58.9700,
          longitude: 5.7331,
          country: 'Norway',
          description: 'Pulpit Rock adventures',
        ),
        PortLocation(
          name: 'Oslo',
          latitude: 59.9139,
          longitude: 10.7522,
          country: 'Norway',
          description: 'Viking heritage',
        ),
        PortLocation(
          name: 'Copenhagen',
          latitude: 55.6761,
          longitude: 12.5683,
          country: 'Denmark',
          description: 'Return to Copenhagen',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2599, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 6, 15), 10),
    description:
        'Experience the dramatic beauty of Norway\'s legendary fjords.',
    highlights: [
      'UNESCO Geiranger Fjord',
      'Pulpit Rock Hiking',
      'Flam Railway',
      'Northern Lights Viewing',
      'Viking History Museums',
    ],
    bookingUrl: 'ncl://book/star-norwegian-fjords-001',
    imageUrl: 'assets/images/norwegian-star-fjords.jpg',
  );

  /// South Africa Cape Town Explorer - Norwegian Jewel
  static final norwegianJewelSouthAfrica = CruiseProduct(
    productId: 'jewel-south-africa-001',
    title: '14-Day South Africa & Namibia',
    shipName: 'Norwegian Jewel',
    shipClass: 'Jewel Class',
    capacity: 2376,
    duration: '14 days',
    route: const CruiseRoute(
      routeId: 'south-africa-001',
      title: 'Cape Town & Garden Route',
      description: 'Discover the stunning beauty of South Africa',
      region: 'Africa',
      routeColor: Colors.amber,
      waypoints: [
        PortLocation(
          name: 'Cape Town',
          latitude: -33.9249,
          longitude: 18.4241,
          country: 'South Africa',
          description: 'Table Mountain & wine country',
        ),
        PortLocation(
          name: 'Mossel Bay',
          latitude: -34.1816,
          longitude: 22.1460,
          country: 'South Africa',
          description: 'Garden Route paradise',
        ),
        PortLocation(
          name: 'Port Elizabeth',
          latitude: -33.9608,
          longitude: 25.6022,
          country: 'South Africa',
          description: 'Friendly city beaches',
        ),
        PortLocation(
          name: 'Durban',
          latitude: -29.8587,
          longitude: 31.0218,
          country: 'South Africa',
          description: 'Golden beaches & Indian culture',
        ),
        PortLocation(
          name: 'Walvis Bay',
          latitude: -22.9576,
          longitude: 14.5052,
          country: 'Namibia',
          description: 'Desert meets ocean',
        ),
        PortLocation(
          name: 'Cape Town',
          latitude: -33.9249,
          longitude: 18.4241,
          country: 'South Africa',
          description: 'Return to Cape Town',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 3, 15), 12),
    description:
        'Experience the diverse beauty of South Africa from Cape Town to Durban.',
    highlights: [
      'Table Mountain & Cape Point',
      'Wine Country Tours',
      'Safari Adventures',
      'Garden Route Scenic Beauty',
      'Namibian Desert',
    ],
    bookingUrl: 'ncl://book/jewel-south-africa-001',
    imageUrl: 'assets/images/norwegian-jewel-africa.jpg',
  );

  /// Middle East Dubai & Arabian Gulf - Norwegian Prima
  static final norwegianPrimaMiddleEast = CruiseProduct(
    productId: 'prima-middle-east-001',
    title: '10-Day Arabian Gulf Explorer',
    shipName: 'Norwegian Prima',
    shipClass: 'Prima Class',
    capacity: 3215,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'arabian-gulf-001',
      title: 'Dubai & Arabian Peninsula',
      description: 'Luxury and tradition in the Arabian Gulf',
      region: 'Middle East',
      routeColor: Colors.deepPurple,
      waypoints: [
        PortLocation(
          name: 'Dubai',
          latitude: 25.2048,
          longitude: 55.2708,
          country: 'UAE',
          description: 'City of gold and innovation',
        ),
        PortLocation(
          name: 'Abu Dhabi',
          latitude: 24.4539,
          longitude: 54.3773,
          country: 'UAE',
          description: 'Capital of luxury',
        ),
        PortLocation(
          name: 'Doha',
          latitude: 25.2854,
          longitude: 51.5310,
          country: 'Qatar',
          description: 'Pearl of the Gulf',
        ),
        PortLocation(
          name: 'Muscat',
          latitude: 23.5859,
          longitude: 58.4059,
          country: 'Oman',
          description: 'Arabian heritage',
        ),
        PortLocation(
          name: 'Khasab',
          latitude: 26.1798,
          longitude: 56.2456,
          country: 'Oman',
          description: 'Fjords of Arabia',
        ),
        PortLocation(
          name: 'Dubai',
          latitude: 25.2048,
          longitude: 55.2708,
          country: 'UAE',
          description: 'Return to Dubai',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 11, 10), 16),
    description:
        'Explore the opulent cities and ancient traditions of the Arabian Gulf.',
    highlights: [
      'Burj Khalifa & Dubai Mall',
      'Sheikh Zayed Mosque',
      'Souks & Traditional Markets',
      'Desert Safari Adventures',
      'Luxury Shopping',
    ],
    bookingUrl: 'ncl://book/prima-middle-east-001',
    imageUrl: 'assets/images/norwegian-prima-dubai.jpg',
    zoomTier: CruiseZoomTier.medium, // Regional Middle East route
  );

  /// Southeast Asia Singapore Explorer - Norwegian Sky
  static final norwegianSkySoutheastAsia = CruiseProduct(
    productId: 'sky-southeast-asia-001',
    title: '12-Day Southeast Asia Discovery',
    shipName: 'Norwegian Sky',
    shipClass: 'Sky Class',
    capacity: 2004,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'southeast-asia-001',
      title: 'Singapore to Bangkok',
      description: 'Temples, beaches, and vibrant cultures',
      region: 'Asia',
      routeColor: Colors.red,
      waypoints: [
        PortLocation(
          name: 'Singapore',
          latitude: 1.3521,
          longitude: 103.8198,
          country: 'Singapore',
          description: 'Garden city of Asia',
        ),
        PortLocation(
          name: 'Kuala Lumpur',
          latitude: 3.1390,
          longitude: 101.6869,
          country: 'Malaysia',
          description: 'Petronas Towers & street food',
        ),
        PortLocation(
          name: 'Phuket',
          latitude: 7.8804,
          longitude: 98.3923,
          country: 'Thailand',
          description: 'Tropical paradise beaches',
        ),
        PortLocation(
          name: 'Ko Samui',
          latitude: 9.5357,
          longitude: 100.0629,
          country: 'Thailand',
          description: 'Palm-fringed beaches',
        ),
        PortLocation(
          name: 'Bangkok',
          latitude: 13.7563,
          longitude: 100.5018,
          country: 'Thailand',
          description: 'City of temples',
        ),
        PortLocation(
          name: 'Ho Chi Minh City',
          latitude: 10.8231,
          longitude: 106.6297,
          country: 'Vietnam',
          description: 'French colonial charm',
        ),
        PortLocation(
          name: 'Singapore',
          latitude: 1.3521,
          longitude: 103.8198,
          country: 'Singapore',
          description: 'Return to Singapore',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 2, 5), 20),
    description:
        'Experience the diverse cultures, cuisines, and landscapes of Southeast Asia.',
    highlights: [
      'Golden Temples & Buddhas',
      'Floating Markets',
      'Tropical Beach Paradise',
      'Street Food Adventures',
      'Ancient Cultural Sites',
    ],
    bookingUrl: 'ncl://book/sky-southeast-asia-001',
    imageUrl: 'assets/images/norwegian-sky-asia.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Southeast Asia cruise
  );

  /// Australia & New Zealand - Norwegian Jewel
  static final norwegianJewelAustralia = CruiseProduct(
    productId: 'jewel-australia-001',
    title: '16-Day Australia & New Zealand',
    shipName: 'Norwegian Jewel',
    shipClass: 'Jewel Class',
    capacity: 2376,
    duration: '16 days',
    route: const CruiseRoute(
      routeId: 'australia-nz-001',
      title: 'Sydney to Auckland',
      description: 'Down Under adventure across two nations',
      region: 'Pacific',
      routeColor: Colors.lightGreen,
      waypoints: [
        PortLocation(
          name: 'Sydney',
          latitude: -33.8688,
          longitude: 151.2093,
          country: 'Australia',
          description: 'Harbor Bridge & Opera House',
        ),
        PortLocation(
          name: 'Melbourne',
          latitude: -37.8136,
          longitude: 144.9631,
          country: 'Australia',
          description: 'Cultural capital',
        ),
        PortLocation(
          name: 'Hobart',
          latitude: -42.8821,
          longitude: 147.3272,
          country: 'Australia',
          description: 'Tasmania\'s wild beauty',
        ),
        PortLocation(
          name: 'Milford Sound',
          latitude: -44.6700,
          longitude: 167.9250,
          country: 'New Zealand',
          description: 'Fiordland wonder',
        ),
        PortLocation(
          name: 'Christchurch',
          latitude: -43.5321,
          longitude: 172.6362,
          country: 'New Zealand',
          description: 'Garden city',
        ),
        PortLocation(
          name: 'Wellington',
          latitude: -41.2865,
          longitude: 174.7762,
          country: 'New Zealand',
          description: 'Capital & film studios',
        ),
        PortLocation(
          name: 'Auckland',
          latitude: -36.8485,
          longitude: 174.7633,
          country: 'New Zealand',
          description: 'City of sails',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 3299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 10, 12), 8),
    description:
        'Discover the natural wonders and vibrant cities of Australia and New Zealand.',
    highlights: [
      'Sydney Opera House',
      'Great Ocean Road',
      'Milford Sound Fjords',
      'Aboriginal Culture',
      'Hobbiton Movie Set',
    ],
    bookingUrl: 'ncl://book/jewel-australia-001',
    imageUrl: 'assets/images/norwegian-jewel-australia.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Australia/Pacific cruise
  );

  /// Antarctica Explorer - Norwegian Star
  static final norwegianStarAntarctica = CruiseProduct(
    productId: 'star-antarctica-001',
    title: '18-Day Antarctica Expedition',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '18 days',
    route: const CruiseRoute(
      routeId: 'antarctica-001',
      title: 'White Continent Explorer',
      description: 'Ultimate polar expedition to Earth\'s last frontier',
      region: 'Antarctica',
      routeColor: Colors.lightBlue,
      waypoints: [
        PortLocation(
          name: 'Buenos Aires',
          latitude: -34.6118,
          longitude: -58.3960,
          country: 'Argentina',
          description: 'Tango capital departure',
        ),
        PortLocation(
          name: 'Montevideo',
          latitude: -34.9011,
          longitude: -56.1645,
          country: 'Uruguay',
          description: 'Historic colonial port',
        ),
        PortLocation(
          name: 'Ushuaia',
          latitude: -54.8019,
          longitude: -68.3030,
          country: 'Argentina',
          description: 'End of the world',
        ),
        PortLocation(
          name: 'Drake Passage',
          latitude: -58.5000,
          longitude: -65.0000,
          country: 'International Waters',
          description: 'Gateway to Antarctica',
        ),
        PortLocation(
          name: 'Antarctic Peninsula',
          latitude: -63.2467,
          longitude: -57.0000,
          country: 'Antarctica',
          description: 'Pristine wilderness',
        ),
        PortLocation(
          name: 'Paradise Harbor',
          latitude: -64.8500,
          longitude: -62.8667,
          country: 'Antarctica',
          description: 'Penguin colonies',
        ),
        PortLocation(
          name: 'Buenos Aires',
          latitude: -34.6118,
          longitude: -58.3960,
          country: 'Argentina',
          description: 'Return to Buenos Aires',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 8999, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 12, 1), 6),
    description:
        'Experience the ultimate adventure to the pristine wilderness of Antarctica.',
    highlights: [
      'Penguin & Seal Colonies',
      'Massive Icebergs',
      'Zodiac Landings',
      'Drake Passage Crossing',
      'Expert Naturalist Guides',
    ],
    bookingUrl: 'ncl://book/star-antarctica-001',
    imageUrl: 'assets/images/norwegian-star-antarctica.jpg',
    zoomTier: CruiseZoomTier.detailed, // Specialty expedition route
  );

  /// China & Japan Explorer - Norwegian Spirit
  static final norwegianSpiritChina = CruiseProduct(
    productId: 'spirit-china-001',
    title: '11-Day China & Japan Discovery',
    shipName: 'Norwegian Spirit',
    shipClass: 'Spirit Class',
    capacity: 1966,
    duration: '11 days',
    route: const CruiseRoute(
      routeId: 'china-japan-001',
      title: 'Ancient Empires & Modern Marvels',
      description: 'Explore thousands of years of Asian culture',
      region: 'Asia',
      routeColor: Colors.orange,
      waypoints: [
        PortLocation(
          name: 'Shanghai',
          latitude: 31.2304,
          longitude: 121.4737,
          country: 'China',
          description: 'The Pearl of the Orient',
        ),
        PortLocation(
          name: 'Beijing (Tianjin)',
          latitude: 39.0458,
          longitude: 117.7219,
          country: 'China',
          description: 'Great Wall & Forbidden City',
        ),
        PortLocation(
          name: 'Dalian',
          latitude: 38.9140,
          longitude: 121.6147,
          country: 'China',
          description: 'Garden city by the sea',
        ),
        PortLocation(
          name: 'Busan',
          latitude: 35.1796,
          longitude: 129.0756,
          country: 'South Korea',
          description: 'Cultural bridge',
        ),
        PortLocation(
          name: 'Nagasaki',
          latitude: 32.7503,
          longitude: 129.8779,
          country: 'Japan',
          description: 'Peace memorial city',
        ),
        PortLocation(
          name: 'Osaka',
          latitude: 34.6937,
          longitude: 135.5023,
          country: 'Japan',
          description: 'Kitchen of Japan',
        ),
        PortLocation(
          name: 'Tokyo (Yokohama)',
          latitude: 35.4437,
          longitude: 139.6380,
          country: 'Japan',
          description: 'Modern metropolis',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2699, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 8), 14),
    description:
        'Journey through ancient civilizations and cutting-edge cultures.',
    highlights: [
      'Great Wall of China',
      'Forbidden City',
      'Traditional Tea Ceremonies',
      'Cherry Blossom Viewing',
      'Modern Tokyo Skyline',
    ],
    bookingUrl: 'ncl://book/spirit-china-001',
    imageUrl: 'assets/images/norwegian-spirit-china.jpg',
  );

  /// Japan & Korea Discovery - Norwegian Jade
  static final norwegianJadeJapanKorea = CruiseProduct(
    productId: 'jade-japan-korea-001',
    title: '14-Day Japan & Korea Discovery',
    shipName: 'Norwegian Jade',
    shipClass: 'Jewel Class',
    capacity: 2402,
    duration: '14 days',
    route: const CruiseRoute(
      routeId: 'japan-korea-001',
      title: 'Tokyo to Seoul Adventure',
      description: 'Ancient traditions meet modern innovation',
      region: 'Asia',
      routeColor: Colors.pink,
      waypoints: [
        PortLocation(
          name: 'Tokyo (Yokohama)',
          latitude: 35.4437,
          longitude: 139.6380,
          country: 'Japan',
          description: 'Modern metropolis & traditional culture',
        ),
        PortLocation(
          name: 'Osaka',
          latitude: 34.6937,
          longitude: 135.5023,
          country: 'Japan',
          description: 'Kitchen of Japan & Osaka Castle',
        ),
        PortLocation(
          name: 'Nagoya',
          latitude: 35.1815,
          longitude: 136.9066,
          country: 'Japan',
          description: 'Toyota City & traditional crafts',
        ),
        PortLocation(
          name: 'Kochi',
          latitude: 33.5597,
          longitude: 133.5311,
          country: 'Japan',
          description: 'Peaceful coastal town',
        ),
        PortLocation(
          name: 'Busan',
          latitude: 35.1796,
          longitude: 129.0756,
          country: 'South Korea',
          description: 'Coastal gateway to Korea',
        ),
        PortLocation(
          name: 'Jeju Island',
          latitude: 33.4996,
          longitude: 126.5312,
          country: 'South Korea',
          description: 'Volcanic island paradise',
        ),
        PortLocation(
          name: 'Incheon (Seoul)',
          latitude: 37.4563,
          longitude: 126.7052,
          country: 'South Korea',
          description: 'Gateway to Seoul',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 15), 18),
    description:
        'Discover the perfect blend of ancient traditions and cutting-edge modernity.',
    highlights: [
      'Mount Fuji Views',
      'Cherry Blossom Season',
      'Korean Palace Tours',
      'Hot Springs & Spas',
      'Authentic Cuisine',
    ],
    bookingUrl: 'ncl://book/jade-japan-korea-001',
    imageUrl: 'assets/images/norwegian-jade-asia.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Asian cruise
  );

  /// Indonesian Islands Explorer - Norwegian Sun
  static final norwegianSunIndonesia = CruiseProduct(
    productId: 'sun-indonesia-001',
    title: '10-Day Indonesian Islands',
    shipName: 'Norwegian Sun',
    shipClass: 'Sun Class',
    capacity: 1936,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'indonesia-001',
      title: 'Bali to Jakarta Island Hopping',
      description: 'Tropical paradise and diverse cultures',
      region: 'Asia',
      routeColor: Colors.green,
      waypoints: [
        PortLocation(
          name: 'Bali (Benoa)',
          latitude: -8.7467,
          longitude: 115.2269,
          country: 'Indonesia',
          description: 'Island of the Gods',
        ),
        PortLocation(
          name: 'Lombok',
          latitude: -8.6500,
          longitude: 116.3240,
          country: 'Indonesia',
          description: 'Pristine beaches & Mount Rinjani',
        ),
        PortLocation(
          name: 'Komodo Island',
          latitude: -8.5537,
          longitude: 119.4519,
          country: 'Indonesia',
          description: 'Home of the Komodo Dragons',
        ),
        PortLocation(
          name: 'Surabaya',
          latitude: -7.2575,
          longitude: 112.7521,
          country: 'Indonesia',
          description: 'Hero City & cultural gateway',
        ),
        PortLocation(
          name: 'Jakarta',
          latitude: -6.2088,
          longitude: 106.8456,
          country: 'Indonesia',
          description: 'Capital city & modern metropolis',
        ),
        PortLocation(
          name: 'Semarang',
          latitude: -6.9667,
          longitude: 110.4167,
          country: 'Indonesia',
          description: 'Dutch colonial heritage',
        ),
        PortLocation(
          name: 'Bali (Benoa)',
          latitude: -8.7467,
          longitude: 115.2269,
          country: 'Indonesia',
          description: 'Return to Bali',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1699, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 3, 20), 22),
    description:
        'Explore the incredible diversity of Indonesia\'s 17,000 islands.',
    highlights: [
      'Komodo Dragon Encounters',
      'Balinese Hindu Temples',
      'Volcanic Landscapes',
      'Traditional Batik Art',
      'Tropical Snorkeling',
    ],
    bookingUrl: 'ncl://book/sun-indonesia-001',
    imageUrl: 'assets/images/norwegian-sun-indonesia.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// India & Sri Lanka Discovery - Norwegian Star
  static final norwegianStarIndiaSriLanka = CruiseProduct(
    productId: 'star-india-sri-lanka-001',
    title: '12-Day India & Sri Lanka',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'india-sri-lanka-001',
      title: 'Mumbai to Colombo Heritage',
      description: 'Ancient civilizations and spiritual journeys',
      region: 'Asia',
      routeColor: Colors.orange,
      waypoints: [
        PortLocation(
          name: 'Mumbai',
          latitude: 19.0760,
          longitude: 72.8777,
          country: 'India',
          description: 'Gateway of India & Bollywood',
        ),
        PortLocation(
          name: 'Goa',
          latitude: 15.2993,
          longitude: 74.1240,
          country: 'India',
          description: 'Portuguese heritage & beaches',
        ),
        PortLocation(
          name: 'Cochin (Kochi)',
          latitude: 9.9312,
          longitude: 76.2673,
          country: 'India',
          description: 'Queen of the Arabian Sea',
        ),
        PortLocation(
          name: 'Colombo',
          latitude: 6.9271,
          longitude: 79.8612,
          country: 'Sri Lanka',
          description: 'Commercial capital of Ceylon',
        ),
        PortLocation(
          name: 'Hambantota',
          latitude: 6.1241,
          longitude: 81.1185,
          country: 'Sri Lanka',
          description: 'Southern gateway & wildlife',
        ),
        PortLocation(
          name: 'Chennai',
          latitude: 13.0827,
          longitude: 80.2707,
          country: 'India',
          description: 'Detroit of India',
        ),
        PortLocation(
          name: 'Mumbai',
          latitude: 19.0760,
          longitude: 72.8777,
          country: 'India',
          description: 'Return to Mumbai',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1999, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 2, 28), 16),
    description:
        'Journey through the subcontinent\'s rich tapestry of cultures and religions.',
    highlights: [
      'Taj Mahal Excursions',
      'Spice Market Tours',
      'Buddhist Temple Visits',
      'Tea Plantation Tours',
      'Ayurvedic Wellness',
    ],
    bookingUrl: 'ncl://book/star-india-sri-lanka-001',
    imageUrl: 'assets/images/norwegian-star-india.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// East Africa Safari & Spices - Norwegian Gem
  static final norwegianGemEastAfrica = CruiseProduct(
    productId: 'gem-east-africa-001',
    title: '12-Day East Africa Safari',
    shipName: 'Norwegian Gem',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'east-africa-001',
      title: 'Kenya & Tanzania Adventure',
      description: 'Wildlife safaris and spice islands',
      region: 'Africa',
      routeColor: Colors.brown,
      waypoints: [
        PortLocation(
          name: 'Mombasa',
          latitude: -4.0435,
          longitude: 39.6682,
          country: 'Kenya',
          description: 'Gateway to safari adventures',
        ),
        PortLocation(
          name: 'Zanzibar',
          latitude: -6.1659,
          longitude: 39.2026,
          country: 'Tanzania',
          description: 'Spice Island paradise',
        ),
        PortLocation(
          name: 'Dar es Salaam',
          latitude: -6.7924,
          longitude: 39.2083,
          country: 'Tanzania',
          description: 'Gateway to Serengeti',
        ),
        PortLocation(
          name: 'Mayotte',
          latitude: -12.8275,
          longitude: 45.1662,
          country: 'France',
          description: 'French tropical paradise',
        ),
        PortLocation(
          name: 'Nosy Be',
          latitude: -13.3203,
          longitude: 48.2696,
          country: 'Madagascar',
          description: 'Perfume island',
        ),
        PortLocation(
          name: 'Port Louis',
          latitude: -20.1619,
          longitude: 57.5012,
          country: 'Mauritius',
          description: 'Multicultural melting pot',
        ),
        PortLocation(
          name: 'Mombasa',
          latitude: -4.0435,
          longitude: 39.6682,
          country: 'Kenya',
          description: 'Return to Mombasa',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2699, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 6, 10), 14),
    description:
        'Experience the Big Five and tropical spice islands of East Africa.',
    highlights: [
      'Serengeti Safari Tours',
      'Spice Farm Visits',
      'Stone Town UNESCO Site',
      'Lemur Encounters',
      'African Cultural Shows',
    ],
    bookingUrl: 'ncl://book/gem-east-africa-001',
    imageUrl: 'assets/images/norwegian-gem-africa.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured African cruise
  );

  /// West Africa & Morocco - Norwegian Escape
  static final norwegianEscapeWestAfrica = CruiseProduct(
    productId: 'escape-west-africa-001',
    title: '10-Day West Africa & Morocco',
    shipName: 'Norwegian Escape',
    shipClass: 'Breakaway Plus Class',
    capacity: 4266,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'west-africa-001',
      title: 'Casablanca to Canary Islands',
      description: 'Imperial cities and volcanic islands',
      region: 'Africa',
      routeColor: Colors.deepOrange,
      waypoints: [
        PortLocation(
          name: 'Casablanca',
          latitude: 33.5731,
          longitude: -7.5898,
          country: 'Morocco',
          description: 'White city of Morocco',
        ),
        PortLocation(
          name: 'Agadir',
          latitude: 30.4278,
          longitude: -9.5981,
          country: 'Morocco',
          description: 'Modern resort city',
        ),
        PortLocation(
          name: 'Las Palmas',
          latitude: 28.1248,
          longitude: -15.4300,
          country: 'Spain',
          description: 'Canary Islands capital',
        ),
        PortLocation(
          name: 'Santa Cruz de Tenerife',
          latitude: 28.4636,
          longitude: -16.2518,
          country: 'Spain',
          description: 'Volcanic island paradise',
        ),
        PortLocation(
          name: 'Funchal',
          latitude: 32.6669,
          longitude: -16.9241,
          country: 'Portugal',
          description: 'Madeira wine country',
        ),
        PortLocation(
          name: 'Tangier',
          latitude: 35.7595,
          longitude: -5.8340,
          country: 'Morocco',
          description: 'Gateway between Africa & Europe',
        ),
        PortLocation(
          name: 'Casablanca',
          latitude: 33.5731,
          longitude: -7.5898,
          country: 'Morocco',
          description: 'Return to Casablanca',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1799, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 5), 20),
    description:
        'Discover the magic of Morocco and the natural beauty of Atlantic islands.',
    highlights: [
      'Hassan II Mosque',
      'Atlas Mountain Views',
      'Berber Culture Tours',
      'Volcanic Landscapes',
      'Traditional Souks',
    ],
    bookingUrl: 'ncl://book/escape-west-africa-001',
    imageUrl: 'assets/images/norwegian-escape-morocco.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured West Africa cruise
  );

  /// Philippines & Vietnam Discovery - Norwegian Spirit
  static final norwegianSpiritPhilippinesVietnam = CruiseProduct(
    productId: 'spirit-philippines-vietnam-001',
    title: '11-Day Philippines & Vietnam',
    shipName: 'Norwegian Spirit',
    shipClass: 'Spirit Class',
    capacity: 1966,
    duration: '11 days',
    route: const CruiseRoute(
      routeId: 'philippines-vietnam-001',
      title: 'Manila to Ho Chi Minh Adventure',
      description: 'Tropical islands and French colonial charm',
      region: 'Asia',
      routeColor: Colors.teal,
      waypoints: [
        PortLocation(
          name: 'Manila',
          latitude: 14.5995,
          longitude: 120.9842,
          country: 'Philippines',
          description: 'Pearl of the Orient',
        ),
        PortLocation(
          name: 'Boracay',
          latitude: 11.9674,
          longitude: 121.9248,
          country: 'Philippines',
          description: 'White Beach paradise',
        ),
        PortLocation(
          name: 'Puerto Princesa',
          latitude: 9.7392,
          longitude: 118.7353,
          country: 'Philippines',
          description: 'Underground river wonder',
        ),
        PortLocation(
          name: 'Nha Trang',
          latitude: 12.2388,
          longitude: 109.1967,
          country: 'Vietnam',
          description: 'Coastal resort city',
        ),
        PortLocation(
          name: 'Ho Chi Minh City',
          latitude: 10.8231,
          longitude: 106.6297,
          country: 'Vietnam',
          description: 'Saigon\'s vibrant energy',
        ),
        PortLocation(
          name: 'Halong Bay',
          latitude: 20.9101,
          longitude: 107.1839,
          country: 'Vietnam',
          description: 'UNESCO limestone karsts',
        ),
        PortLocation(
          name: 'Manila',
          latitude: 14.5995,
          longitude: 120.9842,
          country: 'Philippines',
          description: 'Return to Manila',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1599, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 1, 25), 24),
    description:
        'Explore pristine tropical islands and rich cultural heritage.',
    highlights: [
      'Palawan Underground River',
      'Halong Bay Cruising',
      'French Colonial Architecture',
      'Tropical Island Hopping',
      'Vietnamese Cuisine Tours',
    ],
    bookingUrl: 'ncl://book/spirit-philippines-vietnam-001',
    imageUrl: 'assets/images/norwegian-spirit-philippines.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Brazilian Coast & Chilean Fjords - Norwegian Pearl
  static final norwegianPearlSouthAmerica = CruiseProduct(
    productId: 'pearl-south-america-001',
    title: '14-Day South America Grand Journey',
    shipName: 'Norwegian Pearl',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '14 days',
    route: const CruiseRoute(
      routeId: 'south-america-001',
      title: 'Rio to Santiago Adventure',
      description: 'From Carnival beaches to Patagonian fjords',
      region: 'South America',
      routeColor: Colors.purple,
      waypoints: [
        PortLocation(
          name: 'Rio de Janeiro',
          latitude: -22.9068,
          longitude: -43.1729,
          country: 'Brazil',
          description: 'Christ the Redeemer & Copacabana',
        ),
        PortLocation(
          name: 'Santos (São Paulo)',
          latitude: -23.9351,
          longitude: -46.3256,
          country: 'Brazil',
          description: 'Gateway to São Paulo',
        ),
        PortLocation(
          name: 'Florianópolis',
          latitude: -27.5954,
          longitude: -48.5480,
          country: 'Brazil',
          description: 'Magic Island beaches',
        ),
        PortLocation(
          name: 'Montevideo',
          latitude: -34.9011,
          longitude: -56.1645,
          country: 'Uruguay',
          description: 'Historic colonial charm',
        ),
        PortLocation(
          name: 'Buenos Aires',
          latitude: -34.6118,
          longitude: -58.3960,
          country: 'Argentina',
          description: 'Tango capital of the world',
        ),
        PortLocation(
          name: 'Puerto Madryn',
          latitude: -42.7692,
          longitude: -65.0383,
          country: 'Argentina',
          description: 'Whale watching paradise',
        ),
        PortLocation(
          name: 'Chilean Fjords',
          latitude: -50.9423,
          longitude: -73.4068,
          country: 'Chile',
          description: 'Dramatic glacial landscapes',
        ),
        PortLocation(
          name: 'Valparaíso',
          latitude: -33.0472,
          longitude: -71.6127,
          country: 'Chile',
          description: 'Colorful hillside port city',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 11, 5), 12),
    description:
        'Discover the vibrant cultures and stunning landscapes of South America.',
    highlights: [
      'Christ the Redeemer Statue',
      'Tango Shows in Buenos Aires',
      'Patagonian Wildlife',
      'Chilean Fjords Cruising',
      'Carnival Culture',
    ],
    bookingUrl: 'ncl://book/pearl-south-america-001',
    imageUrl: 'assets/images/norwegian-pearl-south-america.jpg',
    zoomTier: CruiseZoomTier.essential, // Make this a featured route
  );

  /// Mexican Riviera Paradise - Norwegian Bliss
  static final norwegianBlissMexicanRiviera = CruiseProduct(
    productId: 'bliss-mexican-riviera-001',
    title: '7-Day Mexican Riviera',
    shipName: 'Norwegian Bliss',
    shipClass: 'Breakaway Plus Class',
    capacity: 4004,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'mexican-riviera-001',
      title: 'Los Angeles to Cabo & Beyond',
      description: 'Pacific coast paradise and vibrant Mexican culture',
      region: 'Latin America',
      routeColor: Colors.orange,
      waypoints: [
        PortLocation(
          name: 'Los Angeles',
          latitude: 34.0522,
          longitude: -118.2437,
          country: 'USA',
          description: 'City of Angels departure',
        ),
        PortLocation(
          name: 'Cabo San Lucas',
          latitude: 22.8905,
          longitude: -109.9167,
          country: 'Mexico',
          description: 'Land\'s End & luxury resorts',
        ),
        PortLocation(
          name: 'Mazatlán',
          latitude: 23.2494,
          longitude: -106.4194,
          country: 'Mexico',
          description: 'Pearl of the Pacific',
        ),
        PortLocation(
          name: 'Puerto Vallarta',
          latitude: 20.6534,
          longitude: -105.2253,
          country: 'Mexico',
          description: 'Golden beaches & colonial charm',
        ),
        PortLocation(
          name: 'Los Angeles',
          latitude: 34.0522,
          longitude: -118.2437,
          country: 'USA',
          description: 'Return to Los Angeles',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 699, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 2, 10), 30),
    description:
        'Experience Mexico\'s stunning Pacific coastline and vibrant beach culture.',
    highlights: [
      'Cabo\'s Arch & Sea Lions',
      'Mazatlán Historic Center',
      'Puerto Vallarta Malecón',
      'Mexican Cuisine & Tequila',
      'Pacific Sunset Views',
    ],
    bookingUrl: 'ncl://book/bliss-mexican-riviera-001',
    imageUrl: 'assets/images/norwegian-bliss-mexico.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Latin America cruise
  );

  /// Panama Canal Explorer - Norwegian Pearl
  static final norwegianPearlPanamaCanal = CruiseProduct(
    productId: 'pearl-panama-canal-001',
    title: '11-Day Panama Canal Voyage',
    shipName: 'Norwegian Pearl',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '11 days',
    route: const CruiseRoute(
      routeId: 'panama-canal-001',
      title: 'Engineering Marvel Transit',
      description: 'Through the locks connecting two oceans',
      region: 'Latin America',
      routeColor: Colors.blue,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to Latin America',
        ),
        PortLocation(
          name: 'Ocho Rios',
          latitude: 18.4074,
          longitude: -77.1103,
          country: 'Jamaica',
          description: 'Dunn\'s River Falls',
        ),
        PortLocation(
          name: 'Cartagena',
          latitude: 10.3997,
          longitude: -75.5144,
          country: 'Colombia',
          description: 'Colonial Caribbean jewel',
        ),
        PortLocation(
          name: 'Panama Canal',
          latitude: 9.0355,
          longitude: -79.5975,
          country: 'Panama',
          description: 'Engineering wonder transit',
        ),
        PortLocation(
          name: 'Colón',
          latitude: 9.3547,
          longitude: -79.9009,
          country: 'Panama',
          description: 'Caribbean entrance to canal',
        ),
        PortLocation(
          name: 'Limón',
          latitude: 9.9934,
          longitude: -83.0355,
          country: 'Costa Rica',
          description: 'Rainforest adventures',
        ),
        PortLocation(
          name: 'Harvest Caye',
          latitude: 16.4419,
          longitude: -88.0048,
          country: 'Belize',
          description: 'NCL\'s private island',
        ),
        PortLocation(
          name: 'Cozumel',
          latitude: 20.4230,
          longitude: -86.9223,
          country: 'Mexico',
          description: 'Mayan ruins & coral reefs',
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
    pricing: const PriceRange(startingPrice: 1399, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 1, 20), 16),
    description:
        'Witness one of the world\'s greatest engineering marvels on this transit cruise.',
    highlights: [
      'Panama Canal Transit',
      'Cartagena Colonial City',
      'Costa Rican Rainforests',
      'Mayan Archaeological Sites',
      'Caribbean Island Paradise',
    ],
    bookingUrl: 'ncl://book/pearl-panama-canal-001',
    imageUrl: 'assets/images/norwegian-pearl-panama.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Central America Discovery - Norwegian Encore
  static final norwegianEncoreCentralAmerica = CruiseProduct(
    productId: 'encore-central-america-001',
    title: '7-Day Central America',
    shipName: 'Norwegian Encore',
    shipClass: 'Breakaway Plus Class',
    capacity: 4901,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'central-america-001',
      title: 'Mayan Ruins & Tropical Paradise',
      description: 'Ancient civilizations and pristine beaches',
      region: 'Latin America',
      routeColor: Colors.green,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Magic City departure',
        ),
        PortLocation(
          name: 'Roatán',
          latitude: 16.3026,
          longitude: -86.5764,
          country: 'Honduras',
          description: 'Bay Islands diving paradise',
        ),
        PortLocation(
          name: 'Harvest Caye',
          latitude: 16.4419,
          longitude: -88.0048,
          country: 'Belize',
          description: 'Private island adventure',
        ),
        PortLocation(
          name: 'Costa Maya',
          latitude: 18.7373,
          longitude: -87.7584,
          country: 'Mexico',
          description: 'Mayan coastal paradise',
        ),
        PortLocation(
          name: 'Cozumel',
          latitude: 20.4230,
          longitude: -86.9223,
          country: 'Mexico',
          description: 'Sacred Mayan island',
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
    departureDates: _generateDepartureDates(DateTime(2024, 1, 5), 28),
    description:
        'Discover ancient Mayan culture and pristine Caribbean waters.',
    highlights: [
      'Mayan Ruins & Temples',
      'World-Class Diving',
      'Pristine Coral Reefs',
      'Tropical Beach Paradise',
      'Local Cuisine & Culture',
    ],
    bookingUrl: 'ncl://book/encore-central-america-001',
    imageUrl: 'assets/images/norwegian-encore-central-america.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// South American Capitals - Norwegian Star
  static final norwegianStarSouthAmericanCapitals = CruiseProduct(
    productId: 'star-south-american-capitals-001',
    title: '15-Day South American Capitals',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '15 days',
    route: const CruiseRoute(
      routeId: 'south-american-capitals-001',
      title: 'From Caribbean to Patagonia',
      description: 'Grand tour of South America\'s great cities',
      region: 'Latin America',
      routeColor: Colors.red,
      waypoints: [
        PortLocation(
          name: 'Fort Lauderdale',
          latitude: 26.1224,
          longitude: -80.1373,
          country: 'USA',
          description: 'Venice of America',
        ),
        PortLocation(
          name: 'Cartagena',
          latitude: 10.3997,
          longitude: -75.5144,
          country: 'Colombia',
          description: 'Walled colonial city',
        ),
        PortLocation(
          name: 'Willemstad',
          latitude: 12.1224,
          longitude: -68.9335,
          country: 'Curaçao',
          description: 'Colorful Dutch Caribbean',
        ),
        PortLocation(
          name: 'La Guaira',
          latitude: 10.6010,
          longitude: -66.9323,
          country: 'Venezuela',
          description: 'Gateway to Caracas',
        ),
        PortLocation(
          name: 'Georgetown',
          latitude: 6.8013,
          longitude: -58.1551,
          country: 'Guyana',
          description: 'Garden city of the Caribbean',
        ),
        PortLocation(
          name: 'Belém',
          latitude: -1.4558,
          longitude: -48.5044,
          country: 'Brazil',
          description: 'Gateway to the Amazon',
        ),
        PortLocation(
          name: 'Recife',
          latitude: -8.0476,
          longitude: -34.8770,
          country: 'Brazil',
          description: 'Venice of Brazil',
        ),
        PortLocation(
          name: 'Salvador',
          latitude: -12.9714,
          longitude: -38.5014,
          country: 'Brazil',
          description: 'Afro-Brazilian cultural heart',
        ),
        PortLocation(
          name: 'Rio de Janeiro',
          latitude: -22.9068,
          longitude: -43.1729,
          country: 'Brazil',
          description: 'Marvelous City',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2199, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 3, 12), 8),
    description:
        'Experience the diverse cultures and vibrant cities of South America.',
    highlights: [
      'Cartagena UNESCO Site',
      'Amazon River Gateway',
      'Brazilian Carnival Culture',
      'Colonial Architecture',
      'South American Cuisine',
    ],
    bookingUrl: 'ncl://book/star-south-american-capitals-001',
    imageUrl: 'assets/images/norwegian-star-south-america.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// California Coastal Paradise - Norwegian Bliss
  static final norwegianBlissCaliforniaCoast = CruiseProduct(
    productId: 'bliss-california-coast-001',
    title: '7-Day California Coastal',
    shipName: 'Norwegian Bliss',
    shipClass: 'Breakaway Plus Class',
    capacity: 4004,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'california-coast-001',
      title: 'Pacific Coast Discovery',
      description: 'Iconic California coastline and wine country',
      region: 'California',
      routeColor: Colors.blue,
      waypoints: [
        PortLocation(
          name: 'Los Angeles',
          latitude: 34.0522,
          longitude: -118.2437,
          country: 'USA',
          description: 'City of Angels departure',
        ),
        PortLocation(
          name: 'Santa Barbara',
          latitude: 34.4208,
          longitude: -119.6982,
          country: 'USA',
          description: 'American Riviera',
        ),
        PortLocation(
          name: 'San Francisco',
          latitude: 37.7749,
          longitude: -122.4194,
          country: 'USA',
          description: 'Golden Gate city',
        ),
        PortLocation(
          name: 'Monterey',
          latitude: 36.6002,
          longitude: -121.8947,
          country: 'USA',
          description: 'Carmel and Pebble Beach',
        ),
        PortLocation(
          name: 'San Diego',
          latitude: 32.7157,
          longitude: -117.1611,
          country: 'USA',
          description: 'America\'s Finest City',
        ),
        PortLocation(
          name: 'Los Angeles',
          latitude: 34.0522,
          longitude: -118.2437,
          country: 'USA',
          description: 'Return to Los Angeles',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1199, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 15), 20),
    description:
        'Discover the stunning California coastline with wine country and coastal charm.',
    highlights: [
      'Golden Gate Bridge',
      'Napa Valley Access',
      'Carmel-by-the-Sea',
      'Hollywood & Beverly Hills',
      'Balboa Park San Diego',
    ],
    bookingUrl: 'ncl://book/bliss-california-coast-001',
    imageUrl: 'assets/images/norwegian-bliss-california.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured California cruise
  );

  /// Baja California Adventure - Norwegian Gem
  static final norwegianGemBajaCalifornia = CruiseProduct(
    productId: 'gem-baja-california-001',
    title: '10-Day Baja California Discovery',
    shipName: 'Norwegian Gem',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'baja-california-001',
      title: 'Baja Peninsula Explorer',
      description: 'Desert landscapes meet Pacific waters',
      region: 'Mexico',
      routeColor: Colors.teal,
      waypoints: [
        PortLocation(
          name: 'San Diego',
          latitude: 32.7157,
          longitude: -117.1611,
          country: 'USA',
          description: 'Southern California gateway',
        ),
        PortLocation(
          name: 'Ensenada',
          latitude: 31.8444,
          longitude: -116.5984,
          country: 'Mexico',
          description: 'Baja wine country',
        ),
        PortLocation(
          name: 'Cabo San Lucas',
          latitude: 22.8905,
          longitude: -109.9167,
          country: 'Mexico',
          description: 'Land\'s End rock formations',
        ),
        PortLocation(
          name: 'La Paz',
          latitude: 24.1426,
          longitude: -110.3128,
          country: 'Mexico',
          description: 'Sea of Cortez pearl diving',
        ),
        PortLocation(
          name: 'Loreto',
          latitude: 26.0109,
          longitude: -111.3485,
          country: 'Mexico',
          description: 'Historic Baja mission town',
        ),
        PortLocation(
          name: 'Mazatlán',
          latitude: 23.2494,
          longitude: -106.4103,
          country: 'Mexico',
          description: 'Pearl of the Pacific',
        ),
        PortLocation(
          name: 'San Diego',
          latitude: 32.7157,
          longitude: -117.1611,
          country: 'USA',
          description: 'Return to San Diego',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1799, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 11, 8), 12),
    description:
        'Explore Mexico\'s stunning Baja Peninsula with desert beauty and marine life.',
    highlights: [
      'Cabo Arch Formation',
      'Sea of Cortez Snorkeling',
      'Baja Wine Tasting',
      'Desert Landscapes',
      'Traditional Mexican Culture',
    ],
    bookingUrl: 'ncl://book/gem-baja-california-001',
    imageUrl: 'assets/images/norwegian-gem-baja.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Chilean Fjords Explorer - Norwegian Sun
  static final norwegianSunChileanFjords = CruiseProduct(
    productId: 'sun-chilean-fjords-001',
    title: '14-Day Chilean Fjords & Patagonia',
    shipName: 'Norwegian Sun',
    shipClass: 'Dawn Class',
    capacity: 1936,
    duration: '14 days',
    route: const CruiseRoute(
      routeId: 'chilean-fjords-001',
      title: 'Patagonian Wilderness',
      description: 'Dramatic fjords and pristine glaciers',
      region: 'South America',
      routeColor: Colors.blueGrey,
      waypoints: [
        PortLocation(
          name: 'Santiago',
          latitude: -33.4489,
          longitude: -70.6693,
          country: 'Chile',
          description: 'Andean capital departure',
        ),
        PortLocation(
          name: 'Puerto Montt',
          latitude: -41.4693,
          longitude: -72.9424,
          country: 'Chile',
          description: 'Lake District gateway',
        ),
        PortLocation(
          name: 'Castro',
          latitude: -42.4827,
          longitude: -73.7615,
          country: 'Chile',
          description: 'Chiloe Island culture',
        ),
        PortLocation(
          name: 'Chacabuco',
          latitude: -45.4667,
          longitude: -72.8167,
          country: 'Chile',
          description: 'Patagonian fjords',
        ),
        PortLocation(
          name: 'Punta Arenas',
          latitude: -53.1638,
          longitude: -70.9171,
          country: 'Chile',
          description: 'Strait of Magellan',
        ),
        PortLocation(
          name: 'Ushuaia',
          latitude: -54.8019,
          longitude: -68.3030,
          country: 'Argentina',
          description: 'End of the world',
        ),
        PortLocation(
          name: 'Santiago',
          latitude: -33.4489,
          longitude: -70.6693,
          country: 'Chile',
          description: 'Return to Santiago',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 3299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 12, 5), 6),
    description:
        'Navigate the dramatic Chilean fjords and witness Patagonian wilderness.',
    highlights: [
      'Dramatic Glacial Fjords',
      'Patagonian Wildlife',
      'Strait of Magellan',
      'Andes Mountain Views',
      'Gaucho Culture',
    ],
    bookingUrl: 'ncl://book/sun-chilean-fjords-001',
    imageUrl: 'assets/images/norwegian-sun-chile.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// West African Coast Explorer - Norwegian Star
  static final norwegianStarWestAfricanCoast = CruiseProduct(
    productId: 'star-west-african-coast-001',
    title: '12-Day West African Coast',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'west-african-coast-001',
      title: 'Gold Coast Discovery',
      description: 'Historic trading ports and vibrant cultures',
      region: 'Africa',
      routeColor: Colors.orange,
      waypoints: [
        PortLocation(
          name: 'Dakar',
          latitude: 14.7167,
          longitude: -17.4677,
          country: 'Senegal',
          description: 'Westernmost African capital',
        ),
        PortLocation(
          name: 'Banjul',
          latitude: 13.4549,
          longitude: -16.5790,
          country: 'Gambia',
          description: 'River Gambia mouth',
        ),
        PortLocation(
          name: 'Freetown',
          latitude: 8.4657,
          longitude: -13.2317,
          country: 'Sierra Leone',
          description: 'Natural harbor city',
        ),
        PortLocation(
          name: 'Abidjan',
          latitude: 5.3600,
          longitude: -4.0083,
          country: 'Ivory Coast',
          description: 'Economic capital',
        ),
        PortLocation(
          name: 'Accra',
          latitude: 5.6037,
          longitude: -0.1870,
          country: 'Ghana',
          description: 'Gold Coast heritage',
        ),
        PortLocation(
          name: 'Lomé',
          latitude: 6.1319,
          longitude: 1.2228,
          country: 'Togo',
          description: 'Atlantic coastal charm',
        ),
        PortLocation(
          name: 'Dakar',
          latitude: 14.7167,
          longitude: -17.4677,
          country: 'Senegal',
          description: 'Return to Dakar',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 10, 12), 8),
    description:
        'Discover the rich history and vibrant cultures of West Africa\'s coast.',
    highlights: [
      'UNESCO Heritage Sites',
      'Traditional African Markets',
      'Colonial Architecture',
      'West African Music',
      'Cultural Immersion',
    ],
    bookingUrl: 'ncl://book/star-west-african-coast-001',
    imageUrl: 'assets/images/norwegian-star-west-africa.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Antarctic Circle Crossing - Norwegian Gem
  static final norwegianGemAntarcticCircle = CruiseProduct(
    productId: 'gem-antarctic-circle-001',
    title: '21-Day Antarctic Circle Crossing',
    shipName: 'Norwegian Gem',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '21 days',
    route: const CruiseRoute(
      routeId: 'antarctic-circle-001',
      title: 'Ultimate Antarctic Adventure',
      description: 'Cross the Antarctic Circle for the ultimate expedition',
      region: 'Antarctica',
      routeColor: Colors.cyan,
      waypoints: [
        PortLocation(
          name: 'Valparaíso',
          latitude: -33.0458,
          longitude: -71.6197,
          country: 'Chile',
          description: 'Historic port city',
        ),
        PortLocation(
          name: 'Puerto Williams',
          latitude: -54.9333,
          longitude: -67.6167,
          country: 'Chile',
          description: 'Southernmost city',
        ),
        PortLocation(
          name: 'Elephant Island',
          latitude: -61.1000,
          longitude: -55.1667,
          country: 'Antarctica',
          description: 'Shackleton\'s refuge',
        ),
        PortLocation(
          name: 'Deception Island',
          latitude: -62.9667,
          longitude: -60.6000,
          country: 'Antarctica',
          description: 'Volcanic caldera',
        ),
        PortLocation(
          name: 'Lemaire Channel',
          latitude: -65.1000,
          longitude: -63.9500,
          country: 'Antarctica',
          description: 'Iceberg alley',
        ),
        PortLocation(
          name: 'Antarctic Circle',
          latitude: -66.5622,
          longitude: -65.0000,
          country: 'Antarctica',
          description: 'Cross into polar waters',
        ),
        PortLocation(
          name: 'South Shetland Islands',
          latitude: -62.0000,
          longitude: -58.0000,
          country: 'Antarctica',
          description: 'Penguin colonies',
        ),
        PortLocation(
          name: 'Valparaíso',
          latitude: -33.0458,
          longitude: -71.6197,
          country: 'Chile',
          description: 'Return to Valparaíso',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 12999, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 1, 20), 4),
    description:
        'The ultimate Antarctic expedition crossing the Antarctic Circle.',
    highlights: [
      'Antarctic Circle Crossing',
      'Emperor Penguin Colonies',
      'Zodiac Landings',
      'Iceberg Photography',
      'Polar Wildlife',
    ],
    bookingUrl: 'ncl://book/gem-antarctic-circle-001',
    imageUrl: 'assets/images/norwegian-gem-antarctic-circle.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Antarctica cruise
  );

  /// Brazilian Amazon - Norwegian Epic
  static final norwegianEpicBrazilianAmazon = CruiseProduct(
    productId: 'epic-brazilian-amazon-001',
    title: '12-Day Brazilian Amazon River',
    shipName: 'Norwegian Epic',
    shipClass: 'Epic Class',
    capacity: 4100,
    duration: '12 days',
    route: const CruiseRoute(
      routeId: 'brazilian-amazon-001',
      title: 'Amazon River Discovery',
      description: 'Navigate the mighty Amazon through Brazil',
      region: 'South America',
      routeColor: Colors.green,
      waypoints: [
        PortLocation(
          name: 'Manaus',
          latitude: -3.1190,
          longitude: -60.0217,
          country: 'Brazil',
          description: 'Heart of the Amazon',
        ),
        PortLocation(
          name: 'Santarém',
          latitude: -2.4094,
          longitude: -54.7083,
          country: 'Brazil',
          description: 'Meeting of waters',
        ),
        PortLocation(
          name: 'Alter do Chão',
          latitude: -2.5067,
          longitude: -54.9533,
          country: 'Brazil',
          description: 'Caribbean of the Amazon',
        ),
        PortLocation(
          name: 'Boca da Valeria',
          latitude: -2.6333,
          longitude: -56.2167,
          country: 'Brazil',
          description: 'Traditional river village',
        ),
        PortLocation(
          name: 'Parintins',
          latitude: -2.6281,
          longitude: -56.7356,
          country: 'Brazil',
          description: 'Folk festival city',
        ),
        PortLocation(
          name: 'Belém',
          latitude: -1.4558,
          longitude: -48.5044,
          country: 'Brazil',
          description: 'Amazon river mouth',
        ),
        PortLocation(
          name: 'Manaus',
          latitude: -3.1190,
          longitude: -60.0217,
          country: 'Brazil',
          description: 'Return to Manaus',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2599, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 6, 8), 10),
    description:
        'Journey deep into the Amazon rainforest and experience pristine wilderness.',
    highlights: [
      'Amazon Rainforest Expeditions',
      'Pink Dolphin Encounters',
      'Indigenous Village Visits',
      'Jungle Wildlife Spotting',
      'Meeting of Waters',
    ],
    bookingUrl: 'ncl://book/epic-brazilian-amazon-001',
    imageUrl: 'assets/images/norwegian-epic-amazon.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Miami-Based Cruises
  /// Southern Caribbean Grand Voyage - Norwegian Getaway
  static final norwegianGetawaySouthernCaribbean = CruiseProduct(
    productId: 'getaway-southern-caribbean-001',
    title: '10-Day Southern Caribbean',
    shipName: 'Norwegian Getaway',
    shipClass: 'Breakaway Class',
    capacity: 3963,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'southern-caribbean-001',
      title: 'Southern Caribbean Paradise',
      description: 'Discover the stunning southern islands',
      region: 'Caribbean',
      routeColor: Colors.teal,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to the Caribbean',
        ),
        PortLocation(
          name: 'Willemstad',
          latitude: 12.1084,
          longitude: -68.9335,
          country: 'Curaçao',
          description: 'Dutch colonial charm',
        ),
        PortLocation(
          name: 'Oranjestad',
          latitude: 12.5092,
          longitude: -70.0086,
          country: 'Aruba',
          description: 'One happy island',
        ),
        PortLocation(
          name: 'Kralendijk',
          latitude: 12.1508,
          longitude: -68.2773,
          country: 'Bonaire',
          description: 'Diving paradise',
        ),
        PortLocation(
          name: 'Bridgetown',
          latitude: 13.0969,
          longitude: -59.6145,
          country: 'Barbados',
          description: 'Island of rum and relaxation',
        ),
        PortLocation(
          name: 'St. Lucia',
          latitude: 14.0101,
          longitude: -60.9875,
          country: 'St. Lucia',
          description: 'Pitons and paradise',
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
    pricing: const PriceRange(startingPrice: 1399, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 14), 16),
    description:
        'Experience the ultimate Southern Caribbean adventure with pristine beaches, vibrant culture, and world-class diving.',
    highlights: [
      'ABC Islands Trio',
      'Rainbow Row Willemstad',
      'Eagle Beach Aruba',
      'World-Class Diving',
      'Pitons Mountain Views',
    ],
    bookingUrl: 'ncl://book/getaway-southern-caribbean-001',
    imageUrl: 'assets/images/norwegian-getaway-southern.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Western Caribbean Discovery - Norwegian Gem
  static final norwegianGemWestCaribbean = CruiseProduct(
    productId: 'gem-west-caribbean-001',
    title: '7-Day Western Caribbean',
    shipName: 'Norwegian Gem',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'west-caribbean-miami-001',
      title: 'Western Caribbean Explorer',
      description: 'Ancient Mayan ruins and tropical beaches',
      region: 'Caribbean',
      routeColor: Colors.amber,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to the Caribbean',
        ),
        PortLocation(
          name: 'Cozumel',
          latitude: 20.4230,
          longitude: -86.9223,
          country: 'Mexico',
          description: 'Island of the swallows',
        ),
        PortLocation(
          name: 'Costa Maya',
          latitude: 18.7373,
          longitude: -87.7084,
          country: 'Mexico',
          description: 'Ancient Mayan treasures',
        ),
        PortLocation(
          name: 'Harvest Caye',
          latitude: 16.0971,
          longitude: -88.2034,
          country: 'Belize',
          description: 'NCL\'s private island paradise',
        ),
        PortLocation(
          name: 'Roatan',
          latitude: 16.2918,
          longitude: -86.3644,
          country: 'Honduras',
          description: 'Caribbean reef diving',
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
    departureDates: _generateDepartureDates(DateTime(2024, 3, 17), 32),
    description:
        'Explore ancient Mayan civilizations and pristine Caribbean beaches on this classic Western Caribbean adventure.',
    highlights: [
      'Chichen Itza Excursions',
      'World-Class Snorkeling',
      'NCL Private Island',
      'Mayan Ruins Discovery',
      'Tropical Paradise Beaches',
    ],
    bookingUrl: 'ncl://book/gem-west-caribbean-001',
    imageUrl: 'assets/images/norwegian-gem-west-caribbean.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Bahamas & Key West Getaway - Norwegian Sky
  static final norwegianSkyBahamas = CruiseProduct(
    productId: 'sky-bahamas-001',
    title: '4-Day Bahamas & Key West',
    shipName: 'Norwegian Sky',
    shipClass: 'Sun Class',
    capacity: 2004,
    duration: '4 days',
    route: const CruiseRoute(
      routeId: 'bahamas-key-west-001',
      title: 'Quick Caribbean Escape',
      description: 'Perfect weekend getaway to paradise',
      region: 'Caribbean',
      routeColor: Colors.lightBlue,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to the Caribbean',
        ),
        PortLocation(
          name: 'Key West',
          latitude: 24.5551,
          longitude: -81.7800,
          country: 'USA',
          description: 'Southernmost point in the US',
        ),
        PortLocation(
          name: 'Nassau',
          latitude: 25.0443,
          longitude: -77.3504,
          country: 'Bahamas',
          description: 'Atlantis and pristine beaches',
        ),
        PortLocation(
          name: 'Great Stirrup Cay',
          latitude: 25.8267,
          longitude: -77.9167,
          country: 'Bahamas',
          description: 'NCL\'s private island paradise',
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
    pricing: const PriceRange(startingPrice: 399, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 3, 7), 48),
    description:
        'Perfect weekend escape to the Bahamas and Key West with sun, sand, and crystal-clear waters.',
    highlights: [
      'Duval Street Key West',
      'Atlantis Paradise Island',
      'NCL Private Beach',
      'Conch Republic Culture',
      'Quick Caribbean Fix',
    ],
    bookingUrl: 'ncl://book/sky-bahamas-001',
    imageUrl: 'assets/images/norwegian-sky-bahamas.jpg',
    zoomTier: CruiseZoomTier.essential, // Popular short cruise
  );

  /// Bermuda Triangle Adventure - Norwegian Breakaway
  static final norwegianBreakawayBermuda = CruiseProduct(
    productId: 'breakaway-bermuda-001',
    title: '7-Day Bermuda Paradise',
    shipName: 'Norwegian Breakaway',
    shipClass: 'Breakaway Class',
    capacity: 3963,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'bermuda-miami-001',
      title: 'Pink Sand Paradise',
      description: 'Bermuda\'s pink sand beaches and crystal caves',
      region: 'Bermuda',
      routeColor: Colors.pink,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to adventure',
        ),
        PortLocation(
          name: 'Royal Naval Dockyard',
          latitude: 32.3242,
          longitude: -64.8386,
          country: 'Bermuda',
          description: 'Historic British naval base',
        ),
        PortLocation(
          name: 'St. George',
          latitude: 32.3783,
          longitude: -64.6762,
          country: 'Bermuda',
          description: 'UNESCO World Heritage site',
        ),
        PortLocation(
          name: 'Hamilton',
          latitude: 32.2930,
          longitude: -64.7780,
          country: 'Bermuda',
          description: 'Bermuda\'s capital city',
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
    pricing: const PriceRange(startingPrice: 1199, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 21), 20),
    description:
        'Discover Bermuda\'s pink sand beaches, crystal caves, and charming British culture on this tropical escape.',
    highlights: [
      'Pink Sand Beaches',
      'Crystal & Fantasy Caves',
      'Historic St. George',
      'Shopping in Hamilton',
      'British Colonial Architecture',
    ],
    bookingUrl: 'ncl://book/breakaway-bermuda-001',
    imageUrl: 'assets/images/norwegian-breakaway-bermuda.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Extended Caribbean Explorer - Norwegian Encore
  static final norwegianEncoreExtendedCaribbean = CruiseProduct(
    productId: 'encore-extended-caribbean-001',
    title: '11-Day Caribbean Grand Adventure',
    shipName: 'Norwegian Encore',
    shipClass: 'Breakaway Plus Class',
    capacity: 3998,
    duration: '11 days',
    route: const CruiseRoute(
      routeId: 'extended-caribbean-001',
      title: 'Ultimate Caribbean Journey',
      description: 'The most comprehensive Caribbean experience',
      region: 'Caribbean',
      routeColor: Colors.deepOrange,
      waypoints: [
        PortLocation(
          name: 'Miami',
          latitude: 25.7617,
          longitude: -80.1918,
          country: 'USA',
          description: 'Gateway to the Caribbean',
        ),
        PortLocation(
          name: 'St. Maarten',
          latitude: 18.0425,
          longitude: -63.0548,
          country: 'St. Maarten',
          description: 'Dual nation island paradise',
        ),
        PortLocation(
          name: 'St. John\'s',
          latitude: 17.1274,
          longitude: -61.8468,
          country: 'Antigua',
          description: '365 beaches island',
        ),
        PortLocation(
          name: 'Bridgetown',
          latitude: 13.0969,
          longitude: -59.6145,
          country: 'Barbados',
          description: 'Rum and British heritage',
        ),
        PortLocation(
          name: 'St. Lucia',
          latitude: 14.0101,
          longitude: -60.9875,
          country: 'St. Lucia',
          description: 'Pitons and paradise',
        ),
        PortLocation(
          name: 'St. Thomas',
          latitude: 18.3419,
          longitude: -64.9307,
          country: 'USVI',
          description: 'Duty-free shopping paradise',
        ),
        PortLocation(
          name: 'Great Stirrup Cay',
          latitude: 25.8267,
          longitude: -77.9167,
          country: 'Bahamas',
          description: 'NCL\'s private island paradise',
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
    pricing: const PriceRange(startingPrice: 1799, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 5, 5), 12),
    description:
        'The ultimate Caribbean adventure visiting both Eastern and Southern Caribbean gems with extended time in paradise.',
    highlights: [
      'Dual Nation St. Maarten',
      '365 Beaches Antigua',
      'Pitons UNESCO Site',
      'Multiple Private Islands',
      'Extended Caribbean Immersion',
    ],
    bookingUrl: 'ncl://book/encore-extended-caribbean-001',
    imageUrl: 'assets/images/norwegian-encore-extended.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Turkish Riviera & Greek Isles - Norwegian Escape
  static final norwegianEscapeTurkishRiviera = CruiseProduct(
    productId: 'escape-turkish-riviera-001',
    title: '10-Day Turkish Riviera & Greek Isles',
    shipName: 'Norwegian Escape',
    shipClass: 'Breakaway Plus Class',
    capacity: 4266,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'turkish-riviera-001',
      title: 'Turquoise Coast & Ancient Wonders',
      description:
          'Discover ancient civilizations along Turkey\'s stunning coast and Greek islands',
      region: 'Mediterranean',
      routeColor: Colors.teal,
      waypoints: [
        PortLocation(
          name: 'Athens',
          latitude: 37.9755,
          longitude: 23.7348,
          country: 'Greece',
          description: 'Gateway to ancient Greece',
        ),
        PortLocation(
          name: 'Kusadasi',
          latitude: 37.8587,
          longitude: 27.2597,
          country: 'Turkey',
          description: 'Gateway to ancient Ephesus',
        ),
        PortLocation(
          name: 'Antalya',
          latitude: 36.8969,
          longitude: 30.7133,
          country: 'Turkey',
          description: 'Turkish Riviera paradise',
        ),
        PortLocation(
          name: 'Bodrum',
          latitude: 37.0344,
          longitude: 27.4305,
          country: 'Turkey',
          description: 'St. Peter\'s Castle and marina',
        ),
        PortLocation(
          name: 'Rhodes',
          latitude: 36.4341,
          longitude: 28.2176,
          country: 'Greece',
          description: 'Medieval Old Town UNESCO site',
        ),
        PortLocation(
          name: 'Santorini',
          latitude: 36.3932,
          longitude: 25.4615,
          country: 'Greece',
          description: 'Iconic blue domes and sunsets',
        ),
        PortLocation(
          name: 'Athens',
          latitude: 37.9755,
          longitude: 23.7348,
          country: 'Greece',
          description: 'Return to Athens',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 5, 15), 12),
    description:
        'Explore Turkey\'s magnificent coastline and Greece\'s legendary islands on this unforgettable Mediterranean voyage.',
    highlights: [
      'Ancient Ephesus Archaeological Site',
      'Turkish Riviera Blue Lagoons',
      'Bodrum Castle & Marina',
      'Rhodes Medieval Old Town',
      'Santorini Sunset Views',
    ],
    bookingUrl: 'ncl://book/escape-turkish-riviera-001',
    imageUrl: 'assets/images/norwegian-escape-turkey.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Cyprus & Eastern Mediterranean - Norwegian Prima
  static final norwegianPrimaCyprusEasternMed = CruiseProduct(
    productId: 'prima-cyprus-eastern-med-001',
    title: '11-Day Cyprus & Eastern Mediterranean',
    shipName: 'Norwegian Prima',
    shipClass: 'Prima Class',
    capacity: 3215,
    duration: '11 days',
    route: const CruiseRoute(
      routeId: 'cyprus-eastern-med-001',
      title: 'Crossroads of Civilizations',
      description:
          'Journey through the cradle of civilization in the Eastern Mediterranean',
      region: 'Mediterranean',
      routeColor: Colors.deepOrange,
      waypoints: [
        PortLocation(
          name: 'Venice',
          latitude: 45.4408,
          longitude: 12.3155,
          country: 'Italy',
          description: 'Floating city of canals',
        ),
        PortLocation(
          name: 'Dubrovnik',
          latitude: 42.6507,
          longitude: 18.0944,
          country: 'Croatia',
          description: 'Pearl of the Adriatic',
        ),
        PortLocation(
          name: 'Istanbul',
          latitude: 41.0082,
          longitude: 28.9784,
          country: 'Turkey',
          description: 'Bridge between Europe and Asia',
        ),
        PortLocation(
          name: 'Limassol',
          latitude: 34.6851,
          longitude: 33.0254,
          country: 'Cyprus',
          description: 'Cyprus\'s cultural capital',
        ),
        PortLocation(
          name: 'Paphos',
          latitude: 34.7570,
          longitude: 32.4124,
          country: 'Cyprus',
          description: 'Aphrodite\'s legendary birthplace',
        ),
        PortLocation(
          name: 'Mykonos',
          latitude: 37.4467,
          longitude: 25.3289,
          country: 'Greece',
          description: 'Cosmopolitan island paradise',
        ),
        PortLocation(
          name: 'Kotor',
          latitude: 42.4247,
          longitude: 18.7712,
          country: 'Montenegro',
          description: 'Fjord-like bay UNESCO site',
        ),
        PortLocation(
          name: 'Venice',
          latitude: 45.4408,
          longitude: 12.3155,
          country: 'Italy',
          description: 'Return to Venice',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 2299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 6, 22), 8),
    description:
        'Discover the rich tapestry of Eastern Mediterranean cultures, from Byzantine Istanbul to mythical Cyprus.',
    highlights: [
      'Hagia Sophia & Blue Mosque',
      'Cyprus Wine Country Tours',
      'Paphos Archaeological Park',
      'Mykonos Windmills & Beaches',
      'Kotor\'s Medieval Architecture',
    ],
    bookingUrl: 'ncl://book/prima-cyprus-eastern-med-001',
    imageUrl: 'assets/images/norwegian-prima-cyprus.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Mediterranean & Greek Isles - Norwegian Epic (Real NCL Itinerary)
  static final norwegianEpicMediterranean = CruiseProduct(
    productId: 'epic-mediterranean-001',
    title: '10-Day Mediterranean & Greek Isles',
    shipName: 'Norwegian Epic',
    shipClass: 'Epic Class',
    capacity: 4100,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'mediterranean-greek-001',
      title: 'Mediterranean & Greek Isles',
      description: 'Explore the best of the Mediterranean and Greek Islands',
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
          name: 'Palma de Mallorca',
          latitude: 39.5696,
          longitude: 2.6502,
          country: 'Spain',
          description: 'Balearic Islands paradise',
        ),
        PortLocation(
          name: 'Valencia',
          latitude: 39.4699,
          longitude: -0.3763,
          country: 'Spain',
          description: 'City of Arts and Sciences',
        ),
        PortLocation(
          name: 'Malaga',
          latitude: 36.7213,
          longitude: -4.4214,
          country: 'Spain',
          description: 'Costa del Sol gateway',
        ),
        PortLocation(
          name: 'Gibraltar',
          latitude: 36.1408,
          longitude: -5.3536,
          country: 'UK',
          description: 'The Rock of Gibraltar',
        ),
        PortLocation(
          name: 'Cartagena',
          latitude: 37.6000,
          longitude: -0.9833,
          country: 'Spain',
          description: 'Ancient Roman heritage port',
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
    pricing: const PriceRange(startingPrice: 1899, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 5, 12), 16),
    description:
        'Experience the Mediterranean\'s most beautiful ports and the stunning Greek Isles aboard the innovative Norwegian Epic.',
    highlights: [
      'Gaudí\'s Sagrada Familia',
      'Balearic Islands Beaches',
      'Gibraltar\'s Rock',
      'Mediterranean Cuisine',
      'Ancient Roman Ruins',
    ],
    bookingUrl: 'ncl://book/epic-mediterranean-001',
    imageUrl: 'assets/images/norwegian-epic-mediterranean.jpg',
    zoomTier: CruiseZoomTier.essential, // Popular Mediterranean route
  );

  /// Portuguese Coast & Atlantic Islands - Norwegian Star
  static final norwegianStarPortugueseCoast = CruiseProduct(
    productId: 'star-portuguese-coast-001',
    title: '10-Day Portuguese Coast & Atlantic Islands',
    shipName: 'Norwegian Star',
    shipClass: 'Dawn Class',
    capacity: 2348,
    duration: '10 days',
    route: const CruiseRoute(
      routeId: 'portuguese-coast-001',
      title: 'Portuguese Heritage & Madeira',
      description: 'Explore Portugal\'s coast and Atlantic archipelagos',
      region: 'Mediterranean',
      routeColor: Colors.green,
      waypoints: [
        PortLocation(
          name: 'Lisbon',
          latitude: 38.7223,
          longitude: -9.1393,
          country: 'Portugal',
          description: 'Captivating capital of seven hills',
        ),
        PortLocation(
          name: 'Porto',
          latitude: 41.1579,
          longitude: -8.6291,
          country: 'Portugal',
          description: 'UNESCO World Heritage city',
        ),
        PortLocation(
          name: 'Vigo',
          latitude: 42.2406,
          longitude: -8.7207,
          country: 'Spain',
          description: 'Galician seafood capital',
        ),
        PortLocation(
          name: 'Funchal',
          latitude: 32.6669,
          longitude: -16.9241,
          country: 'Portugal',
          description: 'Madeira\'s flower island capital',
        ),
        PortLocation(
          name: 'Santa Cruz de Tenerife',
          latitude: 28.4636,
          longitude: -16.2518,
          country: 'Spain',
          description: 'Canary Islands volcanic paradise',
        ),
        PortLocation(
          name: 'Las Palmas',
          latitude: 28.1248,
          longitude: -15.4300,
          country: 'Spain',
          description: 'Gran Canaria cultural center',
        ),
        PortLocation(
          name: 'Cádiz',
          latitude: 36.5270,
          longitude: -6.2885,
          country: 'Spain',
          description: 'Ancient Phoenician trading port',
        ),
        PortLocation(
          name: 'Lisbon',
          latitude: 38.7223,
          longitude: -9.1393,
          country: 'Portugal',
          description: 'Return to Lisbon',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1599, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 8), 18),
    description:
        'Experience Portugal\'s rich maritime heritage and stunning Atlantic islands with their unique volcanic landscapes and cultural traditions.',
    highlights: [
      'Jerónimos Monastery Lisbon',
      'Port Wine Cellars Porto',
      'Madeira Wine Tastings',
      'Volcanic Landscapes',
      'Portuguese Azulejo Tiles',
    ],
    bookingUrl: 'ncl://book/star-portuguese-coast-001',
    imageUrl: 'assets/images/norwegian-star-portugal.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Portugal cruise
  );

  /// Canary Islands & Morocco - Norwegian Gem (Real NCL Itinerary)
  static final norwegianGemCanaryIslands = CruiseProduct(
    productId: 'gem-canary-islands-001',
    title: '9-Day Canary Islands & Morocco',
    shipName: 'Norwegian Gem',
    shipClass: 'Jewel Class',
    capacity: 2394,
    duration: '9 days',
    route: const CruiseRoute(
      routeId: 'canary-islands-001',
      title: 'Canary Islands & Morocco',
      description: 'Explore the volcanic Canary Islands and exotic Morocco',
      region: 'Mediterranean',
      routeColor: Colors.green,
      waypoints: [
        PortLocation(
          name: 'Barcelona',
          latitude: 41.3851,
          longitude: 2.1734,
          country: 'Spain',
          description: 'Mediterranean departure point',
        ),
        PortLocation(
          name: 'Malaga',
          latitude: 36.7213,
          longitude: -4.4214,
          country: 'Spain',
          description: 'Costa del Sol gateway',
        ),
        PortLocation(
          name: 'Casablanca',
          latitude: 33.5731,
          longitude: -7.5898,
          country: 'Morocco',
          description: 'Exotic Moroccan culture',
        ),
        PortLocation(
          name: 'Agadir',
          latitude: 30.4278,
          longitude: -9.5981,
          country: 'Morocco',
          description: 'Atlantic coast resort',
        ),
        PortLocation(
          name: 'Santa Cruz de Tenerife',
          latitude: 28.4636,
          longitude: -16.2518,
          country: 'Spain',
          description: 'Canary Islands volcanic paradise',
        ),
        PortLocation(
          name: 'Las Palmas',
          latitude: 28.1248,
          longitude: -15.4300,
          country: 'Spain',
          description: 'Gran Canaria cultural center',
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
    pricing: const PriceRange(startingPrice: 1299, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 6, 15), 20),
    description:
        'Discover the volcanic landscapes of the Canary Islands and the exotic culture of Morocco on this unforgettable journey.',
    highlights: [
      'Volcanic Landscapes',
      'Moroccan Souks',
      'Canary Island Beaches',
      'Exotic Culture',
      'Atlantic Ocean Views',
    ],
    bookingUrl: 'ncl://book/gem-canary-islands-001',
    imageUrl: 'assets/images/norwegian-gem-canary-islands.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// Canary Islands Volcanic Paradise - Norwegian Sun
  static final norwegianSunCanaryIslands = CruiseProduct(
    productId: 'sun-canary-islands-001',
    title: '9-Day Canary Islands Volcanic Paradise',
    shipName: 'Norwegian Sun',
    shipClass: 'Sun Class',
    capacity: 1936,
    duration: '9 days',
    route: const CruiseRoute(
      routeId: 'canary-islands-001',
      title: 'Spanish Atlantic Paradise',
      description: 'Explore Spain\'s volcanic Atlantic archipelago',
      region: 'Mediterranean',
      routeColor: Colors.orange,
      waypoints: [
        PortLocation(
          name: 'Las Palmas',
          latitude: 28.1248,
          longitude: -15.4300,
          country: 'Spain',
          description: 'Gran Canaria cultural capital',
        ),
        PortLocation(
          name: 'Santa Cruz de Tenerife',
          latitude: 28.4636,
          longitude: -16.2518,
          country: 'Spain',
          description: 'Teide National Park gateway',
        ),
        PortLocation(
          name: 'Santa Cruz de La Palma',
          latitude: 28.6835,
          longitude: -17.7640,
          country: 'Spain',
          description: 'La Isla Bonita beauty',
        ),
        PortLocation(
          name: 'San Sebastián de La Gomera',
          latitude: 28.0916,
          longitude: -17.1133,
          country: 'Spain',
          description: 'Columbus\' last stop',
        ),
        PortLocation(
          name: 'Puerto del Rosario',
          latitude: 28.5004,
          longitude: -13.8627,
          country: 'Spain',
          description: 'Fuerteventura dune landscapes',
        ),
        PortLocation(
          name: 'Arrecife',
          latitude: 28.9630,
          longitude: -13.5477,
          country: 'Spain',
          description: 'Lanzarote volcanic wonders',
        ),
        PortLocation(
          name: 'Funchal',
          latitude: 32.6669,
          longitude: -16.9241,
          country: 'Portugal',
          description: 'Madeira flower island',
        ),
        PortLocation(
          name: 'Las Palmas',
          latitude: 28.1248,
          longitude: -15.4300,
          country: 'Spain',
          description: 'Return to Las Palmas',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 1399, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 3, 20), 24),
    description:
        'Discover Spain\'s magnificent Canary Islands with their volcanic landscapes, unique ecosystems, and year-round perfect climate.',
    highlights: [
      'Mount Teide National Park',
      'Timanfaya Volcanic Landscapes',
      'Columbus\' Historic Route',
      'Unique Canarian Culture',
      'Year-Round Spring Climate',
    ],
    bookingUrl: 'ncl://book/sun-canary-islands-001',
    imageUrl: 'assets/images/norwegian-sun-canary.jpg',
    zoomTier: CruiseZoomTier.essential, // Featured Spanish islands cruise
  );

  /// Andalusian Coast Explorer - Norwegian Jade
  static final norwegianJadeAndalusia = CruiseProduct(
    productId: 'jade-andalusia-001',
    title: '7-Day Andalusian Coast Explorer',
    shipName: 'Norwegian Jade',
    shipClass: 'Jewel Class',
    capacity: 2402,
    duration: '7 days',
    route: const CruiseRoute(
      routeId: 'andalusian-coast-001',
      title: 'Moorish Spain & Flamenco',
      description: 'Experience the passion and history of Andalusia',
      region: 'Mediterranean',
      routeColor: Colors.amber,
      waypoints: [
        PortLocation(
          name: 'Málaga',
          latitude: 36.7213,
          longitude: -4.4214,
          country: 'Spain',
          description: 'Picasso\'s birthplace',
        ),
        PortLocation(
          name: 'Almería',
          latitude: 36.8414,
          longitude: -2.4637,
          country: 'Spain',
          description: 'Desert landscapes of Andalusia',
        ),
        PortLocation(
          name: 'Cartagena',
          latitude: 37.6000,
          longitude: -0.9833,
          country: 'Spain',
          description: 'Roman amphitheater ruins',
        ),
        PortLocation(
          name: 'Gibraltar',
          latitude: 36.1408,
          longitude: -5.3536,
          country: 'Gibraltar',
          description: 'Rock of Gibraltar & Barbary apes',
        ),
        PortLocation(
          name: 'Cádiz',
          latitude: 36.5270,
          longitude: -6.2885,
          country: 'Spain',
          description: 'Gateway to Jerez sherry country',
        ),
        PortLocation(
          name: 'Huelva',
          latitude: 37.2614,
          longitude: -6.9447,
          country: 'Spain',
          description: 'Columbus departure point',
        ),
        PortLocation(
          name: 'Málaga',
          latitude: 36.7213,
          longitude: -4.4214,
          country: 'Spain',
          description: 'Return to Málaga',
        ),
      ],
    ),
    pricing: const PriceRange(startingPrice: 999, cabinType: 'Interior'),
    departureDates: _generateDepartureDates(DateTime(2024, 4, 25), 26),
    description:
        'Immerse yourself in the passionate culture of Andalusia with its Moorish architecture, flamenco traditions, and stunning Mediterranean coastline.',
    highlights: [
      'Alhambra Palace Granada',
      'Authentic Flamenco Shows',
      'Jerez Sherry Tastings',
      'Picasso Museum Málaga',
      'Moorish Architecture',
    ],
    bookingUrl: 'ncl://book/jade-andalusia-001',
    imageUrl: 'assets/images/norwegian-jade-andalusia.jpg',
    zoomTier: CruiseZoomTier.medium,
  );

  /// All cruise products in the expanded catalog
  static final List<CruiseProduct> allCruises = [
    norwegianEpicCaribbean,
    norwegianBreakawayWestCaribbean,
    norwegianDawnMediterranean,
    norwegianStarGreekIsles,
    norwegianBlissAlaska,
    norwegianSunAlaskaDenali,
    norwegianSpiritHawaii,
    norwegianGemTransatlantic,
    norwegianStarNorwegianFjords,
    norwegianJewelSouthAfrica,
    norwegianPrimaMiddleEast,
    norwegianSkySoutheastAsia,
    norwegianJewelAustralia,
    norwegianStarAntarctica,
    norwegianSpiritChina,
    // New African & Asian Cruises
    norwegianJadeJapanKorea,
    norwegianSunIndonesia,
    norwegianStarIndiaSriLanka,
    norwegianGemEastAfrica,
    norwegianEscapeWestAfrica,
    norwegianSpiritPhilippinesVietnam,
    // South American Cruise
    norwegianPearlSouthAmerica,
    // Latin American Cruises
    norwegianBlissMexicanRiviera,
    norwegianPearlPanamaCanal,
    norwegianEncoreCentralAmerica,
    norwegianStarSouthAmericanCapitals,
    // New California & Baja California Cruises
    norwegianBlissCaliforniaCoast,
    norwegianGemBajaCalifornia,
    // More Latin America & South America Cruises
    norwegianSunChileanFjords,
    norwegianEpicBrazilianAmazon,
    // More West Africa Cruises
    norwegianStarWestAfricanCoast,
    // More Antarctica Cruises
    norwegianGemAntarcticCircle,
    // Miami-Based Cruises
    norwegianGetawaySouthernCaribbean,
    norwegianGemWestCaribbean,
    norwegianSkyBahamas,
    norwegianBreakawayBermuda,
    norwegianEncoreExtendedCaribbean,
    // Turkey & Cyprus Cruises
    norwegianEscapeTurkishRiviera,
    norwegianPrimaCyprusEasternMed,
    // Spain & Portugal Cruises
    norwegianEpicMediterranean,
    norwegianStarPortugueseCoast,
    norwegianGemCanaryIslands,
    norwegianSunCanaryIslands,
    norwegianJadeAndalusia,
  ];

  /// Get cruises by category/region
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

  /// Search cruises by various criteria
  static List<CruiseProduct> searchCruises({
    String? query,
    List<String>? regions,
    int? minDuration,
    int? maxDuration,
    double? maxPrice,
  }) {
    var filtered = allCruises.where((cruise) {
      // Text search
      if (query != null && query.isNotEmpty) {
        final searchText = query.toLowerCase();
        if (!cruise.title.toLowerCase().contains(searchText) &&
            !cruise.shipName.toLowerCase().contains(searchText) &&
            !(cruise.route.region?.toLowerCase().contains(searchText) ??
                false) &&
            !cruise.route.waypoints.any(
              (port) =>
                  port.name.toLowerCase().contains(searchText) ||
                  (port.country?.toLowerCase().contains(searchText) ?? false),
            )) {
          return false;
        }
      }

      // Region filter
      if (regions != null && regions.isNotEmpty) {
        if (!regions
            .map((r) => r.toLowerCase())
            .contains(cruise.route.region?.toLowerCase() ?? '')) {
          return false;
        }
      }

      // Duration filter
      final durationDays = int.tryParse(cruise.duration.split(' ').first);
      if (durationDays != null) {
        if (minDuration != null && durationDays < minDuration) return false;
        if (maxDuration != null && durationDays > maxDuration) return false;
      }

      // Price filter
      if (maxPrice != null && cruise.pricing.startingPrice > maxPrice) {
        return false;
      }

      return true;
    });

    return filtered.toList();
  }

  /// Get featured/popular cruises - representing every continent and major region
  static List<CruiseProduct> getFeaturedCruises() {
    return [
      // North America & Caribbean
      norwegianEpicCaribbean, // Caribbean
      norwegianSkyBahamas, // Quick Caribbean getaway
      norwegianBlissAlaska, // Alaska
      norwegianSpiritHawaii, // Hawaii/Pacific Islands
      norwegianBlissCaliforniaCoast, // California Coast
      // Europe & Mediterranean
      norwegianDawnMediterranean, // Mediterranean
      // Asia
      norwegianJadeJapanKorea, // Japan & Korea Discovery
      norwegianSkySoutheastAsia, // Southeast Asia
      // Africa
      norwegianGemEastAfrica, // East Africa Safari & Spices
      norwegianEscapeWestAfrica, // West Africa & Morocco
      // Australia & Oceania
      norwegianJewelAustralia, // Australia & New Zealand
      // South America
      norwegianPearlSouthAmerica, // Brazilian Coast & Chilean Fjords
      // Latin America
      norwegianBlissMexicanRiviera, // Mexican Riviera Paradise
      // Antarctica
      norwegianStarAntarctica, // Antarctica Expedition
    ];
  }

  /// Get all available regions
  static List<String> getAvailableRegions() {
    final regions =
        allCruises
            .map((cruise) => cruise.route.region)
            .where((region) => region != null)
            .cast<String>()
            .toSet()
            .toList();
    regions.sort();
    return regions;
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
