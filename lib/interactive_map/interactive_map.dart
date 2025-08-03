// We can't use async/await in this file because it's a stateful widget
// and we need to use setState to update the state.
// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

import 'models/interactive_map_marker_data.dart';
import 'pages/marker_details_page.dart';
import 'widgets/interactive_map_error.dart';
import 'widgets/interactive_map_filter.dart';
import 'widgets/interactive_map_legend.dart';
import 'widgets/interactive_map_marker.dart';
import 'widgets/interactive_map_marker_detail.dart';

/// Interactive map widget displaying cruise destination locations with pan, zoom, and marker interaction capabilities.
///
/// This widget provides:
/// - **Pan & Zoom**: Full gesture support with InteractiveViewer
/// - **Marker Selection**: Tap markers to view details with bottom sheet dialogs
/// - **Filtering**: Category-based marker visibility controls
/// - **Responsive Zoom Tiers**: Markers appear/disappear based on zoom level
/// - **Smooth Animations**: Selected markers scale up with pulsing glow effects
/// - **Gesture Handling**: Double-tap zoom, long-press reset, map tap deselection
///
/// ## Architecture:
/// - **Main Widget**: Stack with InteractiveViewer containing image and positioned markers
/// - **Marker Rendering**: Single-pass with natural order preserving smooth animations
/// - **State Management**: Selection, dialog, filter, and animation states
/// - **Animation**: Smooth zoom/pan animations with easing curves
/// - **Bounds Management**: Prevents showing white space during transforms
///
/// ## Performance Optimizations:
/// - Cached image size to prevent repeated loading
/// - Cached marker positions to eliminate repeated calculations
/// - Minimal rebuilds with efficient state updates
/// - Zoom tier-based marker visibility to reduce render load
class InteractiveMap extends StatefulWidget {
  /// Creates an interactive map widget.
  const InteractiveMap({super.key});

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap>
    with TickerProviderStateMixin {
  // ========================================
  // ASSET CONFIGURATION
  // ========================================

  /// Path to the cruise destination map image asset
  static const String _imagePath = 'assets/images/map.jpg';

  // ========================================
  // TRANSFORMATION & SCALING STATE
  // ========================================

  /// Controls pan, zoom, and transformation of the map view
  late final TransformationController _transformationController;

  /// Stores the initial centered view matrix for reset functionality
  /// This focuses on the cruise ship area at app startup
  Matrix4? _initialCenteringMatrix;

  /// Current scale factor of the map (1.0 = original size)
  /// Updated on every transformation change for marker scaling
  double _currentScale = 1;

  // ========================================
  // IMAGE SIZE CACHING
  // ========================================

  /// Cached dimensions of the map image to prevent repeated asset loading
  /// Used for positioning calculations and scale constraints
  Size? _imageSize;

  /// Flag indicating if image size is still being loaded asynchronously
  bool _isImageSizeLoading = true;

  // ========================================
  // ANIMATION CONTROLLERS
  // ========================================

  /// Controls smooth zoom animations with easing curves
  late final AnimationController _zoomAnimationController;

  /// Controls smooth pan animations (currently unused but reserved)
  late final AnimationController _panAnimationController;

  /// Duration for zoom and focus animations
  static const Duration _zoomAnimationDuration = Duration(milliseconds: 500);

  /// Duration for pan animations
  static const Duration _panAnimationDuration = Duration(milliseconds: 250);

  // ========================================
  // DIALOG STATE MANAGEMENT
  // ========================================

  /// Controller for the currently displayed marker detail bottom sheet
  /// null when no dialog is showing
  PersistentBottomSheetController? _currentDialogController;

  /// Flag to prevent multiple dialogs from showing simultaneously
  /// Handles race conditions during dialog transitions
  bool _isDialogShowing = false;

  // ========================================
  // FILTER STATE MANAGEMENT
  // ========================================

  /// Current filter configuration controlling marker visibility by category
  FilterState _filterState = const FilterState();

  /// Whether the filter control panel is currently expanded
  bool _isFilterExpanded = false;

  // ========================================
  // MARKER SELECTION STATE
  // ========================================

  /// ID of the currently selected marker for highlighting and z-order priority
  /// null when no marker is selected
  String? _selectedMarkerId;

  // ========================================
  // PERFORMANCE CACHING
  // ========================================

  /// Cache of absolute marker positions to avoid repeated calculations
  /// Key: marker ID, Value: absolute position in pixels
  /// Invalidated when image size changes
  final Map<String, Offset> _cachedMarkerPositions = {};

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _zoomAnimationController = AnimationController(
      duration: _zoomAnimationDuration,
      vsync: this,
    );
    _panAnimationController = AnimationController(
      duration: _panAnimationDuration,
      vsync: this,
    );

    // Listen to transformation changes to update marker scale
    _transformationController.addListener(_onTransformationChanged);

    // Load image size once at initialization
    _getAssetImageSize(_imagePath)
        .then((size) {
          if (mounted) {
            setState(() {
              _imageSize = size;
              _isImageSizeLoading = false;
              // Invalidate position cache when image size changes
              _invalidatePositionCache();
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _isImageSizeLoading = false;
            });
          }
        });
  }

