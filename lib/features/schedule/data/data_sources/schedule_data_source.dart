import '../dto/race_dto.dart';

abstract interface class IScheduleDataSource {
  Future<List<RaceDto>> getSeasonSchedule();
}