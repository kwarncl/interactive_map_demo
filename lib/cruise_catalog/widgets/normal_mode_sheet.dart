import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/ncl_cruise_catalog.dart';
import '../models/cruise_category.dart';
import '../models/cruise_product.dart';

/// Normal mode content widget (without CustomScrollView)
class NormalModeContent extends StatefulWidget {
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
  State<NormalModeContent> createState() => _NormalModeContentState();
}

class _NormalModeContentState extends State<NormalModeContent> {
  late final List<CruiseProduct> featuredCruises;

  @override
  void initState() {
    super.initState();
    featuredCruises =
        NCLCruiseCatalog.allCruises
            .take(8)
            .toList()
            .where(
              (featured) =>
                  widget.cruises.any((c) => c.productId == featured.productId),
            )
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Destination chips
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Legend label
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    Icons.palette,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  Text(
                    'Cruise Destinations',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Destination chips
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 6,
                children:
                    CruiseCategories.all.map((category) {
                      final isSelected = widget.visibleCategories.contains(
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
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          onSelected: (selected) {
                            HapticFeedback.selectionClick();
                            widget.onCategoryToggled(category.categoryId);
                          },
                          backgroundColor: category.color.withValues(
                            alpha: 0.08,
                          ),
                          selectedColor: category.color.withValues(alpha: 0.15),
                          checkmarkColor: category.color,
                          labelStyle: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color:
                                isSelected
                                    ? category.color
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Selected cruise info or cruise listings (featured + all)
        if (widget.selectedCruise != null)
          _SelectedCruiseCard(cruise: widget.selectedCruise!)
        else
          _CruiseListings(
            cruises: widget.cruises,
            featuredCruises: featuredCruises,
            onCruiseSelected: widget.onCruiseSelected,
          ),
      ],
    );
  }
}

/// Selected cruise card widget
class _SelectedCruiseCard extends StatelessWidget {
  const _SelectedCruiseCard({required this.cruise});

  final CruiseProduct cruise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
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
                    color: Theme.of(context).colorScheme.primary,
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        cruise.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        cruise.shipName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        cruise.duration,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '\$${cruise.pricing.startingPrice}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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
}

/// Cruise listings widget
class _CruiseListings extends StatelessWidget {
  const _CruiseListings({
    required this.cruises,
    required this.featuredCruises,
    required this.onCruiseSelected,
  });

  final List<CruiseProduct> cruises;
  final List<CruiseProduct> featuredCruises;
  final ValueChanged<CruiseProduct> onCruiseSelected;

  @override
  Widget build(BuildContext context) {
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
          _SectionHeader(
            title: 'Featured Cruises',
            subtitle: 'Popular destinations to explore',
            icon: Icons.star,
            iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
            iconBackground: Theme.of(context).colorScheme.secondaryContainer,
          ),
          const SizedBox(height: 16),
          ...featuredCruises.map(
            (cruise) => _CruiseCard(
              cruise: cruise,
              isFeatured: true,
              onCruiseSelected: onCruiseSelected,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // All Cruises Section (if any non-featured cruises exist)
        if (nonFeaturedCruises.isNotEmpty) ...[
          _SectionHeader(
            title: 'All Cruises',
            subtitle: '${nonFeaturedCruises.length} voyages available',
            icon: Icons.explore,
            iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
            iconBackground: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          const SizedBox(height: 16),
          ...nonFeaturedCruises.map(
            (cruise) => _CruiseCard(
              cruise: cruise,
              isFeatured: false,
              onCruiseSelected: onCruiseSelected,
            ),
          ),
        ],
      ],
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual cruise card widget
class _CruiseCard extends StatelessWidget {
  const _CruiseCard({
    required this.cruise,
    required this.isFeatured,
    required this.onCruiseSelected,
  });

  final CruiseProduct cruise;
  final bool isFeatured;
  final ValueChanged<CruiseProduct> onCruiseSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isFeatured
                  ? [
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    Theme.of(context).colorScheme.surface,
                  ]
                  : [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.surfaceContainerLowest,
                  ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isFeatured
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.1),
          width: isFeatured ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isFeatured
                    ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1)
                    : Theme.of(context).shadowColor.withValues(alpha: 0.08),
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
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
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
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                'Featured',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${cruise.pricing.startingPrice}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
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
