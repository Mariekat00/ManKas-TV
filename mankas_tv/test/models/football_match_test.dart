import 'package:flutter_test/flutter_test.dart';
import 'package:mankas_tv/models/football_match.dart';

void main() {
  group('FootballMatch', () {
    FootballMatch makeMatch({
      String id = 'm1',
      String homeTeamName = 'FC Barcelona',
      String awayTeamName = 'Real Madrid',
      String homeScore = '2',
      String awayScore = '1',
      String timeElapsed = '75',
      String finished = 'FALSE',
      String localDate = '2026-06-22 20:00',
      String type = 'final',
      String group = 'A',
    }) {
      return FootballMatch.fromJson({
        '_id': id,
        'home_team_name_en': homeTeamName,
        'away_team_name_en': awayTeamName,
        'home_score': homeScore,
        'away_score': awayScore,
        'time_elapsed': timeElapsed,
        'finished': finished,
        'local_date': localDate,
        'type': type,
        'group': group,
      });
    }

    test('fromJson parses full match correctly', () {
      final match = makeMatch();
      expect(match.id, 'm1');
      expect(match.homeTeamName, 'FC Barcelona');
      expect(match.awayTeamName, 'Real Madrid');
      expect(match.homeScore, '2');
      expect(match.awayScore, '1');
      expect(match.timeElapsed, '75');
      expect(match.finished, 'FALSE');
    });

    test('fromJson handles missing fields with defaults', () {
      final match = FootballMatch.fromJson({});
      expect(match.id, '');
      expect(match.homeTeamName, 'TBD');
      expect(match.awayTeamName, 'TBD');
      expect(match.homeScore, '0');
      expect(match.awayScore, '0');
      expect(match.timeElapsed, 'notstarted');
      expect(match.finished, 'FALSE');
      expect(match.localDate, '');
    });

    test('datePart returns date string from localDate', () {
      final match = makeMatch(localDate: '2026-06-22 20:00');
      expect(match.datePart, '2026-06-22');
    });

    test('timePart returns time string from localDate', () {
      final match = makeMatch(localDate: '2026-06-22 20:00');
      expect(match.timePart, '20:00');
    });

    test('timePart returns empty when no space in localDate', () {
      final match = makeMatch(localDate: '2026-06-22');
      expect(match.timePart, '');
    });

    test('datePart and timePart are cached (same instance)', () {
      final match = makeMatch();
      expect(match.datePart, match.datePart);
      expect(match.timePart, match.timePart);
    });

    test('isLive returns true for in-progress match', () {
      final match = makeMatch(timeElapsed: '30', finished: 'FALSE');
      expect(match.isLive, isTrue);
    });

    test('isLive returns false for notstarted', () {
      final match = makeMatch(timeElapsed: 'notstarted', finished: 'FALSE');
      expect(match.isLive, isFalse);
    });

    test('isLive returns false for finished', () {
      final match = makeMatch(timeElapsed: '90', finished: 'TRUE');
      expect(match.isLive, isFalse);
    });

    test('isFinished returns true when finished is TRUE', () {
      final match = makeMatch(finished: 'TRUE');
      expect(match.isFinished, isTrue);
    });

    test('isFinished returns false when finished is FALSE', () {
      final match = makeMatch(finished: 'FALSE');
      expect(match.isFinished, isFalse);
    });

    test('hasStarted returns false for notstarted', () {
      final match = makeMatch(timeElapsed: 'notstarted');
      expect(match.hasStarted, isFalse);
    });

    test('hasStarted returns true when match has started', () {
      final match = makeMatch(timeElapsed: '15');
      expect(match.hasStarted, isTrue);
    });

    test('statusLabel returns Terminé for finished', () {
      final match = makeMatch(finished: 'TRUE');
      expect(match.statusLabel, 'Terminé');
    });

    test('statusLabel returns Mi-temps for HT', () {
      final match = makeMatch(timeElapsed: 'HT', finished: 'FALSE');
      expect(match.statusLabel, 'Mi-temps');
    });

    test('statusLabel returns À venir for notstarted', () {
      final match = makeMatch(timeElapsed: 'notstarted');
      expect(match.statusLabel, 'À venir');
    });

    test('statusLabel returns minute for in-progress', () {
      final match = makeMatch(timeElapsed: '65', finished: 'FALSE');
      expect(match.statusLabel, "65'");
    });

    test('roundLabel returns Finale for final type', () {
      final match = makeMatch(type: 'final');
      expect(match.roundLabel, 'Finale');
    });

    test('roundLabel returns ½ finale for sf type', () {
      final match = makeMatch(type: 'sf');
      expect(match.roundLabel, '½ finale');
    });

    test('roundLabel returns ¼ de finale for qf type', () {
      final match = makeMatch(type: 'qf');
      expect(match.roundLabel, '¼ de finale');
    });

    test('roundLabel returns 3ème place for third type', () {
      final match = makeMatch(type: 'third');
      expect(match.roundLabel, '3ème place');
    });

    test('roundLabel returns group for group type', () {
      final match = makeMatch(type: 'group', group: 'A');
      expect(match.roundLabel, 'Groupe A');
    });
  });

  group('FootballGroup', () {
    test('fromJson parses with teams', () {
      final json = {
        'id': 'group-a',
        'name': 'Group A',
        'teams': [
          {'team_id': 't1', 'team_name_en': 'Team A', 'mp': '3', 'w': '2', 'd': '1', 'l': '0', 'gf': '5', 'ga': '2', 'pts': '7'},
        ],
      };
      final group = FootballGroup.fromJson(json);
      expect(group.id, 'group-a');
      expect(group.name, 'Group A');
      expect(group.teams.length, 1);
      expect(group.teams[0].teamName, 'Team A');
      expect(group.teams[0].played, 3);
      expect(group.teams[0].points, 7);
    });

    test('fromJson handles empty teams', () {
      final json = {'id': 'group-b', 'name': 'Group B'};
      final group = FootballGroup.fromJson(json);
      expect(group.id, 'group-b');
      expect(group.teams, isEmpty);
    });
  });

  group('FootballGroupTeam', () {
    test('fromJson parses all stats', () {
      final json = {
        'team_id': 't1',
        'team_name_en': 'Team A',
        'mp': '3',
        'w': '2',
        'd': '1',
        'l': '0',
        'gf': '8',
        'ga': '3',
        'pts': '7',
      };
      final team = FootballGroupTeam.fromJson(json);
      expect(team.teamId, 't1');
      expect(team.teamName, 'Team A');
      expect(team.played, 3);
      expect(team.win, 2);
      expect(team.draw, 1);
      expect(team.loss, 0);
      expect(team.goalsFor, 8);
      expect(team.goalsAgainst, 3);
      expect(team.points, 7);
    });

    test('fromJson uses alternative field names', () {
      final json = {
        'id': 't2',
        'team_name_en': 'Team B',
        'played': '4',
        'win': '1',
        'draw': '2',
        'loss': '1',
        'goals_for': '4',
        'goals_against': '4',
        'points': '5',
      };
      final team = FootballGroupTeam.fromJson(json);
      expect(team.teamId, 't2');
      expect(team.played, 4);
      expect(team.points, 5);
    });

    test('fromJson handles int values directly', () {
      final json = {
        'team_id': 't3',
        'team_name_en': 'Team C',
        'mp': 5,
        'w': 3,
        'd': 1,
        'l': 1,
        'gf': 10,
        'ga': 6,
        'pts': 10,
      };
      final team = FootballGroupTeam.fromJson(json);
      expect(team.played, 5);
      expect(team.win, 3);
      expect(team.points, 10);
    });
  });
}
