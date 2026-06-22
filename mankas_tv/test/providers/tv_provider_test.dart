import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mankas_tv/models/channel.dart';
import 'package:mankas_tv/providers/tv_provider.dart';
import 'package:mankas_tv/services/channel_service.dart';

List<Channel> _mockChannels() => [
      Channel(id: '1', name: 'Sport Channel', streamUrl: 'https://example.com/sport.m3u8', category: 'Sports', country: 'France', language: 'French'),
      Channel(id: '2', name: 'News Channel', streamUrl: 'https://example.com/news.m3u8', category: 'News', country: 'USA', language: 'English'),
      Channel(id: '3', name: 'Movie Channel', streamUrl: 'https://example.com/movie.m3u8', category: 'Movies', country: 'France', language: 'French'),
      Channel(id: '4', name: 'Music Channel', streamUrl: 'https://example.com/music.m3u8', country: 'UK', language: 'English'),
      Channel(id: '5', name: 'Arabic News', streamUrl: 'https://example.com/arabic.m3u8', category: 'News', country: 'Qatar', language: 'Arabic'),
      Channel(id: '6', name: 'French Sports 2', streamUrl: 'https://example.com/sport2.m3u8', category: 'Sports', country: 'France', language: 'French'),
      Channel(id: '7', name: 'UK General', streamUrl: 'https://example.com/uk.m3u8', category: 'Général', country: 'UK', language: 'English'),
      Channel(id: '8', name: 'No Category', streamUrl: 'https://example.com/nocat.m3u8', country: 'France', language: 'French'),
    ];

class MockChannelService extends ChannelService {
  final List<Channel> _channels;
  List<String> _favorites = [];

  MockChannelService(this._channels);

  @override
  Future<List<Channel>> getChannels() async => _channels;

  @override
  Future<List<String>> getFavorites() async => _favorites;

  @override
  Future<void> toggleFavorite(String channelId) async {
    if (_favorites.contains(channelId)) {
      _favorites.remove(channelId);
    } else {
      _favorites.add(channelId);
    }
  }
}

