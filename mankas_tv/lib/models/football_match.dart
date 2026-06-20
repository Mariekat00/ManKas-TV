class FootballMatch {
  final String id;
  final String homeTeamId;
  final String awayTeamId;
  final String homeTeamName;
  final String awayTeamName;
  final String homeScore;
  final String awayScore;
  final String homeScorers;
  final String awayScorers;
  final String group;
  final String matchday;
  final String localDate;
  final String finished;
  final String timeElapsed;
  final String type;

  const FootballMatch({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeScore,
    required this.awayScore,
    required this.homeScorers,
    required this.awayScorers,
    required this.group,
    required this.matchday,
    required this.localDate,
    required this.finished,
    required this.timeElapsed,
    required this.type,
  });

  bool get isLive =>
      timeElapsed != 'notstarted' &&
      timeElapsed != 'finished' &&
      finished != 'TRUE' &&
      finished != 'true';

  bool get isFinished => finished == 'TRUE' || finished == 'true';

  bool get hasStarted => timeElapsed != 'notstarted';

  String get datePart => localDate.split(' ').first;
  String get timePart => localDate.split(' ').length > 1 ? localDate.split(' ').last : '';

  String get statusLabel {
    if (isFinished) return 'Terminé';
    if (timeElapsed == 'HT') return 'Mi-temps';
    if (timeElapsed == 'notstarted') return 'À venir';
    if (timeElapsed == 'finished') return 'Terminé';
    return "$timeElapsed'";
  }

  String get roundLabel {
    switch (type) {
      case 'r32':
        return '⅛ de finale';
      case 'r16':
        return '¼ de finale';
      case 'qf':
        return '¼ de finale';
      case 'sf':
        return '½ finale';
      case 'third':
        return '3ème place';
      case 'final':
        return 'Finale';
      default:
        return 'Groupe $group';
    }
  }

  factory FootballMatch.fromJson(Map<String, dynamic> json) {
    return FootballMatch(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      homeTeamId: json['home_team_id']?.toString() ?? '',
      awayTeamId: json['away_team_id']?.toString() ?? '',
      homeTeamName: json['home_team_name_en']?.toString() ?? 'TBD',
      awayTeamName: json['away_team_name_en']?.toString() ?? 'TBD',
      homeScore: json['home_score']?.toString() ?? '0',
      awayScore: json['away_score']?.toString() ?? '0',
      homeScorers: json['home_scorers']?.toString() ?? '',
      awayScorers: json['away_scorers']?.toString() ?? '',
      group: json['group']?.toString() ?? '',
      matchday: json['matchday']?.toString() ?? '',
      localDate: json['local_date']?.toString() ?? '',
      finished: json['finished']?.toString() ?? 'FALSE',
      timeElapsed: json['time_elapsed']?.toString() ?? 'notstarted',
      type: json['type']?.toString() ?? 'group',
    );
  }
}

class FootballGroup {
  final String id;
  final String name;
  final List<FootballGroupTeam> teams;

  const FootballGroup({
    required this.id,
    required this.name,
    required this.teams,
  });

  factory FootballGroup.fromJson(Map<String, dynamic> json) {
    final teamsList = (json['teams'] as List<dynamic>?)
            ?.map((t) => FootballGroupTeam.fromJson(t as Map<String, dynamic>))
            .toList() ??
        [];
    return FootballGroup(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      teams: teamsList,
    );
  }
}

class FootballGroupTeam {
  final String teamId;
  final String teamName;
  final int played;
  final int win;
  final int draw;
  final int loss;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  const FootballGroupTeam({
    required this.teamId,
    required this.teamName,
    required this.played,
    required this.win,
    required this.draw,
    required this.loss,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  factory FootballGroupTeam.fromJson(Map<String, dynamic> json) {
    return FootballGroupTeam(
      teamId: (json['team_id'] ?? json['id'] ?? '').toString(),
      teamName: (json['team_name_en'] ?? '').toString(),
      played: _parseInt(json['mp'] ?? json['played']),
      win: _parseInt(json['w'] ?? json['win']),
      draw: _parseInt(json['d'] ?? json['draw']),
      loss: _parseInt(json['l'] ?? json['loss']),
      goalsFor: _parseInt(json['gf'] ?? json['goals_for']),
      goalsAgainst: _parseInt(json['ga'] ?? json['goals_against']),
      points: _parseInt(json['pts'] ?? json['points']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
