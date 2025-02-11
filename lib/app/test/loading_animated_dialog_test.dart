import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

const loadingMessages = [
  "Just a moment...",
  "Please wait...",
  "Hold on...",
  "Loading, please wait...",
  "Hang tight...",
  "Almost there...",
  "Still with us? Just fine-tuning things...",
  "One moment please...",
  "Just a sec...",
  "Processing your request...",
  "Please hold on...",
  "Working on it...",
  "Stay with us...",
  "We're getting there...",
  "Give us a second...",
  "Waiting for things to load...",
  "Getting everything ready...",
  "Loading, please be patient...",
  "Please stand by...",
  "Getting things in order...",
  "Thank you for your patience...",
  "Just a little bit longer...",
  "Preparing your content...",
  "Completing tasks...",
  "We're almost ready...",
  "Almost done...",
  "Patience, we're on it...",
  "Wait just a little longer...",
  "Getting things set up...",
  "Hang on, loading now..."
];

/// Enum representing the allowed shape types: only circles and 4‑point stars.
enum ShapeType { circle, fourPointStar }

/// Data class representing a moving shape with oscillating size.
class CircleData {
  Offset position;
  double baseRadius;
  double currentRadius;
  final Offset drift;
  final Color color;
  final ShapeType shape;
  final double phase; // For oscillation offset

  CircleData({
    required this.position,
    required this.baseRadius,
    required this.currentRadius,
    required this.drift,
    required this.color,
    required this.shape,
    required this.phase,
  });
}

/// A frosty animated background that always animates. It draws a blurred,
/// full-screen background with softly colored shapes (either circles or 4‑point stars).
/// Optionally, you can supply a list of colors via [circleColors] from which the shapes
/// will be chosen at random. For 4‑point stars, the base radius is capped at 48px.
class FrostyBackground extends StatefulWidget {
  final double blurSigma;
  final List<Color>? circleColors;
  const FrostyBackground({
    super.key,
    this.blurSigma = 4.0,
    this.circleColors,
  });

  @override
  State<FrostyBackground> createState() => _FrostyBackgroundState();
}

class _FrostyBackgroundState extends State<FrostyBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<CircleData> _circles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Ensure the system status bar is transparent.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _initializeCircles(size);
    });

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..addListener(() {
        _updateCircles();
        setState(() {});
      })
      ..repeat();
  }

  void _initializeCircles(Size size) {
    _circles.clear();
    int count = 10 + _random.nextInt(6); // between 10 and 15 shapes.
    for (int i = 0; i < count; i++) {
      double baseRadius = (size.width * 0.05) + _random.nextDouble() * (size.width * 0.15);
      // Only allow circles or 4-point stars.
      double shapeRoll = _random.nextDouble();
      ShapeType shape;
      if (shapeRoll < 0.8) {
        shape = ShapeType.circle;
      } else {
        shape = ShapeType.fourPointStar;
      }
      // For 4-point stars, cap the base radius at 48 pixels.
      if (shape == ShapeType.fourPointStar && baseRadius > 48) {
        baseRadius = 48;
      }
      double currentRadius = baseRadius;
      Offset position = Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );
      Offset drift = Offset(
        (_random.nextDouble() - 0.5) * 0.5,
        (_random.nextDouble() - 0.5) * 0.5,
      );
      Color color;
      if (widget.circleColors != null && widget.circleColors!.isNotEmpty) {
        color = widget.circleColors![_random.nextInt(widget.circleColors!.length)];
      } else {
        double hue = _random.nextDouble() * 360;
        double saturation = 0.3 + _random.nextDouble() * 0.4;
        double alpha = 0.1 + _random.nextDouble() * 0.1; // 10% to 20% opacity.
        HSLColor hslColor = HSLColor.fromAHSL(alpha, hue, saturation, 0.5);
        color = hslColor.toColor();
      }
      double phase = _random.nextDouble() * 2 * pi;
      _circles.add(CircleData(
        position: position,
        baseRadius: baseRadius,
        currentRadius: currentRadius,
        drift: drift,
        color: color,
        shape: shape,
        phase: phase,
      ));
    }
  }

  void _updateCircles() {
    final size = MediaQuery.of(context).size;
    for (var circle in _circles) {
      // Oscillate size using a sine wave.
      circle.currentRadius = circle.baseRadius * (0.8 + 0.4 * sin(2 * pi * _controller.value + circle.phase));
      circle.position += circle.drift;
      // Wrap horizontally.
      if (circle.position.dx < -circle.currentRadius) {
        circle.position =
            Offset(size.width + circle.currentRadius + _random.nextDouble() * 20, circle.position.dy + _random.nextDouble() * 20);
      } else if (circle.position.dx > size.width + circle.currentRadius) {
        circle.position = Offset(-circle.currentRadius - _random.nextDouble() * 20, circle.position.dy - _random.nextDouble() * 20);
      }
      // Wrap vertically.
      if (circle.position.dy < -circle.currentRadius) {
        circle.position =
            Offset(circle.position.dx + _random.nextDouble() * 20, size.height + circle.currentRadius + _random.nextDouble() * 20);
      } else if (circle.position.dy > size.height + circle.currentRadius) {
        circle.position = Offset(circle.position.dx - _random.nextDouble() * 20, -circle.currentRadius - _random.nextDouble() * 20);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // Use a very light background color (15% opacity).
    final Color bgColor = brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.15);

    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _CirclePainter(circles: _circles),
        ),
        Container(color: bgColor),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blurSigma, sigmaY: widget.blurSigma),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }
}