  void _onTransformationChanged() {
    final double newScale = _transformationController.value.getMaxScaleOnAxis();
    // Only update if scale change is significant enough to avoid excessive rebuilds
    if ((newScale - _currentScale).abs() > 0.01) {
      _currentScale = newScale;
      // Use setState to ensure zoom tier calculations get fresh context
      if (mounted) {
        setState(() {
          // Scale changed, markers will use the new _currentScale and zoom tier
        });
      }
    }
  }

  /// Determines which zoom tier should be visible based on current scale.
  ///
  /// Zoom tiers control marker visibility to improve performance:
  /// - **Essential**: Always visible markers (key locations)
  /// - **Medium**: Visible at moderate zoom levels
  /// - **Detailed**: Only visible when fully zoomed in
  ///
  /// Thresholds are calculated as percentages of the total zoom range:
  /// - Medium: 30% into zoom range
  /// - Detailed: 60% into zoom range
  ///
  /// Returns [ZoomTier.essential] if viewport size cannot be determined.
  ZoomTier _getCurrentZoomTier() {
    if (_imageSize == null) {
      return ZoomTier.essential;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return ZoomTier.essential;
    }

    final Size viewportSize = renderBox.size;
    final Size imageSize = _imageSize!;

    final double minScale = _getMinScale(viewportSize, imageSize);
    final double maxScale = _getMaxScale(viewportSize, imageSize);
    final double scaleRange = maxScale - minScale;

    // Define zoom tier thresholds as percentages of the scale range
    final double mediumThreshold =
        minScale + (scaleRange * 0.3); // 30% into zoom range
    final double detailedThreshold =
        minScale + (scaleRange * 0.6); // 60% into zoom range

    if (_currentScale >= detailedThreshold) {
      return ZoomTier.detailed;
    } else if (_currentScale >= mediumThreshold) {
      return ZoomTier.medium;
    } else {
      return ZoomTier.essential;
    }
  }

  @override
  void dispose() {
    _transformationController
      ..removeListener(_onTransformationChanged)
      ..dispose();
    _zoomAnimationController.dispose();
    _panAnimationController.dispose();

    // Clean up dialog state
    _dismissCurrentDialog();

    // Clear performance caches
    _cachedMarkerPositions.clear();

    super.dispose();
  }

