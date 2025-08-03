import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

import '../models/ship_deck_data.dart';

/// A mini-map widget that shows an overview of the deck plan for informational purposes.
///
/// This widget displays:
/// - A scaled-down version of the deck plan image
/// - A red viewport indicator showing the current viewing area
class DeckMiniMap extends StatelessWidget {
  const DeckMiniMap({
    super.key,
    required this.imageSize,
    required this.currentDeck,
    required this.transformationController,
    required this.viewportSize,
    this.size = 150.0,
  });

  /// The size of the full deck plan image
  final Size imageSize;

  /// The current deck data containing image URL and other details
  final ShipDeckInfo currentDeck;

  /// The transformation controller from the main map view
  final TransformationController transformationController;

  /// The viewport size of the main map view
  final Size viewportSize;

  /// The size of the mini-map container (default: 150.0)
  final double size;

  @override
  Widget build(BuildContext context) {
    try {
      // Validate input data
      if (!_isValidImageSize(imageSize) ||
          !_isValidViewportSize(viewportSize) ||
          currentDeck.imageUrl.isEmpty) {
        return const SizedBox.shrink(); // Hide mini-map if data is invalid
      }

      // Calculate mini-map scale to fit the image in the mini-map container
      final double miniMapScale =
          size / math.max(imageSize.width, imageSize.height);
      final double miniMapWidth = imageSize.width * miniMapScale;
      final double miniMapHeight = imageSize.height * miniMapScale;

      // Validate calculated dimensions
      if (!miniMapWidth.isFinite ||
          !miniMapHeight.isFinite ||
          miniMapWidth <= 0 ||
          miniMapHeight <= 0) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            // Mini deck plan image
            Positioned(
              left: 0, // Align to left edge
              top: (size - miniMapHeight) / 2,
              child: _buildMiniMapImage(context, miniMapWidth, miniMapHeight),
            ),
            // Current viewing area indicator
            _buildViewportIndicator(miniMapWidth, miniMapHeight, imageSize),
          ],
        ),
      );
    } catch (e) {
      // If any error occurs, hide the mini-map gracefully
      debugPrint('DeckMiniMap error: $e');
      return const SizedBox.shrink();
    }
  }

  /// Validates if the image size is valid for mini-map rendering
  bool _isValidImageSize(Size size) {
    return size.width > 0 &&
        size.height > 0 &&
        size.width.isFinite &&
        size.height.isFinite;
  }

  /// Validates if the viewport size is valid for calculations
  bool _isValidViewportSize(Size size) {
    return size.width > 0 &&
        size.height > 0 &&
        size.width.isFinite &&
        size.height.isFinite;
  }

  /// Builds the mini-map image
  Widget _buildMiniMapImage(BuildContext context, double width, double height) {
    try {
      // Check if this is an SVG file
      if (currentDeck.imageUrl.toLowerCase().endsWith('.svg')) {
        if (currentDeck.imageUrl.startsWith('assets/')) {
          // SVG asset using jovial_svg
          return SizedBox(
            width: width,
            height: height,
            child: ScalableImageWidget.fromSISource(
              si: ScalableImageSource.fromSvg(
                DefaultAssetBundle.of(context),
                currentDeck.imageUrl,
              ),
              fit: BoxFit.contain,
            ),
          );
        } else {
          // Network SVG using jovial_svg
          return SizedBox(
            width: width,
            height: height,
            child: ScalableImageWidget.fromSISource(
              si: ScalableImageSource.fromSvgHttpUrl(
                Uri.parse(currentDeck.imageUrl),
              ),
              fit: BoxFit.contain,
            ),
          );
        }
      }

      // Handle regular images (PNG, JPG, etc.)
      if (currentDeck.imageUrl.startsWith('assets/')) {
        return Image.asset(
          currentDeck.imageUrl,
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Hide mini-map completely if image fails to load
            return const SizedBox.shrink();
          },
        );
      } else {
        return Image.network(
          currentDeck.imageUrl,
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Hide mini-map completely if image fails to load
            return const SizedBox.shrink();
          },
        );
      }
    } catch (e) {
      // Hide mini-map completely if any error occurs
      return const SizedBox.shrink();
    }
  }

  /// Builds the current viewport indicator rectangle
  Widget _buildViewportIndicator(
    double miniMapWidth,
    double miniMapHeight,
    Size imageSize,
  ) {
    try {
      final Matrix4 currentMatrix = transformationController.value;
      final double currentScale = currentMatrix.getMaxScaleOnAxis();

      // Validate scale to prevent division by zero
      if (!currentScale.isFinite || currentScale <= 0) {
        return const SizedBox.shrink();
      }

      final vector_math.Vector3 translation = currentMatrix.getTranslation();

      // Calculate what portion of the image is currently visible
      final double visibleWidth = viewportSize.width / currentScale;
      final double visibleHeight = viewportSize.height / currentScale;

      // Validate calculations
      if (!visibleWidth.isFinite ||
          !visibleHeight.isFinite ||
          visibleWidth <= 0 ||
          visibleHeight <= 0) {
        return const SizedBox.shrink();
      }

      // Convert to relative coordinates (0.0 to 1.0)
      final double relativeLeft =
          (-translation.x / currentScale) / imageSize.width;
      final double relativeTop =
          (-translation.y / currentScale) / imageSize.height;
      final double relativeWidth = visibleWidth / imageSize.width;
      final double relativeHeight = visibleHeight / imageSize.height;

      // Validate relative coordinates
      if (!relativeLeft.isFinite ||
          !relativeTop.isFinite ||
          !relativeWidth.isFinite ||
          !relativeHeight.isFinite) {
        return const SizedBox.shrink();
      }

      // Convert to mini-map coordinates
      final double indicatorLeft = relativeLeft * miniMapWidth;
      final double indicatorTop = relativeTop * miniMapHeight;
      final double indicatorWidth = relativeWidth * miniMapWidth;
      final double indicatorHeight = relativeHeight * miniMapHeight;

      // Validate mini-map coordinates
      if (!indicatorLeft.isFinite ||
          !indicatorTop.isFinite ||
          !indicatorWidth.isFinite ||
          !indicatorHeight.isFinite) {
        return const SizedBox.shrink();
      }

      // Ensure valid clamp bounds by limiting indicator size first
      final double clampedIndicatorWidth = indicatorWidth.clamp(
        4,
        miniMapWidth,
      );
      final double clampedIndicatorHeight = indicatorHeight.clamp(
        4,
        miniMapHeight,
      );

      // Final validation of clamped values
      final double maxLeft = (miniMapWidth - clampedIndicatorWidth).clamp(
        0,
        miniMapWidth,
      );
      final double maxTop = (miniMapHeight - clampedIndicatorHeight).clamp(
        0,
        miniMapHeight,
      );

      return Positioned(
        left: indicatorLeft.clamp(0, maxLeft),
        top: (size - miniMapHeight) / 2 + indicatorTop.clamp(0, maxTop),
        child: Container(
          width: clampedIndicatorWidth,
          height: clampedIndicatorHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.black.withValues(alpha: 0.2),
          ),
        ),
      );
    } catch (e) {
      // If calculations fail, hide the viewport indicator
      debugPrint('DeckMiniMap viewport indicator error: $e');
      return const SizedBox.shrink();
    }
  }
}
