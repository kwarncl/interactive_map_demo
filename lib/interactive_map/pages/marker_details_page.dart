import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/interactive_map_marker_data.dart';

/// Page that displays the details of a marker
class MarkerDetailsPage extends StatelessWidget {
  /// Constructor
  const MarkerDetailsPage({required this.markerData, super.key});

  /// The marker data
  final InteractiveMapMarkerData markerData;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(markerData.title)),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image placeholder
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: markerData.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(markerData.icon, size: 80, color: markerData.color),
          ),

          const SizedBox(height: 24),

          // Title and badge
          Row(
            children: [
              Expanded(
                child: Text(
                  markerData.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: markerData.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Featured',
                  style: TextStyle(
                    color: markerData.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            markerData.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 32),

          // Quick Info Section
          Text(
            'Quick Info',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            context,
            Icons.access_time,
            'Operating Hours',
            'Daily: 9:00 AM - 8:00 PM\nClosed during rough weather',
            markerData.color,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            context,
            Icons.people,
            'Capacity & Age Requirements',
            'Suitable for all ages\nMaximum group size: 12 people\nHeight requirement: None',
            markerData.color,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            context,
            Icons.star,
            'Guest Reviews',
            '4.8/5 stars (127 reviews)\n"Amazing experience!" - Guest Review\n"Must visit location!" - Guest Review',
            markerData.color,
          ),

          const SizedBox(height: 32),

          // Features Section
          Text(
            "What's Included",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ...(_getFeaturesList(markerData.id).map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: markerData.color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )),

          const SizedBox(height: 32),

          // Important Notes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Important Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getImportantNotes(markerData.id),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to favorites!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Save'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: markerData.color,
                    side: BorderSide(color: markerData.color),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking ${markerData.title}...'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Book Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: markerData.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'This is a demo app. All information provided is for demonstration purposes only and may not reflect actual cruise amenities or services.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    ),
  );

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String content,
    Color color,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  List<String> _getFeaturesList(String markerId) {
    switch (markerId) {
      case 'pier':
        return [
          'Modern boarding facilities',
          'Baggage assistance available',
          'Accessibility features',
          'Information desk',
          'Shuttle service to parking',
        ];
      case 'arrivals_area':
        return [
          'Comfortable waiting areas',
          'Refreshment stands',
          'Ground transportation',
          'Taxi and rideshare pickup',
          'Lost & found services',
        ];
      case 'silver_cove':
        return [
          'Crystal clear swimming water',
          'Beach chairs and umbrellas',
          'Snorkeling equipment rental',
          'Beach volleyball court',
          'Lifeguard on duty',
        ];
      case 'vibe_beach_club':
        return [
          'Premium beach club access',
          'Exclusive dining options',
          'DJ entertainment',
          'Cocktail service',
          'VIP cabana rentals',
        ];
      case 'pool_zone':
        return [
          'Multiple swimming pools',
          'Kids splash area',
          'Pool bar service',
          'Lounge chairs',
          'Towel service',
        ];
      case 'flighthouse_zipline':
        return [
          'Breathtaking aerial views',
          'Professional safety equipment',
          'Experienced guides',
          'Photo opportunities',
          'Certificate of completion',
        ];
      case 'cabanas_on_the_cay':
        return [
          'Private beachfront cabana',
          'Personalized service',
          'Gourmet dining options',
          'Premium beach amenities',
          'Exclusive beach access',
        ];
      case 'horizon_park':
        return [
          'Multiple activity zones',
          'Rock climbing wall',
          'Adventure courses',
          'Scenic walking trails',
          'Photography spots',
        ];
      case 'splash_pad':
        return [
          'Safe water play area',
          'Age-appropriate activities',
          'Supervised play time',
          'Parent seating areas',
          'Changing facilities',
        ];
      default:
        return [
          'Exciting experience',
          'Professional staff',
          'Safety equipment provided',
          'Great photo opportunities',
          'Memorable adventure',
        ];
    }
  }

  String _getImportantNotes(String markerId) {
    switch (markerId) {
      case 'pier':
        return '''Please arrive at least 2 hours before departure. Valid identification required for boarding.''';
      case 'arrivals_area':
        return '''Transportation arrangements should be made in advance. Check-out time is 8:00 AM.''';
      case 'silver_cove':
        return '''Swimming at your own risk. Children must be supervised at all times. No glass containers allowed.''';
      case 'vibe_beach_club':
        return '''Advance reservations recommended. Dress code enforced. Age restrictions may apply for certain areas.''';
      case 'pool_zone':
        return '''Pool hours may vary by weather conditions. Children must be accompanied by adults. No diving allowed.''';
      case 'flighthouse_zipline':
        return '''Weight restrictions apply (80-250 lbs). Not suitable for pregnant guests or those with heart conditions.''';
      case 'cabanas_on_the_cay':
        return '''Advance booking required. Cancellation policy applies. Weather dependent availability.''';
      case 'horizon_park':
        return '''Closed fist policy enforced. Appropriate footwear required. Activities subject to weather conditions.''';
      case 'splash_pad':
        return '''Children must be supervised at all times. Non-slip footwear recommended. Age restrictions apply.''';
      default:
        return '''Please follow all safety guidelines and staff instructions during your visit.''';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<InteractiveMapMarkerData>('markerData', markerData),
    );
  }
}
