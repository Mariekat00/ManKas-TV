import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/channel.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool get isAdmin {
    final user = _supabase.auth.currentUser;
    return user?.email?.toLowerCase() == 'moisemanda2000@gmail.com';
  }

  Future<List<Channel>> getAllChannels() async {
    final response = await _supabase
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
  }

  Future<void> addChannel(Channel channel) async {
    await _supabase.from('channels').insert({
      'name': channel.name,
      'logo': channel.logo,
      'stream_url': channel.streamUrl,
      'category': channel.category,
      'country': channel.country,
      'language': channel.language,
    });
  }

  Future<void> updateChannel(Channel channel) async {
    await _supabase.from('channels').update({
      'name': channel.name,
      'logo': channel.logo,
      'stream_url': channel.streamUrl,
      'category': channel.category,
      'country': channel.country,
      'language': channel.language,
    }).eq('id', channel.id);
  }

  Future<void> deleteChannel(String id) async {
    await _supabase.from('channels').delete().eq('id', id);
  }

  Future<int> getChannelCount() async {
    final response = await _supabase
        .from('channels')
        .select()
        .count();
    return response.count;
  }

  Future<int> getFavoriteCount() async {
    final response = await _supabase
        .from('favorites')
        .select()
        .count();
    return response.count;
  }

  Future<List<MapEntry<String, int>>> getChannelsByCategory() async {
    final channels = await getAllChannels();
    final Map<String, int> map = {};
    for (final c in channels) {
      final cat = c.category ?? 'Autre';
      map[cat] = (map[cat] ?? 0) + 1;
    }
    final sorted = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }

  Future<List<MapEntry<String, int>>> getChannelsByCountry() async {
    final channels = await getAllChannels();
    final Map<String, int> map = {};
    for (final c in channels) {
      final country = c.country ?? 'Inconnu';
      map[country] = (map[country] ?? 0) + 1;
    }
    final sorted = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }

  Future<List<MapEntry<String, int>>> getChannelsByLanguage() async {
    final channels = await getAllChannels();
    final Map<String, int> map = {};
    for (final c in channels) {
      final lang = c.language ?? 'Inconnu';
      map[lang] = (map[lang] ?? 0) + 1;
    }
    final sorted = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }
}
