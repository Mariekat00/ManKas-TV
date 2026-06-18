import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';
import '../widgets/channel_filters.dart';
import '../widgets/channel_grid.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TvProvider>().loadChannels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.live_tv, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PUBLIC IPTV',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'ManKas TV',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.admin_panel_settings, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminScreen()),
                      );
                    },
                    tooltip: 'Admin',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Consumer<TvProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _metric('Channels', provider.channels.length),
                    const SizedBox(width: 8),
                    _metric('Countries', provider.countries.length),
                    const SizedBox(width: 8),
                    _metric('Categories', provider.categories.length),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const ChannelFilters(),
          const SizedBox(height: 4),
          const Expanded(child: ChannelGrid()),
        ],
      ),
    );
  }

  Widget _metric(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.5,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
