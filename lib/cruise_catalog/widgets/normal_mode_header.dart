import 'package:flutter/material.dart';

import '../models/cruise_product.dart';

/// Standalone header widget for normal mode
class NormalModeHeader extends StatelessWidget {
  const NormalModeHeader({
    super.key,
    required this.showSearch,
    required this.cruises,
    required this.onMapReset,
    required this.onSearchToggled,
    required this.onCruiseSelected,
    required this.onSearchChanged,
  });

  final bool showSearch;
  final List<CruiseProduct> cruises;
  final VoidCallback onMapReset;
  final VoidCallback onSearchToggled;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and controls
          Row(
            children: [
              // Enhanced title with icon
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore Cruises',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Find your perfect voyage',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced control buttons
              Row(
                children: [
                  // Map reset button with enhanced design
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                          Theme.of(context).colorScheme.surfaceContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: onMapReset,
                      icon: const Icon(Icons.public),
                      tooltip: 'Reset to Miami View',
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Enhanced search toggle button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            showSearch
                                ? [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.8),
                                ]
                                : [
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainer,
                                ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              showSearch
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.3)
                                  : Theme.of(
                                    context,
                                  ).shadowColor.withValues(alpha: 0.1),
                          blurRadius: showSearch ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: onSearchToggled,
                      icon: Icon(
                        showSearch ? Icons.close : Icons.search,
                        color:
                            showSearch
                                ? Colors.white
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                      ),
                      tooltip: showSearch ? 'Close Search' : 'Search Cruises',
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
