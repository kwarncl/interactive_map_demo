import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/expanded_ncl_catalog.dart';
import '../models/cruise_category.dart';
import '../models/cruise_product.dart';
import 'cruise_search_bar.dart';

/// Normal mode content widget (without CustomScrollView)
class NormalModeContent extends StatelessWidget {
  const NormalModeContent({
    super.key,
    required this.cruises,
    required this.selectedCruise,
    required this.visibleCategories,
    required this.showSearch,
    required this.searchController,
    required this.searchFocusNode,
    required this.onCruiseSelected,
    required this.onCategoryToggled,
    required this.onSearchChanged,
    required this.onSearchToggled,
    required this.onMapReset,
  });

  final List<CruiseProduct> cruises;
  final CruiseProduct? selectedCruise;
  final Set<String> visibleCategories;
  final bool showSearch;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final ValueChanged<String> onCategoryToggled;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggled;
  final VoidCallback onMapReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Destination chips
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: _buildDestinationChips(theme),
        ),
        const SizedBox(height: 16),

        // Selected cruise info or cruise listings (featured + all)
        if (selectedCruise != null) ...[
          _buildEnhancedSelectedCruiseCard(selectedCruise!, theme),
        ] else ...[
          _buildCruiseListings(theme),
        ],
      ],
    );
  }

  /// Build the sticky header section
  Widget buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and controls
          Row(
            children: [
              // Enhanced title with icon
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.explore, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Cruises',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Find your perfect voyage',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.1),
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
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.8,
                                  ),
                                ]
                                : [
                                  theme.colorScheme.surfaceContainerHighest,
                                  theme.colorScheme.surfaceContainer,
                                ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              showSearch
                                  ? theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  )
                                  : theme.shadowColor.withValues(alpha: 0.1),
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
                                : theme.colorScheme.onSurfaceVariant,
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

          // Enhanced search bar with animation
          if (showSearch) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CruiseSearchBar(
                  cruises: cruises,
                  onCruiseSelected: onCruiseSelected,
                  onFilterChanged: onSearchChanged,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build destination chips that serve as map legend
  Widget _buildDestinationChips(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend label
        Row(
          children: [
            Icon(
              Icons.palette,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Cruise Destinations',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Destination chips
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              CruiseCategories.all.map((category) {
                final isSelected = visibleCategories.contains(
                  category.categoryId,
                );
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: category.color.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                    ],
                  ),
                  child: FilterChip(
                    selected: isSelected,
                    elevation: isSelected ? 2 : 0,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: category.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.name,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    onSelected: (selected) {
                      HapticFeedback.selectionClick();
                      onCategoryToggled(category.categoryId);
                    },
                    backgroundColor: category.color.withValues(alpha: 0.08),
                    selectedColor: category.color.withValues(alpha: 0.15),
                    checkmarkColor: category.color,
                    labelStyle: theme.textTheme.labelSmall?.copyWith(
                      color:
                          isSelected
                              ? category.color
                              : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: category.color.withValues(
                        alpha: isSelected ? 0.5 : 0.3,
                      ),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  /// Build enhanced selected cruise card (simplified for normal mode)
  Widget _buildEnhancedSelectedCruiseCard(
    CruiseProduct cruise,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_boat,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Cruise',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        cruise.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ship',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        cruise.shipName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        cruise.duration,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'From',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    Text(
                      '\$${cruise.pricing.startingPrice}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build cruise listings with featured cruises first, then all cruises
  Widget _buildCruiseListings(ThemeData theme) {
    // Get featured cruises that are currently visible
    final featuredCruises =
        ExpandedNCLCatalog.getFeaturedCruises()
            .where(
              (featured) =>
                  cruises.any((c) => c.productId == featured.productId),
            )
            .toList();

    // Get all non-featured cruises
    final featuredIds = featuredCruises.map((c) => c.productId).toSet();
    final nonFeaturedCruises =
        cruises
            .where((cruise) => !featuredIds.contains(cruise.productId))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured Cruises Section (if any)
        if (featuredCruises.isNotEmpty) ...[
          _buildSectionHeader(
            theme,
            title: 'Featured Cruises',
            subtitle: 'Popular destinations to explore',
            icon: Icons.star,
            iconColor: theme.colorScheme.onSecondaryContainer,
            iconBackground: theme.colorScheme.secondaryContainer,
          ),
          const SizedBox(height: 16),
          ...featuredCruises.map(
            (cruise) => _buildCruiseCard(cruise, theme, isFeatured: true),
          ),
          const SizedBox(height: 24),
        ],

        // All Cruises Section (if any non-featured cruises exist)
        if (nonFeaturedCruises.isNotEmpty) ...[
          _buildSectionHeader(
            theme,
            title: 'All Cruises',
            subtitle: '${nonFeaturedCruises.length} voyages available',
            icon: Icons.explore,
            iconColor: theme.colorScheme.onTertiaryContainer,
            iconBackground: theme.colorScheme.tertiaryContainer,
          ),
          const SizedBox(height: 16),
          ...nonFeaturedCruises.map(
            (cruise) => _buildCruiseCard(cruise, theme, isFeatured: false),
          ),
        ],
      ],
    );
  }

  /// Build section header for cruise categories
  Widget _buildSectionHeader(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual cruise card
  Widget _buildCruiseCard(
    CruiseProduct cruise,
    ThemeData theme, {
    required bool isFeatured,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isFeatured
                  ? [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    theme.colorScheme.surface,
                  ]
                  : [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerLowest,
                  ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isFeatured
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
          width: isFeatured ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isFeatured
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: isFeatured ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onCruiseSelected(cruise),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cruise.route.routeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions_boat,
                    color: cruise.route.routeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cruise.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isFeatured) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                'Featured',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        cruise.duration,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${cruise.pricing.startingPrice}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