  void _zoomIn([Offset? focalPoint]) {
    if (_imageSize == null) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final Size viewportSize = renderBox.size;
    final Size imageSize = _imageSize!;

    final Matrix4 currentMatrix = _transformationController.value;
    final double currentScale = currentMatrix.getMaxScaleOnAxis();
    final double zoomStep = _getZoomStep(viewportSize, imageSize);
    final double minScale = _getMinScale(viewportSize, imageSize);
    final double maxScale = _getMaxScale(viewportSize, imageSize);

    final double newScale = (currentScale + zoomStep).clamp(minScale, maxScale);

    // Only zoom if scale actually changed
    if (newScale != currentScale) {
      if (focalPoint != null) {
        // Zoom into specific point
        _zoomToPoint(focalPoint, newScale);
      } else {
        // Zoom while maintaining current view center
        _zoomAroundCurrentCenter(newScale);
      }
    }
    // If scale didn't change (already at max), do nothing to avoid unwanted panning
  }

  void _zoomOut([Offset? focalPoint]) {
    if (_imageSize == null) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final Size viewportSize = renderBox.size;
    final Size imageSize = _imageSize!;

    final Matrix4 currentMatrix = _transformationController.value;
    final double currentScale = currentMatrix.getMaxScaleOnAxis();
    final double zoomStep = _getZoomStep(viewportSize, imageSize);
    final double minScale = _getMinScale(viewportSize, imageSize);
    final double maxScale = _getMaxScale(viewportSize, imageSize);

    final double newScale = (currentScale - zoomStep).clamp(minScale, maxScale);

    if (newScale != currentScale) {
      if (focalPoint != null) {
        // Zoom out from specific point
        _zoomToPoint(focalPoint, newScale);
      } else {
        // Zoom while maintaining current view center
        _zoomAroundCurrentCenter(newScale);
      }
    }
  }

  void _zoomToPoint(Offset focalPoint, double scale) {
    if (_imageSize == null) {
      return;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    final Size viewportSize = renderBox.size;
    final Size imageSize = _imageSize!;
    final double maxScale = _getMaxScale(viewportSize, imageSize);

    // Calculate natural translation based on focal point
    final Matrix4 matrix =
        Matrix4.identity()
          ..translate(focalPoint.dx, focalPoint.dy)
          ..scale(scale)
          ..translate(-focalPoint.dx, -focalPoint.dy);

    // Extract natural translation from the matrix
    final vector_math.Vector3 naturalTranslation = matrix.getTranslation();

    // Be more lenient with constraints when at maximum scale to preserve focal point
    final bool isAtMaxScale = (scale >= maxScale * 0.95);
    final bool wouldShowWhiteSpace = _wouldShowWhiteSpace(
      naturalTranslation.x,
      naturalTranslation.y,
      scale,
      viewportSize,
      imageSize,
    );

    // Only apply constraints if it would actually show white space AND we're not at max scale
    final Offset finalTranslation =
        (wouldShowWhiteSpace && !isAtMaxScale)
            ? _constrainTranslationToBounds(
              naturalTranslation.x,
              naturalTranslation.y,
              scale,
              viewportSize,
              imageSize,
            )
            : Offset(naturalTranslation.x, naturalTranslation.y);

    // Create final matrix
    final Matrix4 finalMatrix =
        Matrix4.identity()
          ..translate(finalTranslation.dx, finalTranslation.dy)
          ..scale(scale);

    _animateToMatrix(finalMatrix);
  }

  void _zoomAroundCurrentCenter(double newScale) {
    // Get the viewport center
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || _imageSize == null) {
      return;
    }

    final Size viewportSize = renderBox.size;
    final Size imageSize = _imageSize!;
    final double maxScale = _getMaxScale(viewportSize, imageSize);
    final double centerX = viewportSize.width / 2;
    final double centerY = viewportSize.height / 2;

    // Get current transformation values
    final Matrix4 currentMatrix = _transformationController.value;
    final double currentScale = currentMatrix.getMaxScaleOnAxis();
    final vector_math.Vector3 currentTranslation =
        currentMatrix.getTranslation();

    // Calculate the scale factor
    final double scaleFactor = newScale / currentScale;

    // Calculate new translation to keep the center point fixed
    // This is the standard formula for scaling around a point
    final double naturalTranslationX =
        centerX - (centerX - currentTranslation.x) * scaleFactor;
    final double naturalTranslationY =
        centerY - (centerY - currentTranslation.y) * scaleFactor;

    // Be more lenient with constraints when at maximum scale
    final bool isAtMaxScale = (newScale >= maxScale * 0.95);
    final bool wouldShowWhiteSpace = _wouldShowWhiteSpace(
      naturalTranslationX,
      naturalTranslationY,
      newScale,
      viewportSize,
      imageSize,
    );

    // Only apply constraints if it would actually show white space AND we're not at max scale
    final Offset finalTranslation =
        (wouldShowWhiteSpace && !isAtMaxScale)
            ? _constrainTranslationToBounds(
              naturalTranslationX,
              naturalTranslationY,
              newScale,
              viewportSize,
              imageSize,
            )
            : Offset(naturalTranslationX, naturalTranslationY);

    // Create the new transformation matrix
    final newMatrix =
        Matrix4.identity()
          ..translate(finalTranslation.dx, finalTranslation.dy)
          ..scale(newScale);

    // Animate to the new matrix instead of setting directly
    _animateToMatrix(newMatrix);
  }

