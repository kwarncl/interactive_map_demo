import 'package:flutter/material.dart';

import '../../interactive_map/models/interactive_map_marker_data.dart';

/// Deck information for Norwegian Aqua ship
class ShipDeckInfo {
  const ShipDeckInfo({
    required this.deckNumber,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.markers,
    required this.primaryColor,
  });

  final int deckNumber;
  final String name;
  final String description;
  final String imageUrl;
  final List<InteractiveMapMarkerData> markers;
  final Color primaryColor;

  /// Gets the formatted deck number with leading zero if needed
  String get formattedDeckNumber => deckNumber.toString().padLeft(2, '0');
}

/// Comprehensive data for all Norwegian Aqua decks
class NorwegianAquaDecks {
  /// Base URL pattern for NCL deck plan images
  static const String _baseImageUrl =
      'https://www.ncl.com/content/dam/ncl/us/en/ships/norwegian-aqua/deck-plans/Aqua-Deck-';
  static const String _imageUrlSuffix = '-061825.png';

  /// Generates the complete image URL for a given deck number
  static String _getImageUrl(int deckNumber) {
    final String formattedNumber = deckNumber.toString().padLeft(2, '0');
    return '$_baseImageUrl$formattedNumber$_imageUrlSuffix';
  }

  /// All Norwegian Aqua deck data
  static final List<ShipDeckInfo> allDecks = [
    ShipDeckInfo(
      deckNumber: 5,
      name: 'Deck 5 - Cabins',
      description:
          'Guest staterooms and interior cabins with oceanview options',
      imageUrl: _getImageUrl(5),
      primaryColor: Colors.blue.shade300,
      markers: _deck5Markers,
    ),
    ShipDeckInfo(
      deckNumber: 6,
      name: 'Deck 6 - Casino & Shops',
      description:
          '3-level atrium base, casino, retail shops, and guest services',
      imageUrl: _getImageUrl(6),
      primaryColor: Colors.purple.shade400,
      markers: _deck6Markers,
    ),
    ShipDeckInfo(
      deckNumber: 7,
      name: 'Deck 7 - Lobby & Restaurants',
      description:
          'Main atrium level with specialty dining, bars, and entertainment venues',
      imageUrl: _getImageUrl(7),
      primaryColor: Colors.orange.shade400,
      markers: _deck7Markers,
    ),
    ShipDeckInfo(
      deckNumber: 8,
      name: 'Deck 8 - Ocean Boulevard',
      description:
          '360° promenade with pools, dining, Ocean Walk, and outdoor spaces',
      imageUrl: _getImageUrl(8),
      primaryColor: Colors.cyan.shade400,
      markers: _deck8Markers,
    ),
    ShipDeckInfo(
      deckNumber: 9,
      name: 'Deck 9 - Staterooms',
      description: 'Balcony staterooms and suites with ocean views',
      imageUrl: _getImageUrl(9),
      primaryColor: Colors.green.shade300,
      markers: _deck9Markers,
    ),
    ShipDeckInfo(
      deckNumber: 10,
      name: 'Deck 10 - Staterooms',
      description: 'Mix of balcony staterooms and Haven suites',
      imageUrl: _getImageUrl(10),
      primaryColor: Colors.green.shade400,
      markers: _deck10Markers,
    ),
    ShipDeckInfo(
      deckNumber: 11,
      name: 'Deck 11 - Staterooms',
      description: 'Balcony staterooms and club-level accommodations',
      imageUrl: _getImageUrl(11),
      primaryColor: Colors.green.shade500,
      markers: _deck11Markers,
    ),
    ShipDeckInfo(
      deckNumber: 12,
      name: 'Deck 12 - Studios & Hospital',
      description: 'Solo traveler studios, staterooms, and medical center',
      imageUrl: _getImageUrl(12),
      primaryColor: Colors.teal.shade400,
      markers: _deck12Markers,
    ),
    ShipDeckInfo(
      deckNumber: 13,
      name: 'Deck 13 - Studios & Suites',
      description: 'More solo studios and premium staterooms',
      imageUrl: _getImageUrl(13),
      primaryColor: Colors.teal.shade500,
      markers: _deck13Markers,
    ),
    ShipDeckInfo(
      deckNumber: 14,
      name: 'Deck 14 - Bridge & Cabins',
      description: 'Ship\'s bridge, officer quarters, and premium staterooms',
      imageUrl: _getImageUrl(14),
      primaryColor: Colors.indigo.shade400,
      markers: _deck14Markers,
    ),
    ShipDeckInfo(
      deckNumber: 15,
      name: 'Deck 15 - Premium Staterooms',
      description: 'High-end staterooms and Haven access levels',
      imageUrl: _getImageUrl(15),
      primaryColor: Colors.indigo.shade500,
      markers: _deck15Markers,
    ),
    ShipDeckInfo(
      deckNumber: 16,
      name: 'Deck 16 - The Haven & Pool',
      description: 'Haven suites, exclusive pool area, and sundeck',
      imageUrl: _getImageUrl(16),
      primaryColor: Colors.amber.shade600,
      markers: _deck16Markers,
    ),
    ShipDeckInfo(
      deckNumber: 17,
      name: 'Deck 17 - Haven & Observation',
      description:
          'The Haven level 2, observation lounge, pools, and exclusive areas',
      imageUrl: _getImageUrl(17),
      primaryColor: Colors.amber.shade700,
      markers: _deck17Markers,
    ),
    ShipDeckInfo(
      deckNumber: 18,
      name: 'Deck 18 - Aqua Park',
      description:
          'Waterpark level 1 with slides, pools, and water attractions',
      imageUrl: _getImageUrl(18),
      primaryColor: Colors.blue.shade600,
      markers: _deck18Markers,
    ),
    ShipDeckInfo(
      deckNumber: 19,
      name: 'Deck 19 - Aqua Park Upper',
      description: 'Waterpark level 2 with slide coaster and sundeck',
      imageUrl: _getImageUrl(19),
      primaryColor: Colors.blue.shade700,
      markers: _deck19Markers,
    ),
    ShipDeckInfo(
      deckNumber: 20,
      name: 'Deck 20 - Sports & Recreation',
      description:
          'Top deck with slide coaster finale, Glow Court, and sports facilities',
      imageUrl: _getImageUrl(20),
      primaryColor: Colors.blue.shade800,
      markers: _deck20Markers,
    ),
  ];

