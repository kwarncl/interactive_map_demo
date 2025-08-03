import 'package:flutter/material.dart';

/// Legend widget for the interactive map showing different marker types
class InteractiveMapLegend extends StatelessWidget {
  /// Constructor
  const InteractiveMapLegend({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(color: Colors.cyan, label: 'Existing Experiences'),
          _LegendItem(color: Colors.amber, label: 'Coming soon'),
        ],
      ),
    ),
  );
}

/// Individual legend item widget
class _LegendItem extends StatelessWidget {
  /// Constructor
  const _LegendItem({required this.color, required this.label});

  /// The color indicator for this legend item
  final Color color;

  /// The text label for this legend item
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
    ],
  );
}
