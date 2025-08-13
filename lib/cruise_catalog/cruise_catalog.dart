import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:interactive_map_demo/common/map_config.dart';
import 'package:interactive_map_demo/common/map_utilities.dart';
import 'package:interactive_map_demo/common/widgets/custom_draggable_sheet.dart';
import 'package:interactive_map_demo/common/widgets/custom_map_tile_layers.dart';
import 'package:interactive_map_demo/common/widgets/custom_sticky_header_delegate.dart';
import 'package:interactive_map_demo/cruise_catalog/widgets/cruise_details_mode_sheet.dart';
import 'package:interactive_map_demo/cruise_catalog/widgets/normal_mode_sheet.dart';
import 'package:interactive_map_demo/cruise_catalog/widgets/search_mode_sheet.dart';
import 'package:latlong2/latlong.dart';

import 'models/cruise_category.dart';
import 'models/cruise_product.dart';
import 'models/cruise_route.dart';
import 'models/sheet_mode.dart';
import 'widgets/cruise_route_overlay.dart';

/// Main cruise world explorer with map focus and draggable controls
/// Accepts cruise data through constructor for easy swapping between mock and real data
class CruiseCatalog extends StatefulWidget {
  const CruiseCatalog({
    super.key,
    required this.cruises,
    required this.title,
    required this.mapConfig,
  });

  final List<CruiseProduct> cruises;
  final String title;
  final MapConfig mapConfig;

  @override
  State<CruiseCatalog> createState() => _CruiseCatalogState();
}

