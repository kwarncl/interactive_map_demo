import 'dart:async';

import 'package:flutter/material.dart';

class SimpleCountdownWidget extends StatefulWidget {
  const SimpleCountdownWidget({
    required this.departureDate,
    this.showSeconds = false,
    this.compact = false,
    super.key,
  });

  final DateTime departureDate;
  final bool showSeconds;
  final bool compact;

  @override
  State<SimpleCountdownWidget> createState() => _SimpleCountdownWidgetState();
}

class _SimpleCountdownWidgetState extends State<SimpleCountdownWidget> {
  late Timer _timer;
  late DateTime _now;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timeRemaining = widget.departureDate.difference(_now);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
        _timeRemaining = widget.departureDate.difference(_now);

        if (_timeRemaining.isNegative) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool get _isCountdownComplete => _timeRemaining.isNegative;

  @override
  Widget build(BuildContext context) {
    if (_isCountdownComplete) {
      return _buildCompleteState();
    }

    if (widget.compact) {
      return _buildCompactDisplay();
    }

    return _buildFullDisplay();
  }

  Widget _buildCompactDisplay() {
    final int days = _timeRemaining.inDays;
    final int hours = _timeRemaining.inHours % 24;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '$days days, $hours hours',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullDisplay() {
    final int days = _timeRemaining.inDays;
    final int hours = _timeRemaining.inHours % 24;
    final int minutes = _timeRemaining.inMinutes % 60;
    final int seconds = widget.showSeconds ? _timeRemaining.inSeconds % 60 : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Departure in',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit('Days', days.toString()),
              _buildTimeUnit('Hours', hours.toString().padLeft(2, '0')),
              _buildTimeUnit('Min', minutes.toString().padLeft(2, '0')),
              if (widget.showSeconds)
                _buildTimeUnit('Sec', seconds.toString().padLeft(2, '0')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String label, String value) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Text(
            'Bon Voyage!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
