import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';
import '../screens/player_screen.dart';
import 'channel_card.dart';

class ChannelGrid extends StatelessWidget {
  const ChannelGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TvProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.filteredChannels.isEmpty) {
          return const Center(
            child: Text('Aucune chaîne ne correspond aux filtres.', style: TextStyle(color: Colors.white54)),
          );
        }

        final crossAxisCount = MediaQuery.of(context).size.width > 1200
            ? 6
            : MediaQuery.of(context).size.width > 800
                ? 4
                : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: provider.filteredChannels.length,
          itemBuilder: (context, index) {
            final channel = provider.filteredChannels[index];
            return ChannelCard(
              channel: channel,
              isFavorite: provider.isFavorite(channel.id),
              onTap: () {
                provider.setSelectedChannel(channel);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlayerScreen()),
                );
              },
              onFavoriteToggle: () => provider.toggleFavorite(channel.id),
            );
          },
        );
      },
    );
  }
}