void main() {
  late TvProvider provider;
  late MockChannelService mockService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockService = MockChannelService(_mockChannels());
    provider = TvProvider(service: mockService);
  });

  group('TvProvider - channels', () {
    test('loadChannels populates channels list', () async {
      await provider.loadChannels();
      expect(provider.channels.length, 8);
    });

    test('loadChannels sets first channel as selected', () async {
      await provider.loadChannels();
      expect(provider.selectedChannel, isNotNull);
      expect(provider.selectedChannel!.id, '1');
    });

    test('loadChannels sets isLoading correctly', () async {
      expect(provider.isLoading, isTrue);
      await provider.loadChannels();
      expect(provider.isLoading, isFalse);
    });

    test('categories includes Général fallback for null category', () async {
      await provider.loadChannels();
      expect(provider.categories, contains('Général'));
      expect(provider.categories, contains('Sports'));
      expect(provider.categories, contains('News'));
    });

    test('countries returns unique countries', () async {
      await provider.loadChannels();
      expect(provider.countries, contains('France'));
      expect(provider.countries, contains('USA'));
      expect(provider.countries, contains('UK'));
    });
  });

  group('TvProvider - filtering', () {
    setUp(() async {
      await provider.loadChannels();
    });

    test('initial state shows all channels', () {
      expect(provider.filteredChannels.length, 8);
    });

    test('setQuery filters by name', () {
      provider.setQuery('Sport');
      expect(provider.filteredChannels.length, 2);
      expect(provider.filteredChannels.every((c) => c.name.contains('Sport')), isTrue);
    });

    test('setQuery filters by country', () {
      provider.setQuery('Qatar');
      expect(provider.filteredChannels.length, 1);
      expect(provider.filteredChannels.first.id, '5');
    });

    test('setQuery filters by language', () {
      provider.setQuery('Arabic');
      expect(provider.filteredChannels.length, 1);
      expect(provider.filteredChannels.first.id, '5');
    });

    test('setQuery is case insensitive', () {
      provider.setQuery('sport');
      expect(provider.filteredChannels.length, 2);
    });

    test('setQuery empty shows all channels', () {
      provider.setQuery('Sport');
      expect(provider.filteredChannels.length, 2);
      provider.setQuery('');
      expect(provider.filteredChannels.length, 8);
    });

    test('setQuery no match returns empty', () {
      provider.setQuery('xyznonexistent');
      expect(provider.filteredChannels, isEmpty);
    });

    test('setCategory filters by category', () {
      provider.setCategory('Sports');
      expect(provider.filteredChannels.length, 2);
      expect(provider.filteredChannels.every((c) => c.category == 'Sports'), isTrue);
    });

    test('setCategory Tout shows all', () {
      provider.setCategory('Sports');
      provider.setCategory('Tout');
      expect(provider.filteredChannels.length, 8);
    });

    test('setCountry filters by country', () {
      provider.setCountry('France');
      expect(provider.filteredChannels.length, 4);
    });

    test('setCountry Tout shows all', () {
      provider.setCountry('France');
      provider.setCountry('Tout');
      expect(provider.filteredChannels.length, 8);
    });

    test('combined filter: category + country', () {
      provider.setCategory('Sports');
      provider.setCountry('France');
      expect(provider.filteredChannels.length, 2);
      expect(provider.filteredChannels.every((c) => c.category == 'Sports' && c.country == 'France'), isTrue);
    });

    test('combined filter: search + category', () {
      provider.setQuery('Arabic');
      provider.setCategory('News');
      expect(provider.filteredChannels.length, 1);
      expect(provider.filteredChannels.first.id, '5');
    });

    test('search filters by country', () {
      provider.setQuery('UK');
      expect(provider.filteredChannels.length, 2);
    });
  });

  group('TvProvider - favorites', () {
    setUp(() async {
      await provider.loadChannels();
    });

    test('isFavorite returns false initially', () {
      expect(provider.isFavorite('1'), isFalse);
      expect(provider.isFavorite('2'), isFalse);
    });

    test('toggleFavorite adds a channel', () async {
      await provider.toggleFavorite('1');
      expect(provider.isFavorite('1'), isTrue);
    });

    test('toggleFavorite removes a channel', () async {
      await provider.toggleFavorite('1');
      expect(provider.isFavorite('1'), isTrue);
      await provider.toggleFavorite('1');
      expect(provider.isFavorite('1'), isFalse);
    });

    test('toggleFavoritesOnly shows no channels when no favorites', () {
      provider.toggleFavoritesOnly();
      expect(provider.showFavoritesOnly, isTrue);
      expect(provider.filteredChannels, isEmpty);
    });

    test('toggleFavoritesOnly shows only favorited channels', () async {
      await provider.toggleFavorite('1');
      await provider.toggleFavorite('3');
      provider.toggleFavoritesOnly();
      expect(provider.filteredChannels.length, 2);
      expect(provider.filteredChannels.map((c) => c.id), containsAll(['1', '3']));
    });

    test('setSelectedChannel updates selected channel', () {
      final ch = provider.channels[3];
      provider.setSelectedChannel(ch);
      expect(provider.selectedChannel, ch);
    });
  });

  group('TvProvider - edge cases', () {
    setUp(() async {
      await provider.loadChannels();
    });

    test('filtering with no results shows empty', () {
      provider.setCategory('Sports');
      provider.setCountry('UK');
      expect(provider.filteredChannels, isEmpty);
    });

    test('empty channels list after load handles gracefully', () async {
      final emptyService = MockChannelService([]);
      final emptyProvider = TvProvider(service: emptyService);
      await emptyProvider.loadChannels();
      expect(emptyProvider.channels, isEmpty);
      expect(emptyProvider.categories, isEmpty);
      expect(emptyProvider.countries, isEmpty);
    });
  });
}
