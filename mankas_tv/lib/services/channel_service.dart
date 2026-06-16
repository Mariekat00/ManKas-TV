import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';
import 'm3u_parser.dart';

class ChannelService {
  static const _favoritesKey = 'favorites';
  static const _cacheKey = 'channels_cache_v2';

  static const guaranteedChannels = [
    // ── Spain ──
    Channel(
      id: 'rmtv',
      name: 'Real Madrid TV',
      logo: 'https://upload.wikimedia.org/wikipedia/en/thumb/1/12/Real_Madrid_CF.svg/512px-Real_Madrid_CF.svg.png',
      streamUrl: 'https://rmtv.akamaized.net/hls/live/2043153/rmtv-es-web/master.m3u8',
      category: 'Sports',
      country: 'Spain',
      language: 'Spanish',
    ),
    Channel(
      id: 'gol-classics',
      name: 'Gol Classics',
      logo: 'https://img.icons8.com/fluency/512/soccer.png',
      streamUrl: 'https://d71gqtnep83vb.cloudfront.net/gol_classics/gol_classics.m3u8',
      category: 'Sports',
      country: 'Spain',
      language: 'Spanish',
    ),
    // ── France ──
    Channel(
      id: 'lequipe',
      name: "L'Equipe",
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/L%27%C3%89quipe_wordmark.svg/640px-L%27%C3%89quipe_wordmark.svg.png',
      streamUrl: 'https://www.dailymotion.com/video/x2lefik',
      category: 'Sports',
      country: 'France',
      language: 'French',
    ),
    Channel(
      id: 'equidia',
      name: 'Equidia',
      logo: 'https://img.icons8.com/fluency/512/horse.png',
      streamUrl: 'https://raw.githubusercontent.com/Paradise-91/ParaTV/main/streams/equidia/live2.m3u8',
      category: 'Sports',
      country: 'France',
      language: 'French',
    ),
    Channel(
      id: 'trace-sport-stars',
      name: 'Trace Sport Stars',
      logo: 'https://cdn-icons-png.flaticon.com/512/3112/3112948.png',
      streamUrl: 'https://lightning-tracesport-samsungau.amagi.tv/playlist.m3u8',
      category: 'Sports',
      country: 'France',
      language: 'French',
    ),
    Channel(
      id: 'ftf-sports',
      name: 'FTF Sports',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Logo_France_T%C3%A9l%C3%A9visions.svg/512px-Logo_France_T%C3%A9l%C3%A9visions.svg.png',
      streamUrl: 'https://1657061170.rsc.cdn77.org/HLS/FTF-LINEAR.m3u8',
      category: 'Sports',
      country: 'France',
      language: 'French',
    ),
    Channel(
      id: 'nrj12',
      name: 'NRJ 12',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/NRJ12_logo_2015.svg/749px-NRJ12_logo_2015.svg.png',
      streamUrl: 'https://nrj12.nrjaudio.fm/hls/live/2038374/nrj_12/master.m3u8',
      category: 'Entertainment',
      country: 'France',
      language: 'French',
    ),
    Channel(
      id: 'cgtvfrench',
      name: 'CGTN Francais',
      logo: 'https://i.imgur.com/fMsJYzl.png',
      streamUrl: 'https://news.cgtn.com/resource/live/french/cgtn-f.m3u8',
      category: 'News',
      country: 'France',
      language: 'French',
    ),
    Channel(
      id: 'm6',
      name: 'M6',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/8/8e/Groupe_M6_Logo.png',
      streamUrl: 'https://origin-m6web.live.6cloud.fr/out/v1/6play/6play-m6/cmaf_q2hyb21h/index-hd720.m3u8',
      category: 'Entertainment',
      country: 'France',
      language: 'French',
    ),
    // ── USA (Spanish) ──
    Channel(
      id: 'telemundo-ny',
      name: 'Telemundo NY',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/6/68/Telemundo_logo_2018.svg',
      streamUrl: 'https://nbculocallive.akamaized.net/hls/live/2037083/newyork/stream7/master.m3u8',
      category: 'Sports',
      country: 'USA',
      language: 'Spanish',
    ),
    // ── Qatar ──
    Channel(
      id: 'alkass-one',
      name: 'Alkass One',
      logo: 'https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png',
      streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass1-p/main.m3u8',
      category: 'Sports',
      country: 'Qatar',
      language: 'Arabic',
    ),
    Channel(
      id: 'alkass-two',
      name: 'Alkass Two',
      logo: 'https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png',
      streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass2-p/main.m3u8',
      category: 'Sports',
      country: 'Qatar',
      language: 'Arabic',
    ),
    // ── Morocco ──
    Channel(
      id: 'arryadia',
      name: 'Arryadia',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png',
      streamUrl: 'https://stream-lb.livemediama.com/arryadia/hls/master.m3u8',
      category: 'Sports',
      country: 'Morocco',
      language: 'Arabic',
    ),
    Channel(
      id: 'arryadia-hd1',
      name: 'Arryadia HD1',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png',
      streamUrl: 'https://stream-lb.livemediama.com/arryadia-hd-01/hls/master.m3u8',
      category: 'Sports',
      country: 'Morocco',
      language: 'Arabic',
    ),
    // ── beIN Sports ──
    Channel(
      id: 'bein-xtra',
      name: 'beIN Sports XTRA',
      logo: 'https://static.wikia.nocookie.net/logopedia/images/0/0b/BeIN_Xtra.PNG',
      streamUrl: 'https://bein-xtra-bein.amagi.tv/playlist.m3u8',
      category: 'Sports',
      country: 'Qatar',
      language: 'Arabic',
    ),
    Channel(
      id: 'bein-xtra-es',
      name: 'beIN Sports XTRA Español',
      logo: 'https://static.wikia.nocookie.net/logopedia/images/0/0b/BeIN_Xtra.PNG',
      streamUrl: 'https://dc1644a9jazgj.cloudfront.net/beIN_Sports_Xtra_Espanol.m3u8',
      category: 'Sports',
      country: 'USA',
      language: 'Spanish',
    ),
    // ── More Free Sports ──
    Channel(
      id: '30a-golf',
      name: '30A Golf Kingdom',
      logo: 'https://img.icons8.com/fluency/512/golf.png',
      streamUrl: 'https://30a-tv.com/feeds/vidaa/golf.m3u8',
      category: 'Sports',
      country: 'USA',
      language: 'English',
    ),
    Channel(
      id: 'as3-sport',
      name: 'AS3 Sport TV',
      logo: 'https://img.icons8.com/fluency/512/sports.png',
      streamUrl: 'https://streamtv.as3sport.online:3394/hybrid/play.m3u8',
      category: 'Sports',
      country: 'International',
      language: 'English',
    ),
    Channel(
      id: 'bahrain-sports-1',
      name: 'Bahrain Sports 1',
      logo: 'https://img.icons8.com/fluency/512/basketball.png',
      streamUrl: 'https://5c7b683162943.streamlock.net/live/ngrp:sportsone_all/playlist.m3u8',
      category: 'Sports',
      country: 'Bahrain',
      language: 'Arabic',
    ),
    Channel(
      id: 'cricket-gold',
      name: 'Cricket Gold',
      logo: 'https://img.icons8.com/fluency/512/cricket.png',
      streamUrl: 'https://streams2.sofast.tv/scheduler/scheduleMaster/418.m3u8',
      category: 'Sports',
      country: 'India',
      language: 'English',
    ),
    Channel(
      id: 'draftkings',
      name: 'DraftKings Network',
      logo: 'https://img.icons8.com/fluency/512/slot-machine.png',
      streamUrl: 'https://na.linear.zype.com/e0bd0e23-a958-4e43-8164-4f2fef8876a8/fd3614bd-90bf-4530-a277-65ae3a1720c8-zype/live.m3u8',
      category: 'Sports',
      country: 'USA',
      language: 'English',
    ),
  ];

  Future<List<Channel>> getChannels() async {
    final cached = await _loadCachedChannels();
    if (cached.isNotEmpty) return cached;

    final channels = List<Channel>.from(guaranteedChannels);

    try {
      final response = await http.get(Uri.parse('https://iptv-org.github.io/iptv/countries/es.m3u'));
      if (response.statusCode == 200) {
        final parsed = M3uParser.parse(response.body);
        for (var i = 0; i < parsed.length; i++) {
          final ch = parsed[i];
          if (ch.streamUrl.endsWith('.m3u8') || ch.streamUrl.contains('.m3u8?')) {
            channels.add(Channel(
              id: 'iptv-$i',
              name: ch.name,
              logo: ch.logo,
              streamUrl: ch.streamUrl,
              category: ch.category,
              country: ch.country,
              language: ch.language,
            ));
          }
        }
      }
    } catch (_) {}

    await _cacheChannels(channels);
    return channels;
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

  Future<void> _cacheChannels(List<Channel> channels) async {
    final prefs = await SharedPreferences.getInstance();
    final json = channels.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_cacheKey, json);
  }

  Future<List<Channel>> _loadCachedChannels() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(_cacheKey);
    if (json == null || json.isEmpty) return [];
    return json.map((s) => Channel.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }
}
