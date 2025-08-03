import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

import '../models/cruise_itinerary.dart';
import 'cruise_route_painter.dart';
import 'itinerary_bottom_section.dart';
import 'port_marker.dart';

/// Interactive cruise itinerary map with animated day-by-day storytelling
class ItineraryMap extends StatefulWidget {
  const ItineraryMap({
    super.key,
    required this.itinerary,
    this.selectedDay,
    this.onDaySelected,
  });

  final CruiseItinerary itinerary;
  final ItineraryDay? selectedDay;
  final Function(ItineraryDay)? onDaySelected;

  @override
  State<ItineraryMap> createState() => _ItineraryMapState();
}

class _ItineraryMapState extends State<ItineraryMap>
    with TickerProviderStateMixin {
  // ========================================
  // ASSET CONFIGURATION (Now from CruiseItinerary model)
  // ========================================

  // ========================================
  // TRANSFORMATION & SCALING STATE
  // ========================================

  /// Controls pan, zoom, and transformation of the map view
  late final TransformationController _transformationController;

  /// Stores the initial centered view matrix
  Matrix4? _initialCenteringMatrix;

  // ========================================
  // IMAGE SIZE CACHING
  // ========================================

  /// Cached dimensions of the map image
  Size? _imageSize;

  /// Flag indicating if image size is still being loaded
  bool _isImageSizeLoading = true;

  // ========================================
  // ANIMATION CONTROLLERS
  // ========================================

  /// Controls smooth camera movements between days
  late final AnimationController _cameraAnimationController;

  /// Controls storytelling animations (fade-ins, etc.)
  late final AnimationController _storyAnimationController;

  /// Controls route progress animations
  late final AnimationController _routeProgressController;

  /// Duration for camera movements between days
  static const Duration _cameraAnimationDuration = Duration(milliseconds: 1200);

  /// Duration for storytelling element animations
  static const Duration _storyAnimationDuration = Duration(milliseconds: 800);

  /// Duration for route progress animations
  static const Duration _routeProgressDuration = Duration(milliseconds: 600);

  // ========================================
  // STORYTELLING STATE
  // ========================================

  /// Flag to prevent animation conflicts
  bool _isAnimating = false;

  /// Current animated route progress (0.0 to 1.0)
  double _routeAnimationProgress = 1.0;

  /// Previous day for animation calculation
  ItineraryDay? _previousDay;

  @override
  void initState() {
    super.initState();

    // Initialize transformation controller
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);

    // Initialize animation controllers
    _cameraAnimationController = AnimationController(
      duration: _cameraAnimationDuration,
      vsync: this,
    );

    _storyAnimationController = AnimationController(
      duration: _storyAnimationDuration,
      vsync: this,
    );

    _routeProgressController = AnimationController(
      duration: _routeProgressDuration,
      vsync: this,
    );

    // Set up route progress animation listener
    _routeProgressController.addListener(() {
      setState(() {
        _routeAnimationProgress = _routeProgressController.value;
      });
    });

    // Initialize previous day for proper animation starting point
    if (widget.selectedDay != null) {
      final selectedDayIndex = widget.itinerary.days.indexOf(
        widget.selectedDay!,
      );
      if (selectedDayIndex > 0) {
        _previousDay = widget.itinerary.days[selectedDayIndex - 1];
      }
    }

    // Load image size
    _loadImageSize();
  }

  /// Calculate route progress for a specific day
  double _calculateDayProgress(ItineraryDay day) {
    final dayIndex = widget.itinerary.days.indexOf(day);
    if (dayIndex < 0) return 0.0;

    // Generate route positions to get port count
    final routePositions = _generateRoutePositions();
    if (routePositions.length < 2) return 0.0;

    if (day.port != null) {
      // Port day - find the port index
      int portIndex = 0;
      for (int i = 0; i <= dayIndex && i < widget.itinerary.days.length; i++) {
        if (widget.itinerary.days[i].port != null) {
          if (i == dayIndex) break;
          portIndex++;
        }
      }
      return portIndex / (routePositions.length - 1);
    } else {
      // Sea day - calculate progressive position between ports
      return _calculateSeaDayProgress(dayIndex, routePositions.length);
    }
  }

  /// Calculate progressive position for sea days between ports
  double _calculateSeaDayProgress(int seaDayIndex, int totalRoutePositions) {
    // Find the previous and next port around this sea day
    int previousPortDayIndex = -1;
    int nextPortDayIndex = -1;
    int previousPortIndex = -1;
    int nextPortIndex = -1;
    int portIndex = 0;

    // Find previous port
    for (int i = seaDayIndex - 1; i >= 0; i--) {
      if (widget.itinerary.days[i].port != null) {
        previousPortDayIndex = i;
        previousPortIndex = portIndex;
        break;
      }
    }

    // Count ports up to the previous port
    portIndex = 0;
    for (int i = 0; i < widget.itinerary.days.length; i++) {
      if (widget.itinerary.days[i].port != null) {
        if (i == previousPortDayIndex) {
          previousPortIndex = portIndex;
          break;
        }
        portIndex++;
      }
    }

    // Find next port and its index
    portIndex = 0;
    for (int i = 0; i < widget.itinerary.days.length; i++) {
      if (widget.itinerary.days[i].port != null) {
        if (i > seaDayIndex) {
          nextPortDayIndex = i;
          nextPortIndex = portIndex;
          break;
        }
        portIndex++;
      }
    }

    // If we found both ports, calculate progressive position
    if (previousPortDayIndex >= 0 &&
        nextPortDayIndex >= 0 &&
        previousPortIndex >= 0 &&
        nextPortIndex >= 0 &&
        nextPortIndex < totalRoutePositions) {
      // Count consecutive sea days between these ports
      final seaDaysCount = nextPortDayIndex - previousPortDayIndex - 1;

      if (seaDaysCount > 0) {
        // Calculate which sea day this is in the sequence (1-based)
        final seaDayPosition = seaDayIndex - previousPortDayIndex;

        // Calculate fractional progress along the segment
        final segmentProgress = seaDayPosition / (seaDaysCount + 1);

        // Calculate final progress considering the port positions
        final previousPortProgress =
            previousPortIndex / (totalRoutePositions - 1);
        final nextPortProgress = nextPortIndex / (totalRoutePositions - 1);

        return previousPortProgress +
            (segmentProgress * (nextPortProgress - previousPortProgress));
      }
    }

    // Fallback: if we can't calculate progressive position, use previous logic
    if (previousPortIndex >= 0 &&
        nextPortIndex >= 0 &&
        nextPortIndex < totalRoutePositions) {
      return (previousPortIndex + 0.5) / (totalRoutePositions - 1);
    }

    // Final fallback: use the previous port position
    if (previousPortIndex >= 0) {
      return previousPortIndex / (totalRoutePositions - 1);
    }

    return 0.0;
  }

  /// Animate route progress between days
  void _animateRouteProgress(ItineraryDay? fromDay, ItineraryDay toDay) {
    // Store the previous day for animation calculation
    _previousDay = fromDay;

    // Reset and animate route progress
    _routeProgressController.reset();
    _routeProgressController.forward();
  }

  @override
  void didUpdateWidget(ItineraryMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If selected day changed, animate route progress and camera
    if (oldWidget.selectedDay != widget.selectedDay &&
        widget.selectedDay != null) {
      _animateRouteProgress(oldWidget.selectedDay, widget.selectedDay!);
      _animateToDay(widget.selectedDay!);
    }
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    _cameraAnimationController.dispose();
    _storyAnimationController.dispose();
    _routeProgressController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    // Update UI when transformation changes (pan only, since zoom is disabled)
    if (mounted) {
      setState(() {
        // Transformation changed, UI will update for any pan-dependent elements
      });
    }
  }

  Future<void> _loadImageSize() async {
    try {
      final Size imageSize = await _getAssetImageSize(
        widget.itinerary.mapImagePath,
      );
      if (mounted) {
        setState(() {
          _imageSize = imageSize;
          _isImageSizeLoading = false;
        });
      }
    } catch (e) {
      // Error loading itinerary map silently handled
      if (mounted) {
        setState(() {
          _isImageSizeLoading = false;
        });
      }
    }
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

  /// Animates the camera to focus on a specific day in the storyline
  void _animateToDay(ItineraryDay day) {
    if (_isAnimating || _imageSize == null) return;

    setState(() {
      _isAnimating = true;
    });

    // Calculate target position and zoom for this day
    _animateToMatrix(_calculateDayMatrix(day));
  }

  /// Calculates the optimal camera matrix for viewing a specific day
  Matrix4 _calculateDayMatrix(ItineraryDay day) {
    if (_imageSize == null) return Matrix4.identity();

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return Matrix4.identity();

    final Size viewportSize = renderBox.size;
    final Size imageSize = _imageSize!;

    // Use the same minimum scale that fills the entire viewport (including bottom sheet area)
    final double targetScale = _getMinScale(viewportSize, imageSize);

    // Get the day index to find its position on the circular route
    final dayIndex = widget.itinerary.days.indexOf(day);

    // Get the focus position for this day using circular route
    final focusPosition = _getDayPosition(dayIndex);

    // Position marker slightly above center in the viewport
    final double unclampedTranslationX =
        (viewportSize.width * 0.5) - (focusPosition.dx * targetScale);
    final double unclampedTranslationY =
        (viewportSize.height * 0.4) - (focusPosition.dy * targetScale);

    // Apply boundary constraints using full viewport (to allow panning to edges)
    final Offset constrainedTranslation = _constrainTranslationToBounds(
      unclampedTranslationX,
      unclampedTranslationY,
      targetScale,
      viewportSize, // Use full viewport for boundary constraints
      imageSize,
    );

    return Matrix4.identity()
      ..translate(constrainedTranslation.dx, constrainedTranslation.dy)
      ..scale(targetScale);
  }

  void _animateToMatrix(Matrix4 targetMatrix) {
    _cameraAnimationController.stop();

    final Matrix4 startMatrix = _transformationController.value.clone();

    final Matrix4Tween tween = Matrix4Tween(
      begin: startMatrix,
      end: targetMatrix,
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _cameraAnimationController,
      curve: Curves.easeInOutCubic,
    );

    void updateTransform() {
      _transformationController.value = tween.evaluate(curvedAnimation);
    }

    _cameraAnimationController
      ..addListener(updateTransform)
      ..reset()
      ..forward().then((_) {
        _cameraAnimationController.removeListener(updateTransform);
        if (mounted) {
          setState(() {
            _isAnimating = false;
          });
        }
        // Start story animation
        _storyAnimationController.forward();
      });
  }

  /// Constrains translation values to prevent showing white space around the image.
  /// Uses the proven approach from interactive_map implementation.
  Offset _constrainTranslationToBounds(
    double translationX,
    double translationY,
    double scale,
    Size viewportSize,
    Size imageSize,
  ) {
    // Calculate the scaled image dimensions
    final double scaledImageWidth = imageSize.width * scale;
    // Use padded height for boundary constraints
    final double paddedImageHeight = imageSize.height + 250.0;
    final double scaledImageHeight = paddedImageHeight * scale;

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

  /// Calculates the minimum scale that ensures the image fills the viewport without white space.
  /// Uses the larger of width/height scale ratios to ensure both dimensions are covered.
  double _getMinScale(Size viewportSize, Size imageSize) {
    final double scaleToFillWidth = viewportSize.width / imageSize.width;
    // Add bottom padding to image height for scale calculation
    final double paddedImageHeight = imageSize.height + 250.0;
    final double scaleToFillHeight = viewportSize.height / paddedImageHeight;

    // Use the larger scale to ensure both dimensions are covered
    return math.max(scaleToFillWidth, scaleToFillHeight);
  }

  void _handleMapTap(TapDownDetails details) {
    final tapPosition = details.localPosition;

    // Convert tap position to image coordinates
    final Matrix4 matrix = _transformationController.value;
    final Matrix4 inverted = Matrix4.inverted(matrix);
    final vector_math.Vector3 tapVector = vector_math.Vector3(
      tapPosition.dx,
      tapPosition.dy,
      0.0,
    );

    final vector_math.Vector3 imageCoords = inverted.transform3(tapVector);

    if (_imageSize == null) return;

    // Find the nearest port to tap location
    ItineraryDay? nearestDay;
    double nearestDistance = double.infinity;

    for (int i = 0; i < widget.itinerary.days.length; i++) {
      final day = widget.itinerary.days[i];
      if (day.port == null) continue;

      final portPosition = _getDayPosition(i); // Now uses day position directly
      final distance =
          (Offset(imageCoords.x, imageCoords.y) - portPosition).distance;

      if (distance < 60 && distance < nearestDistance) {
        // Increased for larger markers
        nearestDistance = distance;
        nearestDay = day;
      }
    }

    if (nearestDay != null) {
      widget.onDaySelected?.call(nearestDay);
    }
  }

  /// Convert image pixel coordinates to screen coordinates
  Offset _imageCoordinatesToScreen(List<double> imageCoords) {
    if (_imageSize == null || imageCoords.length < 2) return Offset.zero;

    // Image coordinates are [x, y] pixels on the original image
    final double imageX = imageCoords[0];
    final double imageY = imageCoords[1];

    // Convert to Offset relative to image size
    return Offset(imageX, imageY);
  }

  /// Get position for any day using actual coordinate data
  Offset _getDayPosition(int dayIndex) {
    if (_imageSize == null) return Offset.zero;

    final totalDays = widget.itinerary.days.length;
    if (dayIndex >= totalDays) return Offset.zero;

    final day = widget.itinerary.days[dayIndex];

    // For port days, use the port's actual coordinates
    if (day.port != null) {
      return _imageCoordinatesToScreen(day.port!.coordinates);
    }

    // For sea days, interpolate between the previous and next port positions
    return _getSeaDayPosition(dayIndex);
  }

  /// Generate route positions based on port positions only (skip sea days)
  List<Offset> _generateRoutePositions() {
    if (_imageSize == null) return [];

    final List<Offset> routePositions = [];

    // Create route points only for port days
    for (int i = 0; i < widget.itinerary.days.length; i++) {
      final day = widget.itinerary.days[i];
      if (day.port != null) {
        final portPosition = _imageCoordinatesToScreen(day.port!.coordinates);
        routePositions.add(portPosition);
      }
    }

    return routePositions;
  }

  /// Calculate position for sea days by interpolating between ports
  Offset _getSeaDayPosition(int dayIndex) {
    if (_imageSize == null) return Offset.zero;

    final totalDays = widget.itinerary.days.length;

    // Find the previous port day
    PortData? previousPort;
    for (int i = dayIndex - 1; i >= 0; i--) {
      if (widget.itinerary.days[i].port != null) {
        previousPort = widget.itinerary.days[i].port;
        break;
      }
    }

    // Find the next port day
    PortData? nextPort;
    for (int i = dayIndex + 1; i < totalDays; i++) {
      if (widget.itinerary.days[i].port != null) {
        nextPort = widget.itinerary.days[i].port;
        break;
      }
    }

    // If we have both previous and next ports, interpolate between them
    if (previousPort != null && nextPort != null) {
      final prevPosition = _imageCoordinatesToScreen(previousPort.coordinates);
      final nextPosition = _imageCoordinatesToScreen(nextPort.coordinates);

      // Simple linear interpolation (could be enhanced with route curves)
      return Offset(
        (prevPosition.dx + nextPosition.dx) / 2,
        (prevPosition.dy + nextPosition.dy) / 2,
      );
    }

    // Fallback to center if no ports found
    return Offset(_imageSize!.width * 0.5, _imageSize!.height * 0.5);
  }

  @override
  Widget build(BuildContext context) {
    if (_isImageSizeLoading) {
      return Container(
        color: Colors.blue.shade50,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading Itinerary Map...'),
            ],
          ),
        ),
      );
    }

    if (_imageSize == null) {
      return Container(
        color: Colors.blue.shade50,
        child: const Center(child: Text('Failed to load map')),
      );
    }

    return Stack(
      children: [
        // Interactive Map Section (full screen)
        LayoutBuilder(
          builder: (context, constraints) {
            final Size viewportSize = constraints.biggest;
            final Size imageSize = _imageSize!;

            // Set initial centering - map at natural size
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_initialCenteringMatrix == null) {
                _setupInitialCentering(viewportSize, imageSize);
              }
            });

            // Calculate minimum scale to fill viewport and prevent white space
            final double minScale = _getMinScale(viewportSize, imageSize);

            return Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: minScale, // Calculated to fill viewport
                maxScale: minScale, // Fixed scale to disable zoom
                scaleEnabled: false,
                trackpadScrollCausesScale: false,
                constrained: false,
                child: SizedBox(
                  width: imageSize.width,
                  height:
                      imageSize.height + 250.0, // Add bottom padding for sheet
                  child: Stack(
                    children: [
                      // Map Background
                      GestureDetector(
                        onTapDown: _handleMapTap,
                        child: Image.asset(
                          widget.itinerary.mapImagePath,
                          width: imageSize.width,
                          height: imageSize.height,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: imageSize.width,
                                height: imageSize.height,
                                color: Colors.blue.shade100,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.map_outlined,
                                        size: 64,
                                        color: Colors.blue.shade300,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Caribbean Cruise Route',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Map temporarily unavailable',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ),
                      ),

                      // Route Path
                      CustomPaint(
                        size: imageSize,
                        painter: CruiseRoutePainter(
                          itinerary: widget.itinerary,
                          selectedDay: widget.selectedDay,
                          imageSize: imageSize,
                          routePositions: _generateRoutePositions(),
                          animationProgress: _routeAnimationProgress,
                          fromDayProgress:
                              _previousDay != null
                                  ? _calculateDayProgress(_previousDay!)
                                  : (widget.selectedDay != null
                                      ? _calculateDayProgress(
                                        widget.selectedDay!,
                                      )
                                      : 0.0),
                          toDayProgress:
                              widget.selectedDay != null
                                  ? _calculateDayProgress(widget.selectedDay!)
                                  : 1.0,
                        ),
                      ),

                      // Port Markers
                      ...widget.itinerary.days
                          .asMap()
                          .entries
                          .where((entry) => entry.value.port != null)
                          .map(
                            (entry) => _buildPortMarker(entry.value, entry.key),
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Bottom Section - Fixed size overlay
        if (widget.selectedDay != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ItineraryBottomSection(
                day: widget.selectedDay!,
                itinerary: widget.itinerary,
                onDaySelected: widget.onDaySelected,
                onHeightChanged:
                    (height) {}, // No-op since we're not using this anymore
              ),
            ),
          ),
      ],
    );
  }

  void _setupInitialCentering(Size viewportSize, Size imageSize) {
    if (_initialCenteringMatrix != null) return;

    // Use the minimum scale that fills the entire viewport (including bottom sheet area)
    final double initialScale = _getMinScale(viewportSize, imageSize);

    // Calculate scaled image dimensions (with bottom padding)
    final double scaledImageWidth = imageSize.width * initialScale;
    final double paddedImageHeight = imageSize.height + 250.0;
    final double scaledImageHeight = paddedImageHeight * initialScale;

    // Center the scaled image in the viewport
    final double desiredTranslationX =
        (viewportSize.width - scaledImageWidth) / 2;
    final double desiredTranslationY =
        (viewportSize.height - scaledImageHeight) / 2;

    // Apply boundary constraints using full viewport (to allow panning to edges)
    final Offset constrainedTranslation = _constrainTranslationToBounds(
      desiredTranslationX,
      desiredTranslationY,
      initialScale,
      viewportSize, // Use full viewport for boundary constraints
      imageSize,
    );

    _initialCenteringMatrix =
        Matrix4.identity()
          ..translate(constrainedTranslation.dx, constrainedTranslation.dy)
          ..scale(initialScale);

    _transformationController.value = _initialCenteringMatrix!;

    // Set the view to the selected day immediately without animation
    if (widget.selectedDay != null) {
      final dayMatrix = _calculateDayMatrix(widget.selectedDay!);
      _transformationController.value = dayMatrix;
    }
  }

  Widget _buildPortMarker(ItineraryDay day, int dayIndex) {
    final port = day.port!;
    final position = _getDayPosition(
      dayIndex,
    ); // Now uses day position directly
    final isSelected = widget.selectedDay?.port?.id == port.id;

    if (day.dayType == ItineraryDayType.sea) {
      return const SizedBox.shrink(); // No marker for sea days
    }

    return Positioned(
      left: position.dx - 12, // Center the 24px wide marker
      top: position.dy - 12, // Center the pin at coordinate
      child: PortMarker(
        day: day,
        isSelected: isSelected,
        onTap: () => widget.onDaySelected?.call(day),
      ),
    );
  }
}
