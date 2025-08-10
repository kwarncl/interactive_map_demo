import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_map_demo/common/widgets/custom_draggable_sheet.dart';

import '../models/cruise_itinerary.dart';
import 'info_widgets/port_day_info.dart';
import 'info_widgets/sea_day_info.dart';

/// Draggable bottom section with day navigation and content
class ItineraryMapBottomSheet extends StatefulWidget {
  const ItineraryMapBottomSheet({
    super.key,
    required this.day,
    required this.cruiseTitle,
    required this.itineraryDays,
    required this.selectedItineraryDay,
    required this.onDaySelected,
    required this.onHeightChanged,
  });

  final String cruiseTitle;
  final List<ItineraryDay> itineraryDays;
  final ItineraryDay selectedItineraryDay;
  final ItineraryDay day;
  final ValueChanged<ItineraryDay>? onDaySelected;
  final ValueChanged<double>? onHeightChanged;

  @override
  State<ItineraryMapBottomSheet> createState() =>
      _ItineraryMapBottomSheetState();
}

class _ItineraryMapBottomSheetState extends State<ItineraryMapBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _lastEmittedIndex;

  void _onControllerIndexChanged() {
    if (!mounted) return;
    final int newIndex = _tabController.index;
    if (newIndex < 0 || newIndex >= widget.itineraryDays.length) return;
    final int currentIndex = widget.itineraryDays.indexOf(widget.day);
    if (currentIndex == newIndex) return; // Already in sync with parent
    if (_lastEmittedIndex == newIndex) return; // Avoid duplicates
    _lastEmittedIndex = newIndex;
    HapticFeedback.selectionClick();
    widget.onDaySelected?.call(widget.itineraryDays[newIndex]);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.itineraryDays.length,
      vsync: this,
      initialIndex: widget.itineraryDays.indexOf(widget.day),
      animationDuration: Duration.zero,
    );
    _tabController.addListener(_onControllerIndexChanged);

    // Set initial tab to current day
    final currentIndex = widget.itineraryDays.indexOf(widget.day);
    if (currentIndex != -1) {
      _tabController.index = currentIndex;
      _lastEmittedIndex = currentIndex;
    }
  }

  @override
  void didUpdateWidget(ItineraryMapBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the day changed, update the tab
    if (oldWidget.day != widget.day) {
      final currentIndex = widget.itineraryDays.indexOf(widget.day);
      if (currentIndex != -1 && _tabController.index != currentIndex) {
        _tabController.animateTo(currentIndex);
      }
      // Ensure we do not emit the same index back to parent
      _lastEmittedIndex = currentIndex;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onControllerIndexChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDraggableSheet(
      slivers: [
        // AppBar with TabBar
        SliverAppBar(
          pinned: true,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(widget.cruiseTitle),
          bottom: TabBar(
            controller: _tabController,
            onTap: (int index) {
              if (index < 0 || index >= widget.itineraryDays.length) return;
              if (_lastEmittedIndex == index) return;
              _lastEmittedIndex = index;
              HapticFeedback.selectionClick();
              widget.onDaySelected?.call(widget.itineraryDays[index]);
            },
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs:
                widget.itineraryDays.asMap().entries.map((entry) {
                  final day = entry.value;
                  final String label =
                      'Day ${day.dayNumber} - ${day.port?.name ?? 'Sea'}';
                  return Semantics(
                    label: label,
                    button: true,
                    selected: day == widget.selectedItineraryDay,
                    child: Tab(text: label),
                  );
                }).toList(),
          ),
        ),

        // Scrollable content for selected tab integrated in outer sliver scroll
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children:
                widget.itineraryDays.map((day) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        day.dayType == ItineraryDayType.sea
                            ? SeaDayInfo(
                              day: day,
                              dayNumber: widget.itineraryDays.indexOf(day) + 1,
                            )
                            : PortDayInfo(
                              day: day,
                              dayNumber: widget.itineraryDays.indexOf(day) + 1,
                            ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