  Offset _constrainTranslationToBounds(
    double translationX,
    double translationY,
    double scale,
    Size viewportSize,
    Size imageSize,
  ) {
    // Calculate the scaled image dimensions
    final double scaledImageWidth = imageSize.width * scale;
    final double scaledImageHeight = imageSize.height * scale;

    // Calculate the maximum allowed translation values
    // For X: if scaled image is smaller than viewport, center it
    // If larger, ensure the right edge doesn't go past the viewport
    double constrainedX = translationX;
    if (scaledImageWidth <= viewportSize.width) {
      // Center the image if it's smaller than viewport
      constrainedX = (viewportSize.width - scaledImageWidth) / 2;
    } else {
      // Clamp to prevent showing white space on left or right
      constrainedX = constrainedX.clamp(
        viewportSize.width - scaledImageWidth, // Rightmost edge
        0.0, // Leftmost edge
      );
    }

    // Similar logic for Y
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

  bool _wouldShowWhiteSpace(
    double translationX,
    double translationY,
    double scale,
    Size viewportSize,
    Size imageSize,
  ) {
    // Calculate the scaled image dimensions
    final double scaledImageWidth = imageSize.width * scale;
    final double scaledImageHeight = imageSize.height * scale;

    // Check if translation would show white space on any edge

    // Left edge: translation is too positive (image left edge past viewport left)
    final bool showsWhiteOnLeft = translationX > 0;

    // Right edge: image right edge doesn't reach viewport right edge
    final bool showsWhiteOnRight =
        (translationX + scaledImageWidth) < viewportSize.width;

    // Top edge: translation is too positive (image top edge past viewport top)
    final bool showsWhiteOnTop = translationY > 0;

    // Bottom edge: image bottom edge doesn't reach viewport bottom edge
    final bool showsWhiteOnBottom =
        (translationY + scaledImageHeight) < viewportSize.height;

    // Return true if any edge would show white space
    return showsWhiteOnLeft ||
        showsWhiteOnRight ||
        showsWhiteOnTop ||
        showsWhiteOnBottom;
  }

  /// Calculates the minimum scale that ensures the image fills the viewport without showing white space.
  ///
  /// Uses the larger of width/height scale ratios to ensure both dimensions are covered.
  /// This prevents any white space from appearing around the image edges.
  ///
  /// **Parameters:**
  /// - [viewportSize]: Current viewport dimensions
  /// - [imageSize]: Original image dimensions
  ///
  /// **Returns:** Minimum scale factor to fill viewport completely
  double _getMinScale(Size viewportSize, Size imageSize) {
    // Calculate the scale needed to fill each dimension
    final double scaleToFillWidth = viewportSize.width / imageSize.width;
    final double scaleToFillHeight = viewportSize.height / imageSize.height;

    // Use the larger scale to ensure both dimensions are covered
    return math.max(scaleToFillWidth, scaleToFillHeight);
  }

  /// Calculates the maximum scale to keep content at readable size while preventing over-zooming.
  ///
  /// Limits zoom to 2.2x the minimum scale or 1.5x absolute maximum, whichever is smaller.
  /// This ensures markers remain readable and the map doesn't become pixelated.
  ///
  /// **Parameters:**
  /// - [viewportSize]: Current viewport dimensions
  /// - [imageSize]: Original image dimensions
  ///
  /// **Returns:** Maximum allowed scale factor
  double _getMaxScale(Size viewportSize, Size imageSize) {
    // Start with the min scale and allow moderate zoom in
    final double minScale = _getMinScale(viewportSize, imageSize);

    // Limit zoom to prevent over-zooming - keep cruise ship at decent viewing size
    // Use a multiplier that ensures the image remains larger than viewport
    final double maxFromMin = minScale * 2.2;

    // Ensure maximum scale always keeps image larger than viewport to prevent centering
    final double safeAbsoluteMax = math.max(minScale * 1.5, 1.5);

    return math.min(maxFromMin, safeAbsoluteMax);
  }

  /// Calculates the natural scale where the image fits comfortably in the viewport.
  ///
  /// Uses the smaller of width/height ratios to fit the entire image with 5% padding.
  /// This provides an optimal initial viewing experience showing the full map.
  ///
  /// **Parameters:**
  /// - [viewportSize]: Current viewport dimensions
  /// - [imageSize]: Original image dimensions
  ///
  /// **Returns:** Natural scale factor for comfortable viewing
  double _getNaturalScale(Size viewportSize, Size imageSize) {
    // Calculate what scale would fit the image nicely in the viewport
    final double scaleToFitWidth = viewportSize.width / imageSize.width;
    final double scaleToFitHeight = viewportSize.height / imageSize.height;

    // Use the smaller scale to fit the entire image with some padding
    final double naturalFit =
        math.min(scaleToFitWidth, scaleToFitHeight) * 0.95;

    // Ensure natural scale is at least the minimum required
    final double minScale = _getMinScale(viewportSize, imageSize);
    return math.max(naturalFit, minScale);
  }

  /// Calculate a dynamic zoom step based on the scale range
  double _getZoomStep(Size viewportSize, Size imageSize) {
    final double minScale = _getMinScale(viewportSize, imageSize);
    final double maxScale = _getMaxScale(viewportSize, imageSize);

    // Make zoom step about 15% of the total scale range for smooth zooming
    return (maxScale - minScale) * 0.5;
  }

  void _resetZoom() {
    // Reset to the initial centered position if available, otherwise identity
    final Matrix4 targetMatrix = _initialCenteringMatrix ?? Matrix4.identity();
    _animateToMatrix(targetMatrix);
  }

  void _animateToMatrix(Matrix4 targetMatrix) {
    // Immediate animation start - no delays
    _zoomAnimationController.stop();

    // Direct value assignment for instant feedback, then animate
    final Matrix4 startMatrix = _transformationController.value.clone();

    // Create smooth tween with ease in and out curve
    final Matrix4Tween tween = Matrix4Tween(
      begin: startMatrix,
      end: targetMatrix,
    );

    // Create curved animation for smooth ease in/out
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _zoomAnimationController,
      curve: Curves.easeInOut,
    );

    // Smooth listener with eased animation
    void updateTransform() {
      _transformationController.value = tween.evaluate(curvedAnimation);
    }

    // Add listener and start immediately with smooth easing
    _zoomAnimationController
      ..addListener(updateTransform)
      ..reset()
      ..forward().then((_) {
        // Check if widget is still mounted before cleanup
        if (mounted) {
          _zoomAnimationController.removeListener(updateTransform);
        }
      });
  }

