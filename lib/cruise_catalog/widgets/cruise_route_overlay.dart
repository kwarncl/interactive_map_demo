import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:interactive_map_demo/common/widgets/custom_polyline_layer.dart';

import '../models/cruise_product.dart';
import '../models/cruise_route.dart';

/// Overlay widget that renders a cruise route on the map with zoom-based styling
class CruiseRouteOverlay extends StatelessWidget {
  const CruiseRouteOverlay({
    super.key,
    required this.cruise,
    required this.isSelected,
    required this.onTap,
    required this.onPortTap,
    required this.animationController,
    required this.currentZoomTier,
    required this.hasSelectedCruise,
    required this.isRecentlyDeselected,
  });

  final CruiseProduct cruise;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(PortLocation) onPortTap;
  final AnimationController animationController;
  final CruiseZoomTier currentZoomTier;
  final bool hasSelectedCruise;
  final bool isRecentlyDeselected;

  /// Get stroke width based on zoom tier and selection state
  double get _strokeWidth {
    if (isSelected) return 4.0;

    switch (currentZoomTier) {
      case CruiseZoomTier.essential:
        return 2.0; // Thinner lines at world view
      case CruiseZoomTier.medium:
        return 2.5; // Standard thickness
      case CruiseZoomTier.detailed:
        return 3.0; // Thicker lines when zoomed in
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate overall cruise opacity (for entire route appearing/disappearing)
    final cruiseOpacity = _calculateCruiseOpacity();

    return AnimatedOpacity(
      opacity: cruiseOpacity,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Stack(
        children: [
          // Clickable route polyline with zoom-based styling (straight)
          GestureDetector(
            onTap: onTap,
            child: PolylineLayer(
              polylines: [
                Polyline(
                  points: cruise.route.coordinates,
                  strokeWidth: _strokeWidth + 4.0,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),

          // Visible straight route polyline via custom layer
          CustomPolylineLayer(
            points: cruise.route.coordinates,
            strokeWidth: _strokeWidth,
            color:
                isSelected
                    ? cruise.route.routeColor.withValues(alpha: 0.6)
                    : cruise.route.routeColor.withValues(alpha: 0.4),
            borderStrokeWidth: isSelected ? 6.0 : 0.0,
          ),

          // Port markers with city names - with individual marker animations
          MarkerLayer(markers: _buildPortMarkersWithNames(context)),
        ],
      ),
    );
  }

  /// Get appropriate icon for port based on position
  IconData _getPortIcon(int index, int totalPorts) {
    if (index == 0) {
      // Embark port - cruise ship icon
      return Icons.directions_boat;
    } else if (index == totalPorts - 1) {
      // Disembark port - anchor icon
      return Icons.anchor;
    } else {
      // Middle waypoints - location pin
      return Icons.location_on_outlined;
    }
  }

  /// Calculate the overall opacity for the entire cruise route
  double _calculateCruiseOpacity() {
    // If cruise is selected, always show with full opacity
    if (isSelected) {
      return 1.0;
    }

    // If this is the recently deselected cruise, keep it visible for better UX
    if (isRecentlyDeselected) {
      return 1.0;
    }

    // Check if this cruise should be visible based on its zoom tier
    switch (cruise.zoomTier) {
      case CruiseZoomTier.essential:
        // Essential/featured cruises are always visible
        return 1.0;
      case CruiseZoomTier.medium:
        // Medium cruises visible at medium and detailed zoom
        return (currentZoomTier == CruiseZoomTier.medium ||
                currentZoomTier == CruiseZoomTier.detailed)
            ? 1.0
            : 0.0;
      case CruiseZoomTier.detailed:
        // Detailed cruises only visible at detailed zoom
        return currentZoomTier == CruiseZoomTier.detailed ? 1.0 : 0.0;
    }
  }

  /// Calculate the target opacity for a marker based on zoom tier and selection state
  double _calculateMarkerOpacity(int index, bool isStartEnd) {
    // If cruise is selected, always show all pins with full opacity
    if (isSelected) {
      return 1.0;
    }

    // If another cruise is selected, hide all labels from this cruise to avoid clashing
    if (hasSelectedCruise && !isSelected) {
      return 0.0;
    }

    // Individual marker visibility based on zoom tier
    // (cruise-level visibility is handled by _calculateCruiseOpacity)
    switch (currentZoomTier) {
      case CruiseZoomTier.essential:
        // At essential tier (zoom 3,4): show only embark/disembark pins
        return isStartEnd ? 1.0 : 0.0;
      case CruiseZoomTier.medium:
      case CruiseZoomTier.detailed:
        // At medium+ tiers: show all pins
        return 1.0;
    }
  }

  /// Build markers for all ports in the route with city names
  List<Marker> _buildPortMarkersWithNames(BuildContext context) {
    // Build all markers but use animated opacity to show/hide them smoothly
    return cruise.route.waypoints.asMap().entries.map((entry) {
      final index = entry.key;
      final port = entry.value;
      final isStartEnd =
          index == 0 || index == cruise.route.waypoints.length - 1;

      // Calculate target opacity for this marker based on visibility rules
      final targetOpacity = _calculateMarkerOpacity(index, isStartEnd);

      return Marker(
        point: port.latLng,
        width: 86,
        height: isStartEnd ? 42 : 38,
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: targetOpacity,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: GestureDetector(
            onTap: () => onPortTap(port),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // City name label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? cruise.route.routeColor.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cruise.route.routeColor.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 2,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Text(
                    port.name,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 1),
                // Port marker pin with specific icons for embark/disembark
                Container(
                  width: isStartEnd ? 22 : 18,
                  height: isStartEnd ? 22 : 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isStartEnd
                            ? cruise.route.routeColor
                            : cruise.route.routeColor.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: isSelected ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getPortIcon(index, cruise.route.waypoints.length),
                    color: Colors.white,
                    size: isStartEnd ? 14 : 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
