import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/interactive_map_marker_data.dart';

class InteractiveMapMarker extends StatefulWidget {
  const InteractiveMapMarker({
    required this.markerId,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.currentZoomTier,
    required this.markerZoomTier,
    this.scale = 1.0,
    this.isSelected = false,
    this.isVisible = true,
    super.key,
  });

  /// Factory constructor to create marker from configuration data
  factory InteractiveMapMarker.fromData({
    required InteractiveMapMarkerData data,
    required VoidCallback onTap,
    required ZoomTier currentZoomTier,
    double scale = 1.0,
    bool isSelected = false,
    bool isVisible = true,
    Key? key,
  }) => InteractiveMapMarker(
    markerId: data.id,
    title: data.title,
    description: data.description,
    icon: data.icon,
    color: data.color,
    onTap: onTap,
    currentZoomTier: currentZoomTier,
    markerZoomTier: data.zoomTier,
    scale: scale,
    isSelected: isSelected,
    isVisible: isVisible,
    key: key,
  );

  final String markerId;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final ZoomTier currentZoomTier;
  final ZoomTier markerZoomTier;
  final double scale;
  final bool isSelected;
  final bool isVisible;

  @override
  State<InteractiveMapMarker> createState() => _InteractiveMapMarkerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('markerId', markerId))
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(ColorProperty('color', color))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap))
      ..add(DoubleProperty('scale', scale))
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}

class _InteractiveMapMarkerState extends State<InteractiveMapMarker>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _pulseController;
  late final AnimationController _visibilityController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _visibilityOpacityAnimation;
  late final Animation<double> _visibilityScaleAnimation;
  static const Duration _scaleDuration = Duration(milliseconds: 300);
  static const Duration _pulseDuration = Duration(milliseconds: 1000);
  static const Duration _visibilityDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: _scaleDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: _pulseDuration,
      vsync: this,
    );

    _visibilityController = AnimationController(
      duration: _visibilityDuration,
      vsync: this,
    );

    // Create smooth scale animation
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.3, // 30% larger when selected
    ).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Create pulsing glow animation for selected state
    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Create visibility animations
    _visibilityOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _visibilityController, curve: Curves.easeInOut),
    );

    _visibilityScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _visibilityController, curve: Curves.easeOutBack),
    );

    // Set initial animation state based on isVisible and isSelected
    if (widget.isVisible) {
      _visibilityController.value = 1.0; // Fully visible
    } else {
      _visibilityController.value = 0.0; // Hidden
    }

    // Set initial animation state based on isSelected
    if (widget.isSelected) {
      _scaleController.value = 1.0; // Set to end of animation (scaled up)
      _pulseController.repeat(reverse: true); // Start pulsing
    } else {
      _scaleController.value =
          0.0; // Set to beginning of animation (normal size)
      _pulseController.stop();
    }
  }

  @override
  void didUpdateWidget(InteractiveMapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // React to visibility changes from parent
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _visibilityController.forward();
      } else {
        _visibilityController.reverse();
      }
    }

    // React to selection changes from parent
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _scaleController.forward();
        _pulseController.repeat(reverse: true); // Start pulsing when selected
      } else {
        _scaleController.reverse();
        _pulseController.stop(); // Stop pulsing when deselected
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    _visibilityController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Trigger parent callback - parent manages selection state
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([
      _visibilityOpacityAnimation,
      _visibilityScaleAnimation,
    ]),
    builder:
        (context, child) => Opacity(
          opacity: _visibilityOpacityAnimation.value,
          child: Transform.scale(
            scale: _visibilityScaleAnimation.value,
            child: child,
          ),
        ),
    child: AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        // Combine selection scale with zoom inverse scale
        final double combinedScale =
            _scaleAnimation.value * (1.0 / widget.scale);
        return Transform.scale(scale: combinedScale, child: child);
      },
      child: _MarkerPin(
        color: widget.color,
        icon: widget.icon,
        onTap: _handleTap,
        title: widget.title,
        scale: 1, // Pass 1.0 since we handle scaling above
        currentZoomTier: widget.currentZoomTier,
        markerZoomTier: widget.markerZoomTier,
        glowOpacity: widget.isSelected ? _pulseAnimation.value : 0.0,
      ),
    ),
  );
}

class _MarkerPin extends StatefulWidget {
  const _MarkerPin({
    required this.color,
    required this.icon,
    required this.onTap,
    required this.title,
    required this.scale,
    required this.currentZoomTier,
    required this.markerZoomTier,
    this.glowOpacity = 0.0,
  });

  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final String title;
  final double scale;
  final ZoomTier currentZoomTier;
  final ZoomTier markerZoomTier;
  final double glowOpacity;

