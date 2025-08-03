import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/interactive_map_marker_data.dart';

/// A widget that displays a detailed view of a marker on the interactive map.
class InteractiveMapMarketDetail extends StatelessWidget {
  /// Constructor
  const InteractiveMapMarketDetail({
    required this.title,
    required this.description,
    this.onActionPressed,
    this.actionButtonText = 'Get Directions',
    this.icon = Icons.location_on,
    this.color,
    this.markerData,
    super.key,
  });

  /// Factory constructor to create dialog from marker data
  factory InteractiveMapMarketDetail.fromMarkerData({
    required InteractiveMapMarkerData markerData,
    VoidCallback? onActionPressed,
    String actionButtonText = 'Get Directions',
    Key? key,
  }) => InteractiveMapMarketDetail(
    title: markerData.title,
    description: markerData.description,
    onActionPressed: onActionPressed,
    actionButtonText: actionButtonText,
    icon: markerData.icon,
    color: markerData.color,
    markerData: markerData,
    key: key,
  );

  /// Title of the marker
  final String title;

  /// Description of the marker
  final String description;

  /// Callback for the action button
  final VoidCallback? onActionPressed;

  /// Text for the action button
  final String actionButtonText;

  /// Icon for the marker
  final IconData icon;

  /// Color for the marker
  final Color? color;

  /// Marker data
  final InteractiveMapMarkerData? markerData;

  Color _getMarkerColor(BuildContext context) =>
      markerData?.color ?? Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: GestureDetector(
      onTap: onActionPressed,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section with colored background
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getMarkerColor(context).withValues(alpha: 0.1),
                      _getMarkerColor(context).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getMarkerColor(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getMarkerColor(
                              context,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getMarkerColor(
                                context,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Featured Location',
                              style: TextStyle(
                                color: _getMarkerColor(context),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Description with enhanced styling
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 8),

              // Quick info badges
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _InfoBadge(
                    icon: Icons.access_time,
                    text: '9AM-8PM',
                    color: _getMarkerColor(context),
                  ),
                  const _InfoBadge(
                    icon: Icons.star,
                    text: '4.8★',
                    color: Colors.amber,
                  ),
                  const _InfoBadge(
                    icon: Icons.people,
                    text: 'All Ages',
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(
        ObjectFlagProperty<VoidCallback?>.has(
          'onActionPressed',
          onActionPressed,
        ),
      )
      ..add(StringProperty('actionButtonText', actionButtonText))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(ColorProperty('color', color))
      ..add(
        DiagnosticsProperty<InteractiveMapMarkerData?>(
          'markerData',
          markerData,
        ),
      );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  /// Icon for the badge
  final IconData icon;

  /// Text for the badge
  final String text;

  /// Color for the badge
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('text', text))
      ..add(ColorProperty('color', color));
  }
}
