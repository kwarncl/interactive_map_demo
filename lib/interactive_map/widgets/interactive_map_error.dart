import 'package:flutter/material.dart';

class InteractiveMapError extends StatelessWidget {
  const InteractiveMapError({super.key});

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.grey[200],
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Failed to load map image',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
