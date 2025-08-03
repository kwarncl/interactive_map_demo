import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A clickable legend widget that displays a deck key dialog when tapped.
/// Shows all the symbols used on deck plans with their meanings.
class DeckKeyLegend extends StatelessWidget {
  const DeckKeyLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeckKeyDialog(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline, size: 20, color: Colors.blue),
            SizedBox(width: 6),
            Text(
              'Deck Key',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeckKeyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
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
            32; // Extra margin for dialog spacing

        // Calculate max width accounting for safe areas
        final availableWidth =
            screenSize.width -
            padding.left -
            padding.right -
            32; // Side margins

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: math.min(400, availableWidth),
              maxHeight: math.min(600, availableHeight),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Deck Key:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Key items
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildKeyItem('*', 'Two non-combinable beds'),
                        _buildKeyItem('■', 'Wheelchair Accessible'),
                        _buildKeyItem('▲', 'Holds 3'),
                        _buildKeyItem('●', 'Hearing Impaired'),
                        _buildKeyItem('+', 'Holds 4'),
                        _buildKeyItem('↔', 'Connecting'),
                        _buildKeyItem('★', 'Holds 5'),
                        _buildKeyItem('△', 'King Bed'),
                        _buildKeyItem('☆', 'Holds 6'),
                        _buildKeyItem('∞', 'Holds 8'),
                        _buildKeyItem('□', 'PrivaSea'),
                        _buildKeyItem('👥', 'Restroom'),
                        _buildKeyItem('✕', 'Elevator'),
                        _buildKeyItem('✓', 'Double Bed'),
                        _buildKeyItem('○', 'Inside Corridors'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyItem(String symbol, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              symbol,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
