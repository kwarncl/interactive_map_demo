import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:interactive_map_demo/common/map_config.dart';
import 'package:interactive_map_demo/common/map_utilities.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

/// Handles tile rendering for the itinerary map, including loading vector
/// styles and falling back to raster on error.
class ItineraryMapTileLayers extends StatefulWidget {
  const ItineraryMapTileLayers({
    super.key,
    required this.mapConfig,
    this.showLoadingOverlay = true,
    this.showErrorBanner = true,
  });

  final MapConfig mapConfig;
  final bool showLoadingOverlay;
  final bool showErrorBanner;

  @override
  State<ItineraryMapTileLayers> createState() => _ItineraryMapTileLayersState();
}

class _ItineraryMapTileLayersState extends State<ItineraryMapTileLayers> {
  Future<Style>? _styleFuture;
  Style? _localVectorStyle;
  Object? _localVectorError;

  @override
  void initState() {
    super.initState();
    _prepareFuture();
  }

  @override
  void didUpdateWidget(covariant ItineraryMapTileLayers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mapConfig.tilesConfig != widget.mapConfig.tilesConfig) {
      _prepareFuture();
    }
  }

  void _prepareFuture() {
    final TilesConfig tilesConfig = widget.mapConfig.tilesConfig;
    switch (tilesConfig) {
      case NetworkVectorTilesConfig network:
        setState(() {
          _localVectorStyle = null;
          _localVectorError = null;
          _styleFuture =
              StyleReader(uri: network.styleUri, apiKey: network.apiKey).read();
        });
        return;
      case LocalVectorTilesConfig local:
        final TileProviders? providers = local.providersOverride;
        if (providers == null) {
          throw ArgumentError(
            'Local style requires providersOverride to be set',
          );
        }
        setState(() {
          _styleFuture = null;
          _localVectorStyle = null;
          _localVectorError = null;
        });
        MapUtilities.readVectorStyleFromAssets(
              styleAssetPath: local.styleAssetPath,
              providers: providers,
            )
            .then((Style style) {
              if (!mounted) return;
              setState(() {
                _localVectorStyle = style;
              });
            })
            .catchError((Object error) {
              if (!mounted) return;
              setState(() {
                _localVectorError = error;
              });
            });
        return;
      default:
        setState(() {
          _styleFuture = null;
          _localVectorStyle = null;
          _localVectorError = null;
        });
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Raster configuration
    if (widget.mapConfig.tilesConfig is RasterTilesConfig) {
      final RasterTilesConfig raster =
          widget.mapConfig.tilesConfig as RasterTilesConfig;
      return TileLayer(
        urlTemplate: raster.urlTemplate,
        subdomains: raster.subdomains,
        additionalOptions: raster.additionalOptions,
        userAgentPackageName: widget.mapConfig.userAgentPackageName,
      );
    }

    // Vector configured
    final TilesConfig tilesConfig = widget.mapConfig.tilesConfig;
    switch (tilesConfig) {
      case LocalVectorTilesConfig _:
        if (_localVectorStyle != null) {
          final Style style = _localVectorStyle!;
          return VectorTileLayer(
            layerMode: VectorTileLayerMode.raster,
            theme: style.theme,
            sprites: style.sprites,
            tileProviders: tilesConfig.providersOverride ?? style.providers,
          );
        }

        if (_localVectorError != null) {
          if (widget.showErrorBanner) {
            return SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Vector style failed; using raster tiles',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        }

        if (widget.showLoadingOverlay) {
          return const Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return const SizedBox.shrink();

      case NetworkVectorTilesConfig _:
        return FutureBuilder<Style>(
          future: _styleFuture,
          builder: (BuildContext context, AsyncSnapshot<Style> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (widget.showLoadingOverlay) {
                  return const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return const SizedBox.shrink();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  if (widget.showErrorBanner) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Vector style failed; using raster tiles',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final Style style = snapshot.data!;
                return VectorTileLayer(
                  layerMode: VectorTileLayerMode.raster,
                  theme: style.theme,
                  sprites: style.sprites,
                  tileProviders:
                      tilesConfig.providersOverride ?? style.providers,
                );
              case ConnectionState.none:
                return const SizedBox.shrink();
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
