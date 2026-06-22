import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/channel.dart';

class StreamFreeService {
  static const _baseUrl = 'https://streamfree.app';

  static Future<List<Channel>> fetchLiveStreams() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/streams')).timeout(
        const Duration(seconds: 15),
      );
      if (res.statusCode != 200) return [];

      final data = json.decode(res.body);
      final streams = data['streams'] as Map<String, dynamic>? ?? {};
      final List<Channel> channels = [];

      const categories = [
        ('soccer', '⚽'),
        ('combat', '🥊'),
        ('basketball', '🏀'),
        ('baseball', '⚾'),
        ('racing', '🏎️'),
        ('tennis', '🎾'),
        ('cricket', '🏏'),
      ];

      final futures = <Future<List<Channel>>>[];
      for (final (cat, emoji) in categories) {
        final items = streams[cat] as List<dynamic>? ?? [];
        futures.add(_processStreams(items, cat, emoji));
      }

      final results = await Future.wait(futures);
      for (final result in results) {
        channels.addAll(result);
      }

      return channels;
    } catch (e) {
      debugPrint('StreamFreeService.fetchLiveStreams failed: $e');
      return [];
    }
  }

  static Future<List<Channel>> _processStreams(
    List<dynamic> items,
    String category,
    String emoji,
  ) async {
    if (items.isEmpty) return [];
    const batchSize = 5;
    final results = <Channel>[];
    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.skip(i).take(batchSize);
      final batchResults = await Future.wait(
        batch.map((s) => _processStream(s, category, 'Sports', emoji)),
      );
      for (final r in batchResults) {
        if (r != null) results.add(r);
      }
    }
    return results;
  }

  static Future<Channel?> _processStream(
    dynamic stream,
    String category,
    String catLabel,
    String emoji,
  ) async {
    try {
      final streamKey = stream['stream_key'] as String? ?? '';
      if (streamKey.isEmpty) return null;

      final name = stream['name'] as String? ?? streamKey;
      final team1 = stream['team1'] as Map<String, dynamic>?;

      // Fetch embed page to get auth tokens
      final tokens = await _fetchTokens(streamKey, category);
      if (tokens == null) return null;

      // Determine best quality
      final quality = await _getBestQuality(streamKey);

      // Build HLS URL
      final hlsUrl = _buildHlsUrl(streamKey, quality, tokens);

      // Build logo from team logos
      String? logo;
      if (team1 != null && team1['logo'] != null) {
        logo = team1['logo'] as String;
      }

      final displayName = '$emoji $name';
      return Channel(
        id: 'sf-$streamKey',
        name: displayName,
        logo: logo,
        streamUrl: hlsUrl,
        category: catLabel,
        country: 'International',
        language: 'English',
      );
    } catch (e) {
      debugPrint('StreamFreeService._processStream failed: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _fetchTokens(String streamKey, String category) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/embed/$category/$streamKey'),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode != 200) return null;

      final html = res.body;

      // Extract _0x JSON from the page
      // Pattern: const _0x = {...};
      final regex = RegExp(r"const _0x = (\{.*?\});", dotAll: true);
      final match = regex.firstMatch(html);
      if (match == null) return null;

      final jsonStr = match.group(1);
      if (jsonStr == null) return null;

      final tokens = json.decode(jsonStr) as Map<String, dynamic>;
      return tokens;
    } catch (e) {
      debugPrint('StreamFreeService._fetchTokens failed: $e');
      return null;
    }
  }

  static Future<String> _getBestQuality(String streamKey) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/api/stream-status/$streamKey'),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) return '720p';

      final data = json.decode(res.body);
      final qualities = data['qualities'] as Map<String, dynamic>? ?? {};

      if (qualities['1080p'] == true) return '1080p';
      if (qualities['720p'] == true) return '720p';
      if (qualities['2160p'] == true) return '2160p';
      if (qualities['540p'] == true) return '540p';
      return '720p';
    } catch (e) {
      debugPrint('StreamFreeService._getBestQuality failed: $e');
      return '720p';
    }
  }

  static String _buildHlsUrl(
    String streamKey,
    String quality,
    Map<String, dynamic> tokens,
  ) {
    final qualityData = tokens[quality] as Map<String, dynamic>?;
    if (qualityData == null) {
      return '$_baseUrl/live/$streamKey$quality/index.m3u8';
    }

    final t = qualityData['_t'] ?? '';
    final e = qualityData['_e'] ?? '';
    final n = qualityData['_n'] ?? '';

    return '$_baseUrl/live/$streamKey$quality/index.m3u8?_t=$t&_e=$e&_n=$n';
  }
}
