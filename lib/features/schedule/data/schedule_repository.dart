import '../domain/schedule_repository.dart';
import '../domain/race_model.dart';
import 'data_sources/schedule_data_source.dart';
import 'mappers/race_mapper.dart';

class ScheduleRepository implements IScheduleRepository {
  final IScheduleDataSource _dataSource;

  const ScheduleRepository(this._dataSource);

  @override
  Future<List<RaceModel>> getSeasonSchedule() async {
    final dtos = await _dataSource.getSeasonSchedule();
    return dtos.toDomainList();
  }
}