  void _setupInitialCentering(RenderBox? renderBox, Size imageSize) {
    // Only set initial centering if we're still at the default transformation
    final Matrix4 currentMatrix = _transformationController.value;
    if (currentMatrix != Matrix4.identity()) {
      return; // Already transformed, don't override
    }

    // Get the viewport size
    if (renderBox == null) {
      return;
    }

    final Size viewportSize = renderBox.size;

    // Use the natural scale for initial setup - this provides a good starting view
    final double initialScale = _getNaturalScale(viewportSize, imageSize);

    // Calculate translation values to focus on cruise ship area (top of island)
    final double scaledImageWidth = imageSize.width * initialScale;
    final double scaledImageHeight = imageSize.height * initialScale;

    // Center horizontally as before
    final double unclampedTranslationX =
        (viewportSize.width - scaledImageWidth) / 2;

    // Focus on cruise ship area - shift view to show upper portion of island
    // Negative Y moves the image up, showing the top part (where ship is)
    final double unclampedTranslationY = -(scaledImageHeight * 0.15);

    // Apply boundary constraints to prevent white space
    final Offset constrainedTranslation = _constrainTranslationToBounds(
      unclampedTranslationX,
      unclampedTranslationY,
      initialScale,
      viewportSize,
      imageSize,
    );

    // Set the initial transformation with constrained values
    final centeringMatrix =
        Matrix4.identity()
          ..translate(constrainedTranslation.dx, constrainedTranslation.dy)
          ..scale(initialScale);

    // Store the initial centering matrix for reset functionality
    _initialCenteringMatrix = centeringMatrix.clone();
    _transformationController.value = centeringMatrix;
  }

