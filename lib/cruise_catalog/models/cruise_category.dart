import 'package:flutter/material.dart';

/// Represents a category of cruises for organization and filtering
class CruiseCategory {
  const CruiseCategory({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    this.region,
  });

  final String categoryId;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final String? region;

  @override
  String toString() => name;
}

/// Predefined cruise categories for the NCL catalog
class CruiseCategories {
  static const caribbean = CruiseCategory(
    categoryId: 'caribbean',
    name: 'Caribbean',
    description: 'Tropical paradise with pristine beaches and crystal waters',
    color: Colors.orange,
    icon: Icons.beach_access,
    region: 'Caribbean Sea',
  );

  static const mediterranean = CruiseCategory(
    categoryId: 'mediterranean',
    name: 'Mediterranean',
    description: 'Historic ports and cultural treasures of Europe',
    color: Colors.blue,
    icon: Icons.account_balance,
    region: 'Mediterranean Sea',
  );

  static const alaska = CruiseCategory(
    categoryId: 'alaska',
    name: 'Alaska',
    description: 'Stunning glaciers and wildlife of the Last Frontier',
    color: Colors.teal,
    icon: Icons.terrain,
    region: 'Alaska',
  );

  static const hawaii = CruiseCategory(
    categoryId: 'hawaii',
    name: 'Hawaii',
    description: 'Volcanic islands and Polynesian culture',
    color: Colors.green,
    icon: Icons.local_florist,
    region: 'Hawaiian Islands',
  );

  static const transatlantic = CruiseCategory(
    categoryId: 'transatlantic',
    name: 'Transatlantic',
    description: 'Cross-ocean journeys with elegant sea days',
    color: Colors.purple,
    icon: Icons.sailing,
    region: 'Atlantic Ocean',
  );

  static const northernEurope = CruiseCategory(
    categoryId: 'northern europe',
    name: 'Northern Europe',
    description: 'Norwegian fjords and Scandinavian capitals',
    color: Colors.indigo,
    icon: Icons.landscape,
    region: 'Northern Europe',
  );

  static const africa = CruiseCategory(
    categoryId: 'africa',
    name: 'Africa',
    description: 'Safari meets ocean adventures along dramatic coastlines',
    color: Colors.amber,
    icon: Icons.terrain,
    region: 'Africa',
  );

  static const middleEast = CruiseCategory(
    categoryId: 'middle east',
    name: 'Middle East',
    description: 'Luxury and ancient traditions in the Arabian Gulf',
    color: Colors.deepPurple,
    icon: Icons.mosque,
    region: 'Middle East',
  );

  static const asia = CruiseCategory(
    categoryId: 'asia',
    name: 'Asia',
    description: 'Ancient cultures, modern cities, and exotic cuisines',
    color: Colors.red,
    icon: Icons.temple_buddhist,
    region: 'Asia',
  );

  static const pacific = CruiseCategory(
    categoryId: 'pacific',
    name: 'Pacific',
    description: 'Australia, New Zealand, and South Pacific islands',
    color: Colors.lightGreen,
    icon: Icons.waves,
    region: 'Pacific',
  );

  static const antarctica = CruiseCategory(
    categoryId: 'antarctica',
    name: 'Antarctica',
    description: 'Ultimate expedition to Earth\'s last frontier',
    color: Colors.lightBlue,
    icon: Icons.ac_unit,
    region: 'Antarctica',
  );

  /// All available categories
  static const List<CruiseCategory> all = [
    caribbean,
    mediterranean,
    alaska,
    hawaii,
    transatlantic,
    northernEurope,
    africa,
    middleEast,
    asia,
    pacific,
    antarctica,
  ];

  /// Get category by ID
  static CruiseCategory? getById(String categoryId) {
    try {
      return all.firstWhere((category) => category.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }
}
