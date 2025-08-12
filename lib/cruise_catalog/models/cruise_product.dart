import 'cruise_route.dart';

/// Zoom tier enumeration for cruise route visibility
enum CruiseZoomTier {
  /// Always visible - flagship/popular routes
  essential,

  /// Visible at medium zoom - seasonal/regional routes
  medium,

  /// Visible at high zoom - specialty/expedition routes
  detailed,
}

/// Pricing information for a cruise product
class PriceRange {
  const PriceRange({
    required this.startingPrice,
    this.currency = 'USD',
    this.cabinType = 'Interior',
    this.isPerPerson = true,
  });

  final double startingPrice;
  final String currency;
  final String cabinType;
  final bool isPerPerson;

  String get formattedPrice {
    final priceText = '\$${startingPrice.toInt()}';
    final perPersonText = isPerPerson ? ' per person' : '';
    return '$priceText$perPersonText';
  }

  String get cabinDescription => '$cabinType starting from';
}

/// Represents a bookable cruise product in the catalog
class CruiseProduct {
  const CruiseProduct({
    required this.productId,
    required this.title,
    required this.shipName,
    required this.route,
    required this.duration,
    required this.pricing,
    required this.departureDates,
    this.description,
    this.highlights = const [],
    this.bookingUrl,
    this.isAvailable = true,
    this.imageUrl,
    this.shipClass,
    this.capacity,
    this.zoomTier = CruiseZoomTier.medium,
  });

  final String productId;
  final String title;
  final String shipName;
  final String? shipClass;
  final int? capacity;
  final CruiseRoute route;
  final String duration; // "7 days", "12 nights", etc.
  final PriceRange pricing;
  final List<DateTime> departureDates;
  final String? description;
  final List<String> highlights;
  final String? bookingUrl;
  final bool isAvailable;
  final String? imageUrl;
  final CruiseZoomTier zoomTier;

  /// Get the next available departure date
  DateTime? get nextDeparture {
    final now = DateTime.now();
    final futureDates = departureDates.where((date) => date.isAfter(now));
    return futureDates.isNotEmpty ? futureDates.first : null;
  }

  /// Get formatted departure dates for display
  String get departuresText {
    if (departureDates.isEmpty) return 'No dates available';

    final next = nextDeparture;
    if (next == null) return 'No upcoming departures';

    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return 'Next: ${months[next.month]} ${next.day}';
  }

  /// Get route summary for display
  String get routeSummary {
    if (route.isRoundTrip) {
      return 'Round trip from ${route.startPort.name}';
    } else {
      return '${route.startPort.name} to ${route.endPort.name}';
    }
  }

  /// Get key selling points as a formatted string
  String get highlightsText {
    if (highlights.isEmpty) return '';
    return highlights.take(3).join(' • ');
  }

  @override
  String toString() => '$title ($shipName) - $duration';
}
