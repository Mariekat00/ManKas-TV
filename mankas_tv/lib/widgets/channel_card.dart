import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/channel.dart';

class ChannelCard extends StatelessWidget {
  final Channel channel;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ChannelCard({
    super.key,
    required this.channel,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  Color _categoryColor() {
    final cat = channel.category ?? '';
    if (cat.contains('World Cup') || cat.contains('FIFA')) return const Color(0xFFD4AF37);
    if (cat == 'Sports') return const Color(0xFF22C55E);
    if (cat == 'Divertissement') return const Color(0xFFA855F7);
    if (cat == 'Actualités') return const Color(0xFF3B82F6);
    if (cat == 'Musique') return const Color(0xFFEC4899);
    return const Color(0xFF6366F1);
  }

  IconData _categoryIcon() {
    final cat = channel.category ?? '';
    if (cat.contains('World Cup') || cat.contains('FIFA')) return Icons.sports_soccer;
    if (cat == 'Sports') return Icons.sports;
    if (cat == 'Divertissement') return Icons.tv;
    if (cat == 'Actualités') return Icons.public;
    if (cat == 'Musique') return Icons.music_note;
    return Icons.live_tv;
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(77), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFF12121F),
                child: channel.logo != null && channel.logo!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: channel.logo!,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => _buildFallback(color),
                        errorWidget: (_, __, ___) => _buildFallback(color),
                      )
                    : _buildFallback(color),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      channel.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(51),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        [channel.category, channel.country]
                            .where((e) => e != null && e.isNotEmpty)
                            .join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 9, color: color),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 14,
                          color: isFavorite ? Colors.redAccent : Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            channel.language ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: Colors.white38),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback(Color color) {
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withAlpha(51),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(_categoryIcon(), size: 28, color: color),
      ),
    );
  }
}
