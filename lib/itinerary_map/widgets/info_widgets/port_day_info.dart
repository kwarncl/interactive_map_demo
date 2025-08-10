import 'package:flutter/material.dart';

import '../../models/cruise_itinerary.dart';
import 'info_tile.dart';

/// Private widget for displaying port day information
class PortDayInfo extends StatelessWidget {
  const PortDayInfo({super.key, required this.day, required this.dayNumber});

  final ItineraryDay day;
  final int dayNumber;

  Color _getPortColor() {
    switch (day.dayType) {
      case ItineraryDayType.embarkation:
      case ItineraryDayType.disembarkation:
        return Colors.green;
      case ItineraryDayType.port:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getPortIcon() {
    switch (day.dayType) {
      case ItineraryDayType.embarkation:
        return Icons.flight_takeoff;
      case ItineraryDayType.disembarkation:
        return Icons.flight_land;
      case ItineraryDayType.port:
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    final port = day.port!;
    final portColor = _getPortColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced header with better visual hierarchy
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                portColor.withValues(alpha: 0.1),
                portColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: portColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: portColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getPortIcon(), color: portColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      port.fullName,
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
                        color: portColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Day $dayNumber • ${day.dayType.displayName}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: portColor,
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

        // Enhanced info tiles with color coordination
        Row(
          children: [
            Expanded(
              child: InfoTile(
                label: 'Date',
                value: '${day.dayOfWeek}, ${day.formattedDate}',
                icon: Icons.calendar_today,
                color: Colors.blue,
              ),
            ),
            if (day.arrivalTime != null)
              Expanded(
                child: InfoTile(
                  label: 'Arrive',
                  value: day.formattedArrivalTime,
                  icon: Icons.flight_land,
                  color: Colors.green,
                ),
              ),
            if (day.departureTime != null)
              Expanded(
                child: InfoTile(
                  label: 'Depart',
                  value: day.formattedDepartureTime,
                  icon: Icons.flight_takeoff,
                  color: Colors.orange,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
