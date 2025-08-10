import 'package:flutter/material.dart';

import '../../models/cruise_itinerary.dart';

/// Private widget for displaying sea day information
class SeaDayInfo extends StatelessWidget {
  const SeaDayInfo({super.key, required this.day, required this.dayNumber});

  final ItineraryDay day;
  final int dayNumber;

  @override
  Widget build(BuildContext context) {
    const seaColor = Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced header for sea day
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                seaColor.withValues(alpha: 0.1),
                seaColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: seaColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: seaColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.waves, color: seaColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day at Sea',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: seaColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Day $dayNumber • ${day.dayOfWeek}, ${day.formattedDate}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: seaColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Enhanced amenities section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withValues(alpha: 0.08),
                Colors.blue.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyan.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.spa, color: Colors.cyan, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ship Amenities',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Relax and enjoy all the ship amenities - pools, spa, dining, and entertainment!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 12),
              // Activity icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActivityIcon(
                    icon: Icons.pool,
                    label: 'Pool',
                    color: Colors.blue,
                  ),
                  _ActivityIcon(
                    icon: Icons.spa,
                    label: 'Spa',
                    color: Colors.green,
                  ),
                  _ActivityIcon(
                    icon: Icons.restaurant,
                    label: 'Dining',
                    color: Colors.orange,
                  ),
                  _ActivityIcon(
                    icon: Icons.theater_comedy,
                    label: 'Shows',
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
