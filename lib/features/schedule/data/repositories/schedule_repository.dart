import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/race_model.dart';

class ScheduleRepository {
  final http.Client _client;

  static const List<String> _baseUrls = [
    'https://api.jolpi.ca/ergast/f1',
    'https://corsproxy.io/?https://api.jolpi.ca/ergast/f1',
    'https://api.allorigins.win/raw?url=https://api.jolpi.ca/ergast/f1',
  ];

  static const Map<String, String> _headers = {
    'Accept': 'application/json',
    'Connection': 'keep-alive',
    'User-Agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
  };

  ScheduleRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> _fetchWithFallback(String path, {int retries = 2}) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      for (final base in _baseUrls) {
        final url = '$base$path';
        try {
          final uri = Uri.parse(url);
          final response = await _client
              .get(uri, headers: _headers)
              .timeout(const Duration(seconds: 7));

          if (response.statusCode == 200) {
            return jsonDecode(response.body);
          }
        } catch (_) {
          continue;
        }
      }
      if (attempt < retries) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    throw Exception('Failed to load schedule from API');
  }

  Future<List<RaceModel>> getSeasonSchedule() async {
    final scheduleData = await _fetchWithFallback('/current.json?limit=50');
    final raceListJson =
        scheduleData['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];

    if (raceListJson.isEmpty) {
      throw Exception('Races list is empty');
    }

    final Map<String, List<PodiumDriver>> podiumMap = {};

    try {
      final responses = await Future.wait([
        _fetchWithFallback('/current/results.json?limit=100&offset=0', retries: 1),
        _fetchWithFallback('/current/results.json?limit=100&offset=100', retries: 1),
        _fetchWithFallback('/current/results.json?limit=100&offset=200', retries: 1),
        _fetchWithFallback('/current/results.json?limit=100&offset=300', retries: 1),
        _fetchWithFallback('/current/results.json?limit=100&offset=400', retries: 1),
      ]);

      for (final data in responses) {
        final races =
            data['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];
        for (final race in races) {
          final round = race['round']?.toString() ?? '';
          final results = race['Results'] as List<dynamic>? ?? [];
          if (results.isNotEmpty && !podiumMap.containsKey(round)) {
            final top3 =
            results.take(3).map((r) => PodiumDriver.fromJson(r)).toList();
            podiumMap[round] = top3;
          }
        }
      }
    } catch (_) {}

    return raceListJson.map((json) {
      final round = json['round']?.toString() ?? '';
      return RaceModel.fromJson(json, podium: podiumMap[round]);
    }).toList();
  }
}