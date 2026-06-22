import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/football_match.dart';

class FootballService {
  static const _baseUrl = 'https://worldcup26.ir';

  static Future<List<FootballMatch>> getMatches() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/get/games'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final games = data['games'] as List<dynamic>? ?? data as List<dynamic>;
        return games
            .map((g) => FootballMatch.fromJson(g as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('FootballService.getMatches failed: $e');
    }
    return [];
  }

  static Future<List<FootballGroup>> getGroups() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/get/groups'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final groups = data['groups'] as List<dynamic>? ?? data as List<dynamic>;
        return groups
            .map((g) => FootballGroup.fromJson(g as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('FootballService.getGroups failed: $e');
    }
    return [];
  }

  static Future<Map<String, String>> getTeamNames() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/get/teams'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final teams = data['teams'] as List<dynamic>? ?? data as List<dynamic>;
        final map = <String, String>{};
        for (final t in teams) {
          final id = (t['id'] ?? '').toString();
          final name = (t['name_en'] ?? '').toString();
          if (id.isNotEmpty && name.isNotEmpty) map[id] = name;
        }
        return map;
      }
    } catch (e) {
      debugPrint('FootballService.getTeamNames failed: $e');
    }
    return {};
  }
}
