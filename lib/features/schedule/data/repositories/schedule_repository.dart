import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../common/network/dio_client.dart';
import '../../../../common/network/local_storage_service.dart';
import '../../domain/models/race_model.dart';

class ScheduleRepository {
  final Dio _dio;

  ScheduleRepository({Dio? dio}) : _dio = dio ?? DioClient.create();

  Future<dynamic> _fetchWithFallback(String path) async {
    final response = await _dio.get<dynamic>(
      path,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
        },
      ),
    );
    return response.data;
  }

  Map<String, PodiumDriver> _parsePositionResults(dynamic data) {
    final Map<String, PodiumDriver> map = {};
    if (data is Map<String, dynamic>) {
      final races =
          data['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];
      for (final race in races) {
        final round = race['round']?.toString() ?? '';
        final results = race['Results'] as List<dynamic>? ?? [];
        if (results.isNotEmpty && round.isNotEmpty) {
          final resObj = results.first;
          if (resObj is Map<String, dynamic>) {
            map[round] = PodiumDriver.fromJson(resObj);
          }
        }
      }
    }
    return map;
  }

  Future<List<RaceModel>> getSeasonSchedule() async {
    final scheduleData = await _fetchWithFallback('/current.json?limit=50');
    final raceListJson =
        scheduleData['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];

    if (raceListJson.isEmpty) {
      throw Exception('Races list is empty');
    }

    final Map<String, List<PodiumDriver>> podiumMap = {};

    for (int r = 1; r <= 24; r++) {
      final roundStr = r.toString();
      final cached = LocalStorageService.getString('podium_$roundStr');
      if (cached != null && cached.isNotEmpty) {
        try {
          final listJson = jsonDecode(cached) as List<dynamic>;
          podiumMap[roundStr] =
              listJson.map((e) => PodiumDriver.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
    }

    try {
      final responses = await Future.wait([
        _fetchWithFallback('/current/results/1.json'),
        _fetchWithFallback('/current/results/2.json'),
        _fetchWithFallback('/current/results/3.json'),
      ]);

      final p1Map = _parsePositionResults(responses[0]);
      final p2Map = _parsePositionResults(responses[1]);
      final p3Map = _parsePositionResults(responses[2]);

      final allRounds = <String>{
        ...p1Map.keys,
        ...p2Map.keys,
        ...p3Map.keys,
      };

      for (final round in allRounds) {
        final list = <PodiumDriver>[];
        if (p1Map.containsKey(round)) list.add(p1Map[round]!);
        if (p2Map.containsKey(round)) list.add(p2Map[round]!);
        if (p3Map.containsKey(round)) list.add(p3Map[round]!);

        if (list.isNotEmpty) {
          podiumMap[round] = list;
          LocalStorageService.setString(
            'podium_$round',
            jsonEncode(list.map((d) => {
              'code': d.code,
              'teamName': d.teamName,
              'position': d.position,
            }).toList()),
          );
        }
      }
    } catch (_) {}

    return raceListJson.map((json) {
      final round = json['round']?.toString() ?? '';
      return RaceModel.fromJson(json, podium: podiumMap[round]);
    }).toList();
  }

  Future<List<PodiumDriver>> getPodiumForRound(String round) async {
    final cached = LocalStorageService.getString('podium_$round');
    if (cached != null && cached.isNotEmpty) {
      try {
        final listJson = jsonDecode(cached) as List<dynamic>;
        return listJson
            .map((e) => PodiumDriver.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    try {
      final data = await _fetchWithFallback('/current/$round/results.json');
      if (data is Map<String, dynamic>) {
        final races =
            data['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];
        if (races.isNotEmpty) {
          final results = races.first['Results'] as List<dynamic>? ?? [];
          final top3 =
              results.take(3).map((r) => PodiumDriver.fromJson(r)).toList();
          if (top3.isNotEmpty) {
            LocalStorageService.setString(
              'podium_$round',
              jsonEncode(top3.map((d) => {
                'code': d.code,
                'teamName': d.teamName,
                'position': d.position,
              }).toList()),
            );
          }
          return top3;
        }
      }
    } catch (_) {}
    return [];
  }
}