import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
import '../utils/category_theme.dart';
import '../utils/app_strings.dart';
import '../screens/player_screen.dart';


const int _pageSize = 50;

class ChannelGrid extends StatefulWidget {
  final List<Channel>? channelsOverride;

  const ChannelGrid({super.key, this.channelsOverride});

  @override
  State<ChannelGrid> createState() => _ChannelGridState();
}

class _ChannelGridState extends State<ChannelGrid> {
  int _visibleCount = _pageSize;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant ChannelGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channelsOverride != widget.channelsOverride) {
      _visibleCount = _pageSize;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() => _visibleCount += _pageSize);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<TvProvider>().loadChannels();
    setState(() => _visibleCount = _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TvProvider>();
    final channels = widget.channelsOverride ?? provider.filteredChannels;
    final isLoading = provider.isLoading;

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF6366F1)),
            const SizedBox(height: 16),
            Text(AppStrings.of(context).loading, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    if (channels.isEmpty) {
      final isSearch = provider.query.isNotEmpty;
      final isFav = provider.showFavoritesOnly;
      final isCategory = provider.category != 'Tout';
      final isCountry = provider.country != 'Tout';
      String message;
      if (isSearch) {
        message = 'No channels match "${provider.query}".';
      } else if (isFav) {
        message = AppStrings.of(context).noFavorites;
      } else if (isCategory || isCountry) {
        message = 'No channels for this filter. Try another category or region.';
      } else {
        message = AppStrings.of(context).noChannels;
      }
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.live_tv_outlined, size: 48, color: Colors.white24),
                      const SizedBox(height: 16),
                      Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 16)),
                      if (isFav || isSearch || isCategory || isCountry) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            provider.setQuery('');
                            provider.setCategory('Tout');
                            provider.setCountry('Tout');
                            if (isFav) provider.toggleFavoritesOnly();
                          },
                          child: Text(AppStrings.of(context).resetFilters),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final visibleChannels = channels.take(_visibleCount).toList();
    final hasMore = _visibleCount < channels.length;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: visibleChannels.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == visibleChannels.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6366F1))),
            );
          }
          final channel = visibleChannels[index];
          final color = categoryColor(channel.category);

          return GestureDetector(
            onTap: () {
              provider.setSelectedChannel(channel);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlayerScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF252540),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(categoryIcon(channel.category), color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          channel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [channel.category, channel.country, channel.language]
                              .where((e) => e != null && e.isNotEmpty)
                              .join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    provider.isFavorite(channel.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 20,
                    color: provider.isFavorite(channel.id)
                        ? Colors.redAccent
                        : Colors.white38,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
