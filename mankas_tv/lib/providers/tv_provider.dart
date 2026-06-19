import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/channel_service.dart';

class TvProvider extends ChangeNotifier {
  final ChannelService _service = ChannelService();

  List<Channel> _channels = [];
  List<Channel> _filteredChannels = [];
  List<String> _favorites = [];
  Channel? _selectedChannel;
  String _query = '';
  String _category = 'All';
  String _country = 'All';
  bool _showFavoritesOnly = false;
  bool _isLoading = true;

  List<Channel> get channels => _channels;
  List<Channel> get filteredChannels => _filteredChannels;
  List<String> get favorites => _favorites;
  Channel? get selectedChannel => _selectedChannel;
  String get query => _query;
  String get category => _category;
  String get country => _country;
  bool get showFavoritesOnly => _showFavoritesOnly;
  bool get isLoading => _isLoading;

  Set<String> get categories => _channels.map((c) => c.category ?? 'General').toSet();
  Set<String> get countries => _channels.map((c) => c.country ?? 'Unknown').toSet();

  Future<void> loadChannels() async {
    _isLoading = true;
    notifyListeners();

    _channels = await _service.getChannels();
    _favorites = await _service.getFavorites();
    _applyFilters();

    if (_channels.isNotEmpty && _selectedChannel == null) {
      _selectedChannel = _channels.first;
    }

    _isLoading = false;
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
      final matchesCategory = _category == 'All' || ch.category == _category;
      final matchesCountry = _country == 'All' || ch.country == _country;
      final matchesFavorites = !_showFavoritesOnly || _favorites.contains(ch.id);
      return matchesSearch && matchesCategory && matchesCountry && matchesFavorites;
    }).toList();
  }
}
