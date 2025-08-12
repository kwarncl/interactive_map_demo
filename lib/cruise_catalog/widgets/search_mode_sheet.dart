import 'package:flutter/material.dart';

import '../models/cruise_product.dart';
import 'cruise_search_bar.dart';

/// Search mode content widget (without CustomScrollView)
class SearchModeContent extends StatelessWidget {
  const SearchModeContent({
    super.key,
    required this.cruises,
    required this.searchQuery,
    required this.onCruiseSelected,
    required this.onSearchChanged,
    required this.onSearchToggled,
    this.searchController,
    this.searchFocusNode,
  });

  final List<CruiseProduct> cruises;
  final String searchQuery;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggled;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search results content
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 20),
          child: _buildSearchResultsContent(theme),
        ),
      ],
    );
  }

  /// Build search header
  Widget buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Row(
        children: [
          // Search input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.7,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CruiseSearchBar(
                  cruises: cruises,
                  onCruiseSelected: onCruiseSelected,
                  onFilterChanged: onSearchChanged,
                  controller: searchController,
                  focusNode: searchFocusNode,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Close search
          IconButton(
            onPressed: onSearchToggled,
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build search results content
  Widget _buildSearchResultsContent(ThemeData theme) {
    if (searchQuery.isEmpty) {
      return _buildSearchInstructions(theme);
    }

    final searchResults =
        cruises.where((cruise) {
          final query = searchQuery.toLowerCase();
          final searchTerms = [
            cruise.title.toLowerCase(),
            cruise.shipName.toLowerCase(),
            cruise.route.region?.toLowerCase() ?? '',
            ...cruise.route.waypoints.map((p) => p.name.toLowerCase()),
            ...cruise.route.waypoints.map(
              (p) => p.country?.toLowerCase() ?? '',
            ),
          ];

          return searchTerms.any((term) => term.contains(query));
        }).toList();

    if (searchResults.isEmpty) {
      return _buildNoSearchResults(theme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '${searchResults.length} cruise${searchResults.length == 1 ? '' : 's'} found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...searchResults.map(
          (cruise) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: _buildSearchResultCard(cruise, theme),
          ),
        ),
      ],
    );
  }

  /// Build search instructions when no query
  Widget _buildSearchInstructions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for Cruises',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type to search by destination, ship name, or cruise line',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build no search results content
  Widget _buildNoSearchResults(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'No cruises found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or browse our featured cruises',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build individual search result card
  Widget _buildSearchResultCard(CruiseProduct cruise, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerLowest,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cruise.route.routeColor.withValues(alpha: 0.2),
                        cruise.route.routeColor.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_boat,
                    color: cruise.route.routeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cruise.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${cruise.shipName} • ${cruise.duration}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From \$${cruise.pricing.startingPrice}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: theme.colorScheme.primary,
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
