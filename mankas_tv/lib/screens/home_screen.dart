import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/football_match.dart';
import '../models/channel.dart';
import '../providers/tv_provider.dart';
import '../services/football_service.dart';
import '../utils/category_theme.dart';
import '../utils/app_strings.dart';
import '../services/match_notification_service.dart';
import '../widgets/animated_icons.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildMainButtons(theme),
            const SizedBox(height: 10),
            _buildM6LiveBanner(theme),
            const SizedBox(height: 10),
            _buildQuickAccess(theme),
            const SizedBox(height: 24),
            _buildSectionTitle('⚽ ${AppStrings.of(context).todaysMatches}', null, theme),
            const SizedBox(height: 12),
            _buildMatchesSection(theme),
            const SizedBox(height: 28),
            _buildSectionTitle('🔥 ${AppStrings.of(context).popularChannels}', null, theme),
            const SizedBox(height: 12),
            _buildPopularChannels(theme),
            const SizedBox(height: 28),
            _buildSectionTitle('📂 ${AppStrings.of(context).categories}', null, theme),
            const SizedBox(height: 12),
            _buildCategories(theme),
            const SizedBox(height: 28),
            _buildBanner(theme),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(180)],
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
                  color: theme.colorScheme.primary.withAlpha(200),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ManKas TV',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const Spacer(),
          Semantics(
            label: AppStrings.of(context).about,
            child: IconButton(
              icon: Icon(Icons.info_outline, size: 22, color: theme.colorScheme.onSurfaceVariant),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
              tooltip: AppStrings.of(context).about,
            ),
          ),
          Semantics(
            label: AppStrings.of(context).adminPanel,
            child: IconButton(
              icon: Icon(Icons.admin_panel_settings, size: 22, color: theme.colorScheme.onSurfaceVariant),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              ),
              tooltip: AppStrings.of(context).adminPanel,
            ),
          ),
        ],
      ),
    );
  }

  // ───────── MAIN BUTTONS ─────────
  Widget _buildMainButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _GradientButton(
              icon: Icons.tv,
              label: AppStrings.of(context).liveTV,
              gradient: [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(200)],
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
              label: AppStrings.of(context).liveMatches,
              gradient: [theme.colorScheme.error, theme.colorScheme.error.withAlpha(200)],
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

  // ───────── M6 LIVE BANNER ─────────
  Widget _buildM6LiveBanner(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          final provider = context.read<TvProvider>();
          final m6 = provider.channels.where(
            (c) => c.name.toLowerCase().contains('m6'),
          );
          if (m6.isNotEmpty) {
            provider.setSelectedChannel(m6.first);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.red.withAlpha(80)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'M6',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'EN DIRECT',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'M6 — TV en direct',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.of(context).liveTV,
                      style: TextStyle(
                        color: Colors.white.withAlpha(150),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Regarder',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── QUICK ACCESS ─────────
  Widget _buildQuickAccess(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _PillButton(
            icon: Icons.emoji_events,
            label: AppStrings.of(context).worldCup,
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFEC4899).withAlpha(30) : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? const Color(0xFFEC4899) : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        active ? Icons.favorite : Icons.favorite_border,
                        color: active ? const Color(0xFFEC4899) : theme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${AppStrings.of(context).favorites} (${provider.favorites.length})',
                        style: TextStyle(
                          color: active ? const Color(0xFFEC4899) : theme.colorScheme.onSurfaceVariant,
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
  Widget _buildSectionTitle(String title, String? action, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          if (action != null)
            Text(
              action,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  // ───────── MATCHS DU JOUR ─────────
  Widget _buildMatchesSection(ThemeData theme) {
    if (_matchesLoading) {
      return SizedBox(
        height: 120,
        child: Center(
          child: SpinningIcon(icon: Icons.refresh, size: 32, color: theme.colorScheme.primary),
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
              PulsingIcon(icon: Icons.sports_soccer, size: 36, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                AppStrings.of(context).noMatchesToday,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
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
        separatorBuilder: (_, _i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final match = _upcomingMatches[index];
          return _MatchCard(match: match);
        },
      ),
    );
  }

  // ───────── CHAÎNES POPULAIRES ─────────
  Widget _buildPopularChannels(ThemeData theme) {
    final popular = _getPopularChannels();
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: popular.length,
        separatorBuilder: (_, _i) => const SizedBox(width: 12),
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
      'M6',
      "L'Equipe",
      'Equidia',
      'BBC One',
      'BBC Two',
      'Alkass One',
      'Arryadia',
      'FTF Sports',
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

  Widget _buildCategories(ThemeData theme) {
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
  Widget _buildBanner(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              AppStrings.of(context).welcomeTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.of(context).welcomeDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onPrimary.withAlpha(200),
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
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  AppStrings.of(context).discoverChannels,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
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
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final isLive = match.isLive;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLive ? theme.colorScheme.error.withAlpha(100) : theme.colorScheme.surfaceContainerHighest,
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
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppStrings.of(context).live,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                )
              else
                Text(
                  match.timePart,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const Spacer(),
              Text(
                match.roundLabel,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          Text(
            match.homeTeamName,
            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                isLive ? '${match.homeScore} - ${match.awayScore}' : 'vs',
                style: TextStyle(
                  color: isLive ? theme.colorScheme.error : theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              if (isLive) ...[
                const SizedBox(width: 6),
                Text(
                  match.statusLabel,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 10),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            match.awayTeamName,
            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600, fontSize: 13),
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
    final theme = Theme.of(context);
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
          color: theme.colorScheme.surface,
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
                        errorBuilder: (_c, _e, _s) => Icon(
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
              style: TextStyle(
                color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);

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
          color: theme.colorScheme.surface,
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
              style: TextStyle(
                color: theme.colorScheme.onSurface,
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