  /// Safely dismisses the currently displayed marker detail dialog.
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

  /// Handles taps on empty areas of the map (not on markers).
  ///
  /// Performs cleanup actions:
  /// - Dismisses any open marker detail dialogs
  /// - Collapses expanded filter controls
  /// - Clears marker selection to return to neutral state
  void _handleMapTap() {
    // Dismiss any open dialog and clear selection
    _dismissCurrentDialog();

    // Collapse filter if expanded
    _collapseFilter();

    // Clear selection when tapping empty areas of the map
    if (_selectedMarkerId != null) {
      setState(() {
        _selectedMarkerId = null;
      });
    }
  }

  void _handleFilterChanged(FilterState newFilterState) {
    setState(() {
      _filterState = newFilterState;

      // Deselect marker if it's no longer visible due to filtering
      if (_selectedMarkerId != null) {
        final InteractiveMapMarkerData selectedMarker = InteractiveMapMarkerData
            .cruiseDestinations
            .firstWhere((marker) => marker.id == _selectedMarkerId);
        if (!_filterState.isCategoryVisible(selectedMarker.category)) {
          _selectedMarkerId = null;
        }
      }
    });
  }

  void _handleFilterExpandChanged(bool isExpanded) {
    setState(() {
      _isFilterExpanded = isExpanded;
    });
  }

  void _collapseFilter() {
    if (_isFilterExpanded) {
      setState(() {
        _isFilterExpanded = false;
      });
    }
  }

