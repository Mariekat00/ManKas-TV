import 'package:flutter_test/flutter_test.dart';
import 'package:mankas_tv/services/m3u_parser.dart';

void main() {
  group('M3uParser', () {
    test('parses a single channel', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="1" tvg-logo="https://example.com/logo.png" group-title="Sports",Sports Channel
https://example.com/stream.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
      expect(channels[0].name, 'Sports Channel');
      expect(channels[0].logo, 'https://example.com/logo.png');
      expect(channels[0].streamUrl, 'https://example.com/stream.m3u8');
      expect(channels[0].category, 'Sports');
    });

    test('parses multiple channels', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="1" group-title="News",News One
https://example.com/news1.m3u8
#EXTINF:-1 tvg-id="2" group-title="News",News Two
https://example.com/news2.m3u8
#EXTINF:-1 tvg-id="3" group-title="Sports",Sports One
https://example.com/sports1.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 3);
      expect(channels[0].name, 'News One');
      expect(channels[1].name, 'News Two');
      expect(channels[2].name, 'Sports One');
    });

    test('skips lines without URL', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="1",No URL
#EXTINF:-1 tvg-id="2",Has URL
https://example.com/stream.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
      expect(channels[0].name, 'Has URL');
    });

    test('defaults name when missing after comma', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="1" tvg-name="Named Channel"
https://example.com/stream.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
      expect(channels[0].name, 'Named Channel');
    });

    test('falls back to Sans nom', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="1"
https://example.com/stream.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
      expect(channels[0].name, 'Sans nom');
    });

    test('defaults category to Général', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="1",Channel
https://example.com/stream.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
      expect(channels[0].category, 'Général');
    });

    test('handles empty content', () {
      final channels = M3uParser.parse('');
      expect(channels, isEmpty);
    });

    test('handles Windows line endings', () {
      final m3u = '#EXTM3U\r\n#EXTINF:-1 tvg-id="1",Channel\r\nhttps://example.com/stream.m3u8\r\n';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
    });

    test('extracts attributes with special characters', () {
      final m3u = '''
#EXTM3U
#EXTINF:-1 tvg-id="123" tvg-logo="https://example.com/path?query=1&key=val" group-title="TV & Movies",My Channel
https://example.com/stream.m3u8
''';
      final channels = M3uParser.parse(m3u);
      expect(channels.length, 1);
      expect(channels[0].logo, 'https://example.com/path?query=1&key=val');
      expect(channels[0].category, 'TV & Movies');
    });
  });
}
