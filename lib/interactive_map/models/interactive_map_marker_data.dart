import 'package:flutter/material.dart';

import '../widgets/interactive_map_filter.dart';

/// Zoom tier enumeration for marker visibility
enum ZoomTier {
  /// Always visible - major landmarks
  essential,

  /// Visible at medium zoom - dining, bars, main activities
  medium,

  /// Visible at high zoom - all facilities and detailed services
  detailed,
}

/// Data class for the interactive map marker
class InteractiveMapMarkerData {
  /// Constructor
  const InteractiveMapMarkerData({
    required this.id,
    required this.position,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.zoomTier,
  });

  /// The id of the marker
  final String id;

  /// The position of the marker
  final Offset position;

  /// The title of the marker
  final String title;

  /// The description of the marker
  final String description;

  /// The icon of the marker
  final IconData icon;

  /// The color of the marker
  final Color color;

  /// The zoom tier determining when this marker becomes visible
  final ZoomTier zoomTier;

  /// Get the category of this marker based on its icon
  MarkerCategory get category {
    switch (icon) {
      // Dining & Bars
      case Icons.restaurant:
      case Icons.lunch_dining:
      case Icons.local_dining:
      case Icons.local_bar:
        return MarkerCategory.dining;

      // Water Activities
      case Icons.scuba_diving:
      case Icons.water_drop:
      case Icons.kayaking:
      case Icons.pool:
      case Icons.beach_access:
        return MarkerCategory.waterActivities;

      // Transportation
      case Icons.directions_boat:
      case Icons.flight:
      case Icons.sports_motorsports:
      case Icons.train:
        return MarkerCategory.transportation;

      // Entertainment & Activities
      case Icons.music_note:
      case Icons.child_care:
      case Icons.sports_tennis:
      case Icons.groups:
        return MarkerCategory.entertainment;

      // Facilities & Services (default)
      default:
        return MarkerCategory.facilities;
    }
  }

  /// Returns contextually appropriate action button text for each marker type.
  ///
  /// Provides specific call-to-action text based on the marker's purpose:
  /// - Dining locations: "View Menu", "Taco Menu", etc.
  /// - Activities: "Adventure Details", "Snorkel Info", etc.
  /// - Transportation: "Construction Details", "Accessibility Info", etc.
  ///
  /// **Parameters:**
  /// - [markerId]: Unique identifier for the marker
  ///
  /// **Returns:** Localized action button text or "View Details" as fallback
  static String getActionButtonText(String markerId) {
    switch (markerId) {
      // Transportation & Arrival
      case 'pier':
        return 'Construction Details';
      case 'welcome_plaza':
        return 'Visitor Info';
      case 'tenders_wheelchair':
        return 'Accessibility Info';

      // Exclusive Areas
      case 'silver_cove':
        return 'Explore Retreat';
      case 'vibe_shore_club':
        return 'Coming Soon Info';

      // Dining Locations
      case 'jumbey_beach_grill':
        return 'View Menu';
      case 'abaco_taco':
        return 'Taco Menu';
      case 'food_truck':
        return 'Food Truck Menu';

      // Bars & Beverages
      case 'lighthouse_bar':
      case 'bacardi_bar':
      case 'beach_bar':
      case 'bertrams_bar':
      case 'patron_bar':
      case 'bobolink_bar':
        return 'Drink Menu';

      // Water Activities & Adventures
      case 'zipline':
        return 'Adventure Details';
      case 'snorkel_garden':
        return 'Snorkel Info';
      case 'great_tiger_waterpark':
        return 'Waterpark Fun';
      case 'watersports_center':
        return 'Book Activities';
      case 'jet_karts':
        return 'Rental Info';

      // Beach Areas & Relaxation
      case 'cabanas':
        return 'Reserve Cabana';
      case 'hammock_bay':
        return 'Relaxation Zone';

      // Facilities & Services
      case 'great_life_lagoon':
        return 'Lagoon Details';
      case 'splash_islands':
        return 'Family Fun';
      case 'horizon_park':
        return 'Park Activities';
      case 'panoramic_bridge':
        return 'Scenic Views';
      case 'tour_booth':
        return 'Book Excursions';
      case 'first_aid':
        return 'Medical Info';
      case 'ping_pong':
        return 'Game Time';
      case 'group_pavilion':
        return 'Group Booking';
      case 'tram_service':
        return 'Coming Soon';

      default:
        return 'View Details';
    }
  }

