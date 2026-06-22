import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/channel_service.dart';
import '../services/streamfree_service.dart';

class TvProvider extends ChangeNotifier {
  final ChannelService _service;

  List<Channel> _channels = [];
  List<Channel> _filteredChannels = [];
  List<Channel> _streamFreeChannels = [];
  List<String> _favorites = [];
  List<String> _recentSearches = [];
  Channel? _selectedChannel;
  String _query = '';
  String _category = 'Tout';
  String _country = 'Tout';
  bool _showFavoritesOnly = false;
  bool _isLoading = true;
  bool _isLoadingStreamFree = false;

  static const _maxRecentSearches = 5;

  TvProvider({ChannelService? service}) : _service = service ?? ChannelService();

  List<Channel> get channels => _channels;
  List<Channel> get filteredChannels => _filteredChannels;
  List<Channel> get streamFreeChannels => _streamFreeChannels;
  List<String> get favorites => _favorites;
  List<String> get recentSearches => _recentSearches;
  Channel? get selectedChannel => _selectedChannel;
  String get query => _query;
  String get category => _category;
  String get country => _country;
  bool get showFavoritesOnly => _showFavoritesOnly;
  bool get isLoading => _isLoading;
  bool get isLoadingStreamFree => _isLoadingStreamFree;

  Set<String> get categories => _channels.map((c) => c.category ?? 'Général').toSet();
  Set<String> get countries => _channels.map((c) => c.country ?? 'Inconnu').toSet();

  Future<void> loadChannels() async {
    _isLoading = true;
    notifyListeners();

    _channels = await _service.getChannels();
    _favorites = await _service.getFavorites();
    _recentSearches = await _service.getRecentSearches();
    _applyFilters();

    if (_channels.isNotEmpty && _selectedChannel == null) {
      _selectedChannel = _channels.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadStreamFree() async {
    _isLoadingStreamFree = true;
    notifyListeners();

    _streamFreeChannels = await StreamFreeService.fetchLiveStreams();

    _isLoadingStreamFree = false;
    notifyListeners();
  }

  void setSelectedChannel(Channel channel) {
    _selectedChannel = channel;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    _applyFilters();
    notifyListeners();
  }

  Future<void> submitQuery(String value) async {
    _query = value;
    _applyFilters();
    if (value.isNotEmpty) {
      _recentSearches.remove(value);
      _recentSearches.insert(0, value);
      if (_recentSearches.length > _maxRecentSearches) {
        _recentSearches = _recentSearches.sublist(0, _maxRecentSearches);
      }
      await _service.saveRecentSearches(_recentSearches);
    }
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    _recentSearches = [];
    await _service.saveRecentSearches(_recentSearches);
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    _applyFilters();
    notifyListeners();
  }

  void setCountry(String value) {
    _country = value;
    _applyFilters();
    notifyListeners();
  }

  void toggleFavoritesOnly() {
    _showFavoritesOnly = !_showFavoritesOnly;
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleFavorite(String channelId) async {
    await _service.toggleFavorite(channelId);
    _favorites = await _service.getFavorites();
    notifyListeners();
  }

  bool isFavorite(String channelId) => _favorites.contains(channelId);

  void _applyFilters() {
    final q = _query.toLowerCase();
    _filteredChannels = _channels.where((ch) {
      final matchesSearch = q.isEmpty ||
          ch.name.toLowerCase().contains(q) ||
          (ch.country?.toLowerCase().contains(q) ?? false) ||
          (ch.language?.toLowerCase().contains(q) ?? false);
      final matchesCategory = _category == 'Tout' || (ch.category ?? 'Général') == _category;
      final matchesCountry = _country == 'Tout' || ch.country == _country;
      final matchesFavorites = !_showFavoritesOnly || _favorites.contains(ch.id);
      return matchesSearch && matchesCategory && matchesCountry && matchesFavorites;
    }).toList();
  }
}
