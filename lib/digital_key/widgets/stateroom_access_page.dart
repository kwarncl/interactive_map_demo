import 'package:flutter/material.dart';
import 'package:interactive_map_demo/digital_key/models/stateroom_access_data.dart';

class StateroomAccessPage extends StatefulWidget {
  const StateroomAccessPage({super.key});

  @override
  State<StateroomAccessPage> createState() => _StateroomAccessPageState();
}

class _StateroomAccessPageState extends State<StateroomAccessPage>
    with TickerProviderStateMixin {
  late AnimationController _authController;
  late Animation<double> _authAnimation;

  late StateroomAccess _stateroomAccess;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();

    _authController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _authAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _authController, curve: Curves.easeInOut),
    );

    _stateroomAccess = StateroomAccessData.getCurrentStateroomAccess();

    // Automatically start unlocking process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAccessRequest();
    });
  }

  @override
  void dispose() {
    // Stop animation before disposing if it's still running
    if (_authController.isAnimating) {
      _authController.stop();
    }
    _authController.dispose();
    super.dispose();
  }

  void _handleAccessRequest() async {
    // Check if widget is still mounted before starting
    if (!mounted) return;

    // Start authentication animation
    setState(() {
      _isAuthenticating = true;
    });

    // Start the authentication animation
    _authController.repeat();

    // Simulate authentication delay (2-3 seconds)
    await Future.delayed(const Duration(milliseconds: 2500));

    // Check if widget is still mounted before stopping animation
    if (!mounted) return;

    // Stop the animation safely
    if (_authController.isAnimating) {
      _authController.stop();
    }

    // Update access status
    setState(() {
      _isAuthenticating = false;
      _stateroomAccess = StateroomAccess(
        stateroomNumber: _stateroomAccess.stateroomNumber,
        deckNumber: _stateroomAccess.deckNumber,
        guest: _stateroomAccess.guest,
        accessStatus: AccessStatus.accessGranted,
        lastAccessTime: DateTime.now(),
        accessMethod: _stateroomAccess.accessMethod,
        location: _stateroomAccess.location,
        notes: _stateroomAccess.notes,
      );
    });

    // Close modal after success
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
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
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
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
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.key_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title and subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Digital Key Access',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_stateroomAccess.guest.name} • Stateroom ${_stateroomAccess.stateroomNumber} • Deck ${_stateroomAccess.deckNumber}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Close button
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: colorScheme.onSurfaceVariant,
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
              // Main content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Modern lock interface
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  (_isAuthenticating
                                          ? Colors.orange
                                          : _stateroomAccess.accessStatus ==
                                              AccessStatus.locked
                                          ? Colors.red
                                          : Colors.green)
                                      .withValues(alpha: 0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Main circular interface
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors:
                                    _isAuthenticating
                                        ? [
                                          const Color(0xFFFF9500),
                                          const Color(0xFFFF6B00),
                                          const Color(0xFFE55100),
                                        ]
                                        : _stateroomAccess.accessStatus ==
                                            AccessStatus.locked
                                        ? [
                                          const Color(0xFFEF5350),
                                          const Color(0xFFE53935),
                                          const Color(0xFFD32F2F),
                                        ]
                                        : [
                                          const Color(0xFF66BB6A),
                                          const Color(0xFF4CAF50),
                                          const Color(0xFF388E3C),
                                        ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_isAuthenticating
                                          ? Colors.orange
                                          : _stateroomAccess.accessStatus ==
                                              AccessStatus.locked
                                          ? Colors.red
                                          : Colors.green)
                                      .withValues(alpha: 0.4),
                                  blurRadius: _isAuthenticating ? 40 : 30,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Enhanced pulsing rings for authentication effect
                                if (_isAuthenticating) ...[
                                  AnimatedBuilder(
                                    animation: _authController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale:
                                            1.0 + (_authAnimation.value * 0.3),
                                        child: Container(
                                          width: 280,
                                          height: 280,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha:
                                                    0.6 -
                                                    (_authAnimation.value *
                                                        0.4),
                                              ),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  AnimatedBuilder(
                                    animation: _authController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale:
                                            1.0 + (_authAnimation.value * 0.5),
                                        child: Container(
                                          width: 280,
                                          height: 280,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha:
                                                    0.4 -
                                                    (_authAnimation.value *
                                                        0.3),
                                              ),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                // Enhanced main content with modern styling
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Enhanced lock icon with glow effect
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        _isAuthenticating
                                            ? Icons.lock_outline_rounded
                                            : _stateroomAccess.accessStatus ==
                                                AccessStatus.locked
                                            ? Icons.lock_outline_rounded
                                            : Icons.lock_open_rounded,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    // Enhanced status text with better typography
                                    Text(
                                      _isAuthenticating
                                          ? 'Authenticating...'
                                          : _stateroomAccess.accessStatus ==
                                              AccessStatus.locked
                                          ? 'Stateroom Locked'
                                          : 'Access Granted',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    // Modern status indicator with better design
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _isAuthenticating
                                              ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              )
                                              : Icon(
                                                _stateroomAccess.accessStatus ==
                                                        AccessStatus.locked
                                                    ? Icons.autorenew_rounded
                                                    : Icons
                                                        .check_circle_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                          const SizedBox(width: 10),
                                          Text(
                                            _isAuthenticating
                                                ? 'Processing'
                                                : _stateroomAccess
                                                        .accessStatus ==
                                                    AccessStatus.locked
                                                ? 'Initializing'
                                                : 'Complete',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Cancel button at the bottom
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: SizedBox(
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
                      'Cancel',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