/// Custom painter that draws shapes based on [CircleData].
class _CirclePainter extends CustomPainter {
  final List<CircleData> circles;
  _CirclePainter({required this.circles});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    for (var circle in circles) {
      paint.color = circle.color;
      switch (circle.shape) {
        case ShapeType.circle:
          canvas.drawCircle(circle.position, circle.currentRadius, paint);
          break;
        case ShapeType.fourPointStar:
          _drawStar(canvas, circle.position, circle.currentRadius, 4, paint);
          break;
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, int points, Paint paint) {
    final Path path = Path();
    final double angle = (2 * pi) / points;
    final double halfAngle = angle / 2;
    final double innerRadius = radius * 0.5;
    for (int i = 0; i < points; i++) {
      double outerAngle = i * angle;
      double innerAngle = outerAngle + halfAngle;
      Offset outerPoint = Offset(
        center.dx + radius * cos(outerAngle),
        center.dy + radius * sin(outerAngle),
      );
      Offset innerPoint = Offset(
        center.dx + innerRadius * cos(innerAngle),
        center.dy + innerRadius * sin(innerAngle),
      );
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    canvas.drawShadow(path, Colors.black, 2.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) => true;
}



class OrganicBackgroundEffect extends StatefulWidget {
  final List<Color>? gradientColors;
  final List<Color>? particleColors;
  final int particleCount;
  final double particleOpacity;
  final double gradientOpacity;

  const OrganicBackgroundEffect({
    super.key,
    this.gradientColors,
    this.particleColors,
    this.particleCount = 1000,
    this.particleOpacity = 0.07,
    this.gradientOpacity = 0.07,
  });

  @override
  State<OrganicBackgroundEffect> createState() => _OrganicBackgroundEffectState();
}

class _OrganicBackgroundEffectState extends State<OrganicBackgroundEffect> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _rotationController;
  final List<Particle> _particles = [];
  final Random _random = Random();

  // Default colors if none provided
  final List<Color> _defaultColors = [
    const Color(0xFF4285F4), // Google Blue
    const Color(0xFF34A853), // Google Green
    const Color(0xFFFBBC05), // Google Yellow
    const Color(0xFFEA4335), // Google Red
    const Color(0xFF9C27B0), // Purple
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeParticles();
    });
  }