  /// Animates the map to focus on a specific marker at maximum zoom level.
  ///
  /// Centers the marker in the viewport (slightly above center to account for bottom sheet)
  /// and zooms to maximum scale for detailed viewing. Uses smooth animation with bounds
  /// constraints to prevent showing white space.
  ///
  /// **Parameters:**
  /// - [marker]: The marker to focus on
  /// - [imageSize]: Current image dimensions for positioning calculations
  void _zoomToMarker(InteractiveMapMarkerData marker, Size imageSize) {
    try {
      // Get viewport size once - cache if possible
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return;
      }

      // Ultra-fast calculation with minimal operations
      final Size viewportSize = renderBox.size;

      // Use maximum scale for viewing marker details - this should be the most zoomed in level
      final double targetScale = _getMaxScale(viewportSize, imageSize);

      // Calculate marker's absolute position on the image
      final double markerAbsoluteX = marker.position.dx * imageSize.width;
      final double markerAbsoluteY = marker.position.dy * imageSize.height;

      // Calculate translation to center the marker in viewport
      // Position the marker slightly above center to account for the bottom sheet
      final double unclampedTranslationX =
          (viewportSize.width * 0.5) - (markerAbsoluteX * targetScale);
      final double unclampedTranslationY =
          (viewportSize.height * 0.4) - (markerAbsoluteY * targetScale);

      // Apply boundary constraints to prevent showing white space
      final Offset constrainedTranslation = _constrainTranslationToBounds(
        unclampedTranslationX,
        unclampedTranslationY,
        targetScale,
        viewportSize,
        imageSize,
      );

      // Direct matrix creation and animation start with constrained translation
      _animateToMatrix(
        Matrix4.identity()
          ..translate(constrainedTranslation.dx, constrainedTranslation.dy)
          ..scale(targetScale),
      );
    } catch (e) {
      // Zoom operation failed - continue silently
    }
  }

  // ========================================
  // PERFORMANCE OPTIMIZATION METHODS
  // ========================================

  /// Invalidates the marker position cache, forcing recalculation on next access.
  /// Called when image size changes or markers are updated.
  void _invalidatePositionCache() {
    _cachedMarkerPositions.clear();
  }

  /// Gets cached absolute position for a marker, calculating if not cached.
  ///
  /// **Parameters:**
  /// - [marker]: The marker to get position for
  /// - [imageSize]: Current image dimensions for calculation
  ///
  /// **Returns:** Absolute position in pixels, offset by marker center (16px)
  Offset _getCachedMarkerPosition(
    InteractiveMapMarkerData marker,
    Size imageSize,
  ) {
    // Check if position is already cached
    final String markerId = marker.id;
    if (_cachedMarkerPositions.containsKey(markerId)) {
      return _cachedMarkerPositions[markerId]!;
    }

    // Calculate and cache the position
    final double absoluteX = marker.position.dx * imageSize.width;
    final double absoluteY = marker.position.dy * imageSize.height;
    final Offset position = Offset(absoluteX - 16, absoluteY - 16);

    _cachedMarkerPositions[markerId] = position;
    return position;
  }

  void _navigateToMarkerDetails(BuildContext context, String markerId) {
    // Find the marker data for this markerId
    final InteractiveMapMarkerData markerData = InteractiveMapMarkerData
        .cruiseDestinations
        .firstWhere((marker) => marker.id == markerId);

    // Navigate to the details page
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MarkerDetailsPage(markerData: markerData),
      ),
    );
  }

  Future<Size> _getAssetImageSize(String assetPath) async {
    final completer = Completer<Size>();
    final image = AssetImage(assetPath);
    final listener = ImageStreamListener((info, _) {
      final ui.Image imageInfo = info.image;
      completer.complete(
        Size(imageInfo.width.toDouble(), imageInfo.height.toDouble()),
      );
      imageInfo.dispose();
    });
    image.resolve(ImageConfiguration.empty).addListener(listener);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Great Stirrup Cay')),
    body: Stack(
      children: [
        if (_isImageSizeLoading)
          const Center(child: CircularProgressIndicator())
        else
          _imageSize == null
              ? const InteractiveMapError()
              : Builder(
                builder: (context) {
                  final Size imageSize = _imageSize!;

                  // Set initial centering on first load
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _setupInitialCentering(
                      context.findRenderObject() as RenderBox?,
                      imageSize,
                    );
                  });

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate dynamic scale limits for InteractiveViewer
                      // Use constraints.biggest as viewport size since RenderBox may not be laid out yet
                      final Size viewportSize = constraints.biggest;
                      final double minScale = _getMinScale(
                        viewportSize,
                        imageSize,
                      );
                      final double maxScale = _getMaxScale(
                        viewportSize,
                        imageSize,
                      );

                      return Center(
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          minScale: minScale,
                          maxScale: maxScale,
                          trackpadScrollCausesScale: true,
                          constrained: false,
                          child: SizedBox(
                            height: imageSize.height,
                            width: imageSize.width,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  // Only handle map background taps, double tap, and long press
                                  onTap: _handleMapTap,
                                  onDoubleTap: _zoomIn,
                                  onLongPress: _resetZoom,
                                  child: Image.asset(
                                    _imagePath,
                                    height: imageSize.height,
                                    width: imageSize.width,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const InteractiveMapError(),
                                  ),
                                ),
                                // Simple single pass - natural order preserves widget identity for smooth animations
                                ...InteractiveMapMarkerData.cruiseDestinations.map((
                                  marker,
                                ) {
                                  final Offset cachedPosition =
                                      _getCachedMarkerPosition(
                                        marker,
                                        imageSize,
                                      );
                                  final bool isSelected =
                                      _selectedMarkerId == marker.id;

                                  return Positioned(
                                    left: cachedPosition.dx,
                                    top: cachedPosition.dy,
                                    child: InteractiveMapMarker.fromData(
                                      key: ValueKey('marker_${marker.id}'),
                                      data: marker,
                                      currentZoomTier: _getCurrentZoomTier(),
                                      scale: _currentScale,
                                      isSelected: isSelected,
                                      isVisible: _filterState.isCategoryVisible(
                                        marker.category,
                                      ),
                                      onTap: () async {
                                        if (isSelected) {
                                          // Deselect when tapping selected marker
                                          await _dismissCurrentDialog();
                                          setState(() {
                                            _selectedMarkerId = null;
                                          });
                                          return;
                                        }

                                        // Select marker
                                        await _dismissCurrentDialog();
                                        _collapseFilter();
                                        setState(() {
                                          _selectedMarkerId = marker.id;
                                        });

                                        _zoomToMarker(marker, imageSize);

                                        if (mounted &&
                                            !_isDialogShowing &&
                                            _currentDialogController == null) {
                                          _isDialogShowing = true;
                                          _currentDialogController = Scaffold.of(
                                            context,
                                          ).showBottomSheet(
                                            (
                                              context,
                                            ) => InteractiveMapMarketDetail.fromMarkerData(
                                              markerData: marker,
                                              actionButtonText:
                                                  InteractiveMapMarkerData.getActionButtonText(
                                                    marker.id,
                                                  ),
                                              onActionPressed: () {
                                                Navigator.of(context).pop();
                                                _currentDialogController = null;
                                                _isDialogShowing = false;
                                                setState(() {
                                                  _selectedMarkerId = null;
                                                });
                                                _navigateToMarkerDetails(
                                                  context,
                                                  marker.id,
                                                );
                                              },
                                            ),
                                            backgroundColor: Colors.transparent,
                                            enableDrag: true,
                                          );
                                          await _currentDialogController!.closed
                                              .then((_) {
                                                _currentDialogController = null;
                                                _isDialogShowing = false;
                                                if (mounted) {
                                                  setState(() {
                                                    _selectedMarkerId = null;
                                                  });
                                                }
                                              });
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
        // Legend
        const Positioned(top: 8, left: 8, child: InteractiveMapLegend()),
        // Filter Controls
        Positioned(
          top: 8,
          right: 8,
          child: InteractiveMapFilter(
            onFilterChanged: _handleFilterChanged,
            initialState: _filterState,
            isExpanded: _isFilterExpanded,
            onExpandChanged: _handleFilterExpandChanged,
          ),
        ),
        // Zoom Controls
        Positioned(
          right: 16,
          bottom: 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'zoom_in',
                mini: true,
                onPressed: _zoomIn,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'zoom_out',
                mini: true,
                onPressed: _zoomOut,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'reset_zoom',
                mini: true,
                onPressed: _resetZoom,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                child: const Icon(Icons.center_focus_strong),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
