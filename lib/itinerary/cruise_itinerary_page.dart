import 'package:flutter/material.dart';

import 'models/cruise_itinerary.dart';
import 'widgets/itinerary_map.dart';

/// Interactive cruise itinerary map page
class CruiseItineraryPage extends StatefulWidget {
  const CruiseItineraryPage({super.key, required this.itinerary});

  final CruiseItinerary itinerary;

  @override
  State<CruiseItineraryPage> createState() => _CruiseItineraryPageState();
}

class _CruiseItineraryPageState extends State<CruiseItineraryPage> {
  ItineraryDay? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Start with first port day
    final portDays =
        widget.itinerary.days.where((day) => day.port != null).toList();
    if (portDays.isNotEmpty) {
      _selectedDay = portDays.first;
    }
  }

  void _onDaySelected(ItineraryDay day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.itinerary.cruiseName)),
      body: ItineraryMap(
        itinerary: widget.itinerary,
        selectedDay: _selectedDay,
        onDaySelected: _onDaySelected,
      ),
    );
  }
}
