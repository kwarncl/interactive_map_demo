// We can't use async/await in this file because it's a stateful widget
// and we need to use setState to update the state.
// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../interactive_map/models/interactive_map_marker_data.dart';
import '../interactive_map/pages/marker_details_page.dart';
import '../interactive_map/widgets/interactive_map_error.dart';
import '../interactive_map/widgets/interactive_map_marker_detail.dart';
import 'models/deck_polygon_data.dart';
import 'models/ship_deck_data.dart';
import 'widgets/deck_mini_map.dart';
import 'widgets/deck_polygon_overlay.dart';

/// Simplified deck map widget for displaying deck plans with interactive polygon areas.
///
/// This widget provides:
/// - **Deck Display**: Shows deck plan images for any ship class
/// - **Polygon Areas**: Interactive polygon overlays for configured decks
/// - **Basic Navigation**: Pan and zoom functionality
/// - **Multi-Ship Support**: Works with any ship class via DeckPolygonDataProvider
class MultiDeckShipMap extends StatefulWidget {
  /// Creates a deck map widget for a specific ship.
  const MultiDeckShipMap({
    super.key,
    required this.shipClass,
    required this.decks,
    this.initialDeckIndex = 0,
    this.polygonDataProvider,
  });

  /// Ship class identifier (e.g., 'norwegian_aqua')
  final String shipClass;

  /// List of deck information for this ship
  final List<ShipDeckInfo> decks;

  /// Initial deck to display (index in decks list)
  final int initialDeckIndex;

  /// Optional polygon data provider (uses factory if not provided)
  final DeckPolygonDataProvider? polygonDataProvider;

  @override
  State<MultiDeckShipMap> createState() => _MultiDeckShipMapState();
}

class _MultiDeckShipMapState extends State<MultiDeckShipMap> {
  // ========================================
  // DECK MANAGEMENT STATE
  // ========================================

  /// Current deck being displayed
  late ShipDeckInfo _currentDeck;

  /// Index of current deck in the provided decks list
  late int _currentDeckIndex;

  /// Polygon data provider for this ship
  late final DeckPolygonDataProvider? _polygonDataProvider;

  // ========================================
  // TRANSFORMATION & SCALING STATE
  // ========================================

  /// Controls pan and transformation of the map view (no zoom, vertical pan only)
  late final TransformationController _transformationController;

  /// Stores the initial centered view matrix for reset functionality
  Matrix4? _initialCenteringMatrix;

  // ========================================
  // IMAGE SIZE CACHING
  // ========================================

  /// Cached dimensions of the current deck plan image
  Size? _imageSize;

  /// Flag indicating if image size is still being loaded asynchronously
  bool _isImageSizeLoading = true;

  // ========================================
  // DIALOG STATE MANAGEMENT
  // ========================================

  /// Controller for the currently displayed polygon detail bottom sheet
  /// null when no dialog is showing
  PersistentBottomSheetController? _currentDialogController;

  /// Flag to prevent multiple dialogs from showing simultaneously
  /// Handles race conditions during dialog transitions
  bool _isDialogShowing = false;

  // ========================================
  // POLYGON SELECTION STATE
  // ========================================

  /// ID of the currently selected polygon area
  String? _selectedPolygonAreaId;

  // ========================================
  // POLYGON AREAS STATE
  // ========================================

  /// List of polygon areas for interactive features
  List<DeckPolygonArea> _polygonAreas = [];

  /// Flag indicating if polygon areas are still being loaded
  bool _isPolygonAreasLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize with provided initial deck index
    _currentDeckIndex = widget.initialDeckIndex.clamp(
      0,
      widget.decks.length - 1,
    );
    _currentDeck = widget.decks[_currentDeckIndex];

    // Initialize polygon data provider
    _polygonDataProvider =
        widget.polygonDataProvider ??
        ShipPolygonDataFactory.getProvider(widget.shipClass);

    _transformationController = TransformationController();

    // Listen to transformation changes to update mini-map viewport indicator
    _transformationController.addListener(_onTransformationChanged);

