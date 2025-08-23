import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_map_demo/digital_key/widgets/stateroom_access_page.dart';

const String _digitalKeyCardHeroTag = 'digital_key_card_hero';

class DigitalKeyPage extends StatefulWidget {
  const DigitalKeyPage({super.key});

  @override
  State<DigitalKeyPage> createState() => _DigitalKeyPageState();
}

class _DigitalKeyPageState extends State<DigitalKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Key'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed:
                () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const _DigitalKeyHelpBottomSheet(),
                ),
          ),
        ],
      ),
      persistentFooterButtons: [
        _UnlockDoorButton(
          onPressed:
              () => showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) => const StateroomAccessPage(),
              ),
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: GestureDetector(
                onTap:
                    () => Navigator.of(context).push(
                      PageRouteBuilder<void>(
                        opaque: false,
                        barrierColor: Colors.black,
                        transitionDuration: const Duration(milliseconds: 300),
                        reverseTransitionDuration: const Duration(
                          milliseconds: 200,
                        ),
                        pageBuilder:
                            (_, __, ___) => const _CardFullscreenPage(),
                        transitionsBuilder: (_, animation, secondary, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    ),
                child: Hero(
                  tag: _digitalKeyCardHeroTag,
                  createRectTween:
                      (begin, end) =>
                          MaterialRectCenterArcTween(begin: begin, end: end),
                  flightShuttleBuilder: (
                    context,
                    animation,
                    direction,
                    from,
                    to,
                  ) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final double t = animation.value;

                        if (direction == HeroFlightDirection.push) {
                          // Forward animation: 0° to 90° rotation
                          final double angle = t * (math.pi / 2);
                          return Center(
                            child: Transform.rotate(
                              angle: angle,
                              child: const _RefinedBoardingPassCard(
                                isHighlighted: true,
                              ),
                            ),
                          );
                        } else {
                          // Reverse animation: 90° to 0° rotation
                          // t goes from 0 to 1, we want angle to go from 90° to 0°
                          final double angle = (math.pi / 2) * (1.0 - t);
                          return Center(
                            child: Transform.rotate(
                              angle: angle,
                              child:
                                  t < 0.5
                                      ? const _RefinedBoardingPassCard(
                                        isHighlighted: true,
                                      )
                                      : const _RefinedBoardingPassCard(
                                        isHighlighted: false,
                                      ),
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: const _RefinedBoardingPassCard(),
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: _KeyCardNote()),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverToBoxAdapter(child: _DigitalKeyFeaturesSection()),
          ),
        ],
      ),
    );
  }
}

class _CardFullscreenPage extends StatelessWidget {
  const _CardFullscreenPage();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black,
          child: Center(
            child: Hero(
              tag: _digitalKeyCardHeroTag,
              createRectTween:
                  (begin, end) =>
                      MaterialRectCenterArcTween(begin: begin, end: end),
              flightShuttleBuilder: (context, animation, direction, from, to) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final double t = animation.value;

                    if (direction == HeroFlightDirection.push) {
                      // Forward animation: 0° to 90° rotation
                      final double angle = t * (math.pi / 2);
                      return Center(
                        child: Transform.rotate(
                          angle: angle,
                          child: const _RefinedBoardingPassCard(
                            isHighlighted: true,
                          ),
                        ),
                      );
                    } else {
                      // Reverse animation: 90° to 0° rotation
                      // t goes from 0 to 1, we want angle to go from 90° to 0°
                      final double angle = (math.pi / 2) * (1.0 - t);
                      return Center(
                        child: Transform.rotate(
                          angle: angle,
                          child:
                              t < 0.5
                                  ? const _RefinedBoardingPassCard(
                                    isHighlighted: true,
                                  )
                                  : const _RefinedBoardingPassCard(
                                    isHighlighted: false,
                                  ),
                        ),
                      );
                    }
                  },
                );
              },
              child: const _FullscreenHeroChild(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenHeroChild extends StatelessWidget {
  const _FullscreenHeroChild();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: math.pi / 2,
        child: const _RefinedBoardingPassCard(isHighlighted: true),
      ),
    );
  }
}

