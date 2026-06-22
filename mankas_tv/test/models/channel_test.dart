import 'package:flutter_test/flutter_test.dart';
import 'package:mankas_tv/models/channel.dart';

void main() {
  group('Channel', () {
    test('fromM3u parses attributes correctly', () {
      final attrs = {
        'tvg-id': '123',
        'tvg-logo': 'https://example.com/logo.png',
        'group-title': 'Sports',
        'tvg-country': 'FR',
        'tvg-language': 'French',
      };
      final channel = Channel.fromM3u(attrs, 'Test Channel', 'https://example.com/stream.m3u8');

      expect(channel.id, '123');
      expect(channel.name, 'Test Channel');
      expect(channel.logo, 'https://example.com/logo.png');
      expect(channel.streamUrl, 'https://example.com/stream.m3u8');
      expect(channel.category, 'Sports');
      expect(channel.country, 'FR');
      expect(channel.language, 'French');
    });

    test('fromM3u uses name hash as fallback id', () {
      final attrs = <String, String>{};
      final channel = Channel.fromM3u(attrs, 'No ID', 'https://example.com/stream.m3u8');
      expect(channel.id, 'No ID'.hashCode.toString());
    });

    test('fromM3u defaults category to General', () {
      final attrs = <String, String>{};
      final channel = Channel.fromM3u(attrs, 'Test', 'https://example.com/stream.m3u8');
      expect(channel.category, 'General');
    });

    test('toJson and fromJson round-trip', () {
      final original = Channel(
        id: '456',
        name: 'My Channel',
        logo: 'https://example.com/logo.png',
        streamUrl: 'https://example.com/stream.m3u8',
        category: 'News',
        country: 'US',
        language: 'English',
      );

      final json = original.toJson();
      final restored = Channel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.logo, original.logo);
      expect(restored.streamUrl, original.streamUrl);
      expect(restored.category, original.category);
      expect(restored.country, original.country);
      expect(restored.language, original.language);
    });

    test('fromJson handles null optional fields', () {
      final json = <String, dynamic>{
        'id': '789',
        'name': 'Minimal',
        'streamUrl': 'https://example.com/stream.m3u8',
      };
      final channel = Channel.fromJson(json);
      expect(channel.id, '789');
      expect(channel.name, 'Minimal');
      expect(channel.logo, null);
      expect(channel.category, null);
      expect(channel.country, null);
      expect(channel.language, null);
    });
  });
}