  /// Predefined ship deck markers for Norwegian Aqua Deck 8
  static const List<InteractiveMapMarkerData> shipDeckMarkers = [
    // Dining & Restaurants
    InteractiveMapMarkerData(
      id: 'main_dining_room',
      position: Offset(0.5, 0.35),
      title: 'Main Dining Room',
      description:
          'Traditional cruise dining experience with rotating menus featuring international cuisine and formal dining atmosphere.',
      icon: Icons.restaurant,
      color: Colors.orange,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'specialty_restaurant',
      position: Offset(0.2, 0.4),
      title: 'Specialty Restaurant',
      description:
          'Premium dining venue featuring chef-curated menus with Italian, Asian, or steakhouse specialties. Reservations recommended.',
      icon: Icons.restaurant,
      color: Colors.orange,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'buffet_restaurant',
      position: Offset(0.7, 0.25),
      title: 'Garden Cafe Buffet',
      description:
          'Casual buffet dining with international cuisine, fresh salads, desserts, and 24-hour availability.',
      icon: Icons.lunch_dining,
      color: Colors.orange,
      zoomTier: ZoomTier.essential,
    ),

    // Bars & Lounges
    InteractiveMapMarkerData(
      id: 'main_bar',
      position: Offset(0.5, 0.55),
      title: 'Atrium Bar',
      description:
          'Central bar located in the ship\'s atrium, perfect for people watching with specialty cocktails and live music.',
      icon: Icons.local_bar,
      color: Colors.purple,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'pool_bar',
      position: Offset(0.3, 0.65),
      title: 'Pool Bar',
      description:
          'Poolside bar serving tropical cocktails, frozen drinks, beer, and light snacks throughout the day.',
      icon: Icons.local_bar,
      color: Colors.purple,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'lounge_bar',
      position: Offset(0.8, 0.45),
      title: 'Whiskey Bar',
      description:
          'Premium lounge featuring an extensive selection of whiskeys, cigars, and sophisticated atmosphere.',
      icon: Icons.local_bar,
      color: Colors.purple,
      zoomTier: ZoomTier.detailed,
    ),

    // Pools & Recreation
    InteractiveMapMarkerData(
      id: 'main_pool',
      position: Offset(0.35, 0.7),
      title: 'Main Pool',
      description:
          'Large swimming pool with poolside service, comfortable loungers, and panoramic ocean views.',
      icon: Icons.pool,
      color: Colors.blue,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'hot_tub',
      position: Offset(0.25, 0.75),
      title: 'Hot Tub',
      description:
          'Relaxing hot tub with therapeutic jets, perfect for unwinding while enjoying ocean views.',
      icon: Icons.hot_tub,
      color: Colors.blue,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'kids_pool',
      position: Offset(0.45, 0.75),
      title: 'Kids Splash Area',
      description:
          'Family-friendly splash area with water features, slides, and shallow pools designed for children.',
      icon: Icons.child_care,
      color: Colors.blue,
      zoomTier: ZoomTier.medium,
    ),

    // Entertainment & Activities
    InteractiveMapMarkerData(
      id: 'theater',
      position: Offset(0.6, 0.5),
      title: 'Main Theater',
      description:
          'Broadway-style theater featuring live shows, musicals, comedy acts, and entertainment performances.',
      icon: Icons.theater_comedy,
      color: Colors.pink,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'casino',
      position: Offset(0.75, 0.6),
      title: 'Casino',
      description:
          'Full-service casino with slot machines, table games, poker tournaments, and gaming excitement.',
      icon: Icons.casino,
      color: Colors.pink,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'sports_deck',
      position: Offset(0.1, 0.3),
      title: 'Sports Deck',
      description:
          'Multi-sport court for basketball, volleyball, and other recreational activities with equipment rental.',
      icon: Icons.sports_basketball,
      color: Colors.pink,
      zoomTier: ZoomTier.detailed,
    ),

    // Spa & Fitness
    InteractiveMapMarkerData(
      id: 'spa',
      position: Offset(0.85, 0.25),
      title: 'The Spa',
      description:
          'Full-service spa offering massages, facials, body treatments, and wellness therapies in a tranquil setting.',
      icon: Icons.spa,
      color: Colors.green,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'fitness_center',
      position: Offset(0.9, 0.35),
      title: 'Fitness Center',
      description:
          'Modern gym with cardio equipment, weight machines, free weights, and fitness classes.',
      icon: Icons.fitness_center,
      color: Colors.green,
      zoomTier: ZoomTier.detailed,
    ),

    // Services & Facilities
    InteractiveMapMarkerData(
      id: 'guest_services',
      position: Offset(0.55, 0.45),
      title: 'Guest Services',
      description:
          'Information desk for excursions, dining reservations, general inquiries, and guest assistance.',
      icon: Icons.info,
      color: Colors.teal,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'medical_center',
      position: Offset(0.15, 0.6),
      title: 'Medical Center',
      description:
          'Onboard medical facility with qualified staff for health emergencies and basic medical services.',
      icon: Icons.medical_services,
      color: Colors.red,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'photo_gallery',
      position: Offset(0.65, 0.4),
      title: 'Photo Gallery',
      description:
          'Professional photography services and photo viewing area for cruise memories and portraits.',
      icon: Icons.photo_camera,
      color: Colors.teal,
      zoomTier: ZoomTier.detailed,
    ),

    // Shopping & Retail
    InteractiveMapMarkerData(
      id: 'shops',
      position: Offset(0.7, 0.35),
      title: 'Promenade Shops',
      description:
          'Duty-free shopping with jewelry, souvenirs, clothing, and luxury goods at sea prices.',
      icon: Icons.shopping_bag,
      color: Colors.amber,
      zoomTier: ZoomTier.medium,
    ),

    // Outdoor Decks
    InteractiveMapMarkerData(
      id: 'observation_deck',
      position: Offset(0.5, 0.15),
      title: 'Observation Deck',
      description:
          'Open-air deck perfect for whale watching, sunbathing, and enjoying panoramic ocean views.',
      icon: Icons.visibility,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'jogging_track',
      position: Offset(0.15, 0.2),
      title: 'Jogging Track',
      description:
          'Outdoor jogging and walking track circumnavigating the ship with marked distances.',
      icon: Icons.directions_run,
      color: Colors.green,
      zoomTier: ZoomTier.detailed,
    ),
  ];

