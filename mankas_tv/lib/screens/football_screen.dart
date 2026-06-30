import 'package:flutter/material.dart';
import '../models/football_match.dart';
import '../services/football_service.dart';
import '../widgets/football/match_card.dart';
import '../widgets/football/group_standings.dart';
import '../widgets/football/match_schedule.dart';
import '../utils/app_strings.dart';
import '../core/widgets/app_state_page.dart';

class FootballScreen extends StatefulWidget {
  const FootballScreen({super.key});

  @override
  State<FootballScreen> createState() => _FootballScreenState();
}

class _FootballScreenState extends State<FootballScreen> {
  List<FootballMatch> _matches = [];
  List<FootballGroup> _groups = [];
  Map<String, String> _teamNames = {};
  bool _loading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      FootballService.getMatches(),
      FootballService.getGroups(),
      FootballService.getTeamNames(),
    ]);
    if (mounted) {
      setState(() {
        _matches = results[0] as List<FootballMatch>;
        _groups = results[1] as List<FootballGroup>;
        _teamNames = results[2] as Map<String, String>;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('⚽ ', style: TextStyle(fontSize: 20)),
            Text(AppStrings.of(context).worldCup),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _tabButton(AppStrings.of(context).todayMatches, 0, theme),
                const SizedBox(width: 8),
                _tabButton(AppStrings.of(context).standings, 1, theme),
                const SizedBox(width: 8),
                _tabButton(AppStrings.of(context).schedule, 2, theme),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? AppStatePage(
              icon: Icons.refresh_rounded,
              iconColor: theme.colorScheme.primary,
              title: AppStrings.of(context).loading,
              description: '${AppStrings.of(context).football}...',
            )
          : _buildContent(theme),
    );
  }

  Widget _tabButton(String label, int index, ThemeData theme) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (_selectedTab) {
      case 0:
        return _buildMatchesTab(theme);
      case 1:
        return _buildStandingsTab(theme);
      case 2:
        return _buildScheduleTab(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMatchesTab(ThemeData theme) {
    final now = DateTime.now();
    final today = _matches.where((m) {
      try {
        final dateStr = m.datePart;
        final parts = dateStr.split('-');
        if (parts.length < 3) return false;
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);
        return year == now.year && month == now.month && day == now.day;
      } catch (_) {
        return false;
      }
    }).toList();

    if (today.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadData,
        child: AppStatePage(
          icon: Icons.sports_soccer_rounded,
          iconColor: theme.colorScheme.primary,
          title: AppStrings.of(context).noMatchesToday,
          description: AppStrings.of(context).upcomingMatches,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: today.length,
        itemBuilder: (context, index) => MatchCard(match: today[index]),
      ),
    );
  }

  Widget _buildStandingsTab(ThemeData theme) {
    if (_groups.isEmpty) {
      return AppStatePage(
        icon: Icons.leaderboard_rounded,
        iconColor: theme.colorScheme.primary,
        title: AppStrings.of(context).standings,
        description: AppStrings.of(context).loading,
      );
    }

    return GroupStandings(groups: _groups, teamNames: _teamNames);
  }

  Widget _buildScheduleTab(ThemeData theme) {
    return MatchSchedule(matches: _matches);
  }
}
