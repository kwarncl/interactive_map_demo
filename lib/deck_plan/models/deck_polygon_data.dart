import 'package:flutter/material.dart';

/// Represents a clickable polygon area on a deck plan
class DeckPolygonArea {
  const DeckPolygonArea({
    required this.id,
    required this.title,
    required this.description,
    required this.polygon,
    required this.category,
    required this.color,
  });

  /// Unique identifier for this area
  final String id;

  /// Display title of the area
  final String title;

  /// Detailed description of the area
  final String description;

  /// List of points defining the polygon boundary (normalized coordinates 0.0-1.0)
  final List<Offset> polygon;

  /// Category for filtering (dining, entertainment, etc.)
  final String category;

  /// Color associated with this area (for highlighting when selected)
  final Color color;

  /// Check if a point is inside this polygon using ray casting algorithm
  bool containsPoint(Offset point) {
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      final Offset pi = polygon[i];
      final Offset pj = polygon[j];

      if (((pi.dy > point.dy) != (pj.dy > point.dy)) &&
          (point.dx <
              (pj.dx - pi.dx) * (point.dy - pi.dy) / (pj.dy - pi.dy) + pi.dx)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }
}

/// Abstract interface for providing polygon data for ship decks
abstract class DeckPolygonDataProvider {
  /// Get polygon areas for a specific ship and deck number
  List<DeckPolygonArea> getPolygonAreas(String shipClass, int deckNumber);

  /// Check if a specific ship and deck has polygon data available
  bool hasPolygonData(String shipClass, int deckNumber);

  /// Get all available deck numbers with polygon data for a ship class
  List<int> getAvailableDecks(String shipClass);
}

/// Norwegian Aqua specific polygon data provider
class NorwegianAquaPolygonProvider implements DeckPolygonDataProvider {
  static const String shipClass = 'norwegian_aqua';

