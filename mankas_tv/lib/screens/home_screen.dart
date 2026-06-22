import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/football_match.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
import '../services/football_service.dart';
import '../utils/category_theme.dart';
import '../utils/app_strings.dart';
import '../services/match_notification_service.dart';
import 'about_screen.dart';
import 'admin_screen.dart';
import 'football_screen.dart';
import 'iptv_screen.dart';
import 'live_matches_screen.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FootballMatch> _upcomingMatches = [];
  bool _matchesLoading = true;
  List<_CountedCat>? _cachedCounted;
  int _channelVersion = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TvProvider>().loadChannels();
      _loadMatches();
    });
  }

  Future<void> _loadMatches() async {
    final matches = await FootballService.getMatches();
    if (!mounted) return;

    final upcoming = matches
        .where((m) => !m.hasStarted && !m.isFinished)
        .toList()
      ..sort((a, b) => a.localDate.compareTo(b.localDate));

    setState(() {
      _upcomingMatches = upcoming.take(6).toList();
      _matchesLoading = false;
    });

    await MatchNotificationService().init();
    await MatchNotificationService().scheduleMatchReminders(matches);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildMainButtons(),
            const SizedBox(height: 10),
            _buildQuickAccess(),
            const SizedBox(height: 24),
            _buildSectionTitle('⚽ Today\'s Matches', null),
            const SizedBox(height: 12),
            _buildMatchesSection(),
            const SizedBox(height: 28),
            _buildSectionTitle('🔥 Popular Channels', null),
            const SizedBox(height: 12),
            _buildPopularChannels(),
            const SizedBox(height: 28),
            _buildSectionTitle('📂 ${AppStrings.of(context).categories}', null),
            const SizedBox(height: 12),
            _buildCategories(),
            const SizedBox(height: 28),
            _buildBanner(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.live_tv, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IPTV PUBLIC',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: const Color(0xFF6366F1).withAlpha(200),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'ManKas TV',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.info_outline, size: 22, color: Colors.white60),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
            tooltip: AppStrings.of(context).about,
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, size: 22, color: Colors.white60),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminScreen()),
            ),
            tooltip: 'Admin',
          ),
        ],
      ),
    );
  }

  // ───────── MAIN BUTTONS ─────────
  Widget _buildMainButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _GradientButton(
              icon: Icons.tv,
              label: AppStrings.of(context).liveTV,
              gradient: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IptvScreen()),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _GradientButton(
              icon: Icons.sports_soccer,
              label: 'Live Matches',
              gradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveMatchesScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── QUICK ACCESS ─────────
  Widget _buildQuickAccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _PillButton(
            icon: Icons.emoji_events,
            label: 'World Cup',
            color: const Color(0xFFF59E0B),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FootballScreen()),
            ),
          ),
          const SizedBox(width: 8),
          Consumer<TvProvider>(
            builder: (context, provider, _) {
              final active = provider.showFavoritesOnly;
              return GestureDetector(
                onTap: () {
                  provider.toggleFavoritesOnly();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IptvScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFEC4899).withAlpha(30) : const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFFEC4899) : const Color(0xFF2A2A3E),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? Icons.favorite : Icons.favorite_border,
                        color: active ? const Color(0xFFEC4899) : Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${AppStrings.of(context).favorites} (${provider.favorites.length})',
                        style: TextStyle(
                          color: active ? const Color(0xFFEC4899) : Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ───────── SECTION TITLE ─────────
  Widget _buildSectionTitle(String title, String? action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          if (action != null)
            Text(
              action,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
              ),
            ),
        ],
      ),
    );
  }

  // ───────── MATCHS DU JOUR ─────────
  Widget _buildMatchesSection() {
    if (_matchesLoading) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1), strokeWidth: 2),
        ),
      );
    }

    if (_upcomingMatches.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sports_soccer, size: 36, color: Colors.white.withAlpha(40)),
              const SizedBox(height: 8),
              Text(
                'No upcoming matches',
                style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _upcomingMatches.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final match = _upcomingMatches[index];
          return _MatchCard(match: match);
        },
      ),
    );
  }

  // ───────── CHAÎNES POPULAIRES ─────────
  Widget _buildPopularChannels() {
    final popular = _getPopularChannels();
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: popular.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final ch = popular[index];
          return _PopularChannelCard(channel: ch);
        },
      ),
    );
  }

  List<Channel> _getPopularChannels() {
    final provider = context.read<TvProvider>();
    final channels = provider.channels;
    if (channels.isEmpty) return [];

    final popularNames = [
      'Real Madrid TV',
      "L'Equipe",
      'Equidia',
      'BBC One',
      'BBC Two',
      'Alkass One',
      'Arryadia',
      'FTF Sports',
      'beIN Sports XTRA',
      'Telemundo NY',
      'Gol Classics',
      'Canal+ Sport',
    ];

    final result = <Channel>[];
    for (final name in popularNames) {
      final match = channels.where(
        (c) => c.name.toLowerCase().contains(name.toLowerCase()),
      );
      if (match.isNotEmpty) result.add(match.first);
      if (result.length >= 8) break;
    }

    if (result.isEmpty && channels.isNotEmpty) {
      result.addAll(channels.take(8));
    }

    return result;
  }

  // ───────── CATÉGORIES ─────────
  static const _catTemplates = [
    _CatData('Sport', '⚽', Color(0xFF22C55E), 'Sports'),
    _CatData('Actualités', '📰', Color(0xFF3B82F6), 'Actualités'),
    _CatData('Musique', '🎵', Color(0xFFEC4899), 'Musique'),
    _CatData('Cinéma', '🎬', Color(0xFFA855F7), 'Cinéma'),
    _CatData('Afrique', '🌍', Color(0xFFF59E0B), 'Afrique'),
    _CatData('Religion', '🙏', Color(0xFF06B6D4), 'Religion'),
    _CatData('Jeunesse', '👶', Color(0xFF10B981), 'Jeunesse'),
    _CatData('Documentaires', '📚', Color(0xFF8B5CF6), 'Documentaire'),
  ];

  List<_CountedCat> _computeCounts(List<Channel> channels) {
    return _catTemplates.map((cat) {
      final count = channels.where((ch) {
        final c = (ch.category ?? '').toLowerCase();
        return c.contains(cat.filter.toLowerCase()) ||
            cat.filter.toLowerCase().contains(c);
      }).length;
      return _CountedCat(cat: cat, count: count);
    }).toList();
  }

  Widget _buildCategories() {
    final provider = context.read<TvProvider>();
    final channels = provider.channels;
    final version = channels.length * 31 + channels.fold<int>(0, (sum, ch) => sum + (ch.category?.hashCode ?? 0));

    if (_cachedCounted == null || version != _channelVersion) {
      _cachedCounted = _computeCounts(channels);
      _channelVersion = version;
    }

    final counted = _cachedCounted!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: counted.length,
        itemBuilder: (context, index) {
          final item = counted[index];
          return _CategoryCard(data: item.cat, count: item.count);
        },
      ),
    );
  }

  // ───────── BANNIÈRE ─────────
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Text(
              'Welcome to ManKas TV',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Watch the best free public IPTV channels from around the world.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withAlpha(200),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IptvScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Discover channels',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  WIDGETS PRIVÉS
// ═══════════════════════════════════════════

class _GradientButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _GradientButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF151525),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final FootballMatch match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isLive = match.isLive;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151525),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLive ? const Color(0xFFEF4444).withAlpha(100) : const Color(0xFF2A2A3E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                )
              else
                Text(
                  match.timePart,
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const Spacer(),
              Text(
                match.roundLabel,
                style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          Text(
            match.homeTeamName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                isLive ? '${match.homeScore} - ${match.awayScore}' : 'vs',
                style: TextStyle(
                  color: isLive ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              if (isLive) ...[
                const SizedBox(width: 6),
                Text(
                  match.statusLabel,
                  style: const TextStyle(color: Color(0xFFEF4444), fontSize: 10),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            match.awayTeamName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PopularChannelCard extends StatelessWidget {
  final Channel channel;

  const _PopularChannelCard({required this.channel});

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColor(channel.category);

    return GestureDetector(
      onTap: () {
        context.read<TvProvider>().setSelectedChannel(channel);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerScreen()),
        );
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: catColor.withAlpha(40)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: catColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: channel.logo != null && channel.logo!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        channel.logo!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          categoryIcon(channel.category),
                          color: catColor,
                          size: 22,
                        ),
                      ),
                    )
                  : Icon(categoryIcon(channel.category), color: catColor, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              channel.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _CategoryCard extends StatelessWidget {
  final _CatData data;
  final int count;

  const _CategoryCard({required this.data, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final provider = context.read<TvProvider>();
        provider.setCategory(data.filter);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IptvScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF151525),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: data.color.withAlpha(40)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              data.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              '$count',
              style: TextStyle(
                color: data.color.withAlpha(180),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatData {
  final String name;
  final String emoji;
  final Color color;
  final String filter;

  const _CatData(this.name, this.emoji, this.color, this.filter);
}

class _CountedCat {
  final _CatData cat;
  final int count;

  const _CountedCat({required this.cat, required this.count});
}


