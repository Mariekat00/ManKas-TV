import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mankas_tv/utils/category_theme.dart';

void main() {
  group('categoryColor', () {
    test('returns green for Sports', () {
      expect(categoryColor('Sports'), const Color(0xFF22C55E));
    });

    test('returns indigo for null category', () {
      expect(categoryColor(null), const Color(0xFF6366F1));
    });

    test('returns blue for News', () {
      expect(categoryColor('News'), const Color(0xFF3B82F6));
    });

    test('returns purple for Divertissement', () {
      expect(categoryColor('Divertissement'), const Color(0xFFA855F7));
    });

    test('returns indigo for unknown category', () {
      expect(categoryColor('UnknownCat'), const Color(0xFF6366F1));
    });

    test('returns gold for FIFA World Cup', () {
      expect(categoryColor('FIFA World Cup 2026'), const Color(0xFFD4AF37));
    });

    test('returns gold for World Cup', () {
      expect(categoryColor('World Cup'), const Color(0xFFD4AF37));
    });

    test('returns pink for Music', () {
      expect(categoryColor('Music'), const Color(0xFFEC4899));
    });

    test('returns pink for Musique', () {
      expect(categoryColor('Musique'), const Color(0xFFEC4899));
    });

    test('returns indigo for Général', () {
      expect(categoryColor('Général'), const Color(0xFF6366F1));
    });

    test('uses contains for Sports* match', () {
      expect(categoryColor('Sports 1'), const Color(0xFF22C55E));
    });
  });

  group('categoryIcon', () {
    test('returns sports for Sports', () {
      expect(categoryIcon('Sports'), Icons.sports);
    });

    test('returns live_tv for null', () {
      expect(categoryIcon(null), Icons.live_tv);
    });

    test('returns public for News', () {
      expect(categoryIcon('News'), Icons.public);
    });

    test('returns music_note for Music', () {
      expect(categoryIcon('Music'), Icons.music_note);
    });

    test('returns tv for Divertissement', () {
      expect(categoryIcon('Divertissement'), Icons.tv);
    });

    test('returns live_tv for unknown category', () {
      expect(categoryIcon('UnknownCat'), Icons.live_tv);
    });

    test('returns sports_soccer for FIFA World Cup', () {
      expect(categoryIcon('FIFA World Cup 2026'), Icons.sports_soccer);
    });

    test('returns sports_soccer for World Cup', () {
      expect(categoryIcon('World Cup'), Icons.sports_soccer);
    });

    test('returns music_note for Musique', () {
      expect(categoryIcon('Musique'), Icons.music_note);
    });
  });
}
