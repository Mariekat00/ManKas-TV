import 'package:flutter/material.dart';
import '../../models/football_match.dart';
import '../../utils/app_strings.dart';

class GroupStandings extends StatelessWidget {
  final List<FootballGroup> groups;
  final Map<String, String> teamNames;

  const GroupStandings({super.key, required this.groups, this.teamNames = const {}});

  String _getName(String teamId) => teamNames[teamId] ?? 'Team #$teamId';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final primary = theme.colorScheme.primary;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        final sortedTeams = [...group.teams]
          ..sort((a, b) => b.points.compareTo(a.points));

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.surface.withAlpha(178)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withAlpha(178),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Text(
                  '${AppStrings.of(context).group} ${group.name}',
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
                  columns: [
                    const DataColumn(label: Text('#', style: TextStyle(fontSize: 11))),
                    DataColumn(label: Text(AppStrings.of(context).team, style: const TextStyle(fontSize: 11))),
                    DataColumn(label: Text(AppStrings.of(context).played, style: const TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text(AppStrings.of(context).drawn, style: const TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text(AppStrings.of(context).lost, style: const TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text(AppStrings.of(context).goalsFor, style: const TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text(AppStrings.of(context).goalsAgainst, style: const TextStyle(fontSize: 11)), numeric: true),
                    DataColumn(label: Text(AppStrings.of(context).points, style: const TextStyle(fontSize: 11)), numeric: true),
                  ],
                  rows: List.generate(sortedTeams.length, (i) {
                    final team = sortedTeams[i];
                    return DataRow(
                      color: WidgetStateProperty.resolveWith((states) {
                        if (i < 2) return primary.withAlpha(13);
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
