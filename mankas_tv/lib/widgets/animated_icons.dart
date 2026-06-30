import 'package:flutter/material.dart';

/// Pulsing icon — scale animation (heart, empty states)
class PulsingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final Duration duration;

  const PulsingIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _a) => Transform.scale(
        scale: _anim.value,
        child: Icon(widget.icon, size: widget.size, color: widget.color),
      ),
    );
  }
}

/// Spinning icon — rotation animation (loading, refresh)
class SpinningIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final Duration duration;

  const SpinningIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.color,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<SpinningIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.rotate(
        angle: _ctrl.value * 2 * 3.14159,
        child: Icon(widget.icon, size: widget.size, color: widget.color),
      ),
    );
  }
}

/// Bouncing icon — vertical bounce (live indicator)
class BouncingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const BouncingIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.color,
  });

  @override
  State<BouncingIcon> createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Icon(widget.icon, size: widget.size, color: widget.color),
      ),
    );
  }
}

/// Shaking icon — horizontal shake (error, warning)
class ShakingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const ShakingIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.color,
  });

  @override
  State<ShakingIcon> createState() => _ShakingIconState();
}

class _ShakingIconState extends State<ShakingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -4.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: -3.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 3.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(_anim.value, 0),
        child: Icon(widget.icon, size: widget.size, color: widget.color),
      ),
    );
  }
}

/// Fading icon — fade in/out (signal, search)
class FadingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const FadingIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.color,
  });

  @override
  State<FadingIcon> createState() => _FadingIconState();
}

class _FadingIconState extends State<FadingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
      ),
      child: Icon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}
