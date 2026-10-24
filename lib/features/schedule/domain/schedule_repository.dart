import 'race_model.dart';

abstract interface class IScheduleRepository {
  Future<List<RaceModel>> getSeasonSchedule();
}