  @override
  State<_MarkerPin> createState() => _MarkerPinState();
}

class _MarkerPinState extends State<_MarkerPin> with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textScaleAnimation;

  /// Determine text visibility for a specific zoom tier
  bool _shouldShowTextForTier(ZoomTier zoomTier) {
    switch (widget.markerZoomTier) {
      case ZoomTier.essential:
        // Essential markers always show text
        return true;
      case ZoomTier.medium:
        // Medium markers show text at medium and detailed zoom
        return zoomTier == ZoomTier.medium || zoomTier == ZoomTier.detailed;
      case ZoomTier.detailed:
        // Detailed markers only show text at detailed zoom
        return zoomTier == ZoomTier.detailed;
    }
  }

  /// Determine pin size based on zoom tiers
  double _getPinSize() {
    switch (widget.markerZoomTier) {
      case ZoomTier.essential:
        // Essential markers always use full size
        return 32.0;
      case ZoomTier.medium:
        // Medium markers use full size at medium/detailed, slightly smaller at essential
        return widget.currentZoomTier == ZoomTier.essential ? 28.0 : 32.0;
      case ZoomTier.detailed:
        // Detailed markers: full at detailed, medium at medium, small at essential
        switch (widget.currentZoomTier) {
          case ZoomTier.detailed:
            return 32.0;
          case ZoomTier.medium:
            return 26.0;
          case ZoomTier.essential:
            return 20.0;
        }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize text animation controller
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    // Create smooth opacity animation
    _textOpacityAnimation = CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    );

    // Create subtle scale animation for text
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Set initial state
    if (_shouldShowTextForTier(widget.currentZoomTier)) {
      _textAnimationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_MarkerPin oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate text visibility changes
    final bool shouldShow = _shouldShowTextForTier(widget.currentZoomTier);
    final bool wasShowing =
        oldWidget.currentZoomTier != widget.currentZoomTier
            ? _shouldShowTextForTier(oldWidget.currentZoomTier)
            : _textAnimationController.value > 0.5;

    if (shouldShow && !wasShowing) {
      _textAnimationController.forward();
    } else if (!shouldShow && wasShowing) {
      _textAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine pin size based on zoom tiers
    final double pinSize = _getPinSize();
    final double iconSize = pinSize * 0.5;

    return AnimatedBuilder(
      animation: Listenable.merge([_textOpacityAnimation, _textScaleAnimation]),
      builder:
          (context, child) => SizedBox(
            width: 160, // Increased width for longer text labels
            height: 80, // Enough height for pin + text
            child: Stack(
              alignment: Alignment.center,
              // Allow text to extend beyond bounds if needed
              clipBehavior: Clip.none,
              children: [
                // Pulsing glow effect for selected markers - centered on pin
                if (widget.glowOpacity > 0)
                  Container(
                    width: pinSize + 8,
                    height: pinSize + 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(
                            alpha: widget.glowOpacity,
                          ),
                          blurRadius: 20,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),

                // Marker pin (clickable) - centered and fixed position
                GestureDetector(
                  onTap: widget.onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: pinSize,
                    height: pinSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: pinSize > 24 ? 3 : 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.3),
                          blurRadius: pinSize > 24 ? 12 : 8,
                          spreadRadius: pinSize > 24 ? 3 : 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      size: iconSize,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Animated label positioned below pin - fixed offset from pin center
                Positioned(
                  // Pin bottom edge + gap (40px center + half pin size + gap)
                  top: 40 + (pinSize / 2) + 2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _textAnimationController,
                      builder:
                          (context, child) => Opacity(
                            opacity: _textOpacityAnimation.value,
                            child: Transform.scale(
                              scale: _textScaleAnimation.value,
                              child: GestureDetector(
                                onTap: widget.onTap,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: widget.color,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    widget.title,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', widget.color))
      ..add(DiagnosticsProperty<IconData>('icon', widget.icon))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', widget.onTap))
      ..add(StringProperty('title', widget.title))
      ..add(DoubleProperty('scale', widget.scale))
      ..add(DoubleProperty('glowOpacity', widget.glowOpacity))
      ..add(EnumProperty<ZoomTier>('currentZoomTier', widget.currentZoomTier))
      ..add(EnumProperty<ZoomTier>('markerZoomTier', widget.markerZoomTier));
  }
}
