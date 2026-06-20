import 'package:flutter/material.dart';
import '../../models/football_match.dart';

class GroupStandings extends StatelessWidget {
  final List<FootballGroup> groups;
  final Map<String, String> teamNames;

  const GroupStandings({super.key, required this.groups, this.teamNames = const {}});

  String _getName(String teamId) => teamNames[teamId] ?? 'Team #$teamId';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final sortedTeams = [...group.teams]
          ..sort((a, b) => b.points.compareTo(a.points));

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2A2A3E)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF252538),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Text(
                  'Groupe ${group.name}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 32,
                  dataRowMinHeight: 36,
          dataRowMaxHeight: 36,
                  columns: const [
                    DataColumn(label: Text('#', style: TextStyle(fontSize: 11))),
                    DataColumn(label: Text('Équipe', style: TextStyle(fontSize: 11))),
                    DataColumn(label: Text('MJ', style: TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text('N', style: TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text('P', style: TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text('BP', style: TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text('BC', style: TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text('Pts', style: TextStyle(fontSize: 11)), numeric: true),
                  ],
                  rows: List.generate(sortedTeams.length, (i) {
                    final team = sortedTeams[i];
                    return DataRow(
                      color: WidgetStateProperty.resolveWith((states) {
                        if (i < 2) return const Color(0xFF6366F1).withValues(alpha: 0.05);
                        return null;
                      }),
                      cells: [
                        DataCell(Text('${i + 1}', style: const TextStyle(fontSize: 12, color: Colors.white54))),
                        DataCell(Text(_getName(team.teamId), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                        DataCell(Text('${team.played}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${team.win}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${team.draw}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${team.goalsFor}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${team.goalsAgainst}', style: const TextStyle(fontSize: 12))),
                        DataCell(Text('${team.points}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
