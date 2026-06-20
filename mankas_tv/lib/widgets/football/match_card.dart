import 'package:flutter/material.dart';
import '../../models/football_match.dart';

String getTeamFlag(String teamName) {
  const flags = {
    'Mexico': '🇲🇽', 'South Korea': '🇰🇷', 'Czech Republic': '🇨🇿',
    'South Africa': '🇿🇦', 'Qatar': '🇶🇦', 'Switzerland': '🇨🇭',
    'Canada': '🇨🇦', 'Ivory Coast': '🇨🇮', 'Ecuador': '🇪🇨',
    'Germany': '🇩🇪', 'Paraguay': '🇵🇾', 'Australia': '🇦🇺',
    'Turkey': '🇹🇷', 'United States': '🇺🇸', 'Japan': '🇯🇵',
    'Sweden': '🇸🇪', 'Tunisia': '🇹🇳', 'Netherlands': '🇳🇱',
    'Senegal': '🇸🇳', 'Iraq': '🇮🇶', 'Norway': '🇳🇴', 'France': '🇫🇷',
    'Egypt': '🇪🇬', 'Iran': '🇮🇷', 'New Zealand': '🇳🇿', 'Belgium': '🇧🇪',
    'Saudi Arabia': '🇸🇦', 'Uruguay': '🇺🇾', 'Spain': '🇪🇸',
    'Panama': '🇵🇦', 'England': '🏴󠁧󠁢󠁥󠁮󠁧󠁿', 'Croatia': '🇭🇷', 'Ghana': '🇬🇭',
    'Algeria': '🇩🇿', 'Austria': '🇦🇹', 'Jordan': '🇯🇴', 'Argentina': '🇦🇷',
    'Colombia': '🇨🇴', 'Portugal': '🇵🇹', 'Morocco': '🇲🇦',
    'Cameroon': '🇨🇲', 'Serbia': '🇷🇸', 'Poland': '🇵🇱',
    'Brazil': '🇧🇷', 'Italy': '🇮🇹',
    'Scotland': '🏴󠁧󠁢󠁳󠁣󠁴󠁿', 'Denmark': '🇩🇰', 'Greece': '🇬🇷',
    'Romania': '🇷🇴', 'Hungary': '🇭🇺', 'Slovakia': '🇸🇰', 'Ukraine': '🇺🇦',
  };
  return flags[teamName] ?? '🏳️';
}

class MatchCard extends StatelessWidget {
  final FootballMatch match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final live = match.isLive;
    final hasScore = match.isFinished || match.hasStarted;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: live ? Colors.red.withValues(alpha: 0.4) : const Color(0xFF2A2A3E),
        ),
      ),
      color: live ? Colors.red.withValues(alpha: 0.05) : const Color(0xFF1E1E2E),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  match.roundLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: live
                        ? Colors.red.withValues(alpha: 0.15)
                        : match.isFinished
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (live) ...[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        match.statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: live
                              ? Colors.red
                              : match.isFinished
                                  ? Colors.white54
                                  : const Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(getTeamFlag(match.homeTeamName), style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          match.homeTeamName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                hasScore
                    ? Text(
                        '${match.homeScore} - ${match.awayScore}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      )
                    : Text(
                        '${match.datePart}\n${match.timePart}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          match.awayTeamName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(getTeamFlag(match.awayTeamName), style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
            if (match.homeScorers.isNotEmpty && match.homeScorers != 'null' ||
                match.awayScorers.isNotEmpty && match.awayScorers != 'null') ...[
              const Divider(height: 16, color: Color(0xFF2A2A3E)),
              if (match.homeScorers.isNotEmpty && match.homeScorers != 'null')
                _scorerLine(match.homeScorers),
              if (match.awayScorers.isNotEmpty && match.awayScorers != 'null')
                _scorerLine(match.awayScorers),
            ],
          ],
        ),
      ),
    );
  }

  Widget _scorerLine(String scorers) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text('⚽ ', style: const TextStyle(fontSize: 11)),
          Expanded(
            child: Text(
              scorers,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
