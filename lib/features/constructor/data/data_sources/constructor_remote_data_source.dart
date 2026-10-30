import 'package:dio/dio.dart';
import '../../../../common/network/load_exception.dart';
import '../dto/constructor_dto.dart';
import 'constructor_data_source.dart';

class ConstructorRemoteDataSource implements IConstructorDataSource {
  final Dio _dio;

  const ConstructorRemoteDataSource(this._dio);

  @override
  Future<List<ConstructorStandingDto>> getConstructorStandings({String? season}) async {
    try {
      final s = season ?? 'current';
      final response = await _dio.get('/$s/constructorStandings.json');
      if (response.data == null) {
        throw const NetworkLoadException();
      }
      final dto = ErgastConstructorResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return dto.standings;
    } on DioException {
      throw const NetworkLoadException();
    } catch (_) {
      throw const NetworkLoadException();
    }
  }

  @override
  Future<Map<String, dynamic>> getConstructorSeasonResults(
    String constructorId, {
    String? season,
  }) async {
    try {
      final s = season ?? 'current';
      final response = await _dio.get<Map<String, dynamic>>(
        '/$s/constructors/$constructorId/results.json',
        queryParameters: {'limit': 100},
      );
      return response.data ?? <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  @override
  Future<ConstructorStandingDto?> getConstructorStandingForSeason(
    String constructorId, {
    String? season,
  }) async {
    try {
      final s = season ?? 'current';
      final response = await _dio.get<Map<String, dynamic>>(
        '/$s/constructors/$constructorId/constructorStandings.json',
      );
      final data = response.data ?? <String, dynamic>{};
      final dto = ErgastConstructorResponseDto.fromJson(data);
      return dto.standings.firstOrNull;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> getConstructorCareerMilestones(
    String constructorId,
  ) async {
    try {
      final results = await Future.wait([
        _dio.get<Map<String, dynamic>>(
          '/constructors/$constructorId/results.json',
          queryParameters: {'limit': 1},
        ),
        _dio.get<Map<String, dynamic>>(
          '/constructors/$constructorId/constructorStandings/1.json',
        ),
      ]);

      return {
        'firstRace': results[0].data ?? <String, dynamic>{},
        'championships': results[1].data ?? <String, dynamic>{},
      };
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  @override
  Future<List<String>> getConstructorSeasons(String constructorId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/constructors/$constructorId/seasons.json',
        queryParameters: {'limit': 100},
      );
      final seasonTable = response.data?['MRData']?['SeasonTable'];
      final seasonsList = seasonTable?['Seasons'] as List<dynamic>? ?? [];
      final seasons = seasonsList
          .map((s) => s['season'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      seasons.sort((a, b) => b.compareTo(a));
      return seasons;
    } catch (_) {
      return [];
    }
  }
}