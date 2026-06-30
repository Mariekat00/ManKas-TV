import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/channel.dart';


class ChannelService {
  static const _favoritesKey = 'favorites';
  static const _apiBase = 'https://mankas-tv.vercel.app';

  static const guaranteedChannels = [
    // ── Sports ──
    Channel(id: 'rmtv', name: 'Real Madrid TV', logo: 'https://upload.wikimedia.org/wikipedia/en/thumb/1/12/Real_Madrid_CF.svg/512px-Real_Madrid_CF.svg.png', streamUrl: 'https://rmtv.akamaized.net/hls/live/2043153/rmtv-es-web/master.m3u8', category: 'Sports', country: 'Spain', language: 'Spanish'),
    Channel(id: 'gol-classics', name: 'Gol Classics', logo: 'https://img.icons8.com/fluency/512/soccer.png', streamUrl: 'https://d71gqtnep83vb.cloudfront.net/gol_classics/gol_classics.m3u8', category: 'Sports', country: 'Spain', language: 'Spanish'),
    Channel(id: 'equidia', name: 'Equidia', logo: 'https://img.icons8.com/fluency/512/horse.png', streamUrl: 'https://raw.githubusercontent.com/Paradise-91/ParaTV/main/streams/equidia/live2.m3u8', category: 'Sports', country: 'France', language: 'French'),
    Channel(id: 'ftf-sports', name: 'FTF Sports', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Logo_France_T%C3%A9l%C3%A9visions.svg/512px-Logo_France_T%C3%A9l%C3%A9visions.svg.png', streamUrl: 'https://1657061170.rsc.cdn77.org/HLS/FTF-LINEAR.m3u8', category: 'Sports', country: 'France', language: 'French'),
    Channel(id: 'telemundo-ny', name: 'Telemundo NY', logo: 'https://upload.wikimedia.org/wikipedia/commons/6/68/Telemundo_logo_2018.svg', streamUrl: 'https://nbculocallive.akamaized.net/hls/live/2037083/newyork/stream7/master.m3u8', category: 'Sports', country: 'USA', language: 'Spanish'),
    Channel(id: 'arryadia', name: 'Arryadia', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png', streamUrl: 'https://stream-lb.livemediama.com/arryadia/hls/master.m3u8', category: 'Sports', country: 'Morocco', language: 'Arabic'),
    Channel(id: 'arryadia-hd1', name: 'Arryadia HD1', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png', streamUrl: 'https://stream-lb.livemediama.com/arryadia-hd-01/hls/master.m3u8', category: 'Sports', country: 'Morocco', language: 'Arabic'),
    Channel(id: 'alkass-one', name: 'Alkass One', logo: 'https://img.icons8.com/fluency/512/tv.png', streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass1-p/main.m3u8', category: 'Sports', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'alkass-two', name: 'Alkass Two', logo: 'https://img.icons8.com/fluency/512/tv.png', streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass2-p/main.m3u8', category: 'Sports', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'sportitalia', name: 'Sportitalia', logo: 'https://img.icons8.com/fluency/512/sports.png', streamUrl: 'https://edge-001.streamup.eu/sportitalia/sihd_abr/playlist.m3u8', category: 'Sports', country: 'Italy', language: 'Italian'),
    Channel(id: 'draftkings', name: 'DraftKings Network', logo: 'https://img.icons8.com/fluency/512/slot-machine.png', streamUrl: 'https://na.linear.zype.com/e0bd0e23-a958-4e43-8164-4f2fef8876a8/fd3614bd-90bf-4530-a277-65ae3a1720c8-zype/live.m3u8', category: 'Sports', country: 'USA', language: 'English'),
    // ── News ──
    Channel(id: 'ard-erde', name: 'ARD (Das Erste)', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/ARD_Dachmarke_2014.svg/960px-ARD_Dachmarke_2014.svg.png', streamUrl: 'https://daserste-live.ard-mcdn.de/daserste/live/hls/int/master.m3u8', category: 'Divertissement', country: 'Germany', language: 'German'),
    Channel(id: 'africa24-sport', name: 'Africa 24 Sport', logo: 'https://img.icons8.com/fluency/512/tv.png', streamUrl: 'https://africa24.vedge.infomaniak.com/livecast/ik:africa24sport/manifest.m3u8', category: 'Afrique', country: 'France', language: 'French'),
  ];

  static Future<List<Channel>> _fetchFromApi() async {
    try {
      final response = await http.get(Uri.parse('$_apiBase/data/channels.json')).timeout(
        const Duration(seconds: 30),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['channels'] as List<dynamic>;
        return list.map((c) => Channel(
          id: c['id'] ?? '',
          name: c['name'] ?? '',
          logo: c['logo'],
          streamUrl: c['stream_url'] ?? '',
          category: c['category'],
          country: c['country'],
          language: c['language'],
        )).toList();
      }
      debugPrint('Channel API returned ${response.statusCode}');
    } catch (e) {
      debugPrint('Channel API fetch failed: $e');
    }
    return [];
  }

  Future<List<Channel>> getChannels() async {
    final results = <String, Channel>{};

    // 1. API first
    try {
      final apiChannels = await _fetchFromApi();
      for (final ch in apiChannels) {
        results[ch.id] = ch;
      }
    } catch (e) {
      debugPrint('ChannelService: API fetch failed: $e');
    }

    // 2. Supabase channels (admin-added)
    try {
      final supabaseChannels = await _fetchFromSupabase();
      for (final ch in supabaseChannels) {
        results[ch.id] = ch;
      }
    } catch (e) {
      debugPrint('ChannelService: Supabase fetch failed: $e');
    }

    // 3. Merge with guaranteed
    for (final ch in guaranteedChannels) {
      results.putIfAbsent(ch.id, () => ch);
    }

    if (results.isNotEmpty) {
      return results.values.toList();
    }

    return List<Channel>.from(guaranteedChannels);
  }

  static Future<List<Channel>> _fetchFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('channels')
          .select()
          .order('name');
      return (response as List).map((c) => Channel(
        id: c['id'] as String,
        name: c['name'] as String,
        logo: c['logo'] as String?,
        streamUrl: c['stream_url'] as String,
        category: c['category'] as String?,
        country: c['country'] as String?,
        language: c['language'] as String?,
      )).toList();
    } catch (e) {
      debugPrint('ChannelService: Supabase channels fetch failed: $e');
      return [];
    }
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> toggleFavorite(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (favorites.contains(channelId)) {
      favorites.remove(channelId);
    } else {
      favorites.add(channelId);
    }
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static const _recentSearchesKey = 'recent_searches';

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchesKey) ?? [];
  }

  Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, searches);
  }

}
