import 'package:flutter/material.dart';
import '../../models/football_match.dart';
import 'match_card.dart';

class MatchSchedule extends StatelessWidget {
  final List<FootballMatch> matches;

  const MatchSchedule({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    final sorted = [...matches]..sort((a, b) => a.localDate.compareTo(b.localDate));

    final grouped = <String, List<FootballMatch>>{};
    for (final match in sorted) {
      final key = match.datePart;
      grouped.putIfAbsent(key, () => []).add(match);
    }

    final dates = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final dateMatches = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: index > 0 ? 8 : 0),
              child: Text(
                _formatDate(date),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(128),
                  letterSpacing: 1,
                ),
              ),
            ),
            ...dateMatches.map((match) => MatchCard(match: match)),
          ],
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length != 3) return dateStr;
    final month = int.tryParse(parts[0]) ?? 1;
    final day = int.tryParse(parts[1]) ?? 1;
    const months = <String>[
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
    ];
    return '$day ${months[month]} ${parts[2]}';
  }
}
