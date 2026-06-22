import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mankas_tv/services/channel_service.dart';

void main() {
  group('ChannelService', () {
    test('guaranteedChannels contains 17 entries', () {
      expect(ChannelService.guaranteedChannels.length, 17);
    });

    test('guaranteedChannels all have non-empty id', () {
      for (final ch in ChannelService.guaranteedChannels) {
        expect(ch.id.isNotEmpty, isTrue, reason: 'Channel ${ch.name} has empty id');
      }
    });

    test('guaranteedChannels all have non-empty streamUrl', () {
      for (final ch in ChannelService.guaranteedChannels) {
        expect(ch.streamUrl.isNotEmpty, isTrue, reason: 'Channel ${ch.name} has empty streamUrl');
      }
    });

    test('guaranteedChannels have valid streamUrl scheme', () {
      for (final ch in ChannelService.guaranteedChannels) {
        expect(ch.streamUrl.startsWith('http://') || ch.streamUrl.startsWith('https://'),
            isTrue, reason: 'Channel ${ch.name} URL: ${ch.streamUrl}');
      }
    });

    test('guaranteedChannels contains Real Madrid TV', () {
      final rmtv = ChannelService.guaranteedChannels.firstWhere((c) => c.id == 'rmtv');
      expect(rmtv.name, 'Real Madrid TV');
      expect(rmtv.category, 'Sports');
      expect(rmtv.country, 'Spain');
    });

    test('guaranteedChannels contains Alkass channels', () {
      final alkass = ChannelService.guaranteedChannels.where((c) => c.id.startsWith('alkass'));
      expect(alkass.length, 2);
      expect(alkass.every((c) => c.category == 'Sports'), isTrue);
    });

    test('no duplicate ids in guaranteedChannels', () {
      final ids = ChannelService.guaranteedChannels.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('getFavorites returns empty list when no favorites saved', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ChannelService();
      final favorites = await service.getFavorites();
      expect(favorites, isEmpty);
    });

    test('toggleFavorite adds and removes channel', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ChannelService();

      await service.toggleFavorite('rmtv');
      var favorites = await service.getFavorites();
      expect(favorites, ['rmtv']);

      await service.toggleFavorite('rmtv');
      favorites = await service.getFavorites();
      expect(favorites, isEmpty);
    });

    test('toggleFavorite handles multiple channels', () async {
      SharedPreferences.setMockInitialValues({});
      final service = ChannelService();

      await service.toggleFavorite('rmtv');
      await service.toggleFavorite('equidia');
      await service.toggleFavorite('cazetv');

      final favorites = await service.getFavorites();
      expect(favorites, ['rmtv', 'equidia', 'cazetv']);
    });

    test('getChannels returns guaranteedChannels when API fails', () async {
      final service = ChannelService();
      final channels = await service.getChannels();
      expect(channels.length, greaterThanOrEqualTo(17));
    });

    test('channels have category, country, language metadata', () {
      for (final ch in ChannelService.guaranteedChannels) {
        expect(ch.category, isNotNull, reason: '${ch.name} has null category');
        expect(ch.country, isNotNull, reason: '${ch.name} has null country');
        expect(ch.language, isNotNull, reason: '${ch.name} has null language');
      }
    });
  });
}
