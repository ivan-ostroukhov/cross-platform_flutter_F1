import 'package:dio/dio.dart';
import '../../../../common/network/load_exception.dart';
import '../dto/race_dto.dart';
import 'schedule_data_source.dart';

class ScheduleRemoteDataSource implements IScheduleDataSource {
  final Dio _dio;

  const ScheduleRemoteDataSource(this._dio);

  @override
  Future<List<RaceDto>> getSeasonSchedule() async {
    try {
      final response = await _dio.get('/current.json');
      if (response.data == null) {
        throw const NetworkLoadException();
      }
      final dto = ErgastRaceResponseDto.fromJson(response.data as Map<String, dynamic>);
      return dto.races;
    } on DioException {
      throw const NetworkLoadException();
    } catch (_) {
      throw const NetworkLoadException();
    }
  }
}