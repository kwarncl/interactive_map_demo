import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cruise_product.dart';
import '../models/cruise_route.dart';

/// Cruise details mode content widget (without CustomScrollView)
class CruiseDetailsModeContent extends StatelessWidget {
  const CruiseDetailsModeContent({
    super.key,
    required this.selectedCruise,
    required this.cruises,
    required this.onCruiseSelected,
    required this.onClose,
  });

  final CruiseProduct? selectedCruise;
  final List<CruiseProduct> cruises;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cruise details or featured cruises
        const SizedBox(height: 16),
        selectedCruise != null
            ? _buildEnhancedSelectedCruiseCard(context, selectedCruise!)
            : _buildEnhancedFeaturedCruises(context),
      ],
    );
  }

  /// Build cruise details header
  Widget buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Row(
        children: [
          // Cruise details icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.directions_boat, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCruise != null
                      ? 'Cruise Details'
                      : 'Featured Cruises',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  selectedCruise != null
                      ? 'Explore your selected voyage'
                      : 'Discover popular destinations',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Close button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surfaceContainerHighest,
                  theme.colorScheme.surfaceContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              tooltip: 'Close Details',
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build comprehensive cruise details view
  Widget _buildEnhancedSelectedCruiseCard(
    BuildContext context,
    CruiseProduct cruise,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main cruise info card
          _buildMainCruiseHeader(context, cruise, theme),
          const SizedBox(height: 20),

          // Quick facts grid
          _buildQuickFactsGrid(context, cruise, theme),
          const SizedBox(height: 20),

          // Detailed itinerary
          _buildDetailedItinerary(context, cruise, theme),
          const SizedBox(height: 20),

          // Ship details and amenities
          _buildShipDetails(context, cruise, theme),
          const SizedBox(height: 20),

          // Cabin options and pricing
          _buildCabinOptions(context, cruise, theme),
          const SizedBox(height: 20),

          // Departure dates
          _buildDepartureDates(context, cruise, theme),
          const SizedBox(height: 20),

          // Highlights and features
          if (cruise.highlights.isNotEmpty)
            _buildHighlightsSection(context, cruise, theme),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Build main cruise header card
  Widget _buildMainCruiseHeader(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_boat,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cruise.shipName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (cruise.shipClass != null)
                      Text(
                        '${cruise.shipClass} Class',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    '\$${cruise.pricing.startingPrice.toInt()}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'per person',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // TODO: Implement booking flow
                    },
                    icon: const Icon(Icons.book_online, size: 18),
                    label: const Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cruise.departuresText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build quick facts grid
  Widget _buildQuickFactsGrid(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Facts',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFactCard(
                context,
                Icons.schedule,
                'Duration',
                cruise.duration,
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFactCard(
                context,
                Icons.location_on,
                'Route Type',
                cruise.route.isRoundTrip ? 'Round Trip' : 'One Way',
                theme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFactCard(
                context,
                Icons.people,
                'Capacity',
                cruise.capacity != null
                    ? '${cruise.capacity} guests'
                    : 'Varies',
                theme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFactCard(
                context,
                Icons.anchor,
                'Ports',
                '${cruise.route.waypoints.length} stops',
                theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build fact card helper
  Widget _buildFactCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build detailed itinerary section
  Widget _buildDetailedItinerary(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.map, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Detailed Itinerary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children:
                cruise.route.waypoints.asMap().entries.map((entry) {
                  final index = entry.key;
                  final port = entry.value;
                  final isLast = index == cruise.route.waypoints.length - 1;

                  return _buildPortItem(
                    context,
                    port,
                    index + 1,
                    isLast,
                    theme,
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  /// Build individual port item
  Widget _buildPortItem(
    BuildContext context,
    PortLocation port,
    int dayNumber,
    bool isLast,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$dayNumber',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    port.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (port.country != null)
                    Text(
                      port.country!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (port.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      port.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.only(left: 16),
            width: 1,
            height: 20,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  /// Build ship details section
  Widget _buildShipDetails(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_boat,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Ship Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cruise.shipName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (cruise.shipClass != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${cruise.shipClass} Class Ship',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildShipFeature(Icons.restaurant, 'Multiple Dining', theme),
                  _buildShipFeature(Icons.pool, 'Pool & Spa', theme),
                  _buildShipFeature(
                    Icons.theater_comedy,
                    'Entertainment',
                    theme,
                  ),
                  _buildShipFeature(
                    Icons.fitness_center,
                    'Fitness Center',
                    theme,
                  ),
                  _buildShipFeature(Icons.wifi, 'Wi-Fi Available', theme),
                  _buildShipFeature(Icons.local_bar, 'Bars & Lounges', theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build ship feature item
  Widget _buildShipFeature(IconData icon, String feature, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          feature,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build cabin options and pricing section
  Widget _buildCabinOptions(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.hotel, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Cabin Options',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildCabinOption(
              'Interior Stateroom',
              cruise.pricing.startingPrice,
              'Cozy interior room with all essentials',
              Icons.bed,
              theme,
            ),
            const SizedBox(height: 8),
            _buildCabinOption(
              'Ocean View',
              cruise.pricing.startingPrice * 1.3,
              'Room with ocean view window',
              Icons.water,
              theme,
            ),
            const SizedBox(height: 8),
            _buildCabinOption(
              'Balcony',
              cruise.pricing.startingPrice * 1.7,
              'Private balcony with ocean views',
              Icons.balcony,
              theme,
            ),
            const SizedBox(height: 8),
            _buildCabinOption(
              'Suite',
              cruise.pricing.startingPrice * 2.5,
              'Luxury suite with premium amenities',
              Icons.king_bed,
              theme,
            ),
          ],
        ),
      ],
    );
  }

  /// Build individual cabin option
  Widget _buildCabinOption(
    String type,
    double price,
    String description,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${price.toInt()}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build departure dates section
  Widget _buildDepartureDates(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Departure Dates',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cruise.nextDeparture != null) ...[
                Text(
                  'Next Available Departure',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(cruise.nextDeparture!),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                'Additional departures available throughout the year. Contact us for full schedule and availability.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build highlights section
  Widget _buildHighlightsSection(
    BuildContext context,
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Cruise Highlights',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              cruise.highlights
                  .map(
                    (highlight) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        highlight,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  /// Helper method to format dates
  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Build enhanced featured cruises section when no cruise is selected
  Widget _buildEnhancedFeaturedCruises(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.star,
                  size: 18,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Cruises',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Popular destinations to explore',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...cruises
            .take(3)
            .map(
              (cruise) => Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.surface,
                      theme.colorScheme.surfaceContainerLowest,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onCruiseSelected(cruise),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cruise.route.routeColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.directions_boat,
                              color: cruise.route.routeColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cruise.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  cruise.duration,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${cruise.pricing.startingPrice}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
