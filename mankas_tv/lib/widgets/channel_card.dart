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
    if (cat == 'Entertainment') return const Color(0xFFA855F7);
    if (cat == 'News') return const Color(0xFF3B82F6);
    return const Color(0xFF6366F1);
  }

  IconData _categoryIcon() {
    final cat = channel.category ?? '';
    if (cat.contains('World Cup') || cat.contains('FIFA')) return Icons.sports_soccer;
    if (cat == 'Sports') return Icons.sports;
    if (cat == 'Entertainment') return Icons.tv;
    if (cat == 'News') return Icons.public;
    return Icons.live_tv;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFF1E1E2E),
                child: channel.logo != null && channel.logo!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: channel.logo!,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => Center(
                          child: Icon(_categoryIcon(), size: 40, color: _categoryColor().withValues(alpha: 0.3)),
                        ),
                        errorWidget: (_, __, ___) => _buildFallback(),
                      )
                    : _buildFallback(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [channel.category, channel.country, channel.language]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(' / '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: OutlinedButton.icon(
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 12,
                        color: isFavorite ? Colors.redAccent : null,
                      ),
                      label: Text(
                        isFavorite ? 'Saved' : 'Favorite',
                        style: const TextStyle(fontSize: 10),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    final color = _categoryColor();
    return Center(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(_categoryIcon(), size: 28, color: color),
      ),
    );
  }
}
