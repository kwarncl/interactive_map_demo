import 'package:flutter/material.dart';
import 'package:interactive_map_demo/itinerary/models/cruise_itinerary.dart';

/// Private widget for rendering individual port markers with styling and selection states
class PortMarker extends StatelessWidget {
  const PortMarker({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final ItineraryDay day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Determine marker styling based on day type
    Color primaryColor;
    IconData markerIcon;
    bool isHomePort = false;

    switch (day.dayType) {
      case ItineraryDayType.embarkation:
      case ItineraryDayType.disembarkation:
        primaryColor = const Color(0xFF1E3A8A); // Navy blue
        markerIcon = Icons.anchor;
        isHomePort = true;
        break;
      case ItineraryDayType.port:
        primaryColor = const Color(0xFF1E40AF); // Royal blue
        markerIcon = Icons.location_on;
        break;
      case ItineraryDayType.sea:
        return const SizedBox.shrink(); // No marker for sea days
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modern pin-style marker
            Stack(
              alignment: Alignment.center,
              children: [
                // Pin shadow
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2, left: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                ),
                // Main pin body
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    markerIcon,
                    color: Colors.white,
                    size: isHomePort ? 16 : 14,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
