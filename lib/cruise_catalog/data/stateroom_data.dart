import '../models/cruise_product.dart';

enum StateroomStatus { available, recommended, notAvailable, soldOut }

enum StateroomType {
  studio,
  inside,
  oceanview,
  balcony,
  clubBalconySuite,
  haven,
}

class StateroomCategory {
  const StateroomCategory({
    required this.name,
    required this.price,
    required this.guests,
    required this.size,
    required this.features,
    required this.status,
    required this.type,
  });

  final String name;
  final String price;
  final String guests;
  final String size;
  final String features;
  final StateroomStatus status;
  final StateroomType type;
}

class StateroomData {
  static List<StateroomCategory> getStateroomCategories(
    StateroomType type,
    CruiseProduct cruise,
  ) {
    final basePrice = cruise.pricing.startingPrice;

    switch (type) {
      case StateroomType.studio:
        return [
          StateroomCategory(
            name: 'Studio',
            price: '\$${(basePrice * 0.8).toInt()} Per Person',
            guests: '1 Guest',
            size: '100 Sq. Ft. Total Approx. Size',
            features: 'Studio Lounge Access • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Studio Accessible',
            price: 'Not Available',
            guests: '1 Guest',
            size: '100 Sq. Ft. Total Approx. Size',
            features: 'Studio Lounge Access • More at Sea™ Available',
            status: StateroomStatus.notAvailable,
            type: type,
          ),
        ];

      case StateroomType.inside:
        return [
          StateroomCategory(
            name: 'Family Inside',
            price: '\$${(basePrice * 1.1).toInt()} Per Person',
            guests: 'Up to 4 Guests',
            size: '135 Sq. Ft. Total Approx. Size',
            features: 'More at Sea™ Available',
            status: StateroomStatus.recommended,
            type: type,
          ),
          StateroomCategory(
            name: 'Inside',
            price: '\$${basePrice.toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '129-201 Sq. Ft. Total Approx. Size',
            features: 'Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Sail Away Inside',
            price: '\$${(basePrice * 0.9).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '129-201 Sq. Ft. Total Approx. Size',
            features: 'More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Inside Accessible',
            price: 'Limited Availability',
            guests: 'Up to 2 Guests',
            size: '129-201 Sq. Ft. Total Approx. Size',
            features: 'Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.notAvailable,
            type: type,
          ),
        ];

      case StateroomType.oceanview:
        return [
          StateroomCategory(
            name: 'Family Oceanview',
            price: '\$${(basePrice * 1.4).toInt()} Per Person',
            guests: 'Up to 4 Guests',
            size: '140-175 Sq. Ft. Total Approx. Size',
            features: 'Picture Window • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Oceanview',
            price: '\$${(basePrice * 1.3).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '140-175 Sq. Ft. Total Approx. Size',
            features:
                'Picture Window • Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Sail Away Oceanview',
            price: '\$${(basePrice * 1.2).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '140-175 Sq. Ft. Total Approx. Size',
            features: 'Picture Window • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Oceanview Accessible',
            price: 'Limited Availability',
            guests: 'Up to 2 Guests',
            size: '140-175 Sq. Ft. Total Approx. Size',
            features:
                'Picture Window • Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.notAvailable,
            type: type,
          ),
        ];

      case StateroomType.balcony:
        return [
          StateroomCategory(
            name: 'Family Balcony',
            price: '\$${(basePrice * 1.8).toInt()} Per Person',
            guests: 'Up to 4 Guests',
            size: '175-205 Sq. Ft. Total Approx. Size',
            features: 'Private Balcony • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Balcony',
            price: '\$${(basePrice * 1.7).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '175-205 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Sail Away Balcony',
            price: '\$${(basePrice * 1.6).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '175-205 Sq. Ft. Total Approx. Size',
            features: 'Private Balcony • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Balcony Accessible',
            price: 'Limited Availability',
            guests: 'Up to 2 Guests',
            size: '175-205 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.notAvailable,
            type: type,
          ),
        ];

      case StateroomType.clubBalconySuite:
        return [
          StateroomCategory(
            name: 'Club Balcony Suite',
            price: '\$${(basePrice * 2.0).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '200-250 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Priority Boarding • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'Club Balcony Suite Accessible',
            price: 'Limited Availability',
            guests: 'Up to 2 Guests',
            size: '200-250 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Priority Boarding • Accessible Staterooms • More at Sea™ Available',
            status: StateroomStatus.notAvailable,
            type: type,
          ),
        ];

      case StateroomType.haven:
        return [
          StateroomCategory(
            name: 'The Haven Owner\'s Suite',
            price: '\$${(basePrice * 4.5).toInt()} Per Person',
            guests: 'Up to 4 Guests',
            size: '400-500 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Butler Service • Concierge • Priority Everything • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'The Haven Penthouse',
            price: '\$${(basePrice * 3.5).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '300-400 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Butler Service • Concierge • Priority Everything • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'The Haven Courtyard Penthouse',
            price: '\$${(basePrice * 3.0).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '250-300 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Butler Service • Concierge • Priority Everything • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
          StateroomCategory(
            name: 'The Haven Spa Suite',
            price: '\$${(basePrice * 3.2).toInt()} Per Person',
            guests: 'Up to 2 Guests',
            size: '275-350 Sq. Ft. Total Approx. Size',
            features:
                'Private Balcony • Butler Service • Concierge • Spa Access • Priority Everything • More at Sea™ Available',
            status: StateroomStatus.available,
            type: type,
          ),
        ];
    }
  }
}
