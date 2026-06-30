import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
import '../utils/category_theme.dart';
import '../utils/app_strings.dart';
import '../screens/player_screen.dart';
import '../core/widgets/app_state_page.dart';


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
      return AppStatePage(
        icon: Icons.refresh_rounded,
        title: AppStrings.of(context).loading,
        description: AppStrings.of(context).loadingStream,
      );
    }

    if (channels.isEmpty) {
      final isSearch = provider.query.isNotEmpty;
      final isFav = provider.showFavoritesOnly;
      final isCategory = provider.category != AppStrings.of(context).all;
      final isCountry = provider.country != AppStrings.of(context).all;

      String title;
      String description;
      IconData icon;
      Color? iconColor;

      if (isSearch) {
        title = AppStrings.of(context).noResults;
        description = '${AppStrings.of(context).noResults} "${provider.query}".';
        icon = Icons.search_off_rounded;
        iconColor = Theme.of(context).colorScheme.primary;
      } else if (isFav) {
        title = AppStrings.of(context).favorites;
        description = AppStrings.of(context).noFavorites;
        icon = Icons.favorite_border_rounded;
        iconColor = const Color(0xFFEC4899);
      } else if (isCategory || isCountry) {
        title = AppStrings.of(context).noResults;
        description = AppStrings.of(context).noChannelsForFilter;
        icon = Icons.filter_list_off_rounded;
        iconColor = Theme.of(context).colorScheme.primary;
      } else {
        title = AppStrings.of(context).liveTV;
        description = AppStrings.of(context).noChannels;
        icon = Icons.tv_off_rounded;
        iconColor = Theme.of(context).colorScheme.error;
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: AppStatePage(
          icon: icon,
          iconColor: iconColor,
          title: title,
          description: description,
          actions: [
            if (isFav || isSearch || isCategory || isCountry)
              AppStateAction(
                label: AppStrings.of(context).resetFilters,
                onPressed: () {
                  provider.setQuery('');
                  provider.setCategory(AppStrings.of(context).all);
                  provider.setCountry(AppStrings.of(context).all);
                  if (isFav) provider.toggleFavoritesOnly();
                },
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
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Semantics(
                    label: provider.isFavorite(channel.id)
                        ? AppStrings.of(context).removeFromFavorites
                        : AppStrings.of(context).addToFavorites,
                    child: IconButton(
                      icon: Icon(
                        provider.isFavorite(channel.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: provider.isFavorite(channel.id)
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => provider.toggleFavorite(channel.id),
                    ),
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