  @override
  List<DeckPolygonArea> getPolygonAreas(String shipClass, int deckNumber) {
    if (shipClass != NorwegianAquaPolygonProvider.shipClass) {
      return [];
    }

    switch (deckNumber) {
      case 8:
        return _deck8Areas;
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
    if (shipClass != NorwegianAquaPolygonProvider.shipClass) {
      return [];
    }
    return [8]; // Only deck 8 has polygon data currently
  }

  /// Deck 8 polygon areas based on the actual colored areas in the deck plan
  /// Only includes colored areas, white/light areas are ignored
  static const List<DeckPolygonArea> _deck8Areas = [
    // The Local Bar & Grill (Port Side) - better wrapped around ship hull
    DeckPolygonArea(
      id: 'local_bar_grill_port',
      title: 'The Local Bar & Grill (Port)',
      description: 'Casual dining and bar with ocean views on the port side.',
      category: 'dining',
      color: Colors.red,
      polygon: [
        // Better wrapped around the ship's port hull
        Offset(0.02, 0.15), // Top-left at hull
        Offset(0.06, 0.13), // Top curve - closer to hull
        Offset(0.12, 0.12), // Top edge - more inward
        Offset(0.20, 0.12), // Top edge continues
        Offset(0.28, 0.13), // Top edge curves down
        Offset(0.35, 0.15), // Right edge starts
        Offset(0.38, 0.18), // Right edge curves
        Offset(0.38, 0.22), // Right edge continues
        Offset(0.35, 0.26), // Right edge curves down
        Offset(0.28, 0.30), // Bottom-right curve
        Offset(0.20, 0.32), // Bottom edge
        Offset(0.12, 0.32), // Bottom edge continues
        Offset(0.06, 0.30), // Bottom-left curve
        Offset(0.02, 0.26), // Left edge at hull
      ],
    ),

    // The Local Bar & Grill (Starboard Side) - better wrapped around ship hull
    DeckPolygonArea(
      id: 'local_bar_grill_starboard',
      title: 'The Local Bar & Grill (Starboard)',
      description:
          'Casual dining and bar with ocean views on the starboard side.',
      category: 'dining',
      color: Colors.red,
      polygon: [
        // Better wrapped around the ship's starboard hull
        Offset(0.98, 0.15), // Top-right at hull
        Offset(0.94, 0.13), // Top curve - closer to hull
        Offset(0.88, 0.12), // Top edge - more inward
        Offset(0.80, 0.12), // Top edge continues
        Offset(0.72, 0.13), // Top edge curves down
        Offset(0.65, 0.15), // Left edge starts
        Offset(0.62, 0.18), // Left edge curves
        Offset(0.62, 0.22), // Left edge continues
        Offset(0.65, 0.26), // Left edge curves down
        Offset(0.72, 0.30), // Bottom-left curve
        Offset(0.80, 0.32), // Bottom edge
        Offset(0.88, 0.32), // Bottom edge continues
        Offset(0.94, 0.30), // Bottom-right curve
        Offset(0.98, 0.26), // Right edge at hull
      ],
    ),

    // Bar area (light blue rectangle) - more precise positioning
    DeckPolygonArea(
      id: 'bar_area',
      title: 'Bar',
      description: 'Full-service bar with premium cocktails and spirits.',
      category: 'bar',
      color: Colors.lightBlue,
      polygon: [
        Offset(0.72, 0.18), // Top-left
        Offset(0.82, 0.18), // Top-right
        Offset(0.82, 0.25), // Bottom-right
        Offset(0.72, 0.25), // Bottom-left
      ],
    ),

    // Infinity Beach (Port Side) - better wrapped around ship hull
    DeckPolygonArea(
      id: 'infinity_beach_port',
      title: 'Infinity Beach (Port)',
      description: 'Outdoor beach area with ocean views on the port side.',
      category: 'recreation',
      color: Colors.lightBlue,
      polygon: [
        // Better wrapped around the ship's port hull
        Offset(0.02, 0.40), // Top-left at hull
        Offset(0.04, 0.37), // Top curve - closer to hull
        Offset(0.08, 0.35), // Top edge - more inward
        Offset(0.15, 0.35), // Top edge continues
        Offset(0.22, 0.37), // Top edge curves
        Offset(0.28, 0.40), // Right edge starts
        Offset(0.30, 0.44), // Right edge curves
        Offset(0.30, 0.52), // Right edge continues
        Offset(0.28, 0.58), // Right edge curves down
        Offset(0.22, 0.62), // Bottom-right curve
        Offset(0.15, 0.64), // Bottom edge
        Offset(0.08, 0.64), // Bottom edge continues
        Offset(0.04, 0.62), // Bottom-left curve
        Offset(0.02, 0.58), // Left edge at hull
      ],
    ),

    // Infinity Beach (Starboard Side) - better wrapped around ship hull
    DeckPolygonArea(
      id: 'infinity_beach_starboard',
      title: 'Infinity Beach (Starboard)',
      description: 'Outdoor beach area with ocean views on the starboard side.',
      category: 'recreation',
      color: Colors.lightBlue,
      polygon: [
        // Better wrapped around the ship's starboard hull
        Offset(0.98, 0.40), // Top-right at hull
        Offset(0.96, 0.37), // Top curve - closer to hull
        Offset(0.92, 0.35), // Top edge - more inward
        Offset(0.85, 0.35), // Top edge continues
        Offset(0.78, 0.37), // Top edge curves
        Offset(0.72, 0.40), // Left edge starts
        Offset(0.70, 0.44), // Left edge curves
        Offset(0.70, 0.52), // Left edge continues
        Offset(0.72, 0.58), // Left edge curves down
        Offset(0.78, 0.62), // Bottom-left curve
        Offset(0.85, 0.64), // Bottom edge
        Offset(0.92, 0.64), // Bottom edge continues
        Offset(0.96, 0.62), // Bottom-right curve
        Offset(0.98, 0.58), // Right edge at hull
      ],
    ),

    // Indulge Food Hall (large orange circular area) - better wrapped around ship shape
    DeckPolygonArea(
      id: 'indulge_food_hall',
      title: 'Indulge Food Hall',
      description:
          'NCL\'s first open-air marketplace with diverse international food vendors.',
      category: 'dining',
      color: Colors.orange,
      polygon: [
        // Better wrapped around the ship's shape - more inward curves
        Offset(0.32, 0.76), // Top-left - more inward
        Offset(0.38, 0.74), // Top-left curve - closer to center
        Offset(0.50, 0.73), // Top-center
        Offset(0.62, 0.74), // Top-right curve - closer to center
        Offset(0.68, 0.76), // Top-right - more inward
        Offset(0.72, 0.79), // Right-top curve - more inward
        Offset(0.74, 0.83), // Right edge - more inward
        Offset(0.74, 0.88), // Right edge continues - more inward
        Offset(0.72, 0.92), // Right-bottom curve - more inward
        Offset(0.68, 0.94), // Bottom-right - more inward
        Offset(0.62, 0.95), // Bottom-right curve - more inward
        Offset(0.50, 0.95), // Bottom-center
        Offset(0.38, 0.95), // Bottom-left curve - more inward
        Offset(0.32, 0.94), // Bottom-left - more inward
        Offset(0.28, 0.92), // Left-bottom curve - more inward
        Offset(0.26, 0.88), // Left edge - more inward
        Offset(0.26, 0.83), // Left edge continues - more inward
        Offset(0.28, 0.79), // Left-top curve - more inward
      ],
    ),

    // Luna Bar (inside the food hall) - more precise positioning
    DeckPolygonArea(
      id: 'luna_bar',
      title: 'Luna Bar',
      description:
          'Specialty bar located within the Indulge Food Hall offering craft cocktails.',
      category: 'bar',
      color: Colors.purple,
      polygon: [
        Offset(0.46, 0.82), // Top-left
        Offset(0.54, 0.82), // Top-right
        Offset(0.54, 0.88), // Bottom-right
        Offset(0.46, 0.88), // Bottom-left
      ],
    ),

    // Soleil Bar (at very bottom) - more precise positioning
    DeckPolygonArea(
      id: 'soleil_bar',
      title: 'Soleil Bar',
      description:
          'Outdoor bar at the aft with stunning ocean views and tropical drinks.',
      category: 'bar',
      color: Colors.amber,
      polygon: [
        Offset(0.44, 0.94), // Top-left
        Offset(0.56, 0.94), // Top-right
        Offset(0.56, 0.98), // Bottom-right
        Offset(0.44, 0.98), // Bottom-left
      ],
    ),

    // Indulge Outdoor Lounge - curved area around the stern circular section only
    DeckPolygonArea(
      id: 'indulge_outdoor_lounge',
      title: 'Indulge Outdoor Lounge',
      description:
          'Open-air seating area around the circular stern section with ocean views.',
      category: 'lounge',
      color: Colors.brown,
      polygon: [
        // Curved shape wrapping only around the circular stern section
        // Port side - starting where the circular section begins
        Offset(0.26, 0.76), // Port inner edge - where circular section starts
        Offset(0.24, 0.79), // Port curve around food hall
        Offset(0.22, 0.83), // Port curve continues
        Offset(0.20, 0.87), // Port curve down
        Offset(0.18, 0.91), // Port bottom curve
        Offset(0.16, 0.94), // Port stern curve
        Offset(0.14, 0.96), // Port stern bottom
        Offset(0.12, 0.98), // Port stern tip
        // Stern bottom - following the circular hull
        Offset(0.15, 0.99), // Stern curve starts
        Offset(0.20, 1.0), // Stern bottom left
        Offset(0.30, 1.0), // Stern bottom left-center
        Offset(0.50, 1.0), // Stern bottom center
        Offset(0.70, 1.0), // Stern bottom right-center
        Offset(0.80, 1.0), // Stern bottom right
        Offset(0.85, 0.99), // Stern curve ends
        // Starboard side - ending where the circular section ends
        Offset(0.88, 0.98), // Starboard stern tip
        Offset(0.86, 0.96), // Starboard stern bottom
        Offset(0.84, 0.94), // Starboard stern curve
        Offset(0.82, 0.91), // Starboard bottom curve
        Offset(0.80, 0.87), // Starboard curve down
        Offset(0.78, 0.83), // Starboard curve continues
        Offset(0.76, 0.79), // Starboard curve around food hall
        Offset(
          0.74,
          0.76,
        ), // Starboard inner edge - where circular section ends
        // Connecting around the food hall area
        Offset(0.72, 0.74), // Around food hall top-right
        Offset(0.68, 0.73), // Around food hall top
        Offset(0.62, 0.72), // Around food hall top
        Offset(0.50, 0.71), // Food hall top center
        Offset(0.38, 0.72), // Around food hall top
        Offset(0.32, 0.73), // Around food hall top
        Offset(0.28, 0.74), // Around food hall top-left
      ],
    ),
  ];
}

/// Factory class for getting polygon data providers for different ship classes
class ShipPolygonDataFactory {
  static final Map<String, DeckPolygonDataProvider> _providers = {
    NorwegianAquaPolygonProvider.shipClass: NorwegianAquaPolygonProvider(),
  };

  /// Get polygon data provider for a specific ship class
  static DeckPolygonDataProvider? getProvider(String shipClass) {
    return _providers[shipClass];
  }

  /// Get all available ship classes
  static List<String> getAvailableShipClasses() {
    return _providers.keys.toList();
  }

  /// Register a new polygon data provider for a ship class
  static void registerProvider(
    String shipClass,
    DeckPolygonDataProvider provider,
  ) {
    _providers[shipClass] = provider;
  }
}