class _CruiseCatalogState extends State<CruiseCatalog>
    with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  late final AnimationController _animationController;
  late final ScrollController _sheetScrollController;
  late final DraggableScrollableController _sheetController;

  CruiseProduct? _selectedCruise;
  CruiseProduct?
  _recentlyDeselectedCruise; // Track recently deselected cruise for better UX
  Set<String> _visibleCategories = {};
  String _searchQuery = '';
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Zoom tier tracking (track tier only to avoid excess rebuilds during gestures)
  CruiseZoomTier _currentZoomTier = CruiseZoomTier.essential;

  // Sheet state management
  SheetMode _currentSheetMode = SheetMode.normal;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _sheetScrollController = ScrollController();
    _sheetController = DraggableScrollableController();
    // Initialize with all categories visible
    _visibleCategories = CruiseCategories.all.map((c) => c.categoryId).toSet();

    // Listen for manual sheet size changes to reset search mode
    _sheetController.addListener(_onSheetSizeChanged);
  }

  /// Handle manual sheet size changes
  void _onSheetSizeChanged() {
    // If in search mode and user manually drags sheet to smaller size, reset to normal
    // Use a threshold that allows normal dragging but prevents accidental dismissal
    if (_currentSheetMode == SheetMode.search &&
        _sheetController.size < SheetPosition.normal.value) {
      // Add a small delay to prevent immediate dismissal when tapping search
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted &&
            _currentSheetMode == SheetMode.search &&
            _sheetController.size < SheetPosition.normal.value) {
          setState(() {
            _currentSheetMode = SheetMode.normal;
            _showSearch = false;
            _searchQuery = '';
            _searchController.clear();
            _searchFocusNode.unfocus();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetSizeChanged);
    _mapController.dispose();
    _animationController.dispose();
    _sheetScrollController.dispose();
    _sheetController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Get filtered cruises based on categories, search, and zoom tier
  List<CruiseProduct> get _filteredCruises {
    var cruises =
        widget.cruises
            .where(
              (cruise) => _visibleCategories.contains(
                cruise.route.region?.toLowerCase(),
              ),
            )
            .toList();

    // Apply search filter if active
    if (_searchQuery.isNotEmpty) {
      cruises =
          cruises.where((cruise) {
            final query = _searchQuery.toLowerCase();
            return cruise.title.toLowerCase().contains(query) ||
                cruise.shipName.toLowerCase().contains(query) ||
                cruise.route.region!.toLowerCase().contains(query) ||
                cruise.route.waypoints.any(
                  (port) =>
                      port.name.toLowerCase().contains(query) ||
                      port.country!.toLowerCase().contains(query),
                );
          }).toList();
    }

    // Apply zoom tier filter - show only featured cruises at essential tier
    if (_currentZoomTier == CruiseZoomTier.essential) {
      // Only show featured cruises (essential tier cruises) at zoom levels 3, 4, 5
      cruises =
          cruises
              .where((cruise) => cruise.zoomTier == CruiseZoomTier.essential)
              .toList();
    } else {
      // Show all cruises at medium and detailed tiers
      cruises =
          cruises
              .where((cruise) => _shouldShowCruiseAtZoomTier(cruise.zoomTier))
              .toList();
    }

    // Always include recently deselected cruise for better UX (even if zoom tier would hide it)
    if (_recentlyDeselectedCruise != null) {
      final recentlyDeselected = _recentlyDeselectedCruise!;
      // Only add if it matches category and search filters, and isn't already included
      final matchesCategory = _visibleCategories.contains(
        recentlyDeselected.route.region?.toLowerCase(),
      );
      final matchesSearch =
          _searchQuery.isEmpty ||
          () {
            final query = _searchQuery.toLowerCase();
            return recentlyDeselected.title.toLowerCase().contains(query) ||
                recentlyDeselected.shipName.toLowerCase().contains(query) ||
                recentlyDeselected.route.region!.toLowerCase().contains(
                  query,
                ) ||
                recentlyDeselected.route.waypoints.any(
                  (port) =>
                      port.name.toLowerCase().contains(query) ||
                      port.country!.toLowerCase().contains(query),
                );
          }();

      if (matchesCategory &&
          matchesSearch &&
          !cruises.any((c) => c.productId == recentlyDeselected.productId)) {
        cruises.add(recentlyDeselected);
        debugPrint(
          'Added recently deselected cruise to visible list: ${recentlyDeselected.title}',
        );
      }
    }

    return cruises;
  }

  /// Determine if a cruise should be visible at the current zoom tier
  bool _shouldShowCruiseAtZoomTier(CruiseZoomTier cruiseZoomTier) {
    switch (cruiseZoomTier) {
      case CruiseZoomTier.essential:
        // Essential cruises always visible
        return true;
      case CruiseZoomTier.medium:
        // Medium cruises visible at medium and detailed zoom
        return _currentZoomTier == CruiseZoomTier.medium ||
            _currentZoomTier == CruiseZoomTier.detailed;
      case CruiseZoomTier.detailed:
        // Detailed cruises only visible at detailed zoom
        return _currentZoomTier == CruiseZoomTier.detailed;
    }
  }

  /// Handle cruise selection with intelligent sheet and map behavior
  void _onCruiseSelected(CruiseProduct cruise) {
    final currentSize = _sheetController.size;
    debugPrint(
      'Cruise selected: ${cruise.title}, current sheet size: $currentSize',
    );

    setState(() {
      // Store previously selected cruise as recently deselected for better UX
      if (_selectedCruise != null &&
          _selectedCruise!.productId != cruise.productId) {
        _recentlyDeselectedCruise = _selectedCruise;
        debugPrint(
          'Storing recently deselected cruise: ${_selectedCruise!.title}',
        );
      }

      _selectedCruise = cruise;
      _currentSheetMode = SheetMode.cruiseDetails;
      // Exit search mode if active
      _showSearch = false;
      _searchController.clear();
      _searchQuery = '';
      _searchFocusNode.unfocus();
    });

    // Fit map to show the entire cruise route dynamically
    try {
      final coordinates = cruise.route.coordinates;

      if (coordinates.isNotEmpty) {
        // Create bounds from all route coordinates
        final bounds = LatLngBounds.fromPoints(coordinates);

        // Animate camera to fit the entire cruise route with smooth movement
        _mapController.animatedFitCamera(
          cameraFit: CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(50.0), // Add padding around the route
          ),
          duration: const Duration(
            milliseconds: 1200,
          ), // Smooth, comfortable animation
          curve: Curves.easeInOut, // Natural acceleration/deceleration
        );

        debugPrint('Fitted map to cruise route bounds: ${cruise.title}');
      } else {
        debugPrint('No coordinates found for cruise: ${cruise.title}');
      }
    } catch (e) {
      // Fallback: use center point with reasonable zoom if fitting fails
      debugPrint(
        'Map fit failed for cruise ${cruise.title}: $e, using fallback',
      );
      // Use animated move for fallback
      _mapController.animateTo(
        dest: cruise.route.centerPoint,
        zoom: 6.5,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
      );
    }

    _animationController.forward();

    // Coordinate sheet animation with map animation for smooth experience
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Always animate sheet to normal height for cruise details
      // Coordinate timing with map animation for cohesive experience
      debugPrint(
        'Animating sheet from $currentSize to ${SheetPosition.normal.value} for cruise details',
      );
      if (_sheetController.isAttached) {
        _sheetController
            .animateTo(
              SheetPosition.normal.value,
              duration: const Duration(milliseconds: 250), // Faster animation
              curve: Curves.easeInOut, // Match map animation curve
            )
            .then((_) {
              debugPrint(
                'Sheet animation completed to ${SheetPosition.normal.value}',
              );
            })
            .catchError((error) {
              debugPrint('Sheet animation error: $error');
            });
      } else {
        debugPrint(
          'Sheet controller not attached, skipping cruise selection animation',
        );
      }
    });

    HapticFeedback.selectionClick();
  }

  /// Handle port selection - cycle through cruises that visit the same port
  void _onPortTapped(PortLocation port) {
    debugPrint('Port tapped: ${port.name}');

    // Find all cruises that visit this port (matching by name and country)
    // Use ALL cruises from catalog, not filtered ones, so users can cycle through
    // all cruises at a port regardless of zoom level, search, or category filters
    final cruisesAtPort =
        widget.cruises.where((cruise) {
          return cruise.route.waypoints.any(
            (waypoint) =>
                waypoint.name == port.name && waypoint.country == port.country,
          );
        }).toList();

    // Sort cruises for better cycling experience: featured first, then by duration, then by price
    cruisesAtPort.sort((a, b) {
      // Featured cruises first
      if (a.zoomTier == CruiseZoomTier.essential &&
          b.zoomTier != CruiseZoomTier.essential) {
        return -1;
      }
      if (b.zoomTier == CruiseZoomTier.essential &&
          a.zoomTier != CruiseZoomTier.essential) {
        return 1;
      }

      // Then by duration (shorter first)
      final aDays =
          int.tryParse(a.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final bDays =
          int.tryParse(b.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (aDays != bDays) {
        return aDays.compareTo(bDays);
      }

      // Finally by price (cheaper first)
      return a.pricing.startingPrice.compareTo(b.pricing.startingPrice);
    });

    debugPrint('Found ${cruisesAtPort.length} cruises at ${port.name}');

    if (cruisesAtPort.isEmpty) return;

    // If only one cruise at this port, just select it
    if (cruisesAtPort.length == 1) {
      _onCruiseSelected(cruisesAtPort.first);
      return;
    }

    // Multiple cruises at this port - cycle through them
    CruiseProduct nextCruise;

    if (_selectedCruise == null) {
      // No cruise selected, select the first one
      nextCruise = cruisesAtPort.first;
    } else {
      // Find currently selected cruise in the list
      final currentIndex = cruisesAtPort.indexWhere(
        (cruise) => cruise.productId == _selectedCruise!.productId,
      );

      if (currentIndex == -1) {
        // Current cruise is not in this port's list, select the first one
        nextCruise = cruisesAtPort.first;
      } else {
        // Cycle to the next cruise (wrap around to beginning if at end)
        final nextIndex = (currentIndex + 1) % cruisesAtPort.length;
        nextCruise = cruisesAtPort[nextIndex];
      }
    }

    final nextIndex = cruisesAtPort.indexOf(nextCruise) + 1;
    debugPrint(
      'Cycling to cruise: ${nextCruise.title} ($nextIndex/${cruisesAtPort.length}) at ${port.name}',
    );

    // Show a brief debug info about all available cruises at this port
    if (cruisesAtPort.length > 1) {
      debugPrint('All cruises at ${port.name}:');
      for (int i = 0; i < cruisesAtPort.length; i++) {
        final cruise = cruisesAtPort[i];
        final marker = i == (nextIndex - 1) ? '➤ ' : '  ';
        debugPrint(
          '$marker${i + 1}. ${cruise.title} (${cruise.duration}, \$${cruise.pricing.startingPrice})',
        );
      }
    }

    _onCruiseSelected(nextCruise);
  }

  /// Close cruise details without resetting map zoom/position
  void _closeCruiseDetails() {
    // Update state to clear selected cruise and return to normal or search mode
    setState(() {
      // Store deselected cruise for better UX - it will remain visible
      if (_selectedCruise != null) {
        _recentlyDeselectedCruise = _selectedCruise;
        debugPrint(
          'Storing recently deselected cruise: ${_selectedCruise!.title}',
        );
      }

      _selectedCruise = null;
      // Keep current mode if in search, otherwise go to normal
      if (_currentSheetMode != SheetMode.search) {
        _currentSheetMode = SheetMode.normal;
      }
    });

    _animationController.reverse();

    // Animate sheet height based on current mode with faster timing
    final targetHeight =
        _showSearch
            ? SheetPosition.fullScreen.value
            : SheetPosition.normal.value;

    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        targetHeight,
        duration: const Duration(milliseconds: 200), // Faster animation
        curve: Curves.easeInOut, // Consistent curve with selection
      );
    } else {
      debugPrint('Sheet controller not attached, skipping close animation');
    }

    HapticFeedback.lightImpact();
  }

  /// Reset map to world view and normalize sheet
  void _resetMapView() {
    // Update state first, then move camera
    setState(() {
      // Store deselected cruise for better UX - it will remain visible
      if (_selectedCruise != null) {
        _recentlyDeselectedCruise = _selectedCruise;
        debugPrint(
          'Storing recently deselected cruise: ${_selectedCruise!.title}',
        );
      }

      _selectedCruise = null;
      _currentSheetMode = SheetMode.normal;
    });

    // Smoothly animate back to Miami, FL center view
    try {
      _mapController.animateTo(
        dest: const LatLng(25.7617, -80.1918),
        zoom: 6.0,
        duration: const Duration(milliseconds: 1000), // Smooth return animation
        curve: Curves.easeInOut,
      );
    } catch (e) {
      // Fallback: set camera directly if move fails
      debugPrint('Map move failed, using fallback: $e');
    }

    _animationController.reverse();

    // Return sheet to default height with faster animation
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        SheetPosition.normal.value,
        duration: const Duration(milliseconds: 200), // Faster reset timing
        curve: Curves.easeInOut, // Consistent smooth curve
      );
    } else {
      debugPrint('Sheet controller not attached, skipping map reset animation');
    }

    HapticFeedback.lightImpact();
  }

  /// Toggle category visibility
  void _onCategoryToggled(String categoryId) {
    setState(() {
      if (_visibleCategories.contains(categoryId)) {
        _visibleCategories.remove(categoryId);
      } else {
        _visibleCategories.add(categoryId);
      }
      // Clear recently deselected cruise when user changes categories
      if (_recentlyDeselectedCruise != null) {
        _recentlyDeselectedCruise = null;
        debugPrint('Cleared recently deselected cruise due to category change');
      }
    });
  }

  /// Handle search query changes
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      // Clear recently deselected cruise when user starts searching
      if (query.isNotEmpty && _recentlyDeselectedCruise != null) {
        _recentlyDeselectedCruise = null;
        debugPrint('Cleared recently deselected cruise due to search');
      }
    });
  }

  /// Toggle search with intelligent sheet behavior
  void _onSearchToggled() {
    debugPrint('Search toggled. Current search state: $_showSearch');

    final wasShowingSearch = _showSearch;

    setState(() {
      _showSearch = !_showSearch;
      if (_showSearch) {
        // Entering search mode
        _currentSheetMode = SheetMode.search;
        _selectedCruise = null; // Clear any selected cruise
        _recentlyDeselectedCruise =
            null; // Clear recently deselected for fresh search
        debugPrint(
          'Entering search mode, animating to ${SheetPosition.fullScreen.value}',
        );
      } else {
        // Exiting search mode
        _currentSheetMode = SheetMode.normal;
        _searchController.clear();
        _searchQuery = '';
        _searchFocusNode.unfocus();
        debugPrint(
          'Exiting search mode, animating to ${SheetPosition.normal.value}',
        );
      }
    });

    // Delay sheet animation until after setState rebuild completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Animate sheet with better error handling
      if (!wasShowingSearch && _showSearch) {
        // Animate sheet to max height for search
        if (_sheetController.isAttached) {
          _sheetController
              .animateTo(
                SheetPosition.fullScreen.value,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              )
              .then((_) {
                // Focus the search input after animation completes
                debugPrint('Sheet animation completed, focusing search input');
                if (mounted && _showSearch) {
                  // Add a small delay to ensure the widget tree is fully built
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted && _showSearch) {
                      _searchFocusNode.requestFocus();
                      debugPrint('Search input focused');
                    }
                  });
                }
              })
              .catchError((error) {
                debugPrint('Sheet animation error: $error');
              });
        } else {
          debugPrint('Sheet controller not attached, skipping animation');
          // Still focus the search input even if animation fails
          if (mounted && _showSearch) {
            // Add a small delay to ensure the widget tree is fully built
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted && _showSearch) {
                _searchFocusNode.requestFocus();
                debugPrint('Search input focused (fallback)');
              }
            });
          }
        }
      } else if (wasShowingSearch && !_showSearch) {
        // Return sheet to default height
        if (_sheetController.isAttached) {
          _sheetController
              .animateTo(
                SheetPosition.normal.value,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              )
              .catchError((error) {
                debugPrint('Sheet animation error: $error');
              });
        } else {
          debugPrint('Sheet controller not attached, skipping animation');
        }
      }
    });

    HapticFeedback.selectionClick();
  }

  /// Calculate current zoom tier based on map zoom level
  CruiseZoomTier _calculateZoomTier(double zoom) {
    // Define zoom thresholds for cruise-focused view
    // Essential: 3, 4 (featured cruises, embark/disembark pins only)
    // Medium: 5, 6, 7 (all cruises, all pins and labels)
    // Detailed: 8 (maximum detail view)

    if (zoom >= 8.0) {
      return CruiseZoomTier.detailed;
    } else if (zoom >= 5.0) {
      return CruiseZoomTier.medium;
    } else {
      return CruiseZoomTier.essential;
    }
  }

  /// Handle position changes (including zoom) in real-time
  /// This is the recommended approach from Flutter Map documentation
  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    final CruiseZoomTier newZoomTier = _calculateZoomTier(camera.zoom);
    if (newZoomTier != _currentZoomTier) {
      setState(() {
        _currentZoomTier = newZoomTier;
      });
    }
  }

  /// Handle map taps to reset sheet to default height
  void _onMapTapped() {
    debugPrint('Map tapped. Current sheet mode: $_currentSheetMode');

    // Only reset if not in search mode (search should stay open)
    if (_currentSheetMode != SheetMode.search) {
      final currentSize = _sheetController.size;
      debugPrint('Current sheet size: $currentSize, resetting to normal mode');

      setState(() {
        // Store deselected cruise for better UX - same as close button behavior
        if (_selectedCruise != null) {
          _recentlyDeselectedCruise = _selectedCruise;
          debugPrint(
            'Storing recently deselected cruise: ${_selectedCruise!.title}',
          );
        }

        _selectedCruise = null;
        _currentSheetMode = SheetMode.normal;
      });

      // Stop any cruise animations
      _animationController.reverse();

      // Delay sheet animation until after setState rebuild completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only animate to default height if not currently hidden (12%)
        // If sheet is hidden, keep it hidden when tapping map
        if (currentSize > SheetPosition.hidden.value) {
          // If sheet is not in hidden state
          debugPrint(
            'Animating sheet to ${SheetPosition.normal.value} from map tap',
          );
          if (_sheetController.isAttached) {
            _sheetController
                .animateTo(
                  SheetPosition.normal.value,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                )
                .catchError((error) {
                  debugPrint('Sheet animation error from map tap: $error');
                });
          } else {
            debugPrint(
              'Sheet controller not attached, skipping map tap animation',
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Full-screen world map (no padding - users control visibility with sheet)
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FlutterMap(
              mapController: _mapController.mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  widget.mapConfig.defaultLocation.latitude,
                  widget.mapConfig.defaultLocation.longitude,
                ),
                initialZoom: widget.mapConfig.initialZoom,
                minZoom: widget.mapConfig.minZoom,
                maxZoom: widget.mapConfig.maxZoom,
                // Allow horizontal wrapping - map repeats at edges
                cameraConstraint: const CameraConstraint.containLatitude(),
                // Keep the map centered and allow continuous panning
                interactionOptions: MapUtilities.buildInteractionOptions(
                  canDrag: widget.mapConfig.allowDrag,
                  canRotate: widget.mapConfig.allowRotate,
                  canPinch: widget.mapConfig.allowPinch,
                  enableMultiFingerGestureRace: false,
                  canDoubleTapZoom: true,
                ),
                // Real-time zoom tier tracking (recommended approach)
                onPositionChanged: _onPositionChanged,
                // Handle map taps to reset sheet height
                onTap: (tapPosition, point) => _onMapTapped(),
              ),
              children: [
                // Base map tiles (vector with raster fallback)
                CustomMapTileLayers(mapConfig: widget.mapConfig),

                // Cruise routes overlay with z-order: non-selected first, selected on top
                ...(_filteredCruises
                    .where(
                      (cruise) =>
                          _selectedCruise?.productId != cruise.productId,
                    )
                    .map(
                      (cruise) => CruiseRouteOverlay(
                        cruise: cruise,
                        isSelected: false,
                        onTap: () => _onCruiseSelected(cruise),
                        onPortTap: _onPortTapped,
                        animationController: _animationController,
                        currentZoomTier: _currentZoomTier,
                        hasSelectedCruise: _selectedCruise != null,
                        isRecentlyDeselected:
                            _recentlyDeselectedCruise?.productId ==
                            cruise.productId,
                      ),
                    )),

                // Render selected cruise last (on top) if one is selected
                if (_selectedCruise != null)
                  CruiseRouteOverlay(
                    cruise: _selectedCruise!,
                    isSelected: true,
                    onTap: () => _onCruiseSelected(_selectedCruise!),
                    onPortTap: _onPortTapped,
                    animationController: _animationController,
                    currentZoomTier: _currentZoomTier,
                    hasSelectedCruise: _selectedCruise != null,
                    isRecentlyDeselected:
                        false, // Selected cruise is never recently deselected
                  ),
              ],
            ),
          ),

          // Top header with greeting and navigation
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Hello, Explorer! greeting
                          IgnorePointer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, Explorer!',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Discover your next adventure',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Draggable bottom sheet with intelligent behavior (customized)
          CustomDraggableSheet(
            controller: _sheetController,
            initialChildSize: SheetPosition.normal.value,
            minChildSize: SheetPosition.hidden.value,
            maxChildSize: SheetPosition.fullScreen.value,
            slivers: [
              // Persistent header based on current mode
              SliverPersistentHeader(
                pinned: true,
                delegate: CustomStickyHeaderDelegate(
                  minHeight: 80.0,
                  maxHeight: 80.0,
                  child: switch (_currentSheetMode) {
                    SheetMode.search => SearchModeContent(
                      cruises: _filteredCruises,
                      searchQuery: _searchQuery,
                      onCruiseSelected: _onCruiseSelected,
                      onSearchChanged: _onSearchChanged,
                      onSearchToggled: _onSearchToggled,
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                    ).buildHeader(Theme.of(context)),
                    SheetMode.cruiseDetails => CruiseDetailsModeContent(
                      selectedCruise: _selectedCruise,
                      cruises: _filteredCruises,
                      onCruiseSelected: _onCruiseSelected,
                      onClose: _closeCruiseDetails,
                    ).buildHeader(context),
                    SheetMode.normal => NormalModeContent(
                      cruises: _filteredCruises,
                      selectedCruise: _selectedCruise,
                      visibleCategories: _visibleCategories,
                      showSearch: _showSearch,
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                      onCruiseSelected: _onCruiseSelected,
                      onCategoryToggled: _onCategoryToggled,
                      onSearchChanged: _onSearchChanged,
                      onSearchToggled: _onSearchToggled,
                      onMapReset: _resetMapView,
                    ).buildHeader(Theme.of(context)),
                  },
                ),
              ),

              // Content based on current mode
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: switch (_currentSheetMode) {
                    SheetMode.search => SearchModeContent(
                      cruises: _filteredCruises,
                      searchQuery: _searchQuery,
                      onCruiseSelected: _onCruiseSelected,
                      onSearchChanged: _onSearchChanged,
                      onSearchToggled: _onSearchToggled,
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                    ),
                    SheetMode.cruiseDetails => CruiseDetailsModeContent(
                      selectedCruise: _selectedCruise,
                      cruises: _filteredCruises,
                      onCruiseSelected: _onCruiseSelected,
                      onClose: _closeCruiseDetails,
                    ),
                    SheetMode.normal => NormalModeContent(
                      cruises: _filteredCruises,
                      selectedCruise: _selectedCruise,
                      visibleCategories: _visibleCategories,
                      showSearch: _showSearch,
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                      onCruiseSelected: _onCruiseSelected,
                      onCategoryToggled: _onCategoryToggled,
                      onSearchChanged: _onSearchChanged,
                      onSearchToggled: _onSearchToggled,
                      onMapReset: _resetMapView,
                    ),
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sticky header delegate
