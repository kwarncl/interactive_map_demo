import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../../common/map_utilities.dart';
import '../../common/widgets/custom_marker.dart';
import '../models/cruise_itinerary.dart';

typedef ItineraryMarkerBuilder =
    Widget Function(BuildContext context, ItineraryDay day, bool isSelected);

typedef ItineraryPopupBuilder =
    Widget Function(BuildContext context, ItineraryDay day);

class ItineraryMapMarkers extends StatefulWidget {
  const ItineraryMapMarkers({
    super.key,
    required this.itineraryDays,
    required this.onDaySelected,
    required this.selectedItineraryDay,
    required this.uniquePortDays,
    this.markerBuilder,
    this.popupBuilder,
  });

  final List<ItineraryDay> itineraryDays;
  final ValueChanged<ItineraryDay> onDaySelected;
  final ItineraryDay selectedItineraryDay;
  final List<ItineraryDay> uniquePortDays;
  final ItineraryMarkerBuilder? markerBuilder;
  final ItineraryPopupBuilder? popupBuilder;

  @override
  State<ItineraryMapMarkers> createState() => _ItineraryMapMarkersState();
}

class _ItineraryMapMarkersState extends State<ItineraryMapMarkers> {
  late List<ItineraryDay> _uniquePortDays;
  late List<Marker> _markers;
  Key _layerKey = const ValueKey<String>('markers-initial');
  late Map<String, ItineraryDay> _portIdToDay;

  @override
  void initState() {
    super.initState();
    _uniquePortDays = widget.uniquePortDays;
    _markers = const <Marker>[];
    _portIdToDay = <String, ItineraryDay>{};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _markers = _buildMarkers(_uniquePortDays);
    _portIdToDay = _buildPortIdMap(_uniquePortDays);
    _layerKey = ValueKey<String>(
      'markers-${_markers.length}-${widget.selectedItineraryDay.port?.id ?? 'sea'}',
    );
  }

  @override
  void didUpdateWidget(covariant ItineraryMapMarkers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.uniquePortDays, widget.uniquePortDays) ||
        !identical(oldWidget.itineraryDays, widget.itineraryDays) ||
        oldWidget.selectedItineraryDay != widget.selectedItineraryDay) {
      _uniquePortDays = widget.uniquePortDays;
      _markers = _buildMarkers(_uniquePortDays);
      _portIdToDay = _buildPortIdMap(_uniquePortDays);
      _layerKey = ValueKey<String>(
        'markers-${_markers.length}-${widget.selectedItineraryDay.port?.id ?? 'sea'}',
      );
    }
  }

  List<Marker> _buildMarkers(List<ItineraryDay> uniquePortDays) {
    final String? selectedPortId = widget.selectedItineraryDay.port?.id;
    final List<Marker> nonSelectedMarkers = <Marker>[];
    Marker? selectedMarker;

    for (final ItineraryDay day in uniquePortDays) {
      final String portId = day.port!.id;
      final bool isSelected =
          selectedPortId != null && portId == selectedPortId;
      final Marker marker = Marker(
        key: ValueKey<String>(portId),
        point: MapUtilities.toLatLng(day.port!.coordinates),
        child:
            widget.markerBuilder?.call(context, day, isSelected) ??
            CustomMarker(
              icon: switch (day.dayType) {
                ItineraryDayType.embarkation => Icons.anchor,
                ItineraryDayType.disembarkation => Icons.anchor,
                ItineraryDayType.port => Icons.location_on,
                ItineraryDayType.sea => Icons.location_on,
              },
              color: Theme.of(context).colorScheme.primary,
              isHomePort:
                  day.dayType == ItineraryDayType.embarkation ||
                  day.dayType == ItineraryDayType.disembarkation,
              isSelected: isSelected,
              onTap: () => widget.onDaySelected(day),
            ),
      );
      if (isSelected) {
        selectedMarker = marker;
      } else {
        nonSelectedMarkers.add(marker);
      }
    }

    // Ensure the selected marker is last so it renders on top of others
    if (selectedMarker != null) nonSelectedMarkers.add(selectedMarker);
    return nonSelectedMarkers;
  }

  Map<String, ItineraryDay> _buildPortIdMap(List<ItineraryDay> uniquePortDays) {
    final Map<String, ItineraryDay> idToDay = <String, ItineraryDay>{};
    for (final ItineraryDay day in uniquePortDays) {
      final String id = day.port!.id;
      idToDay[id] = day;
    }
    return idToDay;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMarkerLayer(
      key: _layerKey,
      options: PopupMarkerLayerOptions(
        markers: _markers,
        initiallySelected: _markers.map(PopupSpec.wrap).toList(growable: false),
        popupDisplayOptions: PopupDisplayOptions(
          builder: (BuildContext context, Marker marker) {
            // Use the marker's ValueKey (port id) to resolve its label
            // instead of relying on index order, which changes when
            // we reorder markers to bring the selected one on top.
            ItineraryDay? day;
            final Key? key = marker.key;
            if (key is ValueKey<String>) {
              day = _portIdToDay[key.value];
            }
            day ??= _uniquePortDays.firstWhere(
              (d) => MapUtilities.toLatLng(d.port!.coordinates) == marker.point,
              orElse: () => _uniquePortDays.first,
            );
            final String label = day.port?.name ?? 'Sea';
            if (widget.popupBuilder != null) {
              return widget.popupBuilder!(context, day);
            }

            return Semantics(
              label: 'Port: $label',
              child: Card(
                elevation: 4,
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
