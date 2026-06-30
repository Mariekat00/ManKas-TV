import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page de chargement — cercle animé + message
class LoadingPage extends StatefulWidget {
  final String? title;
  final String? description;

  const LoadingPage({super.key, this.title, this.description});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppStatePage(
      icon: Icons.refresh_rounded,
      iconColor: theme.colorScheme.primary,
      title: widget.title ?? 'Chargement...',
      description: widget.description ?? 'Nous préparons vos chaînes.',
      illustration: _buildSpinner(theme),
    );
  }

  Widget _buildSpinner(ThemeData theme) {
    return SizedBox(
      width: 100,
      height: 100,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) {
          return CustomPaint(
            painter: _LoadingPainter(
              progress: _ctrl.value,
              color: theme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LoadingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Track
    final trackPaint = Paint()
      ..color = color.withAlpha(25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius, trackPaint);

    // Arc animé
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = 2 * math.pi * progress - math.pi / 2;
    canvas.drawArc(rect, startAngle, 1.2, false, arcPaint);

    // Point lumineux
    final dotAngle = 2 * math.pi * progress;
    final dotX = center.dx + radius * math.cos(dotAngle);
    final dotY = center.dy + radius * math.sin(dotAngle);
    final dotPaint = Paint()..color = color;
    canvas.drawCircle(Offset(dotX, dotY), 4, dotPaint);
  }

  @override
  bool shouldRepaint(_LoadingPainter old) => old.progress != progress;
}
