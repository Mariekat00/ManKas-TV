import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TvProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF6366F1)),
                SizedBox(height: 16),
                Text('Chargement...', style: TextStyle(color: Colors.white54)),
              ],
            ),
          );
        }

        final channels = widget.channelsOverride ?? provider.filteredChannels;

        if (channels.isEmpty) {
          return const Center(
            child: Text('Aucune chaîne trouvée.', style: TextStyle(color: Colors.white54, fontSize: 16)),
          );
        }

        final visibleChannels = channels.take(_visibleCount).toList();
        final hasMore = _visibleCount < channels.length;

        return ListView.builder(
          controller: _scrollController,
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
            final color = _catColor(channel.category);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    provider.setSelectedChannel(channel);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlayerScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
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
                          child: Icon(_catIcon(channel.category), color: color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        IconButton(
                          icon: Icon(
                            provider.isFavorite(channel.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: provider.isFavorite(channel.id)
                                ? Colors.redAccent
                                : Colors.white38,
                          ),
                          onPressed: () => provider.toggleFavorite(channel.id),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Color _catColor(String? cat) {
    if (cat == null) return const Color(0xFF6366F1);
    if (cat.contains('Sports') || cat.contains('FIFA')) return const Color(0xFF22C55E);
    if (cat.contains('Actualités') || cat.contains('News')) return const Color(0xFF3B82F6);
    if (cat.contains('Musique') || cat.contains('Music')) return const Color(0xFFEC4899);
    if (cat.contains('Divertissement')) return const Color(0xFFA855F7);
    return const Color(0xFF6366F1);
  }

  static IconData _catIcon(String? cat) {
    if (cat == null) return Icons.live_tv;
    if (cat.contains('Sports') || cat.contains('FIFA')) return Icons.sports_soccer;
    if (cat.contains('Actualités') || cat.contains('News')) return Icons.public;
    if (cat.contains('Musique') || cat.contains('Music')) return Icons.music_note;
    if (cat.contains('Divertissement')) return Icons.tv;
    return Icons.live_tv;
  }
}
