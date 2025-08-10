import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:interactive_map_demo/common/map_config.dart';
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

  @override
  void initState() {
    super.initState();
    _prepareFuture();
  }

  @override
  void didUpdateWidget(covariant ItineraryMapTileLayers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mapConfig.vectorTiles != widget.mapConfig.vectorTiles) {
      _prepareFuture();
    }
  }

  void _prepareFuture() {
    final VectorTilesConfig? cfg = widget.mapConfig.vectorTiles;
    if (cfg == null) {
      setState(() => _styleFuture = null);
      return;
    }
    setState(() {
      _styleFuture = StyleReader(uri: cfg.styleUri, apiKey: cfg.apiKey).read();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Raster-only configuration
    if (widget.mapConfig.vectorTiles == null) {
      return TileLayer(
        urlTemplate: widget.mapConfig.rasterTiles.urlTemplate,
        subdomains: widget.mapConfig.rasterTiles.subdomains,
        userAgentPackageName: widget.mapConfig.userAgentPackageName,
      );
    }

    // Vector configured → use FutureBuilder to handle loading/error/data
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
                return Stack(
                  children: [
                    TileLayer(
                      urlTemplate: widget.mapConfig.rasterTiles.urlTemplate,
                      subdomains: widget.mapConfig.rasterTiles.subdomains,
                      userAgentPackageName:
                          widget.mapConfig.userAgentPackageName,
                    ),
                    Align(
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
                  ],
                );
              }
              return TileLayer(
                urlTemplate: widget.mapConfig.rasterTiles.urlTemplate,
                subdomains: widget.mapConfig.rasterTiles.subdomains,
                userAgentPackageName: widget.mapConfig.userAgentPackageName,
              );
            }

            final Style style = snapshot.data!;
            return VectorTileLayer(
              theme: style.theme,
              sprites: style.sprites,
              tileProviders:
                  widget.mapConfig.vectorTiles?.providersOverride ??
                  style.providers,
            );
          case ConnectionState.none:
            // Shouldn't happen, but return raster for safety
            return TileLayer(
              urlTemplate: widget.mapConfig.rasterTiles.urlTemplate,
              subdomains: widget.mapConfig.rasterTiles.subdomains,
              userAgentPackageName: widget.mapConfig.userAgentPackageName,
            );
        }
      },
    );
  }
}
