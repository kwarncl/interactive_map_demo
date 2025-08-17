import 'package:flutter/material.dart';

import '../models/cruise_product.dart';

/// Modern header widget for search mode
class SearchModeHeader extends StatelessWidget {
  const SearchModeHeader({
    super.key,
    required this.cruises,
    required this.onCruiseSelected,
    required this.onSearchChanged,
    required this.onSearchToggled,
    this.searchController,
    this.searchFocusNode,
  });

  final List<CruiseProduct> cruises;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggled;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        spacing: 12,
        children: [
          // Search input field
          Expanded(
            child: _SearchBar(
              cruises: cruises,
              onCruiseSelected: onCruiseSelected,
              onSearchChanged: onSearchChanged,
              controller: searchController,
              focusNode: searchFocusNode,
            ),
          ),

          // Close search button
          Container(
            // height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: onSearchToggled,
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              // style: IconButton.styleFrom(
              //   padding: const EdgeInsets.all(12),
              //   minimumSize: const Size(48, 48),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline search bar widget
class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.cruises,
    required this.onCruiseSelected,
    required this.onSearchChanged,
    this.focusNode,
    this.controller,
  });

  final List<CruiseProduct> cruises;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final ValueChanged<String> onSearchChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _shouldDisposeController = false;
  bool _shouldDisposeFocusNode = false;

  @override
  void initState() {
    super.initState();

    // Use external controller if provided, otherwise create our own
    if (widget.controller != null) {
      _controller = widget.controller!;
      _shouldDisposeController = false;
    } else {
      _controller = TextEditingController();
      _shouldDisposeController = true;
    }

    // Use external focus node if provided, otherwise create our own
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _shouldDisposeFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _shouldDisposeFocusNode = true;
    }
  }

  @override
  void dispose() {
    if (_shouldDisposeController) {
      _controller.dispose();
    }
    if (_shouldDisposeFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.onSearchChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search cruises, destinations, ships...',
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        border: InputBorder.none,
        isDense: true,
        alignLabelWithHint: true,
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
