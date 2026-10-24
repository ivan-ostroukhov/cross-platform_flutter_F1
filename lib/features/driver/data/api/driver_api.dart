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
      'current/driverStandings.json',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return ErgastStandingsResponseDto.fromJson(response.data!);
  }
  
  Future<ErgastStandingsResponseDto> getDriverStandingById(String driverId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'current/drivers/$driverId/driverStandings.json',
    );
    return ErgastStandingsResponseDto.fromJson(response.data!);
  }
}