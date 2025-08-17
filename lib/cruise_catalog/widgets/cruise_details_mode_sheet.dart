import 'package:flutter/material.dart';

import '../data/stateroom_data.dart';
import '../models/cruise_product.dart';
import 'cruise_itinerary_preview.dart';

/// Cruise details mode content widget (without CustomScrollView)
class CruiseDetailsModeContent extends StatefulWidget {
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
  State<CruiseDetailsModeContent> createState() =>
      _CruiseDetailsModeContentState();
}

class _CruiseDetailsModeContentState extends State<CruiseDetailsModeContent> {
  StateroomType _selectedStateroomType = StateroomType.inside;

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

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCruise == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '\$${widget.selectedCruise!.pricing.startingPrice.toInt()}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'per person',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Book Now'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.selectedCruise!.departuresText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Itinerary Map Preview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CruiseItineraryPreview(cruise: widget.selectedCruise!),
            ),
            const SizedBox(height: 20),

            _SectionHeader(title: 'Ship Details'),
            _ShipDetailsCard(
              shipName: widget.selectedCruise!.shipName,
              shipClass: widget.selectedCruise!.shipClass,
            ),
            const SizedBox(height: 20),

            // Stateroom options
            _SectionHeader(title: 'Stateroom Options'),
            // Stateroom type selection
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Stateroom Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 4),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  _StateroomTypeChip(
                    type: StateroomType.studio,
                    title: 'Studio Solo',
                    subtitle: 'Solo Guests Only',
                    icon: Icons.person,
                    isSelected: _selectedStateroomType == StateroomType.studio,
                    onTap:
                        (type) => setState(() => _selectedStateroomType = type),
                  ),
                  _StateroomTypeChip(
                    type: StateroomType.inside,
                    title: 'Inside',
                    subtitle:
                        'From \$${widget.selectedCruise!.pricing.startingPrice.toInt()}',
                    icon: Icons.bed,
                    isSelected: _selectedStateroomType == StateroomType.inside,
                    onTap:
                        (type) => setState(() => _selectedStateroomType = type),
                  ),
                  _StateroomTypeChip(
                    type: StateroomType.oceanview,
                    title: 'Oceanview',
                    subtitle:
                        'From \$${(widget.selectedCruise!.pricing.startingPrice * 1.3).toInt()}',
                    icon: Icons.water,
                    isSelected:
                        _selectedStateroomType == StateroomType.oceanview,
                    onTap:
                        (type) => setState(() => _selectedStateroomType = type),
                  ),
                  _StateroomTypeChip(
                    type: StateroomType.balcony,
                    title: 'Balcony',
                    subtitle:
                        'From \$${(widget.selectedCruise!.pricing.startingPrice * 1.7).toInt()}',
                    icon: Icons.balcony,
                    isSelected: _selectedStateroomType == StateroomType.balcony,
                    onTap:
                        (type) => setState(() => _selectedStateroomType = type),
                  ),
                  _StateroomTypeChip(
                    type: StateroomType.clubBalconySuite,
                    title: 'Club Balcony Suite',
                    subtitle:
                        'From \$${(widget.selectedCruise!.pricing.startingPrice * 2.0).toInt()}',
                    icon: Icons.king_bed,
                    isSelected:
                        _selectedStateroomType ==
                        StateroomType.clubBalconySuite,
                    onTap:
                        (type) => setState(() => _selectedStateroomType = type),
                  ),
                  _StateroomTypeChip(
                    type: StateroomType.haven,
                    title: 'The Haven',
                    subtitle:
                        'From \$${(widget.selectedCruise!.pricing.startingPrice * 3.0).toInt()}',
                    icon: Icons.diamond,
                    onTap:
                        (type) => setState(() => _selectedStateroomType = type),
                    isSelected: _selectedStateroomType == StateroomType.haven,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stateroom category selection
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Stateroom Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            // Horizontal scrollable stateroom cards
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 12,
                children:
                    StateroomData.getStateroomCategories(
                          _selectedStateroomType,
                          widget.selectedCruise!,
                        )
                        .map(
                          (category) => SizedBox(
                            width: 280,
                            child: _StateroomCard(
                              title: category.name,
                              price: category.price,
                              guests: category.guests,
                              size: category.size,
                              features: category.features,
                              type: category.type,
                              status: category.status,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _DepartureDatesCard(
          nextDeparture: widget.selectedCruise!.nextDeparture,
          formatDate: _formatDate,
        ),
        const SizedBox(height: 20),

        if (widget.selectedCruise!.highlights.isNotEmpty) ...[
          _HighlightsSection(highlights: widget.selectedCruise!.highlights),
          const SizedBox(height: 40),
        ],
      ],
    );
  }
}

class _StateroomCard extends StatelessWidget {
  const _StateroomCard({
    required this.title,
    required this.price,
    required this.guests,
    required this.size,
    required this.features,
    required this.type,
    required this.status,
  });

  final String title;
  final String price;
  final String guests;
  final String size;
  final String features;
  final StateroomType type;
  final StateroomStatus status;

  @override
  Widget build(BuildContext context) {
    final isAvailable =
        status == StateroomStatus.available ||
        status == StateroomStatus.recommended;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with status badge
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Icon(
                    Icons.bed,
                    size: 48,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
              if (status != StateroomStatus.available) ...[
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          status == StateroomStatus.recommended
                              ? Colors.green
                              : status == StateroomStatus.notAvailable
                              ? Colors.orange
                              : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status == StateroomStatus.recommended
                          ? 'Recommended'
                          : status == StateroomStatus.notAvailable
                          ? 'Not Available'
                          : 'Sold Out',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                // Title and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            isAvailable
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                // Details
                Text(
                  guests,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  size,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (features.isNotEmpty) ...[
                  Text(
                    features,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],

                // More details link
                Text(
                  'More Details >',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Select button
                if (isAvailable) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Select'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.directions_boat,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _StateroomTypeChip extends StatelessWidget {
  const _StateroomTypeChip({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final StateroomType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Function(StateroomType) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShipDetailsCard extends StatelessWidget {
  const _ShipDetailsCard({required this.shipName, this.shipClass});

  final String shipName;
  final String? shipClass;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shipName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (shipClass != null) ...[
            const SizedBox(height: 4),
            Text(
              '$shipClass Class Ship',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _AmenityItem(icon: Icons.restaurant, label: 'Multiple Dining'),
              _AmenityItem(icon: Icons.pool, label: 'Pool & Spa'),
              _AmenityItem(icon: Icons.theater_comedy, label: 'Entertainment'),
              _AmenityItem(icon: Icons.fitness_center, label: 'Fitness Center'),
              _AmenityItem(icon: Icons.wifi, label: 'Wi-Fi Available'),
              _AmenityItem(icon: Icons.local_bar, label: 'Bars & Lounges'),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmenityItem extends StatelessWidget {
  const _AmenityItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DepartureDatesCard extends StatelessWidget {
  const _DepartureDatesCard({
    required this.nextDeparture,
    required this.formatDate,
  });

  final DateTime? nextDeparture;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Departure Dates'),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (nextDeparture != null) ...[
                Text(
                  'Next Available Departure',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(nextDeparture!),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                'Additional departures available throughout the year. Contact us for full schedule and availability.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HighlightsSection extends StatelessWidget {
  const _HighlightsSection({required this.highlights});

  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Highlights'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                highlights
                    .map(
                      (highlight) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          highlight,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