  void _initializeParticles() {
    final size = MediaQuery.of(context).size;
    final particleColors = widget.particleColors ?? _defaultColors;

    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        color: particleColors[_random.nextInt(particleColors.length)]
            .withValues(alpha: widget.particleOpacity),
        size: 1 + _random.nextDouble() * 2,
        speed: 0.2 + _random.nextDouble() * 0.3,
        angle: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Gradient background layer
            AnimatedBuilder(
              animation: Listenable.merge([_pulseController, _rotationController]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: GradientPainter(
                    colors: widget.gradientColors ?? _defaultColors,
                    pulseValue: _pulseController.value,
                    rotationValue: _rotationController.value,
                    opacity: widget.gradientOpacity,
                  ),
                );
              },
            ),
            // Particle layer
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ParticlePainter(
                    particles: _particles,
                    animationValue: _rotationController.value,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class Particle {
  Offset position;
  final Color color;
  final double size;
  final double speed;
  final double angle;

  Particle({
    required this.position,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class GradientPainter extends CustomPainter {
  final List<Color> colors;
  final double pulseValue;
  final double rotationValue;
  final double opacity;

  GradientPainter({
    required this.colors,
    required this.pulseValue,
    required this.rotationValue,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Create multiple gradient layers with different rotations
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(size.width * 0.5, 0),
          Offset(size.width * 0.5, size.height),
          [
            colors[i].withValues(alpha: opacity),
            colors[(i + 1) % colors.length].withValues(alpha: opacity),
          ],
          [0, 1],
          TileMode.clamp,
          Matrix4.rotationZ(rotationValue * pi * 2 + (i * pi / colors.length))
              .storage,
        );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => true;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Move particles in a more organic way
      final dx = cos(particle.angle + animationValue * particle.speed) * 2;
      final dy = sin(particle.angle + animationValue * particle.speed) * 2;

      particle.position = Offset(
        (particle.position.dx + dx) % size.width,
        (particle.position.dy + dy) % size.height,
      );

      final paint = Paint()
        ..color = particle.color
        ..strokeWidth = particle.size
        ..strokeCap = StrokeCap.round;

      canvas.drawPoints(
        ui.PointMode.points,
        [particle.position],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}


/// A full-screen, animated loading page that always animates.
/// This page uses a transparent Scaffold with an animated frosty background
/// and a centered animated loading message.
class FrostyLoadingScaffold extends StatefulWidget {
  final String? msg;
  final Duration transitionDuration;
  final List<Color>? gradientColors;
  final List<Color>? particleColors;
  final List<Color>? circleColors;
  final bool canPop;
  final Color? backgroundColor;
  final int particleCount;
  final double particleOpacity;
  final double gradientOpacity;
  final double blurSigma;

  const FrostyLoadingScaffold({
    super.key,
    this.msg,
    this.transitionDuration = const Duration(milliseconds: 600),
    this.gradientColors,
    this.particleColors,
    this.canPop = true,
    this.backgroundColor, this.circleColors, this.particleCount = 1000,
    this.particleOpacity = 0.07, this.gradientOpacity = 0.07,
    this.blurSigma = 4.0
  });

  @override
  State<FrostyLoadingScaffold> createState() => _FrostyLoadingScaffoldState();
}

class _FrostyLoadingScaffoldState extends State<FrostyLoadingScaffold> {
  int msgIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        msgIndex = (msgIndex + 1) % loadingMessages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: widget.canPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          body: Stack(
            children: [
              // Organic background effect
              OrganicBackgroundEffect(
                gradientColors: widget.gradientColors,
                particleColors: widget.particleColors,
                particleCount: widget.particleCount,
                particleOpacity: widget.particleOpacity,
                gradientOpacity: widget.gradientOpacity,
              ),
              // Frosty background
              FrostyBackground(
                blurSigma: widget.blurSigma,
                circleColors: widget.circleColors,
              ),
              // Loading message
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedSwitcher(
                    duration: widget.transitionDuration,
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.decelerate,
                      ));
                      if (widget.msg == null || (widget.msg != null && widget.msg!.isEmpty)) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      }
                      return child;
                    },
                    child: CustomText(
                      widget.msg ?? loadingMessages[msgIndex],
                      key: ValueKey<int>(msgIndex),
                      fontSize: 18,
                      shadows: const [
                        Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 4),
                      ],
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



PageRouteBuilder loadingDialogBuilder({
  bool isAnimatedDialog = false,
  String? msg,
  bool? canPop,
  Color? backgroundColor,
  List<Color>? animatedColors,
  Color? progressIndicatorColor,
  Duration transitionDuration = const Duration(milliseconds: 500),
  Duration reverseTransitionDuration = const Duration(milliseconds: 250),
  Curve curve = Curves.ease,
  // Extra parameters for the animated scaffold:
  List<Color>? gradientColors,
  List<Color>? particleColors,
  int particleCount = 1000,
  double particleOpacity = 0.07,
  double gradientOpacity = 0.07,
  double blurSigma = 4.0,
}) {
  return PageRouteBuilder(
    opaque: false,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) {
      if (isAnimatedDialog) {
        return FrostyLoadingScaffold(
          msg: msg,
          canPop: canPop ?? true,
          backgroundColor: backgroundColor,
          circleColors: animatedColors,
          gradientColors: gradientColors,
          particleColors: particleColors,
          particleCount: particleCount,
          particleOpacity: particleOpacity,
          gradientOpacity: gradientOpacity,
          blurSigma: blurSigma,
        );
      } else {
        return NormalLoadingScaffold(
          msg: msg,
          canPop: canPop ?? false,
          progressIndicatorColor: progressIndicatorColor,
          backgroundColor: backgroundColor,
        );
      }
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Always apply a fade transition using the provided curve.
      final Animation<double> fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: animation, curve: curve));

      return FadeTransition(
        opacity: fadeAnimation,
        child: Builder(
          builder: (context) {
            // When the route is popping, apply an additional scale effect:
            // Scale = 1.0 when animation.value == 1 and 1.5 when animation.value == 0.
            double scale = 1.0;
            if (animation.status == AnimationStatus.reverse) {
              scale = 1.0 + (1 - animation.value) * 0.5;
            }
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
        ),
      );
    },
  );
}




class NormalLoadingScaffold extends StatefulWidget {
  final bool canPop;
  final String? msg;
  final Color? progressIndicatorColor;
  final Color? backgroundColor;

  const NormalLoadingScaffold({
    super.key,
    this.canPop = false,
    this.msg,
    this.progressIndicatorColor,
    this.backgroundColor,
  });

  @override
  State<NormalLoadingScaffold> createState() => _NormalLoadingScaffoldState();
}

class _NormalLoadingScaffoldState extends State<NormalLoadingScaffold> {
  int msgIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      setState(() {
        msgIndex == loadingMessages.length - 1 ? msgIndex = 0 : msgIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return PopScope(
      canPop: widget.canPop,
      child: Scaffold(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Align(
            alignment: Alignment.center,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(36),
              ),
              child: SizedBox(
                width: screenWidth * 0.6,
                height: screenWidth * 0.4,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          color: widget.progressIndicatorColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        child: CustomText(widget.msg ?? loadingMessages[msgIndex]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
