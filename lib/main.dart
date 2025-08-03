import 'package:flutter/material.dart';
import 'package:interactive_map_demo/deck_plan/deck_8_svg_polygon_provider.dart';
import 'package:interactive_map_demo/deck_plan/models/deck_polygon_data.dart';
import 'package:interactive_map_demo/deck_plan/models/ship_deck_data.dart';
import 'package:interactive_map_demo/itinerary/data/caribbean_cruise.dart';
import 'package:interactive_map_demo/itinerary/data/transatlantic_cruise.dart';

import 'deck_plan/multi_deck_ship_map.dart';
import 'interactive_map/interactive_map.dart';
import 'itinerary/cruise_itinerary_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Map Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MapSelectionScreen(),
    );
  }
}

class MapSelectionScreen extends StatelessWidget {
  const MapSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Maps'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Choose a Map to Explore',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _MapCard(
              title: 'Great Stirrup Cay',
              subtitle: 'Norwegian\'s Private Island Paradise',
              icon: Icons.beach_access,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const InteractiveMap(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _MapCard(
              title: 'Norwegian Aqua - Deck Plans',
              subtitle: 'Complete Ship Deck Plans (Decks 5-20)',
              icon: Icons.directions_boat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => MultiDeckShipMap(
                          shipClass: NorwegianAquaPolygonProvider.shipClass,
                          decks: NorwegianAquaDecks.allDecks,
                          initialDeckIndex: 3,
                          polygonDataProvider: NorwegianAquaPolygonProvider(),
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _MapCard(
              title: 'Deck 8 Interactive Plan',
              subtitle: 'SVG-based interactive deck plan with clickable areas',
              icon: Icons.map,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => MultiDeckShipMap(
                          shipClass: Deck8SvgPolygonProvider.shipClass,
                          decks: [
                            ShipDeckInfo(
                              deckNumber: 8,
                              name: 'Deck 8 - Ocean Boulevard (SVG)',
                              description:
                                  'Interactive SVG-based deck plan with 360° promenade featuring pools, dining, Ocean Walk, and outdoor spaces',
                              imageUrl: 'assets/images/deck-8.svg',
                              primaryColor: Colors.cyan.shade400,
                              markers:
                                  [], // Using polygon areas instead of markers for this implementation
                            ),
                          ],
                          initialDeckIndex: 0,
                          polygonDataProvider: Deck8SvgPolygonProvider(),
                        ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            _MapCard(
              title: 'Norwegian Aqua - Caribbean Cruise',
              subtitle: '7-Day Caribbean Journey',
              icon: Icons.route,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => CruiseItineraryPage(
                          itinerary: CaribbeanCruiseData.norwegianAquaCaribbean,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _MapCard(
              title: 'Norwegian Pearl - Transatlantic',
              subtitle: '15-Night Mediterranean from Miami to Barcelona',
              icon: Icons.sailing,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (context) => CruiseItineraryPage(
                          itinerary:
                              TransatlanticCruiseData
                                  .norwegianPearlMediterranean,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
