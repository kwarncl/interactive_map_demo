import 'package:flutter/material.dart';

import 'models/deck_polygon_data.dart';

/// SVG-based polygon provider for Deck 8 using extracted path data
class Deck8SvgPolygonProvider implements DeckPolygonDataProvider {
  static const String shipClass = 'deck_8_svg';

  @override
  List<DeckPolygonArea> getPolygonAreas(String shipClass, int deckNumber) {
    if (shipClass != Deck8SvgPolygonProvider.shipClass) {
      return [];
    }

    switch (deckNumber) {
      case 8:
        return _deck8SvgAreas;
      default:
        return [];
    }
  }

  @override
  bool hasPolygonData(String shipClass, int deckNumber) {
    return getPolygonAreas(shipClass, deckNumber).isNotEmpty;
  }

  @override
  List<int> getAvailableDecks(String shipClass) {
    if (shipClass != Deck8SvgPolygonProvider.shipClass) {
      return [];
    }
    return [8]; // Only deck 8 has SVG polygon data
  }

  /// Convert SVG coordinates to normalized coordinates (0.0-1.0)
  /// SVG viewBox: "0 0 42000 59400" (width: 42000, height: 59400)
  static Offset _svgToNormalized(double x, double y) {
    return Offset(x / 42000.0, y / 59400.0);
  }

