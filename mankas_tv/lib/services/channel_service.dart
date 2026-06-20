import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';


class ChannelService {
  static const _favoritesKey = 'favorites';
  static const _cacheKey = 'channels_cache_v5';
  static const _apiBase = 'https://mankas-tv.vercel.app';

  static const guaranteedChannels = [
    // ── Sports ──
    Channel(id: 'rmtv', name: 'Real Madrid TV', logo: 'https://upload.wikimedia.org/wikipedia/en/thumb/1/12/Real_Madrid_CF.svg/512px-Real_Madrid_CF.svg.png', streamUrl: 'https://rmtv.akamaized.net/hls/live/2043153/rmtv-es-web/master.m3u8', category: 'Sports', country: 'Spain', language: 'Spanish'),
    Channel(id: 'gol-classics', name: 'Gol Classics', logo: 'https://img.icons8.com/fluency/512/soccer.png', streamUrl: 'https://d71gqtnep83vb.cloudfront.net/gol_classics/gol_classics.m3u8', category: 'Sports', country: 'Spain', language: 'Spanish'),
    Channel(id: 'lequipe', name: "L'Equipe", logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/L%27%C3%89quipe_wordmark.svg/640px-L%27%C3%89quipe_wordmark.svg.png', streamUrl: 'https://www.dailymotion.com/video/x2lefik', category: 'Sports', country: 'France', language: 'French'),
    Channel(id: 'equidia', name: 'Equidia', logo: 'https://img.icons8.com/fluency/512/horse.png', streamUrl: 'https://raw.githubusercontent.com/Paradise-91/ParaTV/main/streams/equidia/live2.m3u8', category: 'Sports', country: 'France', language: 'French'),
    Channel(id: 'trace-sport-stars', name: 'Trace Sport Stars', logo: 'https://cdn-icons-png.flaticon.com/512/3112/3112948.png', streamUrl: 'https://lightning-tracesport-samsungau.amagi.tv/playlist.m3u8', category: 'Sports', country: 'France', language: 'French'),
    Channel(id: 'ftf-sports', name: 'FTF Sports', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Logo_France_T%C3%A9l%C3%A9visions.svg/512px-Logo_France_T%C3%A9l%C3%A9visions.svg.png', streamUrl: 'https://1657061170.rsc.cdn77.org/HLS/FTF-LINEAR.m3u8', category: 'Sports', country: 'France', language: 'French'),
    Channel(id: 'telemundo-ny', name: 'Telemundo NY', logo: 'https://upload.wikimedia.org/wikipedia/commons/6/68/Telemundo_logo_2018.svg', streamUrl: 'https://nbculocallive.akamaized.net/hls/live/2037083/newyork/stream7/master.m3u8', category: 'Sports', country: 'USA', language: 'Spanish'),
    Channel(id: 'arryadia', name: 'Arryadia', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png', streamUrl: 'https://stream-lb.livemediama.com/arryadia/hls/master.m3u8', category: 'Sports', country: 'Morocco', language: 'Arabic'),
    Channel(id: 'arryadia-hd1', name: 'Arryadia HD1', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Arryadia_logo.svg/512px-Arryadia_logo.svg.png', streamUrl: 'https://stream-lb.livemediama.com/arryadia-hd-01/hls/master.m3u8', category: 'Sports', country: 'Morocco', language: 'Arabic'),
    Channel(id: 'bein-xtra', name: 'beIN Sports XTRA', logo: 'https://static.wikia.nocookie.net/logopedia/images/0/0b/BeIN_Xtra.PNG', streamUrl: 'https://bein-xtra-bein.amagi.tv/playlist.m3u8', category: 'Sports', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'bein-xtra-es', name: 'beIN Sports XTRA Español', logo: 'https://static.wikia.nocookie.net/logopedia/images/0/0b/BeIN_Xtra.PNG', streamUrl: 'https://dc1644a9jazgj.cloudfront.net/beIN_Sports_Xtra_Espanol.m3u8', category: 'Sports', country: 'USA', language: 'Spanish'),
    Channel(id: 'bein-sports-1', name: 'beIN Sports 1', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/BeIN_Sports_logo_%28vertical_version%29.svg/500px-BeIN_Sports_logo_%28vertical_version%29.svg.png', streamUrl: 'http://23.237.104.106:8080/USA_BEIN/index.m3u8', category: 'Sports', country: 'USA', language: 'English'),
    Channel(id: '30a-golf', name: '30A Golf Kingdom', logo: 'https://img.icons8.com/fluency/512/golf.png', streamUrl: 'https://30a-tv.com/feeds/vidaa/golf.m3u8', category: 'Sports', country: 'USA', language: 'English'),
    Channel(id: 'as3-sport', name: 'AS3 Sport TV', logo: 'https://img.icons8.com/fluency/512/sports.png', streamUrl: 'https://streamtv.as3sport.online:3394/hybrid/play.m3u8', category: 'Sports', country: 'International', language: 'English'),
    Channel(id: 'bahrain-sports-1', name: 'Bahrain Sports 1', logo: 'https://img.icons8.com/fluency/512/basketball.png', streamUrl: 'https://5c7b683162943.streamlock.net/live/ngrp:sportsone_all/playlist.m3u8', category: 'Sports', country: 'Bahrain', language: 'Arabic'),
    Channel(id: 'cricket-gold', name: 'Cricket Gold', logo: 'https://img.icons8.com/fluency/512/cricket.png', streamUrl: 'https://streams2.sofast.tv/scheduler/scheduleMaster/418.m3u8', category: 'Sports', country: 'India', language: 'English'),
    Channel(id: 'draftkings', name: 'DraftKings Network', logo: 'https://img.icons8.com/fluency/512/slot-machine.png', streamUrl: 'https://na.linear.zype.com/e0bd0e23-a958-4e43-8164-4f2fef8876a8/fd3614bd-90bf-4530-a277-65ae3a1720c8-zype/live.m3u8', category: 'Sports', country: 'USA', language: 'English'),
    Channel(id: 'cazetv', name: 'CazéTV', logo: 'https://img.icons8.com/fluency/512/youtube-play.png', streamUrl: 'https://www.youtube.com/@cazetvoficial/live', category: 'Sports', country: 'Brazil', language: 'Portuguese'),
    // ── FIFA World Cup 2026 ──
    Channel(id: 'alkass-one', name: 'Alkass One', logo: 'https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png', streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass1-p/main.m3u8', category: 'FIFA World Cup 2026', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'alkass-two', name: 'Alkass Two', logo: 'https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png', streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass2-p/main.m3u8', category: 'FIFA World Cup 2026', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'alkass-three', name: 'Alkass Three', logo: 'https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png', streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass3-p/main.m3u8', category: 'FIFA World Cup 2026', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'alkass-four', name: 'Alkass Four', logo: 'https://logovector.net/wp-content/uploads/2013/12/al-kass-sport-channel-logo-vector-2-163055.png', streamUrl: 'https://liveeu-gcp.alkassdigital.net/alkass4-p/main.m3u8', category: 'FIFA World Cup 2026', country: 'Qatar', language: 'Arabic'),
    Channel(id: 'bbc-one', name: 'BBC One', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/BBC_One_logo_2021.svg/960px-BBC_One_logo_2021.svg.png', streamUrl: 'http://a.files.bbci.co.uk/media/live/manifesto/audio_video/simulcast/hls/uk/hls_tablet/ak/bbc_one_london.m3u8', category: 'FIFA World Cup 2026', country: 'UK', language: 'English'),
    Channel(id: 'bbc-two', name: 'BBC Two', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/BBC_Two_logo_2021.svg/960px-BBC_Two_logo_2021.svg.png', streamUrl: 'http://a.files.bbci.co.uk/media/live/manifesto/audio_video/simulcast/hls/uk/hls_tablet/ak/bbc_two_england.m3u8', category: 'FIFA World Cup 2026', country: 'UK', language: 'English'),
    Channel(id: 'canal-sport', name: 'Canal+ Sport', logo: 'https://i.imgur.com/EOXnU15.png', streamUrl: 'http://151.80.18.177:86/Canal+_sport_HD/index.m3u8', category: 'FIFA World Cup 2026', country: 'France', language: 'French'),
    Channel(id: 'canal-foot', name: 'Canal+ Foot', logo: 'https://upload.wikimedia.org/wikipedia/commons/e/eb/Canal%2BFoot.png', streamUrl: 'https://test.946985.filegear-sg.me/proxy/ef3174f16d4557d2', category: 'FIFA World Cup 2026', country: 'France', language: 'French'),
    Channel(id: 'ard-erde', name: 'ARD (Das Erste)', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/ARD_Dachmarke_2014.svg/960px-ARD_Dachmarke_2014.svg.png', streamUrl: 'https://daserste-live.ard-mcdn.de/daserste/live/hls/int/master.m3u8', category: 'FIFA World Cup 2026', country: 'Germany', language: 'German'),
    Channel(id: 'telemundo-intl', name: 'Telemundo Internacional', logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Telemundo_logo_2018.svg/960px-Telemundo_logo_2018.svg.png', streamUrl: 'http://138.121.15.230:9002/TELEMUNDO/index.m3u8', category: 'FIFA World Cup 2026', country: 'USA', language: 'Spanish'),
    Channel(id: 'cctv-football', name: 'CCTV Storm Football', logo: 'https://i.imgur.com/Fy6HkX0.png', streamUrl: 'http://38.75.136.137:98/gslb/dsdqpub/fyzq.m3u8?auth=testpub', category: 'FIFA World Cup 2026', country: 'China', language: 'Chinese'),
  ];

  static final _countryCodeMap = {
    'AL': 'Albania', 'AD': 'Andorra', 'AR': 'Argentina', 'AM': 'Armenia',
    'AU': 'Australia', 'AT': 'Austria', 'AZ': 'Azerbaijan', 'BY': 'Belarus',
    'BE': 'Belgium', 'BA': 'Bosnia and Herzegovina', 'BR': 'Brazil',
    'BG': 'Bulgaria', 'CA': 'Canada', 'CL': 'Chile', 'CN': 'China',
    'CR': 'Costa Rica', 'HR': 'Croatia', 'CY': 'Cyprus', 'CZ': 'Czech Republic',
    'DK': 'Denmark', 'DO': 'Dominican Republic', 'EG': 'Egypt', 'EE': 'Estonia',
    'FI': 'Finland', 'FR': 'France', 'GE': 'Georgia', 'DE': 'Germany',
    'GR': 'Greece', 'HK': 'Hong Kong', 'HU': 'Hungary', 'IS': 'Iceland',
    'IN': 'India', 'ID': 'Indonesia', 'IR': 'Iran', 'IQ': 'Iraq',
    'IE': 'Ireland', 'IL': 'Israel', 'IT': 'Italy', 'JP': 'Japan',
    'KR': 'South Korea', 'LV': 'Latvia', 'LT': 'Lithuania', 'LU': 'Luxembourg',
    'MX': 'Mexico', 'MD': 'Moldova', 'MC': 'Monaco', 'ME': 'Montenegro',
    'NL': 'Netherlands', 'NO': 'Norway', 'PY': 'Paraguay', 'PE': 'Peru',
    'PL': 'Poland', 'PT': 'Portugal', 'QA': 'Qatar', 'RO': 'Romania',
    'RU': 'Russia', 'SA': 'Saudi Arabia', 'RS': 'Serbia', 'SK': 'Slovakia',
    'SI': 'Slovenia', 'ES': 'Spain', 'SE': 'Sweden', 'CH': 'Switzerland',
    'TW': 'Taiwan', 'TR': 'Turkey', 'GB': 'UK', 'UA': 'Ukraine',
    'AE': 'United Arab Emirates', 'US': 'USA', 'VE': 'Venezuela',
    'DZ': 'Algeria', 'AO': 'Angola', 'BJ': 'Benin', 'BW': 'Botswana',
    'BF': 'Burkina Faso', 'BI': 'Burundi', 'CM': 'Cameroon', 'CV': 'Cape Verde',
    'CF': 'Central African Republic', 'TD': 'Chad', 'CG': 'Congo',
    'CD': 'Democratic Republic of the Congo', 'DJ': 'Djibouti',
    'GQ': 'Equatorial Guinea', 'ER': 'Eritrea', 'SZ': 'Eswatini',
    'ET': 'Ethiopia', 'GA': 'Gabon', 'GM': 'Gambia', 'GH': 'Ghana',
    'GN': 'Guinea', 'GW': 'Guinea-Bissau', 'CI': 'Ivory Coast', 'KE': 'Kenya',
    'LS': 'Lesotho', 'LR': 'Liberia', 'LY': 'Libya', 'MG': 'Madagascar',
    'MW': 'Malawi', 'ML': 'Mali', 'MR': 'Mauritania', 'MU': 'Mauritius',
    'MA': 'Morocco', 'MZ': 'Mozambique', 'NA': 'Namibia', 'NE': 'Niger',
    'NG': 'Nigeria', 'RW': 'Rwanda', 'SN': 'Senegal', 'SC': 'Seychelles',
    'SL': 'Sierra Leone', 'SO': 'Somalia', 'ZA': 'South Africa',
    'SS': 'South Sudan', 'SD': 'Sudan', 'TZ': 'Tanzania', 'TG': 'Togo',
    'TN': 'Tunisia', 'UG': 'Uganda', 'ZM': 'Zambia', 'ZW': 'Zimbabwe',
  };

  static String _mapCountry(String code) => _countryCodeMap[code] ?? code;

  static String _mapCategory(String m3uGroup, String name) {
    final n = name.toLowerCase();
    final g = m3uGroup.toLowerCase();

    if (g.contains('sport') || n.contains('sport') || n.contains('football') ||
        n.contains('soccer') || n.contains('espn') || n.contains('bein') ||
        n.contains('sky sport') || n.contains('equidia')) {
      return 'Sports';
    }
    if (g == 'news' || g == 'news (ar)' || g == 'news (es)' ||
        n.contains('news') || n.contains('cnn') || n.contains('france info') ||
        n.contains('bfmtv') || n.contains('cnews') || n.contains('euronews') ||
        n.contains('al jazeera') || n.contains('i24') || n.contains('lci')) {
      return 'Actualités';
    }
    if (n.contains('music') || n.contains('mtv') || n.contains('mcm') ||
        n.contains('nrj') || n.contains('trace') || n.contains('radio') ||
        g.contains('music')) {
      return 'Musique';
    }
    if (g.contains('entertainment') || n.contains('tmc') || n.contains('w9') ||
        n.contains('tfx') || n.contains('nrj12') || n.contains('c8') ||
        n.contains('m6') || n.contains('tf1') || n.contains('france 2') ||
        n.contains('arte')) {
      return 'Divertissement';
    }
    return m3uGroup;
  }

  static Future<List<Channel>> _fetchFromApi() async {
    try {
      final response = await http.get(Uri.parse('$_apiBase/data/channels.json'));
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
    } catch (_) {}
    return [];
  }

  Future<List<Channel>> getChannels() async {
    // Try API first
    final apiChannels = await _fetchFromApi();
    if (apiChannels.isNotEmpty) {
      await _cacheChannels(apiChannels);
      return apiChannels;
    }

    // Fallback to cache
    final cached = await _loadCachedChannels();
    if (cached.isNotEmpty) return cached;

    // Fallback to guaranteed only
    return List<Channel>.from(guaranteedChannels);
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
