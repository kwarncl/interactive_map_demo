import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cruise_itinerary.dart';
import 'port_day_info.dart';
import 'sea_day_info.dart';

/// Draggable bottom section with day navigation and content
class ItineraryBottomSection extends StatefulWidget {
  const ItineraryBottomSection({
    super.key,
    required this.day,
    required this.itinerary,
    required this.onDaySelected,
    required this.onHeightChanged,
  });

  final ItineraryDay day;
  final CruiseItinerary itinerary;
  final Function(ItineraryDay)? onDaySelected;
  final Function(double)? onHeightChanged;

  @override
  State<ItineraryBottomSection> createState() => _ItineraryBottomSectionState();
}

class _ItineraryBottomSectionState extends State<ItineraryBottomSection> {
  late ScrollController _dayIndicatorController;

  @override
  void initState() {
    super.initState();
    _dayIndicatorController = ScrollController();

    // Scroll to current day after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }

  @override
  void didUpdateWidget(ItineraryBottomSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the day changed, scroll to the new current day
    if (oldWidget.day != widget.day) {
      _scrollToCurrentDay();
    }
  }

  @override
  void dispose() {
    _dayIndicatorController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDay() {
    if (!_dayIndicatorController.hasClients) return;

    final currentDayIndex = widget.itinerary.days.indexOf(widget.day);
    if (currentDayIndex == -1) return;

    // Calculate scroll position to center the selected day
    // Each day indicator is 36px wide (28-32px + 8px margin)
    const itemWidth = 36.0;
    final targetPosition = currentDayIndex * itemWidth;

    // Get the viewport width and calculate center offset
    final viewportWidth = _dayIndicatorController.position.viewportDimension;
    final centerOffset = viewportWidth / 2 - itemWidth / 2;
    final scrollPosition = (targetPosition - centerOffset).clamp(
      0.0,
      _dayIndicatorController.position.maxScrollExtent,
    );

    _dayIndicatorController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _navigateToDay(int direction) {
    final currentDayIndex = widget.itinerary.days.indexOf(widget.day);
    final newIndex = currentDayIndex + direction;

    if (newIndex >= 0 && newIndex < widget.itinerary.days.length) {
      HapticFeedback.lightImpact();
      widget.onDaySelected?.call(widget.itinerary.days[newIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDayIndex = widget.itinerary.days.indexOf(widget.day);
    final totalDays = widget.itinerary.days.length;
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return DraggableScrollableSheet(
      initialChildSize: 250.0 / screenHeight,
      minChildSize: 250.0 / screenHeight,
      maxChildSize: 0.8,
      snap: true,
      snapSizes: [250.0 / screenHeight, 0.8],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, -8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.08),
                blurRadius: 40,
                offset: const Offset(0, -4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Fixed header with navigation
              _buildFixedHeader(currentDayIndex, totalDays, theme),

              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildScrollableContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFixedHeader(
    int currentDayIndex,
    int totalDays,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Day progress and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous day button
              _buildNavigationButton(
                icon: Icons.chevron_left,
                enabled: currentDayIndex > 0,
                onTap: () => _navigateToDay(-1),
                theme: theme,
              ),

              // Day indicators with numbers
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: ListView.builder(
                    controller: _dayIndicatorController,
                    scrollDirection: Axis.horizontal,
                    itemCount: totalDays,
                    itemBuilder: (context, index) {
                      final isActive = index == currentDayIndex;
                      final dayNumber = index + 1;

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onDaySelected?.call(
                            widget.itinerary.days[index],
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 32 : 28,
                          height: isActive ? 32 : 28,
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                isActive
                                    ? null
                                    : Border.all(
                                      color: theme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                          ),
                          child: Center(
                            child: Text(
                              '$dayNumber',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color:
                                    isActive
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                fontWeight:
                                    isActive
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Next day button
              _buildNavigationButton(
                icon: Icons.chevron_right,
                enabled: currentDayIndex < totalDays - 1,
                onTap: () => _navigateToDay(1),
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color:
                enabled
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
            borderRadius: BorderRadius.circular(8),
            border:
                enabled
                    ? Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    )
                    : null,
          ),
          child: Icon(
            icon,
            color:
                enabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildDayContent() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        final currentDayIndex = widget.itinerary.days.indexOf(widget.day);
        final totalDays = widget.itinerary.days.length;

        // Swipe right = previous day, Swipe left = next day
        if (details.primaryVelocity! > 0 && currentDayIndex > 0) {
          _navigateToDay(-1);
        } else if (details.primaryVelocity! < 0 &&
            currentDayIndex < totalDays - 1) {
          _navigateToDay(1);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child:
            widget.day.dayType == ItineraryDayType.sea
                ? SeaDayInfo(day: widget.day, itinerary: widget.itinerary)
                : PortDayInfo(day: widget.day, itinerary: widget.itinerary),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return Column(
      children: [
        // Current day content
        _buildDayContent(),

        // Expanded content for additional details
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.day.dayType != ItineraryDayType.sea) ...[
                _buildPortDetailsSection(),
                const SizedBox(height: 16),
                _buildActivitiesSection(),
              ] else ...[
                _buildShipActivitiesSection(),
                const SizedBox(height: 16),
                _buildDiningSection(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortDetailsSection() {
    final theme = Theme.of(context);
    final port = widget.day.port!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${port.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            port.description.isNotEmpty
                ? port.description
                : 'Discover the beauty and culture of ${port.name}, ${port.country}. A wonderful destination with rich history, stunning landscapes, and unique local experiences.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection() {
    final theme = Theme.of(context);
    final activities =
        widget.day.activities.isNotEmpty
            ? widget.day.activities
            : [
              'Beach exploration',
              'Local shopping',
              'Cultural tours',
              'Water sports',
              'Historic sites',
            ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Activities',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipActivitiesSection() {
    final theme = Theme.of(context);
    final activities = [
      {'icon': Icons.pool, 'title': 'Pool Deck', 'time': '6:00 AM - 11:00 PM'},
      {
        'icon': Icons.spa,
        'title': 'Spa & Wellness',
        'time': '8:00 AM - 8:00 PM',
      },
      {
        'icon': Icons.fitness_center,
        'title': 'Fitness Center',
        'time': '24/7 Access',
      },
      {
        'icon': Icons.restaurant,
        'title': 'Specialty Dining',
        'time': '5:30 PM - 10:00 PM',
      },
      {
        'icon': Icons.theater_comedy,
        'title': 'Evening Shows',
        'time': '7:00 PM & 9:30 PM',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Ship Activities',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...activities.map(
            (activity) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    activity['icon'] as IconData,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          activity['time'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiningSection() {
    final theme = Theme.of(context);
    final diningOptions = [
      {'title': 'Main Dining Room', 'description': 'Breakfast, Lunch & Dinner'},
      {'title': 'Buffet', 'description': 'All-day dining'},
      {
        'title': 'Specialty Restaurants',
        'description': 'Premium dining experiences',
      },
      {'title': 'Room Service', 'description': '24/7 available'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dining Options',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...diningOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.restaurant, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option['title'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          option['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
