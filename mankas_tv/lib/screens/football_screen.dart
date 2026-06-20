import 'package:flutter/material.dart';
import '../models/football_match.dart';
import '../services/football_service.dart';
import '../widgets/football/match_card.dart';
import '../widgets/football/group_standings.dart';
import '../widgets/football/match_schedule.dart';

class FootballScreen extends StatefulWidget {
  const FootballScreen({super.key});

  @override
  State<FootballScreen> createState() => _FootballScreenState();
}

class _FootballScreenState extends State<FootballScreen> {
  List<FootballMatch> _matches = [];
  List<FootballGroup> _groups = [];
  bool _loading = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final matches = await FootballService.getMatches();
    final groups = await FootballService.getGroups();
    if (mounted) {
      setState(() {
        _matches = matches;
        _groups = groups;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      appBar: AppBar(
        title: const Row(
          children: [
            Text('⚽ ', style: TextStyle(fontSize: 20)),
            Text('FIFA World Cup 2026'),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _tabButton('Matchs du jour', 0),
                const SizedBox(width: 8),
                _tabButton('Classements', 1),
                const SizedBox(width: 8),
                _tabButton('Calendrier', 2),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
          : _buildContent(),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF2A2A3E),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildTodayTab();
      case 1:
        return GroupStandings(groups: _groups);
      case 2:
        return MatchSchedule(matches: _matches);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTodayTab() {
    final live = _matches.where((m) => m.isLive).toList();
    final now = DateTime.now();
    final todayStr =
        '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
    final today = _matches.where((m) => m.datePart == todayStr).toList();
    final upcoming = _matches
        .where((m) => !m.hasStarted)
        .toList()
      ..sort((a, b) => a.localDate.compareTo(b.localDate));
    final next8 = upcoming.take(8).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (live.isNotEmpty) ...[
            _sectionHeader('🔴 En direct', live.length),
            ...live.map((m) => MatchCard(match: m)),
            const SizedBox(height: 16),
          ],
          if (today.isNotEmpty) ...[
            _sectionHeader('Aujourd\'hui', today.length),
            ...today.map((m) => MatchCard(match: m)),
            const SizedBox(height: 16),
          ],
          if (live.isEmpty && today.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Aucun match en cours aujourd\'hui',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
              ),
            ),
          _sectionHeader('Prochains matchs', next8.length),
          ...next8.map((m) => MatchCard(match: m)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