    // Load initial deck image size
    _loadCurrentDeckImage();

    // Load polygon areas for current deck
    _loadPolygonAreas();
  }

  void _onTransformationChanged() {
    // Trigger a rebuild to update the mini-map viewport indicator
    if (mounted) {
      setState(() {
        // The transformation has changed, mini-map viewport indicator will update
      });
    }
  }

  /// Loads the image for the current deck and caches its size
  Future<void> _loadCurrentDeckImage() async {
    setState(() {
      _isImageSizeLoading = true;
      _imageSize = null;
    });

    try {
      final Size size = await _getImageSize(_currentDeck.imageUrl);
      if (mounted) {
        setState(() {
          _imageSize = size;
          _isImageSizeLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isImageSizeLoading = false;
        });
      }
    }
  }

  /// Loads polygon areas for interactive features
  void _loadPolygonAreas() {
    setState(() {
      _isPolygonAreasLoading = true;
      _polygonAreas = [];
    });

    try {
      final List<DeckPolygonArea> areas =
          _polygonDataProvider?.getPolygonAreas(
            widget.shipClass,
            _currentDeck.deckNumber,
          ) ??
          [];

      if (mounted) {
        setState(() {
          _polygonAreas = areas;
          _isPolygonAreasLoading = false;
        });
        print(
          'Successfully loaded ${areas.length} polygon areas for ${widget.shipClass} Deck ${_currentDeck.deckNumber}',
        );
      }
    } catch (error) {
      print('Error loading polygon areas: $error');
      if (mounted) {
        setState(() {
          _isPolygonAreasLoading = false;
          _polygonAreas = [];
        });
      }
    }
  }

  /// Gets the appropriate polygon areas for the current deck
  List<DeckPolygonArea> _getPolygonAreasForCurrentDeck() {
    // Check if this deck has polygon data available
    if (_polygonDataProvider?.hasPolygonData(
          widget.shipClass,
          _currentDeck.deckNumber,
        ) !=
        true) {
      return [];
    }

    // If polygon areas are loaded, use those
    if (!_isPolygonAreasLoading && _polygonAreas.isNotEmpty) {
      return _polygonAreas;
    }

    // Fallback to provider data
    return _polygonDataProvider?.getPolygonAreas(
          widget.shipClass,
          _currentDeck.deckNumber,
        ) ??
        [];
  }

  /// Switches to a different deck level
  void _switchToDeck(int deckNumber) {
    // Find the deck in the provided decks list
    final int newIndex = widget.decks.indexWhere(
      (deck) => deck.deckNumber == deckNumber,
    );

    if (newIndex == -1 || newIndex == _currentDeckIndex) return;

    final ShipDeckInfo newDeck = widget.decks[newIndex];

    // Clear selection when switching decks
    _selectedPolygonAreaId = null;

    // Update deck info
    setState(() {
      _currentDeck = newDeck;
      _currentDeckIndex = newIndex;
    });

    // Load new deck image
    _loadCurrentDeckImage();

    // Load polygon areas for new deck
    _loadPolygonAreas();

    // Reset transformation to initial position for new deck
    _resetPosition();
  }

  @override
  void dispose() {
    _transformationController
      ..removeListener(_onTransformationChanged)
      ..dispose();

    // Clean up dialog state
    _dismissCurrentDialog();

    super.dispose();
  }

  /// Calculates the minimum scale that ensures the image extends beyond viewport for scrolling
  double _getMinScale(Size viewportSize, Size imageSize) {
    // Calculate scale needed for width to fit viewport
    final double scaleToFitWidth = viewportSize.width / imageSize.width;

    // Calculate scale needed for height to fill viewport
    final double scaleToFillHeight = viewportSize.height / imageSize.height;

    // Use the larger scale to ensure the image extends beyond viewport bounds
    // This guarantees vertical scrolling capability
    return math.max(scaleToFitWidth, scaleToFillHeight);
  }

  /// Calculates the maximum scale to allow moderate zoom while keeping deck plan readable
  double _getMaxScale(Size viewportSize, Size imageSize) {
    final double minScale = _getMinScale(viewportSize, imageSize);
    // Allow moderate zoom in (1.5x) while maintaining scrolling capability
    return minScale * 1.5;
  }

  Offset _constrainTranslationToBounds(
    double translationY,
    double scale,
    Size viewportSize,
    Size imageSize,
  ) {
    // Calculate the scaled image dimensions
    final double scaledImageHeight = imageSize.height * scale;

    // For deck plans, always center horizontally (no horizontal panning)
    final double constrainedX =
        (viewportSize.width - (imageSize.width * scale)) / 2;

    // Allow vertical panning within bounds only
    double constrainedY = translationY;
    if (scaledImageHeight <= viewportSize.height) {
      // Center the image if it's smaller than viewport
      constrainedY = (viewportSize.height - scaledImageHeight) / 2;
    } else {
      // Clamp to prevent showing white space on top or bottom
      constrainedY = constrainedY.clamp(
        viewportSize.height - scaledImageHeight, // Bottom edge
        0.0, // Top edge
      );
    }

    return Offset(constrainedX, constrainedY);
  }

  void _resetPosition() {
    // Reset to the initial centered position if available, otherwise identity
    final Matrix4 targetMatrix = _initialCenteringMatrix ?? Matrix4.identity();
    _transformationController.value = targetMatrix;
  }

  void _setupInitialCentering(RenderBox? renderBox, Size imageSize) {
    final Matrix4 currentMatrix = _transformationController.value;
    if (currentMatrix != Matrix4.identity()) {
      return; // Already transformed, don't override
    }

    if (renderBox == null) return;

    final Size viewportSize = renderBox.size;
    final double minScale = _getMinScale(viewportSize, imageSize);

    // Start at top for deck plan viewing (vertical panning only)
    const double unclampedTranslationY = 0; // Start at top of deck plan

    final Offset constrainedTranslation = _constrainTranslationToBounds(
      unclampedTranslationY,
      minScale,
      viewportSize,
      imageSize,
    );

    final centeringMatrix =
        Matrix4.identity()
          ..translate(constrainedTranslation.dx, constrainedTranslation.dy)
          ..scale(minScale);

    _initialCenteringMatrix = centeringMatrix.clone();
    _transformationController.value = centeringMatrix;
  }

  /// Safely dismisses the currently displayed polygon detail dialog.
  ///
  /// Handles race conditions and edge cases:
  /// - Gracefully handles already-closed dialogs
  /// - Waits for dialogs in the process of showing
  /// - Cleans up controller references and state flags
  /// - Uses retry logic for timing-sensitive dismissals
  Future<void> _dismissCurrentDialog() async {
    if (_currentDialogController != null) {
      try {
        _currentDialogController!.close();
        await _currentDialogController!.closed;
        _currentDialogController = null;
        _isDialogShowing = false;
      } catch (e) {
        // Dialog was already closed or couldn't be closed
        _currentDialogController = null;
        _isDialogShowing = false;
      }
    } else if (_isDialogShowing) {
      // Dialog is in the process of showing but controller not ready yet
      // Use a delayed retry to dismiss once it's ready
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (_currentDialogController != null) {
        await _dismissCurrentDialog();
      } else {
        _isDialogShowing = false;
      }
    }
  }

  /// Handles taps on empty areas of the map
  void _handleMapTap() {
    _dismissCurrentDialog();

    if (_selectedPolygonAreaId != null) {
      setState(() {
        _selectedPolygonAreaId = null;
      });
    }
  }

  /// Handles polygon area selection and shows details
  void _handlePolygonAreaTap(
    DeckPolygonArea area,
    Size imageSize,
    BuildContext scaffoldContext,
  ) async {
    // If already selected, deselect
    if (_selectedPolygonAreaId == area.id) {
      await _dismissCurrentDialog();
      setState(() {
        _selectedPolygonAreaId = null;
      });
      return;
    }

    // Select new area
    await _dismissCurrentDialog();
    setState(() {
      _selectedPolygonAreaId = area.id;
    });

    // Show area details in persistent bottom sheet (same as interactive map)
    if (mounted && !_isDialogShowing && _currentDialogController == null) {
      _isDialogShowing = true;

      // Convert polygon area to marker data for compatibility with existing detail widget
      final InteractiveMapMarkerData markerData = _convertPolygonToMarkerData(
        area,
      );

      _currentDialogController = Scaffold.of(scaffoldContext).showBottomSheet(
        (context) => InteractiveMapMarketDetail.fromMarkerData(
          markerData: markerData,
          actionButtonText: InteractiveMapMarkerData.getActionButtonText(
            area.id,
          ),
          onActionPressed: () {
            Navigator.of(context).pop();
            _currentDialogController = null;
            _isDialogShowing = false;
            setState(() {
              _selectedPolygonAreaId = null;
            });
            _navigateToPolygonAreaDetails(context, area);
          },
        ),
        backgroundColor: Colors.transparent,
        enableDrag: true,
      );

      await _currentDialogController!.closed.then((_) {
        _currentDialogController = null;
        _isDialogShowing = false;
        if (mounted) {
          setState(() {
            _selectedPolygonAreaId = null;
          });
        }
      });
    }
  }

  /// Converts a polygon area to marker data for compatibility with existing detail widgets
  InteractiveMapMarkerData _convertPolygonToMarkerData(DeckPolygonArea area) {
    return InteractiveMapMarkerData(
      id: area.id,
      position: _getPolygonCenter(area.polygon),
      title: area.title,
      description: area.description,
      icon: _getIconForCategory(area.category),
      color: area.color,
      zoomTier: ZoomTier.essential,
    );
  }

  /// Navigate to polygon area details page
  void _navigateToPolygonAreaDetails(
    BuildContext context,
    DeckPolygonArea area,
  ) {
    // Convert polygon area to marker data for compatibility with existing detail page
    final InteractiveMapMarkerData markerData = _convertPolygonToMarkerData(
      area,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MarkerDetailsPage(markerData: markerData),
      ),
    );
  }

  /// Get the center point of a polygon
  Offset _getPolygonCenter(List<Offset> polygon) {
    if (polygon.isEmpty) return const Offset(0.5, 0.5);

    double centerX = 0;
    double centerY = 0;

    for (final point in polygon) {
      centerX += point.dx;
      centerY += point.dy;
    }

    return Offset(centerX / polygon.length, centerY / polygon.length);
  }

  /// Get icon for category
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'dining':
        return Icons.restaurant;
      case 'bar':
        return Icons.local_bar;
      case 'lounge':
        return Icons.chair;
      case 'pool':
        return Icons.pool;
      case 'attraction':
        return Icons.visibility;
      case 'entertainment':
        return Icons.theater_comedy;
      case 'shopping':
        return Icons.shopping_bag;
      case 'recreation':
        return Icons.sports_basketball;
      case 'services':
        return Icons.room_service;
      case 'haven':
        return Icons.star;
      default:
        return Icons.place;
    }
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final completer = Completer<Size>();

    // Check if this is an SVG file
    if (imageUrl.toLowerCase().endsWith('.svg')) {
      if (imageUrl.startsWith('assets/')) {
        // Load SVG asset and parse dimensions
        try {
          final String svgString = await rootBundle.loadString(imageUrl);
          final Size? svgSize = _parseSvgDimensions(svgString);

          if (svgSize != null) {
            completer.complete(svgSize);
          } else {
            // Fallback to default size if parsing fails
            completer.complete(const Size(800, 600));
          }
        } catch (error) {
          // Fallback to default size on error
          completer.complete(const Size(800, 600));
        }
      } else {
        // Network SVG - use default size for now
        completer.complete(const Size(800, 600));
      }
    } else {
      // Check if this is a local asset (starts with 'assets/')
      if (imageUrl.startsWith('assets/')) {
        // Load regular image asset (PNG, JPG, etc.)
        final image = AssetImage(imageUrl);
        final listener = ImageStreamListener((info, _) {
          final ui.Image imageInfo = info.image;
          completer.complete(
            Size(imageInfo.width.toDouble(), imageInfo.height.toDouble()),
          );
          imageInfo.dispose();
        });
        image.resolve(ImageConfiguration.empty).addListener(listener);
      } else {
        // Load network image
        final image = NetworkImage(imageUrl);
        final listener = ImageStreamListener((info, _) {
          final ui.Image imageInfo = info.image;
          completer.complete(
            Size(imageInfo.width.toDouble(), imageInfo.height.toDouble()),
          );
          imageInfo.dispose();
        });
        image.resolve(ImageConfiguration.empty).addListener(listener);
      }
    }

    return completer.future;
  }

  /// Returns default size for non-SVG images
  Size? _parseSvgDimensions(String svgContent) {
    // Simplified: return a default size instead of parsing SVG content
    return const Size(800, 600);
  }

  /// Builds the appropriate image widget based on the image URL type
  Widget _buildImageWidget() {
    final Size imageSize = _imageSize!;

    // Check if this is a local asset (starts with 'assets/')
    if (_currentDeck.imageUrl.startsWith('assets/')) {
      // Regular image asset (PNG, JPG, etc.)
      return Image.asset(
        _currentDeck.imageUrl,
        height: imageSize.height,
        width: imageSize.width,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => const InteractiveMapError(),
      );
    } else {
      // Network image
      return Image.network(
        _currentDeck.imageUrl,
        height: imageSize.height,
        width: imageSize.width,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => const InteractiveMapError(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: imageSize.height,
            width: imageSize.width,
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }
  }

  /// Builds a legend button that opens a bottom dialog
  Widget _buildLegendButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showLegendDialog(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Legend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows the legend in a bottom dialog
  void _showLegendDialog(BuildContext context) {
    final polygonAreas = _getPolygonAreasForCurrentDeck();

    // Group areas by category and get representative color for each
    final Map<String, Color> categoryColors = {};
    final Set<String> categories = {};

    for (final area in polygonAreas) {
      if (!categories.contains(area.category)) {
        categories.add(area.category);
        categoryColors[area.category] = area.color;
      }
    }

    // Standard deck plan legend items
    final List<Map<String, dynamic>> standardLegendItems = [
      {'symbol': '✱', 'title': 'Two non-combinable beds'},
      {'symbol': '⬛', 'title': 'Wheelchair Accessible'},
      {'symbol': '▲', 'title': 'Holds 3'},
      {'symbol': '●', 'title': 'Hearing Impaired'},
      {'symbol': '+', 'title': 'Holds 4'},
      {'symbol': '↔', 'title': 'Connecting'},
      {'symbol': '⭐', 'title': 'Holds 5'},
      {'symbol': '△', 'title': 'King Bed'},
      {'symbol': '☆', 'title': 'Holds 6'},
      {'symbol': '∞', 'title': 'Holds 8'},
      {'symbol': '⬜', 'title': 'PrivaSea'},
      {'symbol': '👫', 'title': 'Restroom'},
      {'symbol': '✗', 'title': 'Elevator'},
      {'symbol': '✓', 'title': 'Double Bed'},
      {'symbol': '○', 'title': 'Inside Corridors'},
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final padding = MediaQuery.of(context).padding;
        final viewInsets = MediaQuery.of(context).viewInsets;

        // Calculate available height accounting for system UI and safe areas
        final availableHeight =
            screenSize.height -
            padding.top -
            padding.bottom -
            viewInsets.bottom -
            kToolbarHeight - // AppBar height
            16; // Additional margin

        return Container(
          constraints: BoxConstraints(
            maxHeight: math.min(screenSize.height * 0.7, availableHeight),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.map, color: Colors.black87, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Deck Plan Legend',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    16 +
                        math.max(
                          0,
                          padding.bottom - 16,
                        ), // Account for safe area bottom
                  ),
                  children: [
                    // Standard Deck Plan Legend Section
                    Text(
                      'Deck Key',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...standardLegendItems.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            // Symbol
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              child: Text(
                                item['symbol'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Title
                            Expanded(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Interactive Areas Section (if any)
                    if (categories.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Interactive Areas',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...categories.map((category) {
                        final color = categoryColors[category]!;
                        final icon = _getIconForCategory(category);
                        final displayName = _getCategoryDisplayName(category);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              // Color indicator
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Icon
                              Icon(icon, color: Colors.black87, size: 20),
                              const SizedBox(width: 12),
                              // Category name
                              Expanded(
                                child: Text(
                                  displayName,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Get display name for category
  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'dining':
        return 'Dining';
      case 'bar':
        return 'Bar & Lounge';
      case 'lounge':
        return 'Lounge';
      case 'pool':
        return 'Pool Area';
      case 'attraction':
        return 'Attraction';
      case 'entertainment':
        return 'Entertainment';
      case 'shopping':
        return 'Shopping';
      case 'recreation':
        return 'Recreation';
      case 'services':
        return 'Services';
      case 'haven':
        return 'The Haven';
      default:
        return 'Area';
    }
  }

  /// Builds the deck selector dropdown
  Widget _buildDeckSelector() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _currentDeck.deckNumber,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (int? newDeckNumber) {
            if (newDeckNumber != null &&
                newDeckNumber != _currentDeck.deckNumber) {
              _switchToDeck(newDeckNumber);
            }
          },
          items:
              widget.decks.map<DropdownMenuItem<int>>((ShipDeckInfo deck) {
                return DropdownMenuItem<int>(
                  value: deck.deckNumber,
                  child: Text('Deck ${deck.deckNumber}'),
                );
              }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_currentDeck.name),
      backgroundColor: _currentDeck.primaryColor,
      foregroundColor: Colors.white,
      actions: [],
    ),
    body: Stack(
      children: [
        if (_isImageSizeLoading)
          const Center(child: CircularProgressIndicator())
        else
          _imageSize == null
              ? const InteractiveMapError()
              : Builder(
                builder: (scaffoldContext) {
                  final Size imageSize = _imageSize!;

                  // Set initial centering on first load
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _setupInitialCentering(
                      scaffoldContext.findRenderObject() as RenderBox?,
                      imageSize,
                    );
                  });

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final Size viewportSize = constraints.biggest;
                      final double minScale = _getMinScale(
                        viewportSize,
                        imageSize,
                      );
                      final double maxScale = _getMaxScale(
                        viewportSize,
                        imageSize,
                      );

                      return Stack(
                        children: [
                          Center(
                            child: InteractiveViewer(
                              transformationController:
                                  _transformationController,
                              minScale: minScale, // Allow vertical scrolling
                              maxScale: maxScale, // Allow moderate zoom
                              trackpadScrollCausesScale: true, // Enable zoom
                              constrained: false,
                              child: SizedBox(
                                height: imageSize.height,
                                width: imageSize.width,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _handleMapTap,
                                      child: _buildImageWidget(),
                                    ),
                                    // Render polygon overlays for decks with polygon data
                                    ..._getPolygonAreasForCurrentDeck().map((
                                      area,
                                    ) {
                                      final bool isSelected =
                                          _selectedPolygonAreaId == area.id;
                                      return DeckPolygonOverlay(
                                        key: ValueKey('polygon_${area.id}'),
                                        area: area,
                                        imageSize: imageSize,
                                        isSelected: isSelected,
                                        onTap:
                                            () => _handlePolygonAreaTap(
                                              area,
                                              imageSize,
                                              scaffoldContext,
                                            ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Mini-map (top-left)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: DeckMiniMap(
                              imageSize: imageSize,
                              currentDeck: _currentDeck,
                              transformationController:
                                  _transformationController,
                              viewportSize: viewportSize,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

        // Legend Button (top-right corner)
        Positioned(top: 8, right: 8, child: _buildLegendButton()),

        // Deck Selector (bottom-right)
        Positioned(bottom: 8, right: 8, child: _buildDeckSelector()),
      ],
    ),
  );
}
