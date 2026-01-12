import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A high-end, animated Toast Widget that mimics a "Cyberpunk/Tech" notification.
///
/// Features:
/// 1. Staggered Entrance (Width snap -> Icon Spin -> Text Slide).
/// 2. Holographic Shimmer Effect (Light beam sweeping across).
/// 3. Idle Hover Animation (Floating effect).
/// 4. Dynamic Progress Bar.
class LuxeToastWidget extends StatefulWidget {
  /// The main message body of the toast.
  final String message;

  /// The bold title displayed at the top.
  final String title;

  /// The theme color (Neon Green, Red, Blue, etc.) used for borders and glow.
  final Color baseColor;

  /// The icon displayed on the left.
  final IconData icon;

  /// How long the toast stays visible (controls the progress bar speed).
  final Duration duration;

  const LuxeToastWidget({
    Key? key,
    required this.message,
    required this.title,
    required this.baseColor,
    required this.icon,
    required this.duration,
  }) : super(key: key);

  @override
  State<LuxeToastWidget> createState() => _LuxeToastWidgetState();
}

class _LuxeToastWidgetState extends State<LuxeToastWidget>
    with TickerProviderStateMixin {
  // --- Controllers ---

  /// Controls the one-time entrance animation (Opening the box, sliding text).
  late AnimationController _mainController;

  /// Controls the infinite "floating" up and down movement.
  late AnimationController _hoverController;

  /// Controls the infinite "light beam" reflection effect.
  late AnimationController _shimmerController;

  // --- Staggered Animations (Driven by _mainController) ---

  /// Expands the container width from a small square to a full rectangle.
  late Animation<double> _widthAnimation;

  /// Pops the icon into existence.
  late Animation<double> _iconScaleAnimation;

  /// Spins the icon 360 degrees.
  late Animation<double> _iconRotateAnimation;

  /// Slides the text in from the right.
  late Animation<Offset> _textSlideAnimation;

  /// Fades the text in.
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // 1. SETUP MAIN ENTRANCE (1.2 seconds total duration)
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // A: Width Expansion (Happens first: 0% to 50% of timeline)
    // ElasticOut gives it a "Snap" open effect.
    _widthAnimation = Tween<double>(begin: 60.0, end: 350.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // B: Icon Spin & Scale (Happens mid-way: 20% to 60% of timeline)
    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Rotates 2 * PI (which equals 360 degrees)
    _iconRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // C: Text Slide (Happens last: 40% to 80% of timeline)
    // Slides from Right (Offset 0.2) to Center (Offset 0)
    _textSlideAnimation = Tween<Offset>(
        begin: const Offset(0.2, 0.0),
        end: Offset.zero
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    // 2. SETUP IDLE HOVER (Repeats forever)
    // Moves the toast gently up and down to make it look "alive".
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Goes 0 -> 1 -> 0

    // 3. SETUP SHIMMER LOOP (Repeats forever)
    // The white light reflection moving across the glass.
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Goes 0 -> 1, then restarts at 0

    // Start the entrance animation immediately
    _mainController.forward();
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _mainController.dispose();
    _hoverController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Outer Animation: The Gentle Hover
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, _) {
          return Transform.translate(
            // Moves up/down by 3 pixels using Sine wave for smoothness
            offset: Offset(0, 3 * math.sin(_hoverController.value * math.pi)),

            // Inner Animation: The Entrance (Width, scaling, etc.)
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Container(
                  // The width grows dynamically based on animation
                  width: _widthAnimation.value,
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111), // Deep Dark Background
                    borderRadius: BorderRadius.circular(12), // Tech-style corners
                    border: Border.all(
                      color: widget.baseColor.withOpacity(0.5),
                      width: 2, // Thicker border for "Card" look
                    ),
                    boxShadow: [
                      // The Neon Glow underneath
                      BoxShadow(
                        color: widget.baseColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Clips children to corners
                    child: Stack(
                      children: [
                        // --- DECORATION: Background Pattern ---
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Icon(
                            widget.icon,
                            size: 100,
                            color: Colors.white.withOpacity(0.05), // Very subtle watermark
                          ),
                        ),

                        // --- CONTENT ROW (Icon + Text) ---
                        // IMPORTANT FIX:
                        // We use SingleChildScrollView + NeverScrollableScrollPhysics.
                        // Why? During the opening animation, the container is 60px wide,
                        // but the Row content is 350px wide. This causes a "RenderFlex Overflow".
                        // This scroll view clips the overflowing content without throwing an error.
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(), // Disables user scrolling
                          child: SizedBox(
                            width: 350, // Force the Row to be full size internally
                            height: 75,
                            child: Row(
                              children: [
                                // 1. Animated Icon Box
                                SizedBox(
                                  width: 75,
                                  height: 75,
                                  child: Center(
                                    child: Transform.scale(
                                      scale: _iconScaleAnimation.value,
                                      child: Transform.rotate(
                                        angle: _iconRotateAnimation.value,
                                        child: Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: widget.baseColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: widget.baseColor,
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              )
                                            ],
                                          ),
                                          child: Icon(
                                            widget.icon,
                                            color: Colors.black, // High contrast
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // 2. Animated Text Column
                                Expanded(
                                  child: FadeTransition(
                                    opacity: _textOpacityAnimation,
                                    child: SlideTransition(
                                      position: _textSlideAnimation,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title.toUpperCase(),
                                            style: TextStyle(
                                              color: widget.baseColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            widget.message,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),

                        // --- EFFECT: Holographic Shimmer ---
                        // This creates the "Beam of light" passing over the card
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            return Positioned.fill(
                              child: FractionallySizedBox(
                                widthFactor: .4, // The beam is 40% of the card width
                                // Lerp moves the alignment from Far Left to Far Right
                                alignment: AlignmentGeometry.lerp(
                                  const Alignment(-2.0, 0),
                                  const Alignment(2.0, 0),
                                  _shimmerController.value,
                                )!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.3), // The bright center
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      transform: const GradientRotation(0.5), // Tilted beam
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // --- FEATURE: Progress Bar ---
                        // A simple tween that shrinks a line from 100% width to 0%
                        Positioned(
                          bottom: 0,
                          left: 40,
                          right: 40,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: widget.duration,
                            curve: Curves.linear,
                            builder: (context, value, _) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 270 * (1.0 - value), // Shrinks width
                                  height: 2,
                                  decoration: BoxDecoration(
                                      color: widget.baseColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.baseColor,
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        )
                                      ]
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}