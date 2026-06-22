import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';
import '../utils/app_strings.dart';

class NetworkQualityIndicator extends StatelessWidget {
  const NetworkQualityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, _) {
        final s = AppStrings.of(context);
        final (color, label) = switch (connectivity.quality) {
          NetworkQuality.good => (const Color(0xFF22C55E), s.networkGood),
          NetworkQuality.fair => (const Color(0xFFEAB308), s.networkFair),
          NetworkQuality.poor => (const Color(0xFFF97316), s.networkPoor),
          NetworkQuality.none => (const Color(0xFFEF4444), s.offline),
        };
        return Tooltip(
          message: '$label (${connectivity.latencyMs >= 0 ? '${connectivity.latencyMs}ms' : 'N/A'})',
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withAlpha(80), blurRadius: 4, spreadRadius: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}
