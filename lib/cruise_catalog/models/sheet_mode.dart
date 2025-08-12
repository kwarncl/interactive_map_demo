/// Sheet mode enum for controlling draggable sheet behavior
enum SheetMode {
  /// Normal browsing mode
  normal,

  /// Search mode with expanded sheet
  search,

  /// Cruise details mode
  cruiseDetails,
}

/// Sheet position enum for standardized sheet heights
enum SheetPosition {
  /// Hidden state - 12% of screen height
  hidden(0.12),

  /// Normal browsing state - 30% of screen height
  normal(0.3),

  /// Full screen state - 100% of screen height
  fullScreen(1.0);

  const SheetPosition(this.value);

  /// The fractional height value (0.0 to 1.0)
  final double value;
}