  /// Predefined cruise destination markers for Great Stirrup Cay
  static const List<InteractiveMapMarkerData> cruiseDestinations = [
    // Transportation & Arrival
    InteractiveMapMarkerData(
      id: 'pier',
      position: Offset(0.86, 0.30),
      title: 'New! Pier',
      description:
          r'''Under construction with \$150M investment. Will accommodate two large vessels simultaneously. Expected completion by late 2025.''',
      icon: Icons.directions_boat,
      color: Colors.amber,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'welcome_plaza',
      position: Offset(0.85, 0.42),
      title: 'Welcome Plaza',
      description:
          '''Main arrival area with information services, restrooms, and guest orientation facilities.''',
      icon: Icons.location_on,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'tenders_wheelchair',
      position: Offset(0.85, 0.55),
      title: 'Accessible Tenders',
      description:
          '''Handicap-accessible tender boats with covered top deck. Beach wheelchairs available with limited availability.''',
      icon: Icons.accessible,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),

    // Exclusive Areas
    InteractiveMapMarkerData(
      id: 'silver_cove',
      position: Offset(0.25, 0.52),
      title: 'Silver Cove',
      description:
          '''Private retreat with exclusive beach, pool, and cabanas. Lagoon villas available from Studio (2 people) to Two-Bedroom (16+ people). Includes Moet Champagne Bar.''',
      icon: Icons.beach_access,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'vibe_shore_club',
      position: Offset(0.32, 0.55),
      title: 'New! Vibe Shore Club',
      description:
          '''Coming soon as part of the island enhancement project. Exclusive beach club with premium amenities and tropical atmosphere.''',
      icon: Icons.music_note,
      color: Colors.amber,
      zoomTier: ZoomTier.medium,
    ),

    // Dining Locations
    InteractiveMapMarkerData(
      id: 'jumbey_beach_grill',
      position: Offset(0.45, 0.58),
      title: 'Jumbey Beach Grill',
      description:
          '''Complimentary island BBQ lunch buffet featuring burgers, hot dogs, jerk chicken, salads, pizza, and desserts. Served 11 AM - 2 PM.''',
      icon: Icons.restaurant,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'abaco_taco',
      position: Offset(0.52, 0.65),
      title: 'Abaco Taco',
      description:
          '''Popular taco stand offering fish, chicken, and beef tacos with fresh toppings including lettuce, tomatoes, cheese, and sour cream.''',
      icon: Icons.lunch_dining,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'food_truck',
      position: Offset(0.58, 0.55),
      title: 'Tropic Like It\'s Hot Food Truck',
      description:
          '''Located near beach cabanas and lighthouse bar. Serves fish sandwiches, pork sandwiches, ceviche, and chicken sandwiches.''',
      icon: Icons.local_dining,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),

    // Bars & Beverages
    InteractiveMapMarkerData(
      id: 'lighthouse_bar',
      position: Offset(0.62, 0.48),
      title: 'Lighthouse Beach Bar',
      description:
          '''Located near the island's lighthouse offering stunning ocean views. Full bar service with frozen drinks, cocktails, and beer.''',
      icon: Icons.local_bar,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'bacardi_bar',
      position: Offset(0.48, 0.52),
      title: 'Bacardi Bar',
      description:
          '''Situated near the main beach serving tropical cocktails, frozen drinks, and beer. Popular gathering spot for beach activities.''',
      icon: Icons.local_bar,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'beach_bar',
      position: Offset(0.42, 0.62),
      title: 'Beach Bar',
      description:
          '''Laid-back beach bar with plenty of shade to cool off from the sun. Offers full beverage service and casual atmosphere.''',
      icon: Icons.local_bar,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'bertrams_bar',
      position: Offset(0.32, 0.78),
      title: 'Bertram\'s Bar',
      description:
          '''Located on Bertram's Beach offering drinks, light bites, and beachside service. Great selection of cocktails and refreshments.''',
      icon: Icons.local_bar,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'patron_bar',
      position: Offset(0.55, 0.48),
      title: 'Patrón Bar',
      description:
          '''Premium bar featuring Patrón specialty drinks, cocktails, and frozen beverages. Located centrally for easy access.''',
      icon: Icons.local_bar,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'bobolink_bar',
      position: Offset(0.38, 0.55),
      title: 'Bobolink Beach Bar',
      description:
          '''Beachside bar serving frozen specialty drinks, cocktails, and beer. Perfect spot for refreshments between activities.''',
      icon: Icons.local_bar,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),

    // Water Activities & Adventures
    InteractiveMapMarkerData(
      id: 'zipline',
      position: Offset(0.47, 0.48),
      title: 'Zipline',
      description:
          '''Thrilling zipline adventure over crystal-clear waters with breathtaking aerial views of the island and surrounding ocean.''',
      icon: Icons.flight,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'snorkel_garden',
      position: Offset(0.22, 0.36),
      title: 'Snorkel Garden',
      description:
          '''Amazing underwater experience with vibrant marine life, coral gardens, and crystal-clear waters perfect for snorkeling.''',
      icon: Icons.scuba_diving,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'great_tiger_waterpark',
      position: Offset(0.25, 0.73),
      title: 'Great Tiger Waterpark',
      description:
          '''Family-friendly waterpark with slides, water features, and aquatic adventures perfect for all ages.''',
      icon: Icons.water_drop,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'watersports_center',
      position: Offset(0.58, 0.72),
      title: 'Wave Runners & Kayaks',
      description:
          '''Wave Runner rentals, kayak tours, eco boat adventures, stingray encounters, and stand-up paddleboard rentals available.''',
      icon: Icons.kayaking,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'jet_karts',
      position: Offset(0.83, 0.76),
      title: 'Jet Karts',
      description:
          '''High-speed jet kart rentals for thrilling water adventures around the island. Professional instruction available.''',
      icon: Icons.sports_motorsports,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),

    // Beach Areas & Relaxation
    InteractiveMapMarkerData(
      id: 'cabanas',
      position: Offset(0.52, 0.58),
      title: 'Cabanas',
      description:
          '''Private beach cabanas offering luxury comfort with stunning ocean views. Various sizes available for rent - advance booking recommended.''',
      icon: Icons.cabin,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'hammock_bay',
      position: Offset(0.42, 0.54),
      title: 'Hammock Bay',
      description:
          '''Peaceful relaxation area with hammocks and shaded spots for ultimate beach relaxation and serenity.''',
      icon: Icons.beach_access,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),

    // Facilities & Services
    InteractiveMapMarkerData(
      id: 'great_life_lagoon',
      position: Offset(0.68, 0.34),
      title: 'Great Life Lagoon',
      description:
          '''Stunning lagoon area with crystal-clear waters, perfect for swimming and relaxation in a protected cove environment.''',
      icon: Icons.pool,
      color: Colors.cyan,
      zoomTier: ZoomTier.essential,
    ),
    InteractiveMapMarkerData(
      id: 'splash_islands',
      position: Offset(0.52, 0.44),
      title: 'Splash Islands',
      description:
          '''Interactive water play area with multiple splash features, perfect for families with children of all ages.''',
      icon: Icons.child_care,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'horizon_park',
      position: Offset(0.65, 0.55),
      title: 'Horizon Park',
      description:
          '''Adventure park featuring various outdoor activities, scenic walking trails, and recreational facilities with beautiful island views.''',
      icon: Icons.park,
      color: Colors.cyan,
      zoomTier: ZoomTier.medium,
    ),
    InteractiveMapMarkerData(
      id: 'panoramic_bridge',
      position: Offset(0.70, 0.48),
      title: 'Panoramic Bridge',
      description:
          '''Scenic bridge offering breathtaking panoramic views of the island and surrounding ocean waters.''',
      icon: Icons.view_agenda,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'tour_booth',
      position: Offset(0.78, 0.58),
      title: 'Tour Information Booth',
      description:
          '''Central information hub for booking excursions, getting island maps, and learning about available activities and services.''',
      icon: Icons.info,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'first_aid',
      position: Offset(0.75, 0.62),
      title: 'First Aid Station',
      description:
          '''Medical assistance and first aid services available. Staffed with trained medical personnel for guest safety and health needs.''',
      icon: Icons.medical_services,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'ping_pong',
      position: Offset(0.68, 0.58),
      title: 'Ping Pong Area',
      description:
          '''Game on! Enjoy a casual game of ping-pong at your leisure. Equipment provided for guest entertainment.''',
      icon: Icons.sports_tennis,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'group_pavilion',
      position: Offset(0.58, 0.68),
      title: 'Group Pavilion',
      description:
          '''Large covered pavilion perfect for group gatherings, events, and shaded relaxation. Available for group bookings.''',
      icon: Icons.groups,
      color: Colors.cyan,
      zoomTier: ZoomTier.detailed,
    ),
    InteractiveMapMarkerData(
      id: 'tram_service',
      position: Offset(0.70, 0.45),
      title: 'New! Tram Service',
      description:
          '''Coming soon as part of island enhancements. Convenient transportation service to connect various areas of the island.''',
      icon: Icons.train,
      color: Colors.amber,
      zoomTier: ZoomTier.detailed,
    ),
  ];
}
