import 'package:dio/dio.dart';
import '../dto/driver_dto.dart';

class DriverApi {
  final Dio _dio;

  const DriverApi(this._dio);

  Future<ErgastStandingsResponseDto> getStandings({
    int limit = 30,
    int offset = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/current/driverStandings.json',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return ErgastStandingsResponseDto.fromJson(response.data!);
  }

  Future<ErgastStandingsResponseDto> getDriverStandingById(String driverId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/current/drivers/$driverId/driverStandings.json',
    );
    return ErgastStandingsResponseDto.fromJson(response.data!);
  }

  Future<Map<String, dynamic>> getDriverSeasonResults(String driverId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/current/drivers/$driverId/results.json',
        queryParameters: {'limit': 30},
      );
      return response.data ?? <String, dynamic>{};
    } catch (_) {
      try {
        final fallback = await _dio.get<Map<String, dynamic>>(
          '/drivers/$driverId/results.json',
          queryParameters: {'limit': 30},
        );
        return fallback.data ?? <String, dynamic>{};
      } catch (_) {
        return <String, dynamic>{};
      }
    }
  }

  Future<Map<String, dynamic>> getDriverFirstRace(String driverId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/drivers/$driverId/results.json',
        queryParameters: {'limit': 1},
      );
      return response.data ?? <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getDriverFirstWin(String driverId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/drivers/$driverId/results/1.json',
        queryParameters: {'limit': 1},
      );
      return response.data ?? <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<Map<String, dynamic>> getDriverChampionships(String driverId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/drivers/$driverId/driverStandings/1.json',
      );
      return response.data ?? <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}