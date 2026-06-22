import 'package:flutter/material.dart';

Color categoryColor(String? cat) {
  if (cat == null) return const Color(0xFF6366F1);
  if (cat.contains('World Cup') || cat.contains('FIFA')) return const Color(0xFFD4AF37);
  if (cat.contains('Sports')) return const Color(0xFF22C55E);
  if (cat.contains('Actualités') || cat.contains('News')) return const Color(0xFF3B82F6);
  if (cat.contains('Musique') || cat.contains('Music')) return const Color(0xFFEC4899);
  if (cat.contains('Divertissement')) return const Color(0xFFA855F7);
  return const Color(0xFF6366F1);
}

IconData categoryIcon(String? cat) {
  if (cat == null) return Icons.live_tv;
  if (cat.contains('World Cup') || cat.contains('FIFA')) return Icons.sports_soccer;
  if (cat.contains('Sports')) return Icons.sports;
  if (cat.contains('Actualités') || cat.contains('News')) return Icons.public;
  if (cat.contains('Musique') || cat.contains('Music')) return Icons.music_note;
  if (cat.contains('Divertissement')) return Icons.tv;
  return Icons.live_tv;
}