class _UnlockDoorButton extends StatelessWidget {
  const _UnlockDoorButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(
          Icons.lock_open_rounded,
          color: Colors.white,
          size: 26,
        ),
        label: Text(
          'Unlock Stateroom',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _RefinedBoardingPassCard extends StatelessWidget {
  const _RefinedBoardingPassCard({this.isHighlighted = false});

  final bool isHighlighted;

  // Credit card dimensions - single source of truth
  static const double _creditCardAspectRatio = 1.585; // width / height

  // Regular card size
  static const double _regularCardWidth = 340.0;
  static const double _regularCardHeight =
      _regularCardWidth / _creditCardAspectRatio;

  // Highlighted card size (larger)
  static const double _highlightedCardWidth = 520.0;
  static const double _highlightedCardHeight =
      _highlightedCardWidth / _creditCardAspectRatio;

  @override
  Widget build(BuildContext context) {
    final double width =
        isHighlighted ? _highlightedCardWidth : _regularCardWidth;
    final double height =
        isHighlighted ? _highlightedCardHeight : _regularCardHeight;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // TODO: use theme
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Main content area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Header
                            Text(
                              'WELCOME BACK TO NORWEGIAN',
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            // Guest info
                            Text(
                              'John Smith',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                            Text(
                              'Norwegian Encore',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            // Room number (large)
                            Text(
                              '8501',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Tags
                            Wrap(
                              spacing: 4,
                              runSpacing: 2,
                              children: [
                                _ModernChip(label: 'DECK 8', isLight: true),
                                _ModernChip(label: 'MUSTER A', isLight: true),
                                _ModernChip(
                                  label: 'MOBILE ACCESS',
                                  isLight: true,
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Bottom info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Dec 15 - Dec 22, 2024',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'BirdTravels • G001',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'ROOM KEY • CHARGE CARD',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Vertical barcode on the right
                      const SizedBox(width: 12),
                      Container(
                        width: 32,
                        height: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: CustomPaint(
                            painter: _ModernBarcodePainter(),
                            size: const Size(double.infinity, 32),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyCardNote extends StatelessWidget {
  const _KeyCardNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your digital key works the same as your physical key card. Keep your phone charged!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DigitalKeyFeaturesSection extends StatelessWidget {
  const _DigitalKeyFeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _CompactFeature(
                icon: Icons.door_front_door,
                label: 'Stateroom Access',
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              _CompactFeature(
                icon: Icons.contactless,
                label: 'Contactless Payment',
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 16),
              _CompactFeature(
                icon: Icons.security,
                label: 'Secure',
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactFeature extends StatelessWidget {
  const _CompactFeature({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DigitalKeyHelpBottomSheet extends StatelessWidget {
  const _DigitalKeyHelpBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modern modal header with drag handle
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header with title and close button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Digital key icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.key_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title
                      Expanded(
                        child: Text(
                          'How Digital Key Works',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      // Close button
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HelpSection(
                    icon: Icons.phone_android,
                    title: 'Setup & Access',
                    content:
                        'Your phone becomes your room key! No need to carry a physical card around the ship.',
                  ),
                  const SizedBox(height: 16),
                  _HelpSection(
                    icon: Icons.nfc,
                    title: 'How to Use',
                    content:
                        'Simply hold your phone near the door reader, just like you would with a physical key card.',
                  ),
                  const SizedBox(height: 16),
                  _HelpSection(
                    icon: Icons.battery_charging_full,
                    title: 'Keep Charged',
                    content:
                        'Make sure your phone stays charged. Your physical key card will still work as backup.',
                  ),
                  const SizedBox(height: 16),
                  _HelpSection(
                    icon: Icons.security,
                    title: 'Security',
                    content:
                        'Digital keys use encrypted technology and are just as secure as physical cards.',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tip: You can also tap your card above to see it in full screen mode!',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernChip extends StatelessWidget {
  const _ModernChip({required this.label, required this.isLight});

  final String label;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            isLight
                ? Colors.white.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isLight
                  ? Colors.white.withValues(alpha: 0.3)
                  : Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color:
              isLight
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: 8,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class _ModernBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    // Create a more modern, cleaner barcode
    final List<double> bars = [
      1.5,
      1,
      2,
      1,
      1.5,
      1,
      2.5,
      1,
      1,
      2,
      1.5,
      1,
      2,
      1,
      1.5,
    ];

    double x = 4;
    bool isDark = true;

    for (double barWidth in bars) {
      if (isDark && x < size.width - 4) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            x,
            4,
            x + barWidth,
            size.height - 4,
            const Radius.circular(0.5),
          ),
          paint,
        );
      }
      x += barWidth + 0.5;
      isDark = !isDark;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
