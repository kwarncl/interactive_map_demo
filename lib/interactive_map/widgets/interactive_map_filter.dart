import 'package:flutter/material.dart';

/// Marker categories for filtering
enum MarkerCategory {
  dining,
  waterActivities,
  transportation,
  entertainment,
  facilities,
}

/// Extension to get display properties for marker categories
extension MarkerCategoryExtension on MarkerCategory {
  String get label {
    switch (this) {
      case MarkerCategory.dining:
        return 'Dining & Bars';
      case MarkerCategory.waterActivities:
        return 'Water Activities';
      case MarkerCategory.transportation:
        return 'Transportation';
      case MarkerCategory.entertainment:
        return 'Entertainment';
      case MarkerCategory.facilities:
        return 'Facilities';
    }
  }

  IconData get icon {
    switch (this) {
      case MarkerCategory.dining:
        return Icons.restaurant;
      case MarkerCategory.waterActivities:
        return Icons.pool;
      case MarkerCategory.transportation:
        return Icons.directions_boat;
      case MarkerCategory.entertainment:
        return Icons.music_note;
      case MarkerCategory.facilities:
        return Icons.location_on;
    }
  }

  Color get color {
    switch (this) {
      case MarkerCategory.dining:
        return Colors.orange;
      case MarkerCategory.waterActivities:
        return Colors.blue;
      case MarkerCategory.transportation:
        return Colors.purple;
      case MarkerCategory.entertainment:
        return Colors.pink;
      case MarkerCategory.facilities:
        return Colors.green;
    }
  }
}

/// Filter state data
class FilterState {
  const FilterState({
    this.visibleCategories = const {
      MarkerCategory.dining,
      MarkerCategory.waterActivities,
      MarkerCategory.transportation,
      MarkerCategory.entertainment,
      MarkerCategory.facilities,
    },
  });

  final Set<MarkerCategory> visibleCategories;

  FilterState copyWith({Set<MarkerCategory>? visibleCategories}) => FilterState(
    visibleCategories: visibleCategories ?? this.visibleCategories,
  );

  bool isCategoryVisible(MarkerCategory category) =>
      visibleCategories.contains(category);
}

/// Filter widget for the interactive map
class InteractiveMapFilter extends StatefulWidget {
  const InteractiveMapFilter({
    required this.onFilterChanged,
    this.initialState = const FilterState(),
    this.isExpanded = false,
    this.onExpandChanged,
    super.key,
  });

  final ValueChanged<FilterState> onFilterChanged;
  final FilterState initialState;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandChanged;

  @override
  State<InteractiveMapFilter> createState() => _InteractiveMapFilterState();
}

class _InteractiveMapFilterState extends State<InteractiveMapFilter>
    with TickerProviderStateMixin {
  late FilterState _filterState;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _filterState = widget.initialState;

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5, // 180 degrees (0.5 * 2π)
    ).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeInOut),
    );

    // Set initial animation state
    if (widget.isExpanded) {
      _expandController.value = 1.0;
    }
  }

  void _toggleCategory(MarkerCategory category) {
    setState(() {
      final Set<MarkerCategory> newCategories = Set.from(
        _filterState.visibleCategories,
      );
      if (newCategories.contains(category)) {
        newCategories.remove(category);
      } else {
        newCategories.add(category);
      }
      _filterState = _filterState.copyWith(visibleCategories: newCategories);
    });
    widget.onFilterChanged(_filterState);
  }

  @override
  void didUpdateWidget(InteractiveMapFilter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // React to expansion state changes from parent
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    widget.onExpandChanged?.call(!widget.isExpanded);
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Header with filter icon and toggle
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _iconRotationAnimation,
                  builder:
                      (context, child) => Transform.rotate(
                        angle:
                            _iconRotationAnimation.value *
                            3.14159, // Convert to radians
                        child: const Icon(
                          Icons.expand_more,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                ),
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.filter_list, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),

        // Animated expandable filter options
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: FadeTransition(
            opacity: _expandAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(color: Colors.white24, height: 1, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:
                        MarkerCategory.values.map((category) {
                          final bool isVisible = _filterState.isCategoryVisible(
                            category,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: GestureDetector(
                              onTap: () => _toggleCategory(category),
                              child: Row(
                                spacing: 4,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      category.label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color:
                                            isVisible
                                                ? Colors.white
                                                : Colors.white54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    category.icon,
                                    size: 14,
                                    color:
                                        isVisible
                                            ? Colors.white
                                            : Colors.white54,
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color:
                                          isVisible
                                              ? category.color
                                              : Colors.transparent,
                                      border: Border.all(
                                        color:
                                            isVisible
                                                ? category.color
                                                : Colors.white54,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child:
                                        isVisible
                                            ? const Icon(
                                              Icons.check,
                                              size: 12,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
