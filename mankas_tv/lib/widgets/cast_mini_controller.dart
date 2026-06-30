import 'dart:async';
import 'package:flutter/material.dart';
import '../services/cast_service.dart';

class CastMiniController extends StatefulWidget {
  const CastMiniController({super.key});

  @override
  State<CastMiniController> createState() => _CastMiniControllerState();
}

class _CastMiniControllerState extends State<CastMiniController> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = CastService.instance.stateStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cast = CastService.instance;
    if (!cast.isConnected) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isPlaying = cast.state == CastState.playing;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(77)),
      ),
      child: Row(
        children: [
          Icon(Icons.cast_connected, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Casting to Chromecast',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            onPressed: () => cast.togglePlayPause(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            icon: Icon(Icons.stop_circle, color: theme.colorScheme.error, size: 24),
            onPressed: () => cast.disconnect(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
