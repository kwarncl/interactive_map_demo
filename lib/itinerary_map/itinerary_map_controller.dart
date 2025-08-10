// Controller intentionally has no Flutter or meta imports to keep it lightweight.
import 'package:interactive_map_demo/itinerary_map/models/cruise_itinerary.dart';

/// Public controller to imperatively interact with `ItineraryMap`.
///
/// Typical usage:
///
/// ```dart
/// final controller = ItineraryMapController();
///
/// ItineraryMap(
///   controller: controller,
///   // ...
/// );
///
/// // Later
/// controller.selectDay(day);
/// controller.centerToBounds();
/// controller.centerToProgress(0.65);
/// ```
class ItineraryMapController {
  void Function(ItineraryDay day)? _selectDay;
  void Function(double progress, {bool animate})? _centerToProgress;
  void Function({bool animate})? _centerToBounds;

  /// Select a specific day on the map (updates camera and UI).
  void selectDay(ItineraryDay day) {
    _selectDay?.call(day);
  }

  /// Center the camera to a normalized route progress (0..1).
  void centerToProgress(double progress, {bool animate = true}) {
    _centerToProgress?.call(progress, animate: animate);
  }

  /// Zoom out and center to show the entire route bounds.
  void centerToBounds({bool animate = true}) {
    _centerToBounds?.call(animate: animate);
  }

  void bind({
    required void Function(ItineraryDay day) selectDay,
    required void Function(double progress, {bool animate}) centerToProgress,
    required void Function({bool animate}) centerToBounds,
  }) {
    _selectDay = selectDay;
    _centerToProgress = centerToProgress;
    _centerToBounds = centerToBounds;
  }

  void unbind() {
    _selectDay = null;
    _centerToProgress = null;
    _centerToBounds = null;
  }
}
