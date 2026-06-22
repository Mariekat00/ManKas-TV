import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';
import '../widgets/channel_filters.dart';
import '../widgets/channel_grid.dart';
import '../widgets/offline_banner.dart';
import '../widgets/network_quality_indicator.dart';
import '../utils/app_strings.dart';

class IptvScreen extends StatefulWidget {
  const IptvScreen({super.key});

  @override
  State<IptvScreen> createState() => _IptvScreenState();
}

class _IptvScreenState extends State<IptvScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11111B),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    AppStrings.of(context).liveTV,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Consumer<TvProvider>(
                    builder: (context, provider, _) {
                      return Row(
                        children: [
                          _metric(AppStrings.of(context).liveTV, provider.channels.length),
                          const SizedBox(width: 6),
                          _metric(AppStrings.of(context).countries, provider.countries.length),
                          const SizedBox(width: 6),
                          _metric(AppStrings.of(context).categories, provider.categories.length),
                          const SizedBox(width: 8),
                          const NetworkQualityIndicator(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const ChannelFilters(),
          const SizedBox(height: 4),
          const OfflineBanner(),
          const Expanded(child: ChannelGrid()),
        ],
      ),
    );
  }

  Widget _metric(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 8, letterSpacing: 1, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
