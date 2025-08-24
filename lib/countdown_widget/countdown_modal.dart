import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'models/cruise_countdown.dart';
import 'widgets/simple_countdown_widget.dart';

class CountdownModal extends StatefulWidget {
  const CountdownModal({super.key, required this.cruises});

  final List<CruiseCountdown> cruises;

  @override
  State<CountdownModal> createState() => _CountdownModalState();
}

class _CountdownModalState extends State<CountdownModal> {
  CruiseCountdown? _selectedCruise;

  Future<void> _updateHomeWidget(CruiseCountdown cruise) async {
    try {
      // Set App Group ID for iOS
      await HomeWidget.setAppGroupId('group.com.example.interactiveMapDemo');

      // Save cruise data to home widget
      await HomeWidget.saveWidgetData<String>('cruise_name', cruise.cruiseName);
      await HomeWidget.saveWidgetData<String>('ship_name', cruise.shipName);
      await HomeWidget.saveWidgetData<String>(
        'destination',
        cruise.destination,
      );
      await HomeWidget.saveWidgetData<String>(
        'departure_date',
        cruise.departureDate.toIso8601String(),
      );
      await HomeWidget.saveWidgetData<int>(
        'days_remaining',
        cruise.departureDate.difference(DateTime.now()).inDays,
      );
      await HomeWidget.saveWidgetData<bool>('has_data', true);

      // Update the widget
      await HomeWidget.updateWidget(
        name: 'CountdownWidget',
        iOSName: 'CountdownWidget',
      );
    } catch (e) {
      log('Failed to update home widget: $e');
    }
  }

  Future<void> _clearHomeWidget() async {
    try {
      // Set App Group ID for iOS
      await HomeWidget.setAppGroupId('group.com.example.interactiveMapDemo');

      // Clear cruise data from home widget
      await HomeWidget.saveWidgetData<String>('cruise_name', '');
      await HomeWidget.saveWidgetData<String>('ship_name', '');
      await HomeWidget.saveWidgetData<String>('destination', '');
      await HomeWidget.saveWidgetData<String>('departure_date', '');
      await HomeWidget.saveWidgetData<int>('days_remaining', 0);
      await HomeWidget.saveWidgetData<bool>('has_data', false);

      // Update the widget
      await HomeWidget.updateWidget(
        name: 'CountdownWidget',
        iOSName: 'CountdownWidget',
      );
    } catch (e) {
      log('Failed to clear home widget: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upcoming Cruises')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Add this app\'s widget to your home screen and then select a cruise to see the changes. Try out different widget sizes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.cruises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cruise = widget.cruises[index];
                return CruiseCountdownCard(
                  cruise: cruise,
                  isSelected: _selectedCruise == cruise,
                  onTap: () async {
                    setState(() {
                      _selectedCruise =
                          _selectedCruise == cruise ? null : cruise;
                    });

                    // Update home widget if a cruise is selected
                    if (_selectedCruise == cruise) {
                      await _updateHomeWidget(cruise);
                    } else {
                      await _clearHomeWidget();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CruiseCountdownCard extends StatelessWidget {
  const CruiseCountdownCard({
    required this.cruise,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final CruiseCountdown cruise;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        cruise.cruiseName,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        cruise.shipName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.8)
                                  : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
            Text(
              cruise.destination,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  '${cruise.departureDate.day}/${cruise.departureDate.month}/${cruise.departureDate.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                SimpleCountdownWidget(
                  departureDate: cruise.departureDate,
                  compact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
