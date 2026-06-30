import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../utils/app_strings.dart';

class AdminStatisticsScreen extends StatefulWidget {
  const AdminStatisticsScreen({super.key});

  @override
  State<AdminStatisticsScreen> createState() => _AdminStatisticsScreenState();
}

class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
  final AdminService _admin = AdminService();
  bool _isLoading = true;
  String? _error;

  int _channelCount = 0;
  int _favoriteCount = 0;
  List<MapEntry<String, int>> _byCategory = [];
  List<MapEntry<String, int>> _byCountry = [];
  List<MapEntry<String, int>> _byLanguage = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final results = await Future.wait([
        _admin.getChannelCount(),
        _admin.getFavoriteCount(),
        _admin.getChannelsByCategory(),
        _admin.getChannelsByCountry(),
        _admin.getChannelsByLanguage(),
      ]);
      if (mounted) {
        setState(() {
          _channelCount = results[0] as int;
          _favoriteCount = results[1] as int;
          _byCategory = results[2] as List<MapEntry<String, int>>;
          _byCountry = results[3] as List<MapEntry<String, int>>;
          _byLanguage = results[4] as List<MapEntry<String, int>>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).statistics),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadStats();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: _loadStats, child: Text(AppStrings.of(context).retry)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadStats,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Overview cards
                      Row(
                        children: [
                          Expanded(child: _StatCard(
                            icon: Icons.tv,
                            label: AppStrings.of(context).channels,
                            value: '$_channelCount',
                            color: theme.colorScheme.primary,
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _StatCard(
                            icon: Icons.favorite,
                            label: AppStrings.of(context).favorites,
                            value: '$_favoriteCount',
                            color: theme.colorScheme.error,
                          )),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // By Category
                      _sectionHeader(AppStrings.of(context).categories),
                      const SizedBox(height: 8),
                      ..._byCategory.map((e) => _StatBar(
                        label: e.key,
                        count: e.value,
                        total: _channelCount,
                        color: theme.colorScheme.primary,
                      )),
                      const SizedBox(height: 24),

                      // By Country
                      _sectionHeader(AppStrings.of(context).countries),
                      const SizedBox(height: 8),
                      ..._byCountry.map((e) => _StatBar(
                        label: e.key,
                        count: e.value,
                        total: _channelCount,
                        color: theme.colorScheme.tertiary,
                      )),
                      const SizedBox(height: 24),

                      // By Language
                      _sectionHeader('Langues'),
                      const SizedBox(height: 8),
                      ..._byLanguage.map((e) => _StatBar(
                        label: e.key,
                        count: e.value,
                        total: _channelCount,
                        color: theme.colorScheme.secondary,
                      )),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.surface.withAlpha(178)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Theme.of(context).colorScheme.surface,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text('$count', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
