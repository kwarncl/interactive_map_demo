import 'package:flutter/material.dart';

import '../models/cruise_product.dart';

/// Search bar widget for filtering cruises
class CruiseSearchBar extends StatefulWidget {
  const CruiseSearchBar({
    super.key,
    required this.cruises,
    required this.onCruiseSelected,
    required this.onFilterChanged,
    this.focusNode,
    this.controller,
  });

  final List<CruiseProduct> cruises;
  final ValueChanged<CruiseProduct> onCruiseSelected;
  final ValueChanged<String> onFilterChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<CruiseSearchBar> createState() => _CruiseSearchBarState();
}

class _CruiseSearchBarState extends State<CruiseSearchBar> {
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

  void _onSearchChanged(String query) {
    setState(() {}); // Trigger rebuild to show/hide clear button
    widget.onFilterChanged(query);
  }

  void _clearSearch() {
    _controller.clear();
    _onSearchChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        autofocus: false, // Disabled to allow manual focus control
        decoration: InputDecoration(
          hintText: 'Search cruises, destinations, ships...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.clear),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
