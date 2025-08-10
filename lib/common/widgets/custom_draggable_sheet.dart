import 'package:flutter/material.dart';

class CustomDraggableSheet extends StatelessWidget {
  const CustomDraggableSheet({
    super.key,
    required this.slivers,
    this.initialChildSize = 0.3,
    this.minChildSize = 0.3,
    this.maxChildSize = 1.0,
  });

  final List<Widget> slivers;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        snap: true,
        snapSizes: [initialChildSize, maxChildSize],
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content using CustomScrollView
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: slivers,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