  /// Deck 8 SVG-based polygon areas extracted from the new deck plan
  static final List<DeckPolygonArea> _deck8SvgAreas = [
    // Main Aqua Theater area - large white polygon
    DeckPolygonArea(
      id: 'aqua_theater',
      title: 'Aqua Theater & Club',
      description:
          'World-class aqua theater with stunning performances and club area',
      category: 'entertainment',
      color: Colors.blue,
      polygon: [
        _svgToNormalized(17018, 4803.8),
        _svgToNormalized(25241, 4803.8),
        _svgToNormalized(25241, 25088),
        _svgToNormalized(17018, 25088),
      ],
    ),

    // Central deck area - main white polygon
    DeckPolygonArea(
      id: 'central_deck_area',
      title: 'Central Deck Area',
      description: 'Main deck area with walkways and central facilities',
      category: 'deck',
      color: Colors.grey,
      polygon: [
        _svgToNormalized(16906, 21493),
        _svgToNormalized(25205, 21407),
        _svgToNormalized(25219, 25024),
        _svgToNormalized(17750, 25882),
        _svgToNormalized(16910, 24972),
      ],
    ),

    // Main lower deck - large white area
    DeckPolygonArea(
      id: 'main_lower_deck',
      title: 'Main Lower Deck',
      description: 'Lower deck area with dining and entertainment venues',
      category: 'deck',
      color: Colors.blueGrey,
      polygon: [
        _svgToNormalized(17750, 25882),
        _svgToNormalized(24305, 25882),
        _svgToNormalized(24306, 37252),
        _svgToNormalized(18981, 38268),
        _svgToNormalized(17750, 37219),
      ],
    ),

    // Indulge Food Hall - large orange area at bottom
    DeckPolygonArea(
      id: 'indulge_food_hall',
      title: 'Indulge Food Hall',
      description:
          'Open-air marketplace with diverse international food vendors',
      category: 'dining',
      color: Colors.orange,
      polygon: [
        _svgToNormalized(18892, 38192),
        _svgToNormalized(23174, 38192),
        _svgToNormalized(24040, 51214),
        _svgToNormalized(17998, 51214),
      ],
    ),

    // Restaurant sections - blue dining areas
    DeckPolygonArea(
      id: 'dining_area_central',
      title: 'Main Dining Area',
      description: 'Central dining venues with multiple restaurant options',
      category: 'dining',
      color: Colors.deepOrange,
      polygon: [
        _svgToNormalized(19436, 11306),
        _svgToNormalized(22701, 11306),
        _svgToNormalized(22701, 17381),
        _svgToNormalized(19436, 17381),
      ],
    ),

    // Belverde Bar - pink area on left
    DeckPolygonArea(
      id: 'belverde_bar',
      title: 'Belverde Bar',
      description: 'Elegant bar with premium spirits and cocktails',
      category: 'bar',
      color: Colors.pink,
      polygon: [
        _svgToNormalized(17758, 25907),
        _svgToNormalized(18940, 25907),
        _svgToNormalized(18937, 33016),
        _svgToNormalized(17758, 33016),
      ],
    ),

    // Restaurant area - orange section on right
    DeckPolygonArea(
      id: 'specialty_restaurant',
      title: 'Specialty Restaurant',
      description: 'Premium dining venue with specialty cuisine',
      category: 'dining',
      color: Colors.amber,
      polygon: [
        _svgToNormalized(22887, 25937),
        _svgToNormalized(24295, 25937),
        _svgToNormalized(24295, 37173),
        _svgToNormalized(22887, 37173),
      ],
    ),

    // Ocean Boulevard sections - side deck areas
    DeckPolygonArea(
      id: 'oceanwalk_port',
      title: 'Ocean Walk (Port)',
      description: 'Spectacular outdoor promenade on the port side',
      category: 'deck',
      color: Colors.cyan,
      polygon: [
        _svgToNormalized(16345, 45065),
        _svgToNormalized(17581, 45065),
        _svgToNormalized(17581, 47101),
        _svgToNormalized(16345, 47101),
      ],
    ),

    DeckPolygonArea(
      id: 'oceanwalk_starboard',
      title: 'Ocean Walk (Starboard)',
      description: 'Spectacular outdoor promenade on the starboard side',
      category: 'deck',
      color: Colors.cyan,
      polygon: [
        _svgToNormalized(24393, 45065),
        _svgToNormalized(25629, 45065),
        _svgToNormalized(25629, 47101),
        _svgToNormalized(24393, 47101),
      ],
    ),

    // Shops & Boutiques areas
    DeckPolygonArea(
      id: 'shops_boutiques',
      title: 'Shops & Boutiques',
      description: 'Shopping area with boutiques and retail stores',
      category: 'shopping',
      color: Colors.purple,
      polygon: [
        _svgToNormalized(21507, 24696),
        _svgToNormalized(23227, 24696),
        _svgToNormalized(23227, 26878),
        _svgToNormalized(21507, 26878),
      ],
    ),

    // The Haven Private Elevators
    DeckPolygonArea(
      id: 'haven_private_elevators',
      title: 'The Haven Private Elevators',
      description: 'Exclusive elevator access for Haven suite guests',
      category: 'amenity',
      color: Colors.deepPurple,
      polygon: [
        _svgToNormalized(20529, 45182),
        _svgToNormalized(21576, 45182),
        _svgToNormalized(21576, 46495),
        _svgToNormalized(20529, 46495),
      ],
    ),

    // Penrose Atrium
    DeckPolygonArea(
      id: 'penrose_atrium',
      title: 'Penrose Atrium',
      description: 'Beautiful multi-story atrium with stunning architecture',
      category: 'amenity',
      color: Colors.lightBlue,
      polygon: [
        _svgToNormalized(18026, 26162),
        _svgToNormalized(21182, 26162),
        _svgToNormalized(21182, 28490),
        _svgToNormalized(18026, 28490),
      ],
    ),

    // Onda by Scarpetta - restaurant areas
    DeckPolygonArea(
      id: 'onda_scarpetta',
      title: 'Onda by Scarpetta',
      description: 'Premium Italian restaurant on Ocean Boulevard',
      category: 'dining',
      color: Colors.red,
      polygon: [
        _svgToNormalized(17742, 33593),
        _svgToNormalized(19302, 33593),
        _svgToNormalized(19302, 37163),
        _svgToNormalized(17742, 37163),
      ],
    ),

    // Los Lobos restaurant
    DeckPolygonArea(
      id: 'los_lobos',
      title: 'Los Lobos',
      description: 'Mexican-inspired specialty restaurant',
      category: 'dining',
      color: Colors.deepOrange,
      polygon: [
        _svgToNormalized(21514, 50628),
        _svgToNormalized(23147, 50628),
        _svgToNormalized(23147, 51745),
        _svgToNormalized(21514, 51745),
      ],
    ),

    // Perspectives Studio
    DeckPolygonArea(
      id: 'perspectives_studio',
      title: 'Perspectives Studio',
      description: 'Photography studio for professional portraits',
      category: 'amenity',
      color: Colors.purple,
      polygon: [
        _svgToNormalized(21571, 41033),
        _svgToNormalized(22253, 41033),
        _svgToNormalized(22253, 42419),
        _svgToNormalized(21571, 42419),
      ],
    ),

    // Restroom areas - small utility spaces
    DeckPolygonArea(
      id: 'restrooms_port',
      title: 'Restrooms (Port)',
      description: 'Restroom facilities on the port side',
      category: 'amenity',
      color: Colors.grey.shade400,
      polygon: [
        _svgToNormalized(19380, 19599),
        _svgToNormalized(19921, 19599),
        _svgToNormalized(19921, 20698),
        _svgToNormalized(19380, 20698),
      ],
    ),

    DeckPolygonArea(
      id: 'restrooms_starboard',
      title: 'Restrooms (Starboard)',
      description: 'Restroom facilities on the starboard side',
      category: 'amenity',
      color: Colors.grey.shade400,
      polygon: [
        _svgToNormalized(22149, 19599),
        _svgToNormalized(22691, 19599),
        _svgToNormalized(22691, 20698),
        _svgToNormalized(22149, 20698),
      ],
    ),

    // Additional restaurant and retail areas from SVG
    DeckPolygonArea(
      id: 'concourse_area',
      title: 'The Concourse',
      description: 'Open gathering area with seating and ocean views',
      category: 'amenity',
      color: Colors.brown,
      polygon: [
        _svgToNormalized(21580, 38786),
        _svgToNormalized(23163, 38786),
        _svgToNormalized(23163, 46659),
        _svgToNormalized(21580, 46659),
      ],
    ),

    // Photo Gallery
    DeckPolygonArea(
      id: 'photo_gallery',
      title: 'Photo Gallery',
      description: 'Professional photo services and portrait gallery',
      category: 'amenity',
      color: Colors.indigo,
      polygon: [
        _svgToNormalized(22142, 38195),
        _svgToNormalized(23163, 38195),
        _svgToNormalized(23163, 38786),
        _svgToNormalized(22142, 38786),
      ],
    ),

    // Luna Bar
    DeckPolygonArea(
      id: 'luna_bar',
      title: 'Luna Bar',
      description: 'Specialty bar within the Indulge Food Hall',
      category: 'bar',
      color: Colors.purple.shade300,
      polygon: [
        _svgToNormalized(20380, 51144),
        _svgToNormalized(21687, 51144),
        _svgToNormalized(21687, 51385),
        _svgToNormalized(20380, 51385),
      ],
    ),

    // Soleil Bar
    DeckPolygonArea(
      id: 'soleil_bar',
      title: 'Soleil Bar',
      description: 'Outdoor bar at the aft with stunning ocean views',
      category: 'bar',
      color: Colors.amber.shade300,
      polygon: [
        _svgToNormalized(19835, 50622),
        _svgToNormalized(20473, 50622),
        _svgToNormalized(20473, 51322),
        _svgToNormalized(19835, 51322),
      ],
    ),
  ];
}