  /// Gets deck info by deck number
  static ShipDeckInfo? getDeckByNumber(int deckNumber) {
    try {
      return allDecks.firstWhere((deck) => deck.deckNumber == deckNumber);
    } catch (e) {
      return null;
    }
  }

  /// Deck 5 Markers - Guest Cabins
  static const List<InteractiveMapMarkerData> _deck5Markers = [
    InteractiveMapMarkerData(
      id: 'guest_services_5',
      position: Offset(0.5, 0.4),
      title: 'Guest Information',
      description:
          'Information desk for cabin services, housekeeping requests, and general assistance.',
      icon: Icons.info,
      color: Colors.blue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'elevator_lobby_5',
      position: Offset(0.5, 0.6),
      title: 'Elevator Lobby',
      description:
          'Main elevator access for convenient deck-to-deck transportation.',
      icon: Icons.elevator,
      color: Colors.grey,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 6 Markers - Casino & Shops
  static const List<InteractiveMapMarkerData> _deck6Markers = [
    InteractiveMapMarkerData(
      id: 'casino_main',
      position: Offset(0.6, 0.4),
      title: 'Primo Casino & Lounge',
      description:
          'Full-service casino with slot machines, table games, poker, and casino bar. Atrium level 1.',
      icon: Icons.casino,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'retail_shops_6',
      position: Offset(0.3, 0.5),
      title: 'Retail Shops',
      description:
          'Duty-free shopping with jewelry, souvenirs, clothing, and cruise essentials.',
      icon: Icons.shopping_bag,
      color: Colors.purple,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'atrium_level1',
      position: Offset(0.5, 0.3),
      title: 'Atrium Level 1',
      description:
          'Base of the stunning 3-level glass atrium with crystal chandelier and artwork.',
      icon: Icons.location_city,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'guest_services_main',
      position: Offset(0.4, 0.6),
      title: 'Guest Services Desk',
      description:
          'Main guest services for excursions, dining reservations, and cruise information.',
      icon: Icons.help_center,
      color: Colors.teal,
      zoomTier: ZoomTier.essential,
    ),
  ];

  /// Deck 7 Markers - Lobby & Restaurants
  static const List<InteractiveMapMarkerData> _deck7Markers = [
    InteractiveMapMarkerData(
      id: 'main_dining_room_7',
      position: Offset(0.3, 0.3),
      title: 'Aqua Main Dining Room',
      description:
          'Primary dining venue with rotating menus featuring international cuisine and formal dining.',
      icon: Icons.restaurant,
      color: Colors.orange,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'specialty_dining_7',
      position: Offset(0.7, 0.4),
      title: 'Specialty Restaurant',
      description:
          'Premium dining venues including Italian, Asian, and steakhouse options.',
      icon: Icons.restaurant_menu,
      color: Colors.red,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'whiskey_bar',
      position: Offset(0.6, 0.6),
      title: 'Whiskey Bar',
      description:
          'Premium whiskey and spirits bar in the atrium level 2 with extensive selection.',
      icon: Icons.local_bar,
      color: Colors.brown,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'atrium_level2',
      position: Offset(0.5, 0.3),
      title: 'Atrium Level 2',
      description: 'Middle level of the 3-story atrium with shopping and bars.',
      icon: Icons.location_city,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'starbucks_7',
      position: Offset(0.4, 0.7),
      title: 'Starbucks Coffee',
      description:
          'Familiar coffee shop with premium coffee, pastries, and light snacks.',
      icon: Icons.coffee,
      color: Colors.green,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 8 Markers - Ocean Boulevard (Main Promenade)
  /// Positioned to overlay existing facility text on the deck plan image
  static const List<InteractiveMapMarkerData> _deck8Markers = [
    // The Local Bar & Grill text overlays (port and starboard)
    InteractiveMapMarkerData(
      id: 'local_bar_grill_port',
      position: Offset(0.20, 0.16),
      title: 'The Local Bar & Grill',
      description: 'Casual dining and bar with ocean views on the port side.',
      icon: Icons.restaurant,
      color: Colors.red,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'local_bar_grill_starboard',
      position: Offset(0.80, 0.16),
      title: 'The Local Bar & Grill',
      description:
          'Casual dining and bar with ocean views on the starboard side.',
      icon: Icons.restaurant,
      color: Colors.red,
      zoomTier: ZoomTier.essential,
    ),
    // Bar area (light blue section)
    InteractiveMapMarkerData(
      id: 'bar_area',
      position: Offset(0.82, 0.25),
      title: 'Bar',
      description: 'Full-service bar with premium cocktails and spirits.',
      icon: Icons.local_bar,
      color: Colors.lightBlue,
      zoomTier: ZoomTier.essential,
    ),
    // Infinity Beach areas (light blue on sides)
    InteractiveMapMarkerData(
      id: 'infinity_beach_port',
      position: Offset(0.12, 0.55),
      title: 'Infinity Beach',
      description: 'Outdoor beach area with ocean views on the port side.',
      icon: Icons.beach_access,
      color: Colors.lightBlue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'infinity_beach_starboard',
      position: Offset(0.88, 0.55),
      title: 'Infinity Beach',
      description: 'Outdoor beach area with ocean views on the starboard side.',
      icon: Icons.beach_access,
      color: Colors.lightBlue,
      zoomTier: ZoomTier.essential,
    ),
    // Indulge Food Hall (large orange area)
    InteractiveMapMarkerData(
      id: 'indulge_food_hall',
      position: Offset(0.50, 0.80),
      title: 'Indulge Food Hall',
      description:
          'NCL\'s first open-air marketplace with diverse international food vendors.',
      icon: Icons.restaurant,
      color: Colors.orange,
      zoomTier: ZoomTier.essential,
    ),
    // Luna Bar (inside food hall)
    InteractiveMapMarkerData(
      id: 'luna_bar',
      position: Offset(0.50, 0.87),
      title: 'Luna Bar',
      description:
          'Specialty bar located within the Indulge Food Hall offering craft cocktails.',
      icon: Icons.local_bar,
      color: Colors.purple,
      zoomTier: ZoomTier.medium,
    ),
    // Soleil Bar (at bottom)
    InteractiveMapMarkerData(
      id: 'soleil_bar',
      position: Offset(0.50, 0.93),
      title: 'Soleil Bar',
      description:
          'Outdoor bar at the aft with stunning ocean views and tropical drinks.',
      icon: Icons.local_bar,
      color: Colors.amber,
      zoomTier: ZoomTier.medium,
    ),
    // Indulge Outdoor Lounge (curved areas around food hall)
    InteractiveMapMarkerData(
      id: 'indulge_outdoor_lounge_port',
      position: Offset(0.18, 0.84),
      title: 'Indulge Outdoor Lounge',
      description:
          'Open-air seating area around the stern section with ocean views.',
      icon: Icons.deck,
      color: Colors.brown,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'indulge_outdoor_lounge_starboard',
      position: Offset(0.82, 0.84),
      title: 'Indulge Outdoor Lounge',
      description:
          'Open-air seating area around the stern section with ocean views.',
      icon: Icons.deck,
      color: Colors.brown,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'atrium_level3',
      position: Offset(0.50, 0.65),
      title: 'Atrium Level 3',
      description:
          'Top level of the 3-story atrium with panoramic views and Penrose Bar.',
      icon: Icons.location_city,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    // Additional facilities visible on deck plan
    InteractiveMapMarkerData(
      id: 'drop_landing_port',
      position: Offset(0.12, 0.25),
      title: 'The Drop Landing',
      description: 'Thrilling drop slide experience with ocean views.',
      icon: Icons.pool,
      color: Colors.blue,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'ocean_boulevard_port',
      position: Offset(0.25, 0.30),
      title: 'Ocean Boulevard',
      description: 'Spectacular outdoor promenade wrapping around the ship.',
      icon: Icons.directions_walk,
      color: Colors.teal,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'ocean_boulevard_starboard',
      position: Offset(0.75, 0.30),
      title: 'Ocean Boulevard',
      description: 'Spectacular outdoor promenade wrapping around the ship.',
      icon: Icons.directions_walk,
      color: Colors.teal,
      zoomTier: ZoomTier.medium,
    ),
    // Restroom facilities
    InteractiveMapMarkerData(
      id: 'restrooms_port_upper',
      position: Offset(0.23, 0.25),
      title: 'RR',
      description: 'Restroom facilities on the port side.',
      icon: Icons.wc,
      color: Colors.grey,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'restrooms_starboard_upper',
      position: Offset(0.77, 0.25),
      title: 'RR',
      description: 'Restroom facilities on the starboard side.',
      icon: Icons.wc,
      color: Colors.grey,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'restrooms_center_upper',
      position: Offset(0.55, 0.32),
      title: 'RR',
      description: 'Central restroom facilities.',
      icon: Icons.wc,
      color: Colors.grey,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'restrooms_center_lower',
      position: Offset(0.50, 0.42),
      title: 'RR',
      description: 'Central restroom facilities near elevators.',
      icon: Icons.wc,
      color: Colors.grey,
      zoomTier: ZoomTier.detailed,
    ),
    // The Haven Private Elevators
    InteractiveMapMarkerData(
      id: 'haven_private_elevators',
      position: Offset(0.45, 0.58),
      title: 'The Haven Private Elevators',
      description: 'Exclusive elevator access for Haven suite guests.',
      icon: Icons.elevator,
      color: Colors.deepPurple,
      zoomTier: ZoomTier.medium,
    ),
    // Additional deck areas
    InteractiveMapMarkerData(
      id: 'deck_central_area',
      position: Offset(0.50, 0.45),
      title: 'Central Deck Area',
      description: 'Open deck space with seating and ocean views.',
      icon: Icons.deck,
      color: Colors.green,
      zoomTier: ZoomTier.detailed,
    ),
    // Top section facilities
    InteractiveMapMarkerData(
      id: 'aqua_theater_club',
      position: Offset(0.50, 0.15),
      title: 'Aqua Theater & Club',
      description: 'Stunning aqua theater with performances and club area.',
      icon: Icons.theater_comedy,
      color: Colors.blue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'shops_boutiques_upper',
      position: Offset(0.75, 0.20),
      title: 'Shops & Boutiques',
      description: 'Shopping area with boutiques and retail stores.',
      icon: Icons.shopping_bag,
      color: Colors.pink,
      zoomTier: ZoomTier.medium,
    ),
    // Middle section facilities
    InteractiveMapMarkerData(
      id: 'perspectives_studio',
      position: Offset(0.35, 0.45),
      title: 'Perspectives Studio',
      description: 'Photography studio for professional portraits.',
      icon: Icons.camera_alt,
      color: Colors.purple,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'shops_boutiques_right',
      position: Offset(0.85, 0.50),
      title: 'Shops & Boutiques',
      description: 'Additional shopping area with specialty stores.',
      icon: Icons.shopping_bag,
      color: Colors.pink,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'the_concourse',
      position: Offset(0.85, 0.60),
      title: 'The Concourse',
      description: 'Open gathering area with seating and ocean views.',
      icon: Icons.deck,
      color: Colors.brown,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'penrose_atrium',
      position: Offset(0.35, 0.60),
      title: 'Penrose Atrium',
      description: 'Beautiful multi-story atrium with stunning architecture.',
      icon: Icons.account_balance,
      color: Colors.lightBlue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'belvedere_bar',
      position: Offset(0.20, 0.60),
      title: 'Belvedere Bar',
      description: 'Elegant bar with premium spirits and cocktails.',
      icon: Icons.local_bar,
      color: Colors.lightBlue,
      zoomTier: ZoomTier.essential,
    ),
    // Deck terraces
    InteractiveMapMarkerData(
      id: 'la_terrazza_port',
      position: Offset(0.08, 0.35),
      title: 'La Terrazza',
      description: 'Outdoor terrace area with scenic ocean views.',
      icon: Icons.deck,
      color: Colors.brown,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'la_terrazza_starboard',
      position: Offset(0.92, 0.35),
      title: 'La Terrazza',
      description: 'Outdoor terrace area with scenic ocean views.',
      icon: Icons.deck,
      color: Colors.brown,
      zoomTier: ZoomTier.medium,
    ),
    // Walkways and outdoor areas
    InteractiveMapMarkerData(
      id: 'oceanwalk_port',
      position: Offset(0.08, 0.65),
      title: 'Oceanwalk',
      description: 'Stunning walkway along the ship\'s edge with ocean views.',
      icon: Icons.directions_walk,
      color: Colors.teal,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'oceanwalk_starboard',
      position: Offset(0.92, 0.65),
      title: 'Oceanwalk',
      description: 'Stunning walkway along the ship\'s edge with ocean views.',
      icon: Icons.directions_walk,
      color: Colors.teal,
      zoomTier: ZoomTier.medium,
    ),
    // Gallery area
    InteractiveMapMarkerData(
      id: 'art_gallery',
      position: Offset(0.75, 0.45),
      title: 'Art Gallery',
      description: 'Fine art gallery featuring paintings and sculptures.',
      icon: Icons.palette,
      color: Colors.orange,
      zoomTier: ZoomTier.medium,
    ),
    // Los Lobos areas
    InteractiveMapMarkerData(
      id: 'los_lobos_port',
      position: Offset(0.12, 0.75),
      title: 'Los Lobos',
      description: 'Specialty dining area with Mexican-inspired cuisine.',
      icon: Icons.restaurant,
      color: Colors.orange,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'los_lobos_starboard',
      position: Offset(0.88, 0.75),
      title: 'Los Lobos',
      description: 'Specialty dining area with Mexican-inspired cuisine.',
      icon: Icons.restaurant,
      color: Colors.orange,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 9 Markers - Staterooms
  static const List<InteractiveMapMarkerData> _deck9Markers = [
    InteractiveMapMarkerData(
      id: 'balcony_staterooms_9',
      position: Offset(0.3, 0.4),
      title: 'Balcony Staterooms',
      description:
          'Premium oceanview staterooms with private balconies and modern amenities.',
      icon: Icons.hotel,
      color: Colors.blue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'suite_level_9',
      position: Offset(0.7, 0.5),
      title: 'Junior Suites',
      description:
          'Spacious suite accommodations with separate living areas and enhanced services.',
      icon: Icons.king_bed,
      color: Colors.purple,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 10 Markers - Staterooms & Haven Access
  static const List<InteractiveMapMarkerData> _deck10Markers = [
    InteractiveMapMarkerData(
      id: 'haven_suites_10',
      position: Offset(0.6, 0.3),
      title: 'Haven Suites',
      description:
          'Exclusive Haven-level suites with priority access and premium amenities.',
      icon: Icons.star,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'club_balcony_10',
      position: Offset(0.4, 0.6),
      title: 'Club Balcony Staterooms',
      description:
          'Enhanced staterooms with club-level perks and priority services.',
      icon: Icons.hotel,
      color: Colors.indigo,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 11 Markers - Club Level
  static const List<InteractiveMapMarkerData> _deck11Markers = [
    InteractiveMapMarkerData(
      id: 'club_level_perks',
      position: Offset(0.5, 0.4),
      title: 'Club Level Access',
      description:
          'Enhanced staterooms with club benefits including priority boarding and dining.',
      icon: Icons.card_membership,
      color: Colors.deepPurple,
      zoomTier: ZoomTier.essential,
    ),
  ];

  /// Deck 12 Markers - Studios & Hospital
  static const List<InteractiveMapMarkerData> _deck12Markers = [
    InteractiveMapMarkerData(
      id: 'studio_complex',
      position: Offset(0.3, 0.4),
      title: 'Studio Complex',
      description:
          'Solo traveler studios with shared lounge access and single-guest accommodations.',
      icon: Icons.single_bed,
      color: Colors.teal,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'medical_center_12',
      position: Offset(0.7, 0.5),
      title: 'Medical Center',
      description:
          'Onboard medical facility with qualified staff for health emergencies and basic care.',
      icon: Icons.medical_services,
      color: Colors.red,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'studio_lounge',
      position: Offset(0.5, 0.6),
      title: 'Studio Lounge',
      description:
          'Exclusive lounge for solo travelers staying in studio accommodations.',
      icon: Icons.chair,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 13 Markers - More Studios
  static const List<InteractiveMapMarkerData> _deck13Markers = [
    InteractiveMapMarkerData(
      id: 'studio_level2',
      position: Offset(0.4, 0.4),
      title: 'Additional Studios',
      description:
          'Second level of solo traveler studios with modern amenities.',
      icon: Icons.single_bed,
      color: Colors.teal,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'premium_staterooms_13',
      position: Offset(0.6, 0.5),
      title: 'Premium Staterooms',
      description: 'High-end staterooms with enhanced features and services.',
      icon: Icons.hotel,
      color: Colors.blue,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 14 Markers - Bridge & Officers
  static const List<InteractiveMapMarkerData> _deck14Markers = [
    InteractiveMapMarkerData(
      id: 'ship_bridge',
      position: Offset(0.5, 0.2),
      title: 'Ship\'s Bridge',
      description:
          'Command center where the captain and officers navigate the vessel. Restricted access.',
      icon: Icons.navigation,
      color: Colors.indigo,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'officers_quarters',
      position: Offset(0.3, 0.4),
      title: 'Officer Accommodations',
      description:
          'Private quarters for ship\'s officers and senior crew members.',
      icon: Icons.security,
      color: Colors.indigo,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'premium_suites_14',
      position: Offset(0.7, 0.6),
      title: 'Premium Suites',
      description:
          'Luxury suite accommodations with panoramic views and enhanced amenities.',
      icon: Icons.king_bed,
      color: Colors.purple,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 15 Markers - Premium Level
  static const List<InteractiveMapMarkerData> _deck15Markers = [
    InteractiveMapMarkerData(
      id: 'haven_access_15',
      position: Offset(0.5, 0.4),
      title: 'Haven Access Level',
      description:
          'Entry level to The Haven exclusive area with priority services.',
      icon: Icons.vpn_key,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'luxury_suites_15',
      position: Offset(0.6, 0.5),
      title: 'Luxury Accommodations',
      description:
          'High-end staterooms and suites with premium amenities and services.',
      icon: Icons.star_rate,
      color: Colors.amber,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 16 Markers - The Haven Level 1
  static const List<InteractiveMapMarkerData> _deck16Markers = [
    InteractiveMapMarkerData(
      id: 'haven_pool',
      position: Offset(0.3, 0.3),
      title: 'Haven Pool & Sundeck',
      description:
          'Exclusive pool area for Haven guests with private sundeck and poolside service.',
      icon: Icons.pool,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'haven_suites_16',
      position: Offset(0.6, 0.4),
      title: 'Haven Staterooms',
      description:
          'Luxury Haven-level staterooms with exclusive access and premium amenities.',
      icon: Icons.king_bed,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'haven_courtyard',
      position: Offset(0.5, 0.6),
      title: 'Haven Courtyard',
      description:
          'Private outdoor space for Haven guests with seating and relaxation areas.',
      icon: Icons.yard,
      color: Colors.green,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 17 Markers - Haven Level 2 & Observation
  static const List<InteractiveMapMarkerData> _deck17Markers = [
    InteractiveMapMarkerData(
      id: 'observation_lounge',
      position: Offset(0.2, 0.3),
      title: 'Observation Lounge',
      description:
          'Forward-facing lounge with panoramic ocean views and comfortable seating.',
      icon: Icons.visibility,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'haven_restaurant',
      position: Offset(0.6, 0.4),
      title: 'Haven Restaurant',
      description:
          'Exclusive dining venue for Haven guests with premium cuisine and service.',
      icon: Icons.restaurant,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'haven_bar_17',
      position: Offset(0.7, 0.6),
      title: 'Haven Bar',
      description:
          'Private bar for Haven guests with premium spirits and personalized service.',
      icon: Icons.local_bar,
      color: Colors.amber,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'sundeck_premium',
      position: Offset(0.4, 0.7),
      title: 'Premium Sundeck',
      description:
          'Exclusive outdoor relaxation area with loungers and ocean views.',
      icon: Icons.beach_access,
      color: Colors.orange,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 18 Markers - Aqua Park Level 1
  static const List<InteractiveMapMarkerData> _deck18Markers = [
    InteractiveMapMarkerData(
      id: 'ocean_loops',
      position: Offset(0.3, 0.4),
      title: 'Ocean Loops Waterslides',
      description:
          'Multi-level waterslides with loops and turns for thrilling water adventures.',
      icon: Icons.water_drop,
      color: Colors.blue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'the_rush_slides',
      position: Offset(0.6, 0.3),
      title: 'The Rush Racing Slides',
      description:
          'High-speed racing waterslides for competitive fun and adrenaline rush.',
      icon: Icons.speed,
      color: Colors.red,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'tidal_wave',
      position: Offset(0.7, 0.5),
      title: 'Tidal Wave',
      description:
          'Fleet\'s first waterslide allowing inner tube surfing for unique experience.',
      icon: Icons.surfing,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'aqua_park_pools',
      position: Offset(0.4, 0.6),
      title: 'Aqua Park Pools',
      description:
          'Two swimming pools within the waterpark area with family-friendly features.',
      icon: Icons.pool,
      color: Colors.lightBlue,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'waterpark_bar',
      position: Offset(0.5, 0.7),
      title: 'Aqua Park Bar',
      description:
          'Poolside bar serving refreshing drinks and snacks within the waterpark.',
      icon: Icons.local_bar,
      color: Colors.orange,
      zoomTier: ZoomTier.medium,
    ),
  ];

  /// Deck 19 Markers - Aqua Park Level 2
  static const List<InteractiveMapMarkerData> _deck19Markers = [
    InteractiveMapMarkerData(
      id: 'slide_coaster_mid',
      position: Offset(0.4, 0.4),
      title: 'Slide Coaster Level 2',
      description:
          'Middle section of the epic slide coaster experience with twists and turns.',
      icon: Icons.roller_skating,
      color: Colors.purple,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'sundeck_upper',
      position: Offset(0.6, 0.5),
      title: 'Upper Sundeck',
      description: 'Open-air sundeck with loungers and panoramic ocean views.',
      icon: Icons.wb_sunny,
      color: Colors.yellow,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'the_drop',
      position: Offset(0.3, 0.6),
      title: 'The Drop',
      description:
          'Freefall dry slide for the ultimate adrenaline rush and thrill experience.',
      icon: Icons.vertical_align_bottom,
      color: Colors.red,
      zoomTier: ZoomTier.essential,
    ),
  ];

  /// Deck 20 Markers - Top Deck Sports
  static const List<InteractiveMapMarkerData> _deck20Markers = [
    InteractiveMapMarkerData(
      id: 'slide_coaster_top',
      position: Offset(0.3, 0.3),
      title: 'Slide Coaster Finale',
      description:
          'Top section and finale of the thrilling slide coaster experience.',
      icon: Icons.roller_skating,
      color: Colors.purple,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'glow_court',
      position: Offset(0.6, 0.4),
      title: 'Glow Court',
      description:
          'Multi-sport court with LED lighting for basketball, volleyball, and other activities.',
      icon: Icons.sports_basketball,
      color: Colors.green,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'top_deck_stadium',
      position: Offset(0.5, 0.6),
      title: 'The Stadium',
      description:
          'Open-air venue for events, activities, and entertainment with stadium seating.',
      icon: Icons.stadium,
      color: Colors.orange,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'jogging_track_top',
      position: Offset(0.4, 0.7),
      title: 'Upper Jogging Track',
      description:
          'Elevated jogging and walking track with spectacular panoramic views.',
      icon: Icons.directions_run,
      color: Colors.blue,
      zoomTier: ZoomTier.medium,
    ),
  ];
